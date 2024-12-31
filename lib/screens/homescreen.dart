import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:superhorn/screens/play_horn_with_bluetooth.dart';
import 'package:superhorn/screens/widgets/screen_background_container.dart';
import 'package:superhorn/screens/widgets/search_field_widget.dart';

import '../core/theme/colors.dart';
import '../core/utils/navigations.dart';
import '../data/data_source/local/sound_data.dart';
import '../domain/entities/sound.dart';
import '../providers/checked_item_provider.dart';
import '../providers/sound_provider.dart';
import '../screens/widgets/navigation_drawer_widget.dart';

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
  bool _isSearchActive = false; // Tracks whether the search field is active
  int? _currentlyPlayingIndex; //To Track current playing sound
  List<Sound> _filteredSounds = []; //List that contains the filtered searches
  String _selectedCategory = "All"; // Default category is 'All'

  @override
  void initState() {
    super.initState();
    assignHornSounds(); // Call this before the app starts
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _currentlyPlayingIndex = null;
      });
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
        final isValidSound =
            sound.hornSound != null; // Check if hornSound is assigned
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
      _filterSounds(); // Reapply the filter
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
      await _audioPlayer.play(AssetSource('sounds/$soundFile'));
      setState(() {
        _currentlyPlayingIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final soundNotifier = ref.read(soundSelectionProvider.notifier);
    final checkedItems = ref.watch(checkedItemsProvider);

    bool isAllSelected = checkedItems.length == _filteredSounds.length &&
        _filteredSounds.isNotEmpty; // Determines "Select All" state

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
                title: const Text(
                  'Home',
                  style: TextStyle(
                    fontFamily: 'JosefinSans',
                  ),
                ),
                backgroundColor: Colors.transparent,
                iconTheme: IconThemeData(
                  size: 32.h, // Adjust the size here
                ),
                actions: [
                  Padding(
                    padding: EdgeInsets.only(right: 18.w),
                    child: PopupMenuButton<String>(
                      child: Image.asset(
                        'assets/icons/filter_icon.png',
                        // Replace with your image path
                        width: 24, // Adjust size as needed
                        height: 24,
                      ),
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
                ],
              ),
        onDrawerChanged: (isOpened) {
          if (isOpened) {
            _searchFocusNode.unfocus();
          }
        },
        drawer: widget.isComingFromPlayOption ? null : MyDrawer(),
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
                        bool isPlaying = _currentlyPlayingIndex == index;
                        bool isChecked =
                            checkedItems.contains(_filteredSounds[index]);

                        return GestureDetector(
                          onTap: () {
                            if (widget.isComingFromPlayOption) {
                              soundNotifier.selectSound(index);
                              navigateToScreen(
                                  context, const PlayHornWithBluetooth());
                            }
                          },
                          child: Card(
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 10.w),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _playPauseHornSound(
                                          _filteredSounds[index].hornSound!,
                                          index);
                                    },
                                    child: Container(
                                      height: 40.h,
                                      width: 40.w,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: AColors.primaryColor,
                                              width: 1.5)),
                                      child: Icon(
                                        isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow_rounded,
                                        size: 30,
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 12.w,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _filteredSounds[index].soundName,
                                        overflow: TextOverflow.ellipsis,
                                        // Adds ellipsis when text overflows
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      // SizedBox(height: 5.h),
                                      Text(
                                        "(${_filteredSounds[index].code})",
                                        overflow: TextOverflow.ellipsis,
                                        // Adds ellipsis when text overflows

                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 11.sp,
                                          color: Colors.black.withOpacity(0.6),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      //SizedBox(height: 5.h),
                                      if (widget.isComingFromPlayOption != true)
                                        Text(
                                          _filteredSounds[index].category,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 11.sp,
                                            color:
                                                Colors.black.withOpacity(0.6),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const Spacer(),
                                  widget.isComingFromPlayOption
                                      ? Container(
                                          height: 25.h,
                                          width: 25.w,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AColors.primaryColor),
                                          child: Center(
                                            child: Text(
                                              _filteredSounds[index]
                                                  .id
                                                  .toString(),
                                              overflow: TextOverflow.ellipsis,
                                              // Adds ellipsis when text overflows
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
                                          activeColor: AColors.primaryColor
                                              .withOpacity(0.8),
                                          // Set the fill color (background when checked)

                                          onChanged: (bool? value) {
                                            if (value != null) {
                                              ref
                                                  .read(checkedItemsProvider
                                                      .notifier)
                                                  .toggleItem(
                                                      _filteredSounds[index]);
                                            }
                                          },
                                        ),
                                ],
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
