import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../core/constants/dummy_assets.dart';
import '../models/home_dashboard_model.dart';

abstract class HomeLocalDataSource {
  Future<HomeDashboardModel> fetchDashboard();
}

/// Dummy dashboard (no backend): `assets/dummy/home.json`.
class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  HomeLocalDataSourceImpl();

  @override
  Future<HomeDashboardModel> fetchDashboard() async {
    final raw = await rootBundle.loadString(DummyAssets.home);
    return HomeDashboardModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }
}
