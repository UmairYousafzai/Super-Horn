import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:superhorn/core/utils/navigations.dart';
import 'package:superhorn/screens/homescreen.dart';

import '../../core/theme/colors.dart';

class ProductContainer extends StatelessWidget {
  const ProductContainer({
    super.key, required this.imagePath, required this.title, required this.subtitle1, required this.subtitle2,
  });
  final String imagePath;
  final String title;
  final String subtitle1;
  final String subtitle2;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=>navigateToScreen(context, const Homescreen(false)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                child: Row(
                  children: [
                    Image.asset(
                      imagePath,
                      height: 80.h,
                      width: 80.w,
                    ),
                    SizedBox(
                      width: 14.w,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontFamily: 'JosefinSans',
                            fontSize: 11.sp,
                            color: AColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 6.h,
                        ),
                        Text(
                          subtitle1,
                          style: TextStyle(
                            fontFamily: 'JosefinSans',
                            fontSize: 11.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 6.h,
                        ),
                        Text(
                          subtitle2,
                          style: TextStyle(
                            fontFamily: 'JosefinSans',
                            fontSize: 11.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 8, // Adjust for spacing from bottom
                right: 8, // Adjust for spacing from right
                child: Container(
                  height: 25.h,
                  width: 25.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AColors.primaryColor,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    size: 20,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}