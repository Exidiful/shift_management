import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'calendar_page.dart';
import 'employee_management_page.dart';
import 'shift_periods_page.dart';
import '../providers/theme_provider.dart';
import '../utils/app_theme.dart';
import '../services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const CalendarPage(),
    const EmployeeManagementPage(),
    const ShiftPeriodsPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shift Scheduler', style: TextStyle(fontWeight: FontWeight.w300)),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6, color: AppTheme.primaryColor),
            onPressed: () {
              final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
              themeProvider.toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: AppTheme.primaryColor),
            onPressed: () async => await context.read<AuthService>().signOut(),
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: AppTheme.primaryColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Employees',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Shift Periods',
          ),
        ],
      ),
    );
  }
}