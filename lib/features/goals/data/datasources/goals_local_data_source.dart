import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../core/constants/dummy_assets.dart';
import '../models/goals_overview_model.dart';

abstract class GoalsLocalDataSource {
  Future<GoalsOverviewModel> fetchOverview();
}

/// Dummy data (no backend): `assets/dummy/goals.json`.
class GoalsLocalDataSourceImpl implements GoalsLocalDataSource {
  GoalsLocalDataSourceImpl();

  @override
  Future<GoalsOverviewModel> fetchOverview() async {
    final raw = await rootBundle.loadString(DummyAssets.goals);
    return GoalsOverviewModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }
}
