
import 'package:superhorn/domain/entities/bluetooth_device.dart';

class BluetoothDeviceModel extends BluetoothDevice{

  BluetoothDeviceModel({
    required super.deviceId,
    required super.deviceName
  });

  BluetoothDeviceModel.copy(BluetoothDevice device):
        this(deviceId: device.deviceId,deviceName: device.deviceName);

}