import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routing/route_names.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../shared/widgets/app_icon_button.dart';
import '../../../../shared/widgets/app_pill_icon_button.dart';
import '../../../../shared/widgets/brand_effects.dart';
import '../../../../shared/widgets/device_state_tile.dart';
import '../../../../shared/widgets/gradient_border_card.dart';
import '../../../../shared/widgets/greeting_header.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../home/presentation/manager/home/home_cubit.dart';
import '../../../home/presentation/widgets/notification_panel.dart';
import '../manager/devices_overview/devices_overview_cubit.dart';
import '../manager/devices_overview/devices_overview_state.dart';
import '../widgets/device_connection_x.dart';
import '../widgets/device_detail_sheet.dart';
import '../widgets/paired_device_card.dart';

/// Figma: Devices (683:53253) — tab Devices of the navbar shell. Tapping a
/// card or tile opens Devices - Detail (703:12420).
class DevicesPage extends StatelessWidget {
  const DevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<DevicesOverviewCubit>()..loadData()),
        // Notification panel (bell) reads the Home notifications.
        BlocProvider(create: (_) => sl<HomeCubit>()..loadData()),
      ],
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          body: AppBackground(
            child: Stack(
              children: [
                // figma: "light effect" #1F076E 582×376 at (-71, -190).
                Positioned(
                  left: -71.w,
                  top: -190.h,
                  child: BlurredEllipse(
                    width: 582.w,
                    height: 376.h,
                    color: AppColors.violet1000,
                    blur: 200,
                  ),
                ),
                const SafeArea(bottom: false, child: _Content()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DevicesOverviewCubit, DevicesOverviewState>(
      builder: (context, state) {
        if (state is DevicesOverviewError) {
          return Center(child: Text(state.message));
        }
        if (state is! DevicesOverviewLoaded) return const LoadingWidget();
        final d = state.overview;

        return SingleChildScrollView(
          // Bottom space so the last card clears the navbar + fade.
          padding: EdgeInsets.only(top: 20.h, bottom: 140.h),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: GreetingHeader(
                  name: d.userName,
                  avatar: d.avatar,
                  trailing: AppIconButton(
                    icon: 'assets/icons/bell.svg',
                    onPressed: () => showNotificationPanel(context),
                  ),
                ),
              ),
              SizedBox(height: 18.h), // figma: 80 + 48 → 146
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.s2.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: AppSpacing.s2.h,
                  children: [
                    if (d.paired.isNotEmpty)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: AppSpacing.s1.w,
                        children: [
                          for (final device in d.paired)
                            Expanded(
                              child: PairedDeviceCard(
                                device: device,
                                onTap: () =>
                                    showDeviceDetailSheet(context, device),
                              ),
                            ),
                        ],
                      ),
                    _AddDevicesCard(state: state),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// "Add new devices" card: header (+ icon, search button) · gap 16 ·
/// Device State tiles (gap 8) · gap 16 · "Didn’t find your devices ?".
class _AddDevicesCard extends StatelessWidget {
  const _AddDevicesCard({required this.state});

  final DevicesOverviewLoaded state;

  @override
  Widget build(BuildContext context) {
    final nearby = state.overview.nearby;
    return GradientBorderCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s3.h,
        children: [
          SectionHeader(
            icon: 'assets/icons/add_circle.svg',
            title: LocaleKeys.devices_add_new_devices.tr(context: context),
            trailing: AppPillIconButton(
              icon: 'assets/icons/search.svg',
              onPressed: () => context.push(RouteNames.kDevicesSearchPage),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.s3.h,
            children: [
              if (nearby.isNotEmpty)
                Column(
                  spacing: AppSpacing.s2.h,
                  children: [
                    for (final device in nearby)
                      DeviceStateTile(
                        image: device.image,
                        name: device.name,
                        status: device.connection.labelKey.tr(context: context),
                        variant: device.connection.variant,
                        onTap: () => showDeviceDetailSheet(context, device),
                      ),
                  ],
                ),
              GestureDetector(
                onTap: () => context.push(RouteNames.kDevicesFaqPage),
                behavior: HitTestBehavior.opaque,
                child: Text(
                  LocaleKeys.devices_didnt_find.tr(context: context),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
