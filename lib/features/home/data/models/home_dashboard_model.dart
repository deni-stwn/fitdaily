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
    required super.movingTime,
    required super.mood,
    required super.activity,
    required super.sleep,
    required super.notifications,
  });

  factory HomeDashboardModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>;
    final quote = json['quote'] as Map<String, dynamic>;
    final heart = json['heart_rate'] as Map<String, dynamic>;
    final mood = json['mood'] as Map<String, dynamic>;
    final activity = json['activity'] as Map<String, dynamic>;
    final sleep = json['sleep'] as Map<String, dynamic>;

    List<double> doubles(Object? list) =>
        (list! as List).map((e) => (e as num).toDouble()).toList();

    WeeklyMetric metric(Map<String, dynamic> m) => WeeklyMetric(
      value: m['value'] as int,
      goal: m['goal'] as int,
      days: doubles(m['days']),
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
      movingTime: metric(json['moving_time'] as Map<String, dynamic>),
      mood: MoodSummary(
        label: mood['label'] as String,
        message: mood['message'] as String,
      ),
      activity: HomeActivitySummary(
        percent: activity['percent'] as int,
        goalMinutes: activity['goal_minutes'] as int,
        days: doubles(activity['days']),
      ),
      sleep: SleepSummary(
        hours: sleep['hours'] as int,
        minutes: sleep['minutes'] as int,
        stages: [
          for (final st in sleep['stages'] as List)
            SleepStage(
              x: ((st as List)[0] as num).toDouble(),
              width: (st[1] as num).toDouble(),
              level: st[2] as int,
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
