import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:superhorn/core/utils/media_query_extension.dart';
import 'package:superhorn/core/utils/navigations.dart';
import 'package:superhorn/screens/play_horn_with_bluetooth.dart';
import 'package:superhorn/screens/widgets/snackBar_messages.dart';

import '../../core/theme/colors.dart';
import '../../core/utils/bluetooth_connectivity_helper.dart';
import '../../providers/bluetooth_devices_provider.dart';
import '../../providers/bluetooth_provider.dart';
import 'bluetooth_device_item_widget.dart';
import '../widgets/buttons.dart';

class BluetoothDevicesWidget extends ConsumerStatefulWidget {
  const BluetoothDevicesWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return BluetoothDevicesState();
  }
}

class BluetoothDevicesState extends ConsumerState<BluetoothDevicesWidget> {
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bluetoothDevicesStateProvider);
    final stateNotifier = ref.read(bluetoothDevicesStateProvider.notifier);
    final screenState = ref.watch(bluetoothNotifierProvider);
    final bluetoothNotifier = ref.read(bluetoothNotifierProvider.notifier);

    ref.listen(bluetoothNotifierProvider, (prev, next) async {
      if (next.isDeviceConnected) {
        showSuccessSnackBar(context, "Connected");
        await Future.delayed(const Duration(microseconds: 1000));
        navigatePushAndRemoveUntil(
            context, const PlayHornWithBluetooth(), true);
      }

      if (next.errorMessage.isNotEmpty) {
        showErrorSnackBar(context, next.errorMessage);
        bluetoothNotifier.setError("");
      }
    });

    return PopScope(
      onPopInvokedWithResult: (didPod, result){
        print("didpod=>>>>>>>>>>>>>. $didPod");
        bluetoothNotifier.resetState();
      },
      child: Scaffold(
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

                            if (!state.isScanning) {
                              ref
                                  .read(bluetoothNotifierProvider.notifier)
                                  .scanForDevices();
                            } else {
                              bluetoothNotifier.stopScanning();
                            }
                          },
                              width: context.mqW(0.2.w),
                              height: context.mqH(0.05.h))),
                      if (state.isScanning)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: AColors.primaryColor,
                              strokeWidth: 1,
                            ),
                          ],
                        ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: screenState.devices.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    children: [
                                      BluetoothDeviceItemWidget(
                                          device: screenState.devices[index]),
                                      const Divider(
                                        color: Colors.grey,
                                      )
                                    ],
                                  ));
                            }),
                      )
                    ],
                  )))),
    );
  }
}
