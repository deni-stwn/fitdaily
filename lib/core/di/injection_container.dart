import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../features/devices/devices_injection.dart';
import '../../features/home/home_injection.dart';
import '../../features/theme/theme_injection.dart';
import '../../features/user_setup/user_setup_injection.dart';
import '../localization/localization_service.dart';
import '../storage/secure_storage_service.dart';
import '../storage/shared_prefs_service.dart';

final sl = GetIt.instance; // sl = Service Locator

Future<void> initCore() async {
  // Storage
  await Hive.initFlutter();

  await SharedPreferencesService.init();
  await LocalizationService.initialize();
  sl.registerLazySingleton(() => SharedPreferencesService());
  sl.registerLazySingleton(() => LocalizationService());
  sl.registerLazySingleton(
    () => SecureStorageService(
      const FlutterSecureStorage(
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock_this_device,
        ),
      ),
    ),
  );

  initTheme();

  // Features
  initHome();
  initUserSetup();
  initDevices();
}
