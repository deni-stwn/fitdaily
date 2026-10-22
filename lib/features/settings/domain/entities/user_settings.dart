import 'package:equatable/equatable.dart';

/// Personal Info (683:53705). Values are display strings (dummy data).
class UserProfile extends Equatable {
  const UserProfile({
    required this.name,
    required this.avatar,
    required this.fullName,
    required this.birthDate,
    required this.weight,
    required this.height,
    required this.username,
  });

  /// Greeting name ("Hi, Brian.").
  final String name;
  final String avatar;
  final String fullName;

  /// e.g. "20th January 2022".
  final String birthDate;
  final String weight;
  final String height;
  final String username;

  UserProfile copyWith({
    String? fullName,
    String? birthDate,
    String? weight,
    String? height,
    String? username,
  }) => UserProfile(
    name: name,
    avatar: avatar,
    fullName: fullName ?? this.fullName,
    birthDate: birthDate ?? this.birthDate,
    weight: weight ?? this.weight,
    height: height ?? this.height,
    username: username ?? this.username,
  );

  @override
  List<Object?> get props => [
    name,
    avatar,
    fullName,
    birthDate,
    weight,
    height,
    username,
  ];
}

/// Health Settings (683:53732).
class HealthSettings extends Equatable {
  const HealthSettings({required this.units, required this.heartRateZone});

  final String units;
  final String heartRateZone;

  HealthSettings copyWith({String? units, String? heartRateZone}) =>
      HealthSettings(
        units: units ?? this.units,
        heartRateZone: heartRateZone ?? this.heartRateZone,
      );

  @override
  List<Object?> get props => [units, heartRateZone];
}

/// Notifications Settings (683:54653).
class NotificationSettings extends Equatable {
  const NotificationSettings({
    required this.reminders,
    required this.reminderTime,
    required this.reminderUnit,
    required this.inactivityAlerts,
    required this.sleepReminders,
  });

  final bool reminders;
  final String reminderTime;
  final String reminderUnit;
  final bool inactivityAlerts;
  final bool sleepReminders;

  NotificationSettings copyWith({
    bool? reminders,
    String? reminderTime,
    String? reminderUnit,
    bool? inactivityAlerts,
    bool? sleepReminders,
  }) => NotificationSettings(
    reminders: reminders ?? this.reminders,
    reminderTime: reminderTime ?? this.reminderTime,
    reminderUnit: reminderUnit ?? this.reminderUnit,
    inactivityAlerts: inactivityAlerts ?? this.inactivityAlerts,
    sleepReminders: sleepReminders ?? this.sleepReminders,
  );

  @override
  List<Object?> get props => [
    reminders,
    reminderTime,
    reminderUnit,
    inactivityAlerts,
    sleepReminders,
  ];
}

/// Privacy & Data (683:53746).
class PrivacySettings extends Equatable {
  const PrivacySettings({
    required this.media,
    required this.dataShare,
    required this.contact,
  });

  final bool media;
  final bool dataShare;
  final bool contact;

  PrivacySettings copyWith({bool? media, bool? dataShare, bool? contact}) =>
      PrivacySettings(
        media: media ?? this.media,
        dataShare: dataShare ?? this.dataShare,
        contact: contact ?? this.contact,
      );

  @override
  List<Object?> get props => [media, dataShare, contact];
}

/// Dropdown options of the settings forms.
class SettingsOptions extends Equatable {
  const SettingsOptions({
    required this.units,
    required this.heartRateZones,
    required this.reminderUnits,
    required this.languages,
  });

  final List<String> units;
  final List<String> heartRateZones;
  final List<String> reminderUnits;

  /// Locale codes (`en`, `ar`).
  final List<String> languages;

  @override
  List<Object?> get props => [units, heartRateZones, reminderUnits, languages];
}

/// Everything behind the Setting panel (683:54836) and its sub pages.
class UserSettings extends Equatable {
  const UserSettings({
    required this.profile,
    required this.health,
    required this.notifications,
    required this.privacy,
    required this.language,
    required this.options,
  });

  final UserProfile profile;
  final HealthSettings health;
  final NotificationSettings notifications;
  final PrivacySettings privacy;

  /// App Settings (683:53770): locale code.
  final String language;
  final SettingsOptions options;

  UserSettings copyWith({
    UserProfile? profile,
    HealthSettings? health,
    NotificationSettings? notifications,
    PrivacySettings? privacy,
    String? language,
  }) => UserSettings(
    profile: profile ?? this.profile,
    health: health ?? this.health,
    notifications: notifications ?? this.notifications,
    privacy: privacy ?? this.privacy,
    language: language ?? this.language,
    options: options,
  );

  @override
  List<Object?> get props => [
    profile,
    health,
    notifications,
    privacy,
    language,
    options,
  ];
}
