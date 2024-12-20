


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:superhorn/core/theme/colors.dart';

import '../../providers/bluetooth_devices_provider.dart';
import '../../providers/bluetooth_provider.dart';

class BluetoothDeviceItemWidget extends ConsumerStatefulWidget{
  BluetoothDevice device;
  bool isConnectingToDevice=false;

  BluetoothDeviceItemWidget({required this.device});


  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return BluetoothDeviceItemWidgetState();
  }}





class BluetoothDeviceItemWidgetState extends ConsumerState<BluetoothDeviceItemWidget>{



    @override
    Widget build(BuildContext context) {

      final state = ref.watch(bluetoothDevicesStateProvider);
      final stateNotifier = ref.read(bluetoothDevicesStateProvider.notifier);


      return Padding(
        padding: const EdgeInsets.only(left: 20),
        child: InkWell(
          onTap: (){
             stateNotifier.setConnecting(!state.isConnecting);
             setState(() {
               widget.isConnectingToDevice=true;
             });
             ref.read(bluetoothNotifierProvider.notifier).connectToDevice(widget.device);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(widget.device.name.toString(),
                  maxLines: 18,
                  style: TextStyle(fontSize: 10,
                      fontWeight: FontWeight.w700, color: AColors.primaryColor),),
              ),
              if(widget.isConnectingToDevice)
                CircularProgressIndicator(color:AColors.primaryColor,strokeWidth: 1,)
            ],
          ),
        ),
      );
    }

  }


