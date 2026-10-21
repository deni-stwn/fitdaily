import 'package:equatable/equatable.dart';

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
    required this.notifications,
  });

  final String userName;

  /// Asset path.
  final String avatar;
  final Quote quote;
  final WeeklyMetric steps;
  final WeeklyMetric calories;
  final HeartRateSummary heartRate;
  final List<HomeNotification> notifications;

  HomeDashboard copyWith({List<HomeNotification>? notifications}) =>
      HomeDashboard(
        userName: userName,
        avatar: avatar,
        quote: quote,
        steps: steps,
        calories: calories,
        heartRate: heartRate,
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

/// One bar of the heart-rate candle chart, in Figma chart coordinates
/// (357 × 111.56 area).
class ChartBar extends Equatable {
  const ChartBar({required this.left, required this.top, required this.height});

  final double left;
  final double top;
  final double height;

  @override
  List<Object?> get props => [left, top, height];
}

enum HeartZoneType { light, intensive, aerobic, anaerobic, vo2max }

class HeartZone extends Equatable {
  const HeartZone({
    required this.type,
    required this.minutes,
    required this.width,
  });

  final HeartZoneType type;
  final int minutes;

  /// Segment width in the zone bar (Figma px of 384, measured).
  final double width;

  @override
  List<Object?> get props => [type, minutes, width];
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
