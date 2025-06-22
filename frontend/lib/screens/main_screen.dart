import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'identify_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // IdentifyScreen is at index 1 but not used in the bottom bar itself
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    IdentifyScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onItemTapped(1), // Index for IdentifyScreen
        elevation: 2.0,
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildTabItem(icon: Icons.home, index: 0, text: 'Home'),
            _buildTabItem(icon: Icons.settings, index: 2, text: 'Settings'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({required IconData icon, required int index, required String text}) {
    final color = _selectedIndex == index ? Theme.of(context).primaryColor : Colors.grey;
    return IconButton(
      icon: Icon(icon, color: color),
      onPressed: () => _onItemTapped(index),
      tooltip: text,
    );
  }
} 