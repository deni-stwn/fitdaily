import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../domain/entities/training_session.dart';
import 'training_type_style.dart';

/// Texts and formatting of each training target. Only "By Distance" is
/// designed (Set Distance / Distance Target / Walking Session); step, time
/// and calories reuse the same modals with their own title and unit.
extension TrainingTargetStyle on TrainingTarget {
  String get icon => 'assets/icons/target_$name.svg';

  /// Input modal header ("Distance target").
  String get inputTitleKey => switch (this) {
    TrainingTarget.step => LocaleKeys.training_step_target_input,
    TrainingTarget.distance => LocaleKeys.training_distance_target_input,
    TrainingTarget.time => LocaleKeys.training_time_target_input,
    TrainingTarget.calories => LocaleKeys.training_calories_target_input,
  };

  /// Pill / active session label ("Distance Target").
  String get labelKey => switch (this) {
    TrainingTarget.step => LocaleKeys.training_step_target,
    TrainingTarget.distance => LocaleKeys.training_distance_target,
    TrainingTarget.time => LocaleKeys.training_time_target,
    TrainingTarget.calories => LocaleKeys.training_calories_target,
  };

  /// Input suffix ("KM").
  String get unitKey => switch (this) {
    TrainingTarget.step => LocaleKeys.training_steps_unit,
    TrainingTarget.distance => LocaleKeys.training_km_unit,
    TrainingTarget.time => LocaleKeys.training_min_unit,
    TrainingTarget.calories => LocaleKeys.training_kcal_unit,
  };

  String get _valueKey => switch (this) {
    TrainingTarget.step => LocaleKeys.training_steps_value,
    TrainingTarget.distance => LocaleKeys.training_km_value,
    TrainingTarget.time => LocaleKeys.training_min_value,
    TrainingTarget.calories => LocaleKeys.training_kcal_value,
  };

  String get _ofKey => switch (this) {
    TrainingTarget.step => LocaleKeys.training_of_steps,
    TrainingTarget.distance => LocaleKeys.training_of_km,
    TrainingTarget.time => LocaleKeys.training_of_min,
    TrainingTarget.calories => LocaleKeys.training_of_kcal,
  };

  /// Distance with one decimal; steps, minutes and kcal as whole numbers.
  bool get decimal => this == TrainingTarget.distance;

  String format(double value) =>
      decimal ? formatKm(value) : value.floor().toString();

  /// "5km" / "5000 steps".
  String valueText(BuildContext context, double value) =>
      _valueKey.tr(context: context, args: [format(value)]);

  /// "/ 5km" / "/ 5000 steps".
  String ofText(BuildContext context, double value) =>
      _ofKey.tr(context: context, args: [format(value)]);
}
