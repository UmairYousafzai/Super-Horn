import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:superhorn/core/utils/media_query_extension.dart';
import 'package:superhorn/domain/entities/bluetooth_device.dart';
import 'package:superhorn/providers/bluetooth_devices_provider.dart';
import 'package:superhorn/screens/widgets/bluetooth_device_item_widget.dart';

import '../widgets/buttons.dart';

class BluetoothDevicesWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return BluetoothDevicesState();
  }
}

class BluetoothDevicesState extends ConsumerState<BluetoothDevicesWidget> {
  List<BluetoothDevice> devices = [];

  void initDummyDevicesList() {
    for (int i = 0; i <= 10; i++) {
      devices.add(
          new BluetoothDevice(deviceId: i.toDouble(), deviceName: "device $i"));
    }
  }

  @override
  void initState() {
    initDummyDevicesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bluetoothDevicesStateProvider);
    final stateNotifier = ref.read(bluetoothDevicesStateProvider.notifier);

    return Scaffold(
        body: GestureDetector(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit
                        .cover, // Ensures the image covers the entire screen
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 40, right: 20),
                        child: primaryButton(
                            context,
                            Text(
                              !state.isScanning ? "Scan" : "Stop",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ), () async {
                          stateNotifier.setScanning(!state.isScanning);
                        },
                            width: context.mqW(0.2.w),
                            height: context.mqH(0.05.h))),
                    Expanded(
                      child: Container(
                        child: ListView.builder(
                            itemCount: devices.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    children: [
                                      BluetoothDeviceItemWidget(
                                          device: devices[index]),
                                      const Divider(
                                        color: Colors.grey,
                                      )
                                    ],
                                  ));
                            }),
                      ),
                    )
                  ],
                ))));
  }
}
