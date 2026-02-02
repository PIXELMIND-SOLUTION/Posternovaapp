import 'dart:ui';

class ImageRectUtils {
  static Rect getImageRenderRect({
    required Size imageSize,
    required Size containerSize,
  }) {
    final imageAspect = imageSize.width / imageSize.height;
    final containerAspect =
        containerSize.width / containerSize.height;

    double renderWidth, renderHeight;
    double offsetX = 0, offsetY = 0;

    if (imageAspect > containerAspect) {
      renderWidth = containerSize.width;
      renderHeight = renderWidth / imageAspect;
      offsetY = (containerSize.height - renderHeight) / 2;
    } else {
      renderHeight = containerSize.height;
      renderWidth = renderHeight * imageAspect;
      offsetX = (containerSize.width - renderWidth) / 2;
    }

    return Rect.fromLTWH(offsetX, offsetY, renderWidth, renderHeight);
  }

  static Rect scaleRectToImage({
    required Rect screenRect,
    required Rect imageRect,
    required Size imageSize,
  }) {
    final clamped = screenRect.intersect(imageRect);

    final scaleX = imageSize.width / imageRect.width;
    final scaleY = imageSize.height / imageRect.height;

    return Rect.fromLTRB(
      (clamped.left - imageRect.left) * scaleX,
      (clamped.top - imageRect.top) * scaleY,
      (clamped.right - imageRect.left) * scaleX,
      (clamped.bottom - imageRect.top) * scaleY,
    );
  }
}
