import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:library_app/main_screen.dart';
import 'package:library_app/preference_service.dart';
import 'package:library_app/book_provider.dart';

void main() {
  runApp(BookApp());
}

class BookApp extends StatefulWidget {
  const BookApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BookAppState createState() => _BookAppState();
}

class _BookAppState extends State<BookApp> {
  final PreferencesService _preferencesService = PreferencesService();
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  void _loadThemePreference() async {
    _isDarkMode = await _preferencesService.getThemePreference();
    setState(() {});
  }

  void _toggleTheme(bool isDarkMode) {
    setState(() {
      _isDarkMode = isDarkMode;
    });
    _preferencesService.saveThemePreference(isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BookProvider(),
      child: MaterialApp(
        title: 'Book App',
        theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
        home: MainScreen(
          toggleTheme: _toggleTheme,
          isDarkMode: _isDarkMode,
        ),
      ),
    );
  }
}
