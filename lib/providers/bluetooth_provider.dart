import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:superhorn/domain/entities/connectable_device.dart';
import 'package:superhorn/domain/entities/states/bluetooth_connectivity_state.dart';

import '../core/utils/services/bluetooth_service.dart';

class BluetoothNotifier extends StateNotifier<BluetoothConnectivityState> {
  BluetoothNotifier(this._service)
      : super(BluetoothConnectivityState(
          devices: [],
          isPermissionGranted: false,
          isDeviceConnected: false,
          errorMessage: "",
          successMessage: "",
        ));

  final FlutterBluetoothSerial bluetoothSerial =
      FlutterBluetoothSerial.instance;
  final BluetoothServiceClass _service;

  Future<void> requestPermissions() async {
    if (await Permission.bluetoothScan.isGranted &&
        await Permission.bluetoothConnect.isGranted &&
        await Permission.location.isGranted) {
      if (kDebugMode) {
        print("All required permissions granted.");
      }
    } else {
      await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.location
      ].request();
    }
  }

  /// Start scanning for Bluetooth devices
  void scanForDevices() async {
    await requestPermissions();

    isBlueToothTurnOn((isOn) {
      if (isOn) {
        bluetoothSerial
            .startDiscovery()
            .listen((BluetoothDiscoveryResult result) {
          final existingDevices = state.devices;
          final device = result.device;

          // Avoid duplicates
          if (!existingDevices.any((d) => d.deviceAddress == device.address)) {
            if (device.name != null && device.name != "null") {
              ConnectableDevice connectableDevice = ConnectableDevice(
                  deviceName: device.name,
                  deviceAddress: device.address,
                  isConnecting: false,
                  isConnected: device.isConnected);
              print("connectable device ====> ${connectableDevice.deviceName}");
              state = state
                  .copyWith(devices: [...existingDevices, connectableDevice]);
            }
          }

          if (kDebugMode) {
            print("Discovered device: ${device.name} (${device.address})");
          }
        }).onDone(() {
          if (kDebugMode) {
            print("Discovery complete.");
          }
        });
      } else {
        setError("Bluetooth is off");
      }
    });
  }

  /// Stop scanning for devices (not directly supported by flutter_bluetooth_serial)
  Future<void> stopScanning() async {
    bluetoothSerial.cancelDiscovery();
    if (kDebugMode) {
      print("Scanning canceled.");
    }
  }

  /// Connect to a specific device
  Future<void> connectToDevice(ConnectableDevice device) async {
     await disconnectDevice(device);

    try {
      _service.connectToDevice(device, (flag) {
        if (flag) {
          state = state.copyWith(isDeviceConnected: true);
        } else {
          setError("Connection Failed");
        }
      });

      // Handle connection logic or stream if required
    } catch (e) {
      setError("Connection Failed");

      if (kDebugMode) {
        print(
            "Error connecting to device: ${device.deviceName} (${device.deviceAddress}) - $e");
      }
    }
  }

  /// Disconnect from a specific device
  Future<void> disconnectDevice(ConnectableDevice device) async {
    // flutter_bluetooth_serial does not keep a direct connection list, so manage manually
    try {
      // Close connections if you manage them in `_service`
      await _service.disconnectDevice(device);
      if (kDebugMode) {
        print('Disconnected from the device: ${device.deviceName}');
      }
    } catch (e) {
      if (kDebugMode) {
        print(
            "Error disconnecting from device: ${device.deviceName} (${device.deviceAddress}) - $e");
      }
    }
  }

  Future<void> sendData(String data) async {
    _service.sendData(data, (flag) {
      if (flag) {
        setSuccess("Sent");
      } else {
        setError("Data not sent");
      }
    });
  }

  void isBlueToothTurnOn(void Function(bool) statusCallBack) {
    _service.ensureBluetoothIsOn((message) {
      statusCallBack(message);
    });
  }

  void setError(String message) {
    state = state.copyWith(errorMessage: message);
  }

  void setSuccess(String message) {
    state = state.copyWith(successMessage: message);
  }

  void resetState() {
    state = BluetoothConnectivityState(
        devices: [],
        isDeviceConnected: false,
        errorMessage: "",
        successMessage: "",
        isPermissionGranted: false);
  }
}

final bluetoothNotifierProvider =
    StateNotifierProvider<BluetoothNotifier, BluetoothConnectivityState>((ref) {
  final service = ref.read(bluetoothServiceProvider);
  return BluetoothNotifier(service);
});
