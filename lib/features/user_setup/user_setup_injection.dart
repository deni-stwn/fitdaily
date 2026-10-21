import '../../core/di/injection_container.dart';
import 'presentation/manager/user_setup_cubit.dart';

void initUserSetup() {
  // State Management (scoped to the User Setup routes by a ShellRoute).
  sl.registerFactory(() => UserSetupCubit());
}
