import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/data_source/local/sound_data.dart';
import '../domain/entities/sound.dart';

// StateNotifier to manage the currently selected sound index
class SoundSelectionNotifier extends StateNotifier<int> {
  final List<Sound> sounds;

  SoundSelectionNotifier(this.sounds)
      : super(0); // Initialize with the first sound

  // Get the currently selected sound
  Sound get currentSound => sounds[state];

  // Move to the next sound
  void next() {
    if (state < sounds.length - 1) {
      state++;
    }
  }

  // Move to the previous sound
  void previous() {
    if (state > 0) {
      state--;
    }
  }

  // Select a specific sound by index
  void selectSound(int index) {
    if (index >= 0 && index < sounds.length) {
      state = index;
    }
  }
}

// Provider for the sound list
final soundListProvider = Provider<List<Sound>>((ref) {
  return soundData;
});

// StateNotifierProvider for the selected sound
final soundSelectionProvider =
    StateNotifierProvider<SoundSelectionNotifier, int>((ref) {
  final sounds = ref.watch(soundListProvider);
  return SoundSelectionNotifier(sounds);
});

// Provider to get the currently selected sound
final currentSoundProvider = Provider<Sound>((ref) {
  final selectedIndex = ref.watch(soundSelectionProvider);
  final sounds = ref.watch(soundListProvider);
  return sounds[selectedIndex];
});
