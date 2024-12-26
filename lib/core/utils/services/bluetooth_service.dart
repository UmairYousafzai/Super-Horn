import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:superhorn/domain/entities/connectable_device.dart';

class BluetoothServiceClass {
  final FlutterBluetoothSerial bluetoothSerial =
      FlutterBluetoothSerial.instance;
  BluetoothConnection? _connection;

  /// Stream of connected (bonded) devices
  Stream<List<BluetoothDevice>> get connectedDevices async* {
    try {
      final bondedDevices = await bluetoothSerial.getBondedDevices();
      yield bondedDevices;
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching connected devices: $e");
      }
      yield [];
    }
  }

  Future<void> ensureBluetoothIsOn(void Function(bool) statusCallBack) async {
    // Check if Bluetooth is enabled
    bool isEnabled = await FlutterBluetoothSerial.instance.isEnabled ?? false;

    if (!isEnabled) {
      // Request to enable Bluetooth
      bool? isNowEnabled =
          await FlutterBluetoothSerial.instance.requestEnable();

      if (isNowEnabled == true) {
        statusCallBack(true);
        if (kDebugMode) {
          print("Bluetooth has been enabled.");
        }
      } else {
        statusCallBack(false);

        if (kDebugMode) {
          print("Bluetooth is still disabled.");
        }
      }
    } else {
      statusCallBack(true);
      if (kDebugMode) {
        print("Bluetooth is already enabled.");
      }
    }
  }

  /// Start scanning for devices
  Stream<List<BluetoothDiscoveryResult>> startScan() async* {
    try {
      final scanStream = bluetoothSerial.startDiscovery();
      await for (final result in scanStream) {
        yield [result]; // Emit results as they are discovered
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error during device scanning: $e");
      }
      yield [];
    }
  }

  /// Stop scanning for devices
  Future<void> stopScan() async {
    try {
      bluetoothSerial.cancelDiscovery();
    } catch (e) {
      if (kDebugMode) {
        print("Error stopping device discovery: $e");
      }
    }
  }

  /// Connect to a Bluetooth device
  Future<void> connectToDevice(
      ConnectableDevice device, void Function(bool) successCallBack) async {
    try {
      if (kDebugMode) {
        print('Connecting to device: ${device.deviceName}');
      }
      _connection?.close();
      Future.delayed(const Duration(seconds: 2));
      _connection = await BluetoothConnection.toAddress(device.deviceAddress);
      if (kDebugMode) {
        print('Connected to the device: ${device.deviceName}');
      }
      successCallBack(true);
    } catch (e) {
      if (kDebugMode) {
        print(
            "Error connecting to device: ${device.deviceName} (${device.deviceAddress}) - $e");
      }
      successCallBack(false);
    }
  }

  /// Disconnect from a Bluetooth device
  Future<void> disconnectDevice(ConnectableDevice device) async {
    try {
      // flutter_bluetooth_serial does not track active connections, so this depends on your app's logic
      if (kDebugMode) {
        print('Disconnected from device: ${device.deviceName}');
      }
      // Implement custom disconnection logic if needed
    } catch (e) {
      if (kDebugMode) {
        print(
            "Error disconnecting from device: ${device.deviceName} (${device.deviceAddress}) - $e");
      }
    }
  }

  void sendData(String data, void Function(bool) callBack) {
    print('Connection state: ${_connection!.isConnected}');

    if (_connection != null && _connection!.isConnected) {
      _connection!.output.add(Uint8List.fromList(data.codeUnits));
      print('Data being sent: $data');

      _connection!.output.allSent.then((_) {
        callBack(true);
        if (kDebugMode) {
          print('Data sent successfully.');
        }
      });
    } else {
      callBack(false);

      if (kDebugMode) {
        print('No connection established.');
      }
    }
  }
}

final bluetoothServiceProvider = Provider<BluetoothServiceClass>((ref) {
  return BluetoothServiceClass();
});
