import 'package:flutter/material.dart';
import 'package:library_app/home_screen.dart';
import 'package:library_app/setting_screen.dart';

class MainScreen extends StatelessWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;

  const MainScreen({super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library App'),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
              
              color: const Color.fromARGB(255, 1, 34, 85), // Dark blue color for drawer header
              child: const DrawerHeader(
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.white),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(
                      toggleTheme: toggleTheme,
                      isDarkMode: isDarkMode,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: HomeScreen(),
    );
  }
}
