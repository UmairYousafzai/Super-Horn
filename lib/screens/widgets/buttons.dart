import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:superhorn/utils/media_query_extension.dart';

import '../../core/theme/colors.dart';

primaryButton(BuildContext context, Widget child, VoidCallback onTap,{double? width,double? height}) {
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

socialButton(BuildContext context, String image) {
  return Container(
    height: 70.h,
    width: 70.h,
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.black.withOpacity(0.3),
      ),
      borderRadius:
          BorderRadius.circular(100), // Set border radius to make it circular
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
