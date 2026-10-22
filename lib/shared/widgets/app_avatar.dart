import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Figma component "Avatar" (`625:6444`) — `size` property.
enum AppAvatarSize {
  xs(48),
  sm(72),
  md(124),
  lg(248);

  const AppAvatarSize(this.dimension);

  /// Width = height in Figma px.
  final double dimension;
}

/// Figma "Avatar": round image (image fill is not in the FigCraft export →
/// the asset comes from the data, e.g. `assets/images/avatar_brian.png`).
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    required this.image,
    this.size = AppAvatarSize.xs,
  });

  final String image;
  final AppAvatarSize size;

  @override
  Widget build(BuildContext context) {
    final dimension = size.dimension.w;
    return ClipOval(
      child: Image.asset(
        image,
        width: dimension,
        height: dimension,
        fit: BoxFit.cover,
      ),
    );
  }
}
