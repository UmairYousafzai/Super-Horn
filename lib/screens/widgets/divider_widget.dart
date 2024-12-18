import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            indent: 25,
            endIndent: 10,
            color: Colors.black.withOpacity(0.2),
          ),
        ),
        Text(
          "Or",
          style:
              TextStyle(color: Colors.black.withOpacity(0.2), fontSize: 16.sp),
        ),
        Expanded(
            child: Divider(
          endIndent: 25,
          indent: 10,
          color: Colors.black.withOpacity(0.2),
        ))
      ],
    );
  }
}
