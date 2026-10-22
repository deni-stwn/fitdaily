import '../../domain/entities/goals_overview.dart';

/// Parses `assets/dummy/goals.json` (values from Figma).
class GoalsOverviewModel extends GoalsOverview {
  const GoalsOverviewModel({
    required super.userName,
    required super.avatar,
    required super.progress,
    required super.progressFill,
    required super.weekly,
    required super.total,
    required super.goals,
    required super.targets,
  });

  factory GoalsOverviewModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>;
    final progress = json['progress'] as Map<String, dynamic>;
    final targets = json['targets'] as Map<String, dynamic>;
    return GoalsOverviewModel(
      userName: user['name'] as String,
      avatar: user['avatar'] as String,
      progress: progress['percent'] as int,
      progressFill: (progress['fill'] as num).toDouble(),
      weekly: _summary(json['weekly'] as Map<String, dynamic>),
      total: _summary(json['total'] as Map<String, dynamic>),
      goals: [
        for (final g in json['goals'] as List)
          TrackedGoal(
            name: g['name'] as String,
            tracking: g['tracking'] as String,
            status: GoalStatus.values.byName(g['status'] as String),
          ),
      ],
      targets: {
        for (final type in GoalType.values)
          type: [
            for (final t in (targets[type.name] as List? ?? const []))
              t as String,
          ],
      },
    );
  }

  static GoalSummary _summary(Map<String, dynamic> json) => GoalSummary(
    percent: json['percent'] as int,
    bars: [for (final b in json['bars'] as List) (b as num).toDouble()],
  );
}
