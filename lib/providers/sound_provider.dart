import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/data_source/local/sound_data.dart';
import '../domain/entities/sound.dart';

// Define a provider for the sound list
final soundListProvider = Provider<List<Sound>>((ref) {
  return soundData;
});
