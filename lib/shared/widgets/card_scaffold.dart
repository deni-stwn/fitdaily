import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_background.dart';

/// Floating illustration of a [CardScaffold] screen, in Figma frame
/// coordinates.
class CardIllustration {
  const CardIllustration({
    required this.asset,
    required this.width,
    required this.height,
    required this.top,
    this.left,
  });

  /// Horizontally centred illustration (Password Reset, User Setup).
  const CardIllustration.centered(
    String asset, {
    required double width,
    required double height,
    required double top,
  }) : this(asset: asset, width: width, height: height, top: top);

  final String asset;
  final double width;
  final double height;
  final double top;

  /// Null = centred horizontally.
  final double? left;
}

/// Screen layout used by auth & user setup: pattern background, floating
/// illustration, optional header (logo / title bar) and a form [card]
/// (usually [FormCard]) pinned to the bottom. Scrolls when the keyboard is
/// open.
class CardScaffold extends StatelessWidget {
  const CardScaffold({
    super.key,
    required this.illustration,
    required this.card,
    this.header,
    this.headerTop = 0,
  });

  final CardIllustration illustration;
  final Widget card;

  /// `AppLogo` (Sign In / Sign Up), `AppTitleBar` (Password Reset) or none
  /// (User Setup).
  final Widget? header;

  /// Header top below the 60px status bar (logo 92.55 → 32.55, title bar
  /// 84 → 24).
  final double headerTop;

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      illustration.asset,
      width: illustration.width.w,
      height: illustration.height.w,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: AppBackground(
          child: Stack(
            children: [
              // Floating illustration: fixed proportion of the full frame.
              Positioned(
                top: illustration.top.h,
                left: illustration.left?.w ?? 0,
                right: illustration.left == null ? 0 : null,
                child: illustration.left == null ? Center(child: image) : image,
              ),
              // Devices without a home indicator (macOS, some Android) get
              // the card's side margin (8) as bottom gap; iPhone keeps 34.
              SafeArea(
                minimum: EdgeInsets.only(bottom: 8.w),
                child: _ScrollableContent(
                  header: header,
                  headerTop: headerTop,
                  card: card,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScrollableContent extends StatelessWidget {
  const _ScrollableContent({
    required this.header,
    required this.headerTop,
    required this.card,
  });

  final Widget? header;
  final double headerTop;
  final Widget card;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: Column(
              children: [
                if (header != null) ...[SizedBox(height: headerTop.h), header!],
                const Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w), // figma: 8
                  child: card,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
