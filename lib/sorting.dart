import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SortingScreen extends StatefulWidget {
  @override
  _SortingScreenState createState() => _SortingScreenState();
}

class _SortingScreenState extends State<SortingScreen> {
  String _sortingPreference = 'title';

  @override
  void initState() {
    super.initState();
    _loadSortingPreference();
  }

  void _loadSortingPreference() async {
    final preferences = await SharedPreferences.getInstance();
    setState(() {
      _sortingPreference = preferences.getString('sorting_preference') ?? 'title';
    });
  }

  void _saveSortingPreference(String value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('sorting_preference', value);
    setState(() {
      _sortingPreference = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sorting Preferences'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('Sort by Title'),
              leading: Radio(
                value: 'title',
                groupValue: _sortingPreference,
                onChanged: (value) {
                  _saveSortingPreference(value!);
                },
              ),
            ),
            ListTile(
              title: Text('Sort by Author'),
              leading: Radio(
                value: 'author',
                groupValue: _sortingPreference,
                onChanged: (value) {
                  _saveSortingPreference(value!);
                },
              ),
            ),
            ListTile(
              title: Text('Sort by Rating'),
              leading: Radio(
                value: 'rating',
                groupValue: _sortingPreference,
                onChanged: (value) {
                  _saveSortingPreference(value!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
