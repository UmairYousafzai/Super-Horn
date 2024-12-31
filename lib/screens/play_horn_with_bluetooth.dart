import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:superhorn/core/utils/media_query_extension.dart';
import 'package:superhorn/screens/widgets/background_image_container.dart';
import 'package:superhorn/screens/widgets/horns_animation_widget.dart';

import '../core/theme/colors.dart';
import '../providers/bluetooth_provider.dart';
import '../providers/sound_provider.dart';

class PlayHornWithBluetooth extends ConsumerStatefulWidget {
  const PlayHornWithBluetooth({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SoundPlayScreenState();
}

class _SoundPlayScreenState extends ConsumerState<PlayHornWithBluetooth>
    with TickerProviderStateMixin {
  AnimationController? _animationController;
  bool _isAnimating = true;
  Ticker? _ticker; // Add a ticker
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToIndex(ref.watch(soundSelectionProvider));
    });
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Adjust duration as needed
    )..repeat();

    Future(() {
      final bluetoothNotifier = ref.read(bluetoothNotifierProvider.notifier);
      bluetoothNotifier.sendData(ref.watch(currentSoundProvider).id.toString());
    });
  }

  void _scrollToIndex(int index) {
    final soundList = ref.watch(soundListProvider);

    if (index >= 0 && index < soundList.length) {
      _scrollController.animateTo(
        index * 62.w, // Adjust 56 based on your item width + padding
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose of the ScrollController
    _animationController?.dispose();
    _ticker?.dispose(); // Dispose of the Ticker if it exists
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bluetoothNotifier = ref.read(bluetoothNotifierProvider.notifier);
    final bluetoothState = ref.watch(bluetoothNotifierProvider);
    final currentSound = ref.watch(currentSoundProvider);
    final soundNotifier = ref.read(soundSelectionProvider.notifier);
    final soundList = ref.watch(soundListProvider);

    // Manage Lottie animation state dynamically
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (bluetoothState.isAnimating) {
        _animationController?.repeat();
      } else {
        _animationController?.stop();
      }
    });

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: true,
        ),
        extendBodyBehindAppBar: true,
        body: Stack(children: [
          BackgroundImageContainer(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: context.mqW(0.85),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Image.asset("assets/superhorn.png"),
                        )),
                    SizedBox(
                      height: 16.h,
                    ),
                    Text(
                      currentSound.soundName,
                      overflow: TextOverflow.ellipsis,
                      // Adds ellipsis when text overflows
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 22.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Expanded(
                      child: Center(
                        child: Transform.scale(
                          scale: 0.7,
                          child: SizedBox(
                            width: context.mqW(0.8),
                            // Adjust this width to match the total width of your ImageRowWidget
                            child: ImageRowWidget(
                                isAnimating: bluetoothState.isAnimating),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "Now Playing",
                      overflow: TextOverflow.ellipsis,
                      // Adds ellipsis when text overflows
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12.sp,
                        color: AColors.primaryColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: soundList.length,
                        itemBuilder: (context, index) {
                          final sound = soundList[index];
                          final bool isSelected =
                              index == ref.watch(soundSelectionProvider);

                          return GestureDetector(
                            onTap: () {
                              soundNotifier.selectSound(index);
                              final currentSound =
                                  ref.watch(currentSoundProvider);
                              bluetoothNotifier.sendData(
                                currentSound.id.toString(),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 8.w),
                              height: isSelected ? 60.h : 50.h,
                              width: isSelected ? 60.h : 50.w,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AColors.primaryColor
                                    : Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  sound.id.toString(),
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: isSelected ? 28.sp : 16.sp,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            IconButton(
                                onPressed: () {
                                  soundNotifier.previous();
                                  final currentSound =
                                      ref.watch(currentSoundProvider);
                                  bluetoothNotifier.sendData(
                                    currentSound.id.toString(),
                                  );
                                  _scrollToIndex(
                                      ref.watch(soundSelectionProvider));
                                },
                                icon: Icon(
                                  Icons.skip_previous_rounded,
                                  color: Colors.black,
                                  size: 50.w,
                                )),
                            Text(
                              "Previous",
                              overflow: TextOverflow.ellipsis,
                              // Adds ellipsis when text overflows
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12.sp,
                                color: AColors.primaryColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isAnimating = !_isAnimating;
                              if (_isAnimating) {
                                _animationController?.forward();
                              } else {
                                _animationController?.stop();
                              }
                            });
                          },
                          child: Lottie.asset(
                            height: 80.h,
                            width: 80.w,
                            "assets/animation/play_animation.json",
                            controller: _animationController,
                            onLoaded: (composition) {
                              _animationController?.duration =
                                  composition.duration;
                              if (bluetoothState.isAnimating) {
                                _animationController?.repeat();
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        Column(
                          children: [
                            IconButton(
                                onPressed: () {
                                  soundNotifier.next();
                                  final currentSound =
                                      ref.watch(currentSoundProvider);
                                  bluetoothNotifier.sendData(
                                    currentSound.id.toString(),
                                  );
                                  _scrollToIndex(
                                      ref.watch(soundSelectionProvider));
                                },
                                icon: Icon(
                                  Icons.skip_next_rounded,
                                  color: Colors.black,
                                  size: 50.w,
                                )),
                            Text(
                              "Next",
                              overflow: TextOverflow.ellipsis,
                              // Adds ellipsis when text overflows
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12.sp,
                                color: AColors.primaryColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 35.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        soundNotifier.selectSound(0);
                        final currentSound = ref.watch(currentSoundProvider);
                        bluetoothNotifier.resetData(
                          currentSound.id.toString(),
                        );
                        bluetoothNotifier.setAnimating(false);
                        setState(() {
                          _isAnimating = false;
                          _animationController?.stop();
                        });
                        _scrollToIndex(0);
                      },
                      child: Text(
                        "Reset",
                        overflow: TextOverflow.ellipsis,
                        // Adds ellipsis when text overflows
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14.sp,
                          color: AColors.primaryColor,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline,
                          decorationColor: AColors.primaryColor,
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
          if (bluetoothState.isSendingData)
            Container(
              color: Colors.white.withOpacity(0.5), // Semi-transparent overlay
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: AColors.primaryColor,
                    ),
                    SizedBox(height: 20.h),
                    const Text(
                      "Playing Sound...",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (bluetoothState.isResettingData)
            Container(
              color: Colors.white.withOpacity(0.5), // Semi-transparent overlay
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: AColors.primaryColor,
                    ),
                    SizedBox(height: 20.h),
                    const Text(
                      "Resetting...",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ]),
      ),
    );
  }
}
