
import 'package:superhorn/domain/entities/bluetooth_device.dart';

class BluetoothDeviceModel extends BluetoothDevice{

  BluetoothDeviceModel({
    required super.deviceId,
    required super.deviceName,
    required super.isConnecting, required super.isConnected
  });

  BluetoothDeviceModel.copy(BluetoothDevice device):
        this(
          deviceId: device.deviceId,
          deviceName: device.deviceName,
          isConnecting: device.isConnecting,
          isConnected: device.isConnected
      );

}