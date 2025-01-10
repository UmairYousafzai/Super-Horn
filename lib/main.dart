import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:superhorn/providers/shared_pref_provider.dart';
import 'package:superhorn/screens/auth/login_screen.dart';
import 'package:superhorn/screens/landing_screen.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const ProviderScope(child: MyApp()));
  FlutterNativeSplash.remove();
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userNotifier = ref.read(sharedPreferencesProvider);

    return FutureBuilder<bool>(
      future: userNotifier.doesUserExist(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.hasError) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: Text('An error occurred!')),
            ),
          );
        }
        final userExists = snapshot.data ?? false;
        return ScreenUtilInit(
          designSize:
              const Size(375, 812), // Replace with your design screen size
          minTextAdapt: true,
          builder: (context, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: userExists ? const LandingScreen() : const LoginScreen(),
              //home: (),
            );
          },
        );
      },
    );
  }
}
