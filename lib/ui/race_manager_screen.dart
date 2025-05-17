import 'package:flutter/material.dart';
import 'package:race_tracking_app/ui/dashboard_screen.dart';
import 'package:race_tracking_app/ui/participant_screen.dart';
import 'package:race_tracking_app/ui/race_control_screen.dart';
import 'package:race_tracking_app/utils/widgets/bottom_nav_bar.dart';

class ManagerScreen extends StatefulWidget {
  const ManagerScreen({super.key});

  @override
  State<ManagerScreen> createState() => _ManagerScreenState();
}

class _ManagerScreenState extends State<ManagerScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    ParticipantListScreen(),
    RaceControlScreen(),
    ResultScreen(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Race Manager')),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}
