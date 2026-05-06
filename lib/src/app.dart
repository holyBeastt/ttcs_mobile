import 'package:flutter/material.dart';

import 'package:mobile/src/screens/auth/login_screen.dart';
import 'package:mobile/src/screens/home/home_shell.dart';
import 'package:mobile/src/state/auth_controller.dart';
import 'package:mobile/src/config/injector.dart';

class MobileApp extends StatefulWidget {
  const MobileApp({super.key});

  @override
  State<MobileApp> createState() => _MobileAppState();
}

class _MobileAppState extends State<MobileApp> {
  @override
  void initState() {
    super.initState();
    getIt<AuthController>().bootstrap();
  }

  @override
  void dispose() {
    getIt<AuthController>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: getIt<AuthController>(),
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
    final authController = getIt<AuthController>();

    if (!authController.initialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (authController.isAuthenticated) {
      return const HomeShell();
    }

    return const LoginScreen();
  }
}
