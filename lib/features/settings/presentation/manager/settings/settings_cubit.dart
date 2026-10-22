import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/mixin/cancelable_safe_cubit_mixin.dart';
import '../../../domain/entities/user_settings.dart';
import '../../../domain/usecases/get_settings_usecase.dart';
import '../../../domain/usecases/save_settings_usecase.dart';
import 'settings_state.dart';

/// One cubit per settings screen: loads the stored settings, keeps the edits
/// as a draft and writes them back on "Save" (dummy, in memory).
class SettingsCubit extends Cubit<SettingsState>
    with CancelableSafeCubitMixin<SettingsState> {
  SettingsCubit(this._getSettings, this._saveSettings)
    : super(SettingsInitial());

  final GetSettingsUseCase _getSettings;
  final SaveSettingsUseCase _saveSettings;

  Future<void> loadData() async {
    safeEmit(SettingsLoading());
    final result = await runCancelable(_getSettings.call());
    if (result == null) return;
    result.fold(
      (failure) => safeEmit(SettingsError(failure.message)),
      (settings) => safeEmit(SettingsLoaded(settings)),
    );
  }

  /// Edits the draft (no-op until loaded).
  void update(UserSettings Function(UserSettings settings) change) {
    final current = state;
    if (current is SettingsLoaded) {
      safeEmit(SettingsLoaded(change(current.settings)));
    }
  }

  /// Stores the draft; true on success.
  Future<bool> save() async {
    final current = state;
    if (current is! SettingsLoaded) return false;
    final result = await _saveSettings(current.settings);
    if (isClosed) return false;
    return result.fold(
      (failure) {
        safeEmit(SettingsError(failure.message));
        return false;
      },
      (saved) {
        safeEmit(SettingsLoaded(saved));
        return true;
      },
    );
  }
}
