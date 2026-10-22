import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../core/constants/dummy_assets.dart';
import '../../domain/entities/metric_overview.dart';
import '../models/heart_rate_overview_model.dart';
import '../models/metric_overview_model.dart';

abstract class StatsLocalDataSource {
  Future<MetricOverviewModel> fetchOverview(OverviewMetric metric);

  Future<HeartRateOverviewModel> fetchHeartRate();
}

/// Dummy overviews (no backend): `assets/dummy/overview.json`.
class StatsLocalDataSourceImpl implements StatsLocalDataSource {
  StatsLocalDataSourceImpl();

  @override
  Future<MetricOverviewModel> fetchOverview(OverviewMetric metric) async {
    final raw = await rootBundle.loadString(DummyAssets.overview);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return MetricOverviewModel.fromJson(
      json[metric.name] as Map<String, dynamic>,
    );
  }

  @override
  Future<HeartRateOverviewModel> fetchHeartRate() async {
    final raw = await rootBundle.loadString(DummyAssets.overview);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return HeartRateOverviewModel.fromJson(
      json['heart_rate'] as Map<String, dynamic>,
    );
  }
}
