import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../core/constants/dummy_assets.dart';
import '../models/training_setup_model.dart';

abstract class TrainingLocalDataSource {
  Future<TrainingSetupModel> fetchSetup();
}

/// Dummy data (no backend / GPS): `assets/dummy/training.json`.
class TrainingLocalDataSourceImpl implements TrainingLocalDataSource {
  TrainingLocalDataSourceImpl();

  @override
  Future<TrainingSetupModel> fetchSetup() async {
    final raw = await rootBundle.loadString(DummyAssets.training);
    return TrainingSetupModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }
}
