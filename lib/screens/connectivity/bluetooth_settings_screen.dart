import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:superhorn/screens/homescreen.dart';
import 'package:superhorn/screens/widgets/background_image_container.dart';

import '../../core/theme/colors.dart';
import '../../core/utils/navigations.dart';
import '../../providers/bluetooth_provider.dart';
import '../widgets/snackBar_messages.dart';

class BluetoothSettingsScreen extends ConsumerStatefulWidget {
  const BluetoothSettingsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BluetoothSettingsScreenState();
}

class _BluetoothSettingsScreenState
    extends ConsumerState<BluetoothSettingsScreen> {
  @override
  void initState() {
    super.initState();
    Future(() async {
      await ref.read(bluetoothNotifierProvider.notifier).requestPermissions();
      ref.read(bluetoothNotifierProvider.notifier).getDeviceName();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bluetoothState = ref.watch(bluetoothNotifierProvider);
    final bluetoothNotifier = ref.read(bluetoothNotifierProvider.notifier);

    // Listen to changes in the Bluetooth state
    ref.listen(bluetoothNotifierProvider, (previous, next) async {
      if (next.isDeviceConnected) {
        // showSuccessSnackBar(context, "Connected");
        await Future.delayed(const Duration(milliseconds: 1000));
        navigatePushAndRemoveUntil(
          context,
          Homescreen(true),
          true,
        );
      }

      if (next.errorMessage.isNotEmpty) {
        showErrorSnackBar(context, next.errorMessage);
        ref.read(bluetoothNotifierProvider.notifier).setError("");
      }
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            bluetoothNotifier.resetState();
            Navigator.pop(context);
          },
        ),
      ),
      body: BackgroundImageContainer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bluetooth",
                  style: TextStyle(
                    fontFamily: 'JosefinSans',
                    color: AColors.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 24.sp,
                  ),
                ),
                SizedBox(height: 12.h),
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  child: ListTile(
                    title: const Text(
                      "Bluetooth",
                      style: TextStyle(
                        fontFamily: 'JosefinSans',
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    trailing: Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: bluetoothState.isBluetoothOn,
                        onChanged: (value) async {
                          bluetoothNotifier.setBluetoothOn(value);
                          if (value) {
                            bluetoothNotifier.scanForDevices();
                          } else {
                            bluetoothNotifier.stopScanning();
                          }
                        },
                        activeColor: Colors.white,
                        activeTrackColor: AColors.blueColor,
                        inactiveTrackColor: Colors.grey,
                        inactiveThumbColor: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                if (bluetoothState.myOwnDevice.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Device Name ",
                        style: TextStyle(
                          fontFamily: 'JosefinSans',
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                        ),
                      ),
                      Text(
                        bluetoothState.myOwnDevice,
                        style: TextStyle(
                          fontFamily: 'JosefinSans',
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                        ),
                      )
                    ],
                  ),
                SizedBox(height: 16.h),
                Divider(
                  color: Colors.black.withOpacity(0.4),
                ),
                SizedBox(height: 16.h),
                if (bluetoothState.connectedDeviceName.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border:
                            Border.all(color: AColors.primaryColor, width: 2),
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: Image.asset(
                        "assets/icons/bluetooth_icon.png",
                        height: 30.h,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bluetoothState.connectedDeviceName,
                            style: TextStyle(
                              fontFamily: 'JosefinSans',
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                          Text(
                            bluetoothState.isDeviceConnected
                                ? "(Connected)"
                                : "",
                            style: TextStyle(
                              fontFamily: 'JosefinSans',
                              color: AColors.primaryColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                SizedBox(
                  height: 16.h,
                ),
                if (bluetoothState.isBluetoothOn)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Available Devices",
                        style: TextStyle(
                          fontFamily: 'JosefinSans',
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                        ),
                      ),
                      bluetoothState.isScanning
                          ? SizedBox(
                              height: 25.h,
                              width: 25.h,
                              child: CircularProgressIndicator(
                                color: AColors.primaryColor,
                                strokeWidth: 3,
                              ),
                            )
                          : TextButton(
                              onPressed: () {
                                bluetoothNotifier.scanForDevices();
                              },
                              child: Text(
                                "Refresh",
                                style: TextStyle(
                                  fontFamily: 'JosefinSans',
                                  color: AColors.primaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.sp,
                                ),
                              ),
                            )
                    ],
                  ),
                SizedBox(height: 8.h),
                Expanded(
                  child: bluetoothState.isBluetoothOn
                      ? ListView.builder(
                          itemCount: bluetoothState.devices.length,
                          itemBuilder: (context, index) {
                            final device = bluetoothState.devices[index];
                            final isConnectingToDevice =
                                bluetoothState.connectingDeviceAddress ==
                                    device.deviceAddress;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Material(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                child: ListTile(
                                  leading: Image.asset(
                                    "assets/icons/bluetooth_icon.png",
                                    height: 30.h,
                                  ),
                                  title: Text(
                                    device.deviceName ?? "Unknown Device",
                                    style: TextStyle(
                                      fontFamily: 'JosefinSans',
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  trailing: isConnectingToDevice
                                      ? SizedBox(
                                          height: 25.h,
                                          width: 25.h,
                                          child: CircularProgressIndicator(
                                            color: AColors.primaryColor,
                                            strokeWidth: 3,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.chevron_right,
                                          color: Colors.black,
                                        ),
                                  onTap: () {
                                    bluetoothNotifier.connectToDevice(device);
                                  },
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            "Turn on Bluetooth to see available devices",
                            style: TextStyle(
                              fontFamily: 'JosefinSans',
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
