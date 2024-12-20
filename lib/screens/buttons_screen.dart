import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:superhorn/screens/widgets/buttons.dart';

class ButtonsScreen extends ConsumerWidget {
  const ButtonsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                            () {}),
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
                            () {}),
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
                            () {}),
                      ]),
                ),
              ),
            )));
  }
}
