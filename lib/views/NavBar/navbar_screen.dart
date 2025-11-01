import 'package:flutter/material.dart';
import 'package:posternova/views/PosterModule/home.dart';
import 'package:posternova/views/ProfileScreen/profile_screen.dart';
import 'package:posternova/views/category/category_screen.dart';
import 'package:posternova/views/createposter/poster_screen.dart';
import 'package:posternova/views/customer/customer_screen.dart';
import 'package:posternova/views/horrorscope/horror_scope.dart';


class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CategoryScreen(),
    const PosterScreen(),
    const HoroscopeScreen(),
    // const ProfileScreen(),
    const CustomerScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1D1E33), Color(0xFF0A0E21)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.purple.shade300,
          unselectedItemColor: Colors.grey.shade600,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 28),
              activeIcon: Icon(Icons.home, size: 28),
              label: 'Home',
            ),

              BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded, size: 28),
              activeIcon: Icon(Icons.grid_view, size: 28),
              label: 'Category',
            ),
                  BottomNavigationBarItem(
              icon: Icon(Icons.edit_outlined, size: 28),
              activeIcon: Icon(Icons.edit, size: 28),
              label: 'Poster',
            ),
         BottomNavigationBarItem(
  icon: Icon(Icons.nightlight_round, size: 28), // 🌙 spooky night
  activeIcon: Icon(Icons.nightlight, size: 28),
  label: 'Horror',
),


             BottomNavigationBarItem(
              icon: Icon(Icons.group_outlined, size: 28),
              activeIcon: Icon(Icons.group, size: 28),
              label: 'Customer',
            ),
          ],
        ),
      ),
    );
  }
}

