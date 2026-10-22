import '../../domain/entities/user_settings.dart';

/// Parses `assets/dummy/settings.json` (values from Figma).
class UserSettingsModel extends UserSettings {
  const UserSettingsModel({
    required super.profile,
    required super.health,
    required super.notifications,
    required super.privacy,
    required super.language,
    required super.options,
  });

  factory UserSettingsModel.fromJson(Map<String, dynamic> json) {
    final profile = json['profile'] as Map<String, dynamic>;
    final health = json['health'] as Map<String, dynamic>;
    final notif = json['notifications'] as Map<String, dynamic>;
    final privacy = json['privacy'] as Map<String, dynamic>;
    final options = json['options'] as Map<String, dynamic>;
    List<String> list(String key) =>
        (options[key] as List).cast<String>().toList(growable: false);
    return UserSettingsModel(
      profile: UserProfile(
        name: profile['name'] as String,
        avatar: profile['avatar'] as String,
        fullName: profile['full_name'] as String,
        birthDate: profile['birth_date'] as String,
        weight: profile['weight'] as String,
        height: profile['height'] as String,
        username: profile['username'] as String,
      ),
      health: HealthSettings(
        units: health['units'] as String,
        heartRateZone: health['heart_rate_zone'] as String,
      ),
      notifications: NotificationSettings(
        reminders: notif['reminders'] as bool,
        reminderTime: notif['reminder_time'] as String,
        reminderUnit: notif['reminder_unit'] as String,
        inactivityAlerts: notif['inactivity_alerts'] as bool,
        sleepReminders: notif['sleep_reminders'] as bool,
      ),
      privacy: PrivacySettings(
        media: privacy['media'] as bool,
        dataShare: privacy['data_share'] as bool,
        contact: privacy['contact'] as bool,
      ),
      language: json['language'] as String,
      options: SettingsOptions(
        units: list('units'),
        heartRateZones: list('heart_rate_zones'),
        reminderUnits: list('reminder_units'),
        languages: list('languages'),
      ),
    );
  }
}
