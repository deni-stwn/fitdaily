import 'package:equatable/equatable.dart';

/// Goal status → Figma *Chips* variant (Complete · In Progress · Incomplete).
enum GoalStatus { complete, inProgress, incomplete }

/// Goals offered on "Goals - Create Goals" (683:53393), in Figma order.
enum GoalType { steps, water, calories, sleep, stress }

/// One row of the "Weekly Goals" list (Figma *Menu Item*).
class TrackedGoal extends Equatable {
  const TrackedGoal({
    required this.name,
    required this.tracking,
    required this.status,
  });

  final String name;

  /// Progress text, e.g. "95/95 gram".
  final String tracking;
  final GoalStatus status;

  @override
  List<Object?> get props => [name, tracking, status];
}

/// "Weekly Goals" / "Total Goals" card: percentage + 7 bars (fill heights in
/// Figma px, track 50).
class GoalSummary extends Equatable {
  const GoalSummary({required this.percent, required this.bars});

  final int percent;
  final List<double> bars;

  @override
  List<Object?> get props => [percent, bars];
}

/// Goals tab (683:53318).
class GoalsOverview extends Equatable {
  const GoalsOverview({
    required this.userName,
    required this.avatar,
    required this.progress,
    required this.progressFill,
    required this.weekly,
    required this.total,
    required this.goals,
    required this.targets,
  });

  final String userName;
  final String avatar;

  /// Big progress bar label ("67%").
  final int progress;

  /// Filled part of the big bar (0–1). Figma draws 220 of 424 for "67%",
  /// so the fill is kept separately to match the design.
  final double progressFill;
  final GoalSummary weekly;
  final GoalSummary total;
  final List<TrackedGoal> goals;

  /// Target options of the Commit step's dropdown, per goal.
  final Map<GoalType, List<String>> targets;

  GoalsOverview copyWith({List<TrackedGoal>? goals}) => GoalsOverview(
    userName: userName,
    avatar: avatar,
    progress: progress,
    progressFill: progressFill,
    weekly: weekly,
    total: total,
    goals: goals ?? this.goals,
    targets: targets,
  );

  @override
  List<Object?> get props => [
    userName,
    avatar,
    progress,
    progressFill,
    weekly,
    total,
    goals,
    targets,
  ];
}
