import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:superhorn/screens/widgets/search_field_widget.dart';

import '../core/theme/colors.dart';
import '../data/data_source/local/sound_data.dart';
import '../domain/entities/sound.dart';
import '../providers/checked_item_provider.dart';
import '../providers/sound_provider.dart';
import '../screens/widgets/navigation_drawer_widget.dart';

class Homescreen extends ConsumerStatefulWidget {
  Homescreen({super.key});

  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends ConsumerState<Homescreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

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
    final checkedItems = ref.watch(checkedItemsProvider);

    bool isAllSelected = checkedItems.length == _filteredSounds.length &&
        _filteredSounds.isNotEmpty; // Determines "Select All" state

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Home',
            style: TextStyle(
              fontFamily: 'JosefinSans',
            ),
          ),
          backgroundColor: Colors.transparent,
          actions: [
            Row(
              children: [
                Text(
                  "Select All",
                  style: TextStyle(
                      fontFamily: 'JosefinSans',
                      color: Colors.black,
                      fontSize: 14.sp),
                ),
                Checkbox(
                  checkColor: Colors.white,
                  activeColor: AColors.primaryColor.withOpacity(0.8),
                  value: isAllSelected,
                  onChanged: (bool? value) {
                    ref
                        .read(checkedItemsProvider.notifier)
                        .toggleSelectAll(value ?? false, _filteredSounds);
                  },
                ),
                // Filter button
                PopupMenuButton<String>(
                  icon: const Icon(Icons.filter_list, color: Colors.black),
                  onSelected: (value) {
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
              ],
            ),
          ],
        ),
        onDrawerChanged: (isOpened) {
          if (isOpened) {
            _searchFocusNode.unfocus();
          }
        },
        drawer: MyDrawer(),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.png'),
              fit: BoxFit.cover, // Ensures the image covers the entire screen
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                // Search Field
                SearchFieldWidget(
                  searchController: _searchController,
                  focusNode: _searchFocusNode,
                ),
                SizedBox(height: 10.h),
                // List of filtered sounds
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredSounds.length,
                    itemBuilder: (context, index) {
                      bool isPlaying = _currentlyPlayingIndex == index;
                      bool isChecked =
                          checkedItems.contains(_filteredSounds[index]);

                      return Card(
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 7),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _filteredSounds[index].soundName,
                                      overflow: TextOverflow.ellipsis,
                                      // Adds ellipsis when text overflows
                                      style: TextStyle(
                                        fontFamily: 'JosefinSans',
                                        fontSize: 16.sp,
                                        color: AColors.primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      "(${_filteredSounds[index].code})",
                                      overflow: TextOverflow.ellipsis,
                                      // Adds ellipsis when text overflows

                                      style: TextStyle(
                                        fontFamily: 'JosefinSans',
                                        fontSize: 12.sp,
                                        color: AColors.primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      _filteredSounds[index].category,
                                      style: TextStyle(
                                        fontFamily: 'JosefinSans',
                                        fontSize: 12.sp,
                                        color: AColors.primaryColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),

                              // Play button
                              GestureDetector(
                                onTap: () {
                                  _playPauseHornSound(
                                      _filteredSounds[index].hornSound!, index);
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        AColors.primaryColor.withOpacity(0.8),
                                  ),
                                  child: Icon(
                                    isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow_outlined,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              // Checkbox for individual items
                              Checkbox(
                                value: isChecked,
                                checkColor: Colors.white,
                                activeColor:
                                    AColors.primaryColor.withOpacity(0.8),
                                // Set the fill color (background when checked)

                                onChanged: (bool? value) {
                                  if (value != null) {
                                    ref
                                        .read(checkedItemsProvider.notifier)
                                        .toggleItem(_filteredSounds[index]);
                                  }
                                },
                              ),
                            ],
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
    );
  }
}
