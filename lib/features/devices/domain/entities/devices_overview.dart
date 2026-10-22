import 'package:equatable/equatable.dart';

/// Connection state of a device (Figma *Device State*: Pairing · Connecting
/// · Disconnect).
enum DeviceConnection { connected, connecting, disconnected }

/// A device on the Devices tab (683:53253): the "Heart rate" cards and the
/// "Add new devices" list share the same data; the detail sheet
/// (703:12420) shows all of it.
class UserDevice extends Equatable {
  const UserDevice({
    required this.id,
    required this.name,
    required this.image,
    required this.connection,
    required this.synced,
    required this.lastSync,
    required this.deviceId,
    required this.deviceName,
    required this.battery,
  });

  final String id;

  /// Card / tile title ("Heart rate", "Samsung watch 8 Classic").
  final String name;

  /// Asset path of the device photo.
  final String image;
  final DeviceConnection connection;
  final bool synced;

  /// Time of the last sync, e.g. "12:09".
  final String lastSync;

  /// Detail rows: "ZX47-9Q2L", "Brian’s Watch", 85 (%).
  final String deviceId;
  final String deviceName;
  final int battery;

  UserDevice copyWith({DeviceConnection? connection}) => UserDevice(
    id: id,
    name: name,
    image: image,
    connection: connection ?? this.connection,
    synced: synced,
    lastSync: lastSync,
    deviceId: deviceId,
    deviceName: deviceName,
    battery: battery,
  );

  @override
  List<Object?> get props => [
    id,
    name,
    image,
    connection,
    synced,
    lastSync,
    deviceId,
    deviceName,
    battery,
  ];
}

/// Devices tab content.
class DevicesOverview extends Equatable {
  const DevicesOverview({
    required this.userName,
    required this.avatar,
    required this.paired,
    required this.nearby,
  });

  final String userName;
  final String avatar;

  /// Top row of 3 cards.
  final List<UserDevice> paired;

  /// "Add new devices" list (Device State tiles).
  final List<UserDevice> nearby;

  DevicesOverview copyWith({
    List<UserDevice>? paired,
    List<UserDevice>? nearby,
  }) => DevicesOverview(
    userName: userName,
    avatar: avatar,
    paired: paired ?? this.paired,
    nearby: nearby ?? this.nearby,
  );

  @override
  List<Object?> get props => [userName, avatar, paired, nearby];
}

/// One FAQ entry (Devices - FAQ, 683:54678).
class FaqItem extends Equatable {
  const FaqItem({
    required this.id,
    required this.question,
    required this.answer,
  });

  final String id;
  final String question;
  final String answer;

  @override
  List<Object?> get props => [id, question, answer];
}
