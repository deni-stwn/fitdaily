import 'package:equatable/equatable.dart';

import '../../../domain/entities/devices_overview.dart';

abstract class FaqState extends Equatable {
  const FaqState();

  @override
  List<Object?> get props => [];
}

class FaqInitial extends FaqState {}

class FaqLoading extends FaqState {}

class FaqLoaded extends FaqState {
  /// All topics.
  final List<FaqItem> items;

  /// Search text (empty → all topics).
  final String query;

  /// Ids of the open accordions.
  final Set<String> expanded;

  const FaqLoaded({
    required this.items,
    this.query = '',
    this.expanded = const {},
  });

  /// Topics matching [query] (question or answer, case-insensitive).
  List<FaqItem> get visible {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return items;
    return [
      for (final item in items)
        if (item.question.toLowerCase().contains(q) ||
            item.answer.toLowerCase().contains(q))
          item,
    ];
  }

  FaqLoaded copyWith({String? query, Set<String>? expanded}) => FaqLoaded(
    items: items,
    query: query ?? this.query,
    expanded: expanded ?? this.expanded,
  );

  @override
  List<Object?> get props => [items, query, expanded];
}

class FaqError extends FaqState {
  final String message;

  const FaqError(this.message);

  @override
  List<Object?> get props => [message];
}
