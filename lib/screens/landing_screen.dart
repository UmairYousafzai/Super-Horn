import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:superhorn/screens/homescreen.dart';
import 'package:superhorn/screens/widgets/buttons.dart';
import 'package:superhorn/utils/navigations.dart';

import '../core/theme/colors.dart';
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    outlinedButton(
                        context,
                        Text(
                          'Play Horn',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: AColors.primaryColor,
                              fontWeight: FontWeight.w500),
                        ), () {
                      navigateToScreen(context, BluetoothDevicesWidget());
                    }),
                    SizedBox(
                      height: 25.h,
                    ),
                    outlinedButton(
                        context,
                        Text(
                          'Place Holder',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: AColors.primaryColor,
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
