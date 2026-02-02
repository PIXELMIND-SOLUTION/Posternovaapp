import 'package:flutter/material.dart';

class ImageRectUtils {
  /// Calculates where the image is actually rendered within the container
  /// (considering BoxFit.contain)
  static Rect getImageRenderRect({
    required Size imageSize,
    required Size containerSize,
  }) {
    final imageAspect = imageSize.width / imageSize.height;
    final containerAspect = containerSize.width / containerSize.height;

    double renderWidth, renderHeight;
    double offsetX = 0, offsetY = 0;

    if (imageAspect > containerAspect) {
      // Image is wider - fit to width
      renderWidth = containerSize.width;
      renderHeight = containerSize.width / imageAspect;
      offsetY = (containerSize.height - renderHeight) / 2;
    } else {
      // Image is taller - fit to height
      renderHeight = containerSize.height;
      renderWidth = containerSize.height * imageAspect;
      offsetX = (containerSize.width - renderWidth) / 2;
    }

    return Rect.fromLTWH(offsetX, offsetY, renderWidth, renderHeight);
  }

  /// Converts a rectangle from screen coordinates to image pixel coordinates
  static Rect scaleRectToImage({
    required Rect screenRect,
    required Rect imageRect,
    required Size imageSize,
  }) {
    // Calculate scale factor
    final scaleX = imageSize.width / imageRect.width;
    final scaleY = imageSize.height / imageRect.height;

    // Translate screen coordinates to image-relative coordinates
    final relativeLeft = (screenRect.left - imageRect.left).clamp(0.0, imageRect.width);
    final relativeTop = (screenRect.top - imageRect.top).clamp(0.0, imageRect.height);
    final relativeRight = (screenRect.right - imageRect.left).clamp(0.0, imageRect.width);
    final relativeBottom = (screenRect.bottom - imageRect.top).clamp(0.0, imageRect.height);

    // Scale to image pixel coordinates
    final imageLeft = (relativeLeft * scaleX).clamp(0.0, imageSize.width);
    final imageTop = (relativeTop * scaleY).clamp(0.0, imageSize.height);
    final imageRight = (relativeRight * scaleX).clamp(0.0, imageSize.width);
    final imageBottom = (relativeBottom * scaleY).clamp(0.0, imageSize.height);

    return Rect.fromLTRB(
      imageLeft,
      imageTop,
      imageRight,
      imageBottom,
    );
  }
}