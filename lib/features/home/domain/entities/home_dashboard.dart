import 'package:equatable/equatable.dart';

import '../../../../shared/models/heart_rate.dart';

export '../../../../shared/models/heart_rate.dart';

/// Everything shown on Home (683:53154) and its notification panel
/// (683:54696).
class HomeDashboard extends Equatable {
  const HomeDashboard({
    required this.userName,
    required this.avatar,
    required this.quote,
    required this.steps,
    required this.calories,
    required this.heartRate,
    required this.movingTime,
    required this.mood,
    required this.activity,
    required this.sleep,
    required this.notifications,
  });

  final String userName;

  /// Asset path.
  final String avatar;
  final Quote quote;
  final WeeklyMetric steps;
  final WeeklyMetric calories;
  final HeartRateSummary heartRate;
  final WeeklyMetric movingTime;
  final MoodSummary mood;
  final HomeActivitySummary activity;
  final SleepSummary sleep;
  final List<HomeNotification> notifications;

  HomeDashboard copyWith({List<HomeNotification>? notifications}) =>
      HomeDashboard(
        userName: userName,
        avatar: avatar,
        quote: quote,
        steps: steps,
        calories: calories,
        heartRate: heartRate,
        movingTime: movingTime,
        mood: mood,
        activity: activity,
        sleep: sleep,
        notifications: notifications ?? this.notifications,
      );

  @override
  List<Object?> get props => [
    userName,
    avatar,
    quote,
    steps,
    calories,
    heartRate,
    movingTime,
    mood,
    activity,
    sleep,
    notifications,
  ];
}

class Quote extends Equatable {
  const Quote({required this.text, required this.author});

  final String text;
  final String author;

  @override
  List<Object?> get props => [text, author];
}

/// Value + goal with 7 daily bar fills (Figma px, track height 50).
class WeeklyMetric extends Equatable {
  const WeeklyMetric({
    required this.value,
    required this.goal,
    required this.days,
  });

  final int value;
  final int goal;
  final List<double> days;

  @override
  List<Object?> get props => [value, goal, days];
}

class HeartRateSummary extends Equatable {
  const HeartRateSummary({
    required this.current,
    required this.min,
    required this.max,
    required this.bars,
    required this.zones,
  });

  final int current;
  final int min;
  final int max;
  final List<ChartBar> bars;
  final List<HeartZone> zones;

  @override
  List<Object?> get props => [current, min, max, bars, zones];
}

/// Home "Mood" card: label (e.g. "Good") and caption.
class MoodSummary extends Equatable {
  const MoodSummary({required this.label, required this.message});

  final String label;
  final String message;

  @override
  List<Object?> get props => [label, message];
}

/// Home "Activity Overview" card: goal progress in percent, goal in
/// minutes and 7 daily bar fills (Figma px, track height 50).
class HomeActivitySummary extends Equatable {
  const HomeActivitySummary({
    required this.percent,
    required this.goalMinutes,
    required this.days,
  });

  final int percent;
  final int goalMinutes;
  final List<double> days;

  @override
  List<Object?> get props => [percent, goalMinutes, days];
}

/// Home "Sleep Monitoring" card: duration and the sleep-stage steps.
class SleepSummary extends Equatable {
  const SleepSummary({
    required this.hours,
    required this.minutes,
    required this.stages,
  });

  final int hours;
  final int minutes;
  final List<SleepStage> stages;

  @override
  List<Object?> get props => [hours, minutes, stages];
}

/// One horizontal step of the sleep chart, in Figma px of the 248×88 chart:
/// [x] start, [width], [level] 0 (top, -14) … 3 (bottom, 88), 34 apart.
class SleepStage extends Equatable {
  const SleepStage({required this.x, required this.width, required this.level});

  final double x;
  final double width;
  final int level;

  @override
  List<Object?> get props => [x, width, level];
}

enum HomeNotificationType { calories, steps, movingTime, sleep, stress }

class HomeNotification extends Equatable {
  const HomeNotification({
    required this.type,
    required this.title,
    required this.message,
    this.messageWidth,
    this.minHeight,
  });

  final HomeNotificationType type;
  final String title;
  final String message;

  /// Fixed text width from Figma (wraps); null = hug (single line).
  final double? messageWidth;

  /// Fixed item height from Figma (item 1 is 84, the others hug at 80).
  final double? minHeight;

  @override
  List<Object?> get props => [type, title, message, messageWidth, minHeight];
}
