
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:superhorn/domain/entities/states/bluetooth_devices_state.dart';


class BluetoothDevicesNotifier extends StateNotifier<BluetoothDevicesState>{
  BluetoothDevicesNotifier():super(BluetoothDevicesState());

  void setScanning(bool isScanning){

    state=state.copyWith(
      isScanning: isScanning,
    );

    if(!isScanning){
      state=state.copyWith(
          isConnecting: false
      );
    }
  }

  void setConnecting(bool isConnecting){
    state=state.copyWith(
      isConnecting: isConnecting
    );
  }
}


final bluetoothDevicesStateProvider = StateNotifierProvider<BluetoothDevicesNotifier,BluetoothDevicesState>((ref){
  return BluetoothDevicesNotifier();
});