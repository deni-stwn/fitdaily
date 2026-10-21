import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../shared/widgets/app_icon_button.dart';
import '../../../../shared/widgets/brand_effects.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/quote_card.dart';
import '../../../../shared/widgets/weekly_bar_card.dart';
import '../manager/home/home_cubit.dart';
import '../manager/home/home_state.dart';
import '../widgets/heart_rate_card.dart';
import '../widgets/home_header.dart';
import '../widgets/notification_panel.dart';

/// Figma: Home (683:53154).
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeCubit>()..loadData(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          body: AppBackground(
            child: Stack(
              children: [
                // figma: "light effect" #1F076E 582×376 at (-71, -190);
                // blur not exported → tuned against the screenshot.
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
                const SafeArea(bottom: false, child: _HomeContent()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  static const _days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeError) return Center(child: Text(state.message));
        if (state is! HomeLoaded) return const LoadingWidget();
        final d = state.dashboard;
        final cubit = context.read<HomeCubit>();

        return SingleChildScrollView(
          // Bottom space so the last card clears the navbar + fade.
          padding: EdgeInsets.only(top: 20.h, bottom: 140.h),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: HomeHeader(
                  name: d.userName,
                  avatar: d.avatar,
                  trailing: AppIconButton(
                    icon: 'assets/icons/bell.svg',
                    onPressed: () => showNotificationPanel(context),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.s3.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.s2.w),
                child: Column(
                  spacing: AppSpacing.s2.h,
                  children: [
                    if (state.showQuote)
                      QuoteCard(
                        text: d.quote.text,
                        author: d.quote.author,
                        onClose: cubit.dismissQuote,
                      ),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: AppSpacing.s2.w,
                        children: [
                          Expanded(
                            child: WeeklyBarCard(
                              icon: 'assets/icons/metric_steps.svg',
                              title: LocaleKeys.home_steps.tr(context: context),
                              color: AppColors.iconSuccess,
                              days: d.steps.days,
                              dayLabels: _days,
                              value: '${d.steps.value}',
                              unit: LocaleKeys.home_steps.tr(context: context),
                              goal: '/${d.steps.goal}',
                            ),
                          ),
                          Expanded(
                            child: WeeklyBarCard(
                              icon: 'assets/icons/metric_calories.svg',
                              title: LocaleKeys.home_calories.tr(
                                context: context,
                              ),
                              color: AppColors.iconWarning,
                              days: d.calories.days,
                              dayLabels: _days,
                              value: '${d.calories.value}',
                              unit: LocaleKeys.home_calories.tr(
                                context: context,
                              ),
                              goal: '/${d.calories.goal}',
                            ),
                          ),
                        ],
                      ),
                    ),
                    HeartRateCard(summary: d.heartRate),
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
