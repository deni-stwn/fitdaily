import 'package:equatable/equatable.dart';

class DeviceEntity extends Equatable {
  const DeviceEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.connected,
  });

  final String id;
  final String name;

  /// Asset path of the device photo.
  final String image;
  final bool connected;

  DeviceEntity copyWith({bool? connected}) => DeviceEntity(
    id: id,
    name: name,
    image: image,
    connected: connected ?? this.connected,
  );

  @override
  List<Object?> get props => [id, name, image, connected];
}
