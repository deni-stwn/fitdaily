import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'app_text_field.dart';

/// [AppTextField] for passwords with the eye show/hide toggle
/// (Figma eye-slash + Iconsax "Eye" Bold for the visible state).
class AppPasswordField extends StatefulWidget {
  const AppPasswordField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.textInputAction,
    this.autofillHints,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: widget.label,
      hint: widget.hint,
      controller: widget.controller,
      obscureText: _obscure,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      suffix: GestureDetector(
        onTap: () => setState(() => _obscure = !_obscure),
        behavior: HitTestBehavior.opaque,
        child: SvgPicture.asset(
          _obscure ? 'assets/icons/eye_slash.svg' : 'assets/icons/eye.svg',
          width: 24.w,
          height: 24.w,
        ),
      ),
    );
  }
}
