import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:superhorn/core/theme/colors.dart';
import 'package:superhorn/screens/auth/signup_screen.dart';
import 'package:superhorn/screens/homescreen.dart';
import 'package:superhorn/utils/navigations.dart';

import '../../providers/login_provider.dart';
import '../widgets/buttons.dart';
import '../widgets/text_field_widget.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginProvider);
    final loginNotifier = ref.read(loginProvider.notifier);

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
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 100.h),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'LOG IN',
                              style: TextStyle(
                                color: AColors.primaryColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 32.sp,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              'Hi! Welcome back ',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 22.sp,
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Super ',
                                    style: TextStyle(
                                      color: AColors.primaryColor,
                                      // Red color for "Super"
                                      fontSize: 22.sp,
                                      fontWeight:
                                          FontWeight.bold, // Optional bold
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Air Horn',
                                    style: TextStyle(
                                      color: Colors
                                          .black, // Black color for "Air Horn"
                                      fontSize: 22.sp,
                                      fontWeight:
                                          FontWeight.bold, // Optional bold
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'Email',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      TextFieldWidget(
                        hintText: 'example@gmail.com',
                        onChanged: (value) {
                          loginNotifier.updateEmail(value);
                        },
                        errorText: loginState.emailError ?? '',
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Password',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      TextFieldWidget(
                        hintText: '********',
                        onChanged: (value) {
                          loginNotifier.updatePassword(value);
                        },
                        errorText: loginState.passwordError ?? '',
                        isObscure: true,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "Forget Password?",
                            style: TextStyle(
                              color: AColors.primaryColor,
                              decoration: TextDecoration.underline,
                              decorationColor: AColors.primaryColor,
                              decorationThickness: 1.5,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 22.h),
                      primaryButton(
                        context,
                        Text(
                          "Get Started",
                          style:
                              TextStyle(fontSize: 20.sp, color: Colors.white),
                        ),
                        () {
                          if (loginState.email.isNotEmpty &&
                              loginState.password.isNotEmpty &&
                              loginState.emailError!.isEmpty &&
                              loginState.passwordError!.isEmpty) {
                            navigatePushReplacement(context, Homescreen());
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please enter valid inputs')),
                            );
                          }
                        },
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            navigateToScreen(context, const SignupScreen());
                          },
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.3),
                                // Default text color for the rest of the text
                                fontSize: 16, // You can adjust the font size
                              ),
                              children: [
                                const TextSpan(
                                  text:
                                      "Don't have an account? ", // Regular text
                                ),
                                TextSpan(
                                  text: "Register", // Styled text
                                  style: TextStyle(
                                    color: AColors.primaryColor,
                                    // Red color for "Register"
                                    fontWeight:
                                        FontWeight.bold, // Optional bold
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
