import 'package:flutter/material.dart';

class ImageRowWidget extends StatefulWidget {
  final bool isAnimating; // Add this parameter

  const ImageRowWidget({Key? key, required this.isAnimating}) : super(key: key);

  @override
  _ImageRowWidgetState createState() => _ImageRowWidgetState();
}

class _ImageRowWidgetState extends State<ImageRowWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _sizeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.72),
        weight: 2.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.72, end: 1.0),
        weight: 1.0,
      ),
    ]).animate(_animationController);

    if (widget.isAnimating) {
      _animationController.repeat();
    }
  }

  @override
  void didUpdateWidget(ImageRowWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating != oldWidget.isAnimating) {
      if (widget.isAnimating) {
        _animationController.repeat();
      } else {
        _animationController.stop();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Background smaller images
            Positioned(
              left: 50,
              top: 5,
              child: _AnimatedImage('assets/single_horn.png',
                  width: 60, height: 60),
            ),
            Positioned(
              left: 140,
              top: 5,
              child: _AnimatedImage('assets/single_horn.png',
                  width: 60, height: 60),
            ),
            Positioned(
              left: 225,
              top: 5,
              child: _AnimatedImage('assets/single_horn.png',
                  width: 60, height: 60),
            ),
            // Foreground larger images
            Positioned(
              left: 0,
              child: _AnimatedImage('assets/single_horn.png',
                  width: 70, height: 70),
            ),
            Positioned(
              left: 90,
              child: _AnimatedImage('assets/single_horn.png',
                  width: 70, height: 70),
            ),
            Positioned(
              left: 180,
              child: _AnimatedImage('assets/single_horn.png',
                  width: 70, height: 70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _AnimatedImage(String assetPath,
      {required double width, required double height}) {
    return AnimatedBuilder(
      animation: _sizeAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _sizeAnimation.value,
          child: Image.asset(assetPath,
              width: width, height: height, fit: BoxFit.cover),
        );
      },
    );
  }
}
