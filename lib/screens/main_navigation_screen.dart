import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'meal_logging.dart';
import 'daily_habits.dart';
import 'goal.dart';

const Color primaryColor = Color(0xFF0ABAB5);
const Color secondaryColor = Color(0xFF56DFCF);

class MainNavigationScreen extends StatefulWidget {
  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    DashboardScreen(),
    MealLoggingScreen(),
    DailyHabitsScreen(),
    GoalsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: primaryColor,
            unselectedItemColor: secondaryColor.withOpacity(0.7),
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            showUnselectedLabels: true,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.dashboard,
                  color: _selectedIndex == 0 ? primaryColor : secondaryColor.withOpacity(0.7),
                ),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.restaurant_menu,
                  color: _selectedIndex == 1 ? primaryColor : secondaryColor.withOpacity(0.7),
                ),
                label: 'Meal Logging',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.check_circle_outline,
                  color: _selectedIndex == 2 ? primaryColor : secondaryColor.withOpacity(0.7),
                ),
                label: 'Daily Habits',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.flag,
                  color: _selectedIndex == 3 ? primaryColor : secondaryColor.withOpacity(0.7),
                ),
                label: 'Goal',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
          ),
        ),
      ),
    );
  }
}
