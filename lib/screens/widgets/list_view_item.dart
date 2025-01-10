// New widget for a single sound item
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/colors.dart';
import '../../domain/entities/sound.dart';

class SoundItem extends StatelessWidget {
  final Sound sound;
  final bool isPlaying;
  final bool isChecked;
  final bool isComingFromPlayOption;
  final VoidCallback onPlayPause;
  final VoidCallback onSelect;
  final VoidCallback? onNavigate;

  const SoundItem({
    super.key,
    required this.sound,
    required this.isPlaying,
    required this.isChecked,
    required this.isComingFromPlayOption,
    required this.onPlayPause,
    required this.onSelect,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onNavigate,
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
          child: Row(
            children: [
              GestureDetector(
                onTap: onPlayPause,
                child: Container(
                  height: 40.h,
                  width: 40.w,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: AColors.primaryColor, width: 1.5)),
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                    size: 30,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sound.soundName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    "(${sound.code})",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11.sp,
                      color: Colors.black.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (!isComingFromPlayOption)
                    Text(
                      sound.category,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11.sp,
                        color: Colors.black.withOpacity(0.6),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                ],
              ),
              const Spacer(),
              isComingFromPlayOption
                  ? Container(
                      height: 25.h,
                      width: 25.w,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: AColors.primaryColor),
                      child: Center(
                        child: Text(
                          sound.id.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    )
                  : Checkbox(
                      value: isChecked,
                      checkColor: Colors.white,
                      activeColor: AColors.primaryColor.withOpacity(0.8),
                      onChanged: (value) => onSelect(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
