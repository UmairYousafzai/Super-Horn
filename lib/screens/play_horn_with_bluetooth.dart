import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:superhorn/core/utils/media_query_extension.dart';
import 'package:superhorn/data/data_source/local/device_sound_data.dart';
import 'package:superhorn/screens/widgets/background_image_container.dart';

import '../core/theme/colors.dart';
import '../providers/bluetooth_provider.dart';
import '../providers/device_sound_provider.dart';

class PlayHornWithBluetooth extends ConsumerStatefulWidget {
  const PlayHornWithBluetooth({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SoundPlayScreenState();
}

class _SoundPlayScreenState extends ConsumerState<PlayHornWithBluetooth>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  bool _isAnimating = true;
  Ticker? _ticker; // Add a ticker
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final soundState = ref.watch(deviceSoundProvider);
      _scrollToIndex(deviceSounds.indexOf(soundState.toString()));
    });
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Adjust duration as needed
    )..repeat();

    Future(() {
      final number = ref.watch(deviceSoundProvider);
      ref.read(bluetoothNotifierProvider.notifier).sendData(number.toString());
    });
  }

  void _scrollToIndex(int index) {
    if (index >= 0 && index < deviceSounds.length) {
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
    _animationController?.dispose(); // Dispose of the AnimationController
    _ticker?.dispose(); // Dispose of the Ticker if it exists
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bluetoothNotifier = ref.read(bluetoothNotifierProvider.notifier);
    final bluetoothState = ref.watch(bluetoothNotifierProvider);
    final soundState = ref.watch(deviceSoundProvider);
    final soundNotifier = ref.read(deviceSoundProvider.notifier);

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
                      "Sound $soundState",
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
                        controller: _scrollController, // Add a ScrollController
                        scrollDirection:
                            Axis.horizontal, // Key for horizontal scrolling
                        itemCount: deviceSounds.length,
                        itemBuilder: (context, index) {
                          final currentSound = deviceSounds[index];
                          final bool isSelected =
                              currentSound == soundState.toString();
                          return GestureDetector(
                            onTap: () {
                              final int soundNumber =
                                  int.parse(deviceSounds[index]);
                              ref
                                  .read(deviceSoundProvider.notifier)
                                  .setSound(soundNumber);
                              bluetoothNotifier
                                  .sendData(soundNumber.toString());
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              child: Container(
                                height: isSelected ? 60.h : 50.h,
                                width: isSelected ? 60.h : 50.w,
                                decoration: BoxDecoration(
                                    color: isSelected
                                        ? AColors.primaryColor
                                        : Colors.white,
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: Text(
                                    deviceSounds[index],
                                    overflow: TextOverflow.ellipsis,
                                    // Adds ellipsis when text overflows
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
                                  soundNotifier.decrement();
                                  final soundState =
                                      ref.watch(deviceSoundProvider);
                                  bluetoothNotifier
                                      .sendData(soundState.toString());
                                  _scrollToIndex(deviceSounds
                                      .indexOf(soundState.toString()));
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
                                _animationController!.repeat();
                              } else {
                                _ticker = Ticker((_) {
                                  _animationController!.reset();
                                  _ticker!
                                      .dispose(); // Dispose of the ticker after reset
                                  _ticker = null;
                                });
                                _ticker!.start();
                                if (_animationController?.isAnimating ??
                                    false) {
                                  _animationController?.stop();
                                }
                              }
                            });
                          },
                          child: Lottie.asset(
                            height: 80.h,
                            width: 80.w,
                            "assets/animation/play_animation.json",
                            controller: _animationController,
                          ),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        Column(
                          children: [
                            IconButton(
                                onPressed: () {
                                  soundNotifier.increment();
                                  final soundState =
                                      ref.watch(deviceSoundProvider);
                                  bluetoothNotifier
                                      .sendData(soundState.toString());
                                  _scrollToIndex(deviceSounds
                                      .indexOf(soundState.toString()));
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
                        soundNotifier.reset();
                        final soundState = ref.watch(deviceSoundProvider);
                        bluetoothNotifier.sendData(soundState.toString());
                        _scrollToIndex(
                            deviceSounds.indexOf(soundState.toString()));
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
                      "Sending Data...",
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
