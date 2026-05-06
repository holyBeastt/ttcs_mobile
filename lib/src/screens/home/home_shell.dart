import 'package:flutter/material.dart';

import 'package:mobile/src/state/auth_controller.dart';
import 'package:mobile/src/screens/announcements/announcement_list_screen.dart';
import 'package:mobile/src/screens/guest_lecturers/guest_lecturer_list_screen.dart';
import 'package:mobile/src/screens/profile/profile_screen.dart';
import 'package:mobile/src/config/injector.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authController = getIt<AuthController>();
    final user = authController.currentUser!;
    final pages = [
      AnnouncementListScreen(user: user),
      const GuestLecturerListScreen(),
      ProfileScreen(user: user),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentIndex == 0
              ? 'Thông báo'
              : _currentIndex == 1
                  ? 'Giảng viên mời'
                  : 'Hồ sơ',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: Text(
                user.fullName,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          IconButton(
            onPressed: getIt<AuthController>().logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
          ),
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: 'Thông báo',
          ),
          NavigationDestination(
            icon: Icon(Icons.badge_outlined),
            selectedIcon: Icon(Icons.badge),
            label: 'Giảng viên mời',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Hồ sơ',
          ),
        ],
      ),
    );
  }
}
