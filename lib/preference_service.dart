import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  Future<void> saveThemePreference(bool isDarkMode) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('is_dark_mode', isDarkMode);
  }

  Future<bool> getThemePreference() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool('is_dark_mode') ?? false;
  }

  Future<void> saveSortingPreference(String sortingPreference) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('sorting_preference', sortingPreference);
  }

  Future<String?> getSortingPreference() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString('sorting_preference');
  }
}
