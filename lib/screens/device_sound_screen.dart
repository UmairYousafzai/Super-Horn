import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:superhorn/core/utils/navigations.dart';
import 'package:superhorn/data/data_source/local/device_sound_data.dart';
import 'package:superhorn/screens/play_horn_with_bluetooth.dart';
import 'package:superhorn/screens/widgets/background_image_container.dart';
import 'package:superhorn/screens/widgets/search_field_widget.dart';

import '../../core/theme/colors.dart';
import '../providers/device_sound_provider.dart';

class DeviceSoundScreen extends ConsumerStatefulWidget {
  const DeviceSoundScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BluetoothSettingsScreenState();
}

class _BluetoothSettingsScreenState extends ConsumerState<DeviceSoundScreen> {
  bool _isSearchActive = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus;
        setState(() {
          _isSearchActive = false;
          _searchController.clear();
        });
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: BackgroundImageContainer(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _isSearchActive
                      ? SearchFieldWidget(
                          searchController: _searchController,
                          focusNode: _searchFocusNode,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Horn Playlist",
                              style: TextStyle(
                                fontFamily: 'JosefinSans',
                                fontSize: 22.sp,
                                color: AColors.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _isSearchActive =
                                      true; // Activate search field
                                });
                              },
                              icon: Image.asset(
                                "assets/icons/search_icon.png",
                                width: 30.w,
                                height: 30.h,
                              ),
                            ),
                          ],
                        ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: deviceSounds.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            final int soundNumber =
                                int.parse(deviceSounds[index]);
                            ref
                                .read(deviceSoundProvider.notifier)
                                .setSound(soundNumber);

                            navigateToScreen(
                                context, const PlayHornWithBluetooth());
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Container(
                              height: 70.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Text(
                                  "Sound ${deviceSounds[index]}",
                                  overflow: TextOverflow.ellipsis,
                                  // Adds ellipsis when text overflows
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
