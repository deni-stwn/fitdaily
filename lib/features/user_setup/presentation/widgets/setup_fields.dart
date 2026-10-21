import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_dimens.dart';
import '../../../../shared/widgets/app_text_field.dart';

/// Some Figma field blocks sit in an 80-high wrapper (72 + 8 extra gap).
class FieldBox80 extends StatelessWidget {
  const FieldBox80({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.h,
      child: Align(alignment: Alignment.topCenter, child: child),
    );
  }
}

/// Two fields side by side, gap 8.
class FieldRow extends StatelessWidget {
  const FieldRow({super.key, required this.left, required this.right});

  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.s2.w,
      children: [
        Expanded(child: left),
        Expanded(child: right),
      ],
    );
  }
}

/// Numeric [AppTextField] with a unit ("Kg", "Hours"…). [hint] is the Figma
/// placeholder value.
class NumberField extends StatelessWidget {
  const NumberField({
    super.key,
    required this.label,
    required this.hint,
    required this.unit,
    this.decimal = false,
  });

  final String label;
  final String hint;
  final String unit;
  final bool decimal;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: label,
      hint: hint,
      suffixText: unit,
      keyboardType: TextInputType.numberWithOptions(decimal: decimal),
      textInputAction: TextInputAction.next,
    );
  }
}

/// "00.00" field that opens the time picker; shows the pick as HH.mm.
class TimeField extends StatefulWidget {
  const TimeField({super.key, required this.label});

  final String label;

  @override
  State<TimeField> createState() => _TimeFieldState();
}

class _TimeFieldState extends State<TimeField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;
    String two(int v) => v.toString().padLeft(2, '0');
    _controller.text = '${two(time.hour)}.${two(time.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: widget.label,
      hint: '00.00',
      controller: _controller,
      readOnly: true,
      onTap: _pick,
    );
  }
}
