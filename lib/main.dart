import 'package:flutter/material.dart';

import 'package:mobile/src/app.dart';
import 'package:mobile/src/config/injector.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupInjector();
  runApp(const MobileApp());
}
