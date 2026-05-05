import 'package:flutter/material.dart';

import 'package:mobile/src/screens/auth/login_screen.dart';
import 'package:mobile/src/screens/home/home_shell.dart';
import 'package:mobile/src/services/announcement_service.dart';
import 'package:mobile/src/services/api_client.dart';
import 'package:mobile/src/services/auth_service.dart';
import 'package:mobile/src/services/guest_lecturer_service.dart';
import 'package:mobile/src/services/profile_service.dart';
import 'package:mobile/src/state/auth_controller.dart';

class MobileApp extends StatefulWidget {
  const MobileApp({super.key});

  @override
  State<MobileApp> createState() => _MobileAppState();
}

class _MobileAppState extends State<MobileApp> {
  late final ApiClient _apiClient;
  late final AuthService _authService;
  late final AnnouncementService _announcementService;
  late final GuestLecturerService _guestLecturerService;
  late final ProfileService _profileService;
  late final AuthController _authController;

  @override
  void initState() {
    super.initState();
    _apiClient = ApiClient();
    _authService = AuthService(_apiClient);
    _announcementService = AnnouncementService(_apiClient);
    _guestLecturerService = GuestLecturerService(_apiClient);
    _profileService = ProfileService(_apiClient);
    _authController = AuthController(_authService)..bootstrap();
  }

  @override
  void dispose() {
    _authController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _authController,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Lecturer Mobile',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
            useMaterial3: true,
          ),
          home: _buildHome(),
        );
      },
    );
  }

  Widget _buildHome() {
    if (!_authController.initialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_authController.isAuthenticated) {
      return HomeShell(
        authController: _authController,
        announcementService: _announcementService,
        guestLecturerService: _guestLecturerService,
        profileService: _profileService,
      );
    }

    return LoginScreen(authController: _authController);
  }
}
