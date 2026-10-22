import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../core/constants/dummy_assets.dart';
import '../models/training_history_model.dart';

abstract class TrainingHistoryLocalDataSource {
  Future<TrainingHistoryModel> fetchHistory();
}

/// Dummy data (no backend): `assets/dummy/training_history.json`.
class TrainingHistoryLocalDataSourceImpl
    implements TrainingHistoryLocalDataSource {
  TrainingHistoryLocalDataSourceImpl();

  @override
  Future<TrainingHistoryModel> fetchHistory() async {
    final raw = await rootBundle.loadString(DummyAssets.trainingHistory);
    return TrainingHistoryModel.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
  }
}
