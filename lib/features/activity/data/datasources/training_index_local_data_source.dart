import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../core/constants/dummy_assets.dart';
import '../../domain/entities/training_index.dart';
import '../models/training_index_model.dart';

abstract class TrainingIndexLocalDataSource {
  Future<TrainingIndexModel> fetchTrainingIndex(TrainingIndexKind kind);
}

/// Dummy data (no backend): `assets/dummy/training_index.json`.
class TrainingIndexLocalDataSourceImpl implements TrainingIndexLocalDataSource {
  TrainingIndexLocalDataSourceImpl();

  @override
  Future<TrainingIndexModel> fetchTrainingIndex(TrainingIndexKind kind) async {
    final raw = await rootBundle.loadString(DummyAssets.trainingIndex);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final key = switch (kind) {
      TrainingIndexKind.fitnessCondition => 'fitness_condition',
      TrainingIndexKind.vo2Max => 'vo2_max',
    };
    return TrainingIndexModel.fromJson(json[key] as Map<String, dynamic>);
  }
}
