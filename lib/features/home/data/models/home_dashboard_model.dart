import '../../domain/entities/home_dashboard.dart';

/// Parses `assets/dummy/home.json` (values taken from the Figma spec).
class HomeDashboardModel extends HomeDashboard {
  const HomeDashboardModel({
    required super.userName,
    required super.avatar,
    required super.quote,
    required super.steps,
    required super.calories,
    required super.heartRate,
    required super.notifications,
  });

  factory HomeDashboardModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>;
    final quote = json['quote'] as Map<String, dynamic>;
    final heart = json['heart_rate'] as Map<String, dynamic>;

    WeeklyMetric metric(Map<String, dynamic> m) => WeeklyMetric(
      value: m['value'] as int,
      goal: m['goal'] as int,
      days: (m['days'] as List).map((e) => (e as num).toDouble()).toList(),
    );

    return HomeDashboardModel(
      userName: user['name'] as String,
      avatar: user['avatar'] as String,
      quote: Quote(
        text: quote['text'] as String,
        author: quote['author'] as String,
      ),
      steps: metric(json['steps'] as Map<String, dynamic>),
      calories: metric(json['calories'] as Map<String, dynamic>),
      heartRate: HeartRateSummary(
        current: heart['current'] as int,
        min: heart['min'] as int,
        max: heart['max'] as int,
        bars: [
          for (final b in heart['bars'] as List)
            ChartBar(
              left: ((b as List)[0] as num).toDouble(),
              top: (b[1] as num).toDouble(),
              height: (b[2] as num).toDouble(),
            ),
        ],
        zones: [
          for (final z in heart['zones'] as List)
            HeartZone(
              type: HeartZoneType.values.byName(
                (z as Map<String, dynamic>)['zone'] as String,
              ),
              minutes: z['minutes'] as int,
              width: (z['width'] as num).toDouble(),
            ),
        ],
      ),
      notifications: [
        for (final n in json['notifications'] as List)
          HomeNotification(
            type: switch ((n as Map<String, dynamic>)['type'] as String) {
              'calories' => HomeNotificationType.calories,
              'steps' => HomeNotificationType.steps,
              'moving_time' => HomeNotificationType.movingTime,
              'sleep' => HomeNotificationType.sleep,
              _ => HomeNotificationType.stress,
            },
            title: n['title'] as String,
            message: n['message'] as String,
            messageWidth: (n['message_width'] as num?)?.toDouble(),
            minHeight: (n['min_height'] as num?)?.toDouble(),
          ),
      ],
    );
  }
}
