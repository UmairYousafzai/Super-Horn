import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Create a provider to initialize SharedPreferences
final sharedPreferencesProvider =
    Provider<SharedPreferencesNotifier>((ref) => SharedPreferencesNotifier());

class SharedPreferencesNotifier {
  late SharedPreferences _prefs;

  // Save user data to SharedPreferences
  Future<void> saveUserData({
    required String name,
    required String email,
    required String password,
    required String city,
    required String country,
  }) async {
    await _prefs.setString('name', name);
    await _prefs.setString('email', email);
    await _prefs.setString('password', password);
    await _prefs.setString('city', city);
    await _prefs.setString('country', country);
  }

  // Retrieve user data from SharedPreferences
  Map<String, String> getUserData() {
    return {
      'name': _prefs.getString('name') ?? '',
      'email': _prefs.getString('email') ?? '',
      'password': _prefs.getString('password') ?? '',
      'city': _prefs.getString('city') ?? '',
      'country': _prefs.getString('country') ?? '',
    };
  }

  Future<bool> doesUserExist() async {
    _prefs = await SharedPreferences.getInstance();
    final hasUserData = _prefs.getString('name') != null &&
        _prefs.getString('email') != null &&
        _prefs.getString('password') != null;
    return hasUserData;
  }

  // Clear user data from SharedPreferences
  Future<void> clearUserData() async {
    await _prefs.clear();
  }
}
