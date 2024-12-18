// sound_data.dart

class Sound {
  final int id;
  final String code;
  final String soundName;
  final String category;
  String? hornSound;

  Sound(
      {required this.id,
      required this.code,
      required this.soundName,
      required this.category,
      this.hornSound});
}
