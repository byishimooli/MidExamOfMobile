import 'package:flutter/material.dart';
import 'package:library_app/sorting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;

  const SettingsScreen({super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  void _saveThemePreference(bool value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('is_dark_mode', value);
    setState(() {
      _isDarkMode = value;
    });
    widget.toggleTheme(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('Dark Mode'),
              trailing: Switch(
                value: _isDarkMode,
                onChanged: (value) {
                  _saveThemePreference(value);
                },
              ),
            ),
            ListTile(
              title: Text('Sorting a Book'),
              trailing: IconButton(
                icon: const Icon(Icons.sort),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SortingScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
