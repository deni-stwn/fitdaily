import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../core/constants/dummy_assets.dart';
import '../../domain/entities/devices_overview.dart';
import '../models/device_model.dart';
import '../models/devices_overview_model.dart';

abstract class DevicesLocalDataSource {
  Future<List<DeviceModel>> fetchDevices();

  /// Devices tab (683:53253): cards + "Add new devices" list.
  Future<DevicesOverview> fetchOverview();

  /// Devices - FAQ (683:54678).
  Future<List<FaqItem>> fetchFaqs();
}

/// Dummy devices (no Bluetooth): `assets/dummy/devices.json` — `devices`
/// (Device Setup scan), `user`/`paired`/`nearby` (Devices tab), `faqs`.
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

  Future<Map<String, dynamic>> _load() async {
    final raw = await rootBundle.loadString(DummyAssets.devices);
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  @override
  Future<DevicesOverview> fetchOverview() async {
    return DevicesOverviewModel.fromJson(await _load());
  }

  @override
  Future<List<FaqItem>> fetchFaqs() async {
    final json = await _load();
    return [
      for (final e in json['faqs'] as List? ?? const [])
        FaqItemModel.fromJson(e as Map<String, dynamic>),
    ];
  }
}
