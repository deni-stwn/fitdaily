import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/mixin/cancelable_safe_cubit_mixin.dart';
import '../../../domain/usecases/get_faqs_usecase.dart';
import 'faq_state.dart';

/// Devices - FAQ (683:54678): search + accordions.
class FaqCubit extends Cubit<FaqState> with CancelableSafeCubitMixin<FaqState> {
  final GetFaqsUseCase _getFaqs;

  FaqCubit(this._getFaqs) : super(FaqInitial());

  Future<void> loadData() async {
    safeEmit(FaqLoading());

    final result = await runCancelable(_getFaqs.call());

    if (result == null) return;

    result.fold(
      (failure) => safeEmit(FaqError(failure.message)),
      // The design opens the first topic.
      (items) => safeEmit(
        FaqLoaded(
          items: items,
          expanded: {if (items.isNotEmpty) items.first.id},
        ),
      ),
    );
  }

  void search(String query) {
    final current = state;
    if (current is! FaqLoaded) return;
    safeEmit(current.copyWith(query: query));
  }

  void toggle(String id) {
    final current = state;
    if (current is! FaqLoaded) return;
    final expanded = {...current.expanded};
    if (!expanded.remove(id)) expanded.add(id);
    safeEmit(current.copyWith(expanded: expanded));
  }
}
