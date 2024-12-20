import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BluetoothServiceClass {
  final FlutterBluetoothSerial bluetoothSerial = FlutterBluetoothSerial.instance;

  /// Stream of connected (bonded) devices
  Stream<List<BluetoothDevice>> get connectedDevices async* {
    try {
      final bondedDevices = await bluetoothSerial.getBondedDevices();
      yield bondedDevices;
    } catch (e) {
      print("Error fetching connected devices: $e");
      yield [];
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
      print("Error during device scanning: $e");
      yield [];
    }
  }

  /// Stop scanning for devices
  Future<void> stopScan() async {
    try {
      bluetoothSerial.cancelDiscovery();
    } catch (e) {
      print("Error stopping device discovery: $e");
    }
  }

  /// Connect to a Bluetooth device
  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      final connection = await BluetoothConnection.toAddress(device.address);
      print('Connected to the device: ${device.name}');
      // Handle connection logic (e.g., communication or streaming data)
    } catch (e) {
      print("Error connecting to device: ${device.name} (${device.address}) - $e");
    }
  }

  /// Disconnect from a Bluetooth device
  Future<void> disconnectDevice(BluetoothDevice device) async {
    try {
      // flutter_bluetooth_serial does not track active connections, so this depends on your app's logic
      print('Disconnected from device: ${device.name}');
      // Implement custom disconnection logic if needed
    } catch (e) {
      print("Error disconnecting from device: ${device.name} (${device.address}) - $e");
    }
  }


}

final bluetoothServiceProvider = Provider<BluetoothServiceClass>((ref) {
  return BluetoothServiceClass();
});
