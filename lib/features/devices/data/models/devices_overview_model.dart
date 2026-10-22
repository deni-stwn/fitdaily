import '../../domain/entities/devices_overview.dart';

class UserDeviceModel extends UserDevice {
  const UserDeviceModel({
    required super.id,
    required super.name,
    required super.image,
    required super.connection,
    required super.synced,
    required super.lastSync,
    required super.deviceId,
    required super.deviceName,
    required super.battery,
  });

  factory UserDeviceModel.fromJson(Map<String, dynamic> json) {
    return UserDeviceModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      image: json['image'] as String? ?? '',
      connection:
          DeviceConnection.values.asNameMap()[json['connection']] ??
          DeviceConnection.disconnected,
      synced: json['synced'] as bool? ?? false,
      lastSync: json['last_sync'] as String? ?? '',
      deviceId: json['device_id'] as String? ?? '',
      deviceName: json['device_name'] as String? ?? '',
      battery: json['battery'] as int? ?? 0,
    );
  }
}

class DevicesOverviewModel extends DevicesOverview {
  const DevicesOverviewModel({
    required super.userName,
    required super.avatar,
    required super.paired,
    required super.nearby,
  });

  factory DevicesOverviewModel.fromJson(Map<String, dynamic> json) {
    List<UserDevice> devices(String key) => [
      for (final e in json[key] as List? ?? const [])
        UserDeviceModel.fromJson(e as Map<String, dynamic>),
    ];
    final user = json['user'] as Map<String, dynamic>? ?? const {};
    return DevicesOverviewModel(
      userName: user['name'] as String? ?? '',
      avatar: user['avatar'] as String? ?? '',
      paired: devices('paired'),
      nearby: devices('nearby'),
    );
  }
}

class FaqItemModel extends FaqItem {
  const FaqItemModel({
    required super.id,
    required super.question,
    required super.answer,
  });

  factory FaqItemModel.fromJson(Map<String, dynamic> json) {
    return FaqItemModel(
      id: json['id'] as String? ?? '',
      question: json['question'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
    );
  }
}
