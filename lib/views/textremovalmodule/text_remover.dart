import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';

class MaskGenerator {
  /// Generates a binary mask where WHITE (255) marks the region to inpaint
  /// and BLACK (0) marks the region to preserve
  static Uint8List generateMask(
    int imageWidth,
    int imageHeight,
    Rect selectionRect,
  ) {
    // Create a black image (all pixels preserved)
    final mask = img.Image(width: imageWidth, height: imageHeight);
    img.fill(mask, color: img.ColorRgb8(0, 0, 0)); // Black = preserve

    // Calculate the selection bounds, ensuring they're within image bounds
    final left = selectionRect.left.clamp(0, imageWidth - 1).toInt();
    final top = selectionRect.top.clamp(0, imageHeight - 1).toInt();
    final right = selectionRect.right.clamp(0, imageWidth).toInt();
    final bottom = selectionRect.bottom.clamp(0, imageHeight).toInt();

    // Draw white rectangle ONLY in the selected region
    // White (255) tells the AI to inpaint this specific area
    for (int y = top; y < bottom; y++) {
      for (int x = left; x < right; x++) {
        mask.setPixel(x, y, img.ColorRgb8(255, 255, 255)); // White = inpaint
      }
    }

    // Optional: Add a small feathering/blur to make the transition smoother
    // This helps the AI blend better at the edges
    final blurred = img.gaussianBlur(mask, radius: 2);

    // Encode to PNG
    return Uint8List.fromList(img.encodePng(blurred));
  }

  /// Alternative version with more control over feathering
  static Uint8List generateMaskWithFeathering(
    int imageWidth,
    int imageHeight,
    Rect selectionRect, {
    int featherRadius = 5,
  }) {
    final mask = img.Image(width: imageWidth, height: imageHeight);
    img.fill(mask, color: img.ColorRgb8(0, 0, 0));

    final left = selectionRect.left.clamp(0, imageWidth - 1).toInt();
    final top = selectionRect.top.clamp(0, imageHeight - 1).toInt();
    final right = selectionRect.right.clamp(0, imageWidth).toInt();
    final bottom = selectionRect.bottom.clamp(0, imageHeight).toInt();

    // Fill the core selection area with white
    for (int y = top; y < bottom; y++) {
      for (int x = left; x < right; x++) {
        mask.setPixel(x, y, img.ColorRgb8(255, 255, 255));
      }
    }

    // Apply Gaussian blur for smooth edges
    if (featherRadius > 0) {
      final blurred = img.gaussianBlur(mask, radius: featherRadius);
      return Uint8List.fromList(img.encodePng(blurred));
    }

    return Uint8List.fromList(img.encodePng(mask));
  }
}