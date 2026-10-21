import '../../../../core/storage/shared_prefs_service.dart';
import '../../../../core/storage/storage_keys.dart';
import '../../domain/entities/theme_entity.dart';

class ThemeLocalDataSource {
  final SharedPreferencesService sharedPreferencesService;
  ThemeLocalDataSource(this.sharedPreferencesService);

  Future saveTheme(ThemeType themeType) async {
    sharedPreferencesService.saveString(
      StorageKeys.themeKey,
      themeType == ThemeType.dark ? 'dark' : 'light',
    );
  }

  Future getTheme() async {
    final theme = sharedPreferencesService.getString(StorageKeys.themeKey);
    // Design is dark-only, so dark is the default.
    return theme == 'light'
        ? ThemeEntity(type: ThemeType.light)
        : ThemeEntity(type: ThemeType.dark);
  }
}
