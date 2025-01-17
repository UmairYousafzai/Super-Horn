import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:superhorn/screens/widgets/background_image_container.dart';
import 'package:superhorn/screens/widgets/product_container.dart';

import '../core/theme/colors.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BackgroundImageContainer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Products",
                  style: TextStyle(
                    fontFamily: 'JosefinSans',
                    color: AColors.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 24.sp,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  'Press the play button to listen to the sound', style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 35.h,),
                const ProductContainer(imagePath: 'assets/product1.png', title: 'ROMEO JINGLE BELL (RMJ-620)', subtitle1: '3-Pipe Auto Horn', subtitle2: '20 Melodies (12/24 Volts)'),
                SizedBox(height: 30.h,),
                const ProductContainer(imagePath: 'assets/product2.png', title: 'ROMEO Air Horn (RM-620)', subtitle1: '6-Pipe Auto Horn', subtitle2: '20 Melodies (12/24 Volts)'),
                SizedBox(height: 30.h,),
                const ProductContainer(imagePath: 'assets/product3.png', title: 'ROAD MASTER (RM-412)', subtitle1: '4-Pipe Auto Horn', subtitle2: '20 Melodies (12/24 Volts)'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

