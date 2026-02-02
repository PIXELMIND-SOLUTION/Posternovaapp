

import 'dart:typed_data';
import 'dart:ui';
import 'package:image/image.dart' as img;

class MaskGenerator {
  static Uint8List generateMask(
    int width,
    int height,
    Rect eraseRect,
  ) {
    final mask = img.Image(
      width: width,
      height: height,
      numChannels: 4,
    );

    // KEEP everything
    img.fill(
      mask,
      color: img.ColorRgba8(255, 255, 255, 255),
    );

    // REMOVE only selected area
    img.fillRect(
      mask,
      x1: eraseRect.left.toInt(),
      y1: eraseRect.top.toInt(),
      x2: eraseRect.right.toInt(),
      y2: eraseRect.bottom.toInt(),
      color: img.ColorRgba8(0, 0, 0, 0),
    );

    return Uint8List.fromList(img.encodePng(mask));
  }
}
