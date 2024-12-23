
import 'package:superhorn/domain/entities/connectable_device.dart';

class BluetoothDeviceModel extends ConnectableDevice{

  BluetoothDeviceModel({
    required super.deviceName,
    required super.deviceAddress,
    required super.isConnecting, required super.isConnected
  });

  BluetoothDeviceModel.copy(ConnectableDevice device):
        this(
          deviceName: device.deviceName,
          deviceAddress: device.deviceAddress,
          isConnecting: device.isConnecting,
          isConnected: device.isConnected
      );

}