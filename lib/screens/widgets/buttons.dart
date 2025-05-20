import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:superhorn/core/utils/media_query_extension.dart';

import '../../core/theme/colors.dart';

primaryButton(BuildContext context, Widget child, VoidCallback onTap, {double? width, double? height}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: height ?? context.mqH(0.075.h),
      width: width ?? context.mqW(0.9.w),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AColors.primaryColor,
              AColors.primaryColor.withOpacity(0.9),
              AColors.primaryColor.withOpacity(0.8),
              AColors.primaryColor.withOpacity(0.7),
            ],
          ),
          borderRadius: const BorderRadius.all(Radius.circular(16))),
      child: Center(child: child),
    ),
  );
}

outlinedButton(BuildContext context, Widget child, VoidCallback onTap, {double? width, double? height}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: height ?? context.mqH(0.075.h),
      width: width ?? context.mqW(0.9.w),
      decoration: BoxDecoration(
          color: AColors.primaryColor.withOpacity(0.05),
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          border: Border.all(color: AColors.primaryColor, width: 2)),
      child: Center(child: child),
    ),
  );
}

socialButton(BuildContext context, String image) {
  return Container(
    height: 70.h,
    width: 70.h,
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.black.withOpacity(0.3),
      ),
      borderRadius: BorderRadius.circular(100), // Set border radius to make it circular
    ),
    child: Center(
      child: Image.asset(
        image,
        height: 35.h,
        width: 35.h, // Adjust the image size to fit nicely inside the circle
      ),
    ),
  );
}

Widget PlayPauseButton(bool isAnimating, VoidCallback onPress) {
  return GestureDetector(
    onTap: onPress,
    child: Container(
      height: 70.h,
      width: 70.w,
      decoration: BoxDecoration(
        color: AColors.primaryColor,
        borderRadius: BorderRadius.circular(80 / 2),
      ),
      child: Icon(
        isAnimating ? Icons.pause_rounded : Icons.play_arrow_rounded,
        color: Colors.white,
        size: 80 * 0.6,
      ),
    ),
  );
}

class WhiteContainerButton extends StatelessWidget {
  const WhiteContainerButton({
    super.key,
    required this.img,
    required this.text,
    required this.onPress,
  });

  final String img;
  final String text;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: context.mqH(0.22.h),
        width: context.mqW(0.9.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Shadow color with opacity
              offset: const Offset(0, 0), // No offset to spread shadow evenly
              blurRadius: 5, // How blurry the shadow is
              spreadRadius: 1, // How much the shadow spreads
            ),
          ],
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              img,
              height: 50.h,
            ),
            SizedBox(
              height: 18.h,
            ),
            Text(
              text,
              style: TextStyle(
                  fontFamily: 'Poppins', color: AColors.primaryColor, fontWeight: FontWeight.w600, fontSize: 18.sp),
            )
          ],
        ),
      ),
    );
  }
}
