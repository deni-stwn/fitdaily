import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../core/constants/dummy_assets.dart';
import '../models/device_model.dart';

abstract class DevicesLocalDataSource {
  Future<List<DeviceModel>> fetchDevices();
}

/// Dummy nearby devices (no Bluetooth): `assets/dummy/devices.json`.
class DevicesLocalDataSourceImpl implements DevicesLocalDataSource {
  DevicesLocalDataSourceImpl();

  /// Simulated scan, so "No Device found" (Find Device, 683:53930) shows
  /// before the list (Pairing Device, 683:53955).
  static const scanDuration = Duration(seconds: 2);

  @override
  Future<List<DeviceModel>> fetchDevices() async {
    await Future.delayed(scanDuration);
    final raw = await rootBundle.loadString(DummyAssets.devices);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return (json['devices'] as List)
        .map((e) => DeviceModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
