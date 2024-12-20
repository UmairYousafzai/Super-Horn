import 'package:flutter/cupertino.dart';

class ScreenBackgroundContainer extends StatelessWidget {
  const ScreenBackgroundContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background.png'),
          fit: BoxFit.cover, // Ensures the image covers the entire screen
        ),
      ),
      child: child,
    );
  }
}
