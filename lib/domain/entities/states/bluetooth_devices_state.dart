
import 'package:superhorn/domain/entities/connectable_device.dart';

class BluetoothDevicesState{

  bool isScanning;
  bool isConnecting;
  List<ConnectableDevice> devicesList;


  BluetoothDevicesState({
    this.isScanning=false,
    this.isConnecting=false,
    this.devicesList=const []
  });


  BluetoothDevicesState copyWith({
    bool? isScanning,
    bool? isConnecting,
    List<ConnectableDevice>? devicesList
  }){

    return BluetoothDevicesState(
        isScanning: isScanning ?? this.isScanning,
        isConnecting: isConnecting ?? this.isConnecting,
        devicesList: devicesList ?? this.devicesList
    );
}
}