import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../generated/locale_keys.g.dart';
import '../manager/device/device_cubit.dart';
import '../manager/device/device_state.dart';
import 'device_tile.dart';
import 'scanning_indicator.dart';

/// "Device List" label + fixed 200-high box: radar animation while
/// scanning (not in Figma), scrollable device list (683:53955), or
/// "No Device found" (683:53930) when the scan finds nothing.
class DeviceListBox extends StatelessWidget {
  const DeviceListBox({super.key});

  @override
  Widget build(BuildContext context) {
    final emptyStyle = AppTextStyles.bodyMedium.copyWith(
      color: AppColors.textTertiary,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.s2.h,
      children: [
        Text(
          LocaleKeys.device_setup_device_list.tr(context: context),
          style: emptyStyle,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.large.r),
          child: Container(
            height: 200.h,
            width: double.infinity,
            color: AppColors.bgTertiary,
            child: BlocBuilder<DeviceCubit, DeviceState>(
              builder: (context, state) => switch (state) {
                DeviceLoaded(:final items) when items.isNotEmpty =>
                  ListView.separated(
                    padding: EdgeInsets.all(AppSpacing.s2.w),
                    itemCount: items.length,
                    // figma: 8 · 1px `border` line · 8 between rows
                    // (line measured from the screenshot, not in spec).
                    separatorBuilder: (_, _) => SizedBox(
                      height: AppSpacing.s3.h,
                      child: const Center(
                        child: Divider(height: 1, color: AppColors.border),
                      ),
                    ),
                    itemBuilder: (context, index) => DeviceTile(
                      device: items[index],
                      onTap: () => context.read<DeviceCubit>().toggleConnection(
                        items[index].id,
                      ),
                    ),
                  ),
                DeviceError(:final message) => Center(
                  child: Text(message, style: emptyStyle),
                ),
                DeviceLoaded() => Center(
                  child: Text(
                    LocaleKeys.device_setup_no_device.tr(context: context),
                    style: emptyStyle,
                  ),
                ),
                _ => const Center(child: ScanningIndicator()),
              },
            ),
          ),
        ),
      ],
    );
  }
}
