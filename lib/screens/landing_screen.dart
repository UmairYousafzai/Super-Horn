import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:superhorn/core/utils/media_query_extension.dart';
import 'package:superhorn/screens/homescreen.dart';
import 'package:superhorn/screens/widgets/buttons.dart';

import '../core/utils/navigations.dart';
import 'connectivity/bluetooth_devices_widget.dart';

class LandingScreen extends ConsumerWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.png'),
              fit: BoxFit.cover, // Ensures the image covers the entire screen
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: context.mqW(0.25).h,
                    ),
                    Image.asset(
                      "assets/superhorn.png",
                      height: 150.h,
                      width: 250.w,
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    WhiteContainerButton(
                        img: "assets/icons/horn_icon.png",
                        text: "Play Horn",
                        onPress: () {
                          navigateToScreen(context, BluetoothDevicesWidget());
                        }),
                    SizedBox(
                      height: 20.h,
                    ),
                    primaryButton(
                        context,
                        const Text(
                          'Place Your Order',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ), () {
                      navigateToScreen(context, Homescreen());
                    })
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
