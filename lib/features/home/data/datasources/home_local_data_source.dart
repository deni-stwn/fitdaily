import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../core/constants/dummy_assets.dart';
import '../models/home_dashboard_model.dart';

abstract class HomeLocalDataSource {
  Future<HomeDashboardModel> fetchDashboard();

  /// Empties the notifications until the app restarts (no backend).
  void clearNotifications();
}

/// Dummy dashboard (no backend): `assets/dummy/home.json`.
class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  HomeLocalDataSourceImpl();

  /// In-memory "Clear All Notification" (lazy singleton → app session).
  bool _cleared = false;

  @override
  Future<HomeDashboardModel> fetchDashboard() async {
    final raw = await rootBundle.loadString(DummyAssets.home);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    if (_cleared) json['notifications'] = <dynamic>[];
    return HomeDashboardModel.fromJson(json);
  }

  @override
  void clearNotifications() => _cleared = true;
}
