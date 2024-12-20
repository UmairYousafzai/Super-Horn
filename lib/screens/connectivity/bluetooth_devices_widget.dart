import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:superhorn/domain/entities/bluetooth_device.dart';
import 'package:superhorn/providers/bluetooth_devices_provider.dart';
import 'package:superhorn/screens/widgets/bluetooth_device_item_widget.dart';
import 'package:superhorn/utils/bluetooth_connectivity_helper.dart';
import 'package:superhorn/utils/media_query_extension.dart';

import '../../core/theme/colors.dart';
import '../../providers/bluetooth_provider.dart';
import '../widgets/buttons.dart';
class BluetoothDevicesWidget extends ConsumerStatefulWidget{
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return BluetoothDevicesState();
  }

}


class BluetoothDevicesState extends ConsumerState<BluetoothDevicesWidget>{

  BluetoothConnectivityHelper connectivityHelper=BluetoothConnectivityHelper();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bluetoothDevicesStateProvider);
    final stateNotifier = ref.read(bluetoothDevicesStateProvider.notifier);
    final devices = ref.watch(bluetoothNotifierProvider);
    final bluetoothNotifier=ref.read(bluetoothNotifierProvider.notifier);

    return Scaffold(
      body: GestureDetector(
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.png'),
              fit: BoxFit.cover, // Ensures the image covers the entire screen
            ),
          ),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              Padding(padding: const EdgeInsets.only(top: 40,right: 20),
              child:
              primaryButton(
                  context,
                   Text(!state.isScanning?"Scan":"Stop", style: TextStyle(fontSize: 20, color: Colors.white),),
                      () async {

                        stateNotifier.setScanning(!state.isScanning);



                    if(!state.isScanning){
                      ref.read(bluetoothNotifierProvider.notifier).scanForDevices();
                    }else{
                      bluetoothNotifier.stopScanning();
                    }


                      },
              width: context.mqW(0.2.w),
              height: context.mqH(0.05.h)
              )),

              if(state.isScanning)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color:AColors.primaryColor,strokeWidth: 1,),
                ],
              ),

              Expanded(
                child: Container(
                  child: ListView.builder(
                    itemCount:devices.length,
                      itemBuilder:(context,index){

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            BluetoothDeviceItemWidget(device: devices[index]),
                            const Divider(color: Colors.grey,)
                          ],
                        ));
                  }
                  
                  ),
                ),
              )
              ],
    )
    )));
  }



}