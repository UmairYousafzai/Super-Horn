// StateNotifier to manage the selected sound number
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SoundNotifier extends StateNotifier<int> {
  SoundNotifier() : super(0); // Initialize with sound 1

  // Increment sound number, ensuring it stays within 1-40
  void increment() {
    if (state < 40) {
      state++;
    }
  }

  // Decrement sound number, ensuring it stays within 1-40
  void decrement() {
    if (state > 1) {
      state--;
    }
  }

  // Reset sound number to 1
  void reset() {
    state = 1;
  }

  // Set a specific sound number
  void setSound(int soundNumber) {
    if (soundNumber >= 1 && soundNumber <= 40) {
      state = soundNumber;
    }
  }
}

// Riverpod provider for the sound controller
final deviceSoundProvider = StateNotifierProvider<SoundNotifier, int>((ref) {
  return SoundNotifier();
});
