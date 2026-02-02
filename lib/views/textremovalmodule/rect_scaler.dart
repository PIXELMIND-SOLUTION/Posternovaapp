import 'dart:ui';

class RectScaler {
  static Rect scaleToImage({
    required Rect screenRect,
    required Size imageSize,
    required Size displaySize,
  }) {
    final scaleX = imageSize.width / displaySize.width;
    final scaleY = imageSize.height / displaySize.height;

    return Rect.fromLTRB(
      screenRect.left * scaleX,
      screenRect.top * scaleY,
      screenRect.right * scaleX,
      screenRect.bottom * scaleY,
    );
  }
}
