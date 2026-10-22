import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../core/constants/dummy_assets.dart';
import '../models/activity_overview_model.dart';

abstract class ActivityLocalDataSource {
  Future<ActivityOverviewModel> fetchOverview();
}

/// Dummy data (no backend): `assets/dummy/activity.json`.
class ActivityLocalDataSourceImpl implements ActivityLocalDataSource {
  ActivityLocalDataSourceImpl();

  @override
  Future<ActivityOverviewModel> fetchOverview() async {
    final raw = await rootBundle.loadString(DummyAssets.activity);
    return ActivityOverviewModel.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
  }
}
