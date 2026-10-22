import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../core/constants/dummy_assets.dart';
import '../../domain/entities/user_settings.dart';
import '../models/user_settings_model.dart';

abstract class SettingsLocalDataSource {
  Future<UserSettings> fetchSettings();

  Future<UserSettings> saveSettings(UserSettings settings);
}

/// Dummy data (no backend): `assets/dummy/settings.json`, then kept in
/// memory so "Save" survives while the app runs (registered as singleton).
class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  SettingsLocalDataSourceImpl();

  UserSettings? _cache;

  @override
  Future<UserSettings> fetchSettings() async {
    if (_cache case final cached?) return cached;
    final raw = await rootBundle.loadString(DummyAssets.settings);
    return _cache = UserSettingsModel.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
  }

  @override
  Future<UserSettings> saveSettings(UserSettings settings) async =>
      _cache = settings;
}
