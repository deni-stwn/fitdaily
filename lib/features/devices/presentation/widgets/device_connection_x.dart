import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/device_state_tile.dart';
import '../../domain/entities/devices_overview.dart';

/// UI mapping of [DeviceConnection].
extension DeviceConnectionX on DeviceConnection {
  /// "Connected" / "Connecting" / "Not Connected".
  String get labelKey => switch (this) {
    DeviceConnection.connected => LocaleKeys.devices_connected,
    DeviceConnection.connecting => LocaleKeys.devices_connecting,
    DeviceConnection.disconnected => LocaleKeys.devices_not_connected,
  };

  /// Figma *Device State* variant.
  DeviceStateVariant get variant => switch (this) {
    DeviceConnection.connected => DeviceStateVariant.pairing,
    DeviceConnection.connecting => DeviceStateVariant.connecting,
    DeviceConnection.disconnected => DeviceStateVariant.disconnect,
  };
}
