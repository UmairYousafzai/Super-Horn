


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:superhorn/core/theme/colors.dart';
import 'package:superhorn/domain/entities/bluetooth_device.dart';

import '../../providers/bluetooth_devices_provider.dart';

class BluetoothDeviceItemWidget extends ConsumerWidget{
  BluetoothDevice device;
  BluetoothDeviceItemWidget({required this.device});

  @override
  Widget build(BuildContext context,ref) {
    final state = ref.watch(bluetoothDevicesStateProvider);
    final stateNotifier = ref.read(bluetoothDevicesStateProvider.notifier);

    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: InkWell(
        onTap: (){
          stateNotifier.setConnecting(!state.isConnecting);
        },
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(device.deviceName!,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AColors.primaryColor
              ),),
            ),
            if(state.isConnecting && state.isScanning)
            CircularProgressIndicator(color:AColors.primaryColor,strokeWidth: 1,)
          ],
        ),
      ),
    );
  }

}