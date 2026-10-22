import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/app_accordion.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/app_title_bar.dart';
import '../../../../shared/widgets/brand_effects.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../manager/faq/faq_cubit.dart';
import '../manager/faq/faq_state.dart';

/// Figma: Devices - FAQ (683:54678) — "Didn’t find your devices ?".
class DevicesFaqPage extends StatelessWidget {
  const DevicesFaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FaqCubit>()..loadData(),
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
                SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      AppTitleBar(
                        variant: AppTitleBarVariant.standard,
                        title: LocaleKeys.devices_faq_title.tr(
                          context: context,
                        ),
                        onBack: context.pop,
                      ),
                      const Expanded(child: _Content()),
                    ],
                  ),
                ),
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
    return BlocBuilder<FaqCubit, FaqState>(
      builder: (context, state) {
        if (state is FaqError) return Center(child: Text(state.message));
        if (state is! FaqLoaded) return const LoadingWidget();
        final cubit = context.read<FaqCubit>();
        final items = state.visible;

        return SingleChildScrollView(
          // figma: list at y 156 (title bar ends at 128).
          padding: EdgeInsets.fromLTRB(
            AppSpacing.s2.w,
            28.h,
            AppSpacing.s2.w,
            AppSpacing.s4.h + MediaQuery.paddingOf(context).bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.s3.h,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.s2.h,
                children: [
                  Text(
                    LocaleKeys.devices_popular_topics.tr(context: context),
                    style: AppTextStyles.headingMedium,
                  ),
                  AppTextField(
                    hint: LocaleKeys.devices_search.tr(context: context),
                    textInputAction: TextInputAction.search,
                    onChanged: cubit.search,
                    suffix: SvgPicture.asset(
                      'assets/icons/search_normal.svg',
                      width: 24.w,
                      height: 24.w,
                    ),
                  ),
                ],
              ),
              if (items.isEmpty)
                Text(
                  LocaleKeys.devices_no_topics.tr(context: context),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: AppSpacing.s2.h,
                  children: [
                    for (final item in items)
                      AppAccordion(
                        key: ValueKey(item.id),
                        title: item.question,
                        content: item.answer,
                        // Accordion "Icons" slot is hidden in the
                        // component; the FAQ instances overlap it with
                        // the title (design glitch) → not rendered.
                        expanded: state.expanded.contains(item.id),
                        onToggle: () => cubit.toggle(item.id),
                      ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
