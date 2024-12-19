
import 'package:superhorn/domain/entities/bluetooth_device.dart';

class BluetoothDevicesState{

  bool isScanning;
  bool isConnecting;
  List<BluetoothDevice> devicesList;


  BluetoothDevicesState({
    this.isScanning=false,
    this.isConnecting=false,
    this.devicesList=const []
  });


  BluetoothDevicesState copyWith({
    bool? isScanning,
    bool? isConnecting,
    List<BluetoothDevice>? devicesList
  }){

    return BluetoothDevicesState(
        isScanning: isScanning ?? this.isScanning,
        isConnecting: isConnecting ?? this.isConnecting,
        devicesList: devicesList ?? this.devicesList
    );
}
}