import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/sound.dart';

// StateNotifier to manage the list of checked sounds
class CheckedItemsNotifier extends StateNotifier<List<Sound>> {
  CheckedItemsNotifier() : super([]);

  // Add or remove the sound from the list
  void toggleItem(Sound sound) {
    if (state.contains(sound)) {
      state = state.where((item) => item != sound).toList();
    } else {
      state = [...state, sound];
    }
  }

  void toggleSelectAll(bool selectAll, List<Sound> soundList) {
    if (selectAll) {
      state = [...soundList]; // Select all items
    } else {
      state = []; // Deselect all items
    }
  }
}

// Provider for the checked items
final checkedItemsProvider =
    StateNotifierProvider<CheckedItemsNotifier, List<Sound>>(
  (ref) => CheckedItemsNotifier(),
);
