import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimens.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../shared/widgets/value_unit.dart';

/// One cell: value + unit and a label below.
typedef SummaryStat = ({String value, String unit, String label});

/// Heartrate "Day Summary" grid (figma: 9037): two columns (fill, gap 16),
/// rows gap 16; each cell is [ValueUnit] with a `bodySmall` tertiary label.
class SummaryStatGrid extends StatelessWidget {
  const SummaryStatGrid({super.key, required this.stats});

  final List<SummaryStat> stats;

  static const _columns = 2;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.s3.h,
      children: [
        for (var i = 0; i < stats.length; i += _columns)
          Row(
            spacing: AppSpacing.s3.w,
            children: [
              for (var j = i; j < i + _columns; j++)
                Expanded(
                  child: j < stats.length
                      ? _Cell(stat: stats[j])
                      : const SizedBox.shrink(),
                ),
            ],
          ),
      ],
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({required this.stat});

  final SummaryStat stat;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValueUnit(value: stat.value, unit: stat.unit),
        Text(
          stat.label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}
