import 'package:flutter/material.dart';

import 'package:mobile/src/app.dart';
import 'package:mobile/src/config/injector.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupInjector();
  runApp(const MobileApp());
}
