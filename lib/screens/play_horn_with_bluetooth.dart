import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:superhorn/screens/widgets/buttons.dart';
import 'package:superhorn/screens/widgets/snackBar_messages.dart';

import '../providers/bluetooth_provider.dart';

class PlayHornWithBluetooth extends ConsumerWidget {
  const PlayHornWithBluetooth({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bluetoothNotifier = ref.read(bluetoothNotifierProvider.notifier);

    ref.listen(bluetoothNotifierProvider, (prev,next){

      if(next.errorMessage.isNotEmpty){
        showErrorSnackBar(context, next.errorMessage);
        bluetoothNotifier.setError("");
      }
      if(next.successMessage.isNotEmpty){
        showErrorSnackBar(context, next.successMessage);
        bluetoothNotifier.setSuccess("");
      }
    });

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
        ),
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
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
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        primaryButton(
                            context,
                            Text(
                              "Next",
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16.sp,
                                  color: Colors.white),
                            ),
                            () {
                              bluetoothNotifier.sendData("1");

                            }),
                        SizedBox(
                          height: 25.h,
                        ),
                        primaryButton(
                            context,
                            Text(
                              "Previous",
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16.sp,
                                  color: Colors.white),
                            ),
                            () {}),
                        SizedBox(
                          height: 25.h,
                        ),
                        primaryButton(
                            context,
                            Text(
                              "Play",
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16.sp,
                                  color: Colors.white),
                            ),
                            () {
                              bluetoothNotifier.sendData("p");

                            }),
                        SizedBox(
                          height: 25.h,
                        ),
                        primaryButton(
                            context,
                            Text(
                              "Reset",
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16.sp,
                                  color: Colors.white),
                            ),
                            () {
                              bluetoothNotifier.sendData("0");

                            }),
                      ]),
                ),
              ),
            )));
  }
}
