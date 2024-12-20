import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:superhorn/utils/services/bluetooth_service.dart';

class BluetoothNotifier extends StateNotifier<List<BluetoothDevice>> {
  BluetoothNotifier(this._service) : super([]);

  late BluetoothConnection _connection;

  final FlutterBluetoothSerial bluetoothSerial = FlutterBluetoothSerial.instance;
  final BluetoothServiceClass _service;

  /// Fetch connected devices (paired devices in this case)
  Future<void> getConnectedDevices() async {
    try {
      List<BluetoothDevice> pairedDevices = await bluetoothSerial.getBondedDevices();
      state = pairedDevices;
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching connected devices: $e");
      }
    }
  }



  Future<void> requestPermissions() async {
    if (await Permission.bluetoothScan.isGranted &&
        await Permission.bluetoothConnect.isGranted &&
        await Permission.location.isGranted) {
      print("All required permissions granted.");
    } else {
      await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.location
      ].request();
    }
  }


  /// Start scanning for Bluetooth devices
  void scanForDevices() {

    requestPermissions();

    bluetoothSerial.startDiscovery().listen((BluetoothDiscoveryResult result) {
      final existingDevices = state;
      final device = result.device;

      // Avoid duplicates
      if (!existingDevices.any((d) => d.address == device.address)) {

        if(device.name!=null && device.name!="null") {
          state = [...existingDevices, device];
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
  }

  /// Stop scanning for devices (not directly supported by flutter_bluetooth_serial)
  Future<void> stopScanning() async {
    bluetoothSerial.cancelDiscovery();
    if (kDebugMode) {
      print("Scanning canceled.");
    }
  }

  /// Connect to a specific device
  Future<void> connectToDevice(BluetoothDevice device  ) async {

    disconnectDevice(device);

    try {


      final connection = await BluetoothConnection.toAddress(device.address);
      connection.input!.listen((_){
        print('Received data: ${String.fromCharCodes(_)}');

      });


      if (kDebugMode) {
        print('Connected to the device: ${device.name}');
      }
      // Handle connection logic or stream if required
    } catch (e) {
      if (kDebugMode) {
        print("Error connecting to device: ${device.name} (${device.address}) - $e");
      }
    }
  }

  /// Disconnect from a specific device
  Future<void> disconnectDevice(BluetoothDevice device) async {
    // flutter_bluetooth_serial does not keep a direct connection list, so manage manually
    try {
      // Close connections if you manage them in `_service`
      await _service.disconnectDevice(device);
      if (kDebugMode) {
        print('Disconnected from the device: ${device.name}');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error disconnecting from device: ${device.name} (${device.address}) - $e");
      }
    }
  }
}

final bluetoothNotifierProvider =
StateNotifierProvider<BluetoothNotifier, List<BluetoothDevice>>((ref) {
  final service = ref.read(bluetoothServiceProvider);
  return BluetoothNotifier(service);
});
