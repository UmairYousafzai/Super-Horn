import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:superhorn/providers/shared_pref_provider.dart';
import 'package:superhorn/screens/homescreen.dart';
import 'package:superhorn/utils/navigations.dart';

import '../../core/theme/colors.dart';
import '../../providers/signup_provider.dart';
import '../widgets/buttons.dart';
import '../widgets/text_field_widget.dart';

class SignupScreen extends ConsumerWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signupState = ref.watch(signUpProvider);
    final signupNotifier = ref.read(signUpProvider.notifier);
    final sharedPrefNotifier = ref.read(sharedPreferencesProvider);

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
              fit: BoxFit.cover, // Ensures the image covers the entire screen
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'SIGN UP',
                            style: TextStyle(
                              color: AColors.primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 32.sp,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'Hello! let’s join with us.',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 22.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Name',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    TextFieldWidget(
                      hintText: 'Wahab Asif',
                      onChanged: (value) {
                        signupNotifier.updateName(value);
                      },
                      errorText: signupState.nameError ?? '',
                      leftIcon: Icons.person,
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
                      hintText: 'example@gmail.co',
                      onChanged: (value) {
                        signupNotifier.updateEmail(value);
                      },
                      errorText: signupState.emailError ?? '',
                      leftIcon: Icons.email_outlined,
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
                        signupNotifier.updatePassword(value);
                      },
                      errorText: signupState.passwordError ?? '',
                      isObscure: true,
                      leftIcon: Icons.password,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'City',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    TextFieldWidget(
                      hintText: 'London',
                      onChanged: (value) {
                        signupNotifier.updateCity(value);
                      },
                      errorText: signupState.cityError ?? '',
                      leftIcon: Icons.location_city_outlined,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Country',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    TextFieldWidget(
                      hintText: 'United Kingdom',
                      onChanged: (value) {
                        signupNotifier.updateCountry(value);
                      },
                      errorText: signupState.countryError ?? '',
                      leftIcon: Icons.location_on_outlined,
                    ),
                    SizedBox(height: 50.h),
                    primaryButton(
                        context,
                        const Text(
                          "Get Started",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ), () async {
                      if (signupState.email.isNotEmpty &&
                          signupState.name.isNotEmpty &&
                          signupState.password.isNotEmpty &&
                          signupState.city.isNotEmpty &&
                          signupState.country.isNotEmpty &&
                          signupState.nameError!.isEmpty &&
                          signupState.emailError!.isEmpty &&
                          signupState.passwordError!.isEmpty &&
                          signupState.cityError!.isEmpty &&
                          signupState.countryError!.isEmpty) {
                        //saving user data to shared preference
                        await sharedPrefNotifier
                            .saveUserData(
                                name: signupState.name,
                                email: signupState.email,
                                password: signupState.password,
                                city: signupState.city,
                                country: signupState.country)
                            .then((value) {
                          if (kDebugMode) {
                            print(
                                "--------------------User save successfully--------------");
                          }
                          navigatePushAndRemoveUntil(
                              context, Homescreen(), false);
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please enter valid inputs')),
                        );
                      }
                    }),
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
