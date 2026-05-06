import 'package:get_it/get_it.dart';
import 'package:mobile/src/services/api_client.dart';
import 'package:mobile/src/services/auth_service.dart';
import 'package:mobile/src/services/announcement_service.dart';
import 'package:mobile/src/services/guest_lecturer_service.dart';
import 'package:mobile/src/services/profile_service.dart';
import 'package:mobile/src/state/auth_controller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/src/services/local_storage_service.dart';

final getIt = GetIt.instance;

Future<void> setupInjector() async {
  final prefs = await SharedPreferences.getInstance();
  const secureStorage = FlutterSecureStorage();

  getIt.registerLazySingleton<LocalStorageService>(
      () => LocalStorageService(secureStorage, prefs));

  getIt.registerLazySingleton<ApiClient>(() => ApiClient());
  
  // Services
  getIt.registerLazySingleton<AuthService>(
      () => AuthService(getIt<ApiClient>()));
  getIt.registerLazySingleton<AnnouncementService>(
      () => AnnouncementService(getIt<ApiClient>()));
  getIt.registerLazySingleton<GuestLecturerService>(
      () => GuestLecturerService(getIt<ApiClient>()));
  getIt.registerLazySingleton<ProfileService>(
      () => ProfileService(getIt<ApiClient>()));
  
  // Controllers
  getIt.registerLazySingleton<AuthController>(
      () => AuthController(getIt<AuthService>(), getIt<LocalStorageService>()));
}
