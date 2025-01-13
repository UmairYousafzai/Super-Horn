import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:superhorn/core/theme/colors.dart';
import 'package:superhorn/screens/auth/signup_screen.dart';

import '../../core/utils/navigations.dart';
import '../../providers/auth/login_provider.dart';
import '../../providers/firebase/firebase_usecase_provider.dart';
import '../../providers/shared_pref_provider.dart';
import '../../utils/helper_functions.dart';
import '../widgets/buttons.dart';
import '../widgets/text_field_widget.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends ConsumerState<LoginScreen> {
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

//Function  for the field validation and saving user data
  void handleButtonClick() async {
    var sharedPreferencesHelper = ref.read(sharedPreferencesProvider);
    var loginState = ref.watch(loginProvider);
    var loginNotifier = ref.read(loginProvider.notifier);
    final fetchUserUseCase = ref.read(fetchUserUseCaseProvider);

    // Validate input fields
    loginNotifier.updateEmail(loginState.email);
    loginNotifier.updatePassword(loginState.password);

    // Get the updated state after validation
    loginState = ref.watch(loginProvider);

    String emailError = loginState.emailError ?? "";
    String passwordError = loginState.passwordError ?? "";

    if (loginState.email.isNotEmpty &&
        emailError.isEmpty &&
        loginState.password.isNotEmpty &&
        passwordError.isEmpty) {
      try {
        await loginNotifier.login();
        loginState = ref.watch(loginProvider);

        // Show error message if login failed
        if (loginState.error!.isNotEmpty) {
          showSnackBar(loginState.error!, context);
          return; // Stop execution if there's an error
        }

        if (loginState.isSignedIn) {
          try {
            final user = await fetchUserUseCase.execute();
            await sharedPreferencesHelper.saveUser(user);
          } catch (e) {
            showSnackBar(e.toString(), context);
          }
        }
      } catch (e) {
        showSnackBar(e.toString(), context);
      }
    } else {
      showSnackBar('Please enter valid inputs', context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                                  fontFamily: 'JosefinSans',
                                  color: AColors.primaryColor,
                                  fontSize: 32.sp,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              'Hi! Welcome back ',
                              style: TextStyle(
                                fontFamily: 'JosefinSans',
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 22.sp,
                              ),
                            ),
                            SizedBox(height: 5.h),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Super ',
                                    style: TextStyle(
                                      color: AColors.primaryColor,
                                      fontFamily: 'JosefinSans',
                                      fontSize: 22.sp,
                                      fontWeight:
                                          FontWeight.bold, // Optional bold
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Air Horn',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'JosefinSans',
                                      fontSize: 24.sp,
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
                          fontFamily: 'JosefinSans',
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
                          fontFamily: 'JosefinSans',
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
                              fontFamily: 'JosefinSans',
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
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20.sp,
                              color: Colors.white),
                        ),
                        () {},
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
                                    text: "Don't have an account? ",
                                    style: TextStyle(
                                      fontFamily: 'JosefinSans',
                                    ) // Regular text
                                    ),
                                TextSpan(
                                  text: "Register", // Styled text
                                  style: TextStyle(
                                    fontFamily: 'JosefinSans',
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
