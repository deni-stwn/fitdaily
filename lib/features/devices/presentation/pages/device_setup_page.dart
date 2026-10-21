import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routing/route_names.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/card_scaffold.dart';
import '../../../../shared/widgets/setup_scaffold.dart';
import '../manager/device/device_cubit.dart';
import '../widgets/device_list_box.dart';

/// Figma: Device Setup - Find Device (683:53930) → Pairing Device
/// (683:53955) once the dummy scan finishes.
class DeviceSetupPage extends StatelessWidget {
  const DeviceSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DeviceCubit>()..loadData(),
      child: SetupScaffold(
        illustration: const CardIllustration(
          asset: 'assets/images/device_watch_illustration.png',
          width: 141,
          height: 173.5,
          top: 154,
          left: 150,
        ),
        title: LocaleKeys.device_setup_title.tr(context: context),
        subtitle: LocaleKeys.device_setup_subtitle.tr(context: context),
        primaryLabel: LocaleKeys.device_setup_continue.tr(context: context),
        onPrimary: () => context.go(RouteNames.kRootPage),
        children: const [DeviceListBox()],
      ),
    );
  }
}
