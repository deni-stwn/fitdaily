import '../../../../shared/widgets/card_scaffold.dart';

/// Illustration presets of the auth screens (Figma frame coordinates).
abstract final class AuthIllustrations {
  /// Sign In / Sign Up person + "* * *" (178×180 at top 205).
  static CardIllustration person({required double left}) => CardIllustration(
    asset: 'assets/images/sign_in_illustration.png',
    width: 178,
    height: 180,
    top: 205,
    left: left,
  );

  /// Password Reset padlocks (150.5 wide, centred).
  static CardIllustration lock(
    String asset, {
    double top = 239,
    double height = 180,
  }) =>
      CardIllustration.centered(asset, width: 150.5, height: height, top: top);
}
