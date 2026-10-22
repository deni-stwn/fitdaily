import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_template/core/errors/failures.dart';
import 'package:flutter_clean_architecture_template/features/settings/domain/entities/user_settings.dart';
import 'package:flutter_clean_architecture_template/features/settings/domain/repositories/settings_repository.dart';
import 'package:flutter_clean_architecture_template/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:flutter_clean_architecture_template/features/settings/domain/usecases/save_settings_usecase.dart';
import 'package:flutter_clean_architecture_template/features/settings/presentation/manager/settings/settings_cubit.dart';
import 'package:flutter_clean_architecture_template/features/settings/presentation/manager/settings/settings_state.dart';
import 'package:flutter_clean_architecture_template/features/settings/presentation/pages/personal_info_page.dart';
import 'package:flutter_test/flutter_test.dart';

const _settings = UserSettings(
  profile: UserProfile(
    name: 'Brian',
    avatar: 'a.png',
    fullName: 'Brian McCall',
    birthDate: '20th January 2022',
    weight: '72',
    height: '182',
    username: 'Brianmc@mail.com',
  ),
  health: HealthSettings(units: 'Matrics', heartRateZone: 'Aerobic (zone 3)'),
  notifications: NotificationSettings(
    reminders: true,
    reminderTime: '12',
    reminderUnit: 'Minutes',
    inactivityAlerts: false,
    sleepReminders: false,
  ),
  privacy: PrivacySettings(media: false, dataShare: false, contact: false),
  language: 'en',
  options: SettingsOptions(
    units: ['Matrics', 'Imperial'],
    heartRateZones: ['Aerobic (zone 3)'],
    reminderUnits: ['Minutes', 'Hours'],
    languages: ['en', 'ar'],
  ),
);

class _Repo implements SettingsRepository {
  _Repo(this.result);

  final Either<Failure, UserSettings> result;
  UserSettings? saved;

  @override
  Future<Either<Failure, UserSettings>> getSettings() async => result;

  @override
  Future<Either<Failure, UserSettings>> saveSettings(
    UserSettings settings,
  ) async {
    saved = settings;
    return Right(settings);
  }
}

SettingsCubit _cubit(_Repo repo) =>
    SettingsCubit(GetSettingsUseCase(repo), SaveSettingsUseCase(repo));

void main() {
  test('loads settings', () async {
    final cubit = _cubit(_Repo(const Right(_settings)));
    await cubit.loadData();
    expect(cubit.state, const SettingsLoaded(_settings));
    await cubit.close();
  });

  test('emits error on failure', () async {
    final cubit = _cubit(_Repo(const Left(UnexpectedFailure('x'))));
    await cubit.loadData();
    expect(cubit.state, const SettingsError('x'));
    await cubit.close();
  });

  test('update edits the draft and save stores it', () async {
    final repo = _Repo(const Right(_settings));
    final cubit = _cubit(repo);
    await cubit.loadData();
    cubit.update((s) => s.copyWith(privacy: s.privacy.copyWith(media: true)));
    expect(repo.saved, isNull);
    expect(await cubit.save(), isTrue);
    expect(repo.saved!.privacy.media, isTrue);
    expect((cubit.state as SettingsLoaded).settings.privacy.media, isTrue);
    await cubit.close();
  });

  test('formats the birth date like Figma', () {
    expect(formatBirthDate(DateTime(2022, 1, 20)), '20th January 2022');
    expect(formatBirthDate(DateTime(2022, 3, 1)), '1st March 2022');
    expect(formatBirthDate(DateTime(2022, 3, 12)), '12th March 2022');
    expect(formatBirthDate(DateTime(2022, 3, 23)), '23rd March 2022');
  });
}
