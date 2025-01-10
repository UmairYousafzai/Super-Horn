import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:superhorn/screens/play_horn_with_bluetooth.dart';
import 'package:superhorn/screens/widgets/list_view_item.dart';
import 'package:superhorn/screens/widgets/screen_background_container.dart';
import 'package:superhorn/screens/widgets/search_field_widget.dart';

import '../core/theme/colors.dart';
import '../core/utils/navigations.dart';
import '../domain/entities/sound.dart';
import '../providers/checked_item_provider.dart';
import '../providers/shared_pref_provider.dart';
import '../providers/sound_provider.dart';
import 'auth/login_screen.dart';

class Homescreen extends ConsumerStatefulWidget {
  Homescreen(this.isComingFromPlayOption, {super.key});

  final bool isComingFromPlayOption;

  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends ConsumerState<Homescreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchActive = false;
  int? _currentlyPlayingIndex;
  List<Sound> _filteredSounds = [];
  String _selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        setState(() {
          _currentlyPlayingIndex = null;
        });
      }
    });
    final soundList = ref.read(soundListProvider);
    _filteredSounds = List.from(soundList);
    _searchController.addListener(() {
      _filterSounds();
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterSounds() {
    final query = _searchController.text.toLowerCase();
    final soundList = ref.read(soundListProvider);

    setState(() {
      _filteredSounds = soundList.where((sound) {
        final isValidSound = sound.hornSound != null;
        return isValidSound &&
            (sound.soundName.toLowerCase().contains(query) ||
                sound.category.toLowerCase().contains(query)) &&
            (_selectedCategory == "All" ||
                sound.category.toUpperCase() ==
                    _selectedCategory.toUpperCase());
      }).toList();
    });
  }

  void _setCategoryFilter(String category) {
    setState(() {
      _selectedCategory = category;
      _filterSounds();
    });
  }

  void _playPauseHornSound(String? soundFile, int index) async {
    if (soundFile == null) {
      print("Sound file is null for index $index");
      return;
    }

    if (_currentlyPlayingIndex == index) {
      await _audioPlayer.pause();
      setState(() {
        _currentlyPlayingIndex = null;
      });
    } else {
      // Stop any currently playing audio
      await _audioPlayer.stop();
      // Set the state before playing to immediately show pause button
      setState(() {
        _currentlyPlayingIndex = index;
      });
      // Load and play the new audio file
      try {
        await _audioPlayer.setAsset(soundFile);
        await _audioPlayer.play();
      } catch (e) {
        // If there's an error, reset the state
        setState(() {
          _currentlyPlayingIndex = null;
        });
        print("Error playing sound: $e");
      }
    }
  }

  // Rest of the widget code remains exactly the same...
  @override
  Widget build(BuildContext context) {
    // Your existing build method remains unchanged
    final soundNotifier = ref.read(soundSelectionProvider.notifier);
    final checkedItems = ref.watch(checkedItemsProvider);
    final sharedPreferencesNotifier = ref.read(sharedPreferencesProvider);

    bool isAllSelected = checkedItems.length == _filteredSounds.length &&
        _filteredSounds.isNotEmpty;

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
        appBar: widget.isComingFromPlayOption
            ? AppBar(
                automaticallyImplyLeading: true,
                backgroundColor: Colors.transparent,
              )
            : AppBar(
                automaticallyImplyLeading: false,
                title: const Text(
                  'Home',
                  style: TextStyle(
                    fontFamily: 'JosefinSans',
                  ),
                ),
                backgroundColor: Colors.transparent,
                iconTheme: IconThemeData(
                  size: 32.h,
                ),
                actions: [
                  // Filter button
                  Padding(
                    padding: EdgeInsets.only(right: 18.w),
                    child: PopupMenuButton<String>(
                      child: Image.asset(
                        'assets/icons/filter_icon.png',
                        width: 24,
                        height: 24,
                      ),
                      onSelected: (String value) {
                        _setCategoryFilter(value);
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: "All",
                          child: Text(
                            "All",
                            style: TextStyle(
                              fontFamily: 'JosefinSans',
                            ),
                          ),
                        ),
                        const PopupMenuItem(
                          value: "INDONESIA",
                          child: Text(
                            "Indonesia",
                            style: TextStyle(
                              fontFamily: 'JosefinSans',
                            ),
                          ),
                        ),
                        const PopupMenuItem(
                          value: "ENGLISH",
                          child: Text(
                            "English",
                            style: TextStyle(
                              fontFamily: 'JosefinSans',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // More options button (3 vertical dots)
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    padding: EdgeInsets.zero,
                    position: PopupMenuPosition.under,
                    constraints: const BoxConstraints(
                      minWidth: 100,
                      maxWidth: 100,
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: "logout",
                        height: 30, // Reduced height
                        onTap: () async {
                          await sharedPreferencesNotifier.clearUserData();
                          navigatePushAndRemoveUntil(
                              context, const LoginScreen(), false);
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.logout, size: 20),
                            SizedBox(width: 8),
                            Text(
                              "Logout",
                              style: TextStyle(
                                fontFamily: 'JosefinSans',
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
        // onDrawerChanged: (isOpened) {
        //   if (isOpened) {
        //     _searchFocusNode.unfocus();
        //   }
        // },
        // drawer: widget.isComingFromPlayOption ? null : MyDrawer(),
        body: ScreenBackgroundContainer(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 10.w,
                    ),
                    child: _isSearchActive
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
                                    _isSearchActive = true;
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
                  ),
                  if (widget.isComingFromPlayOption == false)
                    Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor: AColors.primaryColor.withOpacity(0.8),
                          value: isAllSelected,
                          onChanged: (bool? value) {
                            ref
                                .read(checkedItemsProvider.notifier)
                                .toggleSelectAll(
                                    value ?? false, _filteredSounds);
                          },
                        ),
                        Text(
                          "Select All",
                          style: TextStyle(
                              fontFamily: 'JosefinSans',
                              color: Colors.black,
                              fontSize: 14.sp),
                        ),
                      ],
                    ),
                  Expanded(
                      child: ListView.builder(
                    itemCount: _filteredSounds.length,
                    itemBuilder: (context, index) {
                      final sound = _filteredSounds[index];
                      final isPlaying = _currentlyPlayingIndex == index;
                      final isChecked = checkedItems.contains(sound);

                      return SoundItem(
                        sound: sound,
                        isPlaying: isPlaying,
                        isChecked: isChecked,
                        isComingFromPlayOption: widget.isComingFromPlayOption,
                        onPlayPause: () {
                          _playPauseHornSound(sound.hornSound, index);
                        },
                        onSelect: () {
                          if (!widget.isComingFromPlayOption) {
                            ref
                                .read(checkedItemsProvider.notifier)
                                .toggleItem(sound);
                          }
                        },
                        onNavigate: widget.isComingFromPlayOption
                            ? () {
                                ref
                                    .read(soundSelectionProvider.notifier)
                                    .selectSound(index);
                                navigateToScreen(
                                    context, const PlayHornWithBluetooth());
                              }
                            : null,
                      );
                    },
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
