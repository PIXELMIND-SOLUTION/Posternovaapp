// // // // // // // import 'dart:io';
// // // // // // // import 'dart:math';
// // // // // // // import 'dart:ui' as ui;
// // // // // // // import 'dart:typed_data';
// // // // // // // import 'dart:convert';
// // // // // // // // import 'package:edit_ezy_project/helper/storage_helper.dart';
// // // // // // // import 'package:flutter/material.dart';
// // // // // // // import 'package:flutter/rendering.dart';
// // // // // // // import 'package:flutter/services.dart';
// // // // // // // import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// // // // // // // import 'package:gal/gal.dart';
// // // // // // // import 'package:image_picker/image_picker.dart';
// // // // // // // import 'package:path_provider/path_provider.dart';
// // // // // // // import 'package:http/http.dart' as http;
// // // // // // // import 'package:posternova/helper/storage_helper.dart';
// // // // // // // import 'package:posternova/providers/customer/customer_provider.dart';
// // // // // // // import 'package:posternova/views/chat/chat_module.dart';
// // // // // // // import 'package:posternova/widgets/language_widget.dart';
// // // // // // // import 'package:provider/provider.dart';
// // // // // // // import 'package:share_plus/share_plus.dart';
// // // // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // // // import 'package:url_launcher/url_launcher.dart';

// // // // // // // // Template Models
// // // // // // // class PosterTemplate {
// // // // // // //   String id;
// // // // // // //   String name;
// // // // // // //   String categoryName;
// // // // // // //   String description;
// // // // // // //   String title;
// // // // // // //   String email;
// // // // // // //   String mobile;
// // // // // // //   double width;
// // // // // // //   double height;
// // // // // // //   String? backgroundImage;
// // // // // // //   Color backgroundColor;
// // // // // // //   List<TextElement> textElements;
// // // // // // //   List<ImageElement> imageElements;
// // // // // // //   DesignData designData;

// // // // // // //   PosterTemplate({
// // // // // // //     required this.id,
// // // // // // //     required this.name,
// // // // // // //     required this.categoryName,
// // // // // // //     required this.description,
// // // // // // //     required this.title,
// // // // // // //     required this.email,
// // // // // // //     required this.mobile,
// // // // // // //     required this.width,
// // // // // // //     required this.height,
// // // // // // //     this.backgroundImage,
// // // // // // //     this.backgroundColor = Colors.white,
// // // // // // //     this.textElements = const [],
// // // // // // //     this.imageElements = const [],
// // // // // // //     required this.designData,
// // // // // // //   });

// // // // // // //   void updateWithUserData(String? userEmail, String? userMobile) {
// // // // // // //     for (var element in textElements) {
// // // // // // //       switch (element.id) {
// // // // // // //         case 'email':
// // // // // // //           if (userEmail != null && userEmail.isNotEmpty) {
// // // // // // //             element.text = userEmail;
// // // // // // //           }
// // // // // // //           break;
// // // // // // //         case 'mobile':
// // // // // // //           if (userMobile != null && userMobile.isNotEmpty) {
// // // // // // //             element.text = userMobile;
// // // // // // //           }
// // // // // // //           break;
// // // // // // //       }
// // // // // // //     }
// // // // // // //   }

// // // // // // //   factory PosterTemplate.fromApiResponse(
// // // // // // //     Map<String, dynamic> apiResponse, {
// // // // // // //     String? userEmail,
// // // // // // //     String? userMobile,
// // // // // // //   }) {
// // // // // // //     final posterData = apiResponse['poster'] as Map<String, dynamic>;
// // // // // // //     final designData = posterData['designData'] as Map<String, dynamic>;

// // // // // // //     // Create text elements based on visibility
// // // // // // //     List<TextElement> textElements = [];
// // // // // // //     final textSettings = TextSettings.fromJson(
// // // // // // //       designData['textSettings'] ?? {},
// // // // // // //     );
// // // // // // //     final textStyles = TextStyles.fromJson(designData['textStyles'] ?? {});
// // // // // // //     final textVisibility = TextVisibility.fromJson(
// // // // // // //       designData['textVisibility'] ?? {},
// // // // // // //     );

// // // // // // //     if (textVisibility.isVisible('title')) {
// // // // // // //       textElements.add(
// // // // // // //         TextElement(
// // // // // // //           id: 'title',
// // // // // // //           text: posterData['title'] as String? ?? '',
// // // // // // //           x: textSettings.titleX,
// // // // // // //           y: textSettings.titleY,
// // // // // // //           width: 800,
// // // // // // //           height: 200,
// // // // // // //           fontSize: textStyles.title.fontSize ?? 36,
// // // // // // //           color: textStyles.title.color ?? Colors.black,
// // // // // // //           fontWeight: textStyles.title.fontWeight ?? FontWeight.bold,
// // // // // // //           fontFamily: textStyles.title.fontFamily ?? 'Times New Roman',
// // // // // // //           textAlign: TextAlign.center,
// // // // // // //         ),
// // // // // // //       );
// // // // // // //     }

// // // // // // //     if (textVisibility.isVisible('description')) {
// // // // // // //       textElements.add(
// // // // // // //         TextElement(
// // // // // // //           id: 'description',
// // // // // // //           text: posterData['description'] as String? ?? '',
// // // // // // //           x: textSettings.descriptionX,
// // // // // // //           y: textSettings.descriptionY,
// // // // // // //           width: 900,
// // // // // // //           height: 400,
// // // // // // //           fontSize: textStyles.description.fontSize ?? 20,
// // // // // // //           color: textStyles.description.color ?? Colors.black,
// // // // // // //           fontWeight: textStyles.description.fontWeight ?? FontWeight.bold,
// // // // // // //           fontFamily: textStyles.description.fontFamily ?? 'Times New Roman',
// // // // // // //           textAlign: TextAlign.left,
// // // // // // //         ),
// // // // // // //       );
// // // // // // //     }
// // // // // // //     if (textVisibility.isVisible('name')) {
// // // // // // //       textElements.add(
// // // // // // //         TextElement(
// // // // // // //           id: 'name',
// // // // // // //           // text: posterData['name'] as String? ?? '',
// // // // // // //           text: 'Business Name',
// // // // // // //           x: textSettings.nameX,
// // // // // // //           y: textSettings.nameY,
// // // // // // //           width: 400,
// // // // // // //           height: 100,
// // // // // // //           // fontSize: textStyles.name.fontSize ?? 24,
// // // // // // //           fontSize: 2,

// // // // // // //           color: textStyles.name.color ?? Colors.black,
// // // // // // //           fontWeight: textStyles.name.fontWeight ?? FontWeight.bold,
// // // // // // //           fontFamily: textStyles.name.fontFamily ?? 'Arial',
// // // // // // //           textAlign: TextAlign.left,
// // // // // // //         ),
// // // // // // //       );
// // // // // // //     }

// // // // // // //     const double canvasWidth = 720;
// // // // // // //     // Create image elements from overlay images
// // // // // // //     List<ImageElement> imageElements = [];
// // // // // // //     if (designData['overlayImages'] != null) {
// // // // // // //       final overlayImages = designData['overlayImages'] as List<dynamic>;
// // // // // // //       final overlays =
// // // // // // //           designData['overlaySettings']?['overlays'] as List<dynamic>? ?? [];

// // // // // // //       for (int i = 0; i < overlayImages.length; i++) {
// // // // // // //         final img = overlayImages[i];
// // // // // // //         // Use overlay position if available, otherwise use default
// // // // // // //         final overlay = i < overlays.length ? overlays[i] : null;

// // // // // // //         imageElements.add(
// // // // // // //           ImageElement(
// // // // // // //             id:
// // // // // // //                 img['_id'] ??
// // // // // // //                 'overlay_${DateTime.now().millisecondsSinceEpoch}',
// // // // // // //             imageUrl: img['url'] ?? '',
// // // // // // //             x: overlay != null ? _parseDouble(overlay['x'], 324) : 324,
// // // // // // //             y: overlay != null ? _parseDouble(overlay['y'], 521) : 521,
// // // // // // //             width: overlay != null ? _parseDouble(overlay['width'], 252) : 252,
// // // // // // //             height: overlay != null
// // // // // // //                 ? _parseDouble(overlay['height'], 252)
// // // // // // //                 : 252,
// // // // // // //           ),
// // // // // // //         );
// // // // // // //       }
// // // // // // //     }

// // // // // // //     return PosterTemplate(
// // // // // // //       id:
// // // // // // //           posterData['_id'] ??
// // // // // // //           'template_${DateTime.now().millisecondsSinceEpoch}',
// // // // // // //       name: posterData['name'] ?? 'Untitled',
// // // // // // //       categoryName: posterData['categoryName'] ?? '',
// // // // // // //       description: posterData['description'] ?? '',
// // // // // // //       title: posterData['title'] ?? '',
// // // // // // //       email: posterData['email'] ?? '',
// // // // // // //       mobile: posterData['mobile'] ?? '',
// // // // // // //       width: 900, // Standard poster width
// // // // // // //       height: 1200, // Standard poster height
// // // // // // //       backgroundImage: designData['bgImage']?['url'],
// // // // // // //       backgroundColor: Colors.white,
// // // // // // //       textElements: textElements,
// // // // // // //       imageElements: imageElements,
// // // // // // //       designData: DesignData.fromJson(designData),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   static double _parseDouble(dynamic value, double defaultValue) {
// // // // // // //     if (value == null) return defaultValue;
// // // // // // //     if (value is double) return value;
// // // // // // //     if (value is int) return value.toDouble();
// // // // // // //     if (value is String) return double.tryParse(value) ?? defaultValue;
// // // // // // //     return defaultValue;
// // // // // // //   }

// // // // // // //   Map<String, dynamic> toJson() {
// // // // // // //     return {
// // // // // // //       'id': id,
// // // // // // //       'name': name,
// // // // // // //       'categoryName': categoryName,
// // // // // // //       'description': description,
// // // // // // //       'title': title,
// // // // // // //       'email': email,
// // // // // // //       'mobile': mobile,
// // // // // // //       'width': width,
// // // // // // //       'height': height,
// // // // // // //       'backgroundImage': backgroundImage,
// // // // // // //       'backgroundColor': backgroundColor.value,
// // // // // // //       'textElements': textElements.map((e) => e.toJson()).toList(),
// // // // // // //       'imageElements': imageElements.map((e) => e.toJson()).toList(),
// // // // // // //       'designData': designData.toJson(),
// // // // // // //     };
// // // // // // //   }
// // // // // // // }

// // // // // // // class DesignData {
// // // // // // //   BgImageSettings bgImageSettings;
// // // // // // //   OverlaySettings overlaySettings;
// // // // // // //   TextSettings textSettings;
// // // // // // //   TextStyles textStyles;
// // // // // // //   TextVisibility textVisibility;
// // // // // // //   List<OverlayImageFilter> overlayImageFilters;

// // // // // // //   DesignData({
// // // // // // //     required this.bgImageSettings,
// // // // // // //     required this.overlaySettings,
// // // // // // //     required this.textSettings,
// // // // // // //     required this.textStyles,
// // // // // // //     required this.textVisibility,
// // // // // // //     required this.overlayImageFilters,
// // // // // // //   });

// // // // // // //   factory DesignData.fromJson(Map<String, dynamic> json) {
// // // // // // //     return DesignData(
// // // // // // //       bgImageSettings: BgImageSettings.fromJson(json['bgImageSettings'] ?? {}),
// // // // // // //       overlaySettings: OverlaySettings.fromJson(json['overlaySettings'] ?? {}),
// // // // // // //       textSettings: TextSettings.fromJson(json['textSettings'] ?? {}),
// // // // // // //       textStyles: TextStyles.fromJson(json['textStyles'] ?? {}),
// // // // // // //       textVisibility: TextVisibility.fromJson(json['textVisibility'] ?? {}),
// // // // // // //       overlayImageFilters:
// // // // // // //           (json['overlayImageFilters'] as List<dynamic>?)
// // // // // // //               ?.map((e) => OverlayImageFilter.fromJson(e))
// // // // // // //               .toList() ??
// // // // // // //           [],
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Map<String, dynamic> toJson() {
// // // // // // //     return {
// // // // // // //       'bgImageSettings': bgImageSettings.toJson(),
// // // // // // //       'overlaySettings': overlaySettings.toJson(),
// // // // // // //       'textSettings': textSettings.toJson(),
// // // // // // //       'textStyles': textStyles.toJson(),
// // // // // // //       'textVisibility': textVisibility.toJson(),
// // // // // // //       'overlayImageFilters': overlayImageFilters
// // // // // // //           .map((e) => e.toJson())
// // // // // // //           .toList(),
// // // // // // //     };
// // // // // // //   }
// // // // // // // }

// // // // // // // class BgImageSettings {
// // // // // // //   ImageFilters filters;

// // // // // // //   BgImageSettings({required this.filters});

// // // // // // //   factory BgImageSettings.fromJson(Map<String, dynamic> json) {
// // // // // // //     return BgImageSettings(
// // // // // // //       filters: ImageFilters.fromJson(json['filters'] ?? {}),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Map<String, dynamic> toJson() {
// // // // // // //     return {'filters': filters.toJson()};
// // // // // // //   }
// // // // // // // }

// // // // // // // class ImageFilters {
// // // // // // //   double brightness;
// // // // // // //   double contrast;
// // // // // // //   double saturation;
// // // // // // //   double grayscale;
// // // // // // //   double blur;

// // // // // // //   ImageFilters({
// // // // // // //     this.brightness = 100,
// // // // // // //     this.contrast = 100,
// // // // // // //     this.saturation = 100,
// // // // // // //     this.grayscale = 0,
// // // // // // //     this.blur = 0,
// // // // // // //   });

// // // // // // //   factory ImageFilters.fromJson(Map<String, dynamic> json) {
// // // // // // //     return ImageFilters(
// // // // // // //       brightness: _parseDouble(json['brightness'], 100),
// // // // // // //       contrast: _parseDouble(json['contrast'], 100),
// // // // // // //       saturation: _parseDouble(json['saturation'], 100),
// // // // // // //       grayscale: _parseDouble(json['grayscale'], 0),
// // // // // // //       blur: _parseDouble(json['blur'], 0),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Map<String, dynamic> toJson() {
// // // // // // //     return {
// // // // // // //       'brightness': brightness,
// // // // // // //       'contrast': contrast,
// // // // // // //       'saturation': saturation,
// // // // // // //       'grayscale': grayscale,
// // // // // // //       'blur': blur,
// // // // // // //     };
// // // // // // //   }

// // // // // // //   static double _parseDouble(dynamic value, double defaultValue) {
// // // // // // //     if (value == null) return defaultValue;
// // // // // // //     if (value is double) return value;
// // // // // // //     if (value is int) return value.toDouble();
// // // // // // //     if (value is String) return double.tryParse(value) ?? defaultValue;
// // // // // // //     return defaultValue;
// // // // // // //   }
// // // // // // // }

// // // // // // // class OverlaySettings {
// // // // // // //   List<Overlay> overlays;

// // // // // // //   OverlaySettings({required this.overlays});

// // // // // // //   factory OverlaySettings.fromJson(Map<String, dynamic> json) {
// // // // // // //     return OverlaySettings(
// // // // // // //       overlays:
// // // // // // //           (json['overlays'] as List<dynamic>?)
// // // // // // //               ?.map((e) => Overlay.fromJson(e))
// // // // // // //               .toList() ??
// // // // // // //           [],
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Map<String, dynamic> toJson() {
// // // // // // //     return {'overlays': overlays.map((e) => e.toJson()).toList()};
// // // // // // //   }
// // // // // // // }

// // // // // // // class Overlay {
// // // // // // //   double x;
// // // // // // //   double y;
// // // // // // //   double width;
// // // // // // //   double height;
// // // // // // //   String shape;
// // // // // // //   double borderRadius;

// // // // // // //   Overlay({
// // // // // // //     required this.x,
// // // // // // //     required this.y,
// // // // // // //     required this.width,
// // // // // // //     required this.height,
// // // // // // //     required this.shape,
// // // // // // //     required this.borderRadius,
// // // // // // //   });

// // // // // // //   factory Overlay.fromJson(Map<String, dynamic> json) {
// // // // // // //     return Overlay(
// // // // // // //       x: _parseDouble(json['x'], 0),
// // // // // // //       y: _parseDouble(json['y'], 0),
// // // // // // //       width: _parseDouble(json['width'], 100),
// // // // // // //       height: _parseDouble(json['height'], 100),
// // // // // // //       shape: json['shape'] ?? 'rectangle',
// // // // // // //       borderRadius: _parseDouble(json['borderRadius'], 0),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Map<String, dynamic> toJson() {
// // // // // // //     return {
// // // // // // //       'x': x,
// // // // // // //       'y': y,
// // // // // // //       'width': width,
// // // // // // //       'height': height,
// // // // // // //       'shape': shape,
// // // // // // //       'borderRadius': borderRadius,
// // // // // // //     };
// // // // // // //   }

// // // // // // //   static double _parseDouble(dynamic value, double defaultValue) {
// // // // // // //     if (value == null) return defaultValue;
// // // // // // //     if (value is double) return value;
// // // // // // //     if (value is int) return value.toDouble();
// // // // // // //     if (value is String) return double.tryParse(value) ?? defaultValue;
// // // // // // //     return defaultValue;
// // // // // // //   }
// // // // // // // }

// // // // // // // class TextSettings {
// // // // // // //   double nameX;
// // // // // // //   double nameY;
// // // // // // //   double emailX;
// // // // // // //   double emailY;
// // // // // // //   double mobileX;
// // // // // // //   double mobileY;
// // // // // // //   double titleX;
// // // // // // //   double titleY;
// // // // // // //   double descriptionX;
// // // // // // //   double descriptionY;
// // // // // // //   double tagsX;
// // // // // // //   double tagsY;

// // // // // // //   TextSettings({
// // // // // // //     required this.nameX,
// // // // // // //     required this.nameY,
// // // // // // //     required this.emailX,
// // // // // // //     required this.emailY,
// // // // // // //     required this.mobileX,
// // // // // // //     required this.mobileY,
// // // // // // //     required this.titleX,
// // // // // // //     required this.titleY,
// // // // // // //     required this.descriptionX,
// // // // // // //     required this.descriptionY,
// // // // // // //     required this.tagsX,
// // // // // // //     required this.tagsY,
// // // // // // //   });

// // // // // // //   factory TextSettings.fromJson(Map<String, dynamic> json) {
// // // // // // //     return TextSettings(
// // // // // // //       nameX: _parseDouble(json['nameX'], 0),
// // // // // // //       nameY: _parseDouble(json['nameY'], 0),
// // // // // // //       emailX: _parseDouble(json['emailX'], 0),
// // // // // // //       emailY: _parseDouble(json['emailY'], 0),
// // // // // // //       mobileX: _parseDouble(json['mobileX'], 0),
// // // // // // //       mobileY: _parseDouble(json['mobileY'], 0),
// // // // // // //       titleX: _parseDouble(json['titleX'], 0),
// // // // // // //       titleY: _parseDouble(json['titleY'], 0),
// // // // // // //       descriptionX: _parseDouble(json['descriptionX'], 0),
// // // // // // //       descriptionY: _parseDouble(json['descriptionY'], 0),
// // // // // // //       tagsX: _parseDouble(json['tagsX'], 0),
// // // // // // //       tagsY: _parseDouble(json['tagsY'], 0),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Map<String, dynamic> toJson() {
// // // // // // //     return {
// // // // // // //       'nameX': nameX,
// // // // // // //       'nameY': nameY,
// // // // // // //       'emailX': emailX,
// // // // // // //       'emailY': emailY,
// // // // // // //       'mobileX': mobileX,
// // // // // // //       'mobileY': mobileY,
// // // // // // //       'titleX': titleX,
// // // // // // //       'titleY': titleY,
// // // // // // //       'descriptionX': descriptionX,
// // // // // // //       'descriptionY': descriptionY,
// // // // // // //       'tagsX': tagsX,
// // // // // // //       'tagsY': tagsY,
// // // // // // //     };
// // // // // // //   }

// // // // // // //   static double _parseDouble(dynamic value, double defaultValue) {
// // // // // // //     if (value == null) return defaultValue;
// // // // // // //     if (value is double) return value;
// // // // // // //     if (value is int) return value.toDouble();
// // // // // // //     if (value is String) return double.tryParse(value) ?? defaultValue;
// // // // // // //     return defaultValue;
// // // // // // //   }
// // // // // // // }

// // // // // // // class TextStyles {
// // // // // // //   TextStyle name;
// // // // // // //   TextStyle email;
// // // // // // //   TextStyle mobile;
// // // // // // //   TextStyle title;
// // // // // // //   TextStyle description;
// // // // // // //   TextStyle tags;

// // // // // // //   TextStyles({
// // // // // // //     required this.name,
// // // // // // //     required this.email,
// // // // // // //     required this.mobile,
// // // // // // //     required this.title,
// // // // // // //     required this.description,
// // // // // // //     required this.tags,
// // // // // // //   });

// // // // // // //   factory TextStyles.fromJson(Map<String, dynamic> json) {
// // // // // // //     return TextStyles(
// // // // // // //       name: _textStyleFromJson(json['name'] ?? {}),
// // // // // // //       email: _textStyleFromJson(json['email'] ?? {}),
// // // // // // //       mobile: _textStyleFromJson(json['mobile'] ?? {}),
// // // // // // //       title: _textStyleFromJson(json['title'] ?? {}),
// // // // // // //       description: _textStyleFromJson(json['description'] ?? {}),
// // // // // // //       tags: _textStyleFromJson(json['tags'] ?? {}),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Map<String, dynamic> toJson() {
// // // // // // //     return {
// // // // // // //       'name': _textStyleToJson(name),
// // // // // // //       'email': _textStyleToJson(email),
// // // // // // //       'mobile': _textStyleToJson(mobile),
// // // // // // //       'title': _textStyleToJson(title),
// // // // // // //       'description': _textStyleToJson(description),
// // // // // // //       'tags': _textStyleToJson(tags),
// // // // // // //     };
// // // // // // //   }

// // // // // // //   static TextStyle _textStyleFromJson(Map<String, dynamic> json) {
// // // // // // //     return TextStyle(
// // // // // // //       fontSize: _parseDouble(json['fontSize'], 16),
// // // // // // //       color: _parseColor(json['color']),
// // // // // // //       fontFamily: json['fontFamily'] ?? 'Arial',
// // // // // // //       fontWeight: _fontWeightFromString(json['fontWeight'] ?? 'normal'),
// // // // // // //       fontStyle: _fontStyleFromString(json['fontStyle'] ?? 'normal'),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   static Map<String, dynamic> _textStyleToJson(TextStyle style) {
// // // // // // //     return {
// // // // // // //       'fontSize': style.fontSize,
// // // // // // //       'color': style.color?.value ?? 0xFF000000,
// // // // // // //       'fontFamily': style.fontFamily,
// // // // // // //       'fontWeight': _fontWeightToString(style.fontWeight),
// // // // // // //       'fontStyle': _fontStyleToString(style.fontStyle),
// // // // // // //     };
// // // // // // //   }

// // // // // // //   static Color _parseColor(dynamic colorValue) {
// // // // // // //     if (colorValue == null) return Colors.black;

// // // // // // //     if (colorValue is int) {
// // // // // // //       return Color(colorValue);
// // // // // // //     }

// // // // // // //     if (colorValue is String) {
// // // // // // //       String hexColor = colorValue.replaceAll('#', '');
// // // // // // //       if (hexColor.length == 6) {
// // // // // // //         hexColor = 'FF$hexColor';
// // // // // // //       }
// // // // // // //       int? colorInt = int.tryParse(hexColor, radix: 16);
// // // // // // //       if (colorInt != null) {
// // // // // // //         return Color(colorInt);
// // // // // // //       }
// // // // // // //     }

// // // // // // //     return Colors.black;
// // // // // // //   }

// // // // // // //   static double _parseDouble(dynamic value, double defaultValue) {
// // // // // // //     if (value == null) return defaultValue;
// // // // // // //     if (value is double) return value;
// // // // // // //     if (value is int) return value.toDouble();
// // // // // // //     if (value is String) return double.tryParse(value) ?? defaultValue;
// // // // // // //     return defaultValue;
// // // // // // //   }

// // // // // // //   static FontWeight _fontWeightFromString(String weight) {
// // // // // // //     switch (weight.toLowerCase()) {
// // // // // // //       case 'bold':
// // // // // // //         return FontWeight.bold;
// // // // // // //       case 'w300':
// // // // // // //         return FontWeight.w300;
// // // // // // //       case 'w600':
// // // // // // //         return FontWeight.w600;
// // // // // // //       case 'w700':
// // // // // // //         return FontWeight.w700;
// // // // // // //       default:
// // // // // // //         return FontWeight.normal;
// // // // // // //     }
// // // // // // //   }

// // // // // // //   static String _fontWeightToString(FontWeight? weight) {
// // // // // // //     if (weight == FontWeight.bold) return 'bold';
// // // // // // //     if (weight == FontWeight.w300) return 'w300';
// // // // // // //     if (weight == FontWeight.w600) return 'w600';
// // // // // // //     if (weight == FontWeight.w700) return 'w700';
// // // // // // //     return 'normal';
// // // // // // //   }

// // // // // // //   static FontStyle _fontStyleFromString(String style) {
// // // // // // //     return style.toLowerCase() == 'italic'
// // // // // // //         ? FontStyle.italic
// // // // // // //         : FontStyle.normal;
// // // // // // //   }

// // // // // // //   static String _fontStyleToString(FontStyle? style) {
// // // // // // //     return style == FontStyle.italic ? 'italic' : 'normal';
// // // // // // //   }
// // // // // // // }

// // // // // // // class TextVisibility {
// // // // // // //   String name;
// // // // // // //   String email;
// // // // // // //   String mobile;
// // // // // // //   String title;
// // // // // // //   String description;
// // // // // // //   String tags;

// // // // // // //   TextVisibility({
// // // // // // //     required this.name,
// // // // // // //     required this.email,
// // // // // // //     required this.mobile,
// // // // // // //     required this.title,
// // // // // // //     required this.description,
// // // // // // //     required this.tags,
// // // // // // //   });

// // // // // // //   factory TextVisibility.fromJson(Map<String, dynamic> json) {
// // // // // // //     return TextVisibility(
// // // // // // //       name: json['name'] ?? 'visible',
// // // // // // //       email: json['email'] ?? 'visible',
// // // // // // //       mobile: json['mobile'] ?? 'visible',
// // // // // // //       title: json['title'] ?? 'visible',
// // // // // // //       description: json['description'] ?? 'visible',
// // // // // // //       tags: json['tags'] ?? 'visible',
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Map<String, dynamic> toJson() {
// // // // // // //     return {
// // // // // // //       'name': name,
// // // // // // //       'email': email,
// // // // // // //       'mobile': mobile,
// // // // // // //       'title': title,
// // // // // // //       'description': description,
// // // // // // //       'tags': tags,
// // // // // // //     };
// // // // // // //   }

// // // // // // //   bool isVisible(String field) {
// // // // // // //     switch (field) {
// // // // // // //       case 'name':
// // // // // // //         return name == 'visible';
// // // // // // //       case 'email':
// // // // // // //         return email == 'visible';
// // // // // // //       case 'mobile':
// // // // // // //         return mobile == 'visible';
// // // // // // //       case 'title':
// // // // // // //         return title == 'visible';
// // // // // // //       case 'description':
// // // // // // //         return description == 'visible';
// // // // // // //       case 'tags':
// // // // // // //         return tags == 'visible';
// // // // // // //       default:
// // // // // // //         return true;
// // // // // // //     }
// // // // // // //   }
// // // // // // // }

// // // // // // // class OverlayImageFilter {
// // // // // // //   double brightness;
// // // // // // //   double contrast;
// // // // // // //   double saturation;
// // // // // // //   double grayscale;
// // // // // // //   double blur;

// // // // // // //   OverlayImageFilter({
// // // // // // //     this.brightness = 100,
// // // // // // //     this.contrast = 100,
// // // // // // //     this.saturation = 100,
// // // // // // //     this.grayscale = 0,
// // // // // // //     this.blur = 0,
// // // // // // //   });

// // // // // // //   factory OverlayImageFilter.fromJson(Map<String, dynamic> json) {
// // // // // // //     return OverlayImageFilter(
// // // // // // //       brightness: _parseDouble(json['brightness'], 100),
// // // // // // //       contrast: _parseDouble(json['contrast'], 100),
// // // // // // //       saturation: _parseDouble(json['saturation'], 100),
// // // // // // //       grayscale: _parseDouble(json['grayscale'], 0),
// // // // // // //       blur: _parseDouble(json['blur'], 0),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Map<String, dynamic> toJson() {
// // // // // // //     return {
// // // // // // //       'brightness': brightness,
// // // // // // //       'contrast': contrast,
// // // // // // //       'saturation': saturation,
// // // // // // //       'grayscale': grayscale,
// // // // // // //       'blur': blur,
// // // // // // //     };
// // // // // // //   }

// // // // // // //   static double _parseDouble(dynamic value, double defaultValue) {
// // // // // // //     if (value == null) return defaultValue;
// // // // // // //     if (value is double) return value;
// // // // // // //     if (value is int) return value.toDouble();
// // // // // // //     if (value is String) return double.tryParse(value) ?? defaultValue;
// // // // // // //     return defaultValue;
// // // // // // //   }
// // // // // // // }

// // // // // // // class TextElement {
// // // // // // //   String id;
// // // // // // //   String text;
// // // // // // //   double x;
// // // // // // //   double y;
// // // // // // //   double width;
// // // // // // //   double height;
// // // // // // //   double fontSize;
// // // // // // //   Color color;
// // // // // // //   FontWeight fontWeight;
// // // // // // //   String fontFamily;
// // // // // // //   TextAlign textAlign;
// // // // // // //   bool isSelected;
// // // // // // //   double rotation;

// // // // // // //   TextElement({
// // // // // // //     required this.id,
// // // // // // //     required this.text,
// // // // // // //     required this.x,
// // // // // // //     required this.y,
// // // // // // //     this.width = 200,
// // // // // // //     this.height = 50,
// // // // // // //     this.fontSize = 16,
// // // // // // //     this.color = Colors.black,
// // // // // // //     this.fontWeight = FontWeight.normal,
// // // // // // //     this.fontFamily = 'Roboto',
// // // // // // //     this.textAlign = TextAlign.left,
// // // // // // //     this.isSelected = false,
// // // // // // //     this.rotation = 0,
// // // // // // //   });

// // // // // // //   factory TextElement.fromJson(Map<String, dynamic> json) {
// // // // // // //     return TextElement(
// // // // // // //       id: json['id'] ?? '',
// // // // // // //       text: json['text'] ?? '',
// // // // // // //       x: _parseDouble(json['x'], 0),
// // // // // // //       y: _parseDouble(json['y'], 0),
// // // // // // //       width: _parseDouble(json['width'], 200),
// // // // // // //       height: _parseDouble(json['height'], 50),
// // // // // // //       fontSize: _parseDouble(json['fontSize'], 16),
// // // // // // //       color: _parseColor(json['color']),
// // // // // // //       fontWeight: _fontWeightFromString(json['fontWeight'] ?? 'normal'),
// // // // // // //       fontFamily: json['fontFamily'] ?? 'Roboto',
// // // // // // //       textAlign: _textAlignFromString(json['textAlign'] ?? 'left'),
// // // // // // //       rotation: _parseDouble(json['rotation'], 0),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Map<String, dynamic> toJson() {
// // // // // // //     return {
// // // // // // //       'id': id,
// // // // // // //       'text': text,
// // // // // // //       'x': x,
// // // // // // //       'y': y,
// // // // // // //       'width': width,
// // // // // // //       'height': height,
// // // // // // //       'fontSize': fontSize,
// // // // // // //       'color': color.value,
// // // // // // //       'fontWeight': _fontWeightToString(fontWeight),
// // // // // // //       'fontFamily': fontFamily,
// // // // // // //       'textAlign': _textAlignToString(textAlign),
// // // // // // //       'rotation': rotation,
// // // // // // //     };
// // // // // // //   }

// // // // // // //   static double _parseDouble(dynamic value, double defaultValue) {
// // // // // // //     if (value == null) return defaultValue;
// // // // // // //     if (value is double) return value;
// // // // // // //     if (value is int) return value.toDouble();
// // // // // // //     if (value is String) return double.tryParse(value) ?? defaultValue;
// // // // // // //     return defaultValue;
// // // // // // //   }

// // // // // // //   static Color _parseColor(dynamic colorValue) {
// // // // // // //     if (colorValue == null) return Colors.black;

// // // // // // //     if (colorValue is int) {
// // // // // // //       return Color(colorValue);
// // // // // // //     }

// // // // // // //     if (colorValue is String) {
// // // // // // //       String hexColor = colorValue.replaceAll('#', '');
// // // // // // //       if (hexColor.length == 6) {
// // // // // // //         hexColor = 'FF$hexColor';
// // // // // // //       }
// // // // // // //       int? colorInt = int.tryParse(hexColor, radix: 16);
// // // // // // //       if (colorInt != null) {
// // // // // // //         return Color(colorInt);
// // // // // // //       }
// // // // // // //     }

// // // // // // //     return Colors.black;
// // // // // // //   }

// // // // // // //   static FontWeight _fontWeightFromString(String weight) {
// // // // // // //     switch (weight.toLowerCase()) {
// // // // // // //       case 'bold':
// // // // // // //         return FontWeight.bold;
// // // // // // //       case 'w300':
// // // // // // //         return FontWeight.w300;
// // // // // // //       case 'w600':
// // // // // // //         return FontWeight.w600;
// // // // // // //       case 'w700':
// // // // // // //         return FontWeight.w700;
// // // // // // //       default:
// // // // // // //         return FontWeight.normal;
// // // // // // //     }
// // // // // // //   }

// // // // // // //   static String _fontWeightToString(FontWeight weight) {
// // // // // // //     if (weight == FontWeight.bold) return 'bold';
// // // // // // //     if (weight == FontWeight.w300) return 'w300';
// // // // // // //     if (weight == FontWeight.w600) return 'w600';
// // // // // // //     if (weight == FontWeight.w700) return 'w700';
// // // // // // //     return 'normal';
// // // // // // //   }

// // // // // // //   static TextAlign _textAlignFromString(String align) {
// // // // // // //     switch (align.toLowerCase()) {
// // // // // // //       case 'center':
// // // // // // //         return TextAlign.center;
// // // // // // //       case 'right':
// // // // // // //         return TextAlign.right;
// // // // // // //       default:
// // // // // // //         return TextAlign.left;
// // // // // // //     }
// // // // // // //   }

// // // // // // //   static String _textAlignToString(TextAlign align) {
// // // // // // //     switch (align) {
// // // // // // //       case TextAlign.center:
// // // // // // //         return 'center';
// // // // // // //       case TextAlign.right:
// // // // // // //         return 'right';
// // // // // // //       default:
// // // // // // //         return 'left';
// // // // // // //     }
// // // // // // //   }
// // // // // // // }

// // // // // // // class ImageElement {
// // // // // // //   String id;
// // // // // // //   String imageUrl;
// // // // // // //   double x;
// // // // // // //   double y;
// // // // // // //   double width;
// // // // // // //   double height;
// // // // // // //   bool isSelected;
// // // // // // //   double rotation;
// // // // // // //   double borderRadius;

// // // // // // //   ImageElement({
// // // // // // //     required this.id,
// // // // // // //     required this.imageUrl,
// // // // // // //     required this.x,
// // // // // // //     required this.y,
// // // // // // //     this.width = 100,
// // // // // // //     this.height = 100,
// // // // // // //     this.isSelected = false,
// // // // // // //     this.rotation = 0,
// // // // // // //     this.borderRadius = 4.0,
// // // // // // //   });

// // // // // // //   factory ImageElement.fromJson(Map<String, dynamic> json) {
// // // // // // //     return ImageElement(
// // // // // // //       id: json['id'] ?? '',
// // // // // // //       imageUrl: json['imageUrl'] ?? '',
// // // // // // //       x: _parseDouble(json['x'], 0),
// // // // // // //       y: _parseDouble(json['y'], 0),
// // // // // // //       width: _parseDouble(json['width'], 100),
// // // // // // //       height: _parseDouble(json['height'], 100),
// // // // // // //       rotation: _parseDouble(json['rotation'], 0),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Map<String, dynamic> toJson() {
// // // // // // //     return {
// // // // // // //       'id': id,
// // // // // // //       'imageUrl': imageUrl,
// // // // // // //       'x': x,
// // // // // // //       'y': y,
// // // // // // //       'width': width,
// // // // // // //       'height': height,
// // // // // // //       'rotation': rotation,
// // // // // // //     };
// // // // // // //   }

// // // // // // //   static double _parseDouble(dynamic value, double defaultValue) {
// // // // // // //     if (value == null) return defaultValue;
// // // // // // //     if (value is double) return value;
// // // // // // //     if (value is int) return value.toDouble();
// // // // // // //     if (value is String) return double.tryParse(value) ?? defaultValue;
// // // // // // //     return defaultValue;
// // // // // // //   }
// // // // // // // }

// // // // // // // class ProfileElement {
// // // // // // //   String id;
// // // // // // //   String imageUrl;
// // // // // // //   double x;
// // // // // // //   double y;
// // // // // // //   double width;
// // // // // // //   double height;
// // // // // // //   bool isSelected;
// // // // // // //   double rotation;

// // // // // // //   ProfileElement({
// // // // // // //     required this.id,
// // // // // // //     required this.imageUrl,
// // // // // // //     required this.x,
// // // // // // //     required this.y,
// // // // // // //     this.width = 100,
// // // // // // //     this.height = 100,
// // // // // // //     this.isSelected = false,
// // // // // // //     this.rotation = 0,
// // // // // // //   });

// // // // // // //   factory ProfileElement.fromJson(Map<String, dynamic> json) {
// // // // // // //     return ProfileElement(
// // // // // // //       id: json['id'] ?? '',
// // // // // // //       imageUrl: json['imageUrl'] ?? '',
// // // // // // //       x: _parseDouble(0, 0),
// // // // // // //       y: _parseDouble(0, 0),
// // // // // // //       width: _parseDouble(300, 100),
// // // // // // //       height: _parseDouble(json['height'], 100),
// // // // // // //       rotation: _parseDouble(json['rotation'], 0),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Map<String, dynamic> toJson() {
// // // // // // //     return {
// // // // // // //       'id': id,
// // // // // // //       'imageUrl': imageUrl,
// // // // // // //       'x': x,
// // // // // // //       'y': y,
// // // // // // //       'width': width,
// // // // // // //       'height': height,
// // // // // // //       'rotation': rotation,
// // // // // // //     };
// // // // // // //   }

// // // // // // //   static double _parseDouble(dynamic value, double defaultValue) {
// // // // // // //     if (value == null) return defaultValue;
// // // // // // //     if (value is double) return value;
// // // // // // //     if (value is int) return value.toDouble();
// // // // // // //     if (value is String) return double.tryParse(value) ?? defaultValue;
// // // // // // //     return defaultValue;
// // // // // // //   }
// // // // // // // }

// // // // // // // class SamplePosterScreen extends StatefulWidget {
// // // // // // //   final String posterId;

// // // // // // //   const SamplePosterScreen({super.key, required this.posterId});

// // // // // // //   @override
// // // // // // //   State<SamplePosterScreen> createState() => _ApiPosterEditorState();
// // // // // // // }

// // // // // // // class _ApiPosterEditorState extends State<SamplePosterScreen> {
// // // // // // //   final TextEditingController _fontSizecontroller = TextEditingController();
// // // // // // //   final GlobalKey _canvasKey = GlobalKey();
// // // // // // //   PosterTemplate? _template;
// // // // // // //   bool _isLoading = true;
// // // // // // //   TextElement? _selectedTextElement;
// // // // // // //   ImageElement? _selectedImageElement;
// // // // // // //   ProfileElement? _selectedProfileImageElement;
// // // // // // //   bool _showToolbar = false;
// // // // // // //   String? _errorMessage;
// // // // // // //   double _scaleFactor = 1.0;
// // // // // // //   Size _canvasSize = Size.zero;
// // // // // // //   String? phoneNumber;
// // // // // // //   String? email;
// // // // // // //   String? userId;
// // // // // // //   String? profileImage;
// // // // // // //   Uint8List? _logoImage;
// // // // // // //   Uint8List? _profileImageBytes;
// // // // // // //   final ImagePicker _picker = ImagePicker();
// // // // // // //   double _currentScale = 1.0;
// // // // // // //   Offset _currentOffset = Offset.zero;
// // // // // // //   Offset _startOffset = Offset.zero;
// // // // // // //   Offset _normalizedOffset = Offset.zero;

// // // // // // //   Offset _focusPoint = Offset.zero;
// // // // // // //   double _previousScale = 1.0;

// // // // // // //   // For pinch zoom and pan handling
// // // // // // //   double _baseScale = 1.0;
// // // // // // //   double _currentBaseScale = 1.0;
// // // // // // //   Offset? _initialFocalPoint;

// // // // // // //   // Persistent image elements for profile and logo
// // // // // // //   ProfileElement? _profileImageElement;
// // // // // // //   ImageElement? _logoImageElement;

// // // // // // //   // Add these with your other state variables
// // // // // // //   double _businessNameFontSize = 20.0;
// // // // // // //   double _phoneNumberFontSize = 20.0;

// // // // // // //   // final List<String> _fontFamilies = [
// // // // // // //   //   'Roboto',
// // // // // // //   //   'Arial',
// // // // // // //   //   'Times New Roman',
// // // // // // //   //   'Helvetica',
// // // // // // //   //   'Comic Sans MS',
// // // // // // //   //   'Verdana',
// // // // // // //   //   'Courier New',
// // // // // // //   //   'Georgia',
// // // // // // //   //   'Palatino',
// // // // // // //   //   'Garamond',
// // // // // // //   // ];

// // // // // // //   // final List<String> _fontFamilies = [
// // // // // // //   //   'Roboto',
// // // // // // //   //   'Arial',
// // // // // // //   //   'Times New Roman',
// // // // // // //   //   'Helvetica',
// // // // // // //   //   'Comic Sans MS',
// // // // // // //   //   'Verdana',
// // // // // // //   //   'Courier New',
// // // // // // //   //   'Georgia',
// // // // // // //   //   'Palatino',
// // // // // // //   //   'Garamond',
// // // // // // //   //   'Tahoma',
// // // // // // //   //   'Trebuchet MS',
// // // // // // //   //   'Lucida Sans',
// // // // // // //   //   'Lucida Console',
// // // // // // //   //   'Segoe UI',
// // // // // // //   //   'Calibri',
// // // // // // //   //   'Optima',
// // // // // // //   //   'Candara',
// // // // // // //   //   'Futura',
// // // // // // //   //   'Franklin Gothic Medium',
// // // // // // //   //   'Impact',
// // // // // // //   //   'Book Antiqua',
// // // // // // //   // ];


  
// // // // // // //   final List<String> _fontFamilies = [
// // // // // // //   // System & Web Safe Fonts
// // // // // // //   'Roboto',
// // // // // // //   'Arial',
// // // // // // //   'Times New Roman',
// // // // // // //   'Helvetica',
// // // // // // //   'Comic Sans MS',
// // // // // // //   'Verdana',
// // // // // // //   'Courier New',
// // // // // // //   'Georgia',
// // // // // // //   'Palatino',
// // // // // // //   'Garamond',
// // // // // // //   'Tahoma',
// // // // // // //   'Trebuchet MS',
// // // // // // //   'Lucida Sans',
// // // // // // //   'Lucida Console',
// // // // // // //   'Segoe UI',
// // // // // // //   'Calibri',
// // // // // // //   'Optima',
// // // // // // //   'Candara',
// // // // // // //   'Futura',
// // // // // // //   'Franklin Gothic Medium',
// // // // // // //   'Impact',
// // // // // // //   'Book Antiqua',

// // // // // // //   // Generic Families
// // // // // // //   'Cursive',
// // // // // // //   'Monospace',
// // // // // // //   'Sans-serif',
// // // // // // //   'Serif',
// // // // // // //   'System-ui',

// // // // // // //   // Developer / Monospace
// // // // // // //   'Consolas',
// // // // // // //   'Monaco',
// // // // // // //   'Menlo',
// // // // // // //   'Fira Code',
// // // // // // //   'Source Code Pro',
// // // // // // //   'Inconsolata',
// // // // // // //   'Hack',
// // // // // // //   'JetBrains Mono',
// // // // // // //   'IBM Plex Mono',

// // // // // // //   // Google Fonts - Sans Serif
// // // // // // //   'Ubuntu',
// // // // // // //   'Lato',
// // // // // // //   'Open Sans',
// // // // // // //   'Raleway',
// // // // // // //   'Montserrat',
// // // // // // //   'Poppins',
// // // // // // //   'Nunito',
// // // // // // //   'Oswald',
// // // // // // //   'Muli',
// // // // // // //   'Work Sans',
// // // // // // //   'Barlow',
// // // // // // //   'Exo',
// // // // // // //   'Exo 2',
// // // // // // //   'Archivo',
// // // // // // //   'Karla',
// // // // // // //   'Hind',
// // // // // // //   'Noto Sans',
// // // // // // //   'DM Sans',
// // // // // // //   'Inter',
// // // // // // //   'Jost',
// // // // // // //   'Cabin',
// // // // // // //   'Mukta',
// // // // // // //   'Rubik',
// // // // // // //   'Manrope',
// // // // // // //   'Outfit',
// // // // // // //   'Plus Jakarta Sans',
// // // // // // //   'Figtree',
// // // // // // //   'Sora',
// // // // // // //   'Mulish',

// // // // // // //   // Google Fonts - Serif
// // // // // // //   'Playfair Display',
// // // // // // //   'Merriweather',
// // // // // // //   'Lora',
// // // // // // //   'Bitter',
// // // // // // //   'Noto Serif',
// // // // // // //   'EB Garamond',
// // // // // // //   'Libre Baskerville',
// // // // // // //   'Cormorant Garamond',
// // // // // // //   'Crimson Text',
// // // // // // //   'Spectral',
// // // // // // //   'DM Serif Display',
// // // // // // //   'Cardo',
// // // // // // //   'Alegreya',
// // // // // // //   'Source Serif Pro',
// // // // // // //   'IBM Plex Serif',
// // // // // // //   'PT Serif',

// // // // // // //   // Google Fonts - Display / Decorative
// // // // // // //   'Abril Fatface',
// // // // // // //   'Alfa Slab One',
// // // // // // //   'Anton',
// // // // // // //   'Bebas Neue',
// // // // // // //   'Black Han Sans',
// // // // // // //   'Boogaloo',
// // // // // // //   'Bree Serif',
// // // // // // //   'Chewy',
// // // // // // //   'Cinzel',
// // // // // // //   'Fredoka One',
// // // // // // //   'Graduate',
// // // // // // //   'Josefin Sans',
// // // // // // //   'Josefin Slab',
// // // // // // //   'Kalam',
// // // // // // //   'Lilita One',
// // // // // // //   'Lobster',
// // // // // // //   'Lobster Two',
// // // // // // //   'Monoton',
// // // // // // //   'Orbitron',
// // // // // // //   'Passion One',
// // // // // // //   'Patua One',
// // // // // // //   'Permanent Marker',
// // // // // // //   'Pirata One',
// // // // // // //   'Poiret One',
// // // // // // //   'Press Start 2P',
// // // // // // //   'Righteous',
// // // // // // //   'Rokkitt',
// // // // // // //   'Russo One',
// // // // // // //   'Sigmar One',
// // // // // // //   'Special Elite',
// // // // // // //   'Teko',
// // // // // // //   'Titan One',
// // // // // // //   'Unica One',
// // // // // // //   'Ultra',
// // // // // // //   'Vollkorn',
// // // // // // //   'Yanone Kaffeesatz',
// // // // // // //   'Zilla Slab',

// // // // // // //   // Google Fonts - Handwriting / Script
// // // // // // //   'Dancing Script',
// // // // // // //   'Pacifico',
// // // // // // //   'Satisfy',
// // // // // // //   'Great Vibes',
// // // // // // //   'Courgette',
// // // // // // //   'Kaushan Script',
// // // // // // //   'Sacramento',
// // // // // // //   'Allura',
// // // // // // //   'Alex Brush',
// // // // // // //   'Amatic SC',
// // // // // // //   'Caveat',
// // // // // // //   'Cookie',
// // // // // // //   'Damion',
// // // // // // //   'Dawning of a New Day',
// // // // // // //   'Handlee',
// // // // // // //   'Indie Flower',
// // // // // // //   'Just Another Hand',
// // // // // // //   'Marck Script',
// // // // // // //   'Parisienne',
// // // // // // //   'Patrick Hand',
// // // // // // //   'Pinyon Script',
// // // // // // //   'Quicksand',
// // // // // // //   'Shadows Into Light',
// // // // // // //   'Yellowtail',
// // // // // // //   'Zeyada',

// // // // // // //   // Classic / Traditional
// // // // // // //   'Brush Script MT',
// // // // // // //   'Copperplate',
// // // // // // //   'Papyrus',
// // // // // // //   'Rockwell',
// // // // // // //   'Century Gothic',
// // // // // // //   'Gill Sans',
// // // // // // //   'Baskerville',
// // // // // // //   'Bodoni MT',
// // // // // // //   'Cambria',
// // // // // // //   'Constantia',
// // // // // // //   'Didact Gothic',
// // // // // // //   'Perpetua',
// // // // // // //   'Goudy Old Style',
// // // // // // // ];



// // // // // // // //   final List<String> _fontFamilies = [
// // // // // // // //   'Roboto',
// // // // // // // //   'Arial',
// // // // // // // //   'Times New Roman',
// // // // // // // //   'Helvetica',
// // // // // // // //   'Comic Sans MS',
// // // // // // // //   'Verdana',
// // // // // // // //   'Courier New',
// // // // // // // //   'Georgia',
// // // // // // // //   'Palatino',
// // // // // // // //   'Garamond',
// // // // // // // //   'Tahoma',
// // // // // // // //   'Trebuchet MS',
// // // // // // // //   'Lucida Sans',
// // // // // // // //   'Lucida Console',
// // // // // // // //   'Segoe UI',
// // // // // // // //   'Calibri',
// // // // // // // //   'Optima',
// // // // // // // //   'Candara',
// // // // // // // //   'Futura',
// // // // // // // //   'Franklin Gothic Medium',
// // // // // // // //   'Impact',
// // // // // // // //   'Book Antiqua',
// // // // // // // //   // Add more fonts below:
// // // // // // // //   'Cursive',
// // // // // // // //   'Monospace',
// // // // // // // //   'Sans-serif',
// // // // // // // //   'Serif',
// // // // // // // //   'System-ui',
// // // // // // // //   'Consolas',
// // // // // // // //   'Monaco',
// // // // // // // //   'Menlo',
// // // // // // // //   'Ubuntu',
// // // // // // // //   'Lato',
// // // // // // // //   'Open Sans',
// // // // // // // //   'Raleway',
// // // // // // // //   'Montserrat',
// // // // // // // //   'Poppins',
// // // // // // // //   'Nunito',
// // // // // // // //   'Playfair Display',
// // // // // // // //   'Merriweather',
// // // // // // // //   'Oswald',
// // // // // // // //   'Abril Fatface',
// // // // // // // //   'Dancing Script',
// // // // // // // //   'Pacifico',
// // // // // // // //   'Lobster',
// // // // // // // //   'Satisfy',
// // // // // // // //   'Great Vibes',
// // // // // // // //   'Brush Script MT',
// // // // // // // //   'Copperplate',
// // // // // // // //   'Papyrus',
// // // // // // // //   'Rockwell',
// // // // // // // //   'Century Gothic',
// // // // // // // //   'Gill Sans',
// // // // // // // // ];

// // // // // // //   // final List<FontWeight> _fontWeights = [
// // // // // // //   //   FontWeight.w300,
// // // // // // //   //   FontWeight.normal,
// // // // // // //   //   FontWeight.w600,
// // // // // // //   //   FontWeight.bold, // This is the same as FontWeight.w700
// // // // // // //   //   FontWeight.w900,
// // // // // // //   // ];

// // // // // // //   final List<FontWeight> _fontWeights = [
// // // // // // //     FontWeight.w100, // Thin
// // // // // // //     FontWeight.w200, // Extra Light
// // // // // // //     FontWeight.w300, // Light
// // // // // // //     FontWeight.w400, // Normal / Regular
// // // // // // //     FontWeight.w500, // Medium
// // // // // // //     FontWeight.w600, // Semi Bold
// // // // // // //     FontWeight.w700, // Bold
// // // // // // //     FontWeight.w800, // Extra Bold
// // // // // // //     FontWeight.w900, // Black / Heavy
// // // // // // //   ];

// // // // // // //   final List<Color> _colors = [
// // // // // // //     Colors.black,
// // // // // // //     Colors.white,
// // // // // // //     Colors.red,
// // // // // // //     Colors.blue,
// // // // // // //     Colors.green,
// // // // // // //     Colors.yellow,
// // // // // // //     Colors.purple,
// // // // // // //     Colors.orange,
// // // // // // //     Colors.pink,
// // // // // // //     Colors.brown,
// // // // // // //     Colors.grey,
// // // // // // //     Colors.indigo,
// // // // // // //     Colors.teal,
// // // // // // //     Colors.amber,
// // // // // // //     Colors.deepOrange,
// // // // // // //     Colors.cyan,
// // // // // // //     Colors.lime,
// // // // // // //     Colors.deepPurple,
// // // // // // //   ];

// // // // // // //   @override
// // // // // // //   void initState() {
// // // // // // //     super.initState();
// // // // // // //     _loadPosterFromApi();
// // // // // // //     _loadUserData();

// // // // // // //     WidgetsBinding.instance.addPostFrameCallback((_) {
// // // // // // //     final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
// // // // // // //     languageProvider.addListener(_onLanguageChanged);
// // // // // // //   });

    
// // // // // // //   }


// // // // // // //   void _onLanguageChanged() {
// // // // // // //   // Refresh customer data when language changes
// // // // // // //   final customerProvider = Provider.of<CreateCustomerProvider>(context, listen: false);
// // // // // // //   if (userId != null) {
// // // // // // //     customerProvider.fetchUser(userId.toString());
// // // // // // //   }
// // // // // // // }

// // // // // // //   Future<void> _loadUserData() async {
// // // // // // //     final userData = await AuthPreferences.getUserData();
// // // // // // //     if (userData != null) {
// // // // // // //       setState(() {
// // // // // // //         phoneNumber = userData.user.mobile ?? phoneNumber;
// // // // // // //         profileImage = userData.user.profileImage;
// // // // // // //         email = userData.user.email ?? email;
// // // // // // //         userId = userData.user.id ?? userId;
// // // // // // //       });

// // // // // // //       if (profileImage != null && profileImage!.isNotEmpty) {
// // // // // // //         _loadProfileImage();
// // // // // // //       }

// // // // // // //       if (_template != null) {
// // // // // // //         _updateTextElementsWithUserData();
// // // // // // //       }
// // // // // // //     }
// // // // // // //   }

// // // // // // //   void _showColorPickerDialog() {
// // // // // // //     if (_selectedTextElement == null) return;

// // // // // // //     Color currentColor = _selectedTextElement!.color;
// // // // // // //     Color tempColor = currentColor; // Track temporary color separately

// // // // // // //     final List<Color> _presetColors = [
// // // // // // //       Colors.black,
// // // // // // //       Colors.white,
// // // // // // //       Colors.red,
// // // // // // //       Colors.blue,
// // // // // // //       Colors.green,
// // // // // // //       Colors.yellow,
// // // // // // //       Colors.orange,
// // // // // // //       Colors.purple,
// // // // // // //       Colors.pink,
// // // // // // //       Colors.teal,
// // // // // // //       Colors.cyan,
// // // // // // //       Colors.amber,
// // // // // // //       Colors.indigo,
// // // // // // //       Colors.lime,
// // // // // // //       Colors.brown,
// // // // // // //       Colors.grey,
// // // // // // //     ];

// // // // // // //     showDialog(
// // // // // // //       context: context,
// // // // // // //       builder: (context) => StatefulBuilder(
// // // // // // //         builder: (context, setDialogState) {
// // // // // // //           return AlertDialog(
// // // // // // //             title: const Text('Pick Text Color'),
// // // // // // //             content: SingleChildScrollView(
// // // // // // //               child: Column(
// // // // // // //                 mainAxisSize: MainAxisSize.min,
// // // // // // //                 children: [
// // // // // // //                   // Color preview
// // // // // // //                   Container(
// // // // // // //                     width: double.infinity,
// // // // // // //                     height: 60,
// // // // // // //                     decoration: BoxDecoration(
// // // // // // //                       color: tempColor,
// // // // // // //                       borderRadius: BorderRadius.circular(8),
// // // // // // //                       border: Border.all(color: Colors.grey),
// // // // // // //                     ),
// // // // // // //                     child: Center(
// // // // // // //                       child: Text(
// // // // // // //                         'Preview Text',
// // // // // // //                         style: TextStyle(
// // // // // // //                           color: _getContrastColor(tempColor),
// // // // // // //                           fontSize: 16,
// // // // // // //                           fontWeight: FontWeight.bold,
// // // // // // //                         ),
// // // // // // //                       ),
// // // // // // //                     ),
// // // // // // //                   ),
// // // // // // //                   const SizedBox(height: 20),

// // // // // // //                   // Preset colors grid
// // // // // // //                   const Text(
// // // // // // //                     'Preset Colors:',
// // // // // // //                     style: TextStyle(fontWeight: FontWeight.bold),
// // // // // // //                   ),
// // // // // // //                   const SizedBox(height: 10),
// // // // // // //                   GridView.builder(
// // // // // // //                     shrinkWrap: true,
// // // // // // //                     physics: const NeverScrollableScrollPhysics(),
// // // // // // //                     gridDelegate:
// // // // // // //                         const SliverGridDelegateWithFixedCrossAxisCount(
// // // // // // //                           crossAxisCount: 8,
// // // // // // //                           crossAxisSpacing: 8,
// // // // // // //                           mainAxisSpacing: 8,
// // // // // // //                         ),
// // // // // // //                     itemCount: _presetColors.length,
// // // // // // //                     itemBuilder: (context, index) {
// // // // // // //                       final color = _presetColors[index];
// // // // // // //                       final isSelected = tempColor == color;
// // // // // // //                       return GestureDetector(
// // // // // // //                         onTap: () {
// // // // // // //                           setDialogState(() {
// // // // // // //                             tempColor = color;
// // // // // // //                           });
// // // // // // //                         },
// // // // // // //                         child: Container(
// // // // // // //                           decoration: BoxDecoration(
// // // // // // //                             color: color,
// // // // // // //                             shape: BoxShape.circle,
// // // // // // //                             border: Border.all(
// // // // // // //                               color: isSelected ? Colors.blue : Colors.grey,
// // // // // // //                               width: isSelected ? 3 : 1,
// // // // // // //                             ),
// // // // // // //                             boxShadow: isSelected
// // // // // // //                                 ? [
// // // // // // //                                     BoxShadow(
// // // // // // //                                       color: Colors.blue.withOpacity(0.5),
// // // // // // //                                       blurRadius: 8,
// // // // // // //                                       spreadRadius: 2,
// // // // // // //                                     ),
// // // // // // //                                   ]
// // // // // // //                                 : null,
// // // // // // //                           ),
// // // // // // //                           child: isSelected
// // // // // // //                               ? const Icon(
// // // // // // //                                   Icons.check,
// // // // // // //                                   color: Colors.white,
// // // // // // //                                   size: 16,
// // // // // // //                                 )
// // // // // // //                               : null,
// // // // // // //                         ),
// // // // // // //                       );
// // // // // // //                     },
// // // // // // //                   ),
// // // // // // //                   const SizedBox(height: 20),

// // // // // // //                   // Advanced color picker
// // // // // // //                   const Text(
// // // // // // //                     'Custom Color:',
// // // // // // //                     style: TextStyle(fontWeight: FontWeight.bold),
// // // // // // //                   ),
// // // // // // //                   const SizedBox(height: 10),
// // // // // // //                   ColorPicker(
// // // // // // //                     pickerColor: tempColor,
// // // // // // //                     onColorChanged: (color) {
// // // // // // //                       setDialogState(() {
// // // // // // //                         tempColor = color;
// // // // // // //                       });
// // // // // // //                     },
// // // // // // //                     pickerAreaHeightPercent: 0.4,
// // // // // // //                     enableAlpha: false,
// // // // // // //                     displayThumbColor: true,
// // // // // // //                     colorPickerWidth: 300,
// // // // // // //                     pickerAreaBorderRadius: BorderRadius.circular(12),
// // // // // // //                     hexInputBar: false,
// // // // // // //                     labelTypes: const [],
// // // // // // //                   ),
// // // // // // //                 ],
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //             actions: [
// // // // // // //               TextButton(
// // // // // // //                 onPressed: () {
// // // // // // //                   // Don't apply changes - just close
// // // // // // //                   Navigator.pop(context);
// // // // // // //                 },
// // // // // // //                 child: const Text('Cancel'),
// // // // // // //               ),
// // // // // // //               TextButton(
// // // // // // //                 onPressed: () {
// // // // // // //                   // Apply the color change to the main widget state
// // // // // // //                   setState(() {
// // // // // // //                     _selectedTextElement!.color = tempColor;
// // // // // // //                   });
// // // // // // //                   Navigator.pop(context);
// // // // // // //                 },
// // // // // // //                 child: const Text('Apply'),
// // // // // // //               ),
// // // // // // //             ],
// // // // // // //           );
// // // // // // //         },
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }


// // // // // // //   @override
// // // // // // // void dispose() {
// // // // // // //   // Remove the language listener
// // // // // // //   final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
// // // // // // //   languageProvider.removeListener(_onLanguageChanged);
  
// // // // // // //   super.dispose();
// // // // // // // }

// // // // // // //   // Helper method to get contrast color (add this if not present)
// // // // // // //   Color _getContrastColor(Color backgroundColor) {
// // // // // // //     // Calculate the perceptive luminance
// // // // // // //     double luminance =
// // // // // // //         (0.299 * backgroundColor.red +
// // // // // // //             0.587 * backgroundColor.green +
// // // // // // //             0.114 * backgroundColor.blue) /
// // // // // // //         255;
// // // // // // //     return luminance > 0.5 ? Colors.black : Colors.white;
// // // // // // //   }

// // // // // // //   void _showManualSizeInputDialog() {
// // // // // // //     if (_selectedTextElement == null) return;

// // // // // // //     _fontSizecontroller.text = _selectedTextElement!.fontSize
// // // // // // //         .round()
// // // // // // //         .toString();

// // // // // // //     showDialog(
// // // // // // //       context: context,
// // // // // // //       builder: (context) => AlertDialog(
// // // // // // //         title: const Text('Enter Font Size'),
// // // // // // //         content: TextField(
// // // // // // //           controller: _fontSizecontroller,
// // // // // // //           keyboardType: TextInputType.number,
// // // // // // //           decoration: const InputDecoration(
// // // // // // //             hintText: 'Enter font size...',
// // // // // // //             border: OutlineInputBorder(),
// // // // // // //             suffixText: 'px',
// // // // // // //           ),
// // // // // // //         ),
// // // // // // //         actions: [
// // // // // // //           TextButton(
// // // // // // //             onPressed: () => Navigator.pop(context),
// // // // // // //             child: const Text('Cancel'),
// // // // // // //           ),
// // // // // // //           TextButton(
// // // // // // //             onPressed: () {
// // // // // // //               final newSize = double.tryParse(_fontSizecontroller.text);
// // // // // // //               if (newSize != null && newSize >= 8 && newSize <= 600) {
// // // // // // //                 setState(() {
// // // // // // //                   _selectedTextElement!.fontSize = newSize;
// // // // // // //                   // Auto-adjust dimensions for large text
// // // // // // //                   if (newSize > 100) {
// // // // // // //                     final textLength = _selectedTextElement!.text.length;
// // // // // // //                     _selectedTextElement!.width = (textLength * newSize * 0.5)
// // // // // // //                         .clamp(200.0, _template!.width * 2);
// // // // // // //                     _selectedTextElement!.height = (newSize * 1.5).clamp(
// // // // // // //                       50.0,
// // // // // // //                       _template!.height * 2,
// // // // // // //                     );
// // // // // // //                   }
// // // // // // //                 });
// // // // // // //                 Navigator.pop(context);
// // // // // // //               } else {
// // // // // // //                 ScaffoldMessenger.of(context).showSnackBar(
// // // // // // //                   const SnackBar(
// // // // // // //                     content: Text(
// // // // // // //                       'Please enter a valid size between 8 and 600',
// // // // // // //                     ),
// // // // // // //                     backgroundColor: Colors.red,
// // // // // // //                   ),
// // // // // // //                 );
// // // // // // //               }
// // // // // // //             },
// // // // // // //             child: const Text('Apply'),
// // // // // // //           ),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Future<void> _loadProfileImage() async {
// // // // // // //     try {
// // // // // // //       final response = await http.get(Uri.parse(profileImage!));
// // // // // // //       if (response.statusCode == 200) {
// // // // // // //         setState(() {
// // // // // // //           _profileImageBytes = response.bodyBytes;
// // // // // // //           // Create persistent profile image element
// // // // // // //           _profileImageElement = ProfileElement(
// // // // // // //             id: 'profile_image',
// // // // // // //             imageUrl: '',
// // // // // // //             x: 10,
// // // // // // //             y: 10,
// // // // // // //             width: 200,
// // // // // // //             height: 200,
// // // // // // //           );
// // // // // // //         });
// // // // // // //       }
// // // // // // //     } catch (e) {
// // // // // // //       debugPrint('Error loading profile image: $e');
// // // // // // //     }
// // // // // // //   }

// // // // // // //   void _updateTextElementsWithUserData() {
// // // // // // //     if (_template == null) return;

// // // // // // //     setState(() {
// // // // // // //       for (var element in _template!.textElements) {
// // // // // // //         switch (element.id) {
// // // // // // //           case 'email':
// // // // // // //             if (email != null && email!.isNotEmpty) {
// // // // // // //               element.text = email!;
// // // // // // //             }
// // // // // // //             break;
// // // // // // //           case 'mobile':
// // // // // // //             if (phoneNumber != null && phoneNumber!.isNotEmpty) {
// // // // // // //               element.text = phoneNumber!;
// // // // // // //             }
// // // // // // //             break;
// // // // // // //         }
// // // // // // //       }
// // // // // // //     });
// // // // // // //   }

// // // // // // //   void _calculateScaleFactor(Size screenSize) {
// // // // // // //     if (_template == null) return;

// // // // // // //     final availableHeight = screenSize.height - 200;
// // // // // // //     final availableWidth = screenSize.width - 32;

// // // // // // //     final scaleX = availableWidth / _template!.width;
// // // // // // //     final scaleY = availableHeight / _template!.height;

// // // // // // //     _scaleFactor = scaleX < scaleY ? scaleX : scaleY;

// // // // // // //     if (_scaleFactor < 0.3) _scaleFactor = 0.3;
// // // // // // //     if (_scaleFactor > 1.5) _scaleFactor = 1.5;

// // // // // // //     _canvasSize = Size(
// // // // // // //       _template!.width * _scaleFactor,
// // // // // // //       _template!.height * _scaleFactor,
// // // // // // //     );
// // // // // // //   }

// // // // // // //   // Future<void> _loadPosterFromApi() async {
// // // // // // //   //   try {
// // // // // // //   //     setState(() {
// // // // // // //   //       _isLoading = true;
// // // // // // //   //       _errorMessage = null;
// // // // // // //   //     });

// // // // // // //   //     final response = await http.get(
// // // // // // //   //       Uri.parse(
// // // // // // //   //         'http://31.97.206.144:4061/api/poster/singlecanvasposters/${widget.posterId}',
// // // // // // //   //       ),
// // // // // // //   //       headers: {'Content-Type': 'application/json'},
// // // // // // //   //     );

// // // // // // //   //     if (response.statusCode == 200) {
// // // // // // //   //       final apiResponse = json.decode(response.body) as Map<String, dynamic>;
// // // // // // //   //       final template = PosterTemplate.fromApiResponse(apiResponse);

// // // // // // //   //       setState(() {
// // // // // // //   //         _template = template;
// // // // // // //   //         _isLoading = false;
// // // // // // //   //       });

// // // // // // //   //       _updateTextElementsWithUserData();
// // // // // // //   //     } else {
// // // // // // //   //       throw Exception('Failed to load poster: ${response.statusCode}');
// // // // // // //   //     }
// // // // // // //   //   } catch (e, stackTrace) {
// // // // // // //   //     debugPrint("Error loading poster from API: $e");
// // // // // // //   //     debugPrint("Stack trace: $stackTrace");
// // // // // // //   //     setState(() {
// // // // // // //   //       _errorMessage = "Failed to load poster: $e";
// // // // // // //   //       _isLoading = false;
// // // // // // //   //     });
// // // // // // //   //   }
// // // // // // //   // }



// // // // // // //   Future<void> _loadPosterFromApi() async {
// // // // // // //   try {
// // // // // // //     setState(() {
// // // // // // //       _isLoading = true;
// // // // // // //       _errorMessage = null;
// // // // // // //     });

// // // // // // //     final response = await http.get(
// // // // // // //       Uri.parse(
// // // // // // //         'http://31.97.206.144:4061/api/poster/singlecanvasposters/${widget.posterId}',
// // // // // // //       ),
// // // // // // //       headers: {'Content-Type': 'application/json'},
// // // // // // //     );

// // // // // // //     if (response.statusCode == 200) {
// // // // // // //       final apiResponse = json.decode(response.body) as Map<String, dynamic>;
// // // // // // //       final template = PosterTemplate.fromApiResponse(apiResponse);

// // // // // // //       setState(() {
// // // // // // //         _template = template;
// // // // // // //         _isLoading = false;
// // // // // // //       });

// // // // // // //       _updateTextElementsWithUserData();
      
// // // // // // //       // ADD THIS: Load saved business name after template is loaded
// // // // // // //       await _loadSavedBusinessName();
// // // // // // //     } else {
// // // // // // //       throw Exception('Failed to load poster: ${response.statusCode}');
// // // // // // //     }
// // // // // // //   } catch (e, stackTrace) {
// // // // // // //     debugPrint("Error loading poster from API: $e");
// // // // // // //     debugPrint("Stack trace: $stackTrace");
// // // // // // //     setState(() {
// // // // // // //       _errorMessage = "Failed to load poster: $e";
// // // // // // //       _isLoading = false;
// // // // // // //     });
// // // // // // //   }
// // // // // // // }



// // // // // // // Future<void> _loadSavedBusinessName() async {
// // // // // // //     final savedName = await _loadBusinessName();
// // // // // // //     if (savedName != null && savedName.isNotEmpty && _template != null) {
// // // // // // //       setState(() {
// // // // // // //         final nameElement = _template!.textElements.firstWhere(
// // // // // // //           (e) => e.id == 'name',
// // // // // // //           orElse: () =>
// // // // // // //               TextElement(id: 'name', text: 'Business Name', x: 0, y: 0),
// // // // // // //         );
// // // // // // //         nameElement.text = savedName;
// // // // // // //       });
// // // // // // //     }
// // // // // // //   }



// // // // // // //   Future<void> _saveBusinessName(String name) async {
// // // // // // //     final prefs = await SharedPreferences.getInstance();
// // // // // // //     await prefs.setString('business_name', name);
// // // // // // //   }

// // // // // // //   // Load business name from SharedPreferences
// // // // // // //   Future<String?> _loadBusinessName() async {
// // // // // // //     final prefs = await SharedPreferences.getInstance();
// // // // // // //     return prefs.getString('business_name');
// // // // // // //   }

// // // // // // //   // Update business name in SharedPreferences
// // // // // // //   Future<void> _updateBusinessName(String newName) async {
// // // // // // //     await _saveBusinessName(newName); // Reuses the save method
// // // // // // //   }

// // // // // // //   Future<void> _pickLogoImage() async {
// // // // // // //     try {
// // // // // // //       final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
// // // // // // //       if (image != null) {
// // // // // // //         final bytes = await image.readAsBytes();
// // // // // // //         setState(() {
// // // // // // //           _logoImage = bytes;
// // // // // // //           // Create persistent logo image element
// // // // // // //           _logoImageElement = ImageElement(
// // // // // // //             id: 'logo_image',
// // // // // // //             imageUrl: '',
// // // // // // //             x: _template != null ? _template!.width - 120 : 20,
// // // // // // //             y: 20,
// // // // // // //             width: 100,
// // // // // // //             height: 100,
// // // // // // //           );
// // // // // // //         });
// // // // // // //       }
// // // // // // //     } catch (e) {
// // // // // // //       debugPrint('Error picking logo image: $e');
// // // // // // //       ScaffoldMessenger.of(
// // // // // // //         context,
// // // // // // //       ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
// // // // // // //     }
// // // // // // //   }

// // // // // // //   Future<void> _pickAdditionalImage() async {
// // // // // // //     try {
// // // // // // //       final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
// // // // // // //       if (image != null) {
// // // // // // //         final bytes = await image.readAsBytes();
// // // // // // //         final tempDir = await getTemporaryDirectory();
// // // // // // //         final file = File(
// // // // // // //           '${tempDir.path}/additional_${DateTime.now().millisecondsSinceEpoch}.png',
// // // // // // //         );
// // // // // // //         await file.writeAsBytes(bytes);

// // // // // // //         setState(() {
// // // // // // //           _template?.imageElements.add(
// // // // // // //             ImageElement(
// // // // // // //               id: 'additional_${DateTime.now().millisecondsSinceEpoch}',
// // // // // // //               imageUrl: file.path,
// // // // // // //               x: _template!.width / 2 - 100,
// // // // // // //               y: _template!.height / 2 - 100,
// // // // // // //               width: 200,
// // // // // // //               height: 200,
// // // // // // //             ),
// // // // // // //           );
// // // // // // //         });
// // // // // // //       }
// // // // // // //     } catch (e) {
// // // // // // //       debugPrint('Error picking additional image: $e');
// // // // // // //       ScaffoldMessenger.of(
// // // // // // //         context,
// // // // // // //       ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
// // // // // // //     }
// // // // // // //   }

// // // // // // //   // Future<void> _showCustomerSelectionDialog() async {
// // // // // // //   //   final customerProvider = Provider.of<CreateCustomerProvider>(
// // // // // // //   //     context,
// // // // // // //   //     listen: false,
// // // // // // //   //   );

// // // // // // //   //   // Fetch customers if not already loaded
// // // // // // //   //   if (customerProvider.customers.isEmpty) {
// // // // // // //   //     await customerProvider.fetchUser(userId.toString());
// // // // // // //   //   }

// // // // // // //   //   if (customerProvider.customers.isEmpty) {
// // // // // // //   //     ScaffoldMessenger.of(context).showSnackBar(
// // // // // // //   //       const SnackBar(
// // // // // // //   //         content: Text('No customers available. Please add customers first.'),
// // // // // // //   //         backgroundColor: Colors.orange,
// // // // // // //   //       ),
// // // // // // //   //     );
// // // // // // //   //     return;
// // // // // // //   //   }

// // // // // // //   //   // Track selected customers
// // // // // // //   //   Set<String> selectedCustomerIds = {};

// // // // // // //   //   showDialog(
// // // // // // //   //     context: context,
// // // // // // //   //     builder: (context) => StatefulBuilder(
// // // // // // //   //       builder: (context, setDialogState) => AlertDialog(
// // // // // // //   //         title: Row(
// // // // // // //   //           children: [
// // // // // // //   //             const Icon(Icons.people, color: Colors.deepPurple),
// // // // // // //   //             const SizedBox(width: 8),
// // // // // // //   //             const Text('Share Customers'),
// // // // // // //   //             const Spacer(),
// // // // // // //   //             if (selectedCustomerIds.isNotEmpty)
// // // // // // //   //               Container(
// // // // // // //   //                 padding: const EdgeInsets.symmetric(
// // // // // // //   //                   horizontal: 8,
// // // // // // //   //                   vertical: 4,
// // // // // // //   //                 ),
// // // // // // //   //                 decoration: BoxDecoration(
// // // // // // //   //                   color: Colors.deepPurple,
// // // // // // //   //                   borderRadius: BorderRadius.circular(12),
// // // // // // //   //                 ),
// // // // // // //   //                 // child: Text(
// // // // // // //   //                 //   '${selectedCustomerIds.length}',
// // // // // // //   //                 //   style: const TextStyle(color: Colors.white, fontSize: 12),
// // // // // // //   //                 // ),
// // // // // // //   //               ),
// // // // // // //   //           ],
// // // // // // //   //         ),
// // // // // // //   //         content: SizedBox(
// // // // // // //   //           width: double.maxFinite,
// // // // // // //   //           height: 400,
// // // // // // //   //           child: Column(
// // // // // // //   //             children: [
// // // // // // //   //               // Select All / Deselect All
// // // // // // //   //               CheckboxListTile(
// // // // // // //   //                 title: Text(
// // // // // // //   //                   selectedCustomerIds.length ==
// // // // // // //   //                           customerProvider.customers.length
// // // // // // //   //                       ? 'Deselect All'
// // // // // // //   //                       : 'Select All',
// // // // // // //   //                   style: const TextStyle(fontWeight: FontWeight.bold),
// // // // // // //   //                 ),
// // // // // // //   //                 value:
// // // // // // //   //                     selectedCustomerIds.length ==
// // // // // // //   //                     customerProvider.customers.length,
// // // // // // //   //                 onChanged: (value) {
// // // // // // //   //                   setDialogState(() {
// // // // // // //   //                     if (value == true) {
// // // // // // //   //                       selectedCustomerIds = customerProvider.customers
// // // // // // //   //                           .map((c) => c['_id'] as String)
// // // // // // //   //                           .toSet();
// // // // // // //   //                     } else {
// // // // // // //   //                       selectedCustomerIds.clear();
// // // // // // //   //                     }
// // // // // // //   //                   });
// // // // // // //   //                 },
// // // // // // //   //                 activeColor: Colors.deepPurple,
// // // // // // //   //               ),
// // // // // // //   //               const Divider(),

// // // // // // //   //               // Customer List
// // // // // // //   //               Expanded(
// // // // // // //   //                 child: ListView.builder(
// // // // // // //   //                   itemCount: customerProvider.customers.length,
// // // // // // //   //                   itemBuilder: (context, index) {
// // // // // // //   //                     final customer = customerProvider.customers[index];
// // // // // // //   //                     final customerId = customer['_id'] as String;
// // // // // // //   //                     final isSelected = selectedCustomerIds.contains(
// // // // // // //   //                       customerId,
// // // // // // //   //                     );

// // // // // // //   //                     return CheckboxListTile(
// // // // // // //   //                       secondary: CircleAvatar(
// // // // // // //   //                         backgroundColor: Colors.deepPurple,
// // // // // // //   //                         child: Text(
// // // // // // //   //                           (customer['name'] ?? 'U')[0].toUpperCase(),
// // // // // // //   //                           style: const TextStyle(color: Colors.white),
// // // // // // //   //                         ),
// // // // // // //   //                       ),
// // // // // // //   //                       title: Text(
// // // // // // //   //                         customer['name'] ?? 'Unknown',
// // // // // // //   //                         style: const TextStyle(fontWeight: FontWeight.w600),
// // // // // // //   //                       ),
// // // // // // //   //                       subtitle: Column(
// // // // // // //   //                         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //   //                         children: [
// // // // // // //   //                           if (customer['mobile'] != null)
// // // // // // //   //                             Text(
// // // // // // //   //                               customer['mobile'],
// // // // // // //   //                               style: const TextStyle(fontSize: 12),
// // // // // // //   //                             ),
// // // // // // //   //                           if (customer['email'] != null)
// // // // // // //   //                             Text(
// // // // // // //   //                               customer['email'],
// // // // // // //   //                               style: const TextStyle(fontSize: 11),
// // // // // // //   //                             ),
// // // // // // //   //                         ],
// // // // // // //   //                       ),
// // // // // // //   //                       value: isSelected,
// // // // // // //   //                       onChanged: (value) {
// // // // // // //   //                         setDialogState(() {
// // // // // // //   //                           if (value == true) {
// // // // // // //   //                             selectedCustomerIds.add(customerId);
// // // // // // //   //                           } else {
// // // // // // //   //                             selectedCustomerIds.remove(customerId);
// // // // // // //   //                           }
// // // // // // //   //                         });
// // // // // // //   //                       },
// // // // // // //   //                       activeColor: Colors.deepPurple,
// // // // // // //   //                     );
// // // // // // //   //                   },
// // // // // // //   //                 ),
// // // // // // //   //               ),
// // // // // // //   //             ],
// // // // // // //   //           ),
// // // // // // //   //         ),
// // // // // // //   //         actions: [
// // // // // // //   //           TextButton(
// // // // // // //   //             onPressed: () => Navigator.pop(context),
// // // // // // //   //             child: const Text('Cancel'),
// // // // // // //   //           ),
// // // // // // //   //           ElevatedButton.icon(
// // // // // // //   //             onPressed: selectedCustomerIds.isEmpty
// // // // // // //   //                 ? null
// // // // // // //   //                 : () async {
// // // // // // //   //                     Navigator.pop(context);
// // // // // // //   //                     await _sharePosterWithSelectedCustomers(
// // // // // // //   //                       selectedCustomerIds,
// // // // // // //   //                       customerProvider.customers,
// // // // // // //   //                     );
// // // // // // //   //                   },
// // // // // // //   //             style: ElevatedButton.styleFrom(
// // // // // // //   //               backgroundColor: Colors.deepPurple,
// // // // // // //   //               foregroundColor: Colors.white,
// // // // // // //   //               disabledBackgroundColor: Colors.grey,
// // // // // // //   //             ),
// // // // // // //   //             icon: const Icon(Icons.share, size: 18),
// // // // // // //   //             label: Text('Share (${selectedCustomerIds.length})'),
// // // // // // //   //           ),
// // // // // // //   //         ],
// // // // // // //   //       ),
// // // // // // //   //     ),
// // // // // // //   //   );
// // // // // // //   // }


// // // // // // // Future<void> _showCustomerSelectionDialog() async {
// // // // // // //   final customerProvider = Provider.of<CreateCustomerProvider>(
// // // // // // //     context,
// // // // // // //     listen: false,
// // // // // // //   );

// // // // // // //   // Fetch customers if not already loaded
// // // // // // //   if (customerProvider.customers.isEmpty) {
// // // // // // //     await customerProvider.fetchUser(userId.toString());
// // // // // // //   }

// // // // // // //   if (customerProvider.customers.isEmpty) {
// // // // // // //     ScaffoldMessenger.of(context).showSnackBar(
// // // // // // //       const SnackBar(
// // // // // // //         content: Text('No customers available. Please add customers first.'),
// // // // // // //         backgroundColor: Colors.orange,
// // // // // // //       ),
// // // // // // //     );
// // // // // // //     return;
// // // // // // //   }

  

// // // // // // //   // Extract unique religions from customers
// // // // // // // List<String> religions = customerProvider.customers
// // // // // // //     .where((customer) =>
// // // // // // //         customer['religion'] != null &&
// // // // // // //         customer['religion'].toString().trim().isNotEmpty)
// // // // // // //     .map((customer) => customer['religion'].toString().trim())
// // // // // // //     .toSet()
// // // // // // //     .toList();


// // // // // // //   religions.sort();
// // // // // // //   religions.insert(0, 'All');

// // // // // // //   // Track selected religion and customers
// // // // // // //   String selectedReligion = 'All';
// // // // // // //   Set<String> selectedCustomerIds = {};

// // // // // // //   // Filter customers based on selected religion
// // // // // // //   List<Map<String, dynamic>> filteredCustomers() {
// // // // // // //     if (selectedReligion == 'All') {
// // // // // // //       return customerProvider.customers;
// // // // // // //     } else {
// // // // // // //       return customerProvider.customers
// // // // // // //           .where((customer) =>
// // // // // // //               customer['religion']?.toString() == selectedReligion)
// // // // // // //           .toList();
// // // // // // //     }
// // // // // // //   }

// // // // // // //   // Responsive sizing
// // // // // // //   final screenW = MediaQuery.sizeOf(context).width;
// // // // // // //   final screenH = MediaQuery.sizeOf(context).height;
// // // // // // //   final bool isSmall = screenW < 400;
// // // // // // //   final double dialogWidth = screenW < 600 ? screenW * 0.92 : 520.0;
// // // // // // //   final double dialogMaxH = screenH * 0.82;

// // // // // // //   showDialog(
// // // // // // //     context: context,
// // // // // // //     builder: (context) => StatefulBuilder(
// // // // // // //       builder: (context, setDialogState) {
// // // // // // //         final filtered = filteredCustomers();
// // // // // // //         final bool allSelected = filtered.isNotEmpty &&
// // // // // // //             selectedCustomerIds.length == filtered.length &&
// // // // // // //             filtered
// // // // // // //                 .every((c) => selectedCustomerIds.contains(c['_id'] as String));

// // // // // // //         return Dialog(
// // // // // // //           insetPadding: EdgeInsets.symmetric(
// // // // // // //             horizontal: isSmall ? 10 : 24,
// // // // // // //             vertical: 32,
// // // // // // //           ),
// // // // // // //           shape: const RoundedRectangleBorder(
// // // // // // //             // borderRadius: BorderRadius.circular(20),
// // // // // // //           ),
// // // // // // //           clipBehavior: Clip.antiAliasWithSaveLayer,
// // // // // // //           backgroundColor: Colors.white,
// // // // // // //           child: SizedBox(
// // // // // // //             width: dialogWidth,
// // // // // // //             height: dialogMaxH,
// // // // // // //             child: Column(
// // // // // // //               crossAxisAlignment: CrossAxisAlignment.stretch,
// // // // // // //               children: [
// // // // // // //                 // ──────────── HEADER ────────────
// // // // // // //                 Container(
// // // // // // //                   decoration: const BoxDecoration(
// // // // // // //                     gradient: LinearGradient(
// // // // // // //                       colors: [Color(0xFF6366F1), Color(0xFF818CF8)],
// // // // // // //                       begin: Alignment.centerLeft,
// // // // // // //                       end: Alignment.centerRight,
// // // // // // //                     ),
// // // // // // //                   ),
// // // // // // //                   padding: const EdgeInsets.only(
// // // // // // //                     left: 20,
// // // // // // //                     right: 12,
// // // // // // //                     top: 18,
// // // // // // //                     bottom: 16,
// // // // // // //                   ),
// // // // // // //                   child: Row(
// // // // // // //                     crossAxisAlignment: CrossAxisAlignment.center,
// // // // // // //                     children: [
// // // // // // //                       const Icon(Icons.people_rounded,
// // // // // // //                           color: Colors.white, size: 24),
// // // // // // //                       const SizedBox(width: 10),
// // // // // // //                       const Text(
// // // // // // //                         'Share Customers',
// // // // // // //                         style: TextStyle(
// // // // // // //                           color: Colors.white,
// // // // // // //                           fontSize: 18,
// // // // // // //                           fontWeight: FontWeight.w700,
// // // // // // //                           letterSpacing: 0.2,
// // // // // // //                         ),
// // // // // // //                       ),
// // // // // // //                       const Spacer(),
// // // // // // //                       if (selectedCustomerIds.isNotEmpty)
// // // // // // //                         Container(
// // // // // // //                           padding: const EdgeInsets.symmetric(
// // // // // // //                               horizontal: 10, vertical: 3),
// // // // // // //                           decoration: BoxDecoration(
// // // // // // //                             color: Colors.white.withOpacity(0.25),
// // // // // // //                             borderRadius: BorderRadius.circular(14),
// // // // // // //                           ),
// // // // // // //                           child: Text(
// // // // // // //                             '${selectedCustomerIds.length}',
// // // // // // //                             style: const TextStyle(
// // // // // // //                               color: Colors.white,
// // // // // // //                               fontSize: 13,
// // // // // // //                               fontWeight: FontWeight.w700,
// // // // // // //                             ),
// // // // // // //                           ),
// // // // // // //                         ),
// // // // // // //                       const SizedBox(width: 4),
// // // // // // //                       IconButton(
// // // // // // //                         onPressed: () => Navigator.pop(context),
// // // // // // //                         icon: const Icon(Icons.close_rounded,
// // // // // // //                             color: Colors.white, size: 20),
// // // // // // //                         padding: EdgeInsets.zero,
// // // // // // //                         constraints: const BoxConstraints(),
// // // // // // //                       ),
// // // // // // //                     ],
// // // // // // //                   ),
// // // // // // //                 ),

// // // // // // //                 // ──────────── RELIGION FILTER CHIPS ────────────
// // // // // // //                 Padding(
// // // // // // //                   padding:
// // // // // // //                       const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
// // // // // // //                   child: SizedBox(
// // // // // // //                     height: 36,
// // // // // // //                     child: ListView.builder(
// // // // // // //                       scrollDirection: Axis.horizontal,
// // // // // // //                       physics: const BouncingScrollPhysics(),
// // // // // // //                       itemCount: religions.length,
// // // // // // //                       itemBuilder: (_, index) {
// // // // // // //                         final r = religions[index];
// // // // // // //                         final bool isActive = r == selectedReligion;
// // // // // // //                         return Padding(
// // // // // // //                           padding: EdgeInsets.only(
// // // // // // //                               right: index < religions.length - 1 ? 8 : 0),
// // // // // // //                           child: AnimatedContainer(
// // // // // // //                             duration: const Duration(milliseconds: 220),
// // // // // // //                             curve: Curves.easeInOut,
// // // // // // //                             decoration: BoxDecoration(
// // // // // // //                               color: isActive
// // // // // // //                                   ? const Color(0xFF6366F1)
// // // // // // //                                   : const Color(0xFFF1F1FF),
// // // // // // //                               borderRadius: BorderRadius.circular(18),
// // // // // // //                             ),
// // // // // // //                             child: InkWell(
// // // // // // //                               borderRadius: BorderRadius.circular(18),
// // // // // // //                               onTap: () {
// // // // // // //                                 setDialogState(() {
// // // // // // //                                   selectedReligion = r;
// // // // // // //                                   selectedCustomerIds.clear();
// // // // // // //                                 });
// // // // // // //                               },
// // // // // // //                               child: Padding(
// // // // // // //                                 padding: const EdgeInsets.symmetric(
// // // // // // //                                     horizontal: 14, vertical: 6),
// // // // // // //                                 child: Text(
// // // // // // //                                   r,
// // // // // // //                                   style: TextStyle(
// // // // // // //                                     fontSize: 13,
// // // // // // //                                     fontWeight: FontWeight.w600,
// // // // // // //                                     color: isActive
// // // // // // //                                         ? Colors.white
// // // // // // //                                         : const Color(0xFF6366F1),
// // // // // // //                                   ),
// // // // // // //                                 ),
// // // // // // //                               ),
// // // // // // //                             ),
// // // // // // //                           ),
// // // // // // //                         );
// // // // // // //                       },
// // // // // // //                     ),
// // // // // // //                   ),
// // // // // // //                 ),

// // // // // // //                 // ──────────── INFO ROW ────────────
// // // // // // //                 Padding(
// // // // // // //                   padding: const EdgeInsets.symmetric(horizontal: 16),
// // // // // // //                   child: Row(
// // // // // // //                     children: [
// // // // // // //                       Text(
// // // // // // //                         '${filtered.length} customer${filtered.length != 1 ? 's' : ''}',
// // // // // // //                         style: const TextStyle(
// // // // // // //                           color: Color(0xFF6366F1),
// // // // // // //                           fontWeight: FontWeight.w600,
// // // // // // //                           fontSize: 13,
// // // // // // //                         ),
// // // // // // //                       ),
// // // // // // //                       const Spacer(),
// // // // // // //                       if (filtered.isNotEmpty)
// // // // // // //                         InkWell(
// // // // // // //                           onTap: () {
// // // // // // //                             setDialogState(() {
// // // // // // //                               if (allSelected) {
// // // // // // //                                 selectedCustomerIds.clear();
// // // // // // //                               } else {
// // // // // // //                                 selectedCustomerIds = filtered
// // // // // // //                                     .map((c) => c['_id'] as String)
// // // // // // //                                     .toSet();
// // // // // // //                               }
// // // // // // //                             });
// // // // // // //                           },
// // // // // // //                           borderRadius: BorderRadius.circular(6),
// // // // // // //                           child: Padding(
// // // // // // //                             padding: const EdgeInsets.symmetric(
// // // // // // //                                 horizontal: 6, vertical: 2),
// // // // // // //                             child: Row(
// // // // // // //                               children: [
// // // // // // //                                 Icon(
// // // // // // //                                   allSelected
// // // // // // //                                       ? Icons.deselect
// // // // // // //                                       : Icons.select_all,
// // // // // // //                                   size: 18,
// // // // // // //                                   color: const Color(0xFF6366F1),
// // // // // // //                                 ),
// // // // // // //                                 const SizedBox(width: 4),
// // // // // // //                                 Text(
// // // // // // //                                   allSelected ? 'Deselect All' : 'Select All',
// // // // // // //                                   style: const TextStyle(
// // // // // // //                                     fontSize: 12,
// // // // // // //                                     color: Color(0xFF6366F1),
// // // // // // //                                     fontWeight: FontWeight.w600,
// // // // // // //                                   ),
// // // // // // //                                 ),
// // // // // // //                               ],
// // // // // // //                             ),
// // // // // // //                           ),
// // // // // // //                         ),
// // // // // // //                     ],
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //                 const SizedBox(height: 8),

// // // // // // //                 // ──────────── CUSTOMER LIST ────────────
// // // // // // //                 Expanded(
// // // // // // //                   child: filtered.isEmpty
// // // // // // //                       ? Center(
// // // // // // //                           child: Column(
// // // // // // //                             mainAxisAlignment: MainAxisAlignment.center,
// // // // // // //                             children: [
// // // // // // //                               const Icon(Icons.group_off_rounded,
// // // // // // //                                   size: 52, color: Color(0xFFD1D5DB)),
// // // // // // //                               const SizedBox(height: 12),
// // // // // // //                               const Text(
// // // // // // //                                 'No customers found',
// // // // // // //                                 style: TextStyle(
// // // // // // //                                   color: Color(0xFF6B7280),
// // // // // // //                                   fontWeight: FontWeight.w600,
// // // // // // //                                   fontSize: 15,
// // // // // // //                                 ),
// // // // // // //                               ),
// // // // // // //                               if (selectedReligion != 'All')
// // // // // // //                                 Padding(
// // // // // // //                                   padding: const EdgeInsets.only(top: 4),
// // // // // // //                                   child: Text(
// // // // // // //                                     'in "$selectedReligion"',
// // // // // // //                                     style: const TextStyle(
// // // // // // //                                       color: Color(0xFF9CA3AF),
// // // // // // //                                       fontSize: 13,
// // // // // // //                                     ),
// // // // // // //                                   ),
// // // // // // //                                 ),
// // // // // // //                             ],
// // // // // // //                           ),
// // // // // // //                         )
// // // // // // //                       : ListView.builder(
// // // // // // //                           padding:
// // // // // // //                               const EdgeInsets.symmetric(horizontal: 8),
// // // // // // //                           itemCount: filtered.length,
// // // // // // //                           itemBuilder: (context, index) {
// // // // // // //                             final customer = filtered[index];
// // // // // // //                             final customerId = customer['_id'] as String;
// // // // // // //                             final bool isSelected =
// // // // // // //                                 selectedCustomerIds.contains(customerId);
// // // // // // //                             final String name =
// // // // // // //                                 customer['name']?.toString() ?? 'Unknown';
// // // // // // //                             final String? mobile =
// // // // // // //                                 customer['mobile']?.toString();
// // // // // // //                             final String? email =
// // // // // // //                                 customer['email']?.toString();
// // // // // // //                             final String? religion =
// // // // // // //                                 customer['religion']?.toString();
// // // // // // //                             final String initial =
// // // // // // //                                 name.isNotEmpty ? name[0].toUpperCase() : 'U';

// // // // // // //                             return AnimatedContainer(
// // // // // // //                               duration: const Duration(milliseconds: 200),
// // // // // // //                               curve: Curves.easeInOut,
// // // // // // //                               margin: const EdgeInsets.only(bottom: 4),
// // // // // // //                               decoration: BoxDecoration(
// // // // // // //                                 color: isSelected
// // // // // // //                                     ? const Color(0xFFEEEFFF)
// // // // // // //                                     : Colors.white,
// // // // // // //                                 borderRadius: BorderRadius.circular(12),
// // // // // // //                                 border: Border.all(
// // // // // // //                                   color: isSelected
// // // // // // //                                       ? const Color(0xFF6366F1)
// // // // // // //                                       : const Color(0xFFE8E8F0),
// // // // // // //                                   width: isSelected ? 1.5 : 1,
// // // // // // //                                 ),
// // // // // // //                               ),
// // // // // // //                               child: InkWell(
// // // // // // //                                 onTap: () {
// // // // // // //                                   setDialogState(() {
// // // // // // //                                     if (isSelected) {
// // // // // // //                                       selectedCustomerIds.remove(customerId);
// // // // // // //                                     } else {
// // // // // // //                                       selectedCustomerIds.add(customerId);
// // // // // // //                                     }
// // // // // // //                                   });
// // // // // // //                                 },
// // // // // // //                                 borderRadius: BorderRadius.circular(12),
// // // // // // //                                 child: Padding(
// // // // // // //                                   padding: const EdgeInsets.all(10),
// // // // // // //                                   child: Row(
// // // // // // //                                     crossAxisAlignment:
// // // // // // //                                         CrossAxisAlignment.center,
// // // // // // //                                     children: [
// // // // // // //                                       // Checkbox
// // // // // // //                                       SizedBox(
// // // // // // //                                         width: 22,
// // // // // // //                                         height: 22,
// // // // // // //                                         child: Checkbox(
// // // // // // //                                           value: isSelected,
// // // // // // //                                           onChanged: (_) {
// // // // // // //                                             setDialogState(() {
// // // // // // //                                               if (isSelected) {
// // // // // // //                                                 selectedCustomerIds
// // // // // // //                                                     .remove(customerId);
// // // // // // //                                               } else {
// // // // // // //                                                 selectedCustomerIds
// // // // // // //                                                     .add(customerId);
// // // // // // //                                               }
// // // // // // //                                             });
// // // // // // //                                           },
// // // // // // //                                           activeColor: const Color(0xFF6366F1),
// // // // // // //                                           side: const BorderSide(
// // // // // // //                                               color: Color(0xFFB0B0C0)),
// // // // // // //                                           // materialColor: Colors.transparent,
// // // // // // //                                         ),
// // // // // // //                                       ),
// // // // // // //                                       const SizedBox(width: 8),

// // // // // // //                                       // Avatar
// // // // // // //                                       CircleAvatar(
// // // // // // //                                         radius: 22,
// // // // // // //                                         backgroundColor:
// // // // // // //                                             const Color(0xFF6366F1),
// // // // // // //                                         child: Text(
// // // // // // //                                           initial,
// // // // // // //                                           style: const TextStyle(
// // // // // // //                                             color: Colors.white,
// // // // // // //                                             fontWeight: FontWeight.w700,
// // // // // // //                                             fontSize: 15,
// // // // // // //                                           ),
// // // // // // //                                         ),
// // // // // // //                                       ),
// // // // // // //                                       const SizedBox(width: 10),

// // // // // // //                                       // Name + contact info
// // // // // // //                                       Expanded(
// // // // // // //                                         child: Column(
// // // // // // //                                           crossAxisAlignment:
// // // // // // //                                               CrossAxisAlignment.start,
// // // // // // //                                           mainAxisSize: MainAxisSize.min,
// // // // // // //                                           children: [
// // // // // // //                                             Text(
// // // // // // //                                               name,
// // // // // // //                                               style: const TextStyle(
// // // // // // //                                                 fontSize: 14,
// // // // // // //                                                 fontWeight: FontWeight.w600,
// // // // // // //                                                 color: Color(0xFF1E1B4B),
// // // // // // //                                               ),
// // // // // // //                                               maxLines: 1,
// // // // // // //                                               overflow:
// // // // // // //                                                   TextOverflow.ellipsis,
// // // // // // //                                             ),
// // // // // // //                                             if (mobile != null ||
// // // // // // //                                                 email != null)
// // // // // // //                                               const SizedBox(height: 2),
// // // // // // //                                             if (mobile != null)
// // // // // // //                                               Text(
// // // // // // //                                                 mobile,
// // // // // // //                                                 style: const TextStyle(
// // // // // // //                                                   fontSize: 12,
// // // // // // //                                                   color: Color(0xFF6B7280),
// // // // // // //                                                 ),
// // // // // // //                                               ),
// // // // // // //                                             if (email != null)
// // // // // // //                                               Text(
// // // // // // //                                                 email,
// // // // // // //                                                 style: const TextStyle(
// // // // // // //                                                   fontSize: 11,
// // // // // // //                                                   color: Color(0xFF9CA3AF),
// // // // // // //                                                 ),
// // // // // // //                                                 maxLines: 1,
// // // // // // //                                                 overflow:
// // // // // // //                                                     TextOverflow.ellipsis,
// // // // // // //                                               ),
// // // // // // //                                           ],
// // // // // // //                                         ),
// // // // // // //                                       ),

// // // // // // //                                       // Religion tag
// // // // // // //                                       if (religion != null)
// // // // // // //                                         Container(
// // // // // // //                                           padding:
// // // // // // //                                               const EdgeInsets.symmetric(
// // // // // // //                                                   horizontal: 8, vertical: 3),
// // // // // // //                                           decoration: BoxDecoration(
// // // // // // //                                             color: const Color(0xFFF1F1FF),
// // // // // // //                                             borderRadius:
// // // // // // //                                                 BorderRadius.circular(20),
// // // // // // //                                           ),
// // // // // // //                                           child: Text(
// // // // // // //                                             religion,
// // // // // // //                                             style: const TextStyle(
// // // // // // //                                               fontSize: 10,
// // // // // // //                                               color: Color(0xFF6366F1),
// // // // // // //                                               fontWeight: FontWeight.w600,
// // // // // // //                                             ),
// // // // // // //                                           ),
// // // // // // //                                         ),
// // // // // // //                                     ],
// // // // // // //                                   ),
// // // // // // //                                 ),
// // // // // // //                               ),
// // // // // // //                             );
// // // // // // //                           },
// // // // // // //                         ),
// // // // // // //                 ),

// // // // // // //                 // ──────────── FOOTER ────────────
// // // // // // //                 Container(
// // // // // // //                   padding: EdgeInsets.symmetric(
// // // // // // //                     horizontal: isSmall ? 12 : 16,
// // // // // // //                     vertical: 14,
// // // // // // //                   ),
// // // // // // //                   decoration: const BoxDecoration(
// // // // // // //                     color: Color(0xFFF9FAFB),
// // // // // // //                     border: Border(
// // // // // // //                       top: BorderSide(color: Color(0xFFE5E7EB)),
// // // // // // //                     ),
// // // // // // //                   ),
// // // // // // //                   child: Row(
// // // // // // //                     children: [
// // // // // // //                       TextButton(
// // // // // // //                         style: TextButton.styleFrom(
// // // // // // //                           foregroundColor: const Color(0xFF6B7280),
// // // // // // //                           padding: EdgeInsets.symmetric(
// // // // // // //                               horizontal: isSmall ? 12 : 16, vertical: 10),
// // // // // // //                         ),
// // // // // // //                         onPressed: () => Navigator.pop(context),
// // // // // // //                         child: const Text(
// // // // // // //                           'Cancel',
// // // // // // //                           style: TextStyle(fontWeight: FontWeight.w600),
// // // // // // //                         ),
// // // // // // //                       ),
// // // // // // //                       const Spacer(),
// // // // // // //                       AnimatedOpacity(
// // // // // // //                         opacity: selectedCustomerIds.isNotEmpty ? 1.0 : 0.45,
// // // // // // //                         duration: const Duration(milliseconds: 200),
// // // // // // //                         child: ElevatedButton.icon(
// // // // // // //                           style: ElevatedButton.styleFrom(
// // // // // // //                             backgroundColor: const Color(0xFF6366F1),
// // // // // // //                             foregroundColor: Colors.white,
// // // // // // //                             disabledBackgroundColor: const Color(0xFFACAFE8),
// // // // // // //                             padding: EdgeInsets.symmetric(
// // // // // // //                                 horizontal: isSmall ? 16 : 22, vertical: 10),
// // // // // // //                             // borderRadius: BorderRadius.circular(10),
// // // // // // //                             elevation: 0,
// // // // // // //                           ),
// // // // // // //                           onPressed: selectedCustomerIds.isEmpty
// // // // // // //                               ? null
// // // // // // //                               : () async {
// // // // // // //                                   Navigator.pop(context);
// // // // // // //                                   await _sharePosterWithSelectedCustomers(
// // // // // // //                                     selectedCustomerIds,
// // // // // // //                                     filteredCustomers(),
// // // // // // //                                   );
// // // // // // //                                 },
// // // // // // //                           icon: const Icon(Icons.share_rounded, size: 18),
// // // // // // //                           label: Text(
// // // // // // //                             'Share (${selectedCustomerIds.length})',
// // // // // // //                             style: const TextStyle(
// // // // // // //                                 fontWeight: FontWeight.w700, fontSize: 14),
// // // // // // //                           ),
// // // // // // //                         ),
// // // // // // //                       ),
// // // // // // //                     ],
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //               ],
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //         );
// // // // // // //       },
// // // // // // //     ),
// // // // // // //   );
// // // // // // // }

  

// // // // // // //   // Future<void> _sharePosterWithSelectedCustomers(
// // // // // // //   //   Set<String> selectedCustomerIds,
// // // // // // //   //   List<Map<String, dynamic>> allCustomers,
// // // // // // //   // ) async {
// // // // // // //   //   try {
// // // // // // //   //     showDialog(
// // // // // // //   //       context: context,
// // // // // // //   //       barrierDismissible: false,
// // // // // // //   //       builder: (context) => const AlertDialog(
// // // // // // //   //         content: Row(
// // // // // // //   //           children: [
// // // // // // //   //             CircularProgressIndicator(),
// // // // // // //   //             SizedBox(width: 16),
// // // // // // //   //             Text('Preparing poster...'),
// // // // // // //   //           ],
// // // // // // //   //         ),
// // // // // // //   //       ),
// // // // // // //   //     );

// // // // // // //   //     // Generate poster image
// // // // // // //   //     RenderRepaintBoundary boundary =
// // // // // // //   //         _canvasKey.currentContext!.findRenderObject()
// // // // // // //   //             as RenderRepaintBoundary;
// // // // // // //   //     ui.Image image = await boundary.toImage(pixelRatio: 3.0);
// // // // // // //   //     ByteData? byteData = await image.toByteData(
// // // // // // //   //       format: ui.ImageByteFormat.png,
// // // // // // //   //     );
// // // // // // //   //     Uint8List pngBytes = byteData!.buffer.asUint8List();

// // // // // // //   //     final directory = await getTemporaryDirectory();
// // // // // // //   //     final file = File(
// // // // // // //   //       '${directory.path}/poster_share_${DateTime.now().millisecondsSinceEpoch}.png',
// // // // // // //   //     );
// // // // // // //   //     await file.writeAsBytes(pngBytes);

// // // // // // //   //     Navigator.of(context).pop(); // Close loading dialog

// // // // // // //   //     // Get selected customers
// // // // // // //   //     final selectedCustomers = allCustomers
// // // // // // //   //         .where((c) => selectedCustomerIds.contains(c['_id']))
// // // // // // //   //         .toList();

// // // // // // //   //     int successCount = 0;
// // // // // // //   //     int failCount = 0;

// // // // // // //   //     // Share with each selected customer
// // // // // // //   //     for (var customer in selectedCustomers) {
// // // // // // //   //       final mobile = customer['mobile']?.toString() ?? '';
// // // // // // //   //       final name = customer['name']?.toString() ?? 'Customer';

// // // // // // //   //       if (mobile.isEmpty) {
// // // // // // //   //         failCount++;
// // // // // // //   //         continue;
// // // // // // //   //       }

// // // // // // //   //       try {
// // // // // // //   //         // Clean phone number
// // // // // // //   //         String cleanNumber = mobile.replaceAll(RegExp(r'[^\d+]'), '');
// // // // // // //   //         if (!cleanNumber.startsWith('+')) {
// // // // // // //   //           if (cleanNumber.length == 10) {
// // // // // // //   //             cleanNumber = '+91$cleanNumber';
// // // // // // //   //           }
// // // // // // //   //         }

// // // // // // //   //         // Create WhatsApp URL with image
// // // // // // //   //         final whatsappUrl = Uri.parse(
// // // // // // //   //           'https://wa.me/$cleanNumber?text=${Uri.encodeComponent("Hi $name, check out this poster!")}',
// // // // // // //   //         );

// // // // // // //   //         if (await canLaunchUrl(whatsappUrl)) {
// // // // // // //   //           await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
// // // // // // //   //           // Small delay between shares
// // // // // // //   //           await Future.delayed(const Duration(milliseconds: 500));
// // // // // // //   //           successCount++;
// // // // // // //   //         } else {
// // // // // // //   //           failCount++;
// // // // // // //   //         }
// // // // // // //   //       } catch (e) {
// // // // // // //   //         debugPrint('Error sharing with $name: $e');
// // // // // // //   //         failCount++;
// // // // // // //   //       }
// // // // // // //   //     }

// // // // // // //   //     // Show results
// // // // // // //   //     if (mounted) {
// // // // // // //   //       ScaffoldMessenger.of(context).showSnackBar(
// // // // // // //   //         SnackBar(
// // // // // // //   //           content: Text(
// // // // // // //   //             'Shared with $successCount customer${successCount != 1 ? 's' : ''}' +
// // // // // // //   //                 (failCount > 0 ? ' ($failCount failed)' : ''),
// // // // // // //   //           ),
// // // // // // //   //           backgroundColor: successCount > 0 ? Colors.green : Colors.orange,
// // // // // // //   //           duration: const Duration(seconds: 4),
// // // // // // //   //           action: SnackBarAction(
// // // // // // //   //             label: 'OK',
// // // // // // //   //             textColor: Colors.white,
// // // // // // //   //             onPressed: () {},
// // // // // // //   //           ),
// // // // // // //   //         ),
// // // // // // //   //       );
// // // // // // //   //     }
// // // // // // //   //   } catch (e) {
// // // // // // //   //     if (Navigator.of(context).canPop()) {
// // // // // // //   //       Navigator.of(context).pop();
// // // // // // //   //     }

// // // // // // //   //     if (mounted) {
// // // // // // //   //       ScaffoldMessenger.of(context).showSnackBar(
// // // // // // //   //         SnackBar(
// // // // // // //   //           content: Text('Error preparing poster: $e'),
// // // // // // //   //           backgroundColor: Colors.red,
// // // // // // //   //           duration: const Duration(seconds: 4),
// // // // // // //   //         ),
// // // // // // //   //       );
// // // // // // //   //     }
// // // // // // //   //   }
// // // // // // //   // }




// // // // // // //   Future<void> _sharePosterWithSelectedCustomers(
// // // // // // //   Set<String> selectedCustomerIds,
// // // // // // //   List<Map<String, dynamic>> allCustomers,
// // // // // // // ) async {
// // // // // // //   try {
// // // // // // //     showDialog(
// // // // // // //       context: context,
// // // // // // //       barrierDismissible: false,
// // // // // // //       builder: (context) => const AlertDialog(
// // // // // // //         content: Row(
// // // // // // //           children: [
// // // // // // //             CircularProgressIndicator(),
// // // // // // //             SizedBox(width: 16),
// // // // // // //             Text('Preparing poster...'),
// // // // // // //           ],
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //     );

// // // // // // //     // Generate poster image
// // // // // // //     RenderRepaintBoundary boundary =
// // // // // // //         _canvasKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
// // // // // // //     ui.Image image = await boundary.toImage(pixelRatio: 3.0);
// // // // // // //     ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
// // // // // // //     Uint8List pngBytes = byteData!.buffer.asUint8List();

// // // // // // //     final directory = await getTemporaryDirectory();
// // // // // // //     final file = File(
// // // // // // //       '${directory.path}/poster_share_${DateTime.now().millisecondsSinceEpoch}.png',
// // // // // // //     );
// // // // // // //     await file.writeAsBytes(pngBytes);

// // // // // // //     Navigator.of(context).pop(); // Close loading dialog

// // // // // // //     // Get selected customers
// // // // // // //     final selectedCustomers = allCustomers
// // // // // // //         .where((c) => selectedCustomerIds.contains(c['_id']))
// // // // // // //         .toList();

// // // // // // //     if (selectedCustomers.isEmpty) {
// // // // // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // // // // //         const SnackBar(
// // // // // // //           content: Text('No customers selected'),
// // // // // // //           backgroundColor: Colors.orange,
// // // // // // //         ),
// // // // // // //       );
// // // // // // //       return;
// // // // // // //     }

// // // // // // //     // Show confirmation dialog with customer list
// // // // // // //     final shouldProceed = await showDialog<bool>(
// // // // // // //       context: context,
// // // // // // //       builder: (context) => AlertDialog(
// // // // // // //         title: const Text('Share Poster'),
// // // // // // //         content: Column(
// // // // // // //           mainAxisSize: MainAxisSize.min,
// // // // // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //           children: [
// // // // // // //             Text(
// // // // // // //               'Share poster with ${selectedCustomers.length} customer${selectedCustomers.length != 1 ? 's' : ''}?',
// // // // // // //               style: const TextStyle(fontWeight: FontWeight.bold),
// // // // // // //             ),
// // // // // // //             const SizedBox(height: 16),
// // // // // // //             const Text(
// // // // // // //               'The poster will be shared via WhatsApp. You\'ll need to send it to each customer individually.',
// // // // // // //               style: TextStyle(fontSize: 12, color: Colors.grey),
// // // // // // //             ),
// // // // // // //             const SizedBox(height: 16),
// // // // // // //             Container(
// // // // // // //               constraints: const BoxConstraints(maxHeight: 200),
// // // // // // //               child: SingleChildScrollView(
// // // // // // //                 child: Column(
// // // // // // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //                   children: selectedCustomers.map((customer) {
// // // // // // //                     return Padding(
// // // // // // //                       padding: const EdgeInsets.symmetric(vertical: 4),
// // // // // // //                       child: Row(
// // // // // // //                         children: [
// // // // // // //                           const Icon(Icons.person, size: 16, color: Colors.deepPurple),
// // // // // // //                           const SizedBox(width: 8),
// // // // // // //                           Expanded(
// // // // // // //                             child: Text(
// // // // // // //                               '${customer['name']} - ${customer['mobile']}',
// // // // // // //                               style: const TextStyle(fontSize: 13),
// // // // // // //                             ),
// // // // // // //                           ),
// // // // // // //                         ],
// // // // // // //                       ),
// // // // // // //                     );
// // // // // // //                   }).toList(),
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //           ],
// // // // // // //         ),
// // // // // // //         actions: [
// // // // // // //           TextButton(
// // // // // // //             onPressed: () => Navigator.pop(context, false),
// // // // // // //             child: const Text('Cancel'),
// // // // // // //           ),
// // // // // // //           ElevatedButton(
// // // // // // //             onPressed: () => Navigator.pop(context, true),
// // // // // // //             style: ElevatedButton.styleFrom(
// // // // // // //               backgroundColor: Colors.deepPurple,
// // // // // // //               foregroundColor: Colors.white,
// // // // // // //             ),
// // // // // // //             child: const Text('Continue'),
// // // // // // //           ),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );

// // // // // // //     if (shouldProceed != true) return;

// // // // // // //     // Navigate to ChatModule screen with the poster and customer data
// // // // // // //     Navigator.push(
// // // // // // //       context,
// // // // // // //       MaterialPageRoute(
// // // // // // //         builder: (context) => ChatModule(
// // // // // // //           posterImagePath: file.path,
// // // // // // //           selectedCustomers: selectedCustomers, 
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //     );

// // // // // // //   } catch (e) {
// // // // // // //     if (Navigator.of(context).canPop()) {
// // // // // // //       Navigator.of(context).pop();
// // // // // // //     }

// // // // // // //     if (mounted) {
// // // // // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // // // // //         SnackBar(
// // // // // // //           content: Text('Error preparing poster: $e'),
// // // // // // //           backgroundColor: Colors.red,
// // // // // // //           duration: const Duration(seconds: 4),
// // // // // // //         ),
// // // // // // //       );
// // // // // // //     }
// // // // // // //   }
// // // // // // // }

// // // // // // //   // Updated method to share poster with selected customers via WhatsApp
// // // // // // // // Future<void> _sharePosterWithSelectedCustomers(
// // // // // // // //   Set<String> selectedCustomerIds,
// // // // // // // //   List<Map<String, dynamic>> allCustomers,
// // // // // // // // ) async {
// // // // // // // //   try {
// // // // // // // //     showDialog(
// // // // // // // //       context: context,
// // // // // // // //       barrierDismissible: false,
// // // // // // // //       builder: (context) => const AlertDialog(
// // // // // // // //         content: Row(
// // // // // // // //           children: [
// // // // // // // //             CircularProgressIndicator(),
// // // // // // // //             SizedBox(width: 16),
// // // // // // // //             Text('Preparing poster...'),
// // // // // // // //           ],
// // // // // // // //         ),
// // // // // // // //       ),
// // // // // // // //     );

// // // // // // // //     // Generate poster image
// // // // // // // //     RenderRepaintBoundary boundary =
// // // // // // // //         _canvasKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
// // // // // // // //     ui.Image image = await boundary.toImage(pixelRatio: 3.0);
// // // // // // // //     ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
// // // // // // // //     Uint8List pngBytes = byteData!.buffer.asUint8List();

// // // // // // // //     final directory = await getTemporaryDirectory();
// // // // // // // //     final file = File(
// // // // // // // //       '${directory.path}/poster_share_${DateTime.now().millisecondsSinceEpoch}.png',
// // // // // // // //     );
// // // // // // // //     await file.writeAsBytes(pngBytes);

// // // // // // // //     Navigator.of(context).pop(); // Close loading dialog

// // // // // // // //     // Get selected customers
// // // // // // // //     final selectedCustomers = allCustomers
// // // // // // // //         .where((c) => selectedCustomerIds.contains(c['_id']))
// // // // // // // //         .toList();

// // // // // // // //     if (selectedCustomers.isEmpty) {
// // // // // // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // // // // // //         const SnackBar(
// // // // // // // //           content: Text('No customers selected'),
// // // // // // // //           backgroundColor: Colors.orange,
// // // // // // // //         ),
// // // // // // // //       );
// // // // // // // //       return;
// // // // // // // //     }

// // // // // // // //     // Show confirmation dialog with customer list
// // // // // // // //     final shouldProceed = await showDialog<bool>(
// // // // // // // //       context: context,
// // // // // // // //       builder: (context) => AlertDialog(
// // // // // // // //         title: const Text('Share Poster'),
// // // // // // // //         content: Column(
// // // // // // // //           mainAxisSize: MainAxisSize.min,
// // // // // // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // //           children: [
// // // // // // // //             Text(
// // // // // // // //               'Share poster with ${selectedCustomers.length} customer${selectedCustomers.length != 1 ? 's' : ''}?',
// // // // // // // //               style: const TextStyle(fontWeight: FontWeight.bold),
// // // // // // // //             ),
// // // // // // // //             const SizedBox(height: 16),
// // // // // // // //             const Text(
// // // // // // // //               'The poster will be shared via WhatsApp. You\'ll need to send it to each customer individually.',
// // // // // // // //               style: TextStyle(fontSize: 12, color: Colors.grey),
// // // // // // // //             ),
// // // // // // // //             const SizedBox(height: 16),
// // // // // // // //             Container(
// // // // // // // //               constraints: const BoxConstraints(maxHeight: 200),
// // // // // // // //               child: SingleChildScrollView(
// // // // // // // //                 child: Column(
// // // // // // // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // //                   children: selectedCustomers.map((customer) {
// // // // // // // //                     return Padding(
// // // // // // // //                       padding: const EdgeInsets.symmetric(vertical: 4),
// // // // // // // //                       child: Row(
// // // // // // // //                         children: [
// // // // // // // //                           const Icon(Icons.person, size: 16, color: Colors.deepPurple),
// // // // // // // //                           const SizedBox(width: 8),
// // // // // // // //                           Expanded(
// // // // // // // //                             child: Text(
// // // // // // // //                               '${customer['name']} - ${customer['mobile']}',
// // // // // // // //                               style: const TextStyle(fontSize: 13),
// // // // // // // //                             ),
// // // // // // // //                           ),
// // // // // // // //                         ],
// // // // // // // //                       ),
// // // // // // // //                     );
// // // // // // // //                   }).toList(),
// // // // // // // //                 ),
// // // // // // // //               ),
// // // // // // // //             ),
// // // // // // // //           ],
// // // // // // // //         ),
// // // // // // // //         actions: [
// // // // // // // //           TextButton(
// // // // // // // //             onPressed: () => Navigator.pop(context, false),
// // // // // // // //             child: const Text('Cancel'),
// // // // // // // //           ),
// // // // // // // //           ElevatedButton(
// // // // // // // //             onPressed: () => Navigator.pop(context, true),
// // // // // // // //             style: ElevatedButton.styleFrom(
// // // // // // // //               backgroundColor: Colors.deepPurple,
// // // // // // // //               foregroundColor: Colors.white,
// // // // // // // //             ),
// // // // // // // //             child: const Text('Continue'),
// // // // // // // //           ),
// // // // // // // //         ],
// // // // // // // //       ),
// // // // // // // //     );

// // // // // // // //     if (shouldProceed != true) return;

// // // // // // // //     // Share with each customer one by one
// // // // // // // //     int currentIndex = 0;

// // // // // // // //     for (var customer in selectedCustomers) {
// // // // // // // //       currentIndex++;
// // // // // // // //       final mobile = customer['mobile']?.toString() ?? '';
// // // // // // // //       final name = customer['name']?.toString() ?? 'Customer';

// // // // // // // //       if (mobile.isEmpty) {
// // // // // // // //         ScaffoldMessenger.of(context).showSnackBar(
// // // // // // // //           SnackBar(
// // // // // // // //             content: Text('No mobile number for $name'),
// // // // // // // //             backgroundColor: Colors.orange,
// // // // // // // //             duration: const Duration(seconds: 2),
// // // // // // // //           ),
// // // // // // // //         );
// // // // // // // //         continue;
// // // // // // // //       }

// // // // // // // //       try {
// // // // // // // //         // Clean phone number
// // // // // // // //         String cleanNumber = mobile.replaceAll(RegExp(r'[^\d+]'), '');
// // // // // // // //         if (!cleanNumber.startsWith('+')) {
// // // // // // // //           if (cleanNumber.length == 10) {
// // // // // // // //             cleanNumber = '+91$cleanNumber';
// // // // // // // //           }
// // // // // // // //         }

// // // // // // // //         // Show progress
// // // // // // // //         ScaffoldMessenger.of(context).showSnackBar(
// // // // // // // //           SnackBar(
// // // // // // // //             content: Text('Sharing with $name ($currentIndex/${selectedCustomers.length})'),
// // // // // // // //             backgroundColor: Colors.blue,
// // // // // // // //             duration: const Duration(seconds: 2),
// // // // // // // //           ),
// // // // // // // //         );

// // // // // // // //         // Share via WhatsApp with the specific phone number
// // // // // // // //         final result = await Share.shareXFiles(
// // // // // // // //           [XFile(file.path)],
// // // // // // // //           text: 'Hi $name, check out this poster!',
// // // // // // // //         );

// // // // // // // //         // Add delay between shares to allow user to send each one
// // // // // // // //         if (currentIndex < selectedCustomers.length) {
// // // // // // // //           await Future.delayed(const Duration(seconds: 2));
// // // // // // // //         }

// // // // // // // //       } catch (e) {
// // // // // // // //         debugPrint('Error sharing with $name: $e');
// // // // // // // //         ScaffoldMessenger.of(context).showSnackBar(
// // // // // // // //           SnackBar(
// // // // // // // //             content: Text('Error sharing with $name: $e'),
// // // // // // // //             backgroundColor: Colors.red,
// // // // // // // //             duration: const Duration(seconds: 3),
// // // // // // // //           ),
// // // // // // // //         );
// // // // // // // //       }
// // // // // // // //     }

// // // // // // // //     // Show completion message
// // // // // // // //     if (mounted) {
// // // // // // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // // // // // //         SnackBar(
// // // // // // // //           content: Text('Sharing process completed for ${selectedCustomers.length} customers'),
// // // // // // // //           backgroundColor: Colors.green,
// // // // // // // //           duration: const Duration(seconds: 3),
// // // // // // // //           action: SnackBarAction(
// // // // // // // //             label: 'OK',
// // // // // // // //             textColor: Colors.white,
// // // // // // // //             onPressed: () {},
// // // // // // // //           ),
// // // // // // // //         ),
// // // // // // // //       );
// // // // // // // //     }
// // // // // // // //   } catch (e) {
// // // // // // // //     if (Navigator.of(context).canPop()) {
// // // // // // // //       Navigator.of(context).pop();
// // // // // // // //     }

// // // // // // // //     if (mounted) {
// // // // // // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // // // // // //         SnackBar(
// // // // // // // //           content: Text('Error preparing poster: $e'),
// // // // // // // //           backgroundColor: Colors.red,
// // // // // // // //           duration: const Duration(seconds: 4),
// // // // // // // //         ),
// // // // // // // //       );
// // // // // // // //     }
// // // // // // // //   }
// // // // // // // // }

// // // // // // //   void _selectTextElement(TextElement element) {
// // // // // // //     setState(() {
// // // // // // //       for (var el in _template!.textElements) {
// // // // // // //         el.isSelected = false;
// // // // // // //       }
// // // // // // //       for (var el in _template!.imageElements) {
// // // // // // //         el.isSelected = false;
// // // // // // //       }
// // // // // // //       if (_profileImageElement != null)
// // // // // // //         _profileImageElement!.isSelected = false;
// // // // // // //       if (_logoImageElement != null) _logoImageElement!.isSelected = false;

// // // // // // //       element.isSelected = true;
// // // // // // //       _selectedTextElement = element;
// // // // // // //       _selectedImageElement = null;
// // // // // // //       _showToolbar = true;
// // // // // // //     });
// // // // // // //   }

// // // // // // //   void _selectImageElement(ImageElement element) {
// // // // // // //     setState(() {
// // // // // // //       for (var el in _template!.textElements) {
// // // // // // //         el.isSelected = false;
// // // // // // //       }
// // // // // // //       for (var el in _template!.imageElements) {
// // // // // // //         el.isSelected = false;
// // // // // // //       }
// // // // // // //       if (_profileImageElement != null)
// // // // // // //         _profileImageElement!.isSelected = false;
// // // // // // //       if (_logoImageElement != null) _logoImageElement!.isSelected = false;

// // // // // // //       element.isSelected = true;
// // // // // // //       _selectedImageElement = element;
// // // // // // //       _selectedTextElement = null;
// // // // // // //       _showToolbar = true;
// // // // // // //     });
// // // // // // //   }

// // // // // // //   // void _selectProfileImageElement(ProfileElement element) {
// // // // // // //   //   setState(() {
// // // // // // //   //     for (var el in _template!.textElements) {
// // // // // // //   //       el.isSelected = false;
// // // // // // //   //     }
// // // // // // //   //     for (var el in _template!.imageElements) {
// // // // // // //   //       el.isSelected = false;
// // // // // // //   //     }
// // // // // // //   //     if (_profileImageElement != null)
// // // // // // //   //       _profileImageElement!.isSelected = false;
// // // // // // //   //     if (_logoImageElement != null) _logoImageElement!.isSelected = false;

// // // // // // //   //     element.isSelected = true;
// // // // // // //   //     _selectedProfileImageElement = element;
// // // // // // //   //     _selectedTextElement = null;
// // // // // // //   //     _showToolbar = true;
// // // // // // //   //   });
// // // // // // //   // }

// // // // // // //   void _selectProfileImageElement(ProfileElement element) {
// // // // // // //     setState(() {
// // // // // // //       // Deselect all other elements
// // // // // // //       for (var el in _template!.textElements) {
// // // // // // //         el.isSelected = false;
// // // // // // //       }
// // // // // // //       for (var el in _template!.imageElements) {
// // // // // // //         el.isSelected = false;
// // // // // // //       }
// // // // // // //       if (_logoImageElement != null) _logoImageElement!.isSelected = false;

// // // // // // //       // Select the profile image
// // // // // // //       element.isSelected = true;
// // // // // // //       _selectedProfileImageElement = element;
// // // // // // //       _selectedTextElement = null;
// // // // // // //       _selectedImageElement = null;
// // // // // // //       _showToolbar = true;
// // // // // // //     });
// // // // // // //   }

// // // // // // //   void _updateImageElementPosition(ImageElement element, Offset delta) {
// // // // // // //     setState(() {
// // // // // // //       final scaledDelta = delta / _scaleFactor;
// // // // // // //       element.x += scaledDelta.dx;
// // // // // // //       element.y += scaledDelta.dy;
// // // // // // //       element.x = element.x.clamp(0, _template!.width - element.width);
// // // // // // //       element.y = element.y.clamp(0, _template!.height - element.height);
// // // // // // //     });
// // // // // // //   }

// // // // // // //   void _updateProfileImageElementPosition(
// // // // // // //     ProfileElement element,
// // // // // // //     Offset delta,
// // // // // // //   ) {
// // // // // // //     setState(() {
// // // // // // //       final scaledDelta = delta / _scaleFactor;
// // // // // // //       element.x += scaledDelta.dx;
// // // // // // //       element.y += scaledDelta.dy;
// // // // // // //       element.x = element.x.clamp(0, _template!.width - element.width);
// // // // // // //       element.y = element.y.clamp(0, _template!.height - element.height);
// // // // // // //     });
// // // // // // //   }

// // // // // // //   void _updateImageElementSize(ImageElement element, double scale) {
// // // // // // //     setState(() {
// // // // // // //       final newWidth = (_baseScale * scale).clamp(50.0, _template!.width * 0.8);
// // // // // // //       final newHeight = (_baseScale * scale).clamp(
// // // // // // //         50.0,
// // // // // // //         _template!.height * 0.8,
// // // // // // //       );

// // // // // // //       element.width = newWidth;
// // // // // // //       element.height = newHeight;
// // // // // // //     });
// // // // // // //   }

// // // // // // //   void _updateProfileImageElementSize(ProfileElement element, double scale) {
// // // // // // //     setState(() {
// // // // // // //       final newWidth = (_baseScale * scale).clamp(50.0, _template!.width * 0.8);
// // // // // // //       final newHeight = (_baseScale * scale).clamp(
// // // // // // //         50.0,
// // // // // // //         _template!.height * 0.8,
// // // // // // //       );

// // // // // // //       element.width = newWidth;
// // // // // // //       element.height = newHeight;
// // // // // // //     });
// // // // // // //   }

// // // // // // //   void _zoomImageElement(ImageElement element, double scaleFactor) {
// // // // // // //     setState(() {
// // // // // // //       final newWidth = (element.width * scaleFactor).clamp(
// // // // // // //         20.0,
// // // // // // //         _template!.width * 0.9,
// // // // // // //       );
// // // // // // //       final newHeight = (element.height * scaleFactor).clamp(
// // // // // // //         20.0,
// // // // // // //         _template!.height * 0.9,
// // // // // // //       );

// // // // // // //       // Calculate center point to maintain position during zoom
// // // // // // //       final centerX = element.x + element.width / 2;
// // // // // // //       final centerY = element.y + element.height / 2;

// // // // // // //       element.width = newWidth;
// // // // // // //       element.height = newHeight;

// // // // // // //       // Reposition to maintain center
// // // // // // //       element.x = (centerX - newWidth / 2).clamp(
// // // // // // //         0,
// // // // // // //         _template!.width - newWidth,
// // // // // // //       );
// // // // // // //       element.y = (centerY - newHeight / 2).clamp(
// // // // // // //         0,
// // // // // // //         _template!.height - newHeight,
// // // // // // //       );
// // // // // // //     });
// // // // // // //   }

// // // // // // //   // void _deselectAll() {
// // // // // // //   //   setState(() {
// // // // // // //   //     if (_template != null) {
// // // // // // //   //       for (var el in _template!.textElements) {
// // // // // // //   //         el.isSelected = false;
// // // // // // //   //       }
// // // // // // //   //       for (var el in _template!.imageElements) {
// // // // // // //   //         el.isSelected = false;
// // // // // // //   //       }
// // // // // // //   //     }
// // // // // // //   //     if (_profileImageElement != null)
// // // // // // //   //       _profileImageElement!.isSelected = false;
// // // // // // //   //     if (_logoImageElement != null) _logoImageElement!.isSelected = false;

// // // // // // //   //     _selectedTextElement = null;
// // // // // // //   //     _selectedImageElement = null;
// // // // // // //   //     _showToolbar = false;
// // // // // // //   //   });
// // // // // // //   // }

// // // // // // //   void _deselectAll() {
// // // // // // //     setState(() {
// // // // // // //       if (_template != null) {
// // // // // // //         for (var el in _template!.textElements) {
// // // // // // //           el.isSelected = false;
// // // // // // //         }
// // // // // // //         for (var el in _template!.imageElements) {
// // // // // // //           el.isSelected = false;
// // // // // // //         }
// // // // // // //       }
// // // // // // //       if (_profileImageElement != null)
// // // // // // //         _profileImageElement!.isSelected = false;
// // // // // // //       if (_logoImageElement != null) _logoImageElement!.isSelected = false;

// // // // // // //       _selectedTextElement = null;
// // // // // // //       _selectedImageElement = null;
// // // // // // //       _selectedProfileImageElement = null;
// // // // // // //       _showToolbar = false;
// // // // // // //     });
// // // // // // //   }

// // // // // // //   void _updateTextElementPosition(TextElement element, Offset delta) {
// // // // // // //     setState(() {
// // // // // // //       final scaledDelta = delta / _scaleFactor;
// // // // // // //       element.x += scaledDelta.dx;
// // // // // // //       element.y += scaledDelta.dy;

// // // // // // //       // Very permissive bounds for large text elements
// // // // // // //       element.x = element.x.clamp(
// // // // // // //         -_template!.width * 0.5, // Allow 50% outside left
// // // // // // //         _template!.width * 1.5, // Allow 50% outside right
// // // // // // //       );
// // // // // // //       element.y = element.y.clamp(
// // // // // // //         -_template!.height * 0.5, // Allow 50% outside top
// // // // // // //         _template!.height * 1.5, // Allow 50% outside bottom
// // // // // // //       );
// // // // // // //     });
// // // // // // //   }

// // // // // // //   void _showTextEditDialog() {
// // // // // // //     if (_selectedTextElement == null) return;

// // // // // // //     final controller = TextEditingController(text: _selectedTextElement!.text);

// // // // // // //     showDialog(
// // // // // // //       context: context,
// // // // // // //       builder: (context) => AlertDialog(
// // // // // // //         title: const Text('Edit Text'),
// // // // // // //         content: TextField(
// // // // // // //           controller: controller,
// // // // // // //           maxLines: null,
// // // // // // //           decoration: const InputDecoration(
// // // // // // //             hintText: 'Enter text...',
// // // // // // //             border: OutlineInputBorder(),
// // // // // // //           ),
// // // // // // //         ),
// // // // // // //         actions: [
// // // // // // //           TextButton(
// // // // // // //             onPressed: () => Navigator.pop(context),
// // // // // // //             child: const Text('Cancel'),
// // // // // // //           ),
// // // // // // //           TextButton(
// // // // // // //             onPressed: () {
// // // // // // //               setState(() {
// // // // // // //                 _selectedTextElement!.text = controller.text;
// // // // // // //               });
// // // // // // //               Navigator.pop(context);
// // // // // // //             },
// // // // // // //             child: const Text('Save'),
// // // // // // //           ),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   void _addNewTextElement() {
// // // // // // //     if (_template == null) return;

// // // // // // //     final newElement = TextElement(
// // // // // // //       id: 'text_${DateTime.now().millisecondsSinceEpoch}',
// // // // // // //       text: '',
// // // // // // //       x: 350,
// // // // // // //       y: 350,
// // // // // // //       width: 200,
// // // // // // //       height: 50,
// // // // // // //       fontSize: 50,
// // // // // // //       color: Colors.black,
// // // // // // //       fontWeight: FontWeight.normal,
// // // // // // //       fontFamily: 'Arial',
// // // // // // //       textAlign: TextAlign.left,
// // // // // // //     );

// // // // // // //     setState(() {
// // // // // // //       _template!.textElements.add(newElement);
// // // // // // //       _selectTextElement(newElement);
// // // // // // //     });
// // // // // // //   }

// // // // // // //   void _deleteSelectedElement() {
// // // // // // //     if (_selectedTextElement != null && _template != null) {
// // // // // // //       setState(() {
// // // // // // //         _template!.textElements.remove(_selectedTextElement);
// // // // // // //         _selectedTextElement = null;
// // // // // // //         _showToolbar = false;
// // // // // // //       });
// // // // // // //     } else if (_selectedImageElement != null && _template != null) {
// // // // // // //       setState(() {
// // // // // // //         // Check if it's logo image
// // // // // // //         if (_selectedImageElement!.id == 'logo_image') {
// // // // // // //           _logoImageElement = null;
// // // // // // //           _logoImage = null;
// // // // // // //         } else {
// // // // // // //           _template!.imageElements.remove(_selectedImageElement);
// // // // // // //         }
// // // // // // //         _selectedImageElement = null;
// // // // // // //         _showToolbar = false;
// // // // // // //       });
// // // // // // //     } else if (_selectedProfileImageElement != null) {
// // // // // // //       // Handle profile image deletion
// // // // // // //       setState(() {
// // // // // // //         _profileImageElement = null;
// // // // // // //         _profileImageBytes = null;
// // // // // // //         _selectedProfileImageElement = null;
// // // // // // //         _showToolbar = false;
// // // // // // //       });

// // // // // // //       // Show confirmation message
// // // // // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // // // // //         const SnackBar(
// // // // // // //           content: Text('Profile image deleted'),
// // // // // // //           backgroundColor: Colors.orange,
// // // // // // //           duration: Duration(seconds: 2),
// // // // // // //         ),
// // // // // // //       );
// // // // // // //     }
// // // // // // //   }

// // // // // // //   Future<void> savePoster() async {
// // // // // // //     try {
// // // // // // //       showDialog(
// // // // // // //         context: context,
// // // // // // //         barrierDismissible: false,
// // // // // // //         builder: (context) => const AlertDialog(
// // // // // // //           content: Row(
// // // // // // //             children: [
// // // // // // //               CircularProgressIndicator(),
// // // // // // //               SizedBox(width: 13),
// // // // // // //               Text('Saving poster to gallery...'),
// // // // // // //             ],
// // // // // // //           ),
// // // // // // //         ),
// // // // // // //       );

// // // // // // //       RenderRepaintBoundary boundary =
// // // // // // //           _canvasKey.currentContext!.findRenderObject()
// // // // // // //               as RenderRepaintBoundary;

// // // // // // //       ui.Image image = await boundary.toImage(pixelRatio: 3.0);
// // // // // // //       ByteData? byteData = await image.toByteData(
// // // // // // //         format: ui.ImageByteFormat.png,
// // // // // // //       );
// // // // // // //       Uint8List pngBytes = byteData!.buffer.asUint8List();

// // // // // // //       await Gal.putImageBytes(
// // // // // // //         pngBytes,
// // // // // // //         album: 'Posters',
// // // // // // //         name: 'poster_${DateTime.now().millisecondsSinceEpoch}.png',
// // // // // // //       );

// // // // // // //       Navigator.of(context).pop();

// // // // // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // // // // //         const SnackBar(
// // // // // // //           content: Text('Poster saved to gallery successfully!'),
// // // // // // //           backgroundColor: Colors.green,
// // // // // // //           duration: Duration(seconds: 3),
// // // // // // //         ),
// // // // // // //       );
// // // // // // //     } catch (e) {
// // // // // // //       if (Navigator.of(context).canPop()) {
// // // // // // //         Navigator.of(context).pop();
// // // // // // //       }

// // // // // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // // // // //         SnackBar(
// // // // // // //           content: Text('Error saving poster: $e'),
// // // // // // //           backgroundColor: Colors.red,
// // // // // // //           duration: const Duration(seconds: 4),
// // // // // // //         ),
// // // // // // //       );
// // // // // // //     }
// // // // // // //   }

// // // // // // //   Future<void> _sharePoster() async {
// // // // // // //     try {
// // // // // // //       showDialog(
// // // // // // //         context: context,
// // // // // // //         barrierDismissible: false,
// // // // // // //         builder: (context) => const AlertDialog(
// // // // // // //           content: Row(
// // // // // // //             children: [
// // // // // // //               CircularProgressIndicator(),
// // // // // // //               SizedBox(width: 12),
// // // // // // //               Text('Preparing poster for\n sharing...'),
// // // // // // //             ],
// // // // // // //           ),
// // // // // // //         ),
// // // // // // //       );

// // // // // // //       RenderRepaintBoundary boundary =
// // // // // // //           _canvasKey.currentContext!.findRenderObject()
// // // // // // //               as RenderRepaintBoundary;

// // // // // // //       ui.Image image = await boundary.toImage(pixelRatio: 3.0);
// // // // // // //       ByteData? byteData = await image.toByteData(
// // // // // // //         format: ui.ImageByteFormat.png,
// // // // // // //       );
// // // // // // //       Uint8List pngBytes = byteData!.buffer.asUint8List();

// // // // // // //       final directory = await getTemporaryDirectory();
// // // // // // //       final file = File(
// // // // // // //         '${directory.path}/poster_share_${DateTime.now().millisecondsSinceEpoch}.png',
// // // // // // //       );
// // // // // // //       await file.writeAsBytes(pngBytes);

// // // // // // //       Navigator.of(context).pop();

// // // // // // //       await Share.shareXFiles([XFile(file.path)], text: 'Check out my poster!');
// // // // // // //     } catch (e) {
// // // // // // //       if (Navigator.of(context).canPop()) {
// // // // // // //         Navigator.of(context).pop();
// // // // // // //       }

// // // // // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // // // // //         SnackBar(
// // // // // // //           content: Text('Error sharing poster: $e'),
// // // // // // //           backgroundColor: Colors.red,
// // // // // // //           duration: const Duration(seconds: 4),
// // // // // // //         ),
// // // // // // //       );
// // // // // // //     }
// // // // // // //   }

// // // // // // //   Widget _buildProfileImage() {
// // // // // // //     if (_profileImageBytes == null || _profileImageElement == null) {
// // // // // // //       return const SizedBox.shrink();
// // // // // // //     }

// // // // // // //     return Positioned(
// // // // // // //       left: _profileImageElement!.x,
// // // // // // //       top: _profileImageElement!.y,
// // // // // // //       width: _profileImageElement!.width,
// // // // // // //       height: _profileImageElement!.height,
// // // // // // //       child: GestureDetector(
// // // // // // //         onTap: () => _selectProfileImageElement(_profileImageElement!),
// // // // // // //         onScaleStart: (details) {
// // // // // // //           _baseScale = _profileImageElement!.width;
// // // // // // //           _initialFocalPoint = details.focalPoint;
// // // // // // //         },
// // // // // // //         onScaleUpdate: (details) {
// // // // // // //           // Handle scaling (when scale != 1.0)
// // // // // // //           if (details.scale != 1.0) {
// // // // // // //             _updateProfileImageElementSize(
// // // // // // //               _profileImageElement!,
// // // // // // //               details.scale,
// // // // // // //             );
// // // // // // //           }

// // // // // // //           // Handle panning (when focalPoint changes)
// // // // // // //           if (_initialFocalPoint != null) {
// // // // // // //             final delta = details.focalPoint - _initialFocalPoint!;
// // // // // // //             _updateProfileImageElementPosition(_profileImageElement!, delta);
// // // // // // //             _initialFocalPoint = details.focalPoint;
// // // // // // //           }
// // // // // // //         },
// // // // // // //         onScaleEnd: (details) {
// // // // // // //           _initialFocalPoint = null;
// // // // // // //         },
// // // // // // //         child: Transform.rotate(
// // // // // // //           angle: _profileImageElement!.rotation * 3.14159 / 180,
// // // // // // //           child: Container(
// // // // // // //             decoration: _profileImageElement!.isSelected
// // // // // // //                 ? BoxDecoration(
// // // // // // //                     // border: Border.all(color: Colors.green, width: 2),
// // // // // // //                     color: Colors.green.withOpacity(0.1),
// // // // // // //                   )
// // // // // // //                 : null,
// // // // // // //             child: ClipRRect(
// // // // // // //               borderRadius: BorderRadius.circular(100),
// // // // // // //               child: Image.memory(_profileImageBytes!, fit: BoxFit.fill),
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Widget _buildLogoImage() {
// // // // // // //     if (_logoImage == null || _logoImageElement == null) {
// // // // // // //       return const SizedBox.shrink();
// // // // // // //     }

// // // // // // //     return Positioned(
// // // // // // //       left: _logoImageElement!.x,
// // // // // // //       top: _logoImageElement!.y,
// // // // // // //       width: _logoImageElement!.width,
// // // // // // //       height: _logoImageElement!.height,
// // // // // // //       child: GestureDetector(
// // // // // // //         onTap: () => _selectImageElement(_logoImageElement!),
// // // // // // //         onScaleStart: (details) {
// // // // // // //           _baseScale = _logoImageElement!.width;
// // // // // // //           _initialFocalPoint = details.focalPoint;
// // // // // // //         },
// // // // // // //         onScaleUpdate: (details) {
// // // // // // //           // Handle scaling (when scale != 1.0)
// // // // // // //           if (details.scale != 1.0) {
// // // // // // //             _updateImageElementSize(_logoImageElement!, details.scale);
// // // // // // //           }

// // // // // // //           // Handle panning (when focalPoint changes)
// // // // // // //           if (_initialFocalPoint != null) {
// // // // // // //             final delta = details.focalPoint - _initialFocalPoint!;
// // // // // // //             _updateImageElementPosition(_logoImageElement!, delta);
// // // // // // //             _initialFocalPoint = details.focalPoint;
// // // // // // //           }
// // // // // // //         },
// // // // // // //         onScaleEnd: (details) {
// // // // // // //           _initialFocalPoint = null;
// // // // // // //         },
// // // // // // //         child: Transform.rotate(
// // // // // // //           angle: _logoImageElement!.rotation * 3.14159 / 180,
// // // // // // //           child: Container(
// // // // // // //             decoration: _logoImageElement!.isSelected
// // // // // // //                 ? BoxDecoration(
// // // // // // //                     // border: Border.all(color: Colors.green, width: 2),
// // // // // // //                     color: Colors.green.withOpacity(0.1),
// // // // // // //                   )
// // // // // // //                 : null,
// // // // // // //             child: ClipRRect(
// // // // // // //               borderRadius: BorderRadius.circular(50),
// // // // // // //               child: Image.memory(_logoImage!, fit: BoxFit.cover),
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Widget _buildTextElement(TextElement element) {
// // // // // // //     return Positioned(
// // // // // // //       left: element.x,
// // // // // // //       top: element.y,
// // // // // // //       child: GestureDetector(
// // // // // // //         onTap: () => _selectTextElement(element),
// // // // // // //         onPanUpdate: (details) {
// // // // // // //           _updateTextElementPosition(element, details.delta);
// // // // // // //         },
// // // // // // //         child: Transform.rotate(
// // // // // // //           angle: element.rotation * 3.14159 / 180,
// // // // // // //           child: Container(
// // // // // // //             // Flexible constraints that allow for very large text
// // // // // // //             constraints: BoxConstraints(
// // // // // // //               minWidth: 50,
// // // // // // //               maxWidth:
// // // // // // //                   _template!.width * 3, // Triple canvas width for large text
// // // // // // //               minHeight: 20,
// // // // // // //               maxHeight: _template!.height * 3, // Triple canvas height
// // // // // // //             ),
// // // // // // //             decoration: element.isSelected
// // // // // // //                 ? BoxDecoration(
// // // // // // //                     // border: Border.all(color: Colors.green, width: 2),
// // // // // // //                   )
// // // // // // //                 : null,
// // // // // // //             child: ConstrainedBox(
// // // // // // //               constraints: BoxConstraints(
// // // // // // //                 maxWidth: _template!.width * 2, // Double canvas width
// // // // // // //                 maxHeight: _template!.height * 2, // Double canvas height
// // // // // // //               ),
// // // // // // //               child: SingleChildScrollView(
// // // // // // //                 scrollDirection: Axis.horizontal,
// // // // // // //                 child: SingleChildScrollView(
// // // // // // //                   scrollDirection: Axis.vertical,
// // // // // // //                   child: Text(
// // // // // // //                     element.text,
// // // // // // //                     style: TextStyle(
// // // // // // //                       fontSize: element.fontSize,
// // // // // // //                       color: element.color,
// // // // // // //                       fontWeight: element.fontWeight,
// // // // // // //                       fontFamily: element.fontFamily,
// // // // // // //                       height: 1.2, // Better line spacing for large text
// // // // // // //                     ),
// // // // // // //                     textAlign: element.textAlign,
// // // // // // //                     maxLines: null,
// // // // // // //                     overflow: TextOverflow.visible,
// // // // // // //                     softWrap: true,
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Widget _buildImageElement(ImageElement element) {
// // // // // // //     return Positioned(
// // // // // // //       left: element.x,
// // // // // // //       top: element.y,
// // // // // // //       width: element.width,
// // // // // // //       height: element.height,
// // // // // // //       child: GestureDetector(
// // // // // // //         onTap: () => _selectImageElement(element),
// // // // // // //         onScaleStart: (details) {
// // // // // // //           _baseScale = element.width;
// // // // // // //           _initialFocalPoint = details.focalPoint;
// // // // // // //         },
// // // // // // //         onScaleUpdate: (details) {
// // // // // // //           if (details.scale != 1.0) {
// // // // // // //             _updateImageElementSize(element, details.scale);
// // // // // // //           }
// // // // // // //           if (_initialFocalPoint != null) {
// // // // // // //             final delta = details.focalPoint - _initialFocalPoint!;
// // // // // // //             _updateImageElementPosition(element, delta);
// // // // // // //             _initialFocalPoint = details.focalPoint;
// // // // // // //           }
// // // // // // //         },
// // // // // // //         onScaleEnd: (details) {
// // // // // // //           _initialFocalPoint = null;
// // // // // // //         },
// // // // // // //         child: Transform.rotate(
// // // // // // //           angle: element.rotation * 3.14159 / 180,
// // // // // // //           child: Container(
// // // // // // //             decoration: element.isSelected
// // // // // // //                 ? BoxDecoration(
// // // // // // //                     // border: Border.all(color: Colors.green, width: 2),
// // // // // // //                     color: Colors.green.withOpacity(0.1),
// // // // // // //                   )
// // // // // // //                 : null,
// // // // // // //             child: ClipRRect(
// // // // // // //               borderRadius: BorderRadius.circular(
// // // // // // //                 // Use the dynamic borderRadius property
// // // // // // //                 element.id == 'logo_image' || element.id == 'profile_image'
// // // // // // //                     ? 50
// // // // // // //                     : element.borderRadius,
// // // // // // //               ),
// // // // // // //               child: element.imageUrl.isNotEmpty
// // // // // // //                   ? (element.imageUrl.startsWith('http')
// // // // // // //                         ? Image.network(
// // // // // // //                             element.imageUrl,
// // // // // // //                             fit: BoxFit.cover,
// // // // // // //                             loadingBuilder: (context, child, loadingProgress) {
// // // // // // //                               if (loadingProgress == null) return child;
// // // // // // //                               return Container(
// // // // // // //                                 color: Colors.grey[200],
// // // // // // //                                 child: Center(
// // // // // // //                                   child: SizedBox(
// // // // // // //                                     width: 20,
// // // // // // //                                     height: 20,
// // // // // // //                                     child: CircularProgressIndicator(
// // // // // // //                                       strokeWidth: 2,
// // // // // // //                                       value:
// // // // // // //                                           loadingProgress.expectedTotalBytes !=
// // // // // // //                                               null
// // // // // // //                                           ? loadingProgress
// // // // // // //                                                     .cumulativeBytesLoaded /
// // // // // // //                                                 loadingProgress
// // // // // // //                                                     .expectedTotalBytes!
// // // // // // //                                           : null,
// // // // // // //                                     ),
// // // // // // //                                   ),
// // // // // // //                                 ),
// // // // // // //                               );
// // // // // // //                             },
// // // // // // //                             errorBuilder: (context, error, stackTrace) {
// // // // // // //                               return Container(
// // // // // // //                                 color: Colors.grey.shade300,
// // // // // // //                                 child: const Center(
// // // // // // //                                   child: Column(
// // // // // // //                                     mainAxisAlignment: MainAxisAlignment.center,
// // // // // // //                                     children: [
// // // // // // //                                       Icon(
// // // // // // //                                         Icons.error,
// // // // // // //                                         color: Colors.red,
// // // // // // //                                         size: 24,
// // // // // // //                                       ),
// // // // // // //                                       Text(
// // // // // // //                                         'Image Error',
// // // // // // //                                         style: TextStyle(fontSize: 10),
// // // // // // //                                       ),
// // // // // // //                                     ],
// // // // // // //                                   ),
// // // // // // //                                 ),
// // // // // // //                               );
// // // // // // //                             },
// // // // // // //                           )
// // // // // // //                         : Image.file(File(element.imageUrl), fit: BoxFit.fill))
// // // // // // //                   : Container(
// // // // // // //                       color: Colors.grey.shade300,
// // // // // // //                       child: const Center(
// // // // // // //                         child: Icon(Icons.image, color: Colors.grey, size: 24),
// // // // // // //                       ),
// // // // // // //                     ),
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Alignment _getAlignment(TextAlign textAlign) {
// // // // // // //     switch (textAlign) {
// // // // // // //       case TextAlign.center:
// // // // // // //         return Alignment.center;
// // // // // // //       case TextAlign.right:
// // // // // // //         return Alignment.centerRight;
// // // // // // //       default:
// // // // // // //         return Alignment.centerLeft;
// // // // // // //     }
// // // // // // //   }

// // // // // // //   Widget _buildToolbar() {
// // // // // // //     if (_selectedTextElement == null &&
// // // // // // //         _selectedImageElement == null &&
// // // // // // //         _selectedProfileImageElement == null) {
// // // // // // //       return const SizedBox.shrink();
// // // // // // //     }

// // // // // // //     return Container(
// // // // // // //       padding: const EdgeInsets.all(8),
// // // // // // //       color: Colors.white,
// // // // // // //       child: SingleChildScrollView(
// // // // // // //         scrollDirection: Axis.horizontal,
// // // // // // //         child: Row(
// // // // // // //           children: [
// // // // // // //             if (_selectedTextElement != null) ...[
// // // // // // //               IconButton(
// // // // // // //                 icon: const Icon(Icons.edit, color: Colors.deepPurple),
// // // // // // //                 onPressed: _showTextEditDialog,
// // // // // // //                 tooltip: 'Edit Text',
// // // // // // //               ),
// // // // // // //               const VerticalDivider(width: 16),

// // // // // // //               // Font Size Controls - Manual Input Button
// // // // // // //               IconButton(
// // // // // // //                 icon: const Icon(Icons.text_fields, color: Colors.deepPurple),
// // // // // // //                 onPressed: _showManualSizeInputDialog,
// // // // // // //                 tooltip: 'Enter Size Manually',
// // // // // // //               ),
// // // // // // //               const VerticalDivider(width: 16),

// // // // // // //               // Font Size Slider for Text Elements (keep existing slider)
// // // // // // //               const Text(
// // // // // // //                 'Size: ',
// // // // // // //                 style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
// // // // // // //               ),
// // // // // // //               SizedBox(
// // // // // // //                 width: 150,
// // // // // // //                 child: Slider(
// // // // // // //                   value: _selectedTextElement!.fontSize,
// // // // // // //                   min: 8.0,
// // // // // // //                   max: 600.0,
// // // // // // //                   divisions: 100,
// // // // // // //                   label: '${_selectedTextElement!.fontSize.round()}',
// // // // // // //                   onChanged: (value) {
// // // // // // //                     setState(() {
// // // // // // //                       _selectedTextElement!.fontSize = value;
// // // // // // //                       if (value > 100) {
// // // // // // //                         final textLength = _selectedTextElement!.text.length;
// // // // // // //                         _selectedTextElement!.width = (textLength * value * 0.5)
// // // // // // //                             .clamp(200.0, _template!.width * 2);
// // // // // // //                         _selectedTextElement!.height = (value * 1.5).clamp(
// // // // // // //                           50.0,
// // // // // // //                           _template!.height * 2,
// // // // // // //                         );
// // // // // // //                       }
// // // // // // //                     });
// // // // // // //                   },
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //               const VerticalDivider(width: 16),

// // // // // // //               // Display current font size
// // // // // // //               Container(
// // // // // // //                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// // // // // // //                 decoration: BoxDecoration(
// // // // // // //                   border: Border.all(color: Colors.grey.shade300),
// // // // // // //                   borderRadius: BorderRadius.circular(4),
// // // // // // //                 ),
// // // // // // //                 child: Text(
// // // // // // //                   '${_selectedTextElement!.fontSize.round()}px',
// // // // // // //                   style: const TextStyle(
// // // // // // //                     fontWeight: FontWeight.bold,
// // // // // // //                     fontSize: 12,
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //               const VerticalDivider(width: 16),

// // // // // // //               // Rest of your existing toolbar code remains the same...
// // // // // // //               IconButton(
// // // // // // //                 icon: const Icon(Icons.fit_screen, color: Colors.deepPurple),
// // // // // // //                 onPressed: () {
// // // // // // //                   setState(() {
// // // // // // //                     double estimatedWidth =
// // // // // // //                         _selectedTextElement!.text.length *
// // // // // // //                         _selectedTextElement!.fontSize *
// // // // // // //                         0.6;
// // // // // // //                     double estimatedHeight =
// // // // // // //                         _selectedTextElement!.fontSize * 1.5;

// // // // // // //                     _selectedTextElement!.width = estimatedWidth.clamp(
// // // // // // //                       100.0,
// // // // // // //                       _template!.width * 1.5,
// // // // // // //                     );
// // // // // // //                     _selectedTextElement!.height = estimatedHeight.clamp(
// // // // // // //                       50.0,
// // // // // // //                       _template!.height * 1.5,
// // // // // // //                     );
// // // // // // //                   });
// // // // // // //                 },
// // // // // // //                 tooltip: 'Auto-fit Size',
// // // // // // //               ),

// // // // // // //               // Font Family Dropdown
// // // // // // //               Container(
// // // // // // //                 padding: const EdgeInsets.symmetric(horizontal: 8),
// // // // // // //                 decoration: BoxDecoration(
// // // // // // //                   border: Border.all(color: Colors.grey.shade300),
// // // // // // //                   borderRadius: BorderRadius.circular(4),
// // // // // // //                 ),
// // // // // // //                 child: DropdownButtonHideUnderline(
// // // // // // //                   child: DropdownButton<String>(
// // // // // // //                     value: _selectedTextElement!.fontFamily,
// // // // // // //                     items: _fontFamilies
// // // // // // //                         .toSet()
// // // // // // //                         .map(
// // // // // // //                           (font) => DropdownMenuItem(
// // // // // // //                             value: font,
// // // // // // //                             child: Text(
// // // // // // //                               font,
// // // // // // //                               style: TextStyle(fontFamily: font),
// // // // // // //                             ),
// // // // // // //                           ),
// // // // // // //                         )
// // // // // // //                         .toList(),
// // // // // // //                     onChanged: (value) {
// // // // // // //                       if (value != null) {
// // // // // // //                         setState(() {
// // // // // // //                           _selectedTextElement!.fontFamily = value;
// // // // // // //                         });
// // // // // // //                       }
// // // // // // //                     },
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //               const SizedBox(width: 8),

// // // // // // //               // Font Weight Dropdown
// // // // // // //               Container(
// // // // // // //                 padding: const EdgeInsets.symmetric(horizontal: 8),
// // // // // // //                 decoration: BoxDecoration(
// // // // // // //                   border: Border.all(color: Colors.grey.shade300),
// // // // // // //                   borderRadius: BorderRadius.circular(4),
// // // // // // //                 ),
// // // // // // //                 child: DropdownButtonHideUnderline(
// // // // // // //                   child: DropdownButton<FontWeight>(
// // // // // // //                     value: _selectedTextElement!.fontWeight,
// // // // // // //                     items: _fontWeights
// // // // // // //                         .map(
// // // // // // //                           (weight) => DropdownMenuItem(
// // // // // // //                             value: weight,
// // // // // // //                             child: Text(
// // // // // // //                               weight == FontWeight.bold
// // // // // // //                                   ? 'Bold'
// // // // // // //                                   : weight == FontWeight.w600
// // // // // // //                                   ? 'Semi-Bold'
// // // // // // //                                   : weight == FontWeight.w300
// // // // // // //                                   ? 'Light'
// // // // // // //                                   : weight == FontWeight.w900
// // // // // // //                                   ? 'Black'
// // // // // // //                                   : 'Normal',
// // // // // // //                               style: TextStyle(fontWeight: weight),
// // // // // // //                             ),
// // // // // // //                           ),
// // // // // // //                         )
// // // // // // //                         .toList(),
// // // // // // //                     onChanged: (value) {
// // // // // // //                       if (value != null) {
// // // // // // //                         setState(() {
// // // // // // //                           _selectedTextElement!.fontWeight = value;
// // // // // // //                         });
// // // // // // //                       }
// // // // // // //                     },
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //               const VerticalDivider(width: 16),

// // // // // // //               // Text Alignment
// // // // // // //               Row(
// // // // // // //                 children: [
// // // // // // //                   IconButton(
// // // // // // //                     icon: Icon(
// // // // // // //                       Icons.format_align_left,
// // // // // // //                       color: _selectedTextElement!.textAlign == TextAlign.left
// // // // // // //                           ? Colors.deepPurple
// // // // // // //                           : Colors.grey,
// // // // // // //                     ),
// // // // // // //                     onPressed: () {
// // // // // // //                       setState(() {
// // // // // // //                         _selectedTextElement!.textAlign = TextAlign.left;
// // // // // // //                       });
// // // // // // //                     },
// // // // // // //                     tooltip: 'Align Left',
// // // // // // //                   ),
// // // // // // //                   IconButton(
// // // // // // //                     icon: Icon(
// // // // // // //                       Icons.format_align_center,
// // // // // // //                       color: _selectedTextElement!.textAlign == TextAlign.center
// // // // // // //                           ? Colors.deepPurple
// // // // // // //                           : Colors.grey,
// // // // // // //                     ),
// // // // // // //                     onPressed: () {
// // // // // // //                       setState(() {
// // // // // // //                         _selectedTextElement!.textAlign = TextAlign.center;
// // // // // // //                       });
// // // // // // //                     },
// // // // // // //                     tooltip: 'Align Center',
// // // // // // //                   ),
// // // // // // //                   IconButton(
// // // // // // //                     icon: Icon(
// // // // // // //                       Icons.format_align_right,
// // // // // // //                       color: _selectedTextElement!.textAlign == TextAlign.right
// // // // // // //                           ? Colors.deepPurple
// // // // // // //                           : Colors.grey,
// // // // // // //                     ),
// // // // // // //                     onPressed: () {
// // // // // // //                       setState(() {
// // // // // // //                         _selectedTextElement!.textAlign = TextAlign.right;
// // // // // // //                       });
// // // // // // //                     },
// // // // // // //                     tooltip: 'Align Right',
// // // // // // //                   ),
// // // // // // //                 ],
// // // // // // //               ),
// // // // // // //               const VerticalDivider(width: 16),

// // // // // // //               // RGB Color Picker Button
// // // // // // //               IconButton(
// // // // // // //                 icon: Icon(
// // // // // // //                   Icons.color_lens,
// // // // // // //                   color: _selectedTextElement!.color,
// // // // // // //                 ),
// // // // // // //                 onPressed: _showColorPickerDialog,
// // // // // // //                 tooltip: 'Choose Color',
// // // // // // //               ),

// // // // // // //               // Delete button for text elements
// // // // // // //               const VerticalDivider(width: 16),
// // // // // // //               IconButton(
// // // // // // //                 icon: const Icon(Icons.delete, color: Colors.red),
// // // // // // //                 onPressed: _deleteSelectedElement,
// // // // // // //                 tooltip: 'Delete Text',
// // // // // // //               ),
// // // // // // //             ] else if (_selectedImageElement != null) ...[
// // // // // // //               // ... rest of your existing image toolbar code
// // // // // // //               const Text(
// // // // // // //                 'Size: ',
// // // // // // //                 style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
// // // // // // //               ),
// // // // // // //               SizedBox(
// // // // // // //                 width: 120,
// // // // // // //                 child: Slider(
// // // // // // //                   value: _selectedImageElement!.width,
// // // // // // //                   min: 20.0,
// // // // // // //                   max: _template!.width * 0.9,
// // // // // // //                   divisions: 50,
// // // // // // //                   label: '${_selectedImageElement!.width.round()}',
// // // // // // //                   onChanged: (value) {
// // // // // // //                     setState(() {
// // // // // // //                       final aspectRatio =
// // // // // // //                           _selectedImageElement!.width /
// // // // // // //                           _selectedImageElement!.height;
// // // // // // //                       _selectedImageElement!.width = value;
// // // // // // //                       _selectedImageElement!.height = value / aspectRatio;

// // // // // // //                       _selectedImageElement!.x = _selectedImageElement!.x.clamp(
// // // // // // //                         0,
// // // // // // //                         _template!.width - _selectedImageElement!.width,
// // // // // // //                       );
// // // // // // //                       _selectedImageElement!.y = _selectedImageElement!.y.clamp(
// // // // // // //                         0,
// // // // // // //                         _template!.height - _selectedImageElement!.height,
// // // // // // //                       );
// // // // // // //                     });
// // // // // // //                   },
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //               const VerticalDivider(width: 16),

// // // // // // //               // Border Radius Slider
// // // // // // //               const Text(
// // // // // // //                 'Corner: ',
// // // // // // //                 style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
// // // // // // //               ),
// // // // // // //               SizedBox(
// // // // // // //                 width: 120,
// // // // // // //                 child: Slider(
// // // // // // //                   value: _selectedImageElement!.borderRadius,
// // // // // // //                   min: 0.0,
// // // // // // //                   max: 100.0,
// // // // // // //                   divisions: 20,
// // // // // // //                   label: '${_selectedImageElement!.borderRadius.round()}',
// // // // // // //                   onChanged: (value) {
// // // // // // //                     setState(() {
// // // // // // //                       _selectedImageElement!.borderRadius = value;
// // // // // // //                     });
// // // // // // //                   },
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //               const VerticalDivider(width: 16),

// // // // // // //               IconButton(
// // // // // // //                 icon: const Icon(Icons.crop_square, color: Colors.deepPurple),
// // // // // // //                 onPressed: () {
// // // // // // //                   setState(() {
// // // // // // //                     _selectedImageElement!.borderRadius = 0.0;
// // // // // // //                   });
// // // // // // //                 },
// // // // // // //                 tooltip: 'Sharp Corners',
// // // // // // //               ),
// // // // // // //               IconButton(
// // // // // // //                 icon: const Icon(
// // // // // // //                   Icons.rounded_corner,
// // // // // // //                   color: Colors.deepPurple,
// // // // // // //                 ),
// // // // // // //                 onPressed: () {
// // // // // // //                   setState(() {
// // // // // // //                     _selectedImageElement!.borderRadius = 12.0;
// // // // // // //                   });
// // // // // // //                 },
// // // // // // //                 tooltip: 'Rounded Corners',
// // // // // // //               ),
// // // // // // //               IconButton(
// // // // // // //                 icon: const Icon(
// // // // // // //                   Icons.circle_outlined,
// // // // // // //                   color: Colors.deepPurple,
// // // // // // //                 ),
// // // // // // //                 onPressed: () {
// // // // // // //                   setState(() {
// // // // // // //                     _selectedImageElement!.borderRadius = 50.0;
// // // // // // //                   });
// // // // // // //                 },
// // // // // // //                 tooltip: 'Circular',
// // // // // // //               ),
// // // // // // //               const VerticalDivider(width: 16),

// // // // // // //               // Reset Size Button
// // // // // // //               IconButton(
// // // // // // //                 icon: const Icon(Icons.aspect_ratio, color: Colors.deepPurple),
// // // // // // //                 onPressed: () {
// // // // // // //                   double originalSize = 200.0;
// // // // // // //                   if (_selectedImageElement!.id == 'logo_image') {
// // // // // // //                     originalSize = 100.0;
// // // // // // //                   } else if (_selectedImageElement!.id == 'profile_image') {
// // // // // // //                     originalSize = 200.0;
// // // // // // //                   }

// // // // // // //                   setState(() {
// // // // // // //                     _selectedImageElement!.width = originalSize;
// // // // // // //                     _selectedImageElement!.height = originalSize;
// // // // // // //                   });
// // // // // // //                 },
// // // // // // //                 tooltip: 'Reset Size',
// // // // // // //               ),
// // // // // // //               const VerticalDivider(width: 16),

// // // // // // //               // Delete Button
// // // // // // //               IconButton(
// // // // // // //                 icon: const Icon(Icons.delete, color: Colors.red),
// // // // // // //                 onPressed: _deleteSelectedElement,
// // // // // // //                 tooltip: 'Delete Image',
// // // // // // //               ),
// // // // // // //             ] else if (_selectedProfileImageElement != null) ...[
// // // // // // //               // ... rest of your existing profile image toolbar code
// // // // // // //               const Text(
// // // // // // //                 'Profile Image',
// // // // // // //                 style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
// // // // // // //               ),
// // // // // // //               const VerticalDivider(width: 16),

// // // // // // //               // Size controls for profile image
// // // // // // //               IconButton(
// // // // // // //                 icon: const Icon(Icons.zoom_out, color: Colors.deepPurple),
// // // // // // //                 onPressed: () {
// // // // // // //                   setState(() {
// // // // // // //                     final newSize = (_selectedProfileImageElement!.width * 0.9)
// // // // // // //                         .clamp(50.0, _template!.width * 0.8);
// // // // // // //                     _selectedProfileImageElement!.width = newSize;
// // // // // // //                     _selectedProfileImageElement!.height = newSize;
// // // // // // //                   });
// // // // // // //                 },
// // // // // // //                 tooltip: 'Make Smaller',
// // // // // // //               ),

// // // // // // //               Container(
// // // // // // //                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// // // // // // //                 decoration: BoxDecoration(
// // // // // // //                   border: Border.all(color: Colors.grey.shade300),
// // // // // // //                   borderRadius: BorderRadius.circular(4),
// // // // // // //                 ),
// // // // // // //                 child: Text(
// // // // // // //                   '${(_selectedProfileImageElement!.width).round()}×${(_selectedProfileImageElement!.height).round()}',
// // // // // // //                   style: const TextStyle(fontSize: 12),
// // // // // // //                 ),
// // // // // // //               ),

// // // // // // //               IconButton(
// // // // // // //                 icon: const Icon(Icons.zoom_in, color: Colors.deepPurple),
// // // // // // //                 onPressed: () {
// // // // // // //                   setState(() {
// // // // // // //                     final newSize = (_selectedProfileImageElement!.width * 1.1)
// // // // // // //                         .clamp(50.0, _template!.width * 0.8);
// // // // // // //                     _selectedProfileImageElement!.width = newSize;
// // // // // // //                     _selectedProfileImageElement!.height = newSize;
// // // // // // //                   });
// // // // // // //                 },
// // // // // // //                 tooltip: 'Make Larger',
// // // // // // //               ),

// // // // // // //               const VerticalDivider(width: 16),

// // // // // // //               // Size Slider for Profile Image
// // // // // // //               const Text(
// // // // // // //                 'Size: ',
// // // // // // //                 style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
// // // // // // //               ),
// // // // // // //               SizedBox(
// // // // // // //                 width: 120,
// // // // // // //                 child: Slider(
// // // // // // //                   value: _selectedProfileImageElement!.width,
// // // // // // //                   min: 50.0,
// // // // // // //                   max: _template!.width * 0.8,
// // // // // // //                   divisions: 50,
// // // // // // //                   label: '${_selectedProfileImageElement!.width.round()}',
// // // // // // //                   onChanged: (value) {
// // // // // // //                     setState(() {
// // // // // // //                       _selectedProfileImageElement!.width = value;
// // // // // // //                       _selectedProfileImageElement!.height = value;

// // // // // // //                       _selectedProfileImageElement!
// // // // // // //                           .x = _selectedProfileImageElement!.x.clamp(
// // // // // // //                         0,
// // // // // // //                         _template!.width - _selectedProfileImageElement!.width,
// // // // // // //                       );
// // // // // // //                       _selectedProfileImageElement!.y =
// // // // // // //                           _selectedProfileImageElement!.y.clamp(
// // // // // // //                             0,
// // // // // // //                             _template!.height -
// // // // // // //                                 _selectedProfileImageElement!.height,
// // // // // // //                           );
// // // // // // //                     });
// // // // // // //                   },
// // // // // // //                 ),
// // // // // // //               ),

// // // // // // //               const VerticalDivider(width: 16),

// // // // // // //               // Replace profile image button
// // // // // // //               IconButton(
// // // // // // //                 icon: const Icon(Icons.photo_camera, color: Colors.deepPurple),
// // // // // // //                 onPressed: () async {
// // // // // // //                   try {
// // // // // // //                     final XFile? image = await _picker.pickImage(
// // // // // // //                       source: ImageSource.gallery,
// // // // // // //                     );
// // // // // // //                     if (image != null) {
// // // // // // //                       final bytes = await image.readAsBytes();
// // // // // // //                       setState(() {
// // // // // // //                         _profileImageBytes = bytes;
// // // // // // //                       });
// // // // // // //                       ScaffoldMessenger.of(context).showSnackBar(
// // // // // // //                         const SnackBar(
// // // // // // //                           content: Text('Profile image updated!'),
// // // // // // //                           backgroundColor: Colors.green,
// // // // // // //                           duration: Duration(seconds: 2),
// // // // // // //                         ),
// // // // // // //                       );
// // // // // // //                     }
// // // // // // //                   } catch (e) {
// // // // // // //                     ScaffoldMessenger.of(context).showSnackBar(
// // // // // // //                       SnackBar(
// // // // // // //                         content: Text('Error updating profile image: $e'),
// // // // // // //                         backgroundColor: Colors.red,
// // // // // // //                       ),
// // // // // // //                     );
// // // // // // //                   }
// // // // // // //                 },
// // // // // // //                 tooltip: 'Replace Profile Image',
// // // // // // //               ),

// // // // // // //               // Delete profile image button
// // // // // // //               IconButton(
// // // // // // //                 icon: const Icon(Icons.delete, color: Colors.red),
// // // // // // //                 onPressed: () {
// // // // // // //                   showDialog(
// // // // // // //                     context: context,
// // // // // // //                     builder: (context) => AlertDialog(
// // // // // // //                       title: const Text('Delete Profile Image'),
// // // // // // //                       content: const Text(
// // // // // // //                         'Are you sure you want to delete the profile image?',
// // // // // // //                       ),
// // // // // // //                       actions: [
// // // // // // //                         TextButton(
// // // // // // //                           onPressed: () => Navigator.pop(context),
// // // // // // //                           child: const Text('Cancel'),
// // // // // // //                         ),
// // // // // // //                         TextButton(
// // // // // // //                           onPressed: () {
// // // // // // //                             Navigator.pop(context);
// // // // // // //                             _deleteSelectedElement();
// // // // // // //                           },
// // // // // // //                           style: TextButton.styleFrom(
// // // // // // //                             foregroundColor: Colors.red,
// // // // // // //                           ),
// // // // // // //                           child: const Text('Delete'),
// // // // // // //                         ),
// // // // // // //                       ],
// // // // // // //                     ),
// // // // // // //                   );
// // // // // // //                 },
// // // // // // //                 tooltip: 'Delete Profile Image',
// // // // // // //               ),
// // // // // // //             ],
// // // // // // //           ],
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   @override
// // // // // // //   Widget build(BuildContext context) {
// // // // // // //     final screenSize = MediaQuery.of(context).size;

// // // // // // //     if (_template != null && _scaleFactor == 1.0) {
// // // // // // //       _calculateScaleFactor(screenSize);
// // // // // // //     }

// // // // // // //     void _showEditDialog({
// // // // // // //       required String title,
// // // // // // //       required String currentValue,
// // // // // // //       required IconData icon,
// // // // // // //       TextInputType keyboardType = TextInputType.text,
// // // // // // //       required Function(String) onSave,
// // // // // // //     }) {
// // // // // // //       final controller = TextEditingController(text: currentValue);

// // // // // // //       showDialog(
// // // // // // //         context: context,
// // // // // // //         builder: (context) => AlertDialog(
// // // // // // //           title: Row(
// // // // // // //             children: [
// // // // // // //               Icon(icon, color: Colors.deepPurple),
// // // // // // //               const SizedBox(width: 12),
// // // // // // //               Text(title),
// // // // // // //             ],
// // // // // // //           ),
// // // // // // //           content: TextField(
// // // // // // //             controller: controller,
// // // // // // //             keyboardType: keyboardType,
// // // // // // //             maxLines: keyboardType == TextInputType.phone ? 1 : null,
// // // // // // //             autofocus: true,
// // // // // // //             decoration: InputDecoration(
// // // // // // //               hintText: keyboardType == TextInputType.phone
// // // // // // //                   ? 'Enter phone...'
// // // // // // //                   : 'Enter business name...',
// // // // // // //               border: const OutlineInputBorder(),
// // // // // // //               prefixIcon: Icon(icon),
// // // // // // //               counterText: '',
// // // // // // //             ),
// // // // // // //             maxLength: keyboardType == TextInputType.phone ? 15 : 50,
// // // // // // //           ),
// // // // // // //           // actions: [
// // // // // // //           //   TextButton(
// // // // // // //           //     onPressed: () => Navigator.pop(context),
// // // // // // //           //     child: const Text('Cancel'),
// // // // // // //           //   ),
// // // // // // //           //   ElevatedButton(
// // // // // // //           //     onPressed: () {
// // // // // // //           //       if (controller.text.isNotEmpty) {
// // // // // // //           //         onSave(controller.text);
// // // // // // //           //         Navigator.pop(context);
// // // // // // //           //         ScaffoldMessenger.of(context).showSnackBar(
// // // // // // //           //           SnackBar(
// // // // // // //           //             content: Text('$title updated successfully!'),
// // // // // // //           //             backgroundColor: Colors.green,
// // // // // // //           //             duration: const Duration(seconds: 2),
// // // // // // //           //           ),
// // // // // // //           //         );
// // // // // // //           //       } else {
// // // // // // //           //         ScaffoldMessenger.of(context).showSnackBar(
// // // // // // //           //           const SnackBar(
// // // // // // //           //             content: Text('Value cannot be empty!'),
// // // // // // //           //             backgroundColor: Colors.red,
// // // // // // //           //             duration: Duration(seconds: 2),
// // // // // // //           //           ),
// // // // // // //           //         );
// // // // // // //           //       }
// // // // // // //           //     },
// // // // // // //           //     style: ElevatedButton.styleFrom(
// // // // // // //           //       backgroundColor: Colors.deepPurple,
// // // // // // //           //       foregroundColor: Colors.white,
// // // // // // //           //     ),
// // // // // // //           //     child: const Text('Save'),
// // // // // // //           //   ),
// // // // // // //           // ],


// // // // // // //           actions: [
// // // // // // //   TextButton(
// // // // // // //     onPressed: () => Navigator.pop(context),
// // // // // // //     child: const Text('Cancel'),
// // // // // // //   ),
// // // // // // //   ElevatedButton(
// // // // // // //     onPressed: () {
// // // // // // //       onSave(controller.text);
// // // // // // //       Navigator.pop(context);

// // // // // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // // // // //         SnackBar(
// // // // // // //           content: Text('$title updated successfully!'),
// // // // // // //           backgroundColor: Colors.green,
// // // // // // //           duration: const Duration(seconds: 2),
// // // // // // //         ),
// // // // // // //       );
// // // // // // //     },
// // // // // // //     style: ElevatedButton.styleFrom(
// // // // // // //       backgroundColor: Colors.deepPurple,
// // // // // // //       foregroundColor: Colors.white,
// // // // // // //     ),
// // // // // // //     child: const Text('Save'),
// // // // // // //   ),
// // // // // // // ],
// // // // // // //         ),
// // // // // // //       );
// // // // // // //     }

// // // // // // //     void _showBottomInfoEditOptions() {
// // // // // // //       showModalBottomSheet(
// // // // // // //         context: context,
// // // // // // //         backgroundColor: Colors.transparent,
// // // // // // //         isScrollControlled: true,
// // // // // // //         builder: (context) => StatefulBuilder(
// // // // // // //           builder: (context, setModalState) => Container(
// // // // // // //             decoration: const BoxDecoration(
// // // // // // //               color: Colors.white,
// // // // // // //               borderRadius: BorderRadius.only(
// // // // // // //                 topLeft: Radius.circular(20),
// // // // // // //                 topRight: Radius.circular(20),
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //             child: Column(
// // // // // // //               mainAxisSize: MainAxisSize.min,
// // // // // // //               children: [
// // // // // // //                 Container(
// // // // // // //                   width: 40,
// // // // // // //                   height: 4,
// // // // // // //                   margin: const EdgeInsets.only(top: 12, bottom: 20),
// // // // // // //                   decoration: BoxDecoration(
// // // // // // //                     color: Colors.grey[300],
// // // // // // //                     borderRadius: BorderRadius.circular(2),
// // // // // // //                   ),
// // // // // // //                 ),

// // // // // // //                 // Business Name Edit
// // // // // // //                 ListTile(
// // // // // // //                   leading: Container(
// // // // // // //                     padding: const EdgeInsets.all(8),
// // // // // // //                     decoration: BoxDecoration(
// // // // // // //                       color: Colors.purple.shade50,
// // // // // // //                       borderRadius: BorderRadius.circular(8),
// // // // // // //                     ),
// // // // // // //                     child: Icon(Icons.business, color: Colors.purple.shade700),
// // // // // // //                   ),
// // // // // // //                   title: const Text(
// // // // // // //                     'Edit Business Name',
// // // // // // //                     style: TextStyle(fontWeight: FontWeight.w600),
// // // // // // //                   ),
// // // // // // //                   trailing: const Icon(Icons.arrow_forward_ios, size: 16),
// // // // // // //                   onTap: () {
// // // // // // //                     Navigator.pop(context);
// // // // // // //                     final nameElement = _template?.textElements.firstWhere(
// // // // // // //                       (e) => e.id == 'name',
// // // // // // //                       orElse: () => TextElement(
// // // // // // //                         id: 'name',
// // // // // // //                         text: 'Business Name',
// // // // // // //                         x: 0,
// // // // // // //                         y: 0,
// // // // // // //                       ),
// // // // // // //                     );

// // // // // // //                     if (nameElement != null) {
// // // // // // //                       _showEditDialog(
// // // // // // //                         title: 'Edit  Name',
// // // // // // //                         currentValue: nameElement.text,
// // // // // // //                         icon: Icons.business,
// // // // // // //                         onSave: (newValue) {
// // // // // // //                           setState(() {
// // // // // // //                             nameElement.text = newValue;
// // // // // // //                           });
// // // // // // //                         },
// // // // // // //                       );
// // // // // // //                     }
// // // // // // //                   },
// // // // // // //                 ),

// // // // // // //                 // Business Name Size Slider
// // // // // // //                 Padding(
// // // // // // //                   padding: const EdgeInsets.symmetric(
// // // // // // //                     horizontal: 16,
// // // // // // //                     vertical: 8,
// // // // // // //                   ),
// // // // // // //                   child: Row(
// // // // // // //                     children: [
// // // // // // //                       Container(
// // // // // // //                         padding: const EdgeInsets.all(8),
// // // // // // //                         decoration: BoxDecoration(
// // // // // // //                           color: Colors.purple.shade50,
// // // // // // //                           borderRadius: BorderRadius.circular(8),
// // // // // // //                         ),
// // // // // // //                         child: Icon(
// // // // // // //                           Icons.text_fields,
// // // // // // //                           color: Colors.purple.shade700,
// // // // // // //                           size: 20,
// // // // // // //                         ),
// // // // // // //                       ),
// // // // // // //                       const SizedBox(width: 12),
// // // // // // //                       const Text(
// // // // // // //                         'Name Size: ',
// // // // // // //                         style: TextStyle(fontWeight: FontWeight.w600),
// // // // // // //                       ),
// // // // // // //                       Expanded(
// // // // // // //                         child: Slider(
// // // // // // //                           value: _businessNameFontSize,
// // // // // // //                           min: 12.0,
// // // // // // //                           max: 40.0,
// // // // // // //                           divisions: 28,
// // // // // // //                           label: '${_businessNameFontSize.round()}',
// // // // // // //                           activeColor: Colors.purple.shade700,
// // // // // // //                           onChanged: (value) {
// // // // // // //                             setState(() {
// // // // // // //                               _businessNameFontSize = value;
// // // // // // //                             });
// // // // // // //                             setModalState(() {});
// // // // // // //                           },
// // // // // // //                         ),
// // // // // // //                       ),
// // // // // // //                       Container(
// // // // // // //                         padding: const EdgeInsets.symmetric(
// // // // // // //                           horizontal: 8,
// // // // // // //                           vertical: 4,
// // // // // // //                         ),
// // // // // // //                         decoration: BoxDecoration(
// // // // // // //                           color: Colors.purple.shade100,
// // // // // // //                           borderRadius: BorderRadius.circular(4),
// // // // // // //                         ),
// // // // // // //                         child: Text(
// // // // // // //                           '${_businessNameFontSize.round()}',
// // // // // // //                           style: TextStyle(
// // // // // // //                             fontWeight: FontWeight.bold,
// // // // // // //                             color: Colors.purple.shade900,
// // // // // // //                           ),
// // // // // // //                         ),
// // // // // // //                       ),
// // // // // // //                     ],
// // // // // // //                   ),
// // // // // // //                 ),

// // // // // // //                 const Divider(height: 1),

// // // // // // //                 // Phone Number Edit
// // // // // // //                 ListTile(
// // // // // // //                   leading: Container(
// // // // // // //                     padding: const EdgeInsets.all(8),
// // // // // // //                     decoration: BoxDecoration(
// // // // // // //                       color: Colors.blue.shade50,
// // // // // // //                       borderRadius: BorderRadius.circular(8),
// // // // // // //                     ),
// // // // // // //                     child: Icon(Icons.phone, color: Colors.blue.shade700),
// // // // // // //                   ),
// // // // // // //                   title: const Text(
// // // // // // //                     'Edit Phone Number',
// // // // // // //                     style: TextStyle(fontWeight: FontWeight.w600),
// // // // // // //                   ),
// // // // // // //                   trailing: const Icon(Icons.arrow_forward_ios, size: 16),
// // // // // // //                   onTap: () {
// // // // // // //                     Navigator.pop(context);
// // // // // // //                     final mobileElement = _template?.textElements.firstWhere(
// // // // // // //                       (e) => e.id == 'mobile',
// // // // // // //                       orElse: () => TextElement(
// // // // // // //                         id: 'mobile',
// // // // // // //                         text: phoneNumber ?? 'Not Set',
// // // // // // //                         x: 0,
// // // // // // //                         y: 0,
// // // // // // //                       ),
// // // // // // //                     );

// // // // // // //                     if (mobileElement != null) {
// // // // // // //                       _showEditDialog(
// // // // // // //                         title: 'Edit  Number',
// // // // // // //                         currentValue: mobileElement.text,
// // // // // // //                         icon: Icons.phone,
// // // // // // //                         keyboardType: TextInputType.phone,
// // // // // // //                         onSave: (newValue) {
// // // // // // //                           setState(() {
// // // // // // //                             mobileElement.text = newValue;
// // // // // // //                             phoneNumber = newValue;
// // // // // // //                           });
// // // // // // //                         },
// // // // // // //                       );
// // // // // // //                     }
// // // // // // //                   },
// // // // // // //                 ),

// // // // // // //                 // Phone Number Size Slider
// // // // // // //                 Padding(
// // // // // // //                   padding: const EdgeInsets.symmetric(
// // // // // // //                     horizontal: 16,
// // // // // // //                     vertical: 8,
// // // // // // //                   ),
// // // // // // //                   child: Row(
// // // // // // //                     children: [
// // // // // // //                       Container(
// // // // // // //                         padding: const EdgeInsets.all(8),
// // // // // // //                         decoration: BoxDecoration(
// // // // // // //                           color: Colors.blue.shade50,
// // // // // // //                           borderRadius: BorderRadius.circular(8),
// // // // // // //                         ),
// // // // // // //                         child: Icon(
// // // // // // //                           Icons.text_fields,
// // // // // // //                           color: Colors.blue.shade700,
// // // // // // //                           size: 20,
// // // // // // //                         ),
// // // // // // //                       ),
// // // // // // //                       const SizedBox(width: 12),
// // // // // // //                       const Text(
// // // // // // //                         'Phone Size: ',
// // // // // // //                         style: TextStyle(fontWeight: FontWeight.w600),
// // // // // // //                       ),
// // // // // // //                       Expanded(
// // // // // // //                         child: Slider(
// // // // // // //                           value: _phoneNumberFontSize,
// // // // // // //                           min: 12.0,
// // // // // // //                           max: 40.0,
// // // // // // //                           divisions: 28,
// // // // // // //                           label: '${_phoneNumberFontSize.round()}',
// // // // // // //                           activeColor: Colors.blue.shade700,
// // // // // // //                           onChanged: (value) {
// // // // // // //                             setState(() {
// // // // // // //                               _phoneNumberFontSize = value;
// // // // // // //                             });
// // // // // // //                             setModalState(() {});
// // // // // // //                           },
// // // // // // //                         ),
// // // // // // //                       ),
// // // // // // //                       Container(
// // // // // // //                         padding: const EdgeInsets.symmetric(
// // // // // // //                           horizontal: 8,
// // // // // // //                           vertical: 4,
// // // // // // //                         ),
// // // // // // //                         decoration: BoxDecoration(
// // // // // // //                           color: Colors.blue.shade100,
// // // // // // //                           borderRadius: BorderRadius.circular(4),
// // // // // // //                         ),
// // // // // // //                         child: Text(
// // // // // // //                           '${_phoneNumberFontSize.round()}',
// // // // // // //                           style: TextStyle(
// // // // // // //                             fontWeight: FontWeight.bold,
// // // // // // //                             color: Colors.blue.shade900,
// // // // // // //                           ),
// // // // // // //                         ),
// // // // // // //                       ),
// // // // // // //                     ],
// // // // // // //                   ),
// // // // // // //                 ),

// // // // // // //                 const SizedBox(height: 20),
// // // // // // //               ],
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //         ),
// // // // // // //       );
// // // // // // //     }

// // // // // // //     return Scaffold(
// // // // // // //       appBar: // In your build method, in the AppBar actions section, update this:
// // // // // // //       AppBar(
// // // // // // //         leading: IconButton(
// // // // // // //           onPressed: () {
// // // // // // //             Navigator.of(context).pop();
// // // // // // //           },
// // // // // // //           icon: Icon(Icons.arrow_back_ios, color: Colors.white),
// // // // // // //         ),
// // // // // // //         // title: Text(_template?.name ?? 'Poster Editor'),
// // // // // // //         backgroundColor: Colors.purple.shade300,
// // // // // // //         foregroundColor: Colors.white,
// // // // // // //         actions: [
// // // // // // //           IconButton(
// // // // // // //             icon: const Icon(Icons.font_download, color: Colors.white),
// // // // // // //             onPressed: _addNewTextElement,
// // // // // // //             tooltip: 'Add Text',
// // // // // // //           ),
// // // // // // //           IconButton(
// // // // // // //             icon: const Icon(Icons.cloud_upload, color: Colors.white),
// // // // // // //             onPressed: _pickAdditionalImage,
// // // // // // //             tooltip: 'Add Image',
// // // // // // //           ),
// // // // // // //           TextButton(
// // // // // // //             onPressed: _pickLogoImage,
// // // // // // //             child: const AppText("logo", style: TextStyle(color: Colors.white)),
// // // // // // //           ),
// // // // // // //           // CHANGE THIS CONDITION:
// // // // // // //           if (_selectedTextElement != null ||
// // // // // // //               _selectedImageElement != null ||
// // // // // // //               _selectedProfileImageElement != null) // <- ADD THIS LINE
// // // // // // //             IconButton(
// // // // // // //               icon: const Icon(Icons.delete_outline, color: Colors.red),
// // // // // // //               onPressed: _deleteSelectedElement,
// // // // // // //               tooltip: 'Delete Selected',
// // // // // // //             ),

// // // // // // //           // IconButton(
// // // // // // //           //   icon: const Icon(Icons.refresh),
// // // // // // //           //   onPressed: _loadPosterFromApi,
// // // // // // //           //   tooltip: 'Reload Poster',
// // // // // // //           // ),
// // // // // // //           // PopupMenuButton(
// // // // // // //           //   icon: const Icon(Icons.more_vert, color: Colors.white),
// // // // // // //           //   itemBuilder: (context) => [
// // // // // // //           //     const PopupMenuItem(
// // // // // // //           //       value: 'image',
// // // // // // //           //       child: Row(
// // // // // // //           //         children: [
// // // // // // //           //           Icon(Icons.image, color: Colors.black),
// // // // // // //           //           SizedBox(width: 8),
// // // // // // //           //           Text('Save Poster'),
// // // // // // //           //         ],
// // // // // // //           //       ),
// // // // // // //           //     ),
// // // // // // //           //     const PopupMenuItem(
// // // // // // //           //       value: 'share',
// // // // // // //           //       child: Row(
// // // // // // //           //         children: [
// // // // // // //           //           Icon(Icons.share, color: Colors.black),
// // // // // // //           //           SizedBox(width: 8),
// // // // // // //           //           Text('Share Poster'),
// // // // // // //           //         ],
// // // // // // //           //       ),
// // // // // // //           //     ),
// // // // // // //           //   ],
// // // // // // //           //   onSelected: (value) {
// // // // // // //           //     if (value == 'image') {
// // // // // // //           //       savePoster();
// // // // // // //           //     } else if (value == 'share') {
// // // // // // //           //       _sharePoster();
// // // // // // //           //     }
// // // // // // //           //   },
// // // // // // //           // ),
// // // // // // //           PopupMenuButton(
// // // // // // //             icon: const Icon(Icons.more_vert, color: Colors.white),
// // // // // // //             itemBuilder: (context) => [
// // // // // // //               const PopupMenuItem(
// // // // // // //                 value: 'image',
// // // // // // //                 child: Row(
// // // // // // //                   children: [
// // // // // // //                     Icon(Icons.image, color: Colors.black),
// // // // // // //                     SizedBox(width: 8),
// // // // // // //                     AppText('save_poster'),
// // // // // // //                   ],
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //               const PopupMenuItem(
// // // // // // //                 value: 'share',
// // // // // // //                 child: Row(
// // // // // // //                   children: [
// // // // // // //                     Icon(Icons.share, color: Colors.black),
// // // // // // //                     SizedBox(width: 8),
// // // // // // //                     AppText('share_poster'),
// // // // // // //                   ],
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //               const PopupMenuItem(
// // // // // // //                 value: 'share_customers',
// // // // // // //                 child: Row(
// // // // // // //                   children: [
// // // // // // //                     Icon(Icons.people, color: Colors.deepPurple),
// // // // // // //                     SizedBox(width: 8),
// // // // // // //                     AppText('share_to_customers'),
// // // // // // //                   ],
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //             ],
// // // // // // //             onSelected: (value) {
// // // // // // //               if (value == 'image') {
// // // // // // //                 savePoster();
// // // // // // //               } else if (value == 'share') {
// // // // // // //                 _sharePoster();
// // // // // // //               } else if (value == 'share_customers') {
// // // // // // //                 _showCustomerSelectionDialog();
// // // // // // //               }
// // // // // // //             },
// // // // // // //           ),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //       body: _isLoading
// // // // // // //           ? const Center(
// // // // // // //               child: Column(
// // // // // // //                 mainAxisAlignment: MainAxisAlignment.center,
// // // // // // //                 children: [
// // // // // // //                   CircularProgressIndicator(),
// // // // // // //                   SizedBox(height: 16),
// // // // // // //                   Text('Loading poster...'),
// // // // // // //                 ],
// // // // // // //               ),
// // // // // // //             )
// // // // // // //           : _errorMessage != null
// // // // // // //           ? Center(
// // // // // // //               child: Padding(
// // // // // // //                 padding: const EdgeInsets.all(16.0),
// // // // // // //                 child: Column(
// // // // // // //                   mainAxisAlignment: MainAxisAlignment.center,
// // // // // // //                   children: [
// // // // // // //                     const Icon(Icons.error, size: 64, color: Colors.red),
// // // // // // //                     const SizedBox(height: 16),
// // // // // // //                     Text(
// // // // // // //                       _errorMessage!,
// // // // // // //                       style: const TextStyle(color: Colors.red, fontSize: 16),
// // // // // // //                       textAlign: TextAlign.center,
// // // // // // //                     ),
// // // // // // //                     const SizedBox(height: 24),
// // // // // // //                     ElevatedButton.icon(
// // // // // // //                       onPressed: _loadPosterFromApi,
// // // // // // //                       icon: const Icon(Icons.refresh),
// // // // // // //                       label: const Text('Retry'),
// // // // // // //                       style: ElevatedButton.styleFrom(
// // // // // // //                         backgroundColor: Colors.deepPurple,
// // // // // // //                         foregroundColor: Colors.white,
// // // // // // //                       ),
// // // // // // //                     ),
// // // // // // //                   ],
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //             )
// // // // // // //           : _template == null
// // // // // // //           ? const Center(child: Text("No poster data available"))
// // // // // // //           : Column(
// // // // // // //               children: [
// // // // // // //                 if (_showToolbar &&
// // // // // // //                     (_selectedTextElement != null ||
// // // // // // //                         _selectedImageElement != null))
// // // // // // //                   _buildToolbar(),

// // // // // // //                 Expanded(
// // // // // // //                   child: GestureDetector(
// // // // // // //                     onScaleStart: (details) {
// // // // // // //                       _focusPoint = details.focalPoint;
// // // // // // //                       _previousScale = _currentScale;
// // // // // // //                       _startOffset = _currentOffset;
// // // // // // //                     },
// // // // // // //                     onScaleUpdate: (details) {
// // // // // // //                       setState(() {
// // // // // // //                         // Handle scaling
// // // // // // //                         if (details.scale != 1.0) {
// // // // // // //                           _currentScale = (_previousScale * details.scale)
// // // // // // //                               .clamp(0.5, 3.0);
// // // // // // //                         }

// // // // // // //                         // Handle panning - this is the key fix
// // // // // // //                         if (details.scale == 1.0) {
// // // // // // //                           // Pure panning (no scaling)
// // // // // // //                           final delta = details.focalPoint - _focusPoint;
// // // // // // //                           _currentOffset = _startOffset + delta;
// // // // // // //                         } else {
// // // // // // //                           // Scaling with panning adjustment
// // // // // // //                           // When scaling, we need to adjust the offset to keep the focal point stable
// // // // // // //                           final focalPointDelta =
// // // // // // //                               details.focalPoint - _focusPoint;
// // // // // // //                           _currentOffset = _startOffset + focalPointDelta;
// // // // // // //                         }
// // // // // // //                       });
// // // // // // //                     },
// // // // // // //                     onScaleEnd: (details) {
// // // // // // //                       _previousScale = _currentScale;
// // // // // // //                       _startOffset = _currentOffset;
// // // // // // //                     },
// // // // // // //                     onTap: _deselectAll,
// // // // // // //                     child: Transform(
// // // // // // //                       transform: Matrix4.identity()
// // // // // // //                         ..translate(_currentOffset.dx, _currentOffset.dy)
// // // // // // //                         ..scale(_currentScale),
// // // // // // //                       child: Center(
// // // // // // //                         child: SingleChildScrollView(
// // // // // // //                           scrollDirection: Axis.vertical,
// // // // // // //                           child: SingleChildScrollView(
// // // // // // //                             scrollDirection: Axis.horizontal,
// // // // // // //                             child: RepaintBoundary(
// // // // // // //                               key: _canvasKey,
// // // // // // //                               child: Container(
// // // // // // //                                 constraints: BoxConstraints(
// // // // // // //                                   maxWidth:
// // // // // // //                                       MediaQuery.of(context).size.width * 0.9,
// // // // // // //                                   maxHeight:
// // // // // // //                                       MediaQuery.of(context).size.height * 0.8,
// // // // // // //                                 ),
// // // // // // //                                 child: FittedBox(
// // // // // // //                                   fit: BoxFit.contain,
// // // // // // //                                   child: Container(
// // // // // // //                                     width: _template!.width,
// // // // // // //                                     height: _template!.height,
// // // // // // //                                     decoration: BoxDecoration(
// // // // // // //                                       color: _template!.backgroundColor,
// // // // // // //                                       boxShadow: [
// // // // // // //                                         BoxShadow(
// // // // // // //                                           color: Colors.black.withOpacity(0.2),
// // // // // // //                                           blurRadius: 10,
// // // // // // //                                           offset: const Offset(0, 5),
// // // // // // //                                         ),
// // // // // // //                                       ],
// // // // // // //                                     ),
// // // // // // //                                     child: Stack(
// // // // // // //                                       clipBehavior: Clip.hardEdge,
// // // // // // //                                       children: [
// // // // // // //                                         if (_template!.backgroundImage != null)
// // // // // // //                                           Positioned.fill(
// // // // // // //                                             child: Image.network(
// // // // // // //                                               _template!.backgroundImage!,
// // // // // // //                                               fit: BoxFit.fill,
// // // // // // //                                               loadingBuilder: (context, child, loadingProgress) {
// // // // // // //                                                 if (loadingProgress == null)
// // // // // // //                                                   return child;
// // // // // // //                                                 return Container(
// // // // // // //                                                   color: Colors.grey[200],
// // // // // // //                                                   child: Center(
// // // // // // //                                                     child: Column(
// // // // // // //                                                       mainAxisAlignment:
// // // // // // //                                                           MainAxisAlignment
// // // // // // //                                                               .center,
// // // // // // //                                                       children: [
// // // // // // //                                                         CircularProgressIndicator(
// // // // // // //                                                           value:
// // // // // // //                                                               loadingProgress
// // // // // // //                                                                       .expectedTotalBytes !=
// // // // // // //                                                                   null
// // // // // // //                                                               ? loadingProgress
// // // // // // //                                                                         .cumulativeBytesLoaded /
// // // // // // //                                                                     loadingProgress
// // // // // // //                                                                         .expectedTotalBytes!
// // // // // // //                                                               : null,
// // // // // // //                                                         ),
// // // // // // //                                                         const SizedBox(
// // // // // // //                                                           height: 8,
// // // // // // //                                                         ),
// // // // // // //                                                         const Text(
// // // // // // //                                                           'Loading background...',
// // // // // // //                                                         ),
// // // // // // //                                                       ],
// // // // // // //                                                     ),
// // // // // // //                                                   ),
// // // // // // //                                                 );
// // // // // // //                                               },
// // // // // // //                                               errorBuilder:
// // // // // // //                                                   (context, error, stackTrace) {
// // // // // // //                                                     return Container(
// // // // // // //                                                       color: _template!
// // // // // // //                                                           .backgroundColor,
// // // // // // //                                                       child: const Center(
// // // // // // //                                                         child: Column(
// // // // // // //                                                           mainAxisAlignment:
// // // // // // //                                                               MainAxisAlignment
// // // // // // //                                                                   .center,
// // // // // // //                                                           children: [
// // // // // // //                                                             // Icon(
// // // // // // //                                                             //   Icons.error,
// // // // // // //                                                             //   size: 48,
// // // // // // //                                                             //   color: Colors.red,
// // // // // // //                                                             // ),
// // // // // // //                                                             SizedBox(height: 8),
// // // // // // //                                                             Text(
// // // // // // //                                                               'Failed to load background',
// // // // // // //                                                             ),
// // // // // // //                                                           ],
// // // // // // //                                                         ),
// // // // // // //                                                       ),
// // // // // // //                                                     );
// // // // // // //                                                   },
// // // // // // //                                             ),
// // // // // // //                                           ),
// // // // // // //                                         ..._template!.textElements.map(
// // // // // // //                                           (element) =>
// // // // // // //                                               _buildTextElement(element),
// // // // // // //                                         ),
// // // // // // //                                         ..._template!.imageElements.map(
// // // // // // //                                           (element) =>
// // // // // // //                                               _buildImageElement(element),
// // // // // // //                                         ),
// // // // // // //                                         if (_profileImageBytes != null &&
// // // // // // //                                             _profileImageElement != null)
// // // // // // //                                           _buildProfileImage(),
// // // // // // //                                         if (_logoImage != null &&
// // // // // // //                                             _logoImageElement != null)
// // // // // // //                                           _buildLogoImage(),

// // // // // // //                                         // Business Info Bar at Bottom of Poster
// // // // // // //                                         Positioned(
// // // // // // //                                           left: 0,
// // // // // // //                                           right: 0,
// // // // // // //                                           bottom: 0,
// // // // // // //                                           child: GestureDetector(
// // // // // // //                                             onTap: () {
// // // // // // //                                               // Show options to edit business name or phone
// // // // // // //                                               _showBottomInfoEditOptions();
// // // // // // //                                             },
// // // // // // //                                             child: Container(
// // // // // // //                                               padding:
// // // // // // //                                                   const EdgeInsets.symmetric(
// // // // // // //                                                     horizontal: 20,
// // // // // // //                                                     vertical: 15,
// // // // // // //                                                   ),
// // // // // // //                                               decoration: BoxDecoration(
// // // // // // //                                                 gradient: LinearGradient(
// // // // // // //                                                   colors: [
// // // // // // //                                                     Colors.black.withOpacity(
// // // // // // //                                                       0.8,
// // // // // // //                                                     ),
// // // // // // //                                                     Colors.black.withOpacity(
// // // // // // //                                                       0.9,
// // // // // // //                                                     ),
// // // // // // //                                                   ],
// // // // // // //                                                   begin: Alignment.topCenter,
// // // // // // //                                                   end: Alignment.bottomCenter,
// // // // // // //                                                 ),
// // // // // // //                                                 border: Border(
// // // // // // //                                                   top: BorderSide(
// // // // // // //                                                     color: Colors.white
// // // // // // //                                                         .withOpacity(0.3),
// // // // // // //                                                     width: 1,
// // // // // // //                                                   ),
// // // // // // //                                                 ),
// // // // // // //                                               ),
// // // // // // //                                               child: Row(
// // // // // // //                                                 children: [
// // // // // // //                                                   // Business Name Section
// // // // // // //                                                   Expanded(
// // // // // // //                                                     child: GestureDetector(
// // // // // // //                                                       onTap: () {
// // // // // // //                                                         final nameElement = _template
// // // // // // //                                                             ?.textElements
// // // // // // //                                                             .firstWhere(
// // // // // // //                                                               (e) =>
// // // // // // //                                                                   e.id ==
// // // // // // //                                                                   'name',
// // // // // // //                                                               orElse: () =>
// // // // // // //                                                                   TextElement(
// // // // // // //                                                                     id: 'name',
// // // // // // //                                                                     text:
// // // // // // //                                                                         'Business Name',
// // // // // // //                                                                     x: 0,
// // // // // // //                                                                     y: 0,
// // // // // // //                                                                   ),
// // // // // // //                                                             );

// // // // // // //                                                         if (nameElement !=
// // // // // // //                                                             null) {
// // // // // // //                                                           _showEditDialog(
// // // // // // //                                                             title: 'Edit  Name',
// // // // // // //                                                             currentValue:
// // // // // // //                                                                 nameElement
// // // // // // //                                                                     .text,
// // // // // // //                                                             icon:
// // // // // // //                                                                 Icons.business,
// // // // // // //                                                             // onSave: (newValue) {
// // // // // // //                                                             //   setState(() {
// // // // // // //                                                             //     nameElement
// // // // // // //                                                             //             .text =
// // // // // // //                                                             //         newValue;
// // // // // // //                                                             //   });
// // // // // // //                                                             // },

// // // // // // //                                                             onSave: (newValue) async {
// // // // // // //                                                               await _updateBusinessName(
// // // // // // //                                                                 newValue,
// // // // // // //                                                               ); // Save to SharedPreferences
// // // // // // //                                                               setState(() {
// // // // // // //                                                                 nameElement
// // // // // // //                                                                         .text =
// // // // // // //                                                                     newValue;
// // // // // // //                                                               });
// // // // // // //                                                             },
// // // // // // //                                                           );
// // // // // // //                                                         }
// // // // // // //                                                       },
// // // // // // //                                                       child: Row(
// // // // // // //                                                         children: [
// // // // // // //                                                           Container(
// // // // // // //                                                             padding:
// // // // // // //                                                                 const EdgeInsets.all(
// // // // // // //                                                                   8,
// // // // // // //                                                                 ),
// // // // // // //                                                             decoration: BoxDecoration(
// // // // // // //                                                               color: Colors
// // // // // // //                                                                   .purple
// // // // // // //                                                                   .withOpacity(
// // // // // // //                                                                     0.3,
// // // // // // //                                                                   ),
// // // // // // //                                                               borderRadius:
// // // // // // //                                                                   BorderRadius.circular(
// // // // // // //                                                                     8,
// // // // // // //                                                                   ),
// // // // // // //                                                             ),
// // // // // // //                                                             child: const Icon(
// // // // // // //                                                               Icons.business,
// // // // // // //                                                               color:
// // // // // // //                                                                   Colors.white,
// // // // // // //                                                               size: 20,
// // // // // // //                                                             ),
// // // // // // //                                                           ),
// // // // // // //                                                           const SizedBox(
// // // // // // //                                                             width: 12,
// // // // // // //                                                           ),
// // // // // // //                                                           Expanded(
// // // // // // //                                                             child: Column(
// // // // // // //                                                               crossAxisAlignment:
// // // // // // //                                                                   CrossAxisAlignment
// // // // // // //                                                                       .start,
// // // // // // //                                                               mainAxisSize:
// // // // // // //                                                                   MainAxisSize
// // // // // // //                                                                       .min,
// // // // // // //                                                               children: [
// // // // // // //                                                                 Row(
// // // // // // //                                                                   children: [
// // // // // // //                                                                     // const Text(
// // // // // // //                                                                     //   'Business',
// // // // // // //                                                                     //   style: TextStyle(
// // // // // // //                                                                     //     fontSize:
// // // // // // //                                                                     //         11,
// // // // // // //                                                                     //     color: Colors
// // // // // // //                                                                     //         .white70,
// // // // // // //                                                                     //     fontWeight:
// // // // // // //                                                                     //         FontWeight.w500,
// // // // // // //                                                                     //   ),
// // // // // // //                                                                     // ),
// // // // // // //                                                                     const SizedBox(
// // // // // // //                                                                       width: 4,
// // // // // // //                                                                     ),
// // // // // // //                                                                     // Icon(
// // // // // // //                                                                     //   Icons
// // // // // // //                                                                     //       .edit,
// // // // // // //                                                                     //   size: 14,
// // // // // // //                                                                     //   color: Colors
// // // // // // //                                                                     //       .white
// // // // // // //                                                                     //       .withOpacity(
// // // // // // //                                                                     //         0.5,
// // // // // // //                                                                     //       ),
// // // // // // //                                                                     // ),
// // // // // // //                                                                   ],
// // // // // // //                                                                 ),
// // // // // // //                                                                 const SizedBox(
// // // // // // //                                                                   height: 3,
// // // // // // //                                                                 ),
// // // // // // //                                                                 Text(
// // // // // // //                                                                   _template
// // // // // // //                                                                           ?.textElements
// // // // // // //                                                                           .firstWhere(
// // // // // // //                                                                             (
// // // // // // //                                                                               e,
// // // // // // //                                                                             ) =>
// // // // // // //                                                                                 e.id ==
// // // // // // //                                                                                 'name',
// // // // // // //                                                                             orElse: () => TextElement(
// // // // // // //                                                                               id: 'name',
// // // // // // //                                                                               text: 'Business Name',
// // // // // // //                                                                               x: 0,
// // // // // // //                                                                               y: 0,
// // // // // // //                                                                             ),
// // // // // // //                                                                           )
// // // // // // //                                                                           .text ??
// // // // // // //                                                                       'Business Name',
// // // // // // //                                                                   style: TextStyle(
// // // // // // //                                                                     fontSize:
// // // // // // //                                                                         _businessNameFontSize, // UPDATED
// // // // // // //                                                                     fontWeight:
// // // // // // //                                                                         FontWeight
// // // // // // //                                                                             .bold,
// // // // // // //                                                                     color: Colors
// // // // // // //                                                                         .white,
// // // // // // //                                                                   ),
// // // // // // //                                                                   maxLines: 1,
// // // // // // //                                                                   overflow:
// // // // // // //                                                                       TextOverflow
// // // // // // //                                                                           .ellipsis,
// // // // // // //                                                                 ),
// // // // // // //                                                               ],
// // // // // // //                                                             ),
// // // // // // //                                                           ),
// // // // // // //                                                         ],
// // // // // // //                                                       ),
// // // // // // //                                                     ),
// // // // // // //                                                   ),

// // // // // // //                                                   // Vertical Divider
// // // // // // //                                                   Container(
// // // // // // //                                                     height: 50,
// // // // // // //                                                     width: 1,
// // // // // // //                                                     margin:
// // // // // // //                                                         const EdgeInsets.symmetric(
// // // // // // //                                                           horizontal: 15,
// // // // // // //                                                         ),
// // // // // // //                                                     color: Colors.white
// // // // // // //                                                         .withOpacity(0.3),
// // // // // // //                                                   ),

// // // // // // //                                                   // Phone Number Section
// // // // // // //                                                   Expanded(
// // // // // // //                                                     child: GestureDetector(
// // // // // // //                                                       onTap: () {
// // // // // // //                                                         final mobileElement = _template
// // // // // // //                                                             ?.textElements
// // // // // // //                                                             .firstWhere(
// // // // // // //                                                               (e) =>
// // // // // // //                                                                   e.id ==
// // // // // // //                                                                   'mobile',
// // // // // // //                                                               orElse: () =>
// // // // // // //                                                                   TextElement(
// // // // // // //                                                                     id: 'mobile',
// // // // // // //                                                                     text:
// // // // // // //                                                                         phoneNumber ??
// // // // // // //                                                                         'Not Set',
// // // // // // //                                                                     x: 0,
// // // // // // //                                                                     y: 0,
// // // // // // //                                                                   ),
// // // // // // //                                                             );

// // // // // // //                                                         if (mobileElement !=
// // // // // // //                                                             null) {
// // // // // // //                                                           _showEditDialog(
// // // // // // //                                                             title:
// // // // // // //                                                                 'Edit Number',
// // // // // // //                                                             currentValue:
// // // // // // //                                                                 mobileElement
// // // // // // //                                                                     .text,
// // // // // // //                                                             icon: Icons.phone,
// // // // // // //                                                             keyboardType:
// // // // // // //                                                                 TextInputType
// // // // // // //                                                                     .phone,
// // // // // // //                                                             onSave: (newValue) {
// // // // // // //                                                               setState(() {
// // // // // // //                                                                 mobileElement
// // // // // // //                                                                         .text =
// // // // // // //                                                                     newValue;
// // // // // // //                                                                 phoneNumber =
// // // // // // //                                                                     newValue;
// // // // // // //                                                               });
// // // // // // //                                                             },
// // // // // // //                                                           );
// // // // // // //                                                         }
// // // // // // //                                                       },
// // // // // // //                                                       child: Row(
// // // // // // //                                                         children: [
// // // // // // //                                                           const SizedBox(
// // // // // // //                                                             width: 200,
// // // // // // //                                                           ),
// // // // // // //                                                           Container(
// // // // // // //                                                             padding:
// // // // // // //                                                                 const EdgeInsets.all(
// // // // // // //                                                                   8,
// // // // // // //                                                                 ),
// // // // // // //                                                             decoration: BoxDecoration(
// // // // // // //                                                               color: Colors.blue
// // // // // // //                                                                   .withOpacity(
// // // // // // //                                                                     0.3,
// // // // // // //                                                                   ),
// // // // // // //                                                               borderRadius:
// // // // // // //                                                                   BorderRadius.circular(
// // // // // // //                                                                     8,
// // // // // // //                                                                   ),
// // // // // // //                                                             ),
// // // // // // //                                                             child: const Icon(
// // // // // // //                                                               Icons.phone,
// // // // // // //                                                               color:
// // // // // // //                                                                   Colors.white,
// // // // // // //                                                               size: 20,
// // // // // // //                                                             ),
// // // // // // //                                                           ),
// // // // // // //                                                           const SizedBox(
// // // // // // //                                                             width: 12,
// // // // // // //                                                           ),
// // // // // // //                                                           Expanded(
// // // // // // //                                                             child: Column(
// // // // // // //                                                               crossAxisAlignment:
// // // // // // //                                                                   CrossAxisAlignment
// // // // // // //                                                                       .start,
// // // // // // //                                                               mainAxisSize:
// // // // // // //                                                                   MainAxisSize
// // // // // // //                                                                       .min,
// // // // // // //                                                               children: [
// // // // // // //                                                                 Row(
// // // // // // //                                                                   children: [
// // // // // // //                                                                     // const Text(
// // // // // // //                                                                     //   'Phone',
// // // // // // //                                                                     //   style: TextStyle(
// // // // // // //                                                                     //     fontSize:
// // // // // // //                                                                     //         14,
// // // // // // //                                                                     //     color: Colors
// // // // // // //                                                                     //         .white70,
// // // // // // //                                                                     //     fontWeight:
// // // // // // //                                                                     //         FontWeight.w500,
// // // // // // //                                                                     //   ),
// // // // // // //                                                                     // ),
// // // // // // //                                                                     const SizedBox(
// // // // // // //                                                                       width: 4,
// // // // // // //                                                                     ),
// // // // // // //                                                                     // Icon(
// // // // // // //                                                                     //   Icons
// // // // // // //                                                                     //       .edit,
// // // // // // //                                                                     //   size: 11,
// // // // // // //                                                                     //   color: Colors
// // // // // // //                                                                     //       .white
// // // // // // //                                                                     //       .withOpacity(
// // // // // // //                                                                     //         0.5,
// // // // // // //                                                                     //       ),
// // // // // // //                                                                     // ),
// // // // // // //                                                                   ],
// // // // // // //                                                                 ),
// // // // // // //                                                                 const SizedBox(
// // // // // // //                                                                   height: 3,
// // // // // // //                                                                 ),
// // // // // // //                                                                 Text(
// // // // // // //                                                                   phoneNumber ??
// // // // // // //                                                                       _template
// // // // // // //                                                                           ?.textElements
// // // // // // //                                                                           .firstWhere(
// // // // // // //                                                                             (
// // // // // // //                                                                               e,
// // // // // // //                                                                             ) =>
// // // // // // //                                                                                 e.id ==
// // // // // // //                                                                                 'mobile',
// // // // // // //                                                                             orElse: () => TextElement(
// // // // // // //                                                                               id: 'mobile',
// // // // // // //                                                                               text: 'Not Set',
// // // // // // //                                                                               x: 0,
// // // // // // //                                                                               y: 0,
// // // // // // //                                                                             ),
// // // // // // //                                                                           )
// // // // // // //                                                                           .text ??
// // // // // // //                                                                       'Not Set',
// // // // // // //                                                                   style: TextStyle(
// // // // // // //                                                                     fontSize:
// // // // // // //                                                                         _phoneNumberFontSize, // UPDATED
// // // // // // //                                                                     fontWeight:
// // // // // // //                                                                         FontWeight
// // // // // // //                                                                             .bold,
// // // // // // //                                                                     color: Colors
// // // // // // //                                                                         .white,
// // // // // // //                                                                   ),
// // // // // // //                                                                   maxLines: 1,
// // // // // // //                                                                   overflow:
// // // // // // //                                                                       TextOverflow
// // // // // // //                                                                           .ellipsis,
// // // // // // //                                                                 ),
// // // // // // //                                                               ],
// // // // // // //                                                             ),
// // // // // // //                                                           ),
// // // // // // //                                                         ],
// // // // // // //                                                       ),
// // // // // // //                                                     ),
// // // // // // //                                                   ),
// // // // // // //                                                 ],
// // // // // // //                                               ),
// // // // // // //                                             ),
// // // // // // //                                           ),
// // // // // // //                                         ),
// // // // // // //                                       ],
// // // // // // //                                     ),
// // // // // // //                                   ),
// // // // // // //                                 ),
// // // // // // //                               ),
// // // // // // //                             ),
// // // // // // //                           ),
// // // // // // //                         ),
// // // // // // //                       ),
// // // // // // //                     ),
// // // // // // //                   ),
// // // // // // //                 ),

// // // // // // //                 Container(
// // // // // // //                   padding: const EdgeInsets.symmetric(
// // // // // // //                     horizontal: 16,
// // // // // // //                     vertical: 8,
// // // // // // //                   ),
// // // // // // //                   color: Colors.grey[200],
// // // // // // //                   child: const Row(children: [

// // // // // // //                     ],
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //               ],
// // // // // // //             ),
// // // // // // //     );
// // // // // // //   }
// // // // // // // }

// // // // // // // // import 'dart:io';
// // // // // // // // import 'dart:math';
// // // // // // // // import 'dart:ui' as ui;
// // // // // // // // import 'dart:typed_data';
// // // // // // // // import 'dart:convert';
// // // // // // // // // import 'package:edit_ezy_project/helper/storage_helper.dart';
// // // // // // // // import 'package:ffmpeg_kit_flutter_new_min_gpl/ffmpeg_kit.dart';
// // // // // // // // import 'package:ffmpeg_kit_flutter_new_min_gpl/return_code.dart';
// // // // // // // // import 'package:flutter/material.dart';
// // // // // // // // import 'package:flutter/rendering.dart';
// // // // // // // // import 'package:flutter/services.dart';
// // // // // // // // import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// // // // // // // // import 'package:gal/gal.dart';
// // // // // // // // import 'package:image_picker/image_picker.dart';
// // // // // // // // import 'package:path_provider/path_provider.dart';
// // // // // // // // import 'package:http/http.dart' as http;
// // // // // // // // import 'package:posternova/helper/storage_helper.dart';
// // // // // // // // import 'package:posternova/providers/customer/customer_provider.dart';
// // // // // // // // import 'package:posternova/services/video_export_service.dart';
// // // // // // // // import 'package:provider/provider.dart';
// // // // // // // // import 'package:share_plus/share_plus.dart';
// // // // // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // // // // import 'package:url_launcher/url_launcher.dart';
// // // // // // // // import 'package:file_selector/file_selector.dart';
// // // // // // // // import 'package:video_player/video_player.dart';
// // // // // // // // import 'package:permission_handler/permission_handler.dart';

// // // // // // // // // Template Models
// // // // // // // // class PosterTemplate {
// // // // // // // //   String id;
// // // // // // // //   String name;
// // // // // // // //   String categoryName;
// // // // // // // //   String description;
// // // // // // // //   String title;
// // // // // // // //   String email;
// // // // // // // //   String mobile;
// // // // // // // //   double width;
// // // // // // // //   double height;
// // // // // // // //   String? backgroundImage;
// // // // // // // //   Color backgroundColor;
// // // // // // // //   List<TextElement> textElements;
// // // // // // // //   List<ImageElement> imageElements;
// // // // // // // //   DesignData designData;

// // // // // // // //   PosterTemplate({
// // // // // // // //     required this.id,
// // // // // // // //     required this.name,
// // // // // // // //     required this.categoryName,
// // // // // // // //     required this.description,
// // // // // // // //     required this.title,
// // // // // // // //     required this.email,
// // // // // // // //     required this.mobile,
// // // // // // // //     required this.width,
// // // // // // // //     required this.height,
// // // // // // // //     this.backgroundImage,
// // // // // // // //     this.backgroundColor = Colors.white,
// // // // // // // //     this.textElements = const [],
// // // // // // // //     this.imageElements = const [],
// // // // // // // //     required this.designData,
// // // // // // // //   });

// // // // // // // //   void updateWithUserData(String? userEmail, String? userMobile) {
// // // // // // // //     for (var element in textElements) {
// // // // // // // //       switch (element.id) {
// // // // // // // //         case 'email':
// // // // // // // //           if (userEmail != null && userEmail.isNotEmpty) {
// // // // // // // //             element.text = userEmail;
// // // // // // // //           }
// // // // // // // //           break;
// // // // // // // //         case 'mobile':
// // // // // // // //           if (userMobile != null && userMobile.isNotEmpty) {
// // // // // // // //             element.text = userMobile;
// // // // // // // //           }
// // // // // // // //           break;
// // // // // // // //       }
// // // // // // // //     }
// // // // // // // //   }

// // // // // // // //   factory PosterTemplate.fromApiResponse(
// // // // // // // //     Map<String, dynamic> apiResponse, {
// // // // // // // //     String? userEmail,
// // // // // // // //     String? userMobile,
// // // // // // // //   }) {
// // // // // // // //     final posterData = apiResponse['poster'] as Map<String, dynamic>;
// // // // // // // //     final designData = posterData['designData'] as Map<String, dynamic>;

// // // // // // // //     // Create text elements based on visibility
// // // // // // // //     List<TextElement> textElements = [];
// // // // // // // //     final textSettings = TextSettings.fromJson(
// // // // // // // //       designData['textSettings'] ?? {},
// // // // // // // //     );
// // // // // // // //     final textStyles = TextStyles.fromJson(designData['textStyles'] ?? {});
// // // // // // // //     final textVisibility = TextVisibility.fromJson(
// // // // // // // //       designData['textVisibility'] ?? {},
// // // // // // // //     );

// // // // // // // //     if (textVisibility.isVisible('title')) {
// // // // // // // //       textElements.add(
// // // // // // // //         TextElement(
// // // // // // // //           id: 'title',
// // // // // // // //           text: posterData['title'] as String? ?? '',
// // // // // // // //           x: textSettings.titleX,
// // // // // // // //           y: textSettings.titleY,
// // // // // // // //           width: 800,
// // // // // // // //           height: 200,
// // // // // // // //           fontSize: textStyles.title.fontSize ?? 36,
// // // // // // // //           color: textStyles.title.color ?? Colors.black,
// // // // // // // //           fontWeight: textStyles.title.fontWeight ?? FontWeight.bold,
// // // // // // // //           fontFamily: textStyles.title.fontFamily ?? 'Times New Roman',
// // // // // // // //           textAlign: TextAlign.center,
// // // // // // // //         ),
// // // // // // // //       );
// // // // // // // //     }

// // // // // // // //     if (textVisibility.isVisible('description')) {
// // // // // // // //       textElements.add(
// // // // // // // //         TextElement(
// // // // // // // //           id: 'description',
// // // // // // // //           text: posterData['description'] as String? ?? '',
// // // // // // // //           x: textSettings.descriptionX,
// // // // // // // //           y: textSettings.descriptionY,
// // // // // // // //           width: 900,
// // // // // // // //           height: 400,
// // // // // // // //           fontSize: textStyles.description.fontSize ?? 20,
// // // // // // // //           color: textStyles.description.color ?? Colors.black,
// // // // // // // //           fontWeight: textStyles.description.fontWeight ?? FontWeight.bold,
// // // // // // // //           fontFamily: textStyles.description.fontFamily ?? 'Times New Roman',
// // // // // // // //           textAlign: TextAlign.left,
// // // // // // // //         ),
// // // // // // // //       );
// // // // // // // //     }
// // // // // // // //     if (textVisibility.isVisible('name')) {
// // // // // // // //       textElements.add(
// // // // // // // //         TextElement(
// // // // // // // //           id: 'name',
// // // // // // // //           // text: posterData['name'] as String? ?? '',
// // // // // // // //           text: 'Business Name',
// // // // // // // //           x: textSettings.nameX,
// // // // // // // //           y: textSettings.nameY,
// // // // // // // //           width: 400,
// // // // // // // //           height: 100,
// // // // // // // //           // fontSize: textStyles.name.fontSize ?? 24,
// // // // // // // //           fontSize: 2,

// // // // // // // //           color: textStyles.name.color ?? Colors.black,
// // // // // // // //           fontWeight: textStyles.name.fontWeight ?? FontWeight.bold,
// // // // // // // //           fontFamily: textStyles.name.fontFamily ?? 'Arial',
// // // // // // // //           textAlign: TextAlign.left,
// // // // // // // //         ),
// // // // // // // //       );
// // // // // // // //     }

// // // // // // // //     const double canvasWidth = 720;
// // // // // // // //     // Create image elements from overlay images
// // // // // // // //     List<ImageElement> imageElements = [];
// // // // // // // //     if (designData['overlayImages'] != null) {
// // // // // // // //       final overlayImages = designData['overlayImages'] as List<dynamic>;
// // // // // // // //       final overlays =
// // // // // // // //           designData['overlaySettings']?['overlays'] as List<dynamic>? ?? [];

// // // // // // // //       for (int i = 0; i < overlayImages.length; i++) {
// // // // // // // //         final img = overlayImages[i];
// // // // // // // //         // Use overlay position if available, otherwise use default
// // // // // // // //         final overlay = i < overlays.length ? overlays[i] : null;

// // // // // // // //         imageElements.add(
// // // // // // // //           ImageElement(
// // // // // // // //             id:
// // // // // // // //                 img['_id'] ??
// // // // // // // //                 'overlay_${DateTime.now().millisecondsSinceEpoch}',
// // // // // // // //             imageUrl: img['url'] ?? '',
// // // // // // // //             x: overlay != null ? _parseDouble(overlay['x'], 324) : 324,
// // // // // // // //             y: overlay != null ? _parseDouble(overlay['y'], 521) : 521,
// // // // // // // //             width: overlay != null ? _parseDouble(overlay['width'], 252) : 252,
// // // // // // // //             height: overlay != null
// // // // // // // //                 ? _parseDouble(overlay['height'], 252)
// // // // // // // //                 : 252,
// // // // // // // //           ),
// // // // // // // //         );
// // // // // // // //       }
// // // // // // // //     }

// // // // // // // //     return PosterTemplate(
// // // // // // // //       id:
// // // // // // // //           posterData['_id'] ??
// // // // // // // //           'template_${DateTime.now().millisecondsSinceEpoch}',
// // // // // // // //       name: posterData['name'] ?? 'Untitled',
// // // // // // // //       categoryName: posterData['categoryName'] ?? '',
// // // // // // // //       description: posterData['description'] ?? '',
// // // // // // // //       title: posterData['title'] ?? '',
// // // // // // // //       email: posterData['email'] ?? '',
// // // // // // // //       mobile: posterData['mobile'] ?? '',
// // // // // // // //       width: 900, // Standard poster width
// // // // // // // //       height: 1200, // Standard poster height
// // // // // // // //       backgroundImage: designData['bgImage']?['url'],
// // // // // // // //       backgroundColor: Colors.white,
// // // // // // // //       textElements: textElements,
// // // // // // // //       imageElements: imageElements,
// // // // // // // //       designData: DesignData.fromJson(designData),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   static double _parseDouble(dynamic value, double defaultValue) {
// // // // // // // //     if (value == null) return defaultValue;
// // // // // // // //     if (value is double) return value;
// // // // // // // //     if (value is int) return value.toDouble();
// // // // // // // //     if (value is String) return double.tryParse(value) ?? defaultValue;
// // // // // // // //     return defaultValue;
// // // // // // // //   }

// // // // // // // //   Map<String, dynamic> toJson() {
// // // // // // // //     return {
// // // // // // // //       'id': id,
// // // // // // // //       'name': name,
// // // // // // // //       'categoryName': categoryName,
// // // // // // // //       'description': description,
// // // // // // // //       'title': title,
// // // // // // // //       'email': email,
// // // // // // // //       'mobile': mobile,
// // // // // // // //       'width': width,
// // // // // // // //       'height': height,
// // // // // // // //       'backgroundImage': backgroundImage,
// // // // // // // //       'backgroundColor': backgroundColor.value,
// // // // // // // //       'textElements': textElements.map((e) => e.toJson()).toList(),
// // // // // // // //       'imageElements': imageElements.map((e) => e.toJson()).toList(),
// // // // // // // //       'designData': designData.toJson(),
// // // // // // // //     };
// // // // // // // //   }
// // // // // // // // }

// // // // // // // // class DesignData {
// // // // // // // //   BgImageSettings bgImageSettings;
// // // // // // // //   OverlaySettings overlaySettings;
// // // // // // // //   TextSettings textSettings;
// // // // // // // //   TextStyles textStyles;
// // // // // // // //   TextVisibility textVisibility;
// // // // // // // //   List<OverlayImageFilter> overlayImageFilters;

// // // // // // // //   DesignData({
// // // // // // // //     required this.bgImageSettings,
// // // // // // // //     required this.overlaySettings,
// // // // // // // //     required this.textSettings,
// // // // // // // //     required this.textStyles,
// // // // // // // //     required this.textVisibility,
// // // // // // // //     required this.overlayImageFilters,
// // // // // // // //   });

// // // // // // // //   factory DesignData.fromJson(Map<String, dynamic> json) {
// // // // // // // //     return DesignData(
// // // // // // // //       bgImageSettings: BgImageSettings.fromJson(json['bgImageSettings'] ?? {}),
// // // // // // // //       overlaySettings: OverlaySettings.fromJson(json['overlaySettings'] ?? {}),
// // // // // // // //       textSettings: TextSettings.fromJson(json['textSettings'] ?? {}),
// // // // // // // //       textStyles: TextStyles.fromJson(json['textStyles'] ?? {}),
// // // // // // // //       textVisibility: TextVisibility.fromJson(json['textVisibility'] ?? {}),
// // // // // // // //       overlayImageFilters:
// // // // // // // //           (json['overlayImageFilters'] as List<dynamic>?)
// // // // // // // //               ?.map((e) => OverlayImageFilter.fromJson(e))
// // // // // // // //               .toList() ??
// // // // // // // //           [],
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   Map<String, dynamic> toJson() {
// // // // // // // //     return {
// // // // // // // //       'bgImageSettings': bgImageSettings.toJson(),
// // // // // // // //       'overlaySettings': overlaySettings.toJson(),
// // // // // // // //       'textSettings': textSettings.toJson(),
// // // // // // // //       'textStyles': textStyles.toJson(),
// // // // // // // //       'textVisibility': textVisibility.toJson(),
// // // // // // // //       'overlayImageFilters': overlayImageFilters
// // // // // // // //           .map((e) => e.toJson())
// // // // // // // //           .toList(),
// // // // // // // //     };
// // // // // // // //   }
// // // // // // // // }

// // // // // // // // class BgImageSettings {
// // // // // // // //   ImageFilters filters;

// // // // // // // //   BgImageSettings({required this.filters});

// // // // // // // //   factory BgImageSettings.fromJson(Map<String, dynamic> json) {
// // // // // // // //     return BgImageSettings(
// // // // // // // //       filters: ImageFilters.fromJson(json['filters'] ?? {}),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   Map<String, dynamic> toJson() {
// // // // // // // //     return {'filters': filters.toJson()};
// // // // // // // //   }
// // // // // // // // }

// // // // // // // // class ImageFilters {
// // // // // // // //   double brightness;
// // // // // // // //   double contrast;
// // // // // // // //   double saturation;
// // // // // // // //   double grayscale;
// // // // // // // //   double blur;

// // // // // // // //   ImageFilters({
// // // // // // // //     this.brightness = 100,
// // // // // // // //     this.contrast = 100,
// // // // // // // //     this.saturation = 100,
// // // // // // // //     this.grayscale = 0,
// // // // // // // //     this.blur = 0,
// // // // // // // //   });

// // // // // // // //   factory ImageFilters.fromJson(Map<String, dynamic> json) {
// // // // // // // //     return ImageFilters(
// // // // // // // //       brightness: _parseDouble(json['brightness'], 100),
// // // // // // // //       contrast: _parseDouble(json['contrast'], 100),
// // // // // // // //       saturation: _parseDouble(json['saturation'], 100),
// // // // // // // //       grayscale: _parseDouble(json['grayscale'], 0),
// // // // // // // //       blur: _parseDouble(json['blur'], 0),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   Map<String, dynamic> toJson() {
// // // // // // // //     return {
// // // // // // // //       'brightness': brightness,
// // // // // // // //       'contrast': contrast,
// // // // // // // //       'saturation': saturation,
// // // // // // // //       'grayscale': grayscale,
// // // // // // // //       'blur': blur,
// // // // // // // //     };
// // // // // // // //   }

// // // // // // // //   static double _parseDouble(dynamic value, double defaultValue) {
// // // // // // // //     if (value == null) return defaultValue;
// // // // // // // //     if (value is double) return value;
// // // // // // // //     if (value is int) return value.toDouble();
// // // // // // // //     if (value is String) return double.tryParse(value) ?? defaultValue;
// // // // // // // //     return defaultValue;
// // // // // // // //   }
// // // // // // // // }

// // // // // // // // class OverlaySettings {
// // // // // // // //   List<Overlay> overlays;

// // // // // // // //   OverlaySettings({required this.overlays});

// // // // // // // //   factory OverlaySettings.fromJson(Map<String, dynamic> json) {
// // // // // // // //     return OverlaySettings(
// // // // // // // //       overlays:
// // // // // // // //           (json['overlays'] as List<dynamic>?)
// // // // // // // //               ?.map((e) => Overlay.fromJson(e))
// // // // // // // //               .toList() ??
// // // // // // // //           [],
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   Map<String, dynamic> toJson() {
// // // // // // // //     return {'overlays': overlays.map((e) => e.toJson()).toList()};
// // // // // // // //   }
// // // // // // // // }

// // // // // // // // class Overlay {
// // // // // // // //   double x;
// // // // // // // //   double y;
// // // // // // // //   double width;
// // // // // // // //   double height;
// // // // // // // //   String shape;
// // // // // // // //   double borderRadius;

// // // // // // // //   Overlay({
// // // // // // // //     required this.x,
// // // // // // // //     required this.y,
// // // // // // // //     required this.width,
// // // // // // // //     required this.height,
// // // // // // // //     required this.shape,
// // // // // // // //     required this.borderRadius,
// // // // // // // //   });

// // // // // // // //   factory Overlay.fromJson(Map<String, dynamic> json) {
// // // // // // // //     return Overlay(
// // // // // // // //       x: _parseDouble(json['x'], 0),
// // // // // // // //       y: _parseDouble(json['y'], 0),
// // // // // // // //       width: _parseDouble(json['width'], 100),
// // // // // // // //       height: _parseDouble(json['height'], 100),
// // // // // // // //       shape: json['shape'] ?? 'rectangle',
// // // // // // // //       borderRadius: _parseDouble(json['borderRadius'], 0),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   Map<String, dynamic> toJson() {
// // // // // // // //     return {
// // // // // // // //       'x': x,
// // // // // // // //       'y': y,
// // // // // // // //       'width': width,
// // // // // // // //       'height': height,
// // // // // // // //       'shape': shape,
// // // // // // // //       'borderRadius': borderRadius,
// // // // // // // //     };
// // // // // // // //   }

// // // // // // // //   static double _parseDouble(dynamic value, double defaultValue) {
// // // // // // // //     if (value == null) return defaultValue;
// // // // // // // //     if (value is double) return value;
// // // // // // // //     if (value is int) return value.toDouble();
// // // // // // // //     if (value is String) return double.tryParse(value) ?? defaultValue;
// // // // // // // //     return defaultValue;
// // // // // // // //   }
// // // // // // // // }

// // // // // // // // class TextSettings {
// // // // // // // //   double nameX;
// // // // // // // //   double nameY;
// // // // // // // //   double emailX;
// // // // // // // //   double emailY;
// // // // // // // //   double mobileX;
// // // // // // // //   double mobileY;
// // // // // // // //   double titleX;
// // // // // // // //   double titleY;
// // // // // // // //   double descriptionX;
// // // // // // // //   double descriptionY;
// // // // // // // //   double tagsX;
// // // // // // // //   double tagsY;

// // // // // // // //   TextSettings({
// // // // // // // //     required this.nameX,
// // // // // // // //     required this.nameY,
// // // // // // // //     required this.emailX,
// // // // // // // //     required this.emailY,
// // // // // // // //     required this.mobileX,
// // // // // // // //     required this.mobileY,
// // // // // // // //     required this.titleX,
// // // // // // // //     required this.titleY,
// // // // // // // //     required this.descriptionX,
// // // // // // // //     required this.descriptionY,
// // // // // // // //     required this.tagsX,
// // // // // // // //     required this.tagsY,
// // // // // // // //   });

// // // // // // // //   factory TextSettings.fromJson(Map<String, dynamic> json) {
// // // // // // // //     return TextSettings(
// // // // // // // //       nameX: _parseDouble(json['nameX'], 0),
// // // // // // // //       nameY: _parseDouble(json['nameY'], 0),
// // // // // // // //       emailX: _parseDouble(json['emailX'], 0),
// // // // // // // //       emailY: _parseDouble(json['emailY'], 0),
// // // // // // // //       mobileX: _parseDouble(json['mobileX'], 0),
// // // // // // // //       mobileY: _parseDouble(json['mobileY'], 0),
// // // // // // // //       titleX: _parseDouble(json['titleX'], 0),
// // // // // // // //       titleY: _parseDouble(json['titleY'], 0),
// // // // // // // //       descriptionX: _parseDouble(json['descriptionX'], 0),
// // // // // // // //       descriptionY: _parseDouble(json['descriptionY'], 0),
// // // // // // // //       tagsX: _parseDouble(json['tagsX'], 0),
// // // // // // // //       tagsY: _parseDouble(json['tagsY'], 0),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   Map<String, dynamic> toJson() {
// // // // // // // //     return {
// // // // // // // //       'nameX': nameX,
// // // // // // // //       'nameY': nameY,
// // // // // // // //       'emailX': emailX,
// // // // // // // //       'emailY': emailY,
// // // // // // // //       'mobileX': mobileX,
// // // // // // // //       'mobileY': mobileY,
// // // // // // // //       'titleX': titleX,
// // // // // // // //       'titleY': titleY,
// // // // // // // //       'descriptionX': descriptionX,
// // // // // // // //       'descriptionY': descriptionY,
// // // // // // // //       'tagsX': tagsX,
// // // // // // // //       'tagsY': tagsY,
// // // // // // // //     };
// // // // // // // //   }

// // // // // // // //   static double _parseDouble(dynamic value, double defaultValue) {
// // // // // // // //     if (value == null) return defaultValue;
// // // // // // // //     if (value is double) return value;
// // // // // // // //     if (value is int) return value.toDouble();
// // // // // // // //     if (value is String) return double.tryParse(value) ?? defaultValue;
// // // // // // // //     return defaultValue;
// // // // // // // //   }
// // // // // // // // }

// // // // // // // // class TextStyles {
// // // // // // // //   TextStyle name;
// // // // // // // //   TextStyle email;
// // // // // // // //   TextStyle mobile;
// // // // // // // //   TextStyle title;
// // // // // // // //   TextStyle description;
// // // // // // // //   TextStyle tags;

// // // // // // // //   TextStyles({
// // // // // // // //     required this.name,
// // // // // // // //     required this.email,
// // // // // // // //     required this.mobile,
// // // // // // // //     required this.title,
// // // // // // // //     required this.description,
// // // // // // // //     required this.tags,
// // // // // // // //   });

// // // // // // // //   factory TextStyles.fromJson(Map<String, dynamic> json) {
// // // // // // // //     return TextStyles(
// // // // // // // //       name: _textStyleFromJson(json['name'] ?? {}),
// // // // // // // //       email: _textStyleFromJson(json['email'] ?? {}),
// // // // // // // //       mobile: _textStyleFromJson(json['mobile'] ?? {}),
// // // // // // // //       title: _textStyleFromJson(json['title'] ?? {}),
// // // // // // // //       description: _textStyleFromJson(json['description'] ?? {}),
// // // // // // // //       tags: _textStyleFromJson(json['tags'] ?? {}),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   Map<String, dynamic> toJson() {
// // // // // // // //     return {
// // // // // // // //       'name': _textStyleToJson(name),
// // // // // // // //       'email': _textStyleToJson(email),
// // // // // // // //       'mobile': _textStyleToJson(mobile),
// // // // // // // //       'title': _textStyleToJson(title),
// // // // // // // //       'description': _textStyleToJson(description),
// // // // // // // //       'tags': _textStyleToJson(tags),
// // // // // // // //     };
// // // // // // // //   }

// // // // // // // //   static TextStyle _textStyleFromJson(Map<String, dynamic> json) {
// // // // // // // //     return TextStyle(
// // // // // // // //       fontSize: _parseDouble(json['fontSize'], 16),
// // // // // // // //       color: _parseColor(json['color']),
// // // // // // // //       fontFamily: json['fontFamily'] ?? 'Arial',
// // // // // // // //       fontWeight: _fontWeightFromString(json['fontWeight'] ?? 'normal'),
// // // // // // // //       fontStyle: _fontStyleFromString(json['fontStyle'] ?? 'normal'),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   static Map<String, dynamic> _textStyleToJson(TextStyle style) {
// // // // // // // //     return {
// // // // // // // //       'fontSize': style.fontSize,
// // // // // // // //       'color': style.color?.value ?? 0xFF000000,
// // // // // // // //       'fontFamily': style.fontFamily,
// // // // // // // //       'fontWeight': _fontWeightToString(style.fontWeight),
// // // // // // // //       'fontStyle': _fontStyleToString(style.fontStyle),
// // // // // // // //     };
// // // // // // // //   }

// // // // // // // //   static Color _parseColor(dynamic colorValue) {
// // // // // // // //     if (colorValue == null) return Colors.black;

// // // // // // // //     if (colorValue is int) {
// // // // // // // //       return Color(colorValue);
// // // // // // // //     }

// // // // // // // //     if (colorValue is String) {
// // // // // // // //       String hexColor = colorValue.replaceAll('#', '');
// // // // // // // //       if (hexColor.length == 6) {
// // // // // // // //         hexColor = 'FF$hexColor';
// // // // // // // //       }
// // // // // // // //       int? colorInt = int.tryParse(hexColor, radix: 16);
// // // // // // // //       if (colorInt != null) {
// // // // // // // //         return Color(colorInt);
// // // // // // // //       }
// // // // // // // //     }

// // // // // // // //     return Colors.black;
// // // // // // // //   }

// // // // // // // //   static double _parseDouble(dynamic value, double defaultValue) {
// // // // // // // //     if (value == null) return defaultValue;
// // // // // // // //     if (value is double) return value;
// // // // // // // //     if (value is int) return value.toDouble();
// // // // // // // //     if (value is String) return double.tryParse(value) ?? defaultValue;
// // // // // // // //     return defaultValue;
// // // // // // // //   }

// // // // // // // //   static FontWeight _fontWeightFromString(String weight) {
// // // // // // // //     switch (weight.toLowerCase()) {
// // // // // // // //       case 'bold':
// // // // // // // //         return FontWeight.bold;
// // // // // // // //       case 'w300':
// // // // // // // //         return FontWeight.w300;
// // // // // // // //       case 'w600':
// // // // // // // //         return FontWeight.w600;
// // // // // // // //       case 'w700':
// // // // // // // //         return FontWeight.w700;
// // // // // // // //       default:
// // // // // // // //         return FontWeight.normal;
// // // // // // // //     }
// // // // // // // //   }

// // // // // // // //   static String _fontWeightToString(FontWeight? weight) {
// // // // // // // //     if (weight == FontWeight.bold) return 'bold';
// // // // // // // //     if (weight == FontWeight.w300) return 'w300';
// // // // // // // //     if (weight == FontWeight.w600) return 'w600';
// // // // // // // //     if (weight == FontWeight.w700) return 'w700';
// // // // // // // //     return 'normal';
// // // // // // // //   }

// // // // // // // //   static FontStyle _fontStyleFromString(String style) {
// // // // // // // //     return style.toLowerCase() == 'italic'
// // // // // // // //         ? FontStyle.italic
// // // // // // // //         : FontStyle.normal;
// // // // // // // //   }

// // // // // // // //   static String _fontStyleToString(FontStyle? style) {
// // // // // // // //     return style == FontStyle.italic ? 'italic' : 'normal';
// // // // // // // //   }
// // // // // // // // }

// // // // // // // // class TextVisibility {
// // // // // // // //   String name;
// // // // // // // //   String email;
// // // // // // // //   String mobile;
// // // // // // // //   String title;
// // // // // // // //   String description;
// // // // // // // //   String tags;

// // // // // // // //   TextVisibility({
// // // // // // // //     required this.name,
// // // // // // // //     required this.email,
// // // // // // // //     required this.mobile,
// // // // // // // //     required this.title,
// // // // // // // //     required this.description,
// // // // // // // //     required this.tags,
// // // // // // // //   });

// // // // // // // //   factory TextVisibility.fromJson(Map<String, dynamic> json) {
// // // // // // // //     return TextVisibility(
// // // // // // // //       name: json['name'] ?? 'visible',
// // // // // // // //       email: json['email'] ?? 'visible',
// // // // // // // //       mobile: json['mobile'] ?? 'visible',
// // // // // // // //       title: json['title'] ?? 'visible',
// // // // // // // //       description: json['description'] ?? 'visible',
// // // // // // // //       tags: json['tags'] ?? 'visible',
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   Map<String, dynamic> toJson() {
// // // // // // // //     return {
// // // // // // // //       'name': name,
// // // // // // // //       'email': email,
// // // // // // // //       'mobile': mobile,
// // // // // // // //       'title': title,
// // // // // // // //       'description': description,
// // // // // // // //       'tags': tags,
// // // // // // // //     };
// // // // // // // //   }

// // // // // // // //   bool isVisible(String field) {
// // // // // // // //     switch (field) {
// // // // // // // //       case 'name':
// // // // // // // //         return name == 'visible';
// // // // // // // //       case 'email':
// // // // // // // //         return email == 'visible';
// // // // // // // //       case 'mobile':
// // // // // // // //         return mobile == 'visible';
// // // // // // // //       case 'title':
// // // // // // // //         return title == 'visible';
// // // // // // // //       case 'description':
// // // // // // // //         return description == 'visible';
// // // // // // // //       case 'tags':
// // // // // // // //         return tags == 'visible';
// // // // // // // //       default:
// // // // // // // //         return true;
// // // // // // // //     }
// // // // // // // //   }
// // // // // // // // }

// // // // // // // // class OverlayImageFilter {
// // // // // // // //   double brightness;
// // // // // // // //   double contrast;
// // // // // // // //   double saturation;
// // // // // // // //   double grayscale;
// // // // // // // //   double blur;

// // // // // // // //   OverlayImageFilter({
// // // // // // // //     this.brightness = 100,
// // // // // // // //     this.contrast = 100,
// // // // // // // //     this.saturation = 100,
// // // // // // // //     this.grayscale = 0,
// // // // // // // //     this.blur = 0,
// // // // // // // //   });

// // // // // // // //   factory OverlayImageFilter.fromJson(Map<String, dynamic> json) {
// // // // // // // //     return OverlayImageFilter(
// // // // // // // //       brightness: _parseDouble(json['brightness'], 100),
// // // // // // // //       contrast: _parseDouble(json['contrast'], 100),
// // // // // // // //       saturation: _parseDouble(json['saturation'], 100),
// // // // // // // //       grayscale: _parseDouble(json['grayscale'], 0),
// // // // // // // //       blur: _parseDouble(json['blur'], 0),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   Map<String, dynamic> toJson() {
// // // // // // // //     return {
// // // // // // // //       'brightness': brightness,
// // // // // // // //       'contrast': contrast,
// // // // // // // //       'saturation': saturation,
// // // // // // // //       'grayscale': grayscale,
// // // // // // // //       'blur': blur,
// // // // // // // //     };
// // // // // // // //   }

// // // // // // // //   static double _parseDouble(dynamic value, double defaultValue) {
// // // // // // // //     if (value == null) return defaultValue;
// // // // // // // //     if (value is double) return value;
// // // // // // // //     if (value is int) return value.toDouble();
// // // // // // // //     if (value is String) return double.tryParse(value) ?? defaultValue;
// // // // // // // //     return defaultValue;
// // // // // // // //   }
// // // // // // // // }

// // // // // // // // class TextElement {
// // // // // // // //   String id;
// // // // // // // //   String text;
// // // // // // // //   double x;
// // // // // // // //   double y;
// // // // // // // //   double width;
// // // // // // // //   double height;
// // // // // // // //   double fontSize;
// // // // // // // //   Color color;
// // // // // // // //   FontWeight fontWeight;
// // // // // // // //   String fontFamily;
// // // // // // // //   TextAlign textAlign;
// // // // // // // //   bool isSelected;
// // // // // // // //   double rotation;

// // // // // // // //   TextElement({
// // // // // // // //     required this.id,
// // // // // // // //     required this.text,
// // // // // // // //     required this.x,
// // // // // // // //     required this.y,
// // // // // // // //     this.width = 200,
// // // // // // // //     this.height = 50,
// // // // // // // //     this.fontSize = 16,
// // // // // // // //     this.color = Colors.black,
// // // // // // // //     this.fontWeight = FontWeight.normal,
// // // // // // // //     this.fontFamily = 'Roboto',
// // // // // // // //     this.textAlign = TextAlign.left,
// // // // // // // //     this.isSelected = false,
// // // // // // // //     this.rotation = 0,
// // // // // // // //   });

// // // // // // // //   factory TextElement.fromJson(Map<String, dynamic> json) {
// // // // // // // //     return TextElement(
// // // // // // // //       id: json['id'] ?? '',
// // // // // // // //       text: json['text'] ?? '',
// // // // // // // //       x: _parseDouble(json['x'], 0),
// // // // // // // //       y: _parseDouble(json['y'], 0),
// // // // // // // //       width: _parseDouble(json['width'], 200),
// // // // // // // //       height: _parseDouble(json['height'], 50),
// // // // // // // //       fontSize: _parseDouble(json['fontSize'], 16),
// // // // // // // //       color: _parseColor(json['color']),
// // // // // // // //       fontWeight: _fontWeightFromString(json['fontWeight'] ?? 'normal'),
// // // // // // // //       fontFamily: json['fontFamily'] ?? 'Roboto',
// // // // // // // //       textAlign: _textAlignFromString(json['textAlign'] ?? 'left'),
// // // // // // // //       rotation: _parseDouble(json['rotation'], 0),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   Map<String, dynamic> toJson() {
// // // // // // // //     return {
// // // // // // // //       'id': id,
// // // // // // // //       'text': text,
// // // // // // // //       'x': x,
// // // // // // // //       'y': y,
// // // // // // // //       'width': width,
// // // // // // // //       'height': height,
// // // // // // // //       'fontSize': fontSize,
// // // // // // // //       'color': color.value,
// // // // // // // //       'fontWeight': _fontWeightToString(fontWeight),
// // // // // // // //       'fontFamily': fontFamily,
// // // // // // // //       'textAlign': _textAlignToString(textAlign),
// // // // // // // //       'rotation': rotation,
// // // // // // // //     };
// // // // // // // //   }

// // // // // // // //   static double _parseDouble(dynamic value, double defaultValue) {
// // // // // // // //     if (value == null) return defaultValue;
// // // // // // // //     if (value is double) return value;
// // // // // // // //     if (value is int) return value.toDouble();
// // // // // // // //     if (value is String) return double.tryParse(value) ?? defaultValue;
// // // // // // // //     return defaultValue;
// // // // // // // //   }

// // // // // // // //   static Color _parseColor(dynamic colorValue) {
// // // // // // // //     if (colorValue == null) return Colors.black;

// // // // // // // //     if (colorValue is int) {
// // // // // // // //       return Color(colorValue);
// // // // // // // //     }

// // // // // // // //     if (colorValue is String) {
// // // // // // // //       String hexColor = colorValue.replaceAll('#', '');
// // // // // // // //       if (hexColor.length == 6) {
// // // // // // // //         hexColor = 'FF$hexColor';
// // // // // // // //       }
// // // // // // // //       int? colorInt = int.tryParse(hexColor, radix: 16);
// // // // // // // //       if (colorInt != null) {
// // // // // // // //         return Color(colorInt);
// // // // // // // //       }
// // // // // // // //     }

// // // // // // // //     return Colors.black;
// // // // // // // //   }

// // // // // // // //   static FontWeight _fontWeightFromString(String weight) {
// // // // // // // //     switch (weight.toLowerCase()) {
// // // // // // // //       case 'bold':
// // // // // // // //         return FontWeight.bold;
// // // // // // // //       case 'w300':
// // // // // // // //         return FontWeight.w300;
// // // // // // // //       case 'w600':
// // // // // // // //         return FontWeight.w600;
// // // // // // // //       case 'w700':
// // // // // // // //         return FontWeight.w700;
// // // // // // // //       default:
// // // // // // // //         return FontWeight.normal;
// // // // // // // //     }
// // // // // // // //   }

// // // // // // // //   static String _fontWeightToString(FontWeight weight) {
// // // // // // // //     if (weight == FontWeight.bold) return 'bold';
// // // // // // // //     if (weight == FontWeight.w300) return 'w300';
// // // // // // // //     if (weight == FontWeight.w600) return 'w600';
// // // // // // // //     if (weight == FontWeight.w700) return 'w700';
// // // // // // // //     return 'normal';
// // // // // // // //   }

// // // // // // // //   static TextAlign _textAlignFromString(String align) {
// // // // // // // //     switch (align.toLowerCase()) {
// // // // // // // //       case 'center':
// // // // // // // //         return TextAlign.center;
// // // // // // // //       case 'right':
// // // // // // // //         return TextAlign.right;
// // // // // // // //       default:
// // // // // // // //         return TextAlign.left;
// // // // // // // //     }
// // // // // // // //   }

// // // // // // // //   static String _textAlignToString(TextAlign align) {
// // // // // // // //     switch (align) {
// // // // // // // //       case TextAlign.center:
// // // // // // // //         return 'center';
// // // // // // // //       case TextAlign.right:
// // // // // // // //         return 'right';
// // // // // // // //       default:
// // // // // // // //         return 'left';
// // // // // // // //     }
// // // // // // // //   }
// // // // // // // // }

// // // // // // // // class ImageElement {
// // // // // // // //   String id;
// // // // // // // //   String imageUrl;
// // // // // // // //   double x;
// // // // // // // //   double y;
// // // // // // // //   double width;
// // // // // // // //   double height;
// // // // // // // //   bool isSelected;
// // // // // // // //   double rotation;
// // // // // // // //   double borderRadius;

// // // // // // // //   ImageElement({
// // // // // // // //     required this.id,
// // // // // // // //     required this.imageUrl,
// // // // // // // //     required this.x,
// // // // // // // //     required this.y,
// // // // // // // //     this.width = 100,
// // // // // // // //     this.height = 100,
// // // // // // // //     this.isSelected = false,
// // // // // // // //     this.rotation = 0,
// // // // // // // //     this.borderRadius = 4.0,
// // // // // // // //   });

// // // // // // // //   factory ImageElement.fromJson(Map<String, dynamic> json) {
// // // // // // // //     return ImageElement(
// // // // // // // //       id: json['id'] ?? '',
// // // // // // // //       imageUrl: json['imageUrl'] ?? '',
// // // // // // // //       x: _parseDouble(json['x'], 0),
// // // // // // // //       y: _parseDouble(json['y'], 0),
// // // // // // // //       width: _parseDouble(json['width'], 100),
// // // // // // // //       height: _parseDouble(json['height'], 100),
// // // // // // // //       rotation: _parseDouble(json['rotation'], 0),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   Map<String, dynamic> toJson() {
// // // // // // // //     return {
// // // // // // // //       'id': id,
// // // // // // // //       'imageUrl': imageUrl,
// // // // // // // //       'x': x,
// // // // // // // //       'y': y,
// // // // // // // //       'width': width,
// // // // // // // //       'height': height,
// // // // // // // //       'rotation': rotation,
// // // // // // // //     };
// // // // // // // //   }

// // // // // // // //   static double _parseDouble(dynamic value, double defaultValue) {
// // // // // // // //     if (value == null) return defaultValue;
// // // // // // // //     if (value is double) return value;
// // // // // // // //     if (value is int) return value.toDouble();
// // // // // // // //     if (value is String) return double.tryParse(value) ?? defaultValue;
// // // // // // // //     return defaultValue;
// // // // // // // //   }
// // // // // // // // }

// // // // // // // // class ProfileElement {
// // // // // // // //   String id;
// // // // // // // //   String imageUrl;
// // // // // // // //   double x;
// // // // // // // //   double y;
// // // // // // // //   double width;
// // // // // // // //   double height;
// // // // // // // //   bool isSelected;
// // // // // // // //   double rotation;

// // // // // // // //   ProfileElement({
// // // // // // // //     required this.id,
// // // // // // // //     required this.imageUrl,
// // // // // // // //     required this.x,
// // // // // // // //     required this.y,
// // // // // // // //     this.width = 100,
// // // // // // // //     this.height = 100,
// // // // // // // //     this.isSelected = false,
// // // // // // // //     this.rotation = 0,
// // // // // // // //   });

// // // // // // // //   factory ProfileElement.fromJson(Map<String, dynamic> json) {
// // // // // // // //     return ProfileElement(
// // // // // // // //       id: json['id'] ?? '',
// // // // // // // //       imageUrl: json['imageUrl'] ?? '',
// // // // // // // //       x: _parseDouble(0, 0),
// // // // // // // //       y: _parseDouble(0, 0),
// // // // // // // //       width: _parseDouble(300, 100),
// // // // // // // //       height: _parseDouble(json['height'], 100),
// // // // // // // //       rotation: _parseDouble(json['rotation'], 0),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   Map<String, dynamic> toJson() {
// // // // // // // //     return {
// // // // // // // //       'id': id,
// // // // // // // //       'imageUrl': imageUrl,
// // // // // // // //       'x': x,
// // // // // // // //       'y': y,
// // // // // // // //       'width': width,
// // // // // // // //       'height': height,
// // // // // // // //       'rotation': rotation,
// // // // // // // //     };
// // // // // // // //   }

// // // // // // // //   static double _parseDouble(dynamic value, double defaultValue) {
// // // // // // // //     if (value == null) return defaultValue;
// // // // // // // //     if (value is double) return value;
// // // // // // // //     if (value is int) return value.toDouble();
// // // // // // // //     if (value is String) return double.tryParse(value) ?? defaultValue;
// // // // // // // //     return defaultValue;
// // // // // // // //   }
// // // // // // // // }

// // // // // // // // class SamplePosterScreen extends StatefulWidget {
// // // // // // // //   final String posterId;

// // // // // // // //   const SamplePosterScreen({super.key, required this.posterId});

// // // // // // // //   @override
// // // // // // // //   State<SamplePosterScreen> createState() => _ApiPosterEditorState();
// // // // // // // // }

// // // // // // // // class _ApiPosterEditorState extends State<SamplePosterScreen> {
// // // // // // // //   final TextEditingController _fontSizecontroller = TextEditingController();
// // // // // // // //   final GlobalKey _canvasKey = GlobalKey();
// // // // // // // //   PosterTemplate? _template;
// // // // // // // //   bool _isLoading = true;
// // // // // // // //   TextElement? _selectedTextElement;
// // // // // // // //   ImageElement? _selectedImageElement;
// // // // // // // //   ProfileElement? _selectedProfileImageElement;
// // // // // // // //   bool _showToolbar = false;
// // // // // // // //   String? _errorMessage;
// // // // // // // //   double _scaleFactor = 1.0;
// // // // // // // //   Size _canvasSize = Size.zero;
// // // // // // // //   String? phoneNumber;
// // // // // // // //   String? email;
// // // // // // // //   String? userId;
// // // // // // // //   String? profileImage;
// // // // // // // //   Uint8List? _logoImage;
// // // // // // // //   Uint8List? _profileImageBytes;
// // // // // // // //   final ImagePicker _picker = ImagePicker();
// // // // // // // //   double _currentScale = 1.0;
// // // // // // // //   Offset _currentOffset = Offset.zero;
// // // // // // // //   Offset _startOffset = Offset.zero;
// // // // // // // //   Offset _normalizedOffset = Offset.zero;

// // // // // // // //   Offset _focusPoint = Offset.zero;
// // // // // // // //   double _previousScale = 1.0;

// // // // // // // //   // For pinch zoom and pan handling
// // // // // // // //   double _baseScale = 1.0;
// // // // // // // //   double _currentBaseScale = 1.0;
// // // // // // // //   Offset? _initialFocalPoint;

// // // // // // // //   // Persistent image elements for profile and logo
// // // // // // // //   ProfileElement? _profileImageElement;
// // // // // // // //   ImageElement? _logoImageElement;

// // // // // // // //   // Add these with your other state variables
// // // // // // // //   double _businessNameFontSize = 20.0;
// // // // // // // //   double _phoneNumberFontSize = 20.0;

// // // // // // // //   // Audio section...........................................
// // // // // // // //   File? _audioFile;
// // // // // // // //   String? _videoPath;
// // // // // // // //   VideoPlayerController? _videoController;
// // // // // // // //   bool _exportingVideo = false;
// // // // // // // //   bool _videoReady = false;

// // // // // // // //   // final List<String> _fontFamilies = [
// // // // // // // //   //   'Roboto',
// // // // // // // //   //   'Arial',
// // // // // // // //   //   'Times New Roman',
// // // // // // // //   //   'Helvetica',
// // // // // // // //   //   'Comic Sans MS',
// // // // // // // //   //   'Verdana',
// // // // // // // //   //   'Courier New',
// // // // // // // //   //   'Georgia',
// // // // // // // //   //   'Palatino',
// // // // // // // //   //   'Garamond',
// // // // // // // //   // ];

// // // // // // // //   final List<String> _fontFamilies = [
// // // // // // // //     'Roboto',
// // // // // // // //     'Arial',
// // // // // // // //     'Times New Roman',
// // // // // // // //     'Helvetica',
// // // // // // // //     'Comic Sans MS',
// // // // // // // //     'Verdana',
// // // // // // // //     'Courier New',
// // // // // // // //     'Georgia',
// // // // // // // //     'Palatino',
// // // // // // // //     'Garamond',
// // // // // // // //     'Tahoma',
// // // // // // // //     'Trebuchet MS',
// // // // // // // //     'Lucida Sans',
// // // // // // // //     'Lucida Console',
// // // // // // // //     'Segoe UI',
// // // // // // // //     'Calibri',
// // // // // // // //     'Optima',
// // // // // // // //     'Candara',
// // // // // // // //     'Futura',
// // // // // // // //     'Franklin Gothic Medium',
// // // // // // // //     'Impact',
// // // // // // // //     'Book Antiqua',
// // // // // // // //   ];

// // // // // // // //   // final List<FontWeight> _fontWeights = [
// // // // // // // //   //   FontWeight.w300,
// // // // // // // //   //   FontWeight.normal,
// // // // // // // //   //   FontWeight.w600,
// // // // // // // //   //   FontWeight.bold, // This is the same as FontWeight.w700
// // // // // // // //   //   FontWeight.w900,
// // // // // // // //   // ];

// // // // // // // //   final List<FontWeight> _fontWeights = [
// // // // // // // //     FontWeight.w100, // Thin
// // // // // // // //     FontWeight.w200, // Extra Light
// // // // // // // //     FontWeight.w300, // Light
// // // // // // // //     FontWeight.w400, // Normal / Regular
// // // // // // // //     FontWeight.w500, // Medium
// // // // // // // //     FontWeight.w600, // Semi Bold
// // // // // // // //     FontWeight.w700, // Bold
// // // // // // // //     FontWeight.w800, // Extra Bold
// // // // // // // //     FontWeight.w900, // Black / Heavy
// // // // // // // //   ];

// // // // // // // //   final List<Color> _colors = [
// // // // // // // //     Colors.black,
// // // // // // // //     Colors.white,
// // // // // // // //     Colors.red,
// // // // // // // //     Colors.blue,
// // // // // // // //     Colors.green,
// // // // // // // //     Colors.yellow,
// // // // // // // //     Colors.purple,
// // // // // // // //     Colors.orange,
// // // // // // // //     Colors.pink,
// // // // // // // //     Colors.brown,
// // // // // // // //     Colors.grey,
// // // // // // // //     Colors.indigo,
// // // // // // // //     Colors.teal,
// // // // // // // //     Colors.amber,
// // // // // // // //     Colors.deepOrange,
// // // // // // // //     Colors.cyan,
// // // // // // // //     Colors.lime,
// // // // // // // //     Colors.deepPurple,
// // // // // // // //   ];

// // // // // // // //   @override
// // // // // // // //   void initState() {
// // // // // // // //     super.initState();
// // // // // // // //     _loadPosterFromApi();
// // // // // // // //     _loadUserData();
// // // // // // // //     // _loadSavedBusinessName();
// // // // // // // //   }

// // // // // // // //   // Save business name to SharedPreferences
// // // // // // // //   Future<void> _saveBusinessName(String name) async {
// // // // // // // //     final prefs = await SharedPreferences.getInstance();
// // // // // // // //     await prefs.setString('business_name', name);
// // // // // // // //   }

// // // // // // // //   // Load business name from SharedPreferences
// // // // // // // //   Future<String?> _loadBusinessName() async {
// // // // // // // //     final prefs = await SharedPreferences.getInstance();
// // // // // // // //     return prefs.getString('business_name');
// // // // // // // //   }

// // // // // // // //   // Update business name in SharedPreferences
// // // // // // // //   Future<void> _updateBusinessName(String newName) async {
// // // // // // // //     await _saveBusinessName(newName); // Reuses the save method
// // // // // // // //   }

// // // // // // // //   // Future<void> _loadSavedBusinessName() async {
// // // // // // // //   //   final savedName = await _loadBusinessName();
// // // // // // // //   //   if (savedName != null && _template != null) {
// // // // // // // //   //     setState(() {
// // // // // // // //   //       final nameElement = _template!.textElements.firstWhere(
// // // // // // // //   //         (e) => e.id == 'name',
// // // // // // // //   //         orElse: () =>
// // // // // // // //   //             TextElement(id: 'name', text: 'Business Name', x: 0, y: 0),
// // // // // // // //   //       );
// // // // // // // //   //       nameElement.text = savedName;
// // // // // // // //   //     });
// // // // // // // //   //   }
// // // // // // // //   // }

// // // // // // // //   Future<void> _loadSavedBusinessName() async {
// // // // // // // //     final savedName = await _loadBusinessName();
// // // // // // // //     if (savedName != null && savedName.isNotEmpty && _template != null) {
// // // // // // // //       setState(() {
// // // // // // // //         final nameElement = _template!.textElements.firstWhere(
// // // // // // // //           (e) => e.id == 'name',
// // // // // // // //           orElse: () =>
// // // // // // // //               TextElement(id: 'name', text: 'Business Name', x: 0, y: 0),
// // // // // // // //         );
// // // // // // // //         nameElement.text = savedName;
// // // // // // // //       });
// // // // // // // //     }
// // // // // // // //   }

// // // // // // // //   // audio section................................................
// // // // // // // //   // Add these methods to _ApiPosterEditorState class

// // // // // // // //   /// 🎵 PICK AUDIO
// // // // // // // //   Future<void> _pickAudio() async {
// // // // // // // //     try {
// // // // // // // //       final XFile? file = await openFile(
// // // // // // // //         acceptedTypeGroups: [
// // // // // // // //           const XTypeGroup(
// // // // // // // //             label: 'Audio files',
// // // // // // // //             extensions: ['mp3', 'm4a', 'wav'],
// // // // // // // //           ),
// // // // // // // //         ],
// // // // // // // //       );

// // // // // // // //       if (file != null) {
// // // // // // // //         // Create a safe filename
// // // // // // // //         final safeName = file.name.replaceAll(RegExp(r'[^\w\d\.\-_]'), '_');
// // // // // // // //         final dir = await getApplicationDocumentsDirectory();
// // // // // // // //         final newPath = '${dir.path}/$safeName';

// // // // // // // //         // Delete if exists
// // // // // // // //         if (await File(newPath).exists()) {
// // // // // // // //           await File(newPath).delete();
// // // // // // // //         }

// // // // // // // //         // Copy the file
// // // // // // // //         await File(file.path).copy(newPath);

// // // // // // // //         // Verify the file
// // // // // // // //         final copiedFile = File(newPath);
// // // // // // // //         if (await copiedFile.exists()) {
// // // // // // // //           final size = await copiedFile.length();
// // // // // // // //           print("✅ Audio file copied: $newPath, size: $size bytes");
// // // // // // // //           setState(() => _audioFile = copiedFile);
// // // // // // // //         } else {
// // // // // // // //           throw Exception("Failed to copy audio file");
// // // // // // // //         }

// // // // // // // //         // Clear previous video
// // // // // // // //         if (_videoController != null) {
// // // // // // // //           await _videoController!.pause();
// // // // // // // //           await _videoController!.dispose();
// // // // // // // //           _videoController = null;
// // // // // // // //         }
// // // // // // // //         setState(() {
// // // // // // // //           _videoPath = null;
// // // // // // // //           _videoReady = false;
// // // // // // // //         });
// // // // // // // //       }
// // // // // // // //     } catch (e) {
// // // // // // // //       print("❌ Error picking audio: $e");
// // // // // // // //       ScaffoldMessenger.of(
// // // // // // // //         context,
// // // // // // // //       ).showSnackBar(SnackBar(content: Text("Error picking audio: $e")));
// // // // // // // //     }
// // // // // // // //   }

// // // // // // // //   Future<void> testImageAudioCombination() async {
// // // // // // // //     print("🧪 Testing Image + Audio Combination");

// // // // // // // //     showDialog(
// // // // // // // //       context: context,
// // // // // // // //       barrierDismissible: false,
// // // // // // // //       builder: (context) => AlertDialog(
// // // // // // // //         content: Row(
// // // // // // // //           children: [
// // // // // // // //             CircularProgressIndicator(),
// // // // // // // //             SizedBox(width: 16),
// // // // // // // //             Text("Testing image+audio..."),
// // // // // // // //           ],
// // // // // // // //         ),
// // // // // // // //       ),
// // // // // // // //     );

// // // // // // // //     try {
// // // // // // // //       // 1. Create a test image
// // // // // // // //       final tempDir = await getTemporaryDirectory();
// // // // // // // //       final testImagePath = '${tempDir.path}/test_image.png';

// // // // // // // //       // Create a simple colored image
// // // // // // // //       final recorder = ui.PictureRecorder();
// // // // // // // //       final canvas = Canvas(recorder);
// // // // // // // //       final paint = Paint()..color = Colors.blue;
// // // // // // // //       canvas.drawRect(Rect.fromLTWH(0, 0, 800, 1200), paint);
// // // // // // // //       final picture = recorder.endRecording();
// // // // // // // //       final image = await picture.toImage(800, 1200);
// // // // // // // //       final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
// // // // // // // //       final pngBytes = byteData!.buffer.asUint8List();
// // // // // // // //       await File(testImagePath).writeAsBytes(pngBytes);

// // // // // // // //       print("1️⃣ Test image created: $testImagePath");

// // // // // // // //       // 2. Use your actual audio file or create a test audio
// // // // // // // //       String testAudioPath;
// // // // // // // //       if (_audioFile != null && await _audioFile!.exists()) {
// // // // // // // //         testAudioPath = _audioFile!.path;
// // // // // // // //         print("2️⃣ Using your audio file: $testAudioPath");
// // // // // // // //       } else {
// // // // // // // //         // Create silent audio (1 second of silence)
// // // // // // // //         testAudioPath = '${tempDir.path}/silent.mp3';
// // // // // // // //         final silentCmd =
// // // // // // // //             '-y -f lavfi -i anullsrc=r=44100:cl=stereo -t 1 $testAudioPath';
// // // // // // // //         print("2️⃣ Creating silent audio...");
// // // // // // // //         final silentSession = await FFmpegKit.execute(silentCmd);
// // // // // // // //         final silentReturnCode = await silentSession.getReturnCode();
// // // // // // // //         if (!ReturnCode.isSuccess(silentReturnCode)) {
// // // // // // // //           throw Exception("Failed to create silent audio");
// // // // // // // //         }
// // // // // // // //       }

// // // // // // // //       // 3. Test the command STEP BY STEP

// // // // // // // //       // Test A: Check image info
// // // // // // // //       print("\n3️⃣ Testing image info:");
// // // // // // // //       final imageInfoCmd = '-i "$testImagePath"';
// // // // // // // //       final imageSession = await FFmpegKit.execute(imageInfoCmd);
// // // // // // // //       final imageLogs = await imageSession.getAllLogs();
// // // // // // // //       for (var log in imageLogs) {
// // // // // // // //         print("IMG INFO: ${log.getMessage()}");
// // // // // // // //       }

// // // // // // // //       // Test B: Check audio info
// // // // // // // //       print("\n4️⃣ Testing audio info:");
// // // // // // // //       final audioInfoCmd = '-i "$testAudioPath"';
// // // // // // // //       final audioSession = await FFmpegKit.execute(audioInfoCmd);
// // // // // // // //       final audioLogs = await audioSession.getAllLogs();
// // // // // // // //       for (var log in audioLogs) {
// // // // // // // //         print("AUDIO INFO: ${log.getMessage()}");
// // // // // // // //       }

// // // // // // // //       // Test C: Try SIMPLE combination
// // // // // // // //       print("\n5️⃣ Testing simple combination:");
// // // // // // // //       final simpleOutput = '${tempDir.path}/simple_test.mp4';
// // // // // // // //       final simpleCmd =
// // // // // // // //           '''
// // // // // // // //     -y 
// // // // // // // //     -loop 1 
// // // // // // // //     -t 5 
// // // // // // // //     -i "$testImagePath" 
// // // // // // // //     -i "$testAudioPath" 
// // // // // // // //     -c:v libx264 
// // // // // // // //     -pix_fmt yuv420p 
// // // // // // // //     -c:a copy 
// // // // // // // //     -shortest 
// // // // // // // //     "$simpleOutput"
// // // // // // // //     '''
// // // // // // // //               .replaceAll('\n', ' ')
// // // // // // // //               .replaceAll(RegExp(r'\s+'), ' ')
// // // // // // // //               .trim();

// // // // // // // //       print("Simple Command: $simpleCmd");

// // // // // // // //       final simpleSession = await FFmpegKit.execute(simpleCmd);
// // // // // // // //       final simpleLogs = await simpleSession.getAllLogs();
// // // // // // // //       final simpleReturnCode = await simpleSession.getReturnCode();

// // // // // // // //       print("Simple Test Logs:");
// // // // // // // //       for (var log in simpleLogs) {
// // // // // // // //         print(">> ${log.getMessage()}");
// // // // // // // //       }

// // // // // // // //       if (ReturnCode.isSuccess(simpleReturnCode)) {
// // // // // // // //         final file = File(simpleOutput);
// // // // // // // //         if (await file.exists()) {
// // // // // // // //           print("✅ SIMPLE TEST PASSED! File: ${await file.length()} bytes");
// // // // // // // //           ScaffoldMessenger.of(context).showSnackBar(
// // // // // // // //             SnackBar(
// // // // // // // //               content: Text("Simple test PASSED! Check console."),
// // // // // // // //               backgroundColor: Colors.green,
// // // // // // // //             ),
// // // // // // // //           );
// // // // // // // //         } else {
// // // // // // // //           print("❌ Simple test: File not created");
// // // // // // // //         }
// // // // // // // //       } else {
// // // // // // // //         print(
// // // // // // // //           "❌ Simple test failed with code: ${simpleReturnCode?.getValue()}",
// // // // // // // //         );
// // // // // // // //       }
// // // // // // // //     } catch (e, stackTrace) {
// // // // // // // //       print("❌ Test error: $e");
// // // // // // // //       print("Stack: $stackTrace");
// // // // // // // //     } finally {
// // // // // // // //       if (Navigator.of(context).canPop()) {
// // // // // // // //         Navigator.of(context).pop();
// // // // // // // //       }
// // // // // // // //     }
// // // // // // // //   }

// // // // // // // //   /// 🎬 CREATE VIDEO
// // // // // // // //   Future<void> _exportVideo() async {
// // // // // // // //     if (_audioFile == null || _exportingVideo) return;

// // // // // // // //     setState(() {
// // // // // // // //       _exportingVideo = true;
// // // // // // // //       _videoReady = false;
// // // // // // // //     });

// // // // // // // //     try {
// // // // // // // //       print("1️⃣ Generating canvas image...");
// // // // // // // //       RenderRepaintBoundary boundary =
// // // // // // // //           _canvasKey.currentContext!.findRenderObject()
// // // // // // // //               as RenderRepaintBoundary;
// // // // // // // //       ui.Image image = await boundary.toImage(pixelRatio: 2.0);
// // // // // // // //       ByteData? byteData = await image.toByteData(
// // // // // // // //         format: ui.ImageByteFormat.png,
// // // // // // // //       );
// // // // // // // //       Uint8List pngBytes = byteData!.buffer.asUint8List();

// // // // // // // //       // Save PNG temporarily
// // // // // // // //       final tempDir = await getTemporaryDirectory();
// // // // // // // //       final imagePath =
// // // // // // // //           '${tempDir.path}/poster_${DateTime.now().millisecondsSinceEpoch}.png';
// // // // // // // //       await File(imagePath).writeAsBytes(pngBytes);

// // // // // // // //       print("2️⃣ Image size: ${await File(imagePath).length()} bytes");
// // // // // // // //       print("   Audio size: ${await _audioFile!.length()} bytes");

// // // // // // // //       print("3️⃣ Creating video...");
// // // // // // // //       String path;

// // // // // // // //       try {
// // // // // // // //         // Try main method
// // // // // // // //         path = await VideoExportService.createVideo(
// // // // // // // //           imagePath,
// // // // // // // //           _audioFile!.path,
// // // // // // // //         );
// // // // // // // //       } catch (e) {
// // // // // // // //         print("Method 1 failed: $e");
// // // // // // // //         print("Trying guaranteed method...");
// // // // // // // //         // Try guaranteed method
// // // // // // // //         path = await VideoExportService.createVideoGuaranteed(
// // // // // // // //           imagePath,
// // // // // // // //           _audioFile!.path,
// // // // // // // //         );
// // // // // // // //       }

// // // // // // // //       print("4️⃣ Video created at: $path");

// // // // // // // //       // Verify video file
// // // // // // // //       final videoFile = File(path);
// // // // // // // //       if (!await videoFile.exists()) {
// // // // // // // //         throw Exception("Video file missing: $path");
// // // // // // // //       }

// // // // // // // //       final videoSize = await videoFile.length();
// // // // // // // //       print("5️⃣ Video size: $videoSize bytes");

// // // // // // // //       // Setup video player
// // // // // // // //       if (_videoController != null) {
// // // // // // // //         await _videoController!.dispose();
// // // // // // // //       }

// // // // // // // //       _videoController = VideoPlayerController.file(videoFile);
// // // // // // // //       await _videoController!.initialize();
// // // // // // // //       await _videoController!.play();

// // // // // // // //       setState(() {
// // // // // // // //         _videoPath = path;
// // // // // // // //         _videoReady = true;
// // // // // // // //         _exportingVideo = false;
// // // // // // // //       });

// // // // // // // //       // Cleanup
// // // // // // // //       await File(imagePath).delete();
// // // // // // // //     } catch (e, stackTrace) {
// // // // // // // //       print("❌ FINAL ERROR: $e");
// // // // // // // //       print("Stack: $stackTrace");

// // // // // // // //       setState(() => _exportingVideo = false);

// // // // // // // //       // Show user-friendly error
// // // // // // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // // // // // //         SnackBar(
// // // // // // // //           content: Text("Error: ${e.toString()}"),
// // // // // // // //           duration: Duration(seconds: 5),
// // // // // // // //           action: SnackBarAction(
// // // // // // // //             label: "Debug",
// // // // // // // //             onPressed: () => _runDebugTest(),
// // // // // // // //           ),
// // // // // // // //         ),
// // // // // // // //       );
// // // // // // // //     }
// // // // // // // //   }

// // // // // // // //   // Debug function
// // // // // // // //   Future<void> _runDebugTest() async {
// // // // // // // //     print("🔍 Running debug test...");

// // // // // // // //     // Get image dimensions
// // // // // // // //     final boundary =
// // // // // // // //         _canvasKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
// // // // // // // //     final image = await boundary.toImage(pixelRatio: 1.0);
// // // // // // // //     print("📐 Image dimensions: ${image.width}x${image.height}");
// // // // // // // //     print("   Width even? ${image.width % 2 == 0}");
// // // // // // // //     print("   Height even? ${image.height % 2 == 0}");
// // // // // // // //   }

// // // // // // // //   Future<void> debugFFmpegCompletely() async {
// // // // // // // //     print("=" * 80);
// // // // // // // //     print("🚨 COMPLETE FFMPEG DEBUG");
// // // // // // // //     print("=" * 80);

// // // // // // // //     // Test 1: Basic version check
// // // // // // // //     print("\n1️⃣ Testing FFmpeg version:");
// // // // // // // //     try {
// // // // // // // //       final session = await FFmpegKit.execute("-version");
// // // // // // // //       final logs = await session.getAllLogs();
// // // // // // // //       for (var log in logs) {
// // // // // // // //         print("LOG: ${log.getMessage()}");
// // // // // // // //       }
// // // // // // // //       final returnCode = await session.getReturnCode();
// // // // // // // //       print("Return code: ${returnCode?.getValue()}");
// // // // // // // //     } catch (e) {
// // // // // // // //       print("Version test ERROR: $e");
// // // // // // // //     }

// // // // // // // //     // Test 2: Check available codecs
// // // // // // // //     print("\n2️⃣ Checking available encoders:");
// // // // // // // //     try {
// // // // // // // //       final session = await FFmpegKit.execute("-encoders");
// // // // // // // //       final logs = await session.getAllLogs();
// // // // // // // //       for (var log in logs) {
// // // // // // // //         final msg = log.getMessage();
// // // // // // // //         if (msg.contains("264") ||
// // // // // // // //             msg.contains("aac") ||
// // // // // // // //             msg.contains("mpeg4")) {
// // // // // // // //           print("ENCODER: $msg");
// // // // // // // //         }
// // // // // // // //       }
// // // // // // // //     } catch (e) {
// // // // // // // //       print("Encoder test ERROR: $e");
// // // // // // // //     }

// // // // // // // //     // Test 3: SIMPLE test command
// // // // // // // //     print("\n3️⃣ Testing SIMPLE command:");
// // // // // // // //     try {
// // // // // // // //       final tempDir = await getTemporaryDirectory();
// // // // // // // //       final testOutput = "${tempDir.path}/test_simple.mp4";

// // // // // // // //       // Create a simple colored video
// // // // // // // //       final cmd =
// // // // // // // //           '-y -f lavfi -i color=c=red:size=320x240:d=2 -c:v libx264 $testOutput';
// // // // // // // //       print("Command: $cmd");

// // // // // // // //       final session = await FFmpegKit.execute(cmd);
// // // // // // // //       final logs = await session.getAllLogs();
// // // // // // // //       print("Execution logs:");
// // // // // // // //       for (var log in logs) {
// // // // // // // //         print(">> ${log.getMessage()}");
// // // // // // // //       }

// // // // // // // //       final returnCode = await session.getReturnCode();
// // // // // // // //       print("Return code: ${returnCode?.getValue()}");

// // // // // // // //       final file = File(testOutput);
// // // // // // // //       if (await file.exists()) {
// // // // // // // //         print("✅ Test file created: ${await file.length()} bytes");
// // // // // // // //       } else {
// // // // // // // //         print("❌ Test file NOT created");
// // // // // // // //       }
// // // // // // // //     } catch (e) {
// // // // // // // //       print("Simple test ERROR: $e");
// // // // // // // //     }
// // // // // // // //   }

// // // // // // // //   Future<void> _downloadVideo() async {
// // // // // // // //     if (_videoPath == null) return;

// // // // // // // //     // Request correct permission
// // // // // // // //     final status = await Permission.videos.request();

// // // // // // // //     if (!status.isGranted) {
// // // // // // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // // // // // //         const SnackBar(content: Text("Gallery permission required")),
// // // // // // // //       );
// // // // // // // //       return;
// // // // // // // //     }

// // // // // // // //     try {
// // // // // // // //       await Gal.putVideo(_videoPath!, album: "PosterNova");

// // // // // // // //       ScaffoldMessenger.of(
// // // // // // // //         context,
// // // // // // // //       ).showSnackBar(const SnackBar(content: Text("Video saved to Gallery")));
// // // // // // // //     } catch (e) {
// // // // // // // //       ScaffoldMessenger.of(
// // // // // // // //         context,
// // // // // // // //       ).showSnackBar(const SnackBar(content: Text("Failed to save video")));
// // // // // // // //     }
// // // // // // // //   }

// // // // // // // //   /// 🔗 SHARE MP4
// // // // // // // //   Future<void> _shareVideo() async {
// // // // // // // //     if (_videoPath == null) return;

// // // // // // // //     try {
// // // // // // // //       await Share.shareXFiles([
// // // // // // // //         XFile(_videoPath!),
// // // // // // // //       ], text: "Created with PosterNova 🎨🎶");
// // // // // // // //     } catch (e) {
// // // // // // // //       ScaffoldMessenger.of(
// // // // // // // //         context,
// // // // // // // //       ).showSnackBar(SnackBar(content: Text("Error sharing video: $e")));
// // // // // // // //     }
// // // // // // // //   }

// // // // // // // //   /// Add to dispose method
// // // // // // // //   @override
// // // // // // // //   void dispose() {
// // // // // // // //     _videoController?.pause();
// // // // // // // //     _videoController?.dispose();
// // // // // // // //     super.dispose();
// // // // // // // //   }

// // // // // // // //   Future<void> _loadUserData() async {
// // // // // // // //     final userData = await AuthPreferences.getUserData();
// // // // // // // //     if (userData != null) {
// // // // // // // //       setState(() {
// // // // // // // //         phoneNumber = userData.user.mobile ?? phoneNumber;
// // // // // // // //         profileImage = userData.user.profileImage;
// // // // // // // //         email = userData.user.email ?? email;
// // // // // // // //         userId = userData.user.id ?? userId;
// // // // // // // //       });

// // // // // // // //       if (profileImage != null && profileImage!.isNotEmpty) {
// // // // // // // //         _loadProfileImage();
// // // // // // // //       }

// // // // // // // //       if (_template != null) {
// // // // // // // //         _updateTextElementsWithUserData();
// // // // // // // //       }
// // // // // // // //     }
// // // // // // // //   }

// // // // // // // //   void _showColorPickerDialog() {
// // // // // // // //     if (_selectedTextElement == null) return;

// // // // // // // //     Color currentColor = _selectedTextElement!.color;
// // // // // // // //     Color tempColor = currentColor; // Track temporary color separately

// // // // // // // //     final List<Color> _presetColors = [
// // // // // // // //       Colors.black,
// // // // // // // //       Colors.white,
// // // // // // // //       Colors.red,
// // // // // // // //       Colors.blue,
// // // // // // // //       Colors.green,
// // // // // // // //       Colors.yellow,
// // // // // // // //       Colors.orange,
// // // // // // // //       Colors.purple,
// // // // // // // //       Colors.pink,
// // // // // // // //       Colors.teal,
// // // // // // // //       Colors.cyan,
// // // // // // // //       Colors.amber,
// // // // // // // //       Colors.indigo,
// // // // // // // //       Colors.lime,
// // // // // // // //       Colors.brown,
// // // // // // // //       Colors.grey,
// // // // // // // //     ];

// // // // // // // //     showDialog(
// // // // // // // //       context: context,
// // // // // // // //       builder: (context) => StatefulBuilder(
// // // // // // // //         builder: (context, setDialogState) {
// // // // // // // //           return AlertDialog(
// // // // // // // //             title: const Text('Pick Text Color'),
// // // // // // // //             content: SingleChildScrollView(
// // // // // // // //               child: Column(
// // // // // // // //                 mainAxisSize: MainAxisSize.min,
// // // // // // // //                 children: [
// // // // // // // //                   // Color preview
// // // // // // // //                   Container(
// // // // // // // //                     width: double.infinity,
// // // // // // // //                     height: 60,
// // // // // // // //                     decoration: BoxDecoration(
// // // // // // // //                       color: tempColor,
// // // // // // // //                       borderRadius: BorderRadius.circular(8),
// // // // // // // //                       border: Border.all(color: Colors.grey),
// // // // // // // //                     ),
// // // // // // // //                     child: Center(
// // // // // // // //                       child: Text(
// // // // // // // //                         'Preview Text',
// // // // // // // //                         style: TextStyle(
// // // // // // // //                           color: _getContrastColor(tempColor),
// // // // // // // //                           fontSize: 16,
// // // // // // // //                           fontWeight: FontWeight.bold,
// // // // // // // //                         ),
// // // // // // // //                       ),
// // // // // // // //                     ),
// // // // // // // //                   ),
// // // // // // // //                   const SizedBox(height: 20),

// // // // // // // //                   // Preset colors grid
// // // // // // // //                   const Text(
// // // // // // // //                     'Preset Colors:',
// // // // // // // //                     style: TextStyle(fontWeight: FontWeight.bold),
// // // // // // // //                   ),
// // // // // // // //                   const SizedBox(height: 10),
// // // // // // // //                   GridView.builder(
// // // // // // // //                     shrinkWrap: true,
// // // // // // // //                     physics: const NeverScrollableScrollPhysics(),
// // // // // // // //                     gridDelegate:
// // // // // // // //                         const SliverGridDelegateWithFixedCrossAxisCount(
// // // // // // // //                           crossAxisCount: 8,
// // // // // // // //                           crossAxisSpacing: 8,
// // // // // // // //                           mainAxisSpacing: 8,
// // // // // // // //                         ),
// // // // // // // //                     itemCount: _presetColors.length,
// // // // // // // //                     itemBuilder: (context, index) {
// // // // // // // //                       final color = _presetColors[index];
// // // // // // // //                       final isSelected = tempColor == color;
// // // // // // // //                       return GestureDetector(
// // // // // // // //                         onTap: () {
// // // // // // // //                           setDialogState(() {
// // // // // // // //                             tempColor = color;
// // // // // // // //                           });
// // // // // // // //                         },
// // // // // // // //                         child: Container(
// // // // // // // //                           decoration: BoxDecoration(
// // // // // // // //                             color: color,
// // // // // // // //                             shape: BoxShape.circle,
// // // // // // // //                             border: Border.all(
// // // // // // // //                               color: isSelected ? Colors.blue : Colors.grey,
// // // // // // // //                               width: isSelected ? 3 : 1,
// // // // // // // //                             ),
// // // // // // // //                             boxShadow: isSelected
// // // // // // // //                                 ? [
// // // // // // // //                                     BoxShadow(
// // // // // // // //                                       color: Colors.blue.withOpacity(0.5),
// // // // // // // //                                       blurRadius: 8,
// // // // // // // //                                       spreadRadius: 2,
// // // // // // // //                                     ),
// // // // // // // //                                   ]
// // // // // // // //                                 : null,
// // // // // // // //                           ),
// // // // // // // //                           child: isSelected
// // // // // // // //                               ? const Icon(
// // // // // // // //                                   Icons.check,
// // // // // // // //                                   color: Colors.white,
// // // // // // // //                                   size: 16,
// // // // // // // //                                 )
// // // // // // // //                               : null,
// // // // // // // //                         ),
// // // // // // // //                       );
// // // // // // // //                     },
// // // // // // // //                   ),
// // // // // // // //                   const SizedBox(height: 20),

// // // // // // // //                   // Advanced color picker
// // // // // // // //                   const Text(
// // // // // // // //                     'Custom Color:',
// // // // // // // //                     style: TextStyle(fontWeight: FontWeight.bold),
// // // // // // // //                   ),
// // // // // // // //                   const SizedBox(height: 10),
// // // // // // // //                   ColorPicker(
// // // // // // // //                     pickerColor: tempColor,
// // // // // // // //                     onColorChanged: (color) {
// // // // // // // //                       setDialogState(() {
// // // // // // // //                         tempColor = color;
// // // // // // // //                       });
// // // // // // // //                     },
// // // // // // // //                     pickerAreaHeightPercent: 0.4,
// // // // // // // //                     enableAlpha: false,
// // // // // // // //                     displayThumbColor: true,
// // // // // // // //                     colorPickerWidth: 300,
// // // // // // // //                     pickerAreaBorderRadius: BorderRadius.circular(12),
// // // // // // // //                     hexInputBar: false,
// // // // // // // //                     labelTypes: const [],
// // // // // // // //                   ),
// // // // // // // //                 ],
// // // // // // // //               ),
// // // // // // // //             ),
// // // // // // // //             actions: [
// // // // // // // //               TextButton(
// // // // // // // //                 onPressed: () {
// // // // // // // //                   // Don't apply changes - just close
// // // // // // // //                   Navigator.pop(context);
// // // // // // // //                 },
// // // // // // // //                 child: const Text('Cancel'),
// // // // // // // //               ),
// // // // // // // //               TextButton(
// // // // // // // //                 onPressed: () {
// // // // // // // //                   // Apply the color change to the main widget state
// // // // // // // //                   setState(() {
// // // // // // // //                     _selectedTextElement!.color = tempColor;
// // // // // // // //                   });
// // // // // // // //                   Navigator.pop(context);
// // // // // // // //                 },
// // // // // // // //                 child: const Text('Apply'),
// // // // // // // //               ),
// // // // // // // //             ],
// // // // // // // //           );
// // // // // // // //         },
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   // Helper method to get contrast color (add this if not present)
// // // // // // // //   Color _getContrastColor(Color backgroundColor) {
// // // // // // // //     // Calculate the perceptive luminance
// // // // // // // //     double luminance =
// // // // // // // //         (0.299 * backgroundColor.red +
// // // // // // // //             0.587 * backgroundColor.green +
// // // // // // // //             0.114 * backgroundColor.blue) /
// // // // // // // //         255;
// // // // // // // //     return luminance > 0.5 ? Colors.black : Colors.white;
// // // // // // // //   }

// // // // // // // //   void _showManualSizeInputDialog() {
// // // // // // // //     if (_selectedTextElement == null) return;

// // // // // // // //     _fontSizecontroller.text = _selectedTextElement!.fontSize
// // // // // // // //         .round()
// // // // // // // //         .toString();

// // // // // // // //     showDialog(
// // // // // // // //       context: context,
// // // // // // // //       builder: (context) => AlertDialog(
// // // // // // // //         title: const Text('Enter Font Size'),
// // // // // // // //         content: TextField(
// // // // // // // //           controller: _fontSizecontroller,
// // // // // // // //           keyboardType: TextInputType.number,
// // // // // // // //           decoration: const InputDecoration(
// // // // // // // //             hintText: 'Enter font size...',
// // // // // // // //             border: OutlineInputBorder(),
// // // // // // // //             suffixText: 'px',
// // // // // // // //           ),
// // // // // // // //         ),
// // // // // // // //         actions: [
// // // // // // // //           TextButton(
// // // // // // // //             onPressed: () => Navigator.pop(context),
// // // // // // // //             child: const Text('Cancel'),
// // // // // // // //           ),
// // // // // // // //           TextButton(
// // // // // // // //             onPressed: () {
// // // // // // // //               final newSize = double.tryParse(_fontSizecontroller.text);
// // // // // // // //               if (newSize != null && newSize >= 8 && newSize <= 600) {
// // // // // // // //                 setState(() {
// // // // // // // //                   _selectedTextElement!.fontSize = newSize;
// // // // // // // //                   // Auto-adjust dimensions for large text
// // // // // // // //                   if (newSize > 100) {
// // // // // // // //                     final textLength = _selectedTextElement!.text.length;
// // // // // // // //                     _selectedTextElement!.width = (textLength * newSize * 0.5)
// // // // // // // //                         .clamp(200.0, _template!.width * 2);
// // // // // // // //                     _selectedTextElement!.height = (newSize * 1.5).clamp(
// // // // // // // //                       50.0,
// // // // // // // //                       _template!.height * 2,
// // // // // // // //                     );
// // // // // // // //                   }
// // // // // // // //                 });
// // // // // // // //                 Navigator.pop(context);
// // // // // // // //               } else {
// // // // // // // //                 ScaffoldMessenger.of(context).showSnackBar(
// // // // // // // //                   const SnackBar(
// // // // // // // //                     content: Text(
// // // // // // // //                       'Please enter a valid size between 8 and 600',
// // // // // // // //                     ),
// // // // // // // //                     backgroundColor: Colors.red,
// // // // // // // //                   ),
// // // // // // // //                 );
// // // // // // // //               }
// // // // // // // //             },
// // // // // // // //             child: const Text('Apply'),
// // // // // // // //           ),
// // // // // // // //         ],
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   Future<void> _loadProfileImage() async {
// // // // // // // //     try {
// // // // // // // //       final response = await http.get(Uri.parse(profileImage!));
// // // // // // // //       if (response.statusCode == 200) {
// // // // // // // //         setState(() {
// // // // // // // //           _profileImageBytes = response.bodyBytes;
// // // // // // // //           // Create persistent profile image element
// // // // // // // //           _profileImageElement = ProfileElement(
// // // // // // // //             id: 'profile_image',
// // // // // // // //             imageUrl: '',
// // // // // // // //             x: 10,
// // // // // // // //             y: 10,
// // // // // // // //             width: 200,
// // // // // // // //             height: 200,
// // // // // // // //           );
// // // // // // // //         });
// // // // // // // //       }
// // // // // // // //     } catch (e) {
// // // // // // // //       debugPrint('Error loading profile image: $e');
// // // // // // // //     }
// // // // // // // //   }

// // // // // // // //   void _updateTextElementsWithUserData() {
// // // // // // // //     if (_template == null) return;

// // // // // // // //     setState(() {
// // // // // // // //       for (var element in _template!.textElements) {
// // // // // // // //         switch (element.id) {
// // // // // // // //           case 'email':
// // // // // // // //             if (email != null && email!.isNotEmpty) {
// // // // // // // //               element.text = email!;
// // // // // // // //             }
// // // // // // // //             break;
// // // // // // // //           case 'mobile':
// // // // // // // //             if (phoneNumber != null && phoneNumber!.isNotEmpty) {
// // // // // // // //               element.text = phoneNumber!;
// // // // // // // //             }
// // // // // // // //             break;
// // // // // // // //         }
// // // // // // // //       }
// // // // // // // //     });
// // // // // // // //   }

// // // // // // // //   void _calculateScaleFactor(Size screenSize) {
// // // // // // // //     if (_template == null) return;

// // // // // // // //     final availableHeight = screenSize.height - 200;
// // // // // // // //     final availableWidth = screenSize.width - 32;

// // // // // // // //     final scaleX = availableWidth / _template!.width;
// // // // // // // //     final scaleY = availableHeight / _template!.height;

// // // // // // // //     _scaleFactor = scaleX < scaleY ? scaleX : scaleY;

// // // // // // // //     if (_scaleFactor < 0.3) _scaleFactor = 0.3;
// // // // // // // //     if (_scaleFactor > 1.5) _scaleFactor = 1.5;

// // // // // // // //     _canvasSize = Size(
// // // // // // // //       _template!.width * _scaleFactor,
// // // // // // // //       _template!.height * _scaleFactor,
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   // Future<void> _loadPosterFromApi() async {
// // // // // // // //   //   try {
// // // // // // // //   //     setState(() {
// // // // // // // //   //       _isLoading = true;
// // // // // // // //   //       _errorMessage = null;
// // // // // // // //   //     });

// // // // // // // //   //     final response = await http.get(
// // // // // // // //   //       Uri.parse(
// // // // // // // //   //         'http://31.97.206.144:4061/api/poster/singlecanvasposters/${widget.posterId}',
// // // // // // // //   //       ),
// // // // // // // //   //       headers: {'Content-Type': 'application/json'},
// // // // // // // //   //     );

// // // // // // // //   //     if (response.statusCode == 200) {
// // // // // // // //   //       final apiResponse = json.decode(response.body) as Map<String, dynamic>;
// // // // // // // //   //       final template = PosterTemplate.fromApiResponse(apiResponse);

// // // // // // // //   //       setState(() {
// // // // // // // //   //         _template = template;
// // // // // // // //   //         _isLoading = false;
// // // // // // // //   //       });

// // // // // // // //   //       _updateTextElementsWithUserData();
// // // // // // // //   //       await _loadSavedBusinessName();
// // // // // // // //   //     } else {
// // // // // // // //   //       throw Exception('Failed to load poster: ${response.statusCode}');
// // // // // // // //   //     }
// // // // // // // //   //   } catch (e, stackTrace) {
// // // // // // // //   //     debugPrint("Error loading poster from API: $e");
// // // // // // // //   //     debugPrint("Stack trace: $stackTrace");
// // // // // // // //   //     setState(() {
// // // // // // // //   //       _errorMessage = "Failed to load poster: $e";
// // // // // // // //   //       _isLoading = false;
// // // // // // // //   //     });
// // // // // // // //   //   }
// // // // // // // //   // }

// // // // // // // //   Future<void> _loadPosterFromApi() async {
// // // // // // // //     try {
// // // // // // // //       setState(() {
// // // // // // // //         _isLoading = true;
// // // // // // // //         _errorMessage = null;
// // // // // // // //       });

// // // // // // // //       final response = await http.get(
// // // // // // // //         Uri.parse(
// // // // // // // //           'http://31.97.206.144:4061/api/poster/singlecanvasposters/${widget.posterId}',
// // // // // // // //         ),
// // // // // // // //         headers: {'Content-Type': 'application/json'},
// // // // // // // //       );

// // // // // // // //       if (response.statusCode == 200) {
// // // // // // // //         final apiResponse = json.decode(response.body) as Map<String, dynamic>;
// // // // // // // //         final template = PosterTemplate.fromApiResponse(apiResponse);

// // // // // // // //         setState(() {
// // // // // // // //           _template = template;
// // // // // // // //           _isLoading = false;
// // // // // // // //         });

// // // // // // // //         _updateTextElementsWithUserData();

// // // // // // // //         // ADD THIS: Load saved business name after template is loaded
// // // // // // // //         await _loadSavedBusinessName();
// // // // // // // //       } else {
// // // // // // // //         throw Exception('Failed to load poster: ${response.statusCode}');
// // // // // // // //       }
// // // // // // // //     } catch (e, stackTrace) {
// // // // // // // //       debugPrint("Error loading poster from API: $e");
// // // // // // // //       debugPrint("Stack trace: $stackTrace");
// // // // // // // //       setState(() {
// // // // // // // //         _errorMessage = "Failed to load poster: $e";
// // // // // // // //         _isLoading = false;
// // // // // // // //       });
// // // // // // // //     }
// // // // // // // //   }

// // // // // // // //   Future<void> _pickLogoImage() async {
// // // // // // // //     try {
// // // // // // // //       final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
// // // // // // // //       if (image != null) {
// // // // // // // //         final bytes = await image.readAsBytes();
// // // // // // // //         setState(() {
// // // // // // // //           _logoImage = bytes;
// // // // // // // //           // Create persistent logo image element
// // // // // // // //           _logoImageElement = ImageElement(
// // // // // // // //             id: 'logo_image',
// // // // // // // //             imageUrl: '',
// // // // // // // //             x: _template != null ? _template!.width - 120 : 20,
// // // // // // // //             y: 20,
// // // // // // // //             width: 100,
// // // // // // // //             height: 100,
// // // // // // // //           );
// // // // // // // //         });
// // // // // // // //       }
// // // // // // // //     } catch (e) {
// // // // // // // //       debugPrint('Error picking logo image: $e');
// // // // // // // //       ScaffoldMessenger.of(
// // // // // // // //         context,
// // // // // // // //       ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
// // // // // // // //     }
// // // // // // // //   }

// // // // // // // //   Future<void> _pickAdditionalImage() async {
// // // // // // // //     try {
// // // // // // // //       final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
// // // // // // // //       if (image != null) {
// // // // // // // //         final bytes = await image.readAsBytes();
// // // // // // // //         final tempDir = await getTemporaryDirectory();
// // // // // // // //         final file = File(
// // // // // // // //           '${tempDir.path}/additional_${DateTime.now().millisecondsSinceEpoch}.png',
// // // // // // // //         );
// // // // // // // //         await file.writeAsBytes(bytes);

// // // // // // // //         setState(() {
// // // // // // // //           _template?.imageElements.add(
// // // // // // // //             ImageElement(
// // // // // // // //               id: 'additional_${DateTime.now().millisecondsSinceEpoch}',
// // // // // // // //               imageUrl: file.path,
// // // // // // // //               x: _template!.width / 2 - 100,
// // // // // // // //               y: _template!.height / 2 - 100,
// // // // // // // //               width: 200,
// // // // // // // //               height: 200,
// // // // // // // //             ),
// // // // // // // //           );
// // // // // // // //         });
// // // // // // // //       }
// // // // // // // //     } catch (e) {
// // // // // // // //       debugPrint('Error picking additional image: $e');
// // // // // // // //       ScaffoldMessenger.of(
// // // // // // // //         context,
// // // // // // // //       ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
// // // // // // // //     }
// // // // // // // //   }

// // // // // // // //   Future<void> _showCustomerSelectionDialog() async {
// // // // // // // //     final customerProvider = Provider.of<CreateCustomerProvider>(
// // // // // // // //       context,
// // // // // // // //       listen: false,
// // // // // // // //     );

// // // // // // // //     // Fetch customers if not already loaded
// // // // // // // //     if (customerProvider.customers.isEmpty) {
// // // // // // // //       await customerProvider.fetchUser(userId.toString());
// // // // // // // //     }

// // // // // // // //     if (customerProvider.customers.isEmpty) {
// // // // // // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // // // // // //         const SnackBar(
// // // // // // // //           content: Text('No customers available. Please add customers first.'),
// // // // // // // //           backgroundColor: Colors.orange,
// // // // // // // //         ),
// // // // // // // //       );
// // // // // // // //       return;
// // // // // // // //     }

// // // // // // // //     // Track selected customers
// // // // // // // //     Set<String> selectedCustomerIds = {};

// // // // // // // //     showDialog(
// // // // // // // //       context: context,
// // // // // // // //       builder: (context) => StatefulBuilder(
// // // // // // // //         builder: (context, setDialogState) => AlertDialog(
// // // // // // // //           title: Row(
// // // // // // // //             children: [
// // // // // // // //               const Icon(Icons.people, color: Colors.deepPurple),
// // // // // // // //               const SizedBox(width: 8),
// // // // // // // //               const Text('Share Customers'),
// // // // // // // //               const Spacer(),
// // // // // // // //               if (selectedCustomerIds.isNotEmpty)
// // // // // // // //                 Container(
// // // // // // // //                   padding: const EdgeInsets.symmetric(
// // // // // // // //                     horizontal: 8,
// // // // // // // //                     vertical: 4,
// // // // // // // //                   ),
// // // // // // // //                   decoration: BoxDecoration(
// // // // // // // //                     color: Colors.deepPurple,
// // // // // // // //                     borderRadius: BorderRadius.circular(12),
// // // // // // // //                   ),
// // // // // // // //                   // child: Text(
// // // // // // // //                   //   '${selectedCustomerIds.length}',
// // // // // // // //                   //   style: const TextStyle(color: Colors.white, fontSize: 12),
// // // // // // // //                   // ),
// // // // // // // //                 ),
// // // // // // // //             ],
// // // // // // // //           ),
// // // // // // // //           content: SizedBox(
// // // // // // // //             width: double.maxFinite,
// // // // // // // //             height: 400,
// // // // // // // //             child: Column(
// // // // // // // //               children: [
// // // // // // // //                 // Select All / Deselect All
// // // // // // // //                 CheckboxListTile(
// // // // // // // //                   title: Text(
// // // // // // // //                     selectedCustomerIds.length ==
// // // // // // // //                             customerProvider.customers.length
// // // // // // // //                         ? 'Deselect All'
// // // // // // // //                         : 'Select All',
// // // // // // // //                     style: const TextStyle(fontWeight: FontWeight.bold),
// // // // // // // //                   ),
// // // // // // // //                   value:
// // // // // // // //                       selectedCustomerIds.length ==
// // // // // // // //                       customerProvider.customers.length,
// // // // // // // //                   onChanged: (value) {
// // // // // // // //                     setDialogState(() {
// // // // // // // //                       if (value == true) {
// // // // // // // //                         selectedCustomerIds = customerProvider.customers
// // // // // // // //                             .map((c) => c['_id'] as String)
// // // // // // // //                             .toSet();
// // // // // // // //                       } else {
// // // // // // // //                         selectedCustomerIds.clear();
// // // // // // // //                       }
// // // // // // // //                     });
// // // // // // // //                   },
// // // // // // // //                   activeColor: Colors.deepPurple,
// // // // // // // //                 ),
// // // // // // // //                 const Divider(),

// // // // // // // //                 // Customer List
// // // // // // // //                 Expanded(
// // // // // // // //                   child: ListView.builder(
// // // // // // // //                     itemCount: customerProvider.customers.length,
// // // // // // // //                     itemBuilder: (context, index) {
// // // // // // // //                       final customer = customerProvider.customers[index];
// // // // // // // //                       final customerId = customer['_id'] as String;
// // // // // // // //                       final isSelected = selectedCustomerIds.contains(
// // // // // // // //                         customerId,
// // // // // // // //                       );

// // // // // // // //                       return CheckboxListTile(
// // // // // // // //                         secondary: CircleAvatar(
// // // // // // // //                           backgroundColor: Colors.deepPurple,
// // // // // // // //                           child: Text(
// // // // // // // //                             (customer['name'] ?? 'U')[0].toUpperCase(),
// // // // // // // //                             style: const TextStyle(color: Colors.white),
// // // // // // // //                           ),
// // // // // // // //                         ),
// // // // // // // //                         title: Text(
// // // // // // // //                           customer['name'] ?? 'Unknown',
// // // // // // // //                           style: const TextStyle(fontWeight: FontWeight.w600),
// // // // // // // //                         ),
// // // // // // // //                         subtitle: Column(
// // // // // // // //                           crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // //                           children: [
// // // // // // // //                             if (customer['mobile'] != null)
// // // // // // // //                               Text(
// // // // // // // //                                 customer['mobile'],
// // // // // // // //                                 style: const TextStyle(fontSize: 12),
// // // // // // // //                               ),
// // // // // // // //                             if (customer['email'] != null)
// // // // // // // //                               Text(
// // // // // // // //                                 customer['email'],
// // // // // // // //                                 style: const TextStyle(fontSize: 11),
// // // // // // // //                               ),
// // // // // // // //                           ],
// // // // // // // //                         ),
// // // // // // // //                         value: isSelected,
// // // // // // // //                         onChanged: (value) {
// // // // // // // //                           setDialogState(() {
// // // // // // // //                             if (value == true) {
// // // // // // // //                               selectedCustomerIds.add(customerId);
// // // // // // // //                             } else {
// // // // // // // //                               selectedCustomerIds.remove(customerId);
// // // // // // // //                             }
// // // // // // // //                           });
// // // // // // // //                         },
// // // // // // // //                         activeColor: Colors.deepPurple,
// // // // // // // //                       );
// // // // // // // //                     },
// // // // // // // //                   ),
// // // // // // // //                 ),
// // // // // // // //               ],
// // // // // // // //             ),
// // // // // // // //           ),
// // // // // // // //           actions: [
// // // // // // // //             TextButton(
// // // // // // // //               onPressed: () => Navigator.pop(context),
// // // // // // // //               child: const Text('Cancel'),
// // // // // // // //             ),
// // // // // // // //             ElevatedButton.icon(
// // // // // // // //               onPressed: selectedCustomerIds.isEmpty
// // // // // // // //                   ? null
// // // // // // // //                   : () async {
// // // // // // // //                       Navigator.pop(context);
// // // // // // // //                       await _sharePosterWithSelectedCustomers(
// // // // // // // //                         selectedCustomerIds,
// // // // // // // //                         customerProvider.customers,
// // // // // // // //                       );
// // // // // // // //                     },
// // // // // // // //               style: ElevatedButton.styleFrom(
// // // // // // // //                 backgroundColor: Colors.deepPurple,
// // // // // // // //                 foregroundColor: Colors.white,
// // // // // // // //                 disabledBackgroundColor: Colors.grey,
// // // // // // // //               ),
// // // // // // // //               icon: const Icon(Icons.share, size: 18),
// // // // // // // //               label: Text('Share (${selectedCustomerIds.length})'),
// // // // // // // //             ),
// // // // // // // //           ],
// // // // // // // //         ),
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   // Future<void> _sharePosterWithSelectedCustomers(
// // // // // // // //   //   Set<String> selectedCustomerIds,
// // // // // // // //   //   List<Map<String, dynamic>> allCustomers,
// // // // // // // //   // ) async {
// // // // // // // //   //   try {
// // // // // // // //   //     showDialog(
// // // // // // // //   //       context: context,
// // // // // // // //   //       barrierDismissible: false,
// // // // // // // //   //       builder: (context) => const AlertDialog(
// // // // // // // //   //         content: Row(
// // // // // // // //   //           children: [
// // // // // // // //   //             CircularProgressIndicator(),
// // // // // // // //   //             SizedBox(width: 16),
// // // // // // // //   //             Text('Preparing poster...'),
// // // // // // // //   //           ],
// // // // // // // //   //         ),
// // // // // // // //   //       ),
// // // // // // // //   //     );

// // // // // // // //   //     // Generate poster image
// // // // // // // //   //     RenderRepaintBoundary boundary =
// // // // // // // //   //         _canvasKey.currentContext!.findRenderObject()
// // // // // // // //   //             as RenderRepaintBoundary;
// // // // // // // //   //     ui.Image image = await boundary.toImage(pixelRatio: 3.0);
// // // // // // // //   //     ByteData? byteData = await image.toByteData(
// // // // // // // //   //       format: ui.ImageByteFormat.png,
// // // // // // // //   //     );
// // // // // // // //   //     Uint8List pngBytes = byteData!.buffer.asUint8List();

// // // // // // // //   //     final directory = await getTemporaryDirectory();
// // // // // // // //   //     final file = File(
// // // // // // // //   //       '${directory.path}/poster_share_${DateTime.now().millisecondsSinceEpoch}.png',
// // // // // // // //   //     );
// // // // // // // //   //     await file.writeAsBytes(pngBytes);

// // // // // // // //   //     Navigator.of(context).pop(); // Close loading dialog

// // // // // // // //   //     // Get selected customers
// // // // // // // //   //     final selectedCustomers = allCustomers
// // // // // // // //   //         .where((c) => selectedCustomerIds.contains(c['_id']))
// // // // // // // //   //         .toList();

// // // // // // // //   //     int successCount = 0;
// // // // // // // //   //     int failCount = 0;

// // // // // // // //   //     // Share with each selected customer
// // // // // // // //   //     for (var customer in selectedCustomers) {
// // // // // // // //   //       final mobile = customer['mobile']?.toString() ?? '';
// // // // // // // //   //       final name = customer['name']?.toString() ?? 'Customer';

// // // // // // // //   //       if (mobile.isEmpty) {
// // // // // // // //   //         failCount++;
// // // // // // // //   //         continue;
// // // // // // // //   //       }

// // // // // // // //   //       try {
// // // // // // // //   //         // Clean phone number
// // // // // // // //   //         String cleanNumber = mobile.replaceAll(RegExp(r'[^\d+]'), '');
// // // // // // // //   //         if (!cleanNumber.startsWith('+')) {
// // // // // // // //   //           if (cleanNumber.length == 10) {
// // // // // // // //   //             cleanNumber = '+91$cleanNumber';
// // // // // // // //   //           }
// // // // // // // //   //         }

// // // // // // // //   //         // Create WhatsApp URL with image
// // // // // // // //   //         final whatsappUrl = Uri.parse(
// // // // // // // //   //           'https://wa.me/$cleanNumber?text=${Uri.encodeComponent("Hi $name, check out this poster!")}',
// // // // // // // //   //         );

// // // // // // // //   //         if (await canLaunchUrl(whatsappUrl)) {
// // // // // // // //   //           await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
// // // // // // // //   //           // Small delay between shares
// // // // // // // //   //           await Future.delayed(const Duration(milliseconds: 500));
// // // // // // // //   //           successCount++;
// // // // // // // //   //         } else {
// // // // // // // //   //           failCount++;
// // // // // // // //   //         }
// // // // // // // //   //       } catch (e) {
// // // // // // // //   //         debugPrint('Error sharing with $name: $e');
// // // // // // // //   //         failCount++;
// // // // // // // //   //       }
// // // // // // // //   //     }

// // // // // // // //   //     // Show results
// // // // // // // //   //     if (mounted) {
// // // // // // // //   //       ScaffoldMessenger.of(context).showSnackBar(
// // // // // // // //   //         SnackBar(
// // // // // // // //   //           content: Text(
// // // // // // // //   //             'Shared with $successCount customer${successCount != 1 ? 's' : ''}' +
// // // // // // // //   //                 (failCount > 0 ? ' ($failCount failed)' : ''),
// // // // // // // //   //           ),
// // // // // // // //   //           backgroundColor: successCount > 0 ? Colors.green : Colors.orange,
// // // // // // // //   //           duration: const Duration(seconds: 4),
// // // // // // // //   //           action: SnackBarAction(
// // // // // // // //   //             label: 'OK',
// // // // // // // //   //             textColor: Colors.white,
// // // // // // // //   //             onPressed: () {},
// // // // // // // //   //           ),
// // // // // // // //   //         ),
// // // // // // // //   //       );
// // // // // // // //   //     }
// // // // // // // //   //   } catch (e) {
// // // // // // // //   //     if (Navigator.of(context).canPop()) {
// // // // // // // //   //       Navigator.of(context).pop();
// // // // // // // //   //     }

// // // // // // // //   //     if (mounted) {
// // // // // // // //   //       ScaffoldMessenger.of(context).showSnackBar(
// // // // // // // //   //         SnackBar(
// // // // // // // //   //           content: Text('Error preparing poster: $e'),
// // // // // // // //   //           backgroundColor: Colors.red,
// // // // // // // //   //           duration: const Duration(seconds: 4),
// // // // // // // //   //         ),
// // // // // // // //   //       );
// // // // // // // //   //     }
// // // // // // // //   //   }
// // // // // // // //   // }

// // // // // // // //   // Updated method to share poster with selected customers via WhatsApp
// // // // // // // //   Future<void> _sharePosterWithSelectedCustomers(
// // // // // // // //     Set<String> selectedCustomerIds,
// // // // // // // //     List<Map<String, dynamic>> allCustomers,
// // // // // // // //   ) async {
// // // // // // // //     try {
// // // // // // // //       showDialog(
// // // // // // // //         context: context,
// // // // // // // //         barrierDismissible: false,
// // // // // // // //         builder: (context) => const AlertDialog(
// // // // // // // //           content: Row(
// // // // // // // //             children: [
// // // // // // // //               CircularProgressIndicator(),
// // // // // // // //               SizedBox(width: 16),
// // // // // // // //               Text('Preparing poster...'),
// // // // // // // //             ],
// // // // // // // //           ),
// // // // // // // //         ),
// // // // // // // //       );

// // // // // // // //       // Generate poster image
// // // // // // // //       RenderRepaintBoundary boundary =
// // // // // // // //           _canvasKey.currentContext!.findRenderObject()
// // // // // // // //               as RenderRepaintBoundary;
// // // // // // // //       ui.Image image = await boundary.toImage(pixelRatio: 3.0);
// // // // // // // //       ByteData? byteData = await image.toByteData(
// // // // // // // //         format: ui.ImageByteFormat.png,
// // // // // // // //       );
// // // // // // // //       Uint8List pngBytes = byteData!.buffer.asUint8List();

// // // // // // // //       final directory = await getTemporaryDirectory();
// // // // // // // //       final file = File(
// // // // // // // //         '${directory.path}/poster_share_${DateTime.now().millisecondsSinceEpoch}.png',
// // // // // // // //       );
// // // // // // // //       await file.writeAsBytes(pngBytes);

// // // // // // // //       Navigator.of(context).pop(); // Close loading dialog

// // // // // // // //       // Get selected customers
// // // // // // // //       final selectedCustomers = allCustomers
// // // // // // // //           .where((c) => selectedCustomerIds.contains(c['_id']))
// // // // // // // //           .toList();

// // // // // // // //       if (selectedCustomers.isEmpty) {
// // // // // // // //         ScaffoldMessenger.of(context).showSnackBar(
// // // // // // // //           const SnackBar(
// // // // // // // //             content: Text('No customers selected'),
// // // // // // // //             backgroundColor: Colors.orange,
// // // // // // // //           ),
// // // // // // // //         );
// // // // // // // //         return;
// // // // // // // //       }

// // // // // // // //       // Show confirmation dialog with customer list
// // // // // // // //       final shouldProceed = await showDialog<bool>(
// // // // // // // //         context: context,
// // // // // // // //         builder: (context) => AlertDialog(
// // // // // // // //           title: const Text('Share Poster'),
// // // // // // // //           content: Column(
// // // // // // // //             mainAxisSize: MainAxisSize.min,
// // // // // // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // //             children: [
// // // // // // // //               Text(
// // // // // // // //                 'Share poster with ${selectedCustomers.length} customer${selectedCustomers.length != 1 ? 's' : ''}?',
// // // // // // // //                 style: const TextStyle(fontWeight: FontWeight.bold),
// // // // // // // //               ),
// // // // // // // //               const SizedBox(height: 16),
// // // // // // // //               const Text(
// // // // // // // //                 'The poster will be shared via WhatsApp. You\'ll need to send it to each customer individually.',
// // // // // // // //                 style: TextStyle(fontSize: 12, color: Colors.grey),
// // // // // // // //               ),
// // // // // // // //               const SizedBox(height: 16),
// // // // // // // //               Container(
// // // // // // // //                 constraints: const BoxConstraints(maxHeight: 200),
// // // // // // // //                 child: SingleChildScrollView(
// // // // // // // //                   child: Column(
// // // // // // // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // //                     children: selectedCustomers.map((customer) {
// // // // // // // //                       return Padding(
// // // // // // // //                         padding: const EdgeInsets.symmetric(vertical: 4),
// // // // // // // //                         child: Row(
// // // // // // // //                           children: [
// // // // // // // //                             const Icon(
// // // // // // // //                               Icons.person,
// // // // // // // //                               size: 16,
// // // // // // // //                               color: Colors.deepPurple,
// // // // // // // //                             ),
// // // // // // // //                             const SizedBox(width: 8),
// // // // // // // //                             Expanded(
// // // // // // // //                               child: Text(
// // // // // // // //                                 '${customer['name']} - ${customer['mobile']}',
// // // // // // // //                                 style: const TextStyle(fontSize: 13),
// // // // // // // //                               ),
// // // // // // // //                             ),
// // // // // // // //                           ],
// // // // // // // //                         ),
// // // // // // // //                       );
// // // // // // // //                     }).toList(),
// // // // // // // //                   ),
// // // // // // // //                 ),
// // // // // // // //               ),
// // // // // // // //             ],
// // // // // // // //           ),
// // // // // // // //           actions: [
// // // // // // // //             TextButton(
// // // // // // // //               onPressed: () => Navigator.pop(context, false),
// // // // // // // //               child: const Text('Cancel'),
// // // // // // // //             ),
// // // // // // // //             ElevatedButton(
// // // // // // // //               onPressed: () => Navigator.pop(context, true),
// // // // // // // //               style: ElevatedButton.styleFrom(
// // // // // // // //                 backgroundColor: Colors.deepPurple,
// // // // // // // //                 foregroundColor: Colors.white,
// // // // // // // //               ),
// // // // // // // //               child: const Text('Continue'),
// // // // // // // //             ),
// // // // // // // //           ],
// // // // // // // //         ),
// // // // // // // //       );

// // // // // // // //       if (shouldProceed != true) return;

// // // // // // // //       // Share with each customer one by one
// // // // // // // //       int currentIndex = 0;

// // // // // // // //       for (var customer in selectedCustomers) {
// // // // // // // //         currentIndex++;
// // // // // // // //         final mobile = customer['mobile']?.toString() ?? '';
// // // // // // // //         final name = customer['name']?.toString() ?? 'Customer';

// // // // // // // //         if (mobile.isEmpty) {
// // // // // // // //           ScaffoldMessenger.of(context).showSnackBar(
// // // // // // // //             SnackBar(
// // // // // // // //               content: Text('No mobile number for $name'),
// // // // // // // //               backgroundColor: Colors.orange,
// // // // // // // //               duration: const Duration(seconds: 2),
// // // // // // // //             ),
// // // // // // // //           );
// // // // // // // //           continue;
// // // // // // // //         }

// // // // // // // //         try {
// // // // // // // //           // Clean phone number
// // // // // // // //           String cleanNumber = mobile.replaceAll(RegExp(r'[^\d+]'), '');
// // // // // // // //           if (!cleanNumber.startsWith('+')) {
// // // // // // // //             if (cleanNumber.length == 10) {
// // // // // // // //               cleanNumber = '+91$cleanNumber';
// // // // // // // //             }
// // // // // // // //           }

// // // // // // // //           // Show progress
// // // // // // // //           ScaffoldMessenger.of(context).showSnackBar(
// // // // // // // //             SnackBar(
// // // // // // // //               content: Text(
// // // // // // // //                 'Sharing with $name ($currentIndex/${selectedCustomers.length})',
// // // // // // // //               ),
// // // // // // // //               backgroundColor: Colors.blue,
// // // // // // // //               duration: const Duration(seconds: 2),
// // // // // // // //             ),
// // // // // // // //           );

// // // // // // // //           // Share via WhatsApp with the specific phone number
// // // // // // // //           final result = await Share.shareXFiles([
// // // // // // // //             XFile(file.path),
// // // // // // // //           ], text: 'Hi $name, check out this poster!');

// // // // // // // //           // Add delay between shares to allow user to send each one
// // // // // // // //           if (currentIndex < selectedCustomers.length) {
// // // // // // // //             await Future.delayed(const Duration(seconds: 2));
// // // // // // // //           }
// // // // // // // //         } catch (e) {
// // // // // // // //           debugPrint('Error sharing with $name: $e');
// // // // // // // //           ScaffoldMessenger.of(context).showSnackBar(
// // // // // // // //             SnackBar(
// // // // // // // //               content: Text('Error sharing with $name: $e'),
// // // // // // // //               backgroundColor: Colors.red,
// // // // // // // //               duration: const Duration(seconds: 3),
// // // // // // // //             ),
// // // // // // // //           );
// // // // // // // //         }
// // // // // // // //       }

// // // // // // // //       // Show completion message
// // // // // // // //       if (mounted) {
// // // // // // // //         ScaffoldMessenger.of(context).showSnackBar(
// // // // // // // //           SnackBar(
// // // // // // // //             content: Text(
// // // // // // // //               'Sharing process completed for ${selectedCustomers.length} customers',
// // // // // // // //             ),
// // // // // // // //             backgroundColor: Colors.green,
// // // // // // // //             duration: const Duration(seconds: 3),
// // // // // // // //             action: SnackBarAction(
// // // // // // // //               label: 'OK',
// // // // // // // //               textColor: Colors.white,
// // // // // // // //               onPressed: () {},
// // // // // // // //             ),
// // // // // // // //           ),
// // // // // // // //         );
// // // // // // // //       }
// // // // // // // //     } catch (e) {
// // // // // // // //       if (Navigator.of(context).canPop()) {
// // // // // // // //         Navigator.of(context).pop();
// // // // // // // //       }

// // // // // // // //       if (mounted) {
// // // // // // // //         ScaffoldMessenger.of(context).showSnackBar(
// // // // // // // //           SnackBar(
// // // // // // // //             content: Text('Error preparing poster: $e'),
// // // // // // // //             backgroundColor: Colors.red,
// // // // // // // //             duration: const Duration(seconds: 4),
// // // // // // // //           ),
// // // // // // // //         );
// // // // // // // //       }
// // // // // // // //     }
// // // // // // // //   }

// // // // // // // //   void _selectTextElement(TextElement element) {
// // // // // // // //     setState(() {
// // // // // // // //       for (var el in _template!.textElements) {
// // // // // // // //         el.isSelected = false;
// // // // // // // //       }
// // // // // // // //       for (var el in _template!.imageElements) {
// // // // // // // //         el.isSelected = false;
// // // // // // // //       }
// // // // // // // //       if (_profileImageElement != null)
// // // // // // // //         _profileImageElement!.isSelected = false;
// // // // // // // //       if (_logoImageElement != null) _logoImageElement!.isSelected = false;

// // // // // // // //       element.isSelected = true;
// // // // // // // //       _selectedTextElement = element;
// // // // // // // //       _selectedImageElement = null;
// // // // // // // //       _showToolbar = true;
// // // // // // // //     });
// // // // // // // //   }

// // // // // // // //   void _selectImageElement(ImageElement element) {
// // // // // // // //     setState(() {
// // // // // // // //       for (var el in _template!.textElements) {
// // // // // // // //         el.isSelected = false;
// // // // // // // //       }
// // // // // // // //       for (var el in _template!.imageElements) {
// // // // // // // //         el.isSelected = false;
// // // // // // // //       }
// // // // // // // //       if (_profileImageElement != null)
// // // // // // // //         _profileImageElement!.isSelected = false;
// // // // // // // //       if (_logoImageElement != null) _logoImageElement!.isSelected = false;

// // // // // // // //       element.isSelected = true;
// // // // // // // //       _selectedImageElement = element;
// // // // // // // //       _selectedTextElement = null;
// // // // // // // //       _showToolbar = true;
// // // // // // // //     });
// // // // // // // //   }

// // // // // // // //   // void _selectProfileImageElement(ProfileElement element) {
// // // // // // // //   //   setState(() {
// // // // // // // //   //     for (var el in _template!.textElements) {
// // // // // // // //   //       el.isSelected = false;
// // // // // // // //   //     }
// // // // // // // //   //     for (var el in _template!.imageElements) {
// // // // // // // //   //       el.isSelected = false;
// // // // // // // //   //     }
// // // // // // // //   //     if (_profileImageElement != null)
// // // // // // // //   //       _profileImageElement!.isSelected = false;
// // // // // // // //   //     if (_logoImageElement != null) _logoImageElement!.isSelected = false;

// // // // // // // //   //     element.isSelected = true;
// // // // // // // //   //     _selectedProfileImageElement = element;
// // // // // // // //   //     _selectedTextElement = null;
// // // // // // // //   //     _showToolbar = true;
// // // // // // // //   //   });
// // // // // // // //   // }

// // // // // // // //   void _selectProfileImageElement(ProfileElement element) {
// // // // // // // //     setState(() {
// // // // // // // //       // Deselect all other elements
// // // // // // // //       for (var el in _template!.textElements) {
// // // // // // // //         el.isSelected = false;
// // // // // // // //       }
// // // // // // // //       for (var el in _template!.imageElements) {
// // // // // // // //         el.isSelected = false;
// // // // // // // //       }
// // // // // // // //       if (_logoImageElement != null) _logoImageElement!.isSelected = false;

// // // // // // // //       // Select the profile image
// // // // // // // //       element.isSelected = true;
// // // // // // // //       _selectedProfileImageElement = element;
// // // // // // // //       _selectedTextElement = null;
// // // // // // // //       _selectedImageElement = null;
// // // // // // // //       _showToolbar = true;
// // // // // // // //     });
// // // // // // // //   }

// // // // // // // //   void _updateImageElementPosition(ImageElement element, Offset delta) {
// // // // // // // //     setState(() {
// // // // // // // //       final scaledDelta = delta / _scaleFactor;
// // // // // // // //       element.x += scaledDelta.dx;
// // // // // // // //       element.y += scaledDelta.dy;
// // // // // // // //       element.x = element.x.clamp(0, _template!.width - element.width);
// // // // // // // //       element.y = element.y.clamp(0, _template!.height - element.height);
// // // // // // // //     });
// // // // // // // //   }

// // // // // // // //   void _updateProfileImageElementPosition(
// // // // // // // //     ProfileElement element,
// // // // // // // //     Offset delta,
// // // // // // // //   ) {
// // // // // // // //     setState(() {
// // // // // // // //       final scaledDelta = delta / _scaleFactor;
// // // // // // // //       element.x += scaledDelta.dx;
// // // // // // // //       element.y += scaledDelta.dy;
// // // // // // // //       element.x = element.x.clamp(0, _template!.width - element.width);
// // // // // // // //       element.y = element.y.clamp(0, _template!.height - element.height);
// // // // // // // //     });
// // // // // // // //   }

// // // // // // // //   void _updateImageElementSize(ImageElement element, double scale) {
// // // // // // // //     setState(() {
// // // // // // // //       final newWidth = (_baseScale * scale).clamp(50.0, _template!.width * 0.8);
// // // // // // // //       final newHeight = (_baseScale * scale).clamp(
// // // // // // // //         50.0,
// // // // // // // //         _template!.height * 0.8,
// // // // // // // //       );

// // // // // // // //       element.width = newWidth;
// // // // // // // //       element.height = newHeight;
// // // // // // // //     });
// // // // // // // //   }

// // // // // // // //   void _updateProfileImageElementSize(ProfileElement element, double scale) {
// // // // // // // //     setState(() {
// // // // // // // //       final newWidth = (_baseScale * scale).clamp(50.0, _template!.width * 0.8);
// // // // // // // //       final newHeight = (_baseScale * scale).clamp(
// // // // // // // //         50.0,
// // // // // // // //         _template!.height * 0.8,
// // // // // // // //       );

// // // // // // // //       element.width = newWidth;
// // // // // // // //       element.height = newHeight;
// // // // // // // //     });
// // // // // // // //   }

// // // // // // // //   void _zoomImageElement(ImageElement element, double scaleFactor) {
// // // // // // // //     setState(() {
// // // // // // // //       final newWidth = (element.width * scaleFactor).clamp(
// // // // // // // //         20.0,
// // // // // // // //         _template!.width * 0.9,
// // // // // // // //       );
// // // // // // // //       final newHeight = (element.height * scaleFactor).clamp(
// // // // // // // //         20.0,
// // // // // // // //         _template!.height * 0.9,
// // // // // // // //       );

// // // // // // // //       // Calculate center point to maintain position during zoom
// // // // // // // //       final centerX = element.x + element.width / 2;
// // // // // // // //       final centerY = element.y + element.height / 2;

// // // // // // // //       element.width = newWidth;
// // // // // // // //       element.height = newHeight;

// // // // // // // //       // Reposition to maintain center
// // // // // // // //       element.x = (centerX - newWidth / 2).clamp(
// // // // // // // //         0,
// // // // // // // //         _template!.width - newWidth,
// // // // // // // //       );
// // // // // // // //       element.y = (centerY - newHeight / 2).clamp(
// // // // // // // //         0,
// // // // // // // //         _template!.height - newHeight,
// // // // // // // //       );
// // // // // // // //     });
// // // // // // // //   }

// // // // // // // //   // void _deselectAll() {
// // // // // // // //   //   setState(() {
// // // // // // // //   //     if (_template != null) {
// // // // // // // //   //       for (var el in _template!.textElements) {
// // // // // // // //   //         el.isSelected = false;
// // // // // // // //   //       }
// // // // // // // //   //       for (var el in _template!.imageElements) {
// // // // // // // //   //         el.isSelected = false;
// // // // // // // //   //       }
// // // // // // // //   //     }
// // // // // // // //   //     if (_profileImageElement != null)
// // // // // // // //   //       _profileImageElement!.isSelected = false;
// // // // // // // //   //     if (_logoImageElement != null) _logoImageElement!.isSelected = false;

// // // // // // // //   //     _selectedTextElement = null;
// // // // // // // //   //     _selectedImageElement = null;
// // // // // // // //   //     _showToolbar = false;
// // // // // // // //   //   });
// // // // // // // //   // }

// // // // // // // //   void _deselectAll() {
// // // // // // // //     setState(() {
// // // // // // // //       if (_template != null) {
// // // // // // // //         for (var el in _template!.textElements) {
// // // // // // // //           el.isSelected = false;
// // // // // // // //         }
// // // // // // // //         for (var el in _template!.imageElements) {
// // // // // // // //           el.isSelected = false;
// // // // // // // //         }
// // // // // // // //       }
// // // // // // // //       if (_profileImageElement != null)
// // // // // // // //         _profileImageElement!.isSelected = false;
// // // // // // // //       if (_logoImageElement != null) _logoImageElement!.isSelected = false;

// // // // // // // //       _selectedTextElement = null;
// // // // // // // //       _selectedImageElement = null;
// // // // // // // //       _selectedProfileImageElement = null;
// // // // // // // //       _showToolbar = false;
// // // // // // // //     });
// // // // // // // //   }

// // // // // // // //   void _updateTextElementPosition(TextElement element, Offset delta) {
// // // // // // // //     setState(() {
// // // // // // // //       final scaledDelta = delta / _scaleFactor;
// // // // // // // //       element.x += scaledDelta.dx;
// // // // // // // //       element.y += scaledDelta.dy;

// // // // // // // //       // Very permissive bounds for large text elements
// // // // // // // //       element.x = element.x.clamp(
// // // // // // // //         -_template!.width * 0.5, // Allow 50% outside left
// // // // // // // //         _template!.width * 1.5, // Allow 50% outside right
// // // // // // // //       );
// // // // // // // //       element.y = element.y.clamp(
// // // // // // // //         -_template!.height * 0.5, // Allow 50% outside top
// // // // // // // //         _template!.height * 1.5, // Allow 50% outside bottom
// // // // // // // //       );
// // // // // // // //     });
// // // // // // // //   }

// // // // // // // //   void _showTextEditDialog() {
// // // // // // // //     if (_selectedTextElement == null) return;

// // // // // // // //     final controller = TextEditingController(text: _selectedTextElement!.text);

// // // // // // // //     showDialog(
// // // // // // // //       context: context,
// // // // // // // //       builder: (context) => AlertDialog(
// // // // // // // //         title: const Text('Edit Text'),
// // // // // // // //         content: TextField(
// // // // // // // //           controller: controller,
// // // // // // // //           maxLines: null,
// // // // // // // //           decoration: const InputDecoration(
// // // // // // // //             hintText: 'Enter text...',
// // // // // // // //             border: OutlineInputBorder(),
// // // // // // // //           ),
// // // // // // // //         ),
// // // // // // // //         actions: [
// // // // // // // //           TextButton(
// // // // // // // //             onPressed: () => Navigator.pop(context),
// // // // // // // //             child: const Text('Cancel'),
// // // // // // // //           ),
// // // // // // // //           TextButton(
// // // // // // // //             onPressed: () {
// // // // // // // //               setState(() {
// // // // // // // //                 _selectedTextElement!.text = controller.text;
// // // // // // // //               });
// // // // // // // //               Navigator.pop(context);
// // // // // // // //             },
// // // // // // // //             child: const Text('Save'),
// // // // // // // //           ),
// // // // // // // //         ],
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   void _addNewTextElement() {
// // // // // // // //     if (_template == null) return;

// // // // // // // //     final newElement = TextElement(
// // // // // // // //       id: 'text_${DateTime.now().millisecondsSinceEpoch}',
// // // // // // // //       text: '',
// // // // // // // //       x: 350,
// // // // // // // //       y: 350,
// // // // // // // //       width: 200,
// // // // // // // //       height: 50,
// // // // // // // //       fontSize: 50,
// // // // // // // //       color: Colors.black,
// // // // // // // //       fontWeight: FontWeight.normal,
// // // // // // // //       fontFamily: 'Arial',
// // // // // // // //       textAlign: TextAlign.left,
// // // // // // // //     );

// // // // // // // //     setState(() {
// // // // // // // //       _template!.textElements.add(newElement);
// // // // // // // //       _selectTextElement(newElement);
// // // // // // // //     });
// // // // // // // //   }

// // // // // // // //   void _deleteSelectedElement() {
// // // // // // // //     if (_selectedTextElement != null && _template != null) {
// // // // // // // //       setState(() {
// // // // // // // //         _template!.textElements.remove(_selectedTextElement);
// // // // // // // //         _selectedTextElement = null;
// // // // // // // //         _showToolbar = false;
// // // // // // // //       });
// // // // // // // //     } else if (_selectedImageElement != null && _template != null) {
// // // // // // // //       setState(() {
// // // // // // // //         // Check if it's logo image
// // // // // // // //         if (_selectedImageElement!.id == 'logo_image') {
// // // // // // // //           _logoImageElement = null;
// // // // // // // //           _logoImage = null;
// // // // // // // //         } else {
// // // // // // // //           _template!.imageElements.remove(_selectedImageElement);
// // // // // // // //         }
// // // // // // // //         _selectedImageElement = null;
// // // // // // // //         _showToolbar = false;
// // // // // // // //       });
// // // // // // // //     } else if (_selectedProfileImageElement != null) {
// // // // // // // //       // Handle profile image deletion
// // // // // // // //       setState(() {
// // // // // // // //         _profileImageElement = null;
// // // // // // // //         _profileImageBytes = null;
// // // // // // // //         _selectedProfileImageElement = null;
// // // // // // // //         _showToolbar = false;
// // // // // // // //       });

// // // // // // // //       // Show confirmation message
// // // // // // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // // // // // //         const SnackBar(
// // // // // // // //           content: Text('Profile image deleted'),
// // // // // // // //           backgroundColor: Colors.orange,
// // // // // // // //           duration: Duration(seconds: 2),
// // // // // // // //         ),
// // // // // // // //       );
// // // // // // // //     }
// // // // // // // //   }

// // // // // // // //   Future<void> savePoster() async {
// // // // // // // //     try {
// // // // // // // //       showDialog(
// // // // // // // //         context: context,
// // // // // // // //         barrierDismissible: false,
// // // // // // // //         builder: (context) => const AlertDialog(
// // // // // // // //           content: Row(
// // // // // // // //             children: [
// // // // // // // //               CircularProgressIndicator(),
// // // // // // // //               SizedBox(width: 13),
// // // // // // // //               Text('Saving poster to gallery...'),
// // // // // // // //             ],
// // // // // // // //           ),
// // // // // // // //         ),
// // // // // // // //       );

// // // // // // // //       RenderRepaintBoundary boundary =
// // // // // // // //           _canvasKey.currentContext!.findRenderObject()
// // // // // // // //               as RenderRepaintBoundary;

// // // // // // // //       ui.Image image = await boundary.toImage(pixelRatio: 3.0);
// // // // // // // //       ByteData? byteData = await image.toByteData(
// // // // // // // //         format: ui.ImageByteFormat.png,
// // // // // // // //       );
// // // // // // // //       Uint8List pngBytes = byteData!.buffer.asUint8List();

// // // // // // // //       await Gal.putImageBytes(
// // // // // // // //         pngBytes,
// // // // // // // //         album: 'Posters',
// // // // // // // //         name: 'poster_${DateTime.now().millisecondsSinceEpoch}.png',
// // // // // // // //       );

// // // // // // // //       Navigator.of(context).pop();

// // // // // // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // // // // // //         const SnackBar(
// // // // // // // //           content: Text('Poster saved to gallery successfully!'),
// // // // // // // //           backgroundColor: Colors.green,
// // // // // // // //           duration: Duration(seconds: 3),
// // // // // // // //         ),
// // // // // // // //       );
// // // // // // // //     } catch (e) {
// // // // // // // //       if (Navigator.of(context).canPop()) {
// // // // // // // //         Navigator.of(context).pop();
// // // // // // // //       }

// // // // // // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // // // // // //         SnackBar(
// // // // // // // //           content: Text('Error saving poster: $e'),
// // // // // // // //           backgroundColor: Colors.red,
// // // // // // // //           duration: const Duration(seconds: 4),
// // // // // // // //         ),
// // // // // // // //       );
// // // // // // // //     }
// // // // // // // //   }

// // // // // // // //   Future<void> _sharePoster() async {
// // // // // // // //     try {
// // // // // // // //       showDialog(
// // // // // // // //         context: context,
// // // // // // // //         barrierDismissible: false,
// // // // // // // //         builder: (context) => const AlertDialog(
// // // // // // // //           content: Row(
// // // // // // // //             children: [
// // // // // // // //               CircularProgressIndicator(),
// // // // // // // //               SizedBox(width: 12),
// // // // // // // //               Text('Preparing poster for\n sharing...'),
// // // // // // // //             ],
// // // // // // // //           ),
// // // // // // // //         ),
// // // // // // // //       );

// // // // // // // //       RenderRepaintBoundary boundary =
// // // // // // // //           _canvasKey.currentContext!.findRenderObject()
// // // // // // // //               as RenderRepaintBoundary;

// // // // // // // //       ui.Image image = await boundary.toImage(pixelRatio: 3.0);
// // // // // // // //       ByteData? byteData = await image.toByteData(
// // // // // // // //         format: ui.ImageByteFormat.png,
// // // // // // // //       );
// // // // // // // //       Uint8List pngBytes = byteData!.buffer.asUint8List();

// // // // // // // //       final directory = await getTemporaryDirectory();
// // // // // // // //       final file = File(
// // // // // // // //         '${directory.path}/poster_share_${DateTime.now().millisecondsSinceEpoch}.png',
// // // // // // // //       );
// // // // // // // //       await file.writeAsBytes(pngBytes);

// // // // // // // //       Navigator.of(context).pop();

// // // // // // // //       await Share.shareXFiles([XFile(file.path)], text: 'Check out my poster!');
// // // // // // // //     } catch (e) {
// // // // // // // //       if (Navigator.of(context).canPop()) {
// // // // // // // //         Navigator.of(context).pop();
// // // // // // // //       }

// // // // // // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // // // // // //         SnackBar(
// // // // // // // //           content: Text('Error sharing poster: $e'),
// // // // // // // //           backgroundColor: Colors.red,
// // // // // // // //           duration: const Duration(seconds: 4),
// // // // // // // //         ),
// // // // // // // //       );
// // // // // // // //     }
// // // // // // // //   }

// // // // // // // //   Widget _buildProfileImage() {
// // // // // // // //     if (_profileImageBytes == null || _profileImageElement == null) {
// // // // // // // //       return const SizedBox.shrink();
// // // // // // // //     }

// // // // // // // //     return Positioned(
// // // // // // // //       left: _profileImageElement!.x,
// // // // // // // //       top: _profileImageElement!.y,
// // // // // // // //       width: _profileImageElement!.width,
// // // // // // // //       height: _profileImageElement!.height,
// // // // // // // //       child: GestureDetector(
// // // // // // // //         onTap: () => _selectProfileImageElement(_profileImageElement!),
// // // // // // // //         onScaleStart: (details) {
// // // // // // // //           _baseScale = _profileImageElement!.width;
// // // // // // // //           _initialFocalPoint = details.focalPoint;
// // // // // // // //         },
// // // // // // // //         onScaleUpdate: (details) {
// // // // // // // //           // Handle scaling (when scale != 1.0)
// // // // // // // //           if (details.scale != 1.0) {
// // // // // // // //             _updateProfileImageElementSize(
// // // // // // // //               _profileImageElement!,
// // // // // // // //               details.scale,
// // // // // // // //             );
// // // // // // // //           }

// // // // // // // //           // Handle panning (when focalPoint changes)
// // // // // // // //           if (_initialFocalPoint != null) {
// // // // // // // //             final delta = details.focalPoint - _initialFocalPoint!;
// // // // // // // //             _updateProfileImageElementPosition(_profileImageElement!, delta);
// // // // // // // //             _initialFocalPoint = details.focalPoint;
// // // // // // // //           }
// // // // // // // //         },
// // // // // // // //         onScaleEnd: (details) {
// // // // // // // //           _initialFocalPoint = null;
// // // // // // // //         },
// // // // // // // //         child: Transform.rotate(
// // // // // // // //           angle: _profileImageElement!.rotation * 3.14159 / 180,
// // // // // // // //           child: Container(
// // // // // // // //             decoration: _profileImageElement!.isSelected
// // // // // // // //                 ? BoxDecoration(
// // // // // // // //                     // border: Border.all(color: Colors.green, width: 2),
// // // // // // // //                     color: Colors.green.withOpacity(0.1),
// // // // // // // //                   )
// // // // // // // //                 : null,
// // // // // // // //             child: ClipRRect(
// // // // // // // //               borderRadius: BorderRadius.circular(100),
// // // // // // // //               child: Image.memory(_profileImageBytes!, fit: BoxFit.fill),
// // // // // // // //             ),
// // // // // // // //           ),
// // // // // // // //         ),
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   Widget _buildLogoImage() {
// // // // // // // //     if (_logoImage == null || _logoImageElement == null) {
// // // // // // // //       return const SizedBox.shrink();
// // // // // // // //     }

// // // // // // // //     return Positioned(
// // // // // // // //       left: _logoImageElement!.x,
// // // // // // // //       top: _logoImageElement!.y,
// // // // // // // //       width: _logoImageElement!.width,
// // // // // // // //       height: _logoImageElement!.height,
// // // // // // // //       child: GestureDetector(
// // // // // // // //         onTap: () => _selectImageElement(_logoImageElement!),
// // // // // // // //         onScaleStart: (details) {
// // // // // // // //           _baseScale = _logoImageElement!.width;
// // // // // // // //           _initialFocalPoint = details.focalPoint;
// // // // // // // //         },
// // // // // // // //         onScaleUpdate: (details) {
// // // // // // // //           // Handle scaling (when scale != 1.0)
// // // // // // // //           if (details.scale != 1.0) {
// // // // // // // //             _updateImageElementSize(_logoImageElement!, details.scale);
// // // // // // // //           }

// // // // // // // //           // Handle panning (when focalPoint changes)
// // // // // // // //           if (_initialFocalPoint != null) {
// // // // // // // //             final delta = details.focalPoint - _initialFocalPoint!;
// // // // // // // //             _updateImageElementPosition(_logoImageElement!, delta);
// // // // // // // //             _initialFocalPoint = details.focalPoint;
// // // // // // // //           }
// // // // // // // //         },
// // // // // // // //         onScaleEnd: (details) {
// // // // // // // //           _initialFocalPoint = null;
// // // // // // // //         },
// // // // // // // //         child: Transform.rotate(
// // // // // // // //           angle: _logoImageElement!.rotation * 3.14159 / 180,
// // // // // // // //           child: Container(
// // // // // // // //             decoration: _logoImageElement!.isSelected
// // // // // // // //                 ? BoxDecoration(
// // // // // // // //                     // border: Border.all(color: Colors.green, width: 2),
// // // // // // // //                     color: Colors.green.withOpacity(0.1),
// // // // // // // //                   )
// // // // // // // //                 : null,
// // // // // // // //             child: ClipRRect(
// // // // // // // //               borderRadius: BorderRadius.circular(50),
// // // // // // // //               child: Image.memory(_logoImage!, fit: BoxFit.cover),
// // // // // // // //             ),
// // // // // // // //           ),
// // // // // // // //         ),
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   Widget _buildTextElement(TextElement element) {
// // // // // // // //     return Positioned(
// // // // // // // //       left: element.x,
// // // // // // // //       top: element.y,
// // // // // // // //       child: GestureDetector(
// // // // // // // //         onTap: () => _selectTextElement(element),
// // // // // // // //         onPanUpdate: (details) {
// // // // // // // //           _updateTextElementPosition(element, details.delta);
// // // // // // // //         },
// // // // // // // //         child: Transform.rotate(
// // // // // // // //           angle: element.rotation * 3.14159 / 180,
// // // // // // // //           child: Container(
// // // // // // // //             // Flexible constraints that allow for very large text
// // // // // // // //             constraints: BoxConstraints(
// // // // // // // //               minWidth: 50,
// // // // // // // //               maxWidth:
// // // // // // // //                   _template!.width * 3, // Triple canvas width for large text
// // // // // // // //               minHeight: 20,
// // // // // // // //               maxHeight: _template!.height * 3, // Triple canvas height
// // // // // // // //             ),
// // // // // // // //             decoration: element.isSelected
// // // // // // // //                 ? BoxDecoration(
// // // // // // // //                     // border: Border.all(color: Colors.green, width: 2),
// // // // // // // //                   )
// // // // // // // //                 : null,
// // // // // // // //             child: ConstrainedBox(
// // // // // // // //               constraints: BoxConstraints(
// // // // // // // //                 maxWidth: _template!.width * 2, // Double canvas width
// // // // // // // //                 maxHeight: _template!.height * 2, // Double canvas height
// // // // // // // //               ),
// // // // // // // //               child: SingleChildScrollView(
// // // // // // // //                 scrollDirection: Axis.horizontal,
// // // // // // // //                 child: SingleChildScrollView(
// // // // // // // //                   scrollDirection: Axis.vertical,
// // // // // // // //                   child: Text(
// // // // // // // //                     element.text,
// // // // // // // //                     style: TextStyle(
// // // // // // // //                       fontSize: element.fontSize,
// // // // // // // //                       color: element.color,
// // // // // // // //                       fontWeight: element.fontWeight,
// // // // // // // //                       fontFamily: element.fontFamily,
// // // // // // // //                       height: 1.2, // Better line spacing for large text
// // // // // // // //                     ),
// // // // // // // //                     textAlign: element.textAlign,
// // // // // // // //                     maxLines: null,
// // // // // // // //                     overflow: TextOverflow.visible,
// // // // // // // //                     softWrap: true,
// // // // // // // //                   ),
// // // // // // // //                 ),
// // // // // // // //               ),
// // // // // // // //             ),
// // // // // // // //           ),
// // // // // // // //         ),
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   Widget _buildImageElement(ImageElement element) {
// // // // // // // //     return Positioned(
// // // // // // // //       left: element.x,
// // // // // // // //       top: element.y,
// // // // // // // //       width: element.width,
// // // // // // // //       height: element.height,
// // // // // // // //       child: GestureDetector(
// // // // // // // //         onTap: () => _selectImageElement(element),
// // // // // // // //         onScaleStart: (details) {
// // // // // // // //           _baseScale = element.width;
// // // // // // // //           _initialFocalPoint = details.focalPoint;
// // // // // // // //         },
// // // // // // // //         onScaleUpdate: (details) {
// // // // // // // //           if (details.scale != 1.0) {
// // // // // // // //             _updateImageElementSize(element, details.scale);
// // // // // // // //           }
// // // // // // // //           if (_initialFocalPoint != null) {
// // // // // // // //             final delta = details.focalPoint - _initialFocalPoint!;
// // // // // // // //             _updateImageElementPosition(element, delta);
// // // // // // // //             _initialFocalPoint = details.focalPoint;
// // // // // // // //           }
// // // // // // // //         },
// // // // // // // //         onScaleEnd: (details) {
// // // // // // // //           _initialFocalPoint = null;
// // // // // // // //         },
// // // // // // // //         child: Transform.rotate(
// // // // // // // //           angle: element.rotation * 3.14159 / 180,
// // // // // // // //           child: Container(
// // // // // // // //             decoration: element.isSelected
// // // // // // // //                 ? BoxDecoration(
// // // // // // // //                     // border: Border.all(color: Colors.green, width: 2),
// // // // // // // //                     color: Colors.green.withOpacity(0.1),
// // // // // // // //                   )
// // // // // // // //                 : null,
// // // // // // // //             child: ClipRRect(
// // // // // // // //               borderRadius: BorderRadius.circular(
// // // // // // // //                 // Use the dynamic borderRadius property
// // // // // // // //                 element.id == 'logo_image' || element.id == 'profile_image'
// // // // // // // //                     ? 50
// // // // // // // //                     : element.borderRadius,
// // // // // // // //               ),
// // // // // // // //               child: element.imageUrl.isNotEmpty
// // // // // // // //                   ? (element.imageUrl.startsWith('http')
// // // // // // // //                         ? Image.network(
// // // // // // // //                             element.imageUrl,
// // // // // // // //                             fit: BoxFit.cover,
// // // // // // // //                             loadingBuilder: (context, child, loadingProgress) {
// // // // // // // //                               if (loadingProgress == null) return child;
// // // // // // // //                               return Container(
// // // // // // // //                                 color: Colors.grey[200],
// // // // // // // //                                 child: Center(
// // // // // // // //                                   child: SizedBox(
// // // // // // // //                                     width: 20,
// // // // // // // //                                     height: 20,
// // // // // // // //                                     child: CircularProgressIndicator(
// // // // // // // //                                       strokeWidth: 2,
// // // // // // // //                                       value:
// // // // // // // //                                           loadingProgress.expectedTotalBytes !=
// // // // // // // //                                               null
// // // // // // // //                                           ? loadingProgress
// // // // // // // //                                                     .cumulativeBytesLoaded /
// // // // // // // //                                                 loadingProgress
// // // // // // // //                                                     .expectedTotalBytes!
// // // // // // // //                                           : null,
// // // // // // // //                                     ),
// // // // // // // //                                   ),
// // // // // // // //                                 ),
// // // // // // // //                               );
// // // // // // // //                             },
// // // // // // // //                             errorBuilder: (context, error, stackTrace) {
// // // // // // // //                               return Container(
// // // // // // // //                                 color: Colors.grey.shade300,
// // // // // // // //                                 child: const Center(
// // // // // // // //                                   child: Column(
// // // // // // // //                                     mainAxisAlignment: MainAxisAlignment.center,
// // // // // // // //                                     children: [
// // // // // // // //                                       Icon(
// // // // // // // //                                         Icons.error,
// // // // // // // //                                         color: Colors.red,
// // // // // // // //                                         size: 24,
// // // // // // // //                                       ),
// // // // // // // //                                       Text(
// // // // // // // //                                         'Image Error',
// // // // // // // //                                         style: TextStyle(fontSize: 10),
// // // // // // // //                                       ),
// // // // // // // //                                     ],
// // // // // // // //                                   ),
// // // // // // // //                                 ),
// // // // // // // //                               );
// // // // // // // //                             },
// // // // // // // //                           )
// // // // // // // //                         : Image.file(File(element.imageUrl), fit: BoxFit.fill))
// // // // // // // //                   : Container(
// // // // // // // //                       color: Colors.grey.shade300,
// // // // // // // //                       child: const Center(
// // // // // // // //                         child: Icon(Icons.image, color: Colors.grey, size: 24),
// // // // // // // //                       ),
// // // // // // // //                     ),
// // // // // // // //             ),
// // // // // // // //           ),
// // // // // // // //         ),
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   Alignment _getAlignment(TextAlign textAlign) {
// // // // // // // //     switch (textAlign) {
// // // // // // // //       case TextAlign.center:
// // // // // // // //         return Alignment.center;
// // // // // // // //       case TextAlign.right:
// // // // // // // //         return Alignment.centerRight;
// // // // // // // //       default:
// // // // // // // //         return Alignment.centerLeft;
// // // // // // // //     }
// // // // // // // //   }

// // // // // // // //   Widget _buildToolbar() {
// // // // // // // //     if (_selectedTextElement == null &&
// // // // // // // //         _selectedImageElement == null &&
// // // // // // // //         _selectedProfileImageElement == null) {
// // // // // // // //       return const SizedBox.shrink();
// // // // // // // //     }

// // // // // // // //     return Container(
// // // // // // // //       padding: const EdgeInsets.all(8),
// // // // // // // //       color: Colors.white,
// // // // // // // //       child: SingleChildScrollView(
// // // // // // // //         scrollDirection: Axis.horizontal,
// // // // // // // //         child: Row(
// // // // // // // //           children: [
// // // // // // // //             if (_selectedTextElement != null) ...[
// // // // // // // //               IconButton(
// // // // // // // //                 icon: const Icon(Icons.edit, color: Colors.deepPurple),
// // // // // // // //                 onPressed: _showTextEditDialog,
// // // // // // // //                 tooltip: 'Edit Text',
// // // // // // // //               ),
// // // // // // // //               const VerticalDivider(width: 16),

// // // // // // // //               // Font Size Controls - Manual Input Button
// // // // // // // //               IconButton(
// // // // // // // //                 icon: const Icon(Icons.text_fields, color: Colors.deepPurple),
// // // // // // // //                 onPressed: _showManualSizeInputDialog,
// // // // // // // //                 tooltip: 'Enter Size Manually',
// // // // // // // //               ),
// // // // // // // //               const VerticalDivider(width: 16),

// // // // // // // //               // Font Size Slider for Text Elements (keep existing slider)
// // // // // // // //               const Text(
// // // // // // // //                 'Size: ',
// // // // // // // //                 style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
// // // // // // // //               ),
// // // // // // // //               SizedBox(
// // // // // // // //                 width: 150,
// // // // // // // //                 child: Slider(
// // // // // // // //                   value: _selectedTextElement!.fontSize,
// // // // // // // //                   min: 8.0,
// // // // // // // //                   max: 600.0,
// // // // // // // //                   divisions: 100,
// // // // // // // //                   label: '${_selectedTextElement!.fontSize.round()}',
// // // // // // // //                   onChanged: (value) {
// // // // // // // //                     setState(() {
// // // // // // // //                       _selectedTextElement!.fontSize = value;
// // // // // // // //                       if (value > 100) {
// // // // // // // //                         final textLength = _selectedTextElement!.text.length;
// // // // // // // //                         _selectedTextElement!.width = (textLength * value * 0.5)
// // // // // // // //                             .clamp(200.0, _template!.width * 2);
// // // // // // // //                         _selectedTextElement!.height = (value * 1.5).clamp(
// // // // // // // //                           50.0,
// // // // // // // //                           _template!.height * 2,
// // // // // // // //                         );
// // // // // // // //                       }
// // // // // // // //                     });
// // // // // // // //                   },
// // // // // // // //                 ),
// // // // // // // //               ),
// // // // // // // //               const VerticalDivider(width: 16),

// // // // // // // //               // Display current font size
// // // // // // // //               Container(
// // // // // // // //                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// // // // // // // //                 decoration: BoxDecoration(
// // // // // // // //                   border: Border.all(color: Colors.grey.shade300),
// // // // // // // //                   borderRadius: BorderRadius.circular(4),
// // // // // // // //                 ),
// // // // // // // //                 child: Text(
// // // // // // // //                   '${_selectedTextElement!.fontSize.round()}px',
// // // // // // // //                   style: const TextStyle(
// // // // // // // //                     fontWeight: FontWeight.bold,
// // // // // // // //                     fontSize: 12,
// // // // // // // //                   ),
// // // // // // // //                 ),
// // // // // // // //               ),
// // // // // // // //               const VerticalDivider(width: 16),

// // // // // // // //               // Rest of your existing toolbar code remains the same...
// // // // // // // //               IconButton(
// // // // // // // //                 icon: const Icon(Icons.fit_screen, color: Colors.deepPurple),
// // // // // // // //                 onPressed: () {
// // // // // // // //                   setState(() {
// // // // // // // //                     double estimatedWidth =
// // // // // // // //                         _selectedTextElement!.text.length *
// // // // // // // //                         _selectedTextElement!.fontSize *
// // // // // // // //                         0.6;
// // // // // // // //                     double estimatedHeight =
// // // // // // // //                         _selectedTextElement!.fontSize * 1.5;

// // // // // // // //                     _selectedTextElement!.width = estimatedWidth.clamp(
// // // // // // // //                       100.0,
// // // // // // // //                       _template!.width * 1.5,
// // // // // // // //                     );
// // // // // // // //                     _selectedTextElement!.height = estimatedHeight.clamp(
// // // // // // // //                       50.0,
// // // // // // // //                       _template!.height * 1.5,
// // // // // // // //                     );
// // // // // // // //                   });
// // // // // // // //                 },
// // // // // // // //                 tooltip: 'Auto-fit Size',
// // // // // // // //               ),

// // // // // // // //               // Font Family Dropdown
// // // // // // // //               Container(
// // // // // // // //                 padding: const EdgeInsets.symmetric(horizontal: 8),
// // // // // // // //                 decoration: BoxDecoration(
// // // // // // // //                   border: Border.all(color: Colors.grey.shade300),
// // // // // // // //                   borderRadius: BorderRadius.circular(4),
// // // // // // // //                 ),
// // // // // // // //                 child: DropdownButtonHideUnderline(
// // // // // // // //                   child: DropdownButton<String>(
// // // // // // // //                     value: _selectedTextElement!.fontFamily,
// // // // // // // //                     items: _fontFamilies
// // // // // // // //                         .toSet()
// // // // // // // //                         .map(
// // // // // // // //                           (font) => DropdownMenuItem(
// // // // // // // //                             value: font,
// // // // // // // //                             child: Text(
// // // // // // // //                               font,
// // // // // // // //                               style: TextStyle(fontFamily: font),
// // // // // // // //                             ),
// // // // // // // //                           ),
// // // // // // // //                         )
// // // // // // // //                         .toList(),
// // // // // // // //                     onChanged: (value) {
// // // // // // // //                       if (value != null) {
// // // // // // // //                         setState(() {
// // // // // // // //                           _selectedTextElement!.fontFamily = value;
// // // // // // // //                         });
// // // // // // // //                       }
// // // // // // // //                     },
// // // // // // // //                   ),
// // // // // // // //                 ),
// // // // // // // //               ),
// // // // // // // //               const SizedBox(width: 8),

// // // // // // // //               // Font Weight Dropdown
// // // // // // // //               Container(
// // // // // // // //                 padding: const EdgeInsets.symmetric(horizontal: 8),
// // // // // // // //                 decoration: BoxDecoration(
// // // // // // // //                   border: Border.all(color: Colors.grey.shade300),
// // // // // // // //                   borderRadius: BorderRadius.circular(4),
// // // // // // // //                 ),
// // // // // // // //                 child: DropdownButtonHideUnderline(
// // // // // // // //                   child: DropdownButton<FontWeight>(
// // // // // // // //                     value: _selectedTextElement!.fontWeight,
// // // // // // // //                     items: _fontWeights
// // // // // // // //                         .map(
// // // // // // // //                           (weight) => DropdownMenuItem(
// // // // // // // //                             value: weight,
// // // // // // // //                             child: Text(
// // // // // // // //                               weight == FontWeight.bold
// // // // // // // //                                   ? 'Bold'
// // // // // // // //                                   : weight == FontWeight.w600
// // // // // // // //                                   ? 'Semi-Bold'
// // // // // // // //                                   : weight == FontWeight.w300
// // // // // // // //                                   ? 'Light'
// // // // // // // //                                   : weight == FontWeight.w900
// // // // // // // //                                   ? 'Black'
// // // // // // // //                                   : 'Normal',
// // // // // // // //                               style: TextStyle(fontWeight: weight),
// // // // // // // //                             ),
// // // // // // // //                           ),
// // // // // // // //                         )
// // // // // // // //                         .toList(),
// // // // // // // //                     onChanged: (value) {
// // // // // // // //                       if (value != null) {
// // // // // // // //                         setState(() {
// // // // // // // //                           _selectedTextElement!.fontWeight = value;
// // // // // // // //                         });
// // // // // // // //                       }
// // // // // // // //                     },
// // // // // // // //                   ),
// // // // // // // //                 ),
// // // // // // // //               ),
// // // // // // // //               const VerticalDivider(width: 16),

// // // // // // // //               // Text Alignment
// // // // // // // //               Row(
// // // // // // // //                 children: [
// // // // // // // //                   IconButton(
// // // // // // // //                     icon: Icon(
// // // // // // // //                       Icons.format_align_left,
// // // // // // // //                       color: _selectedTextElement!.textAlign == TextAlign.left
// // // // // // // //                           ? Colors.deepPurple
// // // // // // // //                           : Colors.grey,
// // // // // // // //                     ),
// // // // // // // //                     onPressed: () {
// // // // // // // //                       setState(() {
// // // // // // // //                         _selectedTextElement!.textAlign = TextAlign.left;
// // // // // // // //                       });
// // // // // // // //                     },
// // // // // // // //                     tooltip: 'Align Left',
// // // // // // // //                   ),
// // // // // // // //                   IconButton(
// // // // // // // //                     icon: Icon(
// // // // // // // //                       Icons.format_align_center,
// // // // // // // //                       color: _selectedTextElement!.textAlign == TextAlign.center
// // // // // // // //                           ? Colors.deepPurple
// // // // // // // //                           : Colors.grey,
// // // // // // // //                     ),
// // // // // // // //                     onPressed: () {
// // // // // // // //                       setState(() {
// // // // // // // //                         _selectedTextElement!.textAlign = TextAlign.center;
// // // // // // // //                       });
// // // // // // // //                     },
// // // // // // // //                     tooltip: 'Align Center',
// // // // // // // //                   ),
// // // // // // // //                   IconButton(
// // // // // // // //                     icon: Icon(
// // // // // // // //                       Icons.format_align_right,
// // // // // // // //                       color: _selectedTextElement!.textAlign == TextAlign.right
// // // // // // // //                           ? Colors.deepPurple
// // // // // // // //                           : Colors.grey,
// // // // // // // //                     ),
// // // // // // // //                     onPressed: () {
// // // // // // // //                       setState(() {
// // // // // // // //                         _selectedTextElement!.textAlign = TextAlign.right;
// // // // // // // //                       });
// // // // // // // //                     },
// // // // // // // //                     tooltip: 'Align Right',
// // // // // // // //                   ),
// // // // // // // //                 ],
// // // // // // // //               ),
// // // // // // // //               const VerticalDivider(width: 16),

// // // // // // // //               // RGB Color Picker Button
// // // // // // // //               IconButton(
// // // // // // // //                 icon: Icon(
// // // // // // // //                   Icons.color_lens,
// // // // // // // //                   color: _selectedTextElement!.color,
// // // // // // // //                 ),
// // // // // // // //                 onPressed: _showColorPickerDialog,
// // // // // // // //                 tooltip: 'Choose Color',
// // // // // // // //               ),

// // // // // // // //               // Delete button for text elements
// // // // // // // //               const VerticalDivider(width: 16),
// // // // // // // //               IconButton(
// // // // // // // //                 icon: const Icon(Icons.delete, color: Colors.red),
// // // // // // // //                 onPressed: _deleteSelectedElement,
// // // // // // // //                 tooltip: 'Delete Text',
// // // // // // // //               ),
// // // // // // // //             ] else if (_selectedImageElement != null) ...[
// // // // // // // //               // ... rest of your existing image toolbar code
// // // // // // // //               const Text(
// // // // // // // //                 'Size: ',
// // // // // // // //                 style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
// // // // // // // //               ),
// // // // // // // //               SizedBox(
// // // // // // // //                 width: 120,
// // // // // // // //                 child: Slider(
// // // // // // // //                   value: _selectedImageElement!.width,
// // // // // // // //                   min: 20.0,
// // // // // // // //                   max: _template!.width * 0.9,
// // // // // // // //                   divisions: 50,
// // // // // // // //                   label: '${_selectedImageElement!.width.round()}',
// // // // // // // //                   onChanged: (value) {
// // // // // // // //                     setState(() {
// // // // // // // //                       final aspectRatio =
// // // // // // // //                           _selectedImageElement!.width /
// // // // // // // //                           _selectedImageElement!.height;
// // // // // // // //                       _selectedImageElement!.width = value;
// // // // // // // //                       _selectedImageElement!.height = value / aspectRatio;

// // // // // // // //                       _selectedImageElement!.x = _selectedImageElement!.x.clamp(
// // // // // // // //                         0,
// // // // // // // //                         _template!.width - _selectedImageElement!.width,
// // // // // // // //                       );
// // // // // // // //                       _selectedImageElement!.y = _selectedImageElement!.y.clamp(
// // // // // // // //                         0,
// // // // // // // //                         _template!.height - _selectedImageElement!.height,
// // // // // // // //                       );
// // // // // // // //                     });
// // // // // // // //                   },
// // // // // // // //                 ),
// // // // // // // //               ),
// // // // // // // //               const VerticalDivider(width: 16),

// // // // // // // //               // Border Radius Slider
// // // // // // // //               const Text(
// // // // // // // //                 'Corner: ',
// // // // // // // //                 style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
// // // // // // // //               ),
// // // // // // // //               SizedBox(
// // // // // // // //                 width: 120,
// // // // // // // //                 child: Slider(
// // // // // // // //                   value: _selectedImageElement!.borderRadius,
// // // // // // // //                   min: 0.0,
// // // // // // // //                   max: 100.0,
// // // // // // // //                   divisions: 20,
// // // // // // // //                   label: '${_selectedImageElement!.borderRadius.round()}',
// // // // // // // //                   onChanged: (value) {
// // // // // // // //                     setState(() {
// // // // // // // //                       _selectedImageElement!.borderRadius = value;
// // // // // // // //                     });
// // // // // // // //                   },
// // // // // // // //                 ),
// // // // // // // //               ),
// // // // // // // //               const VerticalDivider(width: 16),

// // // // // // // //               IconButton(
// // // // // // // //                 icon: const Icon(Icons.crop_square, color: Colors.deepPurple),
// // // // // // // //                 onPressed: () {
// // // // // // // //                   setState(() {
// // // // // // // //                     _selectedImageElement!.borderRadius = 0.0;
// // // // // // // //                   });
// // // // // // // //                 },
// // // // // // // //                 tooltip: 'Sharp Corners',
// // // // // // // //               ),
// // // // // // // //               IconButton(
// // // // // // // //                 icon: const Icon(
// // // // // // // //                   Icons.rounded_corner,
// // // // // // // //                   color: Colors.deepPurple,
// // // // // // // //                 ),
// // // // // // // //                 onPressed: () {
// // // // // // // //                   setState(() {
// // // // // // // //                     _selectedImageElement!.borderRadius = 12.0;
// // // // // // // //                   });
// // // // // // // //                 },
// // // // // // // //                 tooltip: 'Rounded Corners',
// // // // // // // //               ),
// // // // // // // //               IconButton(
// // // // // // // //                 icon: const Icon(
// // // // // // // //                   Icons.circle_outlined,
// // // // // // // //                   color: Colors.deepPurple,
// // // // // // // //                 ),
// // // // // // // //                 onPressed: () {
// // // // // // // //                   setState(() {
// // // // // // // //                     _selectedImageElement!.borderRadius = 50.0;
// // // // // // // //                   });
// // // // // // // //                 },
// // // // // // // //                 tooltip: 'Circular',
// // // // // // // //               ),
// // // // // // // //               const VerticalDivider(width: 16),

// // // // // // // //               // Reset Size Button
// // // // // // // //               IconButton(
// // // // // // // //                 icon: const Icon(Icons.aspect_ratio, color: Colors.deepPurple),
// // // // // // // //                 onPressed: () {
// // // // // // // //                   double originalSize = 200.0;
// // // // // // // //                   if (_selectedImageElement!.id == 'logo_image') {
// // // // // // // //                     originalSize = 100.0;
// // // // // // // //                   } else if (_selectedImageElement!.id == 'profile_image') {
// // // // // // // //                     originalSize = 200.0;
// // // // // // // //                   }

// // // // // // // //                   setState(() {
// // // // // // // //                     _selectedImageElement!.width = originalSize;
// // // // // // // //                     _selectedImageElement!.height = originalSize;
// // // // // // // //                   });
// // // // // // // //                 },
// // // // // // // //                 tooltip: 'Reset Size',
// // // // // // // //               ),
// // // // // // // //               const VerticalDivider(width: 16),

// // // // // // // //               // Delete Button
// // // // // // // //               IconButton(
// // // // // // // //                 icon: const Icon(Icons.delete, color: Colors.red),
// // // // // // // //                 onPressed: _deleteSelectedElement,
// // // // // // // //                 tooltip: 'Delete Image',
// // // // // // // //               ),
// // // // // // // //             ] else if (_selectedProfileImageElement != null) ...[
// // // // // // // //               // ... rest of your existing profile image toolbar code
// // // // // // // //               const Text(
// // // // // // // //                 'Profile Image',
// // // // // // // //                 style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
// // // // // // // //               ),
// // // // // // // //               const VerticalDivider(width: 16),

// // // // // // // //               // Size controls for profile image
// // // // // // // //               IconButton(
// // // // // // // //                 icon: const Icon(Icons.zoom_out, color: Colors.deepPurple),
// // // // // // // //                 onPressed: () {
// // // // // // // //                   setState(() {
// // // // // // // //                     final newSize = (_selectedProfileImageElement!.width * 0.9)
// // // // // // // //                         .clamp(50.0, _template!.width * 0.8);
// // // // // // // //                     _selectedProfileImageElement!.width = newSize;
// // // // // // // //                     _selectedProfileImageElement!.height = newSize;
// // // // // // // //                   });
// // // // // // // //                 },
// // // // // // // //                 tooltip: 'Make Smaller',
// // // // // // // //               ),

// // // // // // // //               Container(
// // // // // // // //                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// // // // // // // //                 decoration: BoxDecoration(
// // // // // // // //                   border: Border.all(color: Colors.grey.shade300),
// // // // // // // //                   borderRadius: BorderRadius.circular(4),
// // // // // // // //                 ),
// // // // // // // //                 child: Text(
// // // // // // // //                   '${(_selectedProfileImageElement!.width).round()}×${(_selectedProfileImageElement!.height).round()}',
// // // // // // // //                   style: const TextStyle(fontSize: 12),
// // // // // // // //                 ),
// // // // // // // //               ),

// // // // // // // //               IconButton(
// // // // // // // //                 icon: const Icon(Icons.zoom_in, color: Colors.deepPurple),
// // // // // // // //                 onPressed: () {
// // // // // // // //                   setState(() {
// // // // // // // //                     final newSize = (_selectedProfileImageElement!.width * 1.1)
// // // // // // // //                         .clamp(50.0, _template!.width * 0.8);
// // // // // // // //                     _selectedProfileImageElement!.width = newSize;
// // // // // // // //                     _selectedProfileImageElement!.height = newSize;
// // // // // // // //                   });
// // // // // // // //                 },
// // // // // // // //                 tooltip: 'Make Larger',
// // // // // // // //               ),

// // // // // // // //               const VerticalDivider(width: 16),

// // // // // // // //               // Size Slider for Profile Image
// // // // // // // //               const Text(
// // // // // // // //                 'Size: ',
// // // // // // // //                 style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
// // // // // // // //               ),
// // // // // // // //               SizedBox(
// // // // // // // //                 width: 120,
// // // // // // // //                 child: Slider(
// // // // // // // //                   value: _selectedProfileImageElement!.width,
// // // // // // // //                   min: 50.0,
// // // // // // // //                   max: _template!.width * 0.8,
// // // // // // // //                   divisions: 50,
// // // // // // // //                   label: '${_selectedProfileImageElement!.width.round()}',
// // // // // // // //                   onChanged: (value) {
// // // // // // // //                     setState(() {
// // // // // // // //                       _selectedProfileImageElement!.width = value;
// // // // // // // //                       _selectedProfileImageElement!.height = value;

// // // // // // // //                       _selectedProfileImageElement!
// // // // // // // //                           .x = _selectedProfileImageElement!.x.clamp(
// // // // // // // //                         0,
// // // // // // // //                         _template!.width - _selectedProfileImageElement!.width,
// // // // // // // //                       );
// // // // // // // //                       _selectedProfileImageElement!.y =
// // // // // // // //                           _selectedProfileImageElement!.y.clamp(
// // // // // // // //                             0,
// // // // // // // //                             _template!.height -
// // // // // // // //                                 _selectedProfileImageElement!.height,
// // // // // // // //                           );
// // // // // // // //                     });
// // // // // // // //                   },
// // // // // // // //                 ),
// // // // // // // //               ),

// // // // // // // //               const VerticalDivider(width: 16),

// // // // // // // //               // Replace profile image button
// // // // // // // //               IconButton(
// // // // // // // //                 icon: const Icon(Icons.photo_camera, color: Colors.deepPurple),
// // // // // // // //                 onPressed: () async {
// // // // // // // //                   try {
// // // // // // // //                     final XFile? image = await _picker.pickImage(
// // // // // // // //                       source: ImageSource.gallery,
// // // // // // // //                     );
// // // // // // // //                     if (image != null) {
// // // // // // // //                       final bytes = await image.readAsBytes();
// // // // // // // //                       setState(() {
// // // // // // // //                         _profileImageBytes = bytes;
// // // // // // // //                       });
// // // // // // // //                       ScaffoldMessenger.of(context).showSnackBar(
// // // // // // // //                         const SnackBar(
// // // // // // // //                           content: Text('Profile image updated!'),
// // // // // // // //                           backgroundColor: Colors.green,
// // // // // // // //                           duration: Duration(seconds: 2),
// // // // // // // //                         ),
// // // // // // // //                       );
// // // // // // // //                     }
// // // // // // // //                   } catch (e) {
// // // // // // // //                     ScaffoldMessenger.of(context).showSnackBar(
// // // // // // // //                       SnackBar(
// // // // // // // //                         content: Text('Error updating profile image: $e'),
// // // // // // // //                         backgroundColor: Colors.red,
// // // // // // // //                       ),
// // // // // // // //                     );
// // // // // // // //                   }
// // // // // // // //                 },
// // // // // // // //                 tooltip: 'Replace Profile Image',
// // // // // // // //               ),

// // // // // // // //               // Delete profile image button
// // // // // // // //               IconButton(
// // // // // // // //                 icon: const Icon(Icons.delete, color: Colors.red),
// // // // // // // //                 onPressed: () {
// // // // // // // //                   showDialog(
// // // // // // // //                     context: context,
// // // // // // // //                     builder: (context) => AlertDialog(
// // // // // // // //                       title: const Text('Delete Profile Image'),
// // // // // // // //                       content: const Text(
// // // // // // // //                         'Are you sure you want to delete the profile image?',
// // // // // // // //                       ),
// // // // // // // //                       actions: [
// // // // // // // //                         TextButton(
// // // // // // // //                           onPressed: () => Navigator.pop(context),
// // // // // // // //                           child: const Text('Cancel'),
// // // // // // // //                         ),
// // // // // // // //                         TextButton(
// // // // // // // //                           onPressed: () {
// // // // // // // //                             Navigator.pop(context);
// // // // // // // //                             _deleteSelectedElement();
// // // // // // // //                           },
// // // // // // // //                           style: TextButton.styleFrom(
// // // // // // // //                             foregroundColor: Colors.red,
// // // // // // // //                           ),
// // // // // // // //                           child: const Text('Delete'),
// // // // // // // //                         ),
// // // // // // // //                       ],
// // // // // // // //                     ),
// // // // // // // //                   );
// // // // // // // //                 },
// // // // // // // //                 tooltip: 'Delete Profile Image',
// // // // // // // //               ),
// // // // // // // //             ],
// // // // // // // //           ],
// // // // // // // //         ),
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   @override
// // // // // // // //   Widget build(BuildContext context) {
// // // // // // // //     final screenSize = MediaQuery.of(context).size;

// // // // // // // //     if (_template != null && _scaleFactor == 1.0) {
// // // // // // // //       _calculateScaleFactor(screenSize);
// // // // // // // //     }

// // // // // // // //     void _showEditDialog({
// // // // // // // //       required String title,
// // // // // // // //       required String currentValue,
// // // // // // // //       required IconData icon,
// // // // // // // //       TextInputType keyboardType = TextInputType.text,
// // // // // // // //       required Function(String) onSave,
// // // // // // // //     }) {
// // // // // // // //       final controller = TextEditingController(text: currentValue);

// // // // // // // //       showDialog(
// // // // // // // //         context: context,
// // // // // // // //         builder: (context) => AlertDialog(
// // // // // // // //           title: Row(
// // // // // // // //             children: [
// // // // // // // //               Icon(icon, color: Colors.deepPurple),
// // // // // // // //               const SizedBox(width: 12),
// // // // // // // //               Text(title),
// // // // // // // //             ],
// // // // // // // //           ),
// // // // // // // //           content: TextField(
// // // // // // // //             controller: controller,
// // // // // // // //             keyboardType: keyboardType,
// // // // // // // //             maxLines: keyboardType == TextInputType.phone ? 1 : null,
// // // // // // // //             autofocus: true,
// // // // // // // //             decoration: InputDecoration(
// // // // // // // //               hintText: keyboardType == TextInputType.phone
// // // // // // // //                   ? 'Enter phone...'
// // // // // // // //                   : 'Enter business name...',
// // // // // // // //               border: const OutlineInputBorder(),
// // // // // // // //               prefixIcon: Icon(icon),
// // // // // // // //               counterText: '',
// // // // // // // //             ),
// // // // // // // //             maxLength: keyboardType == TextInputType.phone ? 15 : 50,
// // // // // // // //           ),
// // // // // // // //           actions: [
// // // // // // // //             TextButton(
// // // // // // // //               onPressed: () => Navigator.pop(context),
// // // // // // // //               child: const Text('Cancel'),
// // // // // // // //             ),
// // // // // // // //             ElevatedButton(
// // // // // // // //               onPressed: () {
// // // // // // // //                 if (controller.text.isNotEmpty) {
// // // // // // // //                   onSave(controller.text);
// // // // // // // //                   Navigator.pop(context);
// // // // // // // //                   ScaffoldMessenger.of(context).showSnackBar(
// // // // // // // //                     SnackBar(
// // // // // // // //                       content: Text('$title updated successfully!'),
// // // // // // // //                       backgroundColor: Colors.green,
// // // // // // // //                       duration: const Duration(seconds: 2),
// // // // // // // //                     ),
// // // // // // // //                   );
// // // // // // // //                 } else {
// // // // // // // //                   ScaffoldMessenger.of(context).showSnackBar(
// // // // // // // //                     const SnackBar(
// // // // // // // //                       content: Text('Value cannot be empty!'),
// // // // // // // //                       backgroundColor: Colors.red,
// // // // // // // //                       duration: Duration(seconds: 2),
// // // // // // // //                     ),
// // // // // // // //                   );
// // // // // // // //                 }
// // // // // // // //               },
// // // // // // // //               style: ElevatedButton.styleFrom(
// // // // // // // //                 backgroundColor: Colors.deepPurple,
// // // // // // // //                 foregroundColor: Colors.white,
// // // // // // // //               ),
// // // // // // // //               child: const Text('Save'),
// // // // // // // //             ),
// // // // // // // //           ],
// // // // // // // //         ),
// // // // // // // //       );
// // // // // // // //     }

// // // // // // // //     void _showBottomInfoEditOptions() {
// // // // // // // //       showModalBottomSheet(
// // // // // // // //         context: context,
// // // // // // // //         backgroundColor: Colors.transparent,
// // // // // // // //         isScrollControlled: true,
// // // // // // // //         builder: (context) => StatefulBuilder(
// // // // // // // //           builder: (context, setModalState) => Container(
// // // // // // // //             decoration: const BoxDecoration(
// // // // // // // //               color: Colors.white,
// // // // // // // //               borderRadius: BorderRadius.only(
// // // // // // // //                 topLeft: Radius.circular(20),
// // // // // // // //                 topRight: Radius.circular(20),
// // // // // // // //               ),
// // // // // // // //             ),
// // // // // // // //             child: Column(
// // // // // // // //               mainAxisSize: MainAxisSize.min,
// // // // // // // //               children: [
// // // // // // // //                 Container(
// // // // // // // //                   width: 40,
// // // // // // // //                   height: 4,
// // // // // // // //                   margin: const EdgeInsets.only(top: 12, bottom: 20),
// // // // // // // //                   decoration: BoxDecoration(
// // // // // // // //                     color: Colors.grey[300],
// // // // // // // //                     borderRadius: BorderRadius.circular(2),
// // // // // // // //                   ),
// // // // // // // //                 ),

// // // // // // // //                 // Business Name Edit
// // // // // // // //                 ListTile(
// // // // // // // //                   leading: Container(
// // // // // // // //                     padding: const EdgeInsets.all(8),
// // // // // // // //                     decoration: BoxDecoration(
// // // // // // // //                       color: Colors.purple.shade50,
// // // // // // // //                       borderRadius: BorderRadius.circular(8),
// // // // // // // //                     ),
// // // // // // // //                     child: Icon(Icons.business, color: Colors.purple.shade700),
// // // // // // // //                   ),
// // // // // // // //                   title: const Text(
// // // // // // // //                     'Edit Business Name',
// // // // // // // //                     style: TextStyle(fontWeight: FontWeight.w600),
// // // // // // // //                   ),
// // // // // // // //                   trailing: const Icon(Icons.arrow_forward_ios, size: 16),
// // // // // // // //                   onTap: () {
// // // // // // // //                     Navigator.pop(context);
// // // // // // // //                     final nameElement = _template?.textElements.firstWhere(
// // // // // // // //                       (e) => e.id == 'name',
// // // // // // // //                       orElse: () => TextElement(
// // // // // // // //                         id: 'name',
// // // // // // // //                         text: 'Business Name',
// // // // // // // //                         x: 0,
// // // // // // // //                         y: 0,
// // // // // // // //                       ),
// // // // // // // //                     );

// // // // // // // //                     if (nameElement != null) {
// // // // // // // //                       _showEditDialog(
// // // // // // // //                         title: 'Edit  Name',
// // // // // // // //                         currentValue: nameElement.text,
// // // // // // // //                         icon: Icons.business,
// // // // // // // //                         onSave: (newValue) {
// // // // // // // //                           setState(() {
// // // // // // // //                             nameElement.text = newValue;
// // // // // // // //                           });
// // // // // // // //                         },
// // // // // // // //                       );
// // // // // // // //                     }
// // // // // // // //                   },
// // // // // // // //                 ),

// // // // // // // //                 // Business Name Size Slider
// // // // // // // //                 Padding(
// // // // // // // //                   padding: const EdgeInsets.symmetric(
// // // // // // // //                     horizontal: 16,
// // // // // // // //                     vertical: 8,
// // // // // // // //                   ),
// // // // // // // //                   child: Row(
// // // // // // // //                     children: [
// // // // // // // //                       Container(
// // // // // // // //                         padding: const EdgeInsets.all(8),
// // // // // // // //                         decoration: BoxDecoration(
// // // // // // // //                           color: Colors.purple.shade50,
// // // // // // // //                           borderRadius: BorderRadius.circular(8),
// // // // // // // //                         ),
// // // // // // // //                         child: Icon(
// // // // // // // //                           Icons.text_fields,
// // // // // // // //                           color: Colors.purple.shade700,
// // // // // // // //                           size: 20,
// // // // // // // //                         ),
// // // // // // // //                       ),
// // // // // // // //                       const SizedBox(width: 12),
// // // // // // // //                       const Text(
// // // // // // // //                         'Name Size: ',
// // // // // // // //                         style: TextStyle(fontWeight: FontWeight.w600),
// // // // // // // //                       ),
// // // // // // // //                       Expanded(
// // // // // // // //                         child: Slider(
// // // // // // // //                           value: _businessNameFontSize,
// // // // // // // //                           min: 12.0,
// // // // // // // //                           max: 40.0,
// // // // // // // //                           divisions: 28,
// // // // // // // //                           label: '${_businessNameFontSize.round()}',
// // // // // // // //                           activeColor: Colors.purple.shade700,
// // // // // // // //                           onChanged: (value) {
// // // // // // // //                             setState(() {
// // // // // // // //                               _businessNameFontSize = value;
// // // // // // // //                             });
// // // // // // // //                             setModalState(() {});
// // // // // // // //                           },
// // // // // // // //                         ),
// // // // // // // //                       ),
// // // // // // // //                       Container(
// // // // // // // //                         padding: const EdgeInsets.symmetric(
// // // // // // // //                           horizontal: 8,
// // // // // // // //                           vertical: 4,
// // // // // // // //                         ),
// // // // // // // //                         decoration: BoxDecoration(
// // // // // // // //                           color: Colors.purple.shade100,
// // // // // // // //                           borderRadius: BorderRadius.circular(4),
// // // // // // // //                         ),
// // // // // // // //                         child: Text(
// // // // // // // //                           '${_businessNameFontSize.round()}',
// // // // // // // //                           style: TextStyle(
// // // // // // // //                             fontWeight: FontWeight.bold,
// // // // // // // //                             color: Colors.purple.shade900,
// // // // // // // //                           ),
// // // // // // // //                         ),
// // // // // // // //                       ),
// // // // // // // //                     ],
// // // // // // // //                   ),
// // // // // // // //                 ),

// // // // // // // //                 const Divider(height: 1),

// // // // // // // //                 // Phone Number Edit
// // // // // // // //                 ListTile(
// // // // // // // //                   leading: Container(
// // // // // // // //                     padding: const EdgeInsets.all(8),
// // // // // // // //                     decoration: BoxDecoration(
// // // // // // // //                       color: Colors.blue.shade50,
// // // // // // // //                       borderRadius: BorderRadius.circular(8),
// // // // // // // //                     ),
// // // // // // // //                     child: Icon(Icons.phone, color: Colors.blue.shade700),
// // // // // // // //                   ),
// // // // // // // //                   title: const Text(
// // // // // // // //                     'Edit Phone Number',
// // // // // // // //                     style: TextStyle(fontWeight: FontWeight.w600),
// // // // // // // //                   ),
// // // // // // // //                   trailing: const Icon(Icons.arrow_forward_ios, size: 16),
// // // // // // // //                   onTap: () {
// // // // // // // //                     Navigator.pop(context);
// // // // // // // //                     final mobileElement = _template?.textElements.firstWhere(
// // // // // // // //                       (e) => e.id == 'mobile',
// // // // // // // //                       orElse: () => TextElement(
// // // // // // // //                         id: 'mobile',
// // // // // // // //                         text: phoneNumber ?? 'Not Set',
// // // // // // // //                         x: 0,
// // // // // // // //                         y: 0,
// // // // // // // //                       ),
// // // // // // // //                     );

// // // // // // // //                     if (mobileElement != null) {
// // // // // // // //                       _showEditDialog(
// // // // // // // //                         title: 'Edit  Number',
// // // // // // // //                         currentValue: mobileElement.text,
// // // // // // // //                         icon: Icons.phone,
// // // // // // // //                         keyboardType: TextInputType.phone,
// // // // // // // //                         onSave: (newValue) {
// // // // // // // //                           setState(() {
// // // // // // // //                             mobileElement.text = newValue;
// // // // // // // //                             phoneNumber = newValue;
// // // // // // // //                           });
// // // // // // // //                         },
// // // // // // // //                       );
// // // // // // // //                     }
// // // // // // // //                   },
// // // // // // // //                 ),

// // // // // // // //                 // Phone Number Size Slider
// // // // // // // //                 Padding(
// // // // // // // //                   padding: const EdgeInsets.symmetric(
// // // // // // // //                     horizontal: 16,
// // // // // // // //                     vertical: 8,
// // // // // // // //                   ),
// // // // // // // //                   child: Row(
// // // // // // // //                     children: [
// // // // // // // //                       Container(
// // // // // // // //                         padding: const EdgeInsets.all(8),
// // // // // // // //                         decoration: BoxDecoration(
// // // // // // // //                           color: Colors.blue.shade50,
// // // // // // // //                           borderRadius: BorderRadius.circular(8),
// // // // // // // //                         ),
// // // // // // // //                         child: Icon(
// // // // // // // //                           Icons.text_fields,
// // // // // // // //                           color: Colors.blue.shade700,
// // // // // // // //                           size: 20,
// // // // // // // //                         ),
// // // // // // // //                       ),
// // // // // // // //                       const SizedBox(width: 12),
// // // // // // // //                       const Text(
// // // // // // // //                         'Phone Size: ',
// // // // // // // //                         style: TextStyle(fontWeight: FontWeight.w600),
// // // // // // // //                       ),
// // // // // // // //                       Expanded(
// // // // // // // //                         child: Slider(
// // // // // // // //                           value: _phoneNumberFontSize,
// // // // // // // //                           min: 12.0,
// // // // // // // //                           max: 40.0,
// // // // // // // //                           divisions: 28,
// // // // // // // //                           label: '${_phoneNumberFontSize.round()}',
// // // // // // // //                           activeColor: Colors.blue.shade700,
// // // // // // // //                           onChanged: (value) {
// // // // // // // //                             setState(() {
// // // // // // // //                               _phoneNumberFontSize = value;
// // // // // // // //                             });
// // // // // // // //                             setModalState(() {});
// // // // // // // //                           },
// // // // // // // //                         ),
// // // // // // // //                       ),
// // // // // // // //                       Container(
// // // // // // // //                         padding: const EdgeInsets.symmetric(
// // // // // // // //                           horizontal: 8,
// // // // // // // //                           vertical: 4,
// // // // // // // //                         ),
// // // // // // // //                         decoration: BoxDecoration(
// // // // // // // //                           color: Colors.blue.shade100,
// // // // // // // //                           borderRadius: BorderRadius.circular(4),
// // // // // // // //                         ),
// // // // // // // //                         child: Text(
// // // // // // // //                           '${_phoneNumberFontSize.round()}',
// // // // // // // //                           style: TextStyle(
// // // // // // // //                             fontWeight: FontWeight.bold,
// // // // // // // //                             color: Colors.blue.shade900,
// // // // // // // //                           ),
// // // // // // // //                         ),
// // // // // // // //                       ),
// // // // // // // //                     ],
// // // // // // // //                   ),
// // // // // // // //                 ),

// // // // // // // //                 const SizedBox(height: 20),
// // // // // // // //               ],
// // // // // // // //             ),
// // // // // // // //           ),
// // // // // // // //         ),
// // // // // // // //       );
// // // // // // // //     }

// // // // // // // //     return Scaffold(
// // // // // // // //       appBar: // In your build method, in the AppBar actions section, update this:
// // // // // // // //       AppBar(
// // // // // // // //         leading: IconButton(
// // // // // // // //           onPressed: () {
// // // // // // // //             Navigator.of(context).pop();
// // // // // // // //           },
// // // // // // // //           icon: Icon(Icons.arrow_back_ios, color: Colors.white),
// // // // // // // //         ),
// // // // // // // //         // title: Text(_template?.name ?? 'Poster Editor'),
// // // // // // // //         backgroundColor: Colors.purple.shade300,
// // // // // // // //         foregroundColor: Colors.white,
// // // // // // // //         actions: [
// // // // // // // //           IconButton(
// // // // // // // //             icon: const Icon(Icons.audio_file, color: Colors.white),
// // // // // // // //             onPressed: _pickAudio,
// // // // // // // //             tooltip: 'Add Text',
// // // // // // // //           ),
// // // // // // // //           IconButton(
// // // // // // // //             icon: const Icon(Icons.font_download, color: Colors.white),
// // // // // // // //             onPressed: _addNewTextElement,
// // // // // // // //             tooltip: 'Add Text',
// // // // // // // //           ),
// // // // // // // //           IconButton(
// // // // // // // //             icon: const Icon(Icons.cloud_upload, color: Colors.white),
// // // // // // // //             onPressed: _pickAdditionalImage,
// // // // // // // //             tooltip: 'Add Image',
// // // // // // // //           ),
// // // // // // // //           TextButton(
// // // // // // // //             onPressed: _pickLogoImage,
// // // // // // // //             child: const Text("Logo", style: TextStyle(color: Colors.white)),
// // // // // // // //           ),
// // // // // // // //           // CHANGE THIS CONDITION:
// // // // // // // //           if (_selectedTextElement != null ||
// // // // // // // //               _selectedImageElement != null ||
// // // // // // // //               _selectedProfileImageElement != null) // <- ADD THIS LINE
// // // // // // // //             IconButton(
// // // // // // // //               icon: const Icon(Icons.delete_outline, color: Colors.red),
// // // // // // // //               onPressed: _deleteSelectedElement,
// // // // // // // //               tooltip: 'Delete Selected',
// // // // // // // //             ),

// // // // // // // //           // IconButton(
// // // // // // // //           //   icon: const Icon(Icons.refresh),
// // // // // // // //           //   onPressed: _loadPosterFromApi,
// // // // // // // //           //   tooltip: 'Reload Poster',
// // // // // // // //           // ),
// // // // // // // //           // PopupMenuButton(
// // // // // // // //           //   icon: const Icon(Icons.more_vert, color: Colors.white),
// // // // // // // //           //   itemBuilder: (context) => [
// // // // // // // //           //     const PopupMenuItem(
// // // // // // // //           //       value: 'image',
// // // // // // // //           //       child: Row(
// // // // // // // //           //         children: [
// // // // // // // //           //           Icon(Icons.image, color: Colors.black),
// // // // // // // //           //           SizedBox(width: 8),
// // // // // // // //           //           Text('Save Poster'),
// // // // // // // //           //         ],
// // // // // // // //           //       ),
// // // // // // // //           //     ),
// // // // // // // //           //     const PopupMenuItem(
// // // // // // // //           //       value: 'share',
// // // // // // // //           //       child: Row(
// // // // // // // //           //         children: [
// // // // // // // //           //           Icon(Icons.share, color: Colors.black),
// // // // // // // //           //           SizedBox(width: 8),
// // // // // // // //           //           Text('Share Poster'),
// // // // // // // //           //         ],
// // // // // // // //           //       ),
// // // // // // // //           //     ),
// // // // // // // //           //   ],
// // // // // // // //           //   onSelected: (value) {
// // // // // // // //           //     if (value == 'image') {
// // // // // // // //           //       savePoster();
// // // // // // // //           //     } else if (value == 'share') {
// // // // // // // //           //       _sharePoster();
// // // // // // // //           //     }
// // // // // // // //           //   },
// // // // // // // //           // ),
// // // // // // // //           PopupMenuButton(
// // // // // // // //             icon: const Icon(Icons.more_vert, color: Colors.white),
// // // // // // // //             itemBuilder: (context) => [
// // // // // // // //               const PopupMenuItem(
// // // // // // // //                 value: 'image',
// // // // // // // //                 child: Row(
// // // // // // // //                   children: [
// // // // // // // //                     Icon(Icons.image, color: Colors.black),
// // // // // // // //                     SizedBox(width: 8),
// // // // // // // //                     Text('Save Poster'),
// // // // // // // //                   ],
// // // // // // // //                 ),
// // // // // // // //               ),
// // // // // // // //               const PopupMenuItem(
// // // // // // // //                 value: 'share',
// // // // // // // //                 child: Row(
// // // // // // // //                   children: [
// // // // // // // //                     Icon(Icons.share, color: Colors.black),
// // // // // // // //                     SizedBox(width: 8),
// // // // // // // //                     Text('Share Poster'),
// // // // // // // //                   ],
// // // // // // // //                 ),
// // // // // // // //               ),
// // // // // // // //               const PopupMenuItem(
// // // // // // // //                 value: 'share_customers',
// // // // // // // //                 child: Row(
// // // // // // // //                   children: [
// // // // // // // //                     Icon(Icons.people, color: Colors.deepPurple),
// // // // // // // //                     SizedBox(width: 8),
// // // // // // // //                     Text('Share to Customers'),
// // // // // // // //                   ],
// // // // // // // //                 ),
// // // // // // // //               ),
// // // // // // // //             ],
// // // // // // // //             onSelected: (value) {
// // // // // // // //               if (value == 'image') {
// // // // // // // //                 savePoster();
// // // // // // // //               } else if (value == 'share') {
// // // // // // // //                 _sharePoster();
// // // // // // // //               } else if (value == 'share_customers') {
// // // // // // // //                 _showCustomerSelectionDialog();
// // // // // // // //               }
// // // // // // // //             },
// // // // // // // //           ),
// // // // // // // //         ],
// // // // // // // //       ),
// // // // // // // //       body: _isLoading
// // // // // // // //           ? const Center(
// // // // // // // //               child: Column(
// // // // // // // //                 mainAxisAlignment: MainAxisAlignment.center,
// // // // // // // //                 children: [
// // // // // // // //                   CircularProgressIndicator(),
// // // // // // // //                   SizedBox(height: 16),
// // // // // // // //                   Text('Loading poster...'),
// // // // // // // //                 ],
// // // // // // // //               ),
// // // // // // // //             )
// // // // // // // //           : _errorMessage != null
// // // // // // // //           ? Center(
// // // // // // // //               child: Padding(
// // // // // // // //                 padding: const EdgeInsets.all(16.0),
// // // // // // // //                 child: Column(
// // // // // // // //                   mainAxisAlignment: MainAxisAlignment.center,
// // // // // // // //                   children: [
// // // // // // // //                     const Icon(Icons.error, size: 64, color: Colors.red),
// // // // // // // //                     const SizedBox(height: 16),
// // // // // // // //                     Text(
// // // // // // // //                       _errorMessage!,
// // // // // // // //                       style: const TextStyle(color: Colors.red, fontSize: 16),
// // // // // // // //                       textAlign: TextAlign.center,
// // // // // // // //                     ),
// // // // // // // //                     const SizedBox(height: 24),
// // // // // // // //                     ElevatedButton.icon(
// // // // // // // //                       onPressed: _loadPosterFromApi,
// // // // // // // //                       icon: const Icon(Icons.refresh),
// // // // // // // //                       label: const Text('Retry'),
// // // // // // // //                       style: ElevatedButton.styleFrom(
// // // // // // // //                         backgroundColor: Colors.deepPurple,
// // // // // // // //                         foregroundColor: Colors.white,
// // // // // // // //                       ),
// // // // // // // //                     ),
// // // // // // // //                   ],
// // // // // // // //                 ),
// // // // // // // //               ),
// // // // // // // //             )
// // // // // // // //           : _template == null
// // // // // // // //           ? const Center(child: Text("No poster data available"))
// // // // // // // //           : Column(
// // // // // // // //               children: [
// // // // // // // //                 if (_showToolbar &&
// // // // // // // //                     (_selectedTextElement != null ||
// // // // // // // //                         _selectedImageElement != null))
// // // // // // // //                   _buildToolbar(),

// // // // // // // //                 Expanded(
// // // // // // // //                   child: GestureDetector(
// // // // // // // //                     onScaleStart: (details) {
// // // // // // // //                       _focusPoint = details.focalPoint;
// // // // // // // //                       _previousScale = _currentScale;
// // // // // // // //                       _startOffset = _currentOffset;
// // // // // // // //                     },
// // // // // // // //                     onScaleUpdate: (details) {
// // // // // // // //                       setState(() {
// // // // // // // //                         // Handle scaling
// // // // // // // //                         if (details.scale != 1.0) {
// // // // // // // //                           _currentScale = (_previousScale * details.scale)
// // // // // // // //                               .clamp(0.5, 3.0);
// // // // // // // //                         }

// // // // // // // //                         // Handle panning - this is the key fix
// // // // // // // //                         if (details.scale == 1.0) {
// // // // // // // //                           // Pure panning (no scaling)
// // // // // // // //                           final delta = details.focalPoint - _focusPoint;
// // // // // // // //                           _currentOffset = _startOffset + delta;
// // // // // // // //                         } else {
// // // // // // // //                           // Scaling with panning adjustment
// // // // // // // //                           // When scaling, we need to adjust the offset to keep the focal point stable
// // // // // // // //                           final focalPointDelta =
// // // // // // // //                               details.focalPoint - _focusPoint;
// // // // // // // //                           _currentOffset = _startOffset + focalPointDelta;
// // // // // // // //                         }
// // // // // // // //                       });
// // // // // // // //                     },
// // // // // // // //                     onScaleEnd: (details) {
// // // // // // // //                       _previousScale = _currentScale;
// // // // // // // //                       _startOffset = _currentOffset;
// // // // // // // //                     },
// // // // // // // //                     onTap: _deselectAll,
// // // // // // // //                     child: Transform(
// // // // // // // //                       transform: Matrix4.identity()
// // // // // // // //                         ..translate(_currentOffset.dx, _currentOffset.dy)
// // // // // // // //                         ..scale(_currentScale),
// // // // // // // //                       child: Center(
// // // // // // // //                         child: SingleChildScrollView(
// // // // // // // //                           scrollDirection: Axis.vertical,
// // // // // // // //                           child: SingleChildScrollView(
// // // // // // // //                             scrollDirection: Axis.horizontal,
// // // // // // // //                             child: RepaintBoundary(
// // // // // // // //                               key: _canvasKey,
// // // // // // // //                               child: Container(
// // // // // // // //                                 constraints: BoxConstraints(
// // // // // // // //                                   maxWidth:
// // // // // // // //                                       MediaQuery.of(context).size.width * 0.9,
// // // // // // // //                                   maxHeight:
// // // // // // // //                                       MediaQuery.of(context).size.height * 0.8,
// // // // // // // //                                 ),
// // // // // // // //                                 child: FittedBox(
// // // // // // // //                                   fit: BoxFit.contain,
// // // // // // // //                                   child: Container(
// // // // // // // //                                     width: _template!.width,
// // // // // // // //                                     height: _template!.height,
// // // // // // // //                                     decoration: BoxDecoration(
// // // // // // // //                                       color: _template!.backgroundColor,
// // // // // // // //                                       boxShadow: [
// // // // // // // //                                         BoxShadow(
// // // // // // // //                                           color: Colors.black.withOpacity(0.2),
// // // // // // // //                                           blurRadius: 10,
// // // // // // // //                                           offset: const Offset(0, 5),
// // // // // // // //                                         ),
// // // // // // // //                                       ],
// // // // // // // //                                     ),
// // // // // // // //                                     child: Stack(
// // // // // // // //                                       clipBehavior: Clip.hardEdge,
// // // // // // // //                                       children: [
// // // // // // // //                                         if (_template!.backgroundImage != null)
// // // // // // // //                                           Positioned.fill(
// // // // // // // //                                             child: Image.network(
// // // // // // // //                                               _template!.backgroundImage!,
// // // // // // // //                                               fit: BoxFit.fill,
// // // // // // // //                                               loadingBuilder: (context, child, loadingProgress) {
// // // // // // // //                                                 if (loadingProgress == null)
// // // // // // // //                                                   return child;
// // // // // // // //                                                 return Container(
// // // // // // // //                                                   color: Colors.grey[200],
// // // // // // // //                                                   child: Center(
// // // // // // // //                                                     child: Column(
// // // // // // // //                                                       mainAxisAlignment:
// // // // // // // //                                                           MainAxisAlignment
// // // // // // // //                                                               .center,
// // // // // // // //                                                       children: [
// // // // // // // //                                                         CircularProgressIndicator(
// // // // // // // //                                                           value:
// // // // // // // //                                                               loadingProgress
// // // // // // // //                                                                       .expectedTotalBytes !=
// // // // // // // //                                                                   null
// // // // // // // //                                                               ? loadingProgress
// // // // // // // //                                                                         .cumulativeBytesLoaded /
// // // // // // // //                                                                     loadingProgress
// // // // // // // //                                                                         .expectedTotalBytes!
// // // // // // // //                                                               : null,
// // // // // // // //                                                         ),
// // // // // // // //                                                         const SizedBox(
// // // // // // // //                                                           height: 8,
// // // // // // // //                                                         ),
// // // // // // // //                                                         const Text(
// // // // // // // //                                                           'Loading background...',
// // // // // // // //                                                         ),
// // // // // // // //                                                       ],
// // // // // // // //                                                     ),
// // // // // // // //                                                   ),
// // // // // // // //                                                 );
// // // // // // // //                                               },
// // // // // // // //                                               errorBuilder:
// // // // // // // //                                                   (context, error, stackTrace) {
// // // // // // // //                                                     return Container(
// // // // // // // //                                                       color: _template!
// // // // // // // //                                                           .backgroundColor,
// // // // // // // //                                                       child: const Center(
// // // // // // // //                                                         child: Column(
// // // // // // // //                                                           mainAxisAlignment:
// // // // // // // //                                                               MainAxisAlignment
// // // // // // // //                                                                   .center,
// // // // // // // //                                                           children: [
// // // // // // // //                                                             // Icon(
// // // // // // // //                                                             //   Icons.error,
// // // // // // // //                                                             //   size: 48,
// // // // // // // //                                                             //   color: Colors.red,
// // // // // // // //                                                             // ),
// // // // // // // //                                                             SizedBox(height: 8),
// // // // // // // //                                                             Text(
// // // // // // // //                                                               'Failed to load background',
// // // // // // // //                                                             ),
// // // // // // // //                                                           ],
// // // // // // // //                                                         ),
// // // // // // // //                                                       ),
// // // // // // // //                                                     );
// // // // // // // //                                                   },
// // // // // // // //                                             ),
// // // // // // // //                                           ),
// // // // // // // //                                         ..._template!.textElements.map(
// // // // // // // //                                           (element) =>
// // // // // // // //                                               _buildTextElement(element),
// // // // // // // //                                         ),
// // // // // // // //                                         ..._template!.imageElements.map(
// // // // // // // //                                           (element) =>
// // // // // // // //                                               _buildImageElement(element),
// // // // // // // //                                         ),
// // // // // // // //                                         if (_profileImageBytes != null &&
// // // // // // // //                                             _profileImageElement != null)
// // // // // // // //                                           _buildProfileImage(),
// // // // // // // //                                         if (_logoImage != null &&
// // // // // // // //                                             _logoImageElement != null)
// // // // // // // //                                           _buildLogoImage(),

// // // // // // // //                                         // Business Info Bar at Bottom of Poster
// // // // // // // //                                         Positioned(
// // // // // // // //                                           left: 0,
// // // // // // // //                                           right: 0,
// // // // // // // //                                           bottom: 0,
// // // // // // // //                                           child: GestureDetector(
// // // // // // // //                                             onTap: () {
// // // // // // // //                                               // Show options to edit business name or phone
// // // // // // // //                                               _showBottomInfoEditOptions();
// // // // // // // //                                             },
// // // // // // // //                                             child: Container(
// // // // // // // //                                               padding:
// // // // // // // //                                                   const EdgeInsets.symmetric(
// // // // // // // //                                                     horizontal: 20,
// // // // // // // //                                                     vertical: 15,
// // // // // // // //                                                   ),
// // // // // // // //                                               decoration: BoxDecoration(
// // // // // // // //                                                 gradient: LinearGradient(
// // // // // // // //                                                   colors: [
// // // // // // // //                                                     Colors.black.withOpacity(
// // // // // // // //                                                       0.8,
// // // // // // // //                                                     ),
// // // // // // // //                                                     Colors.black.withOpacity(
// // // // // // // //                                                       0.9,
// // // // // // // //                                                     ),
// // // // // // // //                                                   ],
// // // // // // // //                                                   begin: Alignment.topCenter,
// // // // // // // //                                                   end: Alignment.bottomCenter,
// // // // // // // //                                                 ),
// // // // // // // //                                                 border: Border(
// // // // // // // //                                                   top: BorderSide(
// // // // // // // //                                                     color: Colors.white
// // // // // // // //                                                         .withOpacity(0.3),
// // // // // // // //                                                     width: 1,
// // // // // // // //                                                   ),
// // // // // // // //                                                 ),
// // // // // // // //                                               ),
// // // // // // // //                                               child: Row(
// // // // // // // //                                                 children: [
// // // // // // // //                                                   // Business Name Section
// // // // // // // //                                                   Expanded(
// // // // // // // //                                                     child: GestureDetector(
// // // // // // // //                                                       onTap: () {
// // // // // // // //                                                         final nameElement = _template
// // // // // // // //                                                             ?.textElements
// // // // // // // //                                                             .firstWhere(
// // // // // // // //                                                               (e) =>
// // // // // // // //                                                                   e.id ==
// // // // // // // //                                                                   'name',
// // // // // // // //                                                               orElse: () =>
// // // // // // // //                                                                   TextElement(
// // // // // // // //                                                                     id: 'name',
// // // // // // // //                                                                     text:
// // // // // // // //                                                                         'Business Name',
// // // // // // // //                                                                     x: 0,
// // // // // // // //                                                                     y: 0,
// // // // // // // //                                                                   ),
// // // // // // // //                                                             );

// // // // // // // //                                                         if (nameElement !=
// // // // // // // //                                                             null) {
// // // // // // // //                                                           _showEditDialog(
// // // // // // // //                                                             title: 'Edit  Name',
// // // // // // // //                                                             currentValue:
// // // // // // // //                                                                 nameElement
// // // // // // // //                                                                     .text,
// // // // // // // //                                                             icon:
// // // // // // // //                                                                 Icons.business,

// // // // // // // //                                                             // onSave: (newValue) {
// // // // // // // //                                                             //   setState(() {
// // // // // // // //                                                             //     nameElement
// // // // // // // //                                                             //             .text =
// // // // // // // //                                                             //         newValue;
// // // // // // // //                                                             //   });
// // // // // // // //                                                             // },
// // // // // // // //                                                             onSave: (newValue) async {
// // // // // // // //                                                               await _updateBusinessName(
// // // // // // // //                                                                 newValue,
// // // // // // // //                                                               ); // Save to SharedPreferences
// // // // // // // //                                                               setState(() {
// // // // // // // //                                                                 nameElement
// // // // // // // //                                                                         .text =
// // // // // // // //                                                                     newValue;
// // // // // // // //                                                               });
// // // // // // // //                                                             },
// // // // // // // //                                                           );
// // // // // // // //                                                         }
// // // // // // // //                                                       },
// // // // // // // //                                                       child: Row(
// // // // // // // //                                                         children: [
// // // // // // // //                                                           Container(
// // // // // // // //                                                             padding:
// // // // // // // //                                                                 const EdgeInsets.all(
// // // // // // // //                                                                   8,
// // // // // // // //                                                                 ),
// // // // // // // //                                                             decoration: BoxDecoration(
// // // // // // // //                                                               color: Colors
// // // // // // // //                                                                   .purple
// // // // // // // //                                                                   .withOpacity(
// // // // // // // //                                                                     0.3,
// // // // // // // //                                                                   ),
// // // // // // // //                                                               borderRadius:
// // // // // // // //                                                                   BorderRadius.circular(
// // // // // // // //                                                                     8,
// // // // // // // //                                                                   ),
// // // // // // // //                                                             ),
// // // // // // // //                                                             child: const Icon(
// // // // // // // //                                                               Icons.business,
// // // // // // // //                                                               color:
// // // // // // // //                                                                   Colors.white,
// // // // // // // //                                                               size: 20,
// // // // // // // //                                                             ),
// // // // // // // //                                                           ),
// // // // // // // //                                                           const SizedBox(
// // // // // // // //                                                             width: 12,
// // // // // // // //                                                           ),
// // // // // // // //                                                           Expanded(
// // // // // // // //                                                             child: Column(
// // // // // // // //                                                               crossAxisAlignment:
// // // // // // // //                                                                   CrossAxisAlignment
// // // // // // // //                                                                       .start,
// // // // // // // //                                                               mainAxisSize:
// // // // // // // //                                                                   MainAxisSize
// // // // // // // //                                                                       .min,
// // // // // // // //                                                               children: [
// // // // // // // //                                                                 Row(
// // // // // // // //                                                                   children: [
// // // // // // // //                                                                     // const Text(
// // // // // // // //                                                                     //   'Business',
// // // // // // // //                                                                     //   style: TextStyle(
// // // // // // // //                                                                     //     fontSize:
// // // // // // // //                                                                     //         11,
// // // // // // // //                                                                     //     color: Colors
// // // // // // // //                                                                     //         .white70,
// // // // // // // //                                                                     //     fontWeight:
// // // // // // // //                                                                     //         FontWeight.w500,
// // // // // // // //                                                                     //   ),
// // // // // // // //                                                                     // ),
// // // // // // // //                                                                     const SizedBox(
// // // // // // // //                                                                       width: 4,
// // // // // // // //                                                                     ),
// // // // // // // //                                                                     // Icon(
// // // // // // // //                                                                     //   Icons
// // // // // // // //                                                                     //       .edit,
// // // // // // // //                                                                     //   size: 14,
// // // // // // // //                                                                     //   color: Colors
// // // // // // // //                                                                     //       .white
// // // // // // // //                                                                     //       .withOpacity(
// // // // // // // //                                                                     //         0.5,
// // // // // // // //                                                                     //       ),
// // // // // // // //                                                                     // ),
// // // // // // // //                                                                   ],
// // // // // // // //                                                                 ),
// // // // // // // //                                                                 const SizedBox(
// // // // // // // //                                                                   height: 3,
// // // // // // // //                                                                 ),
// // // // // // // //                                                                 Text(
// // // // // // // //                                                                   _template
// // // // // // // //                                                                           ?.textElements
// // // // // // // //                                                                           .firstWhere(
// // // // // // // //                                                                             (
// // // // // // // //                                                                               e,
// // // // // // // //                                                                             ) =>
// // // // // // // //                                                                                 e.id ==
// // // // // // // //                                                                                 'name',
// // // // // // // //                                                                             orElse: () => TextElement(
// // // // // // // //                                                                               id: 'name',
// // // // // // // //                                                                               text: 'Business Name',
// // // // // // // //                                                                               x: 0,
// // // // // // // //                                                                               y: 0,
// // // // // // // //                                                                             ),
// // // // // // // //                                                                           )
// // // // // // // //                                                                           .text ??
// // // // // // // //                                                                       'Business Name',
// // // // // // // //                                                                   style: TextStyle(
// // // // // // // //                                                                     fontSize:
// // // // // // // //                                                                         _businessNameFontSize, // UPDATED
// // // // // // // //                                                                     fontWeight:
// // // // // // // //                                                                         FontWeight
// // // // // // // //                                                                             .bold,
// // // // // // // //                                                                     color: Colors
// // // // // // // //                                                                         .white,
// // // // // // // //                                                                   ),
// // // // // // // //                                                                   maxLines: 1,
// // // // // // // //                                                                   overflow:
// // // // // // // //                                                                       TextOverflow
// // // // // // // //                                                                           .ellipsis,
// // // // // // // //                                                                 ),
// // // // // // // //                                                               ],
// // // // // // // //                                                             ),
// // // // // // // //                                                           ),
// // // // // // // //                                                         ],
// // // // // // // //                                                       ),
// // // // // // // //                                                     ),
// // // // // // // //                                                   ),

// // // // // // // //                                                   // Vertical Divider
// // // // // // // //                                                   Container(
// // // // // // // //                                                     height: 50,
// // // // // // // //                                                     width: 1,
// // // // // // // //                                                     margin:
// // // // // // // //                                                         const EdgeInsets.symmetric(
// // // // // // // //                                                           horizontal: 15,
// // // // // // // //                                                         ),
// // // // // // // //                                                     color: Colors.white
// // // // // // // //                                                         .withOpacity(0.3),
// // // // // // // //                                                   ),

// // // // // // // //                                                   // Phone Number Section
// // // // // // // //                                                   Expanded(
// // // // // // // //                                                     child: GestureDetector(
// // // // // // // //                                                       onTap: () {
// // // // // // // //                                                         final mobileElement = _template
// // // // // // // //                                                             ?.textElements
// // // // // // // //                                                             .firstWhere(
// // // // // // // //                                                               (e) =>
// // // // // // // //                                                                   e.id ==
// // // // // // // //                                                                   'mobile',
// // // // // // // //                                                               orElse: () =>
// // // // // // // //                                                                   TextElement(
// // // // // // // //                                                                     id: 'mobile',
// // // // // // // //                                                                     text:
// // // // // // // //                                                                         phoneNumber ??
// // // // // // // //                                                                         'Not Set',
// // // // // // // //                                                                     x: 0,
// // // // // // // //                                                                     y: 0,
// // // // // // // //                                                                   ),
// // // // // // // //                                                             );

// // // // // // // //                                                         if (mobileElement !=
// // // // // // // //                                                             null) {
// // // // // // // //                                                           _showEditDialog(
// // // // // // // //                                                             title:
// // // // // // // //                                                                 'Edit Number',
// // // // // // // //                                                             currentValue:
// // // // // // // //                                                                 mobileElement
// // // // // // // //                                                                     .text,
// // // // // // // //                                                             icon: Icons.phone,
// // // // // // // //                                                             keyboardType:
// // // // // // // //                                                                 TextInputType
// // // // // // // //                                                                     .phone,
// // // // // // // //                                                             onSave: (newValue) {
// // // // // // // //                                                               setState(() {
// // // // // // // //                                                                 mobileElement
// // // // // // // //                                                                         .text =
// // // // // // // //                                                                     newValue;
// // // // // // // //                                                                 phoneNumber =
// // // // // // // //                                                                     newValue;
// // // // // // // //                                                               });
// // // // // // // //                                                             },
// // // // // // // //                                                           );
// // // // // // // //                                                         }
// // // // // // // //                                                       },
// // // // // // // //                                                       child: Row(
// // // // // // // //                                                         children: [
// // // // // // // //                                                           const SizedBox(
// // // // // // // //                                                             width: 200,
// // // // // // // //                                                           ),
// // // // // // // //                                                           Container(
// // // // // // // //                                                             padding:
// // // // // // // //                                                                 const EdgeInsets.all(
// // // // // // // //                                                                   8,
// // // // // // // //                                                                 ),
// // // // // // // //                                                             decoration: BoxDecoration(
// // // // // // // //                                                               color: Colors.blue
// // // // // // // //                                                                   .withOpacity(
// // // // // // // //                                                                     0.3,
// // // // // // // //                                                                   ),
// // // // // // // //                                                               borderRadius:
// // // // // // // //                                                                   BorderRadius.circular(
// // // // // // // //                                                                     8,
// // // // // // // //                                                                   ),
// // // // // // // //                                                             ),
// // // // // // // //                                                             child: const Icon(
// // // // // // // //                                                               Icons.phone,
// // // // // // // //                                                               color:
// // // // // // // //                                                                   Colors.white,
// // // // // // // //                                                               size: 20,
// // // // // // // //                                                             ),
// // // // // // // //                                                           ),
// // // // // // // //                                                           const SizedBox(
// // // // // // // //                                                             width: 12,
// // // // // // // //                                                           ),
// // // // // // // //                                                           Expanded(
// // // // // // // //                                                             child: Column(
// // // // // // // //                                                               crossAxisAlignment:
// // // // // // // //                                                                   CrossAxisAlignment
// // // // // // // //                                                                       .start,
// // // // // // // //                                                               mainAxisSize:
// // // // // // // //                                                                   MainAxisSize
// // // // // // // //                                                                       .min,
// // // // // // // //                                                               children: [
// // // // // // // //                                                                 Row(
// // // // // // // //                                                                   children: [
// // // // // // // //                                                                     // const Text(
// // // // // // // //                                                                     //   'Phone',
// // // // // // // //                                                                     //   style: TextStyle(
// // // // // // // //                                                                     //     fontSize:
// // // // // // // //                                                                     //         14,
// // // // // // // //                                                                     //     color: Colors
// // // // // // // //                                                                     //         .white70,
// // // // // // // //                                                                     //     fontWeight:
// // // // // // // //                                                                     //         FontWeight.w500,
// // // // // // // //                                                                     //   ),
// // // // // // // //                                                                     // ),
// // // // // // // //                                                                     const SizedBox(
// // // // // // // //                                                                       width: 4,
// // // // // // // //                                                                     ),
// // // // // // // //                                                                     // Icon(
// // // // // // // //                                                                     //   Icons
// // // // // // // //                                                                     //       .edit,
// // // // // // // //                                                                     //   size: 11,
// // // // // // // //                                                                     //   color: Colors
// // // // // // // //                                                                     //       .white
// // // // // // // //                                                                     //       .withOpacity(
// // // // // // // //                                                                     //         0.5,
// // // // // // // //                                                                     //       ),
// // // // // // // //                                                                     // ),
// // // // // // // //                                                                   ],
// // // // // // // //                                                                 ),
// // // // // // // //                                                                 const SizedBox(
// // // // // // // //                                                                   height: 3,
// // // // // // // //                                                                 ),
// // // // // // // //                                                                 Text(
// // // // // // // //                                                                   phoneNumber ??
// // // // // // // //                                                                       _template
// // // // // // // //                                                                           ?.textElements
// // // // // // // //                                                                           .firstWhere(
// // // // // // // //                                                                             (
// // // // // // // //                                                                               e,
// // // // // // // //                                                                             ) =>
// // // // // // // //                                                                                 e.id ==
// // // // // // // //                                                                                 'mobile',
// // // // // // // //                                                                             orElse: () => TextElement(
// // // // // // // //                                                                               id: 'mobile',
// // // // // // // //                                                                               text: 'Not Set',
// // // // // // // //                                                                               x: 0,
// // // // // // // //                                                                               y: 0,
// // // // // // // //                                                                             ),
// // // // // // // //                                                                           )
// // // // // // // //                                                                           .text ??
// // // // // // // //                                                                       'Not Set',
// // // // // // // //                                                                   style: TextStyle(
// // // // // // // //                                                                     fontSize:
// // // // // // // //                                                                         _phoneNumberFontSize, // UPDATED
// // // // // // // //                                                                     fontWeight:
// // // // // // // //                                                                         FontWeight
// // // // // // // //                                                                             .bold,
// // // // // // // //                                                                     color: Colors
// // // // // // // //                                                                         .white,
// // // // // // // //                                                                   ),
// // // // // // // //                                                                   maxLines: 1,
// // // // // // // //                                                                   overflow:
// // // // // // // //                                                                       TextOverflow
// // // // // // // //                                                                           .ellipsis,
// // // // // // // //                                                                 ),
// // // // // // // //                                                               ],
// // // // // // // //                                                             ),
// // // // // // // //                                                           ),
// // // // // // // //                                                         ],
// // // // // // // //                                                       ),
// // // // // // // //                                                     ),
// // // // // // // //                                                   ),
// // // // // // // //                                                 ],
// // // // // // // //                                               ),
// // // // // // // //                                             ),
// // // // // // // //                                           ),
// // // // // // // //                                         ),
// // // // // // // //                                       ],
// // // // // // // //                                     ),
// // // // // // // //                                   ),
// // // // // // // //                                 ),
// // // // // // // //                               ),
// // // // // // // //                             ),
// // // // // // // //                           ),
// // // // // // // //                         ),
// // // // // // // //                       ),
// // // // // // // //                     ),
// // // // // // // //                   ),
// // // // // // // //                 ),

// // // // // // // //                 Container(
// // // // // // // //                   padding: const EdgeInsets.symmetric(
// // // // // // // //                     horizontal: 16,
// // // // // // // //                     vertical: 8,
// // // // // // // //                   ),
// // // // // // // //                   color: Colors.grey[200],
// // // // // // // //                   child: const Row(children: [
             
// // // // // // // //                     ],
// // // // // // // //                   ),
// // // // // // // //                 ),

// // // // // // // //                 const SizedBox(height: 20),

// // // // // // // //                 // Audio to Video Section
// // // // // // // //                 Container(
// // // // // // // //                   padding: const EdgeInsets.all(16),
// // // // // // // //                   child: Column(
// // // // // // // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // //                     children: [
// // // // // // // //                       // const Text(
// // // // // // // //                       //   "🎵 Audio to Video",
// // // // // // // //                       //   style: TextStyle(
// // // // // // // //                       //     fontSize: 18,
// // // // // // // //                       //     fontWeight: FontWeight.bold,
// // // // // // // //                       //     color: Colors.deepPurple,
// // // // // // // //                       //   ),
// // // // // // // //                       // ),
// // // // // // // //                       // const SizedBox(height: 8),
// // // // // // // //                       // const Text(
// // // // // // // //                       //   "Add audio to create a video slideshow of your poster",
// // // // // // // //                       //   style: TextStyle(color: Colors.grey, fontSize: 12),
// // // // // // // //                       // ),
// // // // // // // //                       // const SizedBox(height: 16),

// // // // // // // //                       // Audio Picker Button
// // // // // // // //                       // ElevatedButton.icon(
// // // // // // // //                       //   icon: const Icon(Icons.music_note),
// // // // // // // //                       //   label: const Text("Pick Audio (MP3/M4A/WAV)"),
// // // // // // // //                       //   onPressed: _pickAudio,
// // // // // // // //                       //   style: ElevatedButton.styleFrom(
// // // // // // // //                       //     minimumSize: const Size(double.infinity, 48),
// // // // // // // //                       //   ),
// // // // // // // //                       // ),
// // // // // // // //                       if (_audioFile != null) ...[
// // // // // // // //                         // const SizedBox(height: 16),
// // // // // // // //                         // Container(
// // // // // // // //                         //   padding: const EdgeInsets.all(12),
// // // // // // // //                         //   decoration: BoxDecoration(
// // // // // // // //                         //     color: Colors.green[50],
// // // // // // // //                         //     borderRadius: BorderRadius.circular(8),
// // // // // // // //                         //     border: Border.all(color: Colors.green),
// // // // // // // //                         //   ),
// // // // // // // //                         //   child: Row(
// // // // // // // //                         //     children: [
// // // // // // // //                         //       const Icon(Icons.check_circle, color: Colors.green),
// // // // // // // //                         //       const SizedBox(width: 12),
// // // // // // // //                         //       Expanded(
// // // // // // // //                         //         child: Text(
// // // // // // // //                         //           "Selected: ${_audioFile!.path.split('/').last}",
// // // // // // // //                         //           style: const TextStyle(fontSize: 12),
// // // // // // // //                         //           overflow: TextOverflow.ellipsis,
// // // // // // // //                         //         ),
// // // // // // // //                         //       ),
// // // // // // // //                         //       IconButton(
// // // // // // // //                         //         icon: const Icon(Icons.close, size: 18),
// // // // // // // //                         //         onPressed: () {
// // // // // // // //                         //           setState(() {
// // // // // // // //                         //             _audioFile = null;
// // // // // // // //                         //             _videoPath = null;
// // // // // // // //                         //             _videoReady = false;
// // // // // // // //                         //           });
// // // // // // // //                         //         },
// // // // // // // //                         //       ),
// // // // // // // //                         //     ],
// // // // // // // //                         //   ),
// // // // // // // //                         // ),
// // // // // // // //                         // const SizedBox(height: 16),

// // // // // // // //                         // Create Video Button
// // // // // // // //                         // Create Video Button - IMPROVED VERSION
// // // // // // // //                         SizedBox(
// // // // // // // //                           width: double.infinity,
// // // // // // // //                           child: ElevatedButton(
// // // // // // // //                             onPressed: _exportingVideo ? null : _exportVideo,
// // // // // // // //                             style: ElevatedButton.styleFrom(
// // // // // // // //                               padding: const EdgeInsets.symmetric(vertical: 16),
// // // // // // // //                               backgroundColor: Colors.deepPurple,
// // // // // // // //                               foregroundColor: Colors.white,
// // // // // // // //                               shape: RoundedRectangleBorder(
// // // // // // // //                                 borderRadius: BorderRadius.circular(12),
// // // // // // // //                               ),
// // // // // // // //                             ),
// // // // // // // //                             child: _exportingVideo
// // // // // // // //                                 ? Row(
// // // // // // // //                                     mainAxisAlignment: MainAxisAlignment.center,
// // // // // // // //                                     children: [
// // // // // // // //                                       SizedBox(
// // // // // // // //                                         height: 20,
// // // // // // // //                                         width: 20,
// // // // // // // //                                         child: CircularProgressIndicator(
// // // // // // // //                                           strokeWidth: 2,
// // // // // // // //                                           color: Colors.white,
// // // // // // // //                                         ),
// // // // // // // //                                       ),
// // // // // // // //                                       const SizedBox(width: 12),
// // // // // // // //                                       Text(
// // // // // // // //                                         "Creating Video...",
// // // // // // // //                                         style: TextStyle(
// // // // // // // //                                           fontSize: 16,
// // // // // // // //                                           color: Colors.white,
// // // // // // // //                                         ),
// // // // // // // //                                       ),
// // // // // // // //                                     ],
// // // // // // // //                                   )
// // // // // // // //                                 : Row(
// // // // // // // //                                     mainAxisAlignment: MainAxisAlignment.center,
// // // // // // // //                                     children: [
// // // // // // // //                                       Icon(Icons.videocam),
// // // // // // // //                                       SizedBox(width: 8),
// // // // // // // //                                       Text(
// // // // // // // //                                         "Create Video",
// // // // // // // //                                         style: TextStyle(fontSize: 16),
// // // // // // // //                                       ),
// // // // // // // //                                     ],
// // // // // // // //                                   ),
// // // // // // // //                           ),
// // // // // // // //                         ),
// // // // // // // //                       ],

// // // // // // // //                       // Video Preview
// // // // // // // //                       if (_videoReady && _videoController != null) ...[
// // // // // // // //                         const SizedBox(height: 24),
// // // // // // // //                         const Text(
// // // // // // // //                           "Video Preview:",
// // // // // // // //                           style: TextStyle(fontWeight: FontWeight.bold),
// // // // // // // //                         ),
// // // // // // // //                         const SizedBox(height: 12),
// // // // // // // //                         AspectRatio(
// // // // // // // //                           aspectRatio: _videoController!.value.aspectRatio,
// // // // // // // //                           child: ClipRRect(
// // // // // // // //                             borderRadius: BorderRadius.circular(12),
// // // // // // // //                             child: Stack(
// // // // // // // //                               children: [
// // // // // // // //                                 VideoPlayer(_videoController!),
// // // // // // // //                                 Positioned.fill(
// // // // // // // //                                   child: Align(
// // // // // // // //                                     alignment: Alignment.center,
// // // // // // // //                                     child: IconButton(
// // // // // // // //                                       icon: Icon(
// // // // // // // //                                         _videoController!.value.isPlaying
// // // // // // // //                                             ? Icons.pause_circle_filled
// // // // // // // //                                             : Icons.play_circle_filled,
// // // // // // // //                                         size: 48,
// // // // // // // //                                         color: Colors.white.withOpacity(0.8),
// // // // // // // //                                       ),
// // // // // // // //                                       onPressed: () {
// // // // // // // //                                         setState(() {
// // // // // // // //                                           if (_videoController!
// // // // // // // //                                               .value
// // // // // // // //                                               .isPlaying) {
// // // // // // // //                                             _videoController!.pause();
// // // // // // // //                                           } else {
// // // // // // // //                                             _videoController!.play();
// // // // // // // //                                           }
// // // // // // // //                                         });
// // // // // // // //                                       },
// // // // // // // //                                     ),
// // // // // // // //                                   ),
// // // // // // // //                                 ),
// // // // // // // //                               ],
// // // // // // // //                             ),
// // // // // // // //                           ),
// // // // // // // //                         ),
// // // // // // // //                         const SizedBox(height: 16),

// // // // // // // //                         // Video Actions
// // // // // // // //                         Row(
// // // // // // // //                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// // // // // // // //                           children: [
// // // // // // // //                             Expanded(
// // // // // // // //                               child: OutlinedButton.icon(
// // // // // // // //                                 icon: const Icon(Icons.download),
// // // // // // // //                                 label: const Text("Download"),
// // // // // // // //                                 onPressed: _downloadVideo,
// // // // // // // //                                 style: OutlinedButton.styleFrom(
// // // // // // // //                                   padding: const EdgeInsets.symmetric(
// // // // // // // //                                     vertical: 12,
// // // // // // // //                                   ),
// // // // // // // //                                 ),
// // // // // // // //                               ),
// // // // // // // //                             ),
// // // // // // // //                             const SizedBox(width: 12),
// // // // // // // //                             Expanded(
// // // // // // // //                               child: ElevatedButton.icon(
// // // // // // // //                                 icon: const Icon(Icons.share),
// // // // // // // //                                 label: const Text("Share"),
// // // // // // // //                                 onPressed: _shareVideo,
// // // // // // // //                                 style: ElevatedButton.styleFrom(
// // // // // // // //                                   padding: const EdgeInsets.symmetric(
// // // // // // // //                                     vertical: 12,
// // // // // // // //                                   ),
// // // // // // // //                                   backgroundColor: Colors.deepPurple,
// // // // // // // //                                   foregroundColor: Colors.white,
// // // // // // // //                                 ),
// // // // // // // //                               ),
// // // // // // // //                             ),
// // // // // // // //                           ],
// // // // // // // //                         ),
// // // // // // // //                       ],

// // // // // // // //                       if (_videoPath != null) ...[
// // // // // // // //                         const SizedBox(height: 12),
// // // // // // // //                         Text(
// // // // // // // //                           "Generated: ${_videoPath!.split('/').last}",
// // // // // // // //                           textAlign: TextAlign.center,
// // // // // // // //                           style: const TextStyle(
// // // // // // // //                             fontSize: 10,
// // // // // // // //                             color: Colors.grey,
// // // // // // // //                           ),
// // // // // // // //                         ), 
// // // // // // // //                       ],
// // // // // // // //                     ],
// // // // // // // //                   ),
// // // // // // // //                 ),
// // // // // // // //               ],
// // // // // // // //             ),
// // // // // // // //     );
// // // // // // // //   }
// // // // // // // // }























































































// import 'dart:io';
// import 'dart:math';
// import 'dart:ui' as ui;
// import 'dart:typed_data';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// import 'package:gal/gal.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:posternova/helper/storage_helper.dart';
// import 'package:posternova/providers/customer/customer_provider.dart';
// import 'package:posternova/views/chat/chat_module.dart';
// import 'package:posternova/widgets/language_widget.dart';
// import 'package:provider/provider.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// // ════════════════════════════════════════════════════════
// //  ENUMS
// // ════════════════════════════════════════════════════════

// enum BottomTab { none, text, frames, effects, animation, design }

// enum PosterAnimation { none, flipInX, flipInY, wobble, rollIn, largeZoom, rotateLeft, rotateRight, bounce, fadeIn }

// enum PosterEffectType { none, sparkle, stars, snow, confetti }


// enum BarLayoutStyle {
//   classic,
//   stacked,
//   badgeChip,
//   centered,
//   cardSplit,
//   minimal,
//   ribbon,
//   neon,
//   wave,
//   magazine,
// }

// class BottomBarDesign {
//   final String id;
//   final String name;
//   final BarLayoutStyle layoutStyle;
//   final Gradient? gradient;
//   final Color? solidColor;
//   final Color primaryColor;
//   final Color secondaryColor;
//   final Color iconBgColor;
//   final Color dividerColor;
//   final double borderRadiusTop;
//   final bool showTopBorder;
//   final Color topBorderColor;
//   final bool showIcons;
//   final double elevation;

//   const BottomBarDesign({
//     required this.id,
//     required this.name,
//     required this.layoutStyle,
//     required this.primaryColor,
//     required this.secondaryColor,
//     required this.iconBgColor,
//     required this.dividerColor,
//     this.gradient,
//     this.solidColor,
//     this.borderRadiusTop = 0,
//     this.showTopBorder = true,
//     this.topBorderColor = const Color(0x33FFFFFF),
//     this.showIcons = true,
//     this.elevation = 0,
//   });
// }

// const List<BottomBarDesign> kBottomBarDesigns = [
//   BottomBarDesign(id: 'classic', name: 'Classic', layoutStyle: BarLayoutStyle.classic, solidColor: Color(0xF0000000), primaryColor: Colors.white, secondaryColor: Color(0xAAFFFFFF), iconBgColor: Color(0x449C27B0), dividerColor: Colors.white30, topBorderColor: Colors.white24),
//   BottomBarDesign(id: 'stacked', name: 'Stacked', layoutStyle: BarLayoutStyle.stacked, gradient: LinearGradient(colors: [Color(0xFF1A237E), Color(0xFF283593)], begin: Alignment.topLeft, end: Alignment.bottomRight), primaryColor: Colors.white, secondaryColor: Color(0xAAFFFFFF), iconBgColor: Color(0x447986CB), dividerColor: Color(0x557986CB), topBorderColor: Color(0x887986CB)),
//   BottomBarDesign(id: 'badge', name: 'Badge', layoutStyle: BarLayoutStyle.badgeChip, solidColor: Color(0xFF1A1A1A), primaryColor: Color(0xFFFFE500), secondaryColor: Colors.white70, iconBgColor: Color(0x44FFE500), dividerColor: Colors.transparent, topBorderColor: Color(0x88FFE500), showTopBorder: true),
//   BottomBarDesign(id: 'centered', name: 'Centered', layoutStyle: BarLayoutStyle.centered, gradient: LinearGradient(colors: [Color(0xFF880E4F), Color(0xFFAD1457)], begin: Alignment.centerLeft, end: Alignment.centerRight), primaryColor: Colors.white, secondaryColor: Color(0xDDFFFFFF), iconBgColor: Colors.transparent, dividerColor: Colors.white30, topBorderColor: Color(0x55F48FB1), showIcons: false),
//   BottomBarDesign(id: 'card_split', name: 'Cards', layoutStyle: BarLayoutStyle.cardSplit, solidColor: Color(0xEE111111), primaryColor: Colors.white, secondaryColor: Color(0xAAFFFFFF), iconBgColor: Color(0x4400BCD4), dividerColor: Colors.transparent, topBorderColor: Colors.transparent, showTopBorder: false, elevation: 8),
//   BottomBarDesign(id: 'minimal', name: 'Minimal', layoutStyle: BarLayoutStyle.minimal, solidColor: Color(0xCC000000), primaryColor: Color(0xFFFFFFFF), secondaryColor: Color(0x99FFFFFF), iconBgColor: Colors.transparent, dividerColor: Color(0x55FFFFFF), topBorderColor: Colors.transparent, showIcons: false, showTopBorder: false),
//   BottomBarDesign(id: 'ribbon', name: 'Ribbon', layoutStyle: BarLayoutStyle.ribbon, gradient: LinearGradient(colors: [Color(0xFF004D40), Color(0xFF00695C), Color(0xFF00897B)], begin: Alignment.centerLeft, end: Alignment.centerRight), primaryColor: Colors.white, secondaryColor: Color(0xCCFFFFFF), iconBgColor: Color(0x4480CBC4), dividerColor: Colors.white30, topBorderColor: Color(0x8880CBC4)),
//   BottomBarDesign(id: 'neon', name: 'Neon', layoutStyle: BarLayoutStyle.neon, solidColor: Color(0xFF0A0A0A), primaryColor: Color(0xFF00FF88), secondaryColor: Color(0xAA00FF88), iconBgColor: Color(0x2200FF88), dividerColor: Color(0x8800FF88), topBorderColor: Color(0xFF00FF88), elevation: 0),
//   BottomBarDesign(id: 'wave', name: 'Wave', layoutStyle: BarLayoutStyle.wave, gradient: LinearGradient(colors: [Color(0xFF4A148C), Color(0xFF6A1B9A)], begin: Alignment.topLeft, end: Alignment.bottomRight), primaryColor: Colors.white, secondaryColor: Color(0xCCFFFFFF), iconBgColor: Color(0x44CE93D8), dividerColor: Colors.white24, topBorderColor: Colors.transparent, showTopBorder: false, borderRadiusTop: 24),
//   BottomBarDesign(id: 'magazine', name: 'Magazine', layoutStyle: BarLayoutStyle.magazine, gradient: LinearGradient(colors: [Color(0xFFB71C1C), Color(0xFFC62828)], begin: Alignment.centerLeft, end: Alignment.centerRight), primaryColor: Colors.white, secondaryColor: Color(0xCCFFFFFF), iconBgColor: Color(0x44EF9A9A), dividerColor: Colors.white30, topBorderColor: Color(0x55EF9A9A)),
//   BottomBarDesign(id: 'gold', name: 'Gold', layoutStyle: BarLayoutStyle.classic, gradient: LinearGradient(colors: [Color(0xFF1A1A1A), Color(0xFF3D2B00)], begin: Alignment.centerLeft, end: Alignment.centerRight), primaryColor: Color(0xFFFFD700), secondaryColor: Color(0xAAFFD700), iconBgColor: Color(0x44FFD700), dividerColor: Color(0x66FFD700), topBorderColor: Color(0xAAFFD700)),
//   BottomBarDesign(id: 'white', name: 'White', layoutStyle: BarLayoutStyle.stacked, solidColor: Colors.white, primaryColor: Color(0xFF1A1A1A), secondaryColor: Color(0x996A1B9A), iconBgColor: Color(0x1A6A1B9A), dividerColor: Color(0x226A1B9A), topBorderColor: Color(0x336A1B9A), borderRadiusTop: 18),
// ];

// // ════════════════════════════════════════════════════════
// //  SPARKLE EFFECT
// // ════════════════════════════════════════════════════════

// class _Sparkle {
//   double x, y, size, opacity, speed, rotation, rotationSpeed;
//   _Sparkle({required this.x, required this.y, required this.size, required this.opacity, required this.speed, required this.rotation, required this.rotationSpeed});
// }

// class _SparkleParticlesPainter extends CustomPainter {
//   final List<_Sparkle> sparkles;
//   final PosterEffectType effectType;
//   _SparkleParticlesPainter(this.sparkles, this.effectType);

//   @override
//   void paint(Canvas canvas, Size size) {
//     for (final s in sparkles) {
//       final paint = Paint()
//         ..color = _color(effectType).withOpacity(s.opacity.clamp(0.0, 1.0))
//         ..style = PaintingStyle.fill;
//       canvas.save();
//       canvas.translate(s.x * size.width, s.y * size.height);
//       canvas.rotate(s.rotation);
//       switch (effectType) {
//         case PosterEffectType.sparkle: _drawSparkle(canvas, paint, s.size); break;
//         case PosterEffectType.stars: _drawStar(canvas, paint, s.size); break;
//         case PosterEffectType.snow: canvas.drawCircle(Offset.zero, s.size * 0.5, paint); break;
//         case PosterEffectType.confetti:
//           canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: s.size * 0.6, height: s.size * 1.2), paint); break;
//         default: break;
//       }
//       canvas.restore();
//     }
//   }

//   Color _color(PosterEffectType t) {
//     switch (t) {
//       case PosterEffectType.sparkle: return Colors.white;
//       case PosterEffectType.stars: return Colors.yellowAccent;
//       case PosterEffectType.snow: return Colors.lightBlueAccent;
//       case PosterEffectType.confetti: return Colors.pinkAccent;
//       default: return Colors.white;
//     }
//   }

//   void _drawSparkle(Canvas canvas, Paint paint, double size) {
//     final path = Path();
//     for (int i = 0; i < 8; i++) {
//       final angle = i * pi / 4;
//       final r = i.isEven ? size : size * 0.25;
//       final x = cos(angle) * r; final y = sin(angle) * r;
//       i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
//     }
//     path.close();
//     canvas.drawPath(path, paint);
//     canvas.drawPath(path, Paint()..color = Colors.white.withOpacity(paint.color.opacity * 0.3)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));
//   }

//   void _drawStar(Canvas canvas, Paint paint, double size) {
//     final path = Path();
//     for (int i = 0; i < 10; i++) {
//       final angle = i * pi / 5 - pi / 2;
//       final r = i.isEven ? size : size * 0.4;
//       final x = cos(angle) * r; final y = sin(angle) * r;
//       i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
//     }
//     path.close();
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(_SparkleParticlesPainter old) => true;
// }

// class PosterEffectOverlay extends StatefulWidget {
//   final PosterEffectType effectType;
//   final double width, height;
//   const PosterEffectOverlay({super.key, required this.effectType, required this.width, required this.height});

//   @override
//   State<PosterEffectOverlay> createState() => _PosterEffectOverlayState();
// }

// class _PosterEffectOverlayState extends State<PosterEffectOverlay> with SingleTickerProviderStateMixin {
//   late AnimationController _ctrl;
//   late List<_Sparkle> _sparkles;
//   final Random _rnd = Random();

//   @override
//   void initState() {
//     super.initState();
//     _initSparkles();
//     _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..addListener(_update);
//     if (widget.effectType != PosterEffectType.none) _ctrl.repeat();
//   }

//   @override
//   void didUpdateWidget(PosterEffectOverlay old) {
//     super.didUpdateWidget(old);
//     if (widget.effectType != old.effectType) {
//       _initSparkles();
//       widget.effectType != PosterEffectType.none ? _ctrl.repeat() : _ctrl.stop();
//     }
//   }

//   int get _count {
//     switch (widget.effectType) {
//       case PosterEffectType.sparkle: return 20;
//       case PosterEffectType.stars: return 25;
//       case PosterEffectType.snow: return 35;
//       case PosterEffectType.confetti: return 30;
//       default: return 0;
//     }
//   }

//   void _initSparkles() => _sparkles = List.generate(_count, (_) => _rand());

//   _Sparkle _rand() => _Sparkle(x: _rnd.nextDouble(), y: _rnd.nextDouble(), size: _rnd.nextDouble() * 14 + 6,
//       opacity: _rnd.nextDouble(), speed: _rnd.nextDouble() * 0.003 + 0.001,
//       rotation: _rnd.nextDouble() * 2 * pi, rotationSpeed: (_rnd.nextDouble() - 0.5) * 0.05);

//   void _update() {
//     if (!mounted) return;
//     setState(() {
//       for (final s in _sparkles) {
//         s.rotation += s.rotationSpeed;
//         s.opacity = (s.opacity + (_rnd.nextDouble() - 0.5) * 0.15).clamp(0.1, 1.0);
//         switch (widget.effectType) {
//           case PosterEffectType.snow: s.y += s.speed; s.x += sin(s.rotation) * 0.002; break;
//           case PosterEffectType.confetti: s.y += s.speed * 1.5; s.x += cos(s.rotation) * 0.003; break;
//           case PosterEffectType.sparkle:
//           case PosterEffectType.stars:
//             if (_rnd.nextDouble() < 0.02) { s.x = _rnd.nextDouble(); s.y = _rnd.nextDouble(); s.opacity = 1.0; s.size = _rnd.nextDouble() * 18 + 6; }
//             break;
//           default: break;
//         }
//         if (s.y > 1.05 || s.x < -0.05 || s.x > 1.05) { s.x = _rnd.nextDouble(); s.y = -0.05; s.opacity = 0.8; }
//       }
//     });
//   }

//   @override
//   void dispose() { _ctrl.dispose(); super.dispose(); }

//   @override
//   Widget build(BuildContext context) {
//     if (widget.effectType == PosterEffectType.none) return const SizedBox.shrink();
//     return IgnorePointer(child: SizedBox(width: widget.width, height: widget.height,
//         child: CustomPaint(painter: _SparkleParticlesPainter(_sparkles, widget.effectType))));
//   }
// }

// // ════════════════════════════════════════════════════════
// //  FRAME MODEL & PAINTER
// // ════════════════════════════════════════════════════════

// class PosterFrame {
//   final String id, name;
//   final Color borderColor;
//   final double borderWidth, borderRadius;
//   final List<Color> gradientColors;
//   final bool isDefault;

//   const PosterFrame({
//     required this.id, required this.name, required this.borderColor,
//     this.borderWidth = 8.0, this.borderRadius = 0.0,
//     this.gradientColors = const [], this.isDefault = false,
//   });
// }

// class FrameBorderPainter extends CustomPainter {
//   final PosterFrame frame;
//   FrameBorderPainter(this.frame);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final hw = frame.borderWidth / 2;
//     final rrect = RRect.fromRectAndRadius(
//       Rect.fromLTWH(hw, hw, size.width - frame.borderWidth, size.height - frame.borderWidth),
//       Radius.circular(frame.borderRadius),
//     );
//     if (frame.gradientColors.isNotEmpty) {
//       canvas.drawRRect(rrect, Paint()
//         ..shader = LinearGradient(colors: frame.gradientColors, begin: Alignment.topLeft, end: Alignment.bottomRight)
//             .createShader(Rect.fromLTWH(0, 0, size.width, size.height))
//         ..style = PaintingStyle.stroke ..strokeWidth = frame.borderWidth);
//     } else {
//       canvas.drawRRect(rrect, Paint()..color = frame.borderColor..style = PaintingStyle.stroke..strokeWidth = frame.borderWidth);
//     }
//   }

//   @override
//   bool shouldRepaint(FrameBorderPainter old) => true;
// }

// // ════════════════════════════════════════════════════════
// //  ANIMATION WRAPPER
// // ════════════════════════════════════════════════════════

// class AnimatedPosterWrapper extends StatefulWidget {
//   final PosterAnimation animation;
//   final Widget child;
//   const AnimatedPosterWrapper({super.key, required this.animation, required this.child});

//   @override
//   State<AnimatedPosterWrapper> createState() => _AnimatedPosterWrapperState();
// }

// class _AnimatedPosterWrapperState extends State<AnimatedPosterWrapper> with SingleTickerProviderStateMixin {
//   late AnimationController _ctrl;
//   late Animation<double> _anim;

//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
//     _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
//     if (widget.animation != PosterAnimation.none) _ctrl.repeat(reverse: true);
//   }

//   @override
//   void didUpdateWidget(AnimatedPosterWrapper old) {
//     super.didUpdateWidget(old);
//     if (widget.animation != old.animation) {
//       if (widget.animation == PosterAnimation.none) { _ctrl.stop(); _ctrl.reset(); }
//       else _ctrl.repeat(reverse: true);
//     }
//   }

//   @override
//   void dispose() { _ctrl.dispose(); super.dispose(); }

//   @override
//   Widget build(BuildContext context) {
//     if (widget.animation == PosterAnimation.none) return widget.child;
//     return AnimatedBuilder(
//       animation: _anim,
//       builder: (_, child) {
//         switch (widget.animation) {
//           case PosterAnimation.flipInX:
//             return Transform(alignment: Alignment.center, transform: Matrix4.identity()..rotateX((_anim.value - 0.5) * 0.3), child: child);
//           case PosterAnimation.flipInY:
//             return Transform(alignment: Alignment.center, transform: Matrix4.identity()..rotateY((_anim.value - 0.5) * 0.3), child: child);
//           case PosterAnimation.wobble:
//             return Transform.rotate(angle: sin(_anim.value * 2 * pi) * 0.04, child: child);
//           case PosterAnimation.rollIn:
//             return Transform.rotate(angle: (_anim.value - 0.5) * 0.15, child: child);
//           case PosterAnimation.largeZoom:
//             return Transform.scale(scale: 1.0 + _anim.value * 0.04, child: child);
//           case PosterAnimation.rotateLeft:
//             return Transform.rotate(angle: -_anim.value * 0.06, child: child);
//           case PosterAnimation.rotateRight:
//             return Transform.rotate(angle: _anim.value * 0.06, child: child);
//           case PosterAnimation.bounce:
//             return Transform.translate(offset: Offset(0, -_anim.value * 8), child: child);
//           case PosterAnimation.fadeIn:
//             return Opacity(opacity: 0.85 + _anim.value * 0.15, child: child);
//           default: return child!;
//         }
//       },
//       child: widget.child,
//     );
//   }
// }

// // ════════════════════════════════════════════════════════
// //  BOTTOM PANELS
// // ════════════════════════════════════════════════════════

// // ── FRAMES PANEL ──
// class FramesPanel extends StatefulWidget {
//   final PosterFrame? selectedFrame;
//   final ValueChanged<PosterFrame?> onFrameSelected;
//   const FramesPanel({super.key, required this.selectedFrame, required this.onFrameSelected});

//   @override
//   State<FramesPanel> createState() => _FramesPanelState();
// }

// class _FramesPanelState extends State<FramesPanel> {
//   int _selectedColorIndex = -1;

//   static const List<Color> _suggestedColors = [
//     Color(0xFF00BFA5), Color(0xFF8D6E63), Color(0xFF90A4AE), Color(0xFF66BB6A),
//     Color(0xFFFFA726), Color(0xFF26A69A), Color(0xFF4CAF50), Color(0xFF00ACC1), Color(0xFFB2DFDB),
//   ];

//   final List<PosterFrame> _frames = const [
//     PosterFrame(id: 'default', name: 'Use\nDefault', borderColor: Colors.transparent, isDefault: true),
//     PosterFrame(id: 'gold', name: 'Gold', borderColor: Color(0xFFFFD700), borderWidth: 10, gradientColors: [Color(0xFFFFD700), Color(0xFFFFA000)]),
//     PosterFrame(id: 'modern', name: 'Modern', borderColor: Color(0xFF2196F3), borderWidth: 8, borderRadius: 12),
//     PosterFrame(id: 'elegant', name: 'Elegant', borderColor: Color(0xFF9C27B0), borderWidth: 12, gradientColors: [Color(0xFF9C27B0), Color(0xFFE040FB)]),
//     PosterFrame(id: 'business', name: 'Business', borderColor: Color(0xFF37474F), borderWidth: 8),
//     PosterFrame(id: 'nature', name: 'Nature', borderColor: Color(0xFF388E3C), borderWidth: 10, borderRadius: 8),
//     PosterFrame(id: 'sunset', name: 'Sunset', borderColor: Color(0xFFFF5722), borderWidth: 10, gradientColors: [Color(0xFFFF5722), Color(0xFFFF9800)]),
//     PosterFrame(id: 'ocean', name: 'Ocean', borderColor: Color(0xFF0288D1), borderWidth: 10, gradientColors: [Color(0xFF0288D1), Color(0xFF00BCD4)], borderRadius: 16),
//     PosterFrame(id: 'rose', name: 'Rose', borderColor: Color(0xFFE91E63), borderWidth: 8, gradientColors: [Color(0xFFE91E63), Color(0xFFF48FB1)]),
//     PosterFrame(id: 'silver', name: 'Silver', borderColor: Color(0xFF9E9E9E), borderWidth: 10, gradientColors: [Color(0xFFBDBDBD), Color(0xFF757575)]),
//     PosterFrame(id: 'royal', name: 'Royal', borderColor: Color(0xFF283593), borderWidth: 12, gradientColors: [Color(0xFF283593), Color(0xFF3949AB)]),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.black87,
//       padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 12),
//           const Text('Suggested Colours', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
//           const SizedBox(height: 8),
//           SizedBox(
//             height: 36,
//             child: ListView.separated(
//               scrollDirection: Axis.horizontal,
//               itemCount: _suggestedColors.length,
//               separatorBuilder: (_, __) => const SizedBox(width: 8),
//               itemBuilder: (_, i) {
//                 final isSel = _selectedColorIndex == i;
//                 return GestureDetector(
//                   onTap: () {
//                     setState(() => _selectedColorIndex = i);
//                     widget.onFrameSelected(PosterFrame(id: 'color_$i', name: 'Color', borderColor: _suggestedColors[i], borderWidth: 10));
//                   },
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 200),
//                     width: 36, height: 36,
//                     decoration: BoxDecoration(
//                       color: _suggestedColors[i],
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: isSel ? Colors.white : Colors.transparent, width: 2.5),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           const SizedBox(height: 12),
//           SizedBox(
//             height: 108,
//             child: ListView.separated(
//               scrollDirection: Axis.horizontal,
//               itemCount: _frames.length,
//               separatorBuilder: (_, __) => const SizedBox(width: 10),
//               itemBuilder: (_, i) {
//                 final f = _frames[i];
//                 final isSel = widget.selectedFrame?.id == f.id;
//                 return GestureDetector(
//                   onTap: () { setState(() => _selectedColorIndex = -1); widget.onFrameSelected(f.isDefault ? null : f); },
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 200),
//                     width: 86, height: 108,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: isSel ? Colors.white : Colors.grey.shade300, width: isSel ? 2.5 : 1),
//                       boxShadow: isSel ? [BoxShadow(color: Colors.white.withOpacity(0.4), blurRadius: 8)] : [],
//                     ),
//                     child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//                       _FrameThumb(frame: f),
//                       const SizedBox(height: 6),
//                       Text(f.name, textAlign: TextAlign.center,
//                           style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Colors.black87)),
//                     ]),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _FrameThumb extends StatelessWidget {
//   final PosterFrame frame;
//   const _FrameThumb({required this.frame});

//   @override
//   Widget build(BuildContext context) {
//     if (frame.isDefault) {
//       return Container(width: 58, height: 66,
//         decoration: BoxDecoration(color: Colors.grey.shade100,
//           border: Border.all(color: const Color(0xFFFFE500), width: 2, style: BorderStyle.solid),
//           borderRadius: BorderRadius.circular(4)),
//         child: const Center(child: Text('Use\nDefault', textAlign: TextAlign.center, style: TextStyle(fontSize: 8, color: Colors.black54))));
//     }
//     if (frame.gradientColors.isNotEmpty) {
//       return Container(width: 58, height: 66,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(colors: frame.gradientColors, begin: Alignment.topLeft, end: Alignment.bottomRight),
//           borderRadius: BorderRadius.circular(frame.borderRadius)),
//         child: Container(margin: EdgeInsets.all(frame.borderWidth * 0.5), color: Colors.white));
//     }
//     return Container(width: 58, height: 66,
//       decoration: BoxDecoration(border: Border.all(color: frame.borderColor, width: 3), borderRadius: BorderRadius.circular(frame.borderRadius)));
//   }
// }

// // ── ANIMATION PANEL ──
// class AnimationPanel extends StatelessWidget {
//   final PosterAnimation currentAnimation;
//   final ValueChanged<PosterAnimation> onAnimationSelected;
//   const AnimationPanel({super.key, required this.currentAnimation, required this.onAnimationSelected});

//   static const List<({PosterAnimation type, String label, IconData icon})> _opts = [
//     (type: PosterAnimation.none, label: 'Remove', icon: Icons.block),
//     (type: PosterAnimation.flipInX, label: 'FlipInX', icon: Icons.flip),
//     (type: PosterAnimation.flipInY, label: 'FlipInY', icon: Icons.flip_camera_android),
//     (type: PosterAnimation.wobble, label: 'Wobble', icon: Icons.waves),
//     (type: PosterAnimation.rollIn, label: 'RollIn', icon: Icons.rotate_right),
//     (type: PosterAnimation.largeZoom, label: 'LargeZoom', icon: Icons.zoom_in),
//     (type: PosterAnimation.rotateLeft, label: 'RotateLeft', icon: Icons.rotate_left),
//     (type: PosterAnimation.rotateRight, label: 'RotateRight', icon: Icons.rotate_right_outlined),
//     (type: PosterAnimation.bounce, label: 'Bounce', icon: Icons.sports_basketball_outlined),
//     (type: PosterAnimation.fadeIn, label: 'FadeIn', icon: Icons.brightness_medium),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.black87,
//       padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
//       child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
//         const Text('Animation', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
//         const SizedBox(height: 12),
//         SizedBox(
//           height: 92,
//           child: ListView.separated(
//             scrollDirection: Axis.horizontal,
//             itemCount: _opts.length,
//             separatorBuilder: (_, __) => const SizedBox(width: 10),
//             itemBuilder: (_, i) {
//               final opt = _opts[i];
//               final isSel = currentAnimation == opt.type;
//               return GestureDetector(
//                 onTap: () => onAnimationSelected(opt.type),
//                 child: Column(mainAxisSize: MainAxisSize.min, children: [
//                   AnimatedContainer(
//                     duration: const Duration(milliseconds: 200),
//                     width: 64, height: 64,
//                     decoration: BoxDecoration(
//                       color: opt.type == PosterAnimation.none ? Colors.grey.shade800 : Colors.grey.shade900,
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(color: isSel ? Colors.white : Colors.grey.shade700, width: isSel ? 2.5 : 1),
//                       boxShadow: isSel ? [BoxShadow(color: Colors.white.withOpacity(0.3), blurRadius: 8)] : [],
//                     ),
//                     child: Center(
//                       child: opt.type == PosterAnimation.none
//                           ? const Text('Remove\nAnimation', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 8.5, fontWeight: FontWeight.w600))
//                           : Icon(opt.icon, color: const Color(0xFFFFE500), size: 28),
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(opt.label, textAlign: TextAlign.center,
//                       style: TextStyle(color: isSel ? Colors.white : Colors.white60, fontSize: 9, fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
//                 ]),
//               );
//             },
//           ),
//         ),
//       ]),
//     );
//   }
// }

// // ── TEXT TOOLS PANEL ──
// class TextToolsPanel extends StatelessWidget {
//   final VoidCallback onAddText, onAddLogo, onAddImage;
//   const TextToolsPanel({super.key, required this.onAddText, required this.onAddLogo, required this.onAddImage});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.black87,
//       padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
//       child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
//         const Text('Text & Elements', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
//         const SizedBox(height: 12),
//         Row(children: [
//           _ToolBtn(icon: Icons.text_fields, label: 'Add Text', onTap: onAddText),
//           const SizedBox(width: 12),
//           _ToolBtn(icon: Icons.image_outlined, label: 'Add Image', onTap: onAddImage),
//           const SizedBox(width: 12),
//           _ToolBtn(icon: Icons.business_center_outlined, label: 'Add Logo', onTap: onAddLogo),
//         ]),
//       ]),
//     );
//   }
// }

// class _ToolBtn extends StatelessWidget {
//   final IconData icon; final String label; final VoidCallback onTap;
//   const _ToolBtn({required this.icon, required this.label, required this.onTap});

//   @override
//   Widget build(BuildContext context) => GestureDetector(
//     onTap: onTap,
//     child: Container(width: 80, height: 80,
//       decoration: BoxDecoration(color: Colors.grey.shade900, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade700)),
//       child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//         Icon(icon, color: Colors.white, size: 28),
//         const SizedBox(height: 6),
//         Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 10)),
//       ])),
//   );
// }

// // ── EFFECTS PANEL ──
// class EffectsPanel extends StatelessWidget {
//   final PosterEffectType currentEffect;
//   final ValueChanged<PosterEffectType> onEffectSelected;
//   const EffectsPanel({super.key, required this.currentEffect, required this.onEffectSelected});

//   @override
//   Widget build(BuildContext context) {
//     final effects = [
//       _EffectOption(type: PosterEffectType.none, label: 'Remove', preview: _buildRemovePreview()),
//       _EffectOption(type: PosterEffectType.sparkle, label: 'Sparkle', preview: _buildSparklePreview()),
//       _EffectOption(type: PosterEffectType.stars, label: 'Stars', preview: _buildStarsPreview()),
//       _EffectOption(type: PosterEffectType.snow, label: 'Snow', preview: _buildSnowPreview()),
//       _EffectOption(type: PosterEffectType.confetti, label: 'Confetti', preview: _buildConfettiPreview()),
//     ];

//     return Container(
//       color: Colors.black87,
//       padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('Effect', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
//           const SizedBox(height: 12),
//           SizedBox(
//             height: 100,
//             child: ListView.separated(
//               scrollDirection: Axis.horizontal,
//               itemCount: effects.length,
//               separatorBuilder: (_, __) => const SizedBox(width: 10),
//               itemBuilder: (_, i) {
//                 final opt = effects[i];
//                 final isSelected = currentEffect == opt.type;
//                 return GestureDetector(
//                   onTap: () => onEffectSelected(opt.type),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       AnimatedContainer(
//                         duration: const Duration(milliseconds: 200),
//                         width: 68,
//                         height: 68,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color: isSelected ? Colors.white : Colors.transparent,
//                             width: 2.5,
//                           ),
//                           boxShadow: isSelected
//                               ? [BoxShadow(color: Colors.white.withOpacity(0.35), blurRadius: 10, spreadRadius: 2)]
//                               : [],
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(10),
//                           child: opt.preview,
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       Text(
//                         opt.label,
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: isSelected ? Colors.white : Colors.white60,
//                           fontSize: 10,
//                           fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildRemovePreview() => Container(
//     color: Colors.grey.shade800,
//     child: const Center(
//       child: Text('Remove\nEffect', textAlign: TextAlign.center,
//           style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white70)),
//     ),
//   );

//   Widget _buildSparklePreview() => Container(
//     color: const Color(0xFFFFB300),
//     child: Stack(children: [
//       Positioned(top: 8, left: 10, child: Icon(Icons.auto_awesome, color: Colors.white, size: 16)),
//       Positioned(bottom: 10, right: 6, child: Icon(Icons.auto_awesome, color: Colors.white, size: 22)),
//       Positioned(top: 28, right: 18, child: Icon(Icons.auto_awesome, color: Colors.white70, size: 11)),
//       Positioned(bottom: 22, left: 6, child: Icon(Icons.auto_awesome, color: Colors.white60, size: 10)),
//     ]),
//   );

//   Widget _buildStarsPreview() => Container(
//     color: const Color(0xFFFFD700),
//     child: Stack(children: [
//       Positioned(top: 8, left: 8, child: Icon(Icons.star, color: Colors.white, size: 18)),
//       Positioned(bottom: 8, right: 6, child: Icon(Icons.star, color: Colors.white, size: 22)),
//       Positioned(top: 30, right: 20, child: Icon(Icons.star, color: Colors.white70, size: 12)),
//       Positioned(bottom: 24, left: 4, child: Icon(Icons.star, color: Colors.white60, size: 10)),
//     ]),
//   );

//   Widget _buildSnowPreview() => Container(
//     color: const Color(0xFF64B5F6),
//     child: Stack(children: [
//       Positioned(top: 8, left: 10, child: Icon(Icons.ac_unit, color: Colors.white, size: 16)),
//       Positioned(bottom: 8, right: 8, child: Icon(Icons.ac_unit, color: Colors.white, size: 20)),
//       Positioned(top: 30, right: 18, child: Icon(Icons.ac_unit, color: Colors.white70, size: 11)),
//       Positioned(bottom: 26, left: 4, child: Icon(Icons.ac_unit, color: Colors.white60, size: 10)),
//     ]),
//   );

//   Widget _buildConfettiPreview() => Container(
//     color: const Color(0xFFE91E63),
//     child: Stack(children: [
//       Positioned(top: 8, left: 10, child: Icon(Icons.celebration, color: Colors.white, size: 16)),
//       Positioned(bottom: 8, right: 6, child: Icon(Icons.celebration, color: Colors.white, size: 22)),
//       Positioned(top: 30, right: 18, child: Icon(Icons.celebration, color: Colors.white70, size: 11)),
//       Positioned(bottom: 24, left: 4, child: Icon(Icons.celebration, color: Colors.white60, size: 10)),
//     ]),
//   );
// }

// class _EffectOption {
//   final PosterEffectType type;
//   final String label;
//   final Widget preview;
//   const _EffectOption({required this.type, required this.label, required this.preview});
// }

// // ── DESIGN PANEL (Bottom Bar Style) ──
// class DesignPanel extends StatelessWidget {
//   final BottomBarDesign currentDesign;
//   final ValueChanged<BottomBarDesign> onDesignSelected;
//   const DesignPanel({super.key, required this.currentDesign, required this.onDesignSelected});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.black87,
//       padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(children: [
//             const Text('Bottom Bar Style', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
//             const SizedBox(width: 10),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
//               decoration: BoxDecoration(color: const Color(0xFFFFE500), borderRadius: BorderRadius.circular(12)),
//               child: Text(currentDesign.name, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11)),
//             ),
//           ]),
//           const SizedBox(height: 12),
//           SizedBox(
//             height: 120,
//             child: ListView.separated(
//               scrollDirection: Axis.horizontal,
//               itemCount: kBottomBarDesigns.length,
//               separatorBuilder: (_, __) => const SizedBox(width: 10),
//               itemBuilder: (_, i) {
//                 final d = kBottomBarDesigns[i];
//                 final isSelected = currentDesign.id == d.id;
//                 return GestureDetector(
//                   onTap: () => onDesignSelected(d),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       AnimatedContainer(
//                         duration: const Duration(milliseconds: 200),
//                         width: 110,
//                         height: 94,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           border: Border.all(
//                             color: isSelected ? const Color(0xFFFFE500) : Colors.grey.shade700,
//                             width: isSelected ? 2.5 : 1,
//                           ),
//                           boxShadow: isSelected
//                               ? [BoxShadow(color: const Color(0xFFFFE500).withOpacity(0.3), blurRadius: 10, spreadRadius: 1)]
//                               : [],
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: _BarStylePreview(design: d),
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           if (isSelected) const Icon(Icons.check_circle, color: Color(0xFFFFE500), size: 12),
//                           if (isSelected) const SizedBox(width: 3),
//                           Text(d.name,
//                             style: TextStyle(
//                               color: isSelected ? const Color(0xFFFFE500) : Colors.white60,
//                               fontSize: 11,
//                               fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                             )),
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _BarStylePreview extends StatelessWidget {
//   final BottomBarDesign design;
//   const _BarStylePreview({required this.design});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: design.gradient,
//         color: design.gradient == null ? design.solidColor : null,
//       ),
//       child: Stack(
//         children: [
//           Positioned(top: 0, left: 0, right: 0, bottom: 40,
//             child: Container(color: const Color(0xFFE0E0E0),
//               child: Center(child: Icon(Icons.image, color: Colors.grey.shade400, size: 22)))),
//           Positioned(left: 0, right: 0, bottom: 0, height: 40,
//             child: _buildBarLayout()),
//         ],
//       ),
//     );
//   }

//   Widget _buildBarLayout() {
//     final tc = design.primaryColor;
//     final sc = design.secondaryColor;
//     final ibg = design.iconBgColor;

//     // Helper: flexible mock text bar that never overflows
//     Widget _bar(Color c, double maxW) => Flexible(
//       child: Container(
//         height: 4,
//         constraints: BoxConstraints(maxWidth: maxW),
//         decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(2)),
//       ),
//     );

//     switch (design.layoutStyle) {

//       // ── STACKED ──
//       case BarLayoutStyle.stacked:
//         return Container(
//           decoration: BoxDecoration(
//             gradient: design.gradient,
//             color: design.gradient == null ? design.solidColor : null,
//             border: design.showTopBorder ? Border(top: BorderSide(color: design.topBorderColor, width: 1)) : null,
//             borderRadius: design.borderRadiusTop > 0 ? BorderRadius.vertical(top: Radius.circular(design.borderRadiusTop)) : null,
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(children: [
//                 Icon(Icons.business, color: tc, size: 8),
//                 const SizedBox(width: 3),
//                 _bar(tc.withOpacity(0.9), 44),
//               ]),
//               const SizedBox(height: 3),
//               Row(children: [
//                 Icon(Icons.phone, color: sc, size: 8),
//                 const SizedBox(width: 3),
//                 _bar(sc.withOpacity(0.7), 32),
//               ]),
//             ],
//           ),
//         );

//       // ── BADGE CHIP ──
//       case BarLayoutStyle.badgeChip:
//         return Container(
//           decoration: BoxDecoration(
//             gradient: design.gradient,
//             color: design.gradient == null ? design.solidColor : null,
//             border: Border(top: BorderSide(color: design.topBorderColor, width: 1.5)),
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Flexible(
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
//                   decoration: BoxDecoration(
//                     color: ibg,
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(color: tc.withOpacity(0.5), width: 1),
//                   ),
//                   child: Row(mainAxisSize: MainAxisSize.min, children: [
//                     Icon(Icons.business, color: tc, size: 8),
//                     const SizedBox(width: 3),
//                     Flexible(child: Container(height: 4, constraints: const BoxConstraints(maxWidth: 18), decoration: BoxDecoration(color: tc, borderRadius: BorderRadius.circular(2)))),
//                   ]),
//                 ),
//               ),
//               const SizedBox(width: 4),
//               Flexible(
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
//                   decoration: BoxDecoration(
//                     color: ibg,
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(color: tc.withOpacity(0.5), width: 1),
//                   ),
//                   child: Row(mainAxisSize: MainAxisSize.min, children: [
//                     Icon(Icons.phone, color: tc, size: 8),
//                     const SizedBox(width: 3),
//                     Flexible(child: Container(height: 4, constraints: const BoxConstraints(maxWidth: 18), decoration: BoxDecoration(color: tc, borderRadius: BorderRadius.circular(2)))),
//                   ]),
//                 ),
//               ),
//             ],
//           ),
//         );

//       // ── CENTERED ──
//       case BarLayoutStyle.centered:
//         return Container(
//           decoration: BoxDecoration(
//             gradient: design.gradient,
//             color: design.gradient == null ? design.solidColor : null,
//             border: Border(top: BorderSide(color: design.topBorderColor, width: 1)),
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 8),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//                 Flexible(child: Container(height: 5, constraints: const BoxConstraints(maxWidth: 55), decoration: BoxDecoration(color: tc, borderRadius: BorderRadius.circular(3)))),
//               ]),
//               const SizedBox(height: 4),
//               Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//                 Flexible(child: Container(height: 3, constraints: const BoxConstraints(maxWidth: 38), decoration: BoxDecoration(color: sc, borderRadius: BorderRadius.circular(3)))),
//               ]),
//             ],
//           ),
//         );

//       // ── CARD SPLIT ──
//       case BarLayoutStyle.cardSplit:
//         return Container(
//           decoration: BoxDecoration(gradient: design.gradient, color: design.gradient == null ? design.solidColor : null),
//           padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
//           child: Row(children: [
//             Expanded(child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//               decoration: BoxDecoration(color: ibg, borderRadius: BorderRadius.circular(6)),
//               child: Row(children: [
//                 Icon(Icons.business, color: tc, size: 8),
//                 const SizedBox(width: 3),
//                 _bar(tc, 22),
//               ]),
//             )),
//             const SizedBox(width: 4),
//             Expanded(child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//               decoration: BoxDecoration(color: ibg, borderRadius: BorderRadius.circular(6)),
//               child: Row(children: [
//                 Icon(Icons.phone, color: tc, size: 8),
//                 const SizedBox(width: 3),
//                 _bar(tc, 22),
//               ]),
//             )),
//           ]),
//         );

//       // ── MINIMAL ──
//       case BarLayoutStyle.minimal:
//         return Container(
//           color: design.solidColor,
//           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//           child: Row(
//             children: [
//               Expanded(child: Container(height: 4, decoration: BoxDecoration(color: tc, borderRadius: BorderRadius.circular(2)))),
//               Container(width: 1, height: 16, margin: const EdgeInsets.symmetric(horizontal: 6), color: design.dividerColor),
//               Expanded(child: Container(height: 4, decoration: BoxDecoration(color: sc, borderRadius: BorderRadius.circular(2)))),
//             ],
//           ),
//         );

//       // ── RIBBON ──
//       case BarLayoutStyle.ribbon:
//         return Container(
//           decoration: BoxDecoration(
//             gradient: design.gradient,
//             border: Border(top: BorderSide(color: design.topBorderColor, width: 2)),
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 6),
//           child: Row(
//             children: [
//               Container(width: 3, height: 28, color: tc.withOpacity(0.7), margin: const EdgeInsets.only(right: 5)),
//               Expanded(child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(height: 4, decoration: BoxDecoration(color: tc, borderRadius: BorderRadius.circular(2))),
//                   const SizedBox(height: 3),
//                   Container(height: 3, width: double.infinity, constraints: const BoxConstraints(maxWidth: 32), decoration: BoxDecoration(color: tc.withOpacity(0.6), borderRadius: BorderRadius.circular(2))),
//                 ],
//               )),
//             ],
//           ),
//         );

//       // ── NEON ──
//       case BarLayoutStyle.neon:
//         return Container(
//           decoration: BoxDecoration(
//             color: design.solidColor,
//             border: Border(top: BorderSide(color: design.topBorderColor, width: 1.5)),
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 6),
//           child: Row(children: [
//             Expanded(child: Row(children: [
//               Container(
//                 width: 14, height: 14,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(color: tc, width: 1),
//                   boxShadow: [BoxShadow(color: tc.withOpacity(0.5), blurRadius: 4)],
//                 ),
//                 child: Icon(Icons.business, color: tc, size: 7),
//               ),
//               const SizedBox(width: 3),
//               Expanded(child: Container(height: 4, decoration: BoxDecoration(
//                 color: tc,
//                 borderRadius: BorderRadius.circular(2),
//                 boxShadow: [BoxShadow(color: tc.withOpacity(0.4), blurRadius: 3)],
//               ))),
//             ])),
//             Container(width: 1, height: 20, color: design.dividerColor),
//             Expanded(child: Row(children: [
//               const SizedBox(width: 4),
//               Container(
//                 width: 14, height: 14,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(color: tc, width: 1),
//                   boxShadow: [BoxShadow(color: tc.withOpacity(0.5), blurRadius: 4)],
//                 ),
//                 child: Icon(Icons.phone, color: tc, size: 7),
//               ),
//               const SizedBox(width: 3),
//               Expanded(child: Container(height: 4, decoration: BoxDecoration(
//                 color: tc,
//                 borderRadius: BorderRadius.circular(2),
//                 boxShadow: [BoxShadow(color: tc.withOpacity(0.4), blurRadius: 3)],
//               ))),
//             ])),
//           ]),
//         );

//       // ── WAVE ──
//       case BarLayoutStyle.wave:
//         return ClipPath(
//           clipper: _WaveClipper(),
//           child: Container(
//             decoration: BoxDecoration(
//               gradient: design.gradient,
//               color: design.gradient == null ? design.solidColor : null,
//             ),
//             padding: const EdgeInsets.fromLTRB(6, 10, 6, 4),
//             child: Row(children: [
//               Expanded(child: Row(children: [
//                 Icon(Icons.business, color: design.primaryColor, size: 8),
//                 const SizedBox(width: 3),
//                 Expanded(child: Container(height: 4, decoration: BoxDecoration(color: design.primaryColor, borderRadius: BorderRadius.circular(2)))),
//               ])),
//               Container(width: 1, height: 16, color: design.dividerColor),
//               Expanded(child: Row(children: [
//                 const SizedBox(width: 4),
//                 Icon(Icons.phone, color: design.secondaryColor, size: 8),
//                 const SizedBox(width: 3),
//                 Expanded(child: Container(height: 4, decoration: BoxDecoration(color: design.secondaryColor, borderRadius: BorderRadius.circular(2)))),
//               ])),
//             ]),
//           ),
//         );

//       // ── MAGAZINE ──
//       case BarLayoutStyle.magazine:
//         return Container(
//           decoration: BoxDecoration(
//             gradient: design.gradient,
//             color: design.gradient == null ? design.solidColor : null,
//             border: Border(top: BorderSide(color: design.topBorderColor, width: 1)),
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
//           child: Row(children: [
//             Expanded(flex: 3, child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(height: 6, decoration: BoxDecoration(color: design.primaryColor, borderRadius: BorderRadius.circular(2))),
//                 const SizedBox(height: 2),
//                 Container(height: 3, decoration: BoxDecoration(color: design.primaryColor.withOpacity(0.5), borderRadius: BorderRadius.circular(2))),
//               ],
//             )),
//             Container(width: 1, height: 24, margin: const EdgeInsets.symmetric(horizontal: 4), color: design.dividerColor),
//             Expanded(flex: 2, child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(height: 3, decoration: BoxDecoration(color: design.secondaryColor, borderRadius: BorderRadius.circular(2))),
//                 const SizedBox(height: 2),
//                 Container(height: 3, decoration: BoxDecoration(color: design.secondaryColor.withOpacity(0.6), borderRadius: BorderRadius.circular(2))),
//               ],
//             )),
//           ]),
//         );

//       // ── CLASSIC (default) ──
//       case BarLayoutStyle.classic:
//       default:
//         return Container(
//           decoration: BoxDecoration(
//             gradient: design.gradient,
//             color: design.gradient == null ? design.solidColor : null,
//             border: design.showTopBorder ? Border(top: BorderSide(color: design.topBorderColor, width: 1)) : null,
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 6),
//           child: Row(children: [
//             Expanded(child: Row(children: [
//               Container(
//                 width: 16, height: 16,
//                 decoration: BoxDecoration(color: ibg, borderRadius: BorderRadius.circular(4)),
//                 child: Icon(Icons.business, color: tc, size: 9),
//               ),
//               const SizedBox(width: 4),
//               Expanded(child: Container(height: 5, decoration: BoxDecoration(color: tc, borderRadius: BorderRadius.circular(2)))),
//             ])),
//             Container(width: 1, height: 22, color: design.dividerColor),
//             Expanded(child: Row(children: [
//               const SizedBox(width: 4),
//               Container(
//                 width: 16, height: 16,
//                 decoration: BoxDecoration(color: ibg, borderRadius: BorderRadius.circular(4)),
//                 child: Icon(Icons.phone, color: tc, size: 9),
//               ),
//               const SizedBox(width: 4),
//               Expanded(child: Container(height: 5, decoration: BoxDecoration(color: tc, borderRadius: BorderRadius.circular(2)))),
//             ])),
//           ]),
//         );
//     }
//   }
// }

// class _WaveClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final path = Path();
//     path.moveTo(0, 8);
//     path.quadraticBezierTo(size.width * 0.25, 0, size.width * 0.5, 6);
//     path.quadraticBezierTo(size.width * 0.75, 12, size.width, 4);
//     path.lineTo(size.width, size.height);
//     path.lineTo(0, size.height);
//     path.close();
//     return path;
//   }
//   @override
//   bool shouldReclip(_WaveClipper old) => false;
// }

// // ════════════════════════════════════════════════════════
// //  DATA MODELS
// // ════════════════════════════════════════════════════════

// class PosterTemplate {
//   String id, name, categoryName, description, title, email, mobile;
//   double width, height;
//   String? backgroundImage;
//   Color backgroundColor;
//   List<TextElement> textElements;
//   List<ImageElement> imageElements;
//   DesignData designData;

//   PosterTemplate({required this.id, required this.name, required this.categoryName, required this.description, required this.title, required this.email, required this.mobile, required this.width, required this.height, this.backgroundImage, this.backgroundColor = Colors.white, this.textElements = const [], this.imageElements = const [], required this.designData});

//   factory PosterTemplate.fromApiResponse(Map<String, dynamic> r) {
//     final p = r['poster'] as Map<String, dynamic>;
//     final d = p['designData'] as Map<String, dynamic>;
//     final ts = TextSettings.fromJson(d['textSettings'] ?? {});
//     final tst = TextStyles.fromJson(d['textStyles'] ?? {});
//     final tv = TextVisibility.fromJson(d['textVisibility'] ?? {});

//     List<TextElement> textElements = [];
//     if (tv.isVisible('title')) textElements.add(TextElement(id: 'title', text: p['title'] ?? '', x: ts.titleX, y: ts.titleY, width: 800, height: 200, fontSize: tst.title.fontSize ?? 36, color: tst.title.color ?? Colors.black, fontWeight: tst.title.fontWeight ?? FontWeight.bold, fontFamily: tst.title.fontFamily ?? 'Times New Roman', textAlign: TextAlign.center));
//     if (tv.isVisible('description')) textElements.add(TextElement(id: 'description', text: p['description'] ?? '', x: ts.descriptionX, y: ts.descriptionY, width: 900, height: 400, fontSize: tst.description.fontSize ?? 20, color: tst.description.color ?? Colors.black, fontWeight: tst.description.fontWeight ?? FontWeight.bold, fontFamily: tst.description.fontFamily ?? 'Times New Roman'));
//     if (tv.isVisible('name')) textElements.add(TextElement(id: 'name', text: 'Business Name', x: ts.nameX, y: ts.nameY, width: 400, height: 100, fontSize: 2, color: tst.name.color ?? Colors.black, fontWeight: tst.name.fontWeight ?? FontWeight.bold, fontFamily: tst.name.fontFamily ?? 'Arial'));

//     List<ImageElement> imageElements = [];
//     if (d['overlayImages'] != null) {
//       final oi = d['overlayImages'] as List;
//       final ov = (d['overlaySettings']?['overlays'] as List?) ?? [];
//       for (int i = 0; i < oi.length; i++) {
//         final img = oi[i]; final o = i < ov.length ? ov[i] : null;
//         imageElements.add(ImageElement(id: img['_id'] ?? 'ov_$i', imageUrl: img['url'] ?? '', x: _pd(o?['x'], 324), y: _pd(o?['y'], 521), width: _pd(o?['width'], 252), height: _pd(o?['height'], 252)));
//       }
//     }

//     return PosterTemplate(
//       id: p['_id'] ?? 'tpl_${DateTime.now().millisecondsSinceEpoch}',
//       name: p['name'] ?? 'Untitled', categoryName: p['categoryName'] ?? '',
//       description: p['description'] ?? '', title: p['title'] ?? '',
//       email: p['email'] ?? '', mobile: p['mobile'] ?? '',
//       width: 900, height: 1200, backgroundImage: d['bgImage']?['url'],
//       textElements: textElements, imageElements: imageElements,
//       designData: DesignData.fromJson(d),
//     );
//   }

//   static double _pd(dynamic v, double d) { if (v == null) return d; if (v is double) return v; if (v is int) return v.toDouble(); if (v is String) return double.tryParse(v) ?? d; return d; }
// }

// class DesignData {
//   DesignData();
//   factory DesignData.fromJson(Map<String, dynamic> j) => DesignData();
// }

// class TextSettings {
//   double nameX, nameY, emailX, emailY, mobileX, mobileY, titleX, titleY, descriptionX, descriptionY, tagsX, tagsY;
//   TextSettings({this.nameX=0,this.nameY=0,this.emailX=0,this.emailY=0,this.mobileX=0,this.mobileY=0,this.titleX=0,this.titleY=0,this.descriptionX=0,this.descriptionY=0,this.tagsX=0,this.tagsY=0});
//   factory TextSettings.fromJson(Map<String, dynamic> j) => TextSettings(nameX:_p(j['nameX'],0),nameY:_p(j['nameY'],0),emailX:_p(j['emailX'],0),emailY:_p(j['emailY'],0),mobileX:_p(j['mobileX'],0),mobileY:_p(j['mobileY'],0),titleX:_p(j['titleX'],0),titleY:_p(j['titleY'],0),descriptionX:_p(j['descriptionX'],0),descriptionY:_p(j['descriptionY'],0),tagsX:_p(j['tagsX'],0),tagsY:_p(j['tagsY'],0));
//   static double _p(dynamic v,double d){if(v==null)return d;if(v is double)return v;if(v is int)return v.toDouble();if(v is String)return double.tryParse(v)??d;return d;}
// }

// class TextStyles {
//   TextStyle name,email,mobile,title,description,tags;
//   TextStyles({required this.name,required this.email,required this.mobile,required this.title,required this.description,required this.tags});
//   factory TextStyles.fromJson(Map<String, dynamic> j) => TextStyles(name:_ts(j['name']??{}),email:_ts(j['email']??{}),mobile:_ts(j['mobile']??{}),title:_ts(j['title']??{}),description:_ts(j['description']??{}),tags:_ts(j['tags']??{}));
//   static TextStyle _ts(Map<String,dynamic> j) => TextStyle(fontSize:_p(j['fontSize'],16),color:_c(j['color']),fontFamily:j['fontFamily']??'Arial',fontWeight:_fw(j['fontWeight']??'normal'),fontStyle:j['fontStyle']=='italic'?FontStyle.italic:FontStyle.normal);
//   static Color _c(dynamic v){if(v==null)return Colors.black;if(v is int)return Color(v);if(v is String){String h=v.replaceAll('#','');if(h.length==6)h='FF$h';final i=int.tryParse(h,radix:16);if(i!=null)return Color(i);}return Colors.black;}
//   static double _p(dynamic v,double d){if(v==null)return d;if(v is double)return v;if(v is int)return v.toDouble();if(v is String)return double.tryParse(v)??d;return d;}
//   static FontWeight _fw(String w){switch(w.toLowerCase()){case 'bold':return FontWeight.bold;case 'w600':return FontWeight.w600;case 'w300':return FontWeight.w300;default:return FontWeight.normal;}}
// }

// class TextVisibility {
//   String name,email,mobile,title,description,tags;
//   TextVisibility({this.name='visible',this.email='visible',this.mobile='visible',this.title='visible',this.description='visible',this.tags='visible'});
//   factory TextVisibility.fromJson(Map<String,dynamic> j) => TextVisibility(name:j['name']??'visible',email:j['email']??'visible',mobile:j['mobile']??'visible',title:j['title']??'visible',description:j['description']??'visible',tags:j['tags']??'visible');
//   bool isVisible(String f){switch(f){case 'name':return name=='visible';case 'email':return email=='visible';case 'mobile':return mobile=='visible';case 'title':return title=='visible';case 'description':return description=='visible';default:return true;}}
// }

// class TextElement {
//   String id, text, fontFamily;
//   double x, y, width, height, fontSize, rotation;
//   Color color; FontWeight fontWeight; TextAlign textAlign; bool isSelected;
//   TextElement({required this.id,required this.text,required this.x,required this.y,this.width=200,this.height=50,this.fontSize=16,this.color=Colors.black,this.fontWeight=FontWeight.normal,this.fontFamily='Roboto',this.textAlign=TextAlign.left,this.isSelected=false,this.rotation=0});
// }

// class ImageElement {
//   String id, imageUrl;
//   double x, y, width, height, rotation, borderRadius;
//   bool isSelected;
//   ImageElement({required this.id,required this.imageUrl,required this.x,required this.y,this.width=100,this.height=100,this.isSelected=false,this.rotation=0,this.borderRadius=4});
// }

// class ProfileElement {
//   String id, imageUrl;
//   double x, y, width, height, rotation;
//   bool isSelected;
//   ProfileElement({required this.id,required this.imageUrl,required this.x,required this.y,this.width=200,this.height=200,this.isSelected=false,this.rotation=0});
// }

// // ════════════════════════════════════════════════════════
// //  POSTER PREVIEW SCREEN
// // ════════════════════════════════════════════════════════

// class PosterPreviewScreen extends StatefulWidget {
//   final Widget posterWidget;
//   final String posterName;
//   final VoidCallback onSave;
//   final VoidCallback onShare;

//   const PosterPreviewScreen({
//     super.key,
//     required this.posterWidget,
//     required this.posterName,
//     required this.onSave,
//     required this.onShare,
//   });

//   @override
//   State<PosterPreviewScreen> createState() => _PosterPreviewScreenState();
// }

// class _PosterPreviewScreenState extends State<PosterPreviewScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _entryCtrl;
//   late Animation<double> _fadeAnim;
//   late Animation<Offset> _slideAnim;
//   double _scale = 1.0;
//   double _prevScale = 1.0;

//   @override
//   void initState() {
//     super.initState();
//     _entryCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 420));
//     _fadeAnim = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
//     _slideAnim = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
//         .animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic));
//     _entryCtrl.forward();
//   }

//   @override
//   void dispose() {
//     _entryCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0D0D0D),
//       body: Stack(
//         children: [
//           // Subtle background glow
//           Positioned.fill(
//             child: Container(
//               decoration: const BoxDecoration(
//                 gradient: RadialGradient(
//                   center: Alignment(0, -0.3),
//                   radius: 1.2,
//                   colors: [Color(0x226A1B9A), Color(0xFF0D0D0D)],
//                 ),
//               ),
//             ),
//           ),

//           Column(
//             children: [
//               // ── AppBar ──
//               SafeArea(
//                 bottom: false,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//                   child: Row(
//                     children: [
//                       // Close button
//                       Material(
//                         color: Colors.white10,
//                         borderRadius: BorderRadius.circular(12),
//                         child: InkWell(
//                           borderRadius: BorderRadius.circular(12),
//                           onTap: () => Navigator.of(context).pop(),
//                           child: const Padding(
//                             padding: EdgeInsets.all(10),
//                             child: Icon(Icons.close, color: Colors.white, size: 22),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text('Preview', style: TextStyle(color: Colors.white70, fontSize: 11, letterSpacing: 1.2)),
//                             Text(
//                               widget.posterName,
//                               style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ],
//                         ),
//                       ),
//                       // Hint chip
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                         decoration: BoxDecoration(
//                           color: Colors.white10,
//                           borderRadius: BorderRadius.circular(20),
//                           border: Border.all(color: Colors.white12),
//                         ),
//                         child: Row(mainAxisSize: MainAxisSize.min, children: const [
//                           Icon(Icons.pinch, color: Colors.white54, size: 14),
//                           SizedBox(width: 4),
//                           Text('Pinch to zoom', style: TextStyle(color: Colors.white54, fontSize: 11)),
//                         ]),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               // ── Poster display ──
//               Expanded(
//                 child: GestureDetector(
//                   onScaleStart: (_) => _prevScale = _scale,
//                   onScaleUpdate: (d) => setState(() => _scale = (_prevScale * d.scale).clamp(0.5, 4.0)),
//                   child: Center(
//                     child: FadeTransition(
//                       opacity: _fadeAnim,
//                       child: SlideTransition(
//                         position: _slideAnim,
//                         child: Transform.scale(
//                           scale: _scale,
//                           child: Container(
//                             margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: const Color(0xFF6A1B9A).withOpacity(0.35),
//                                   blurRadius: 40,
//                                   spreadRadius: 4,
//                                   offset: const Offset(0, 10),
//                                 ),
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.6),
//                                   blurRadius: 20,
//                                   offset: const Offset(0, 6),
//                                 ),
//                               ],
//                             ),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(12),
//                               child: widget.posterWidget,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),

//               // ── Action bar ──
//               SafeArea(
//                 top: false,
//                 child: Container(
//                   margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
//                   padding: const EdgeInsets.all(4),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF1A1A2E),
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(color: Colors.white10),
//                     boxShadow: [
//                       BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 4)),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       // Save button
//                       Expanded(
//                         child: _PreviewActionButton(
//                           icon: Icons.save_alt_rounded,
//                           label: 'Save',
//                           color: const Color(0xFF6A1B9A),
//                           onTap: () {
//                             Navigator.of(context).pop();
//                             widget.onSave();
//                           },
//                         ),
//                       ),
//                       const SizedBox(width: 4),
//                       // Share button
//                       Expanded(
//                         child: _PreviewActionButton(
//                           icon: Icons.share_rounded,
//                           label: 'Share',
//                           color: const Color(0xFF1565C0),
//                           onTap: () {
//                             Navigator.of(context).pop();
//                             widget.onShare();
//                           },
//                         ),
//                       ),
//                       const SizedBox(width: 4),
//                       // Edit button
//                       Expanded(
//                         child: _PreviewActionButton(
//                           icon: Icons.edit_rounded,
//                           label: 'Edit',
//                           color: const Color(0xFF2E7D32),
//                           onTap: () => Navigator.of(context).pop(),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _PreviewActionButton extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final Color color;
//   final VoidCallback onTap;

//   const _PreviewActionButton({
//     required this.icon,
//     required this.label,
//     required this.color,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: color,
//       borderRadius: BorderRadius.circular(16),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(16),
//         onTap: onTap,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 14),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(icon, color: const ui.Color.fromARGB(255, 0, 0, 0), size: 22),
//               const SizedBox(height: 4),
//               Text(label, style: const TextStyle(color: ui.Color.fromARGB(255, 0, 0, 0), fontSize: 12, fontWeight: FontWeight.w600)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ════════════════════════════════════════════════════════
// //  MAIN SCREEN
// // ════════════════════════════════════════════════════════

// class SamplePosterScreen extends StatefulWidget {
//   final String posterId;
//   const SamplePosterScreen({super.key, required this.posterId});

//   @override
//   State<SamplePosterScreen> createState() => _ApiPosterEditorState();
// }

// class _ApiPosterEditorState extends State<SamplePosterScreen> {
//   final TextEditingController _fontSizeCtrl = TextEditingController();
//   final GlobalKey _canvasKey = GlobalKey();

//   PosterTemplate? _template;
//   bool _isLoading = true;
//   String? _errorMessage;

//   TextElement? _selectedText;
//   ImageElement? _selectedImage;
//   ProfileElement? _selectedProfile;
//   bool _showToolbar = false;

//   double _currentScale = 1.0, _previousScale = 1.0, _baseScale = 1.0;
//   Offset _currentOffset = Offset.zero, _startOffset = Offset.zero, _focusPoint = Offset.zero;
//   Offset? _initialFocalPoint;

//   String? phoneNumber, email, userId, profileImageUrl;
//   Uint8List? _logoImage, _profileImageBytes;
//   ProfileElement? _profileImageElement;
//   ImageElement? _logoImageElement;
//   double _businessNameFontSize = 20.0, _phoneNumberFontSize = 20.0;
//   BottomBarDesign _selectedBarDesign = kBottomBarDesigns[0];

//   BottomTab _activeTab = BottomTab.none;
//   PosterEffectType _currentEffect = PosterEffectType.none;
//   PosterFrame? _selectedFrame;
//   PosterAnimation _currentAnimation = PosterAnimation.none;

//   final ImagePicker _picker = ImagePicker();

//   final List<String> _fontFamilies = ['Roboto','Arial','Times New Roman','Helvetica','Verdana','Georgia','Montserrat','Poppins','Lato','Open Sans','Raleway','Nunito','Oswald','Playfair Display','Dancing Script','Pacifico','Lobster','Bebas Neue','Caveat','Permanent Marker','Quicksand','Inter','Manrope'];
//   final List<FontWeight> _fontWeights = [FontWeight.w100,FontWeight.w200,FontWeight.w300,FontWeight.w400,FontWeight.w500,FontWeight.w600,FontWeight.w700,FontWeight.w800,FontWeight.w900];

//   @override
//   void initState() {
//     super.initState();
//     _loadPosterFromApi();
//     _loadUserData();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       try { Provider.of<LanguageProvider>(context, listen: false).addListener(_onLangChanged); } catch (_) {}
//     });
//   }

//   void _onLangChanged() {
//     try { if (userId != null) Provider.of<CreateCustomerProvider>(context, listen: false).fetchUser(userId!); } catch (_) {}
//   }

//   @override
//   void dispose() {
//     try { Provider.of<LanguageProvider>(context, listen: false).removeListener(_onLangChanged); } catch (_) {}
//     super.dispose();
//   }

//   // ── LOADING ──

//   Future<void> _loadUserData() async {
//     final data = await AuthPreferences.getUserData();
//     if (data != null) {
//       setState(() { phoneNumber = data.user.mobile ?? phoneNumber; profileImageUrl = data.user.profileImage; email = data.user.email ?? email; userId = data.user.id ?? userId; });
//       if (profileImageUrl != null && profileImageUrl!.isNotEmpty) _loadProfileImage();
//       if (_template != null) _updateTextWithUserData();
//     }
//   }

//   Future<void> _loadPosterFromApi() async {
//     try {
//       setState(() { _isLoading = true; _errorMessage = null; });
//       final res = await http.get(Uri.parse('http://31.97.206.144:4061/api/poster/singlecanvasposters/${widget.posterId}'), headers: {'Content-Type': 'application/json'});
//       if (res.statusCode == 200) {
//         final tpl = PosterTemplate.fromApiResponse(json.decode(res.body));
//         setState(() { _template = tpl; _isLoading = false; });
//         _updateTextWithUserData();
//         await _loadSavedBusinessName();
//       } else throw Exception('Status: ${res.statusCode}');
//     } catch (e) { setState(() { _errorMessage = 'Failed: $e'; _isLoading = false; }); }
//   }

//   Future<void> _loadSavedBusinessName() async {
//     final prefs = await SharedPreferences.getInstance();
//     final saved = prefs.getString('business_name');
//     if (saved != null && saved.isNotEmpty && _template != null) {
//       setState(() { _template!.textElements.firstWhere((e) => e.id == 'name', orElse: () => TextElement(id: 'name', text: '', x: 0, y: 0)).text = saved; });
//     }
//   }

//   Future<void> _saveBusinessName(String n) async { final p = await SharedPreferences.getInstance(); await p.setString('business_name', n); }

//   Future<void> _loadProfileImage() async {
//     try {
//       final res = await http.get(Uri.parse(profileImageUrl!));
//       if (res.statusCode == 200) setState(() { _profileImageBytes = res.bodyBytes; _profileImageElement = ProfileElement(id: 'profile_image', imageUrl: '', x: 10, y: 10, width: 200, height: 200); });
//     } catch (_) {}
//   }

//   void _updateTextWithUserData() {
//     if (_template == null) return;
//     setState(() {
//       for (var el in _template!.textElements) {
//         if (el.id == 'email' && email != null && email!.isNotEmpty) el.text = email!;
//         if (el.id == 'mobile' && phoneNumber != null && phoneNumber!.isNotEmpty) el.text = phoneNumber!;
//       }
//     });
//   }

//   // ── TAB ──

//   void _setTab(BottomTab tab) => setState(() {
//     _activeTab = _activeTab == tab ? BottomTab.none : tab;
//     if (_activeTab != BottomTab.none) { _deselectAll(); _showToolbar = false; }
//   });

//   // ── SELECTION ──

//   void _selectText(TextElement el) => setState(() { _deselectAllSilent(); el.isSelected = true; _selectedText = el; _selectedImage = null; _selectedProfile = null; _showToolbar = true; _activeTab = BottomTab.none; });
//   void _selectImage(ImageElement el) => setState(() { _deselectAllSilent(); el.isSelected = true; _selectedImage = el; _selectedText = null; _selectedProfile = null; _showToolbar = true; _activeTab = BottomTab.none; });
//   void _selectProfile(ProfileElement el) => setState(() { _deselectAllSilent(); el.isSelected = true; _selectedProfile = el; _selectedText = null; _selectedImage = null; _showToolbar = true; _activeTab = BottomTab.none; });

//   void _deselectAllSilent() {
//     _template?.textElements.forEach((e) => e.isSelected = false);
//     _template?.imageElements.forEach((e) => e.isSelected = false);
//     _profileImageElement?.isSelected = false;
//     _logoImageElement?.isSelected = false;
//   }

//   void _deselectAll() => setState(() { _deselectAllSilent(); _selectedText = null; _selectedImage = null; _selectedProfile = null; _showToolbar = false; });

//   // ── MOVE / RESIZE ──

//   void _moveText(TextElement el, Offset d) => setState(() { el.x = (el.x + d.dx).clamp(-_template!.width * 0.5, _template!.width * 1.5); el.y = (el.y + d.dy).clamp(-_template!.height * 0.5, _template!.height * 1.5); });
//   void _moveImage(ImageElement el, Offset d) => setState(() { el.x = (el.x + d.dx).clamp(0, _template!.width - el.width); el.y = (el.y + d.dy).clamp(0, _template!.height - el.height); });
//   void _moveProfile(ProfileElement el, Offset d) => setState(() { el.x = (el.x + d.dx).clamp(0, _template!.width - el.width); el.y = (el.y + d.dy).clamp(0, _template!.height - el.height); });
//   void _resizeImage(ImageElement el, double s) => setState(() { final ns = (_baseScale * s).clamp(50.0, _template!.width * 0.8); el.width = ns; el.height = ns; });
//   void _resizeProfile(ProfileElement el, double s) => setState(() { final ns = (_baseScale * s).clamp(50.0, _template!.width * 0.8); el.width = ns; el.height = ns; });

//   // ── DELETE ──

//   void _deleteSelected() {
//     if (_selectedText != null) { setState(() { _template!.textElements.remove(_selectedText); _selectedText = null; _showToolbar = false; }); }
//     else if (_selectedImage != null) { setState(() { if (_selectedImage!.id == 'logo_image') { _logoImageElement = null; _logoImage = null; } else _template!.imageElements.remove(_selectedImage); _selectedImage = null; _showToolbar = false; }); }
//     else if (_selectedProfile != null) { setState(() { _profileImageElement = null; _profileImageBytes = null; _selectedProfile = null; _showToolbar = false; }); }
//   }

//   // ── ADD ──

//   void _addText() { if (_template == null) return; final el = TextElement(id: 'txt_${DateTime.now().millisecondsSinceEpoch}', text: 'New Text', x: 350, y: 350, fontSize: 50, color: Colors.black); setState(() { _template!.textElements.add(el); _selectText(el); }); }

//   Future<void> _pickLogo() async {
//     final f = await _picker.pickImage(source: ImageSource.gallery);
//     if (f != null) { final bytes = await f.readAsBytes(); setState(() { _logoImage = bytes; _logoImageElement = ImageElement(id: 'logo_image', imageUrl: '', x: _template != null ? _template!.width - 120 : 20, y: 20, width: 100, height: 100); }); }
//   }

//   Future<void> _pickAdditionalImage() async {
//     final f = await _picker.pickImage(source: ImageSource.gallery);
//     if (f != null) { final bytes = await f.readAsBytes(); final tmp = await getTemporaryDirectory(); final file = File('${tmp.path}/add_${DateTime.now().millisecondsSinceEpoch}.png'); await file.writeAsBytes(bytes); setState(() { _template?.imageElements.add(ImageElement(id: 'add_${DateTime.now().millisecondsSinceEpoch}', imageUrl: file.path, x: _template!.width / 2 - 100, y: _template!.height / 2 - 100, width: 200, height: 200)); }); }
//   }

//   // ── SAVE / SHARE ──

//   Future<void> _savePoster() async {
//     try {
//       showDialog(context: context, barrierDismissible: false, builder: (_) => const AlertDialog(content: Row(children: [CircularProgressIndicator(), SizedBox(width: 13), Text('Saving...')])));
//       final b = _canvasKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
//       final img = await b.toImage(pixelRatio: 3.0);
//       final bd = await img.toByteData(format: ui.ImageByteFormat.png);
//       await Gal.putImageBytes(bd!.buffer.asUint8List(), album: 'Posters', name: 'poster_${DateTime.now().millisecondsSinceEpoch}.png');
//       Navigator.of(context).pop();
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved!'), backgroundColor: Colors.green));
//     } catch (e) { if (Navigator.of(context).canPop()) Navigator.of(context).pop(); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red)); }
//   }

//   Future<void> _sharePoster() async {
//     try {
//       showDialog(context: context, barrierDismissible: false, builder: (_) => const AlertDialog(content: Row(children: [CircularProgressIndicator(), SizedBox(width: 12), Text('Preparing...')])));
//       final b = _canvasKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
//       final img = await b.toImage(pixelRatio: 3.0);
//       final bd = await img.toByteData(format: ui.ImageByteFormat.png);
//       final tmp = await getTemporaryDirectory();
//       final file = File('${tmp.path}/share_${DateTime.now().millisecondsSinceEpoch}.png');
//       await file.writeAsBytes(bd!.buffer.asUint8List());
//       Navigator.of(context).pop();
//       await Share.shareXFiles([XFile(file.path)], text: 'Check out my poster!');
//     } catch (e) { if (Navigator.of(context).canPop()) Navigator.of(context).pop(); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red)); }
//   }

//   // ════════════════════════════════════════════════════════
//   //  PREVIEW BUTTON ACTION  ← NEW
//   // ════════════════════════════════════════════════════════

//   void _openPreview() {
//     if (_template == null) return;
//     _deselectAll();
//     // Build a static snapshot of the poster widget to show in preview
//     final posterWidget = _buildPosterCanvas(interactive: false);
//     Navigator.of(context).push(
//       PageRouteBuilder(
//         pageBuilder: (_, animation, __) => FadeTransition(
//           opacity: animation,
//           child: PosterPreviewScreen(
//             posterWidget: posterWidget,
//             posterName: _template!.name,
//             onSave: _savePoster,
//             onShare: _sharePoster,
//           ),
//         ),
//         transitionDuration: const Duration(milliseconds: 380),
//         reverseTransitionDuration: const Duration(milliseconds: 280),
//       ),
//     );
//   }

//   // ── DIALOGS ──

//   void _showEditDialog({required String title, required String currentValue, required IconData icon, TextInputType keyboardType = TextInputType.text, required Function(String) onSave}) {
//     final ctrl = TextEditingController(text: currentValue);
//     showDialog(context: context, builder: (_) => AlertDialog(
//       title: Row(children: [Icon(icon, color: Colors.deepPurple), const SizedBox(width: 12), Text(title)]),
//       content: TextField(controller: ctrl, keyboardType: keyboardType, autofocus: true, decoration: InputDecoration(border: const OutlineInputBorder(), prefixIcon: Icon(icon))),
//       actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
//         ElevatedButton(onPressed: () { onSave(ctrl.text); Navigator.pop(context); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white), child: const Text('Save'))],
//     ));
//   }

//   void _showColorPicker() {
//     if (_selectedText == null) return;
//     Color temp = _selectedText!.color;
//     showDialog(context: context, builder: (_) => StatefulBuilder(builder: (ctx, set) => AlertDialog(
//       title: const Text('Pick Color'),
//       content: SingleChildScrollView(child: ColorPicker(pickerColor: temp, onColorChanged: (c) => set(() => temp = c), pickerAreaHeightPercent: 0.4, enableAlpha: false, hexInputBar: false, labelTypes: const [])),
//       actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')), TextButton(onPressed: () { setState(() => _selectedText!.color = temp); Navigator.pop(ctx); }, child: const Text('Apply'))],
//     )));
//   }

//   void _showCustomerDialog() async {
//     try {
//       final cp = Provider.of<CreateCustomerProvider>(context, listen: false);
//       if (cp.customers.isEmpty && userId != null) await cp.fetchUser(userId!);
//       if (cp.customers.isEmpty) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No customers found.'), backgroundColor: Colors.orange)); return; }
//       Set<String> sel = {};
//       showDialog(context: context, builder: (_) => StatefulBuilder(builder: (ctx, set) => AlertDialog(
//         title: const Text('Share with Customers'),
//         content: SizedBox(width: double.maxFinite, height: 350,
//           child: ListView.builder(itemCount: cp.customers.length, itemBuilder: (_, i) {
//             final c = cp.customers[i]; final id = c['_id'] as String;
//             return CheckboxListTile(title: Text(c['name'] ?? ''), subtitle: Text(c['mobile'] ?? ''), value: sel.contains(id), onChanged: (v) => set(() => v! ? sel.add(id) : sel.remove(id)), activeColor: Colors.deepPurple);
//           })),
//         actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
//           ElevatedButton(onPressed: sel.isEmpty ? null : () async { Navigator.pop(ctx); await _sharePosterWithCustomers(sel, cp.customers); },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white), child: Text('Share (${sel.length})')),
//         ],
//       )));
//     } catch (e) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red)); }
//   }

//   Future<void> _sharePosterWithCustomers(Set<String> ids, List<Map<String,dynamic>> customers) async {
//     try {
//       showDialog(context: context, barrierDismissible: false, builder: (_) => const AlertDialog(content: Row(children: [CircularProgressIndicator(), SizedBox(width: 16), Text('Preparing...')])));
//       final b = _canvasKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
//       final img = await b.toImage(pixelRatio: 3.0);
//       final bd = await img.toByteData(format: ui.ImageByteFormat.png);
//       final tmp = await getTemporaryDirectory();
//       final file = File('${tmp.path}/share_${DateTime.now().millisecondsSinceEpoch}.png');
//       await file.writeAsBytes(bd!.buffer.asUint8List());
//       Navigator.of(context).pop();
//       final selected = customers.where((c) => ids.contains(c['_id'])).toList();
//       Navigator.push(context, MaterialPageRoute(builder: (_) => ChatModule(posterImagePath: file.path, selectedCustomers: selected)));
//     } catch (e) { if (Navigator.of(context).canPop()) Navigator.of(context).pop(); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red)); }
//   }

//   // ── BUILD ELEMENTS ──

//   Widget _buildTextEl(TextElement el) => Positioned(
//     left: el.x, top: el.y,
//     child: GestureDetector(
//       onTap: () => _selectText(el),
//       onPanUpdate: (d) => _moveText(el, d.delta),
//       child: Transform.rotate(angle: el.rotation * pi / 180,
//         child: Container(
//           constraints: BoxConstraints(minWidth: 50, maxWidth: _template!.width * 3, minHeight: 20, maxHeight: _template!.height * 3),
//           decoration: el.isSelected ? BoxDecoration(border: Border.all(color: Colors.blueAccent.withOpacity(0.6), width: 1)) : null,
//           child: Text(el.text, style: TextStyle(fontSize: el.fontSize, color: el.color, fontWeight: el.fontWeight, fontFamily: el.fontFamily, height: 1.2), textAlign: el.textAlign, maxLines: null, overflow: TextOverflow.visible, softWrap: true),
//         )),
//     ),
//   );

//   Widget _buildImageEl(ImageElement el) => Positioned(
//     left: el.x, top: el.y, width: el.width, height: el.height,
//     child: GestureDetector(
//       onTap: () => _selectImage(el),
//       onScaleStart: (d) { _baseScale = el.width; _initialFocalPoint = d.focalPoint; },
//       onScaleUpdate: (d) { if (d.scale != 1.0) _resizeImage(el, d.scale); if (_initialFocalPoint != null) { _moveImage(el, d.focalPoint - _initialFocalPoint!); _initialFocalPoint = d.focalPoint; } },
//       onScaleEnd: (_) => _initialFocalPoint = null,
//       child: Transform.rotate(angle: el.rotation * pi / 180,
//         child: Container(
//           decoration: el.isSelected ? BoxDecoration(border: Border.all(color: Colors.blueAccent.withOpacity(0.6), width: 1)) : null,
//           child: ClipRRect(borderRadius: BorderRadius.circular(el.borderRadius),
//             child: el.imageUrl.startsWith('http') ? Image.network(el.imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade300)) : (el.imageUrl.isNotEmpty ? Image.file(File(el.imageUrl), fit: BoxFit.fill) : Container(color: Colors.grey.shade300))),
//         )),
//     ),
//   );

//   Widget _buildProfileEl() {
//     if (_profileImageBytes == null || _profileImageElement == null) return const SizedBox.shrink();
//     final el = _profileImageElement!;
//     return Positioned(left: el.x, top: el.y, width: el.width, height: el.height,
//       child: GestureDetector(
//         onTap: () => _selectProfile(el),
//         onScaleStart: (d) { _baseScale = el.width; _initialFocalPoint = d.focalPoint; },
//         onScaleUpdate: (d) { if (d.scale != 1.0) _resizeProfile(el, d.scale); if (_initialFocalPoint != null) { _moveProfile(el, d.focalPoint - _initialFocalPoint!); _initialFocalPoint = d.focalPoint; } },
//         onScaleEnd: (_) => _initialFocalPoint = null,
//         child: ClipRRect(borderRadius: BorderRadius.circular(100), child: Image.memory(_profileImageBytes!, fit: BoxFit.fill)),
//       ),
//     );
//   }

//   Widget _buildLogoEl() {
//     if (_logoImage == null || _logoImageElement == null) return const SizedBox.shrink();
//     final el = _logoImageElement!;
//     return Positioned(left: el.x, top: el.y, width: el.width, height: el.height,
//       child: GestureDetector(
//         onTap: () => _selectImage(el),
//         onScaleStart: (d) { _baseScale = el.width; _initialFocalPoint = d.focalPoint; },
//         onScaleUpdate: (d) { if (d.scale != 1.0) _resizeImage(el, d.scale); if (_initialFocalPoint != null) { _moveImage(el, d.focalPoint - _initialFocalPoint!); _initialFocalPoint = d.focalPoint; } },
//         onScaleEnd: (_) => _initialFocalPoint = null,
//         child: ClipRRect(borderRadius: BorderRadius.circular(50), child: Image.memory(_logoImage!, fit: BoxFit.cover)),
//       ),
//     );
//   }

//   // ── ELEMENT TOOLBAR ──

//   String _fwLabel(FontWeight w) {
//     switch (w) {
//       case FontWeight.w100: return 'Thin'; case FontWeight.w200: return 'XLight'; case FontWeight.w300: return 'Light';
//       case FontWeight.w400: return 'Regular'; case FontWeight.w500: return 'Medium'; case FontWeight.w600: return 'SemiBold';
//       case FontWeight.w700: return 'Bold'; case FontWeight.w800: return 'XBold'; default: return 'Black';
//     }
//   }

//   Widget _buildElementToolbar() {
//     if (!_showToolbar || _activeTab != BottomTab.none) return const SizedBox.shrink();
//     return Container(
//       padding: const EdgeInsets.all(8), color: Colors.white,
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(children: [
//           if (_selectedText != null) ...[
//             IconButton(icon: const Icon(Icons.edit, color: Colors.deepPurple), onPressed: () => _showEditDialog(title: 'Edit Text', currentValue: _selectedText!.text, icon: Icons.edit, onSave: (v) => setState(() => _selectedText!.text = v))),
//             const VerticalDivider(width: 16),
//             const Text('Size:', style: TextStyle(fontSize: 12)),
//             SizedBox(width: 130, child: Slider(value: _selectedText!.fontSize, min: 8, max: 300, divisions: 60, label: '${_selectedText!.fontSize.round()}', onChanged: (v) => setState(() => _selectedText!.fontSize = v))),
//             Text('${_selectedText!.fontSize.round()}px', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
//             const VerticalDivider(width: 16),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 6),
//               decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
//               child: DropdownButtonHideUnderline(child: DropdownButton<String>(
//                 value: _selectedText!.fontFamily,
//                 items: _fontFamilies.toSet().map((f) => DropdownMenuItem(value: f, child: Text(f, style: TextStyle(fontFamily: f, fontSize: 13)))).toList(),
//                 onChanged: (v) { if (v != null) setState(() => _selectedText!.fontFamily = v); },
//               )),
//             ),
//             const SizedBox(width: 8),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 6),
//               decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
//               child: DropdownButtonHideUnderline(child: DropdownButton<FontWeight>(
//                 value: _selectedText!.fontWeight,
//                 items: _fontWeights.map((w) => DropdownMenuItem(value: w, child: Text(_fwLabel(w), style: TextStyle(fontWeight: w, fontSize: 13)))).toList(),
//                 onChanged: (v) { if (v != null) setState(() => _selectedText!.fontWeight = v); },
//               )),
//             ),
//             const VerticalDivider(width: 16),
//             IconButton(icon: Icon(Icons.format_align_left, color: _selectedText!.textAlign == TextAlign.left ? Colors.deepPurple : Colors.grey), onPressed: () => setState(() => _selectedText!.textAlign = TextAlign.left)),
//             IconButton(icon: Icon(Icons.format_align_center, color: _selectedText!.textAlign == TextAlign.center ? Colors.deepPurple : Colors.grey), onPressed: () => setState(() => _selectedText!.textAlign = TextAlign.center)),
//             IconButton(icon: Icon(Icons.format_align_right, color: _selectedText!.textAlign == TextAlign.right ? Colors.deepPurple : Colors.grey), onPressed: () => setState(() => _selectedText!.textAlign = TextAlign.right)),
//             const VerticalDivider(width: 16),
//             IconButton(icon: Icon(Icons.color_lens, color: _selectedText!.color), onPressed: _showColorPicker),
//             const VerticalDivider(width: 16),
//             IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: _deleteSelected),
//           ] else if (_selectedImage != null) ...[
//             const Text('Size:', style: TextStyle(fontSize: 12)),
//             SizedBox(width: 120, child: Slider(value: _selectedImage!.width, min: 20, max: 800, divisions: 50, label: '${_selectedImage!.width.round()}', onChanged: (v) => setState(() { final ar = _selectedImage!.width / _selectedImage!.height; _selectedImage!.width = v; _selectedImage!.height = v / ar; }))),
//             const VerticalDivider(width: 16),
//             const Text('Corner:', style: TextStyle(fontSize: 12)),
//             SizedBox(width: 100, child: Slider(value: _selectedImage!.borderRadius, min: 0, max: 100, divisions: 20, label: '${_selectedImage!.borderRadius.round()}', onChanged: (v) => setState(() => _selectedImage!.borderRadius = v))),
//             const VerticalDivider(width: 16),
//             IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: _deleteSelected),
//           ] else if (_selectedProfile != null) ...[
//             const Text('Size:', style: TextStyle(fontSize: 12)),
//             SizedBox(width: 120, child: Slider(value: _selectedProfile!.width, min: 50, max: 600, divisions: 50, label: '${_selectedProfile!.width.round()}', onChanged: (v) => setState(() { _selectedProfile!.width = v; _selectedProfile!.height = v; }))),
//             const VerticalDivider(width: 16),
//             IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: _deleteSelected),
//           ],
//         ]),
//       ),
//     );
//   }

//   // ── BOTTOM PANEL ──

//   Widget _buildActivePanel() {
//     switch (_activeTab) {
//       case BottomTab.text:
//         return TextToolsPanel(onAddText: _addText, onAddLogo: _pickLogo, onAddImage: _pickAdditionalImage);
//       case BottomTab.frames:
//         return FramesPanel(selectedFrame: _selectedFrame, onFrameSelected: (f) => setState(() => _selectedFrame = f));
//       case BottomTab.effects:
//         return EffectsPanel(currentEffect: _currentEffect, onEffectSelected: (e) => setState(() => _currentEffect = e));
//       case BottomTab.animation:
//         return AnimationPanel(currentAnimation: _currentAnimation, onAnimationSelected: (a) => setState(() => _currentAnimation = a));
//       case BottomTab.design:
//         return DesignPanel(currentDesign: _selectedBarDesign, onDesignSelected: (d) => setState(() => _selectedBarDesign = d));
//       default:
//         return const SizedBox.shrink();
//     }
//   }

//   // ── BOTTOM NAV ──

//   Widget _buildBottomNav() {
//     final items = [
//       (BottomTab.text, Icons.text_fields, 'Text'),
//       (BottomTab.frames, Icons.crop_square, 'Frames'),
//       (BottomTab.effects, Icons.auto_awesome, 'Effects'),
//       (BottomTab.animation, Icons.animation, 'Animation'),
//       (BottomTab.design, Icons.style, 'Design'),
//     ];
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFF1A1A2E),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, -2))],
//       ),
//       child: SafeArea(
//         top: false,
//         child: Row(
//           children: items.map((item) {
//             final (tab, icon, label) = item;
//             final isActive = _activeTab == tab;
//             return Expanded(
//               child: GestureDetector(
//                 onTap: () => _setTab(tab),
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 200),
//                   padding: const EdgeInsets.symmetric(vertical: 10),
//                   decoration: BoxDecoration(
//                     border: Border(top: BorderSide(color: isActive ? const Color(0xFFFFE500) : Colors.transparent, width: 2.5)),
//                   ),
//                   child: Column(mainAxisSize: MainAxisSize.min, children: [
//                     Icon(icon, color: isActive ? const Color(0xFFFFE500) : Colors.white54, size: 22),
//                     const SizedBox(height: 3),
//                     Text(label, style: TextStyle(color: isActive ? const Color(0xFFFFE500) : Colors.white54, fontSize: 10, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
//                   ]),
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }

//   // ════════════════════════════════════════════════════════
//   //  POSTER CANVAS BUILDER (shared between editor & preview)
//   // ════════════════════════════════════════════════════════

//   Widget _buildPosterCanvas({bool interactive = true}) {
//     if (_template == null) return const SizedBox.shrink();
//     return Container(
//       width: _template!.width,
//       height: _template!.height,
//       decoration: BoxDecoration(
//         color: _template!.backgroundColor,
//         boxShadow: interactive
//             ? [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 14, offset: const Offset(0, 7))]
//             : [],
//       ),
//       child: Stack(clipBehavior: Clip.hardEdge, children: [
//         // BG
//         if (_template!.backgroundImage != null)
//           Positioned.fill(child: Image.network(_template!.backgroundImage!, fit: BoxFit.fill, errorBuilder: (_, __, ___) => Container(color: _template!.backgroundColor))),

//         // Text elements
//         ..._template!.textElements.map(_buildTextEl),
//         // Image elements
//         ..._template!.imageElements.map(_buildImageEl),
//         // Profile
//         _buildProfileEl(),
//         // Logo
//         _buildLogoEl(),

//         // Effect overlay
//         if (_currentEffect != PosterEffectType.none)
//           Positioned.fill(child: PosterEffectOverlay(effectType: _currentEffect, width: _template!.width, height: _template!.height)),

//         // Frame border
//         if (_selectedFrame != null && !_selectedFrame!.isDefault)
//           Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: FrameBorderPainter(_selectedFrame!)))),

//         // Business info bar
//         Positioned(
//           left: 0, right: 0, bottom: 0,
//           child: interactive
//               ? GestureDetector(
//                   onTap: () {
//                     final nameEl = _template?.textElements.firstWhere((e) => e.id == 'name', orElse: () => TextElement(id: 'name', text: 'Business Name', x: 0, y: 0));
//                     final mobileEl = _template?.textElements.firstWhere((e) => e.id == 'mobile', orElse: () => TextElement(id: 'mobile', text: '', x: 0, y: 0));
//                     _showBottomInfoSheet(nameEl, mobileEl);
//                   },
//                   child: AnimatedSwitcher(
//                     duration: const Duration(milliseconds: 450),
//                     transitionBuilder: (child, anim) => FadeTransition(
//                       opacity: anim,
//                       child: SlideTransition(
//                         position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
//                             .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
//                         child: child,
//                       ),
//                     ),
//                     child: KeyedSubtree(key: ValueKey(_selectedBarDesign.id), child: _buildInfoBar()),
//                   ),
//                 )
//               : _buildInfoBar(),
//         ),
//       ]),
//     );
//   }

//   // ── MAIN BUILD ──

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade200,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF6A1B9A),
//         foregroundColor: Colors.white,
//         leading: IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back_ios)),
//         title: Text(_template?.name ?? 'Poster Editor', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//         actions: [
//           // ── PREVIEW BUTTON (NEW) ──
//           if (_template != null)
//             Padding(
//               padding: const EdgeInsets.only(right: 4),
//               child: TextButton.icon(
//                 onPressed: _openPreview,
//                 icon: const Icon(Icons.visibility_rounded, color: Color(0xFFFFE500), size: 18),
//                 label: const Text('Preview', style: TextStyle(color: Color(0xFFFFE500), fontSize: 13, fontWeight: FontWeight.bold)),
//                 style: TextButton.styleFrom(
//                   backgroundColor: Colors.white10,
//                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//                 ),
//               ),
//             ),
//           if (_selectedText != null || _selectedImage != null || _selectedProfile != null)
//             IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent), onPressed: _deleteSelected),
//           PopupMenuButton(
//             icon: const Icon(Icons.more_vert, color: Colors.white),
//             itemBuilder: (_) => [
//               const PopupMenuItem(value: 'save', child: Row(children: [Icon(Icons.save_alt), SizedBox(width: 8), Text('Save to Gallery')])),
//               const PopupMenuItem(value: 'share', child: Row(children: [Icon(Icons.share), SizedBox(width: 8), Text('Share')])),
//               const PopupMenuItem(value: 'customers', child: Row(children: [Icon(Icons.people), SizedBox(width: 8), Text('Share to Customers')])),
//             ],
//             onSelected: (v) { if (v == 'save') _savePoster(); if (v == 'share') _sharePoster(); if (v == 'customers') _showCustomerDialog(); },
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [CircularProgressIndicator(), SizedBox(height: 16), Text('Loading poster...')]))
//           : _errorMessage != null
//               ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//                   const Icon(Icons.error, size: 64, color: Colors.red), const SizedBox(height: 16),
//                   Text(_errorMessage!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center), const SizedBox(height: 24),
//                   ElevatedButton.icon(onPressed: _loadPosterFromApi, icon: const Icon(Icons.refresh), label: const Text('Retry'),
//                       style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white)),
//                 ]))
//               : _template == null ? const Center(child: Text('No poster data'))
//               : Column(children: [
//                   // Element toolbar
//                   _buildElementToolbar(),

//                   // Poster canvas
//                   Expanded(
//                     child: GestureDetector(
//                       onScaleStart: (d) { _focusPoint = d.focalPoint; _previousScale = _currentScale; _startOffset = _currentOffset; },
//                       onScaleUpdate: (d) => setState(() {
//                         if (d.scale != 1.0) _currentScale = (_previousScale * d.scale).clamp(0.5, 3.0);
//                         _currentOffset = _startOffset + (d.focalPoint - _focusPoint);
//                       }),
//                       onScaleEnd: (_) { _previousScale = _currentScale; _startOffset = _currentOffset; },
//                       onTap: () { _deselectAll(); setState(() => _activeTab = BottomTab.none); },
//                       child: Transform(
//                         transform: Matrix4.identity()..translate(_currentOffset.dx, _currentOffset.dy)..scale(_currentScale),
//                         child: Center(
//                           child: RepaintBoundary(
//                             key: _canvasKey,
//                             child: Container(
//                               constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.95, maxHeight: MediaQuery.of(context).size.height * 0.72),
//                               child: FittedBox(
//                                 fit: BoxFit.contain,
//                                 child: AnimatedPosterWrapper(
//                                   animation: _currentAnimation,
//                                   child: _buildPosterCanvas(interactive: true),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),

//                   // Bottom panel (animated slide up/down)
//                   AnimatedSwitcher(
//                     duration: const Duration(milliseconds: 250),
//                     transitionBuilder: (child, anim) => SlideTransition(
//                       position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
//                       child: child,
//                     ),
//                     child: _activeTab != BottomTab.none
//                         ? KeyedSubtree(key: ValueKey(_activeTab), child: _buildActivePanel())
//                         : const SizedBox.shrink(key: ValueKey('none')),
//                   ),

//                   // Bottom nav bar
//                   _buildBottomNav(),
//                 ]),
//     );
//   }

//   // ── Build info bar based on selected layout style ──
//   Widget _buildInfoBar() {
//     final d = _selectedBarDesign;
//     final businessName = _template?.textElements
//         .firstWhere((e) => e.id == 'name', orElse: () => TextElement(id: 'name', text: 'Business Name', x: 0, y: 0))
//         .text ?? 'Business Name';
//     final phone = phoneNumber ??
//         _template?.textElements
//             .firstWhere((e) => e.id == 'mobile', orElse: () => TextElement(id: 'mobile', text: 'Not Set', x: 0, y: 0))
//             .text ?? 'Not Set';
//     final tc = d.primaryColor;
//     final sc = d.secondaryColor;
//     final ibg = d.iconBgColor;

//     BoxDecoration bgDecor = BoxDecoration(
//       gradient: d.gradient,
//       color: d.gradient == null ? d.solidColor : null,
//       borderRadius: d.borderRadiusTop > 0 ? BorderRadius.vertical(top: Radius.circular(d.borderRadiusTop)) : null,
//       border: d.showTopBorder ? Border(top: BorderSide(color: d.topBorderColor, width: 1.5)) : null,
//     );

//     switch (d.layoutStyle) {
//       case BarLayoutStyle.stacked:
//         return Container(
//           decoration: bgDecor,
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Row(children: [
//                 Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: ibg, borderRadius: BorderRadius.circular(8)), child: Icon(Icons.business, color: tc, size: 18)),
//                 const SizedBox(width: 12),
//                 Expanded(child: Text(businessName, style: TextStyle(fontSize: _businessNameFontSize, fontWeight: FontWeight.bold, color: tc), maxLines: 1, overflow: TextOverflow.ellipsis)),
//               ]),
//               const SizedBox(height: 8),
//               Row(children: [
//                 Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: ibg, borderRadius: BorderRadius.circular(8)), child: Icon(Icons.phone, color: sc, size: 18)),
//                 const SizedBox(width: 12),
//                 Expanded(child: Text(phone, style: TextStyle(fontSize: _phoneNumberFontSize, fontWeight: FontWeight.w600, color: sc), maxLines: 1, overflow: TextOverflow.ellipsis)),
//               ]),
//             ],
//           ),
//         );
//       case BarLayoutStyle.badgeChip:
//         return Container(
//           decoration: bgDecor,
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                 decoration: BoxDecoration(color: ibg, borderRadius: BorderRadius.circular(30), border: Border.all(color: tc.withOpacity(0.6), width: 1.5)),
//                 child: Row(mainAxisSize: MainAxisSize.min, children: [
//                   Icon(Icons.business, color: tc, size: 16),
//                   const SizedBox(width: 8),
//                   Text(businessName, style: TextStyle(fontSize: _businessNameFontSize.clamp(10, 16), fontWeight: FontWeight.bold, color: tc), maxLines: 1, overflow: TextOverflow.ellipsis),
//                 ]),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                 decoration: BoxDecoration(color: ibg, borderRadius: BorderRadius.circular(30), border: Border.all(color: tc.withOpacity(0.6), width: 1.5)),
//                 child: Row(mainAxisSize: MainAxisSize.min, children: [
//                   Icon(Icons.phone, color: tc, size: 16),
//                   const SizedBox(width: 8),
//                   Text(phone, style: TextStyle(fontSize: _phoneNumberFontSize.clamp(10, 16), fontWeight: FontWeight.bold, color: tc), maxLines: 1, overflow: TextOverflow.ellipsis),
//                 ]),
//               ),
//             ],
//           ),
//         );
//       case BarLayoutStyle.centered:
//         return Container(
//           decoration: bgDecor,
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(businessName, textAlign: TextAlign.center, style: TextStyle(fontSize: _businessNameFontSize, fontWeight: FontWeight.bold, color: tc, letterSpacing: 0.5), maxLines: 1, overflow: TextOverflow.ellipsis),
//               const SizedBox(height: 4),
//               Text(phone, textAlign: TextAlign.center, style: TextStyle(fontSize: _phoneNumberFontSize, fontWeight: FontWeight.w500, color: sc), maxLines: 1, overflow: TextOverflow.ellipsis),
//             ],
//           ),
//         );
//       case BarLayoutStyle.cardSplit:
//         return Container(
//           color: d.solidColor ?? Colors.black.withOpacity(0.85),
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//           child: Row(children: [
//             Expanded(child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               decoration: BoxDecoration(color: ibg.withOpacity(0.5), borderRadius: BorderRadius.circular(12), border: Border.all(color: tc.withOpacity(0.2), width: 1), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 3))]),
//               child: Row(children: [
//                 Icon(Icons.business, color: tc, size: 18),
//                 const SizedBox(width: 8),
//                 Expanded(child: Text(businessName, style: TextStyle(fontSize: _businessNameFontSize.clamp(10, 16), fontWeight: FontWeight.bold, color: tc), maxLines: 1, overflow: TextOverflow.ellipsis)),
//               ]),
//             )),
//             const SizedBox(width: 10),
//             Expanded(child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               decoration: BoxDecoration(color: ibg.withOpacity(0.5), borderRadius: BorderRadius.circular(12), border: Border.all(color: tc.withOpacity(0.2), width: 1), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 3))]),
//               child: Row(children: [
//                 Icon(Icons.phone, color: tc, size: 18),
//                 const SizedBox(width: 8),
//                 Expanded(child: Text(phone, style: TextStyle(fontSize: _phoneNumberFontSize.clamp(10, 16), fontWeight: FontWeight.bold, color: tc), maxLines: 1, overflow: TextOverflow.ellipsis)),
//               ]),
//             )),
//           ]),
//         );
//       case BarLayoutStyle.minimal:
//         return Container(
//           color: d.solidColor,
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           child: Row(
//             children: [
//               Expanded(child: Text(businessName, style: TextStyle(fontSize: _businessNameFontSize, fontWeight: FontWeight.w600, color: tc, letterSpacing: 0.3), maxLines: 1, overflow: TextOverflow.ellipsis)),
//               Container(width: 1, height: 20, margin: const EdgeInsets.symmetric(horizontal: 16), color: d.dividerColor),
//               Expanded(child: Text(phone, textAlign: TextAlign.right, style: TextStyle(fontSize: _phoneNumberFontSize, fontWeight: FontWeight.w400, color: sc), maxLines: 1, overflow: TextOverflow.ellipsis)),
//             ],
//           ),
//         );
//       case BarLayoutStyle.ribbon:
//         return Container(
//           decoration: bgDecor,
//           padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 14),
//           child: Row(children: [
//             Container(width: 5, color: tc.withOpacity(0.8), margin: const EdgeInsets.only(right: 14)),
//             Expanded(child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(businessName, style: TextStyle(fontSize: _businessNameFontSize, fontWeight: FontWeight.bold, color: tc), maxLines: 1, overflow: TextOverflow.ellipsis),
//                 const SizedBox(height: 4),
//                 Row(children: [
//                   Icon(Icons.phone, color: sc, size: 13),
//                   const SizedBox(width: 6),
//                   Expanded(child: Text(phone, style: TextStyle(fontSize: _phoneNumberFontSize.clamp(10, 14), color: sc), maxLines: 1, overflow: TextOverflow.ellipsis)),
//                 ]),
//               ],
//             )),
//             const SizedBox(width: 16),
//           ]),
//         );
//       case BarLayoutStyle.neon:
//         return Container(
//           decoration: BoxDecoration(color: d.solidColor, border: Border(top: BorderSide(color: tc, width: 1.5)), boxShadow: [BoxShadow(color: tc.withOpacity(0.4), blurRadius: 12, spreadRadius: 0, offset: const Offset(0, -3))]),
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
//           child: Row(children: [
//             Expanded(child: Row(children: [
//               Container(padding: const EdgeInsets.all(7), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: tc, width: 1.5), boxShadow: [BoxShadow(color: tc.withOpacity(0.5), blurRadius: 8)]), child: Icon(Icons.business, color: tc, size: 16)),
//               const SizedBox(width: 10),
//               Expanded(child: Text(businessName, style: TextStyle(fontSize: _businessNameFontSize, fontWeight: FontWeight.bold, color: tc, shadows: [Shadow(color: tc.withOpacity(0.8), blurRadius: 8)]), maxLines: 1, overflow: TextOverflow.ellipsis)),
//             ])),
//             Container(width: 1, height: 36, margin: const EdgeInsets.symmetric(horizontal: 14), color: d.dividerColor),
//             Expanded(child: Row(children: [
//               Container(padding: const EdgeInsets.all(7), decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: tc, width: 1.5), boxShadow: [BoxShadow(color: tc.withOpacity(0.5), blurRadius: 8)]), child: Icon(Icons.phone, color: tc, size: 16)),
//               const SizedBox(width: 10),
//               Expanded(child: Text(phone, style: TextStyle(fontSize: _phoneNumberFontSize, fontWeight: FontWeight.bold, color: tc, shadows: [Shadow(color: tc.withOpacity(0.8), blurRadius: 8)]), maxLines: 1, overflow: TextOverflow.ellipsis)),
//             ])),
//           ]),
//         );
//       case BarLayoutStyle.wave:
//         return ClipPath(
//           clipper: _WaveInfoBarClipper(),
//           child: Container(
//             decoration: BoxDecoration(gradient: d.gradient, color: d.gradient == null ? d.solidColor : null),
//             padding: const EdgeInsets.fromLTRB(20, 22, 20, 14),
//             child: Row(children: [
//               Expanded(child: Row(children: [
//                 Container(padding: const EdgeInsets.all(7), decoration: BoxDecoration(color: ibg, borderRadius: BorderRadius.circular(8)), child: Icon(Icons.business, color: tc, size: 18)),
//                 const SizedBox(width: 12),
//                 Expanded(child: Text(businessName, style: TextStyle(fontSize: _businessNameFontSize, fontWeight: FontWeight.bold, color: tc), maxLines: 1, overflow: TextOverflow.ellipsis)),
//               ])),
//               Container(width: 1, height: 36, margin: const EdgeInsets.symmetric(horizontal: 14), color: d.dividerColor),
//               Expanded(child: Row(children: [
//                 Container(padding: const EdgeInsets.all(7), decoration: BoxDecoration(color: ibg, borderRadius: BorderRadius.circular(8)), child: Icon(Icons.phone, color: sc, size: 18)),
//                 const SizedBox(width: 12),
//                 Expanded(child: Text(phone, style: TextStyle(fontSize: _phoneNumberFontSize, fontWeight: FontWeight.bold, color: sc), maxLines: 1, overflow: TextOverflow.ellipsis)),
//               ])),
//             ]),
//           ),
//         );
//       case BarLayoutStyle.magazine:
//         return Container(
//           decoration: bgDecor,
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//           child: Row(children: [
//             Expanded(flex: 3, child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(businessName, style: TextStyle(fontSize: _businessNameFontSize + 2, fontWeight: FontWeight.w900, color: tc, letterSpacing: 0.5), maxLines: 1, overflow: TextOverflow.ellipsis),
//                 const SizedBox(height: 3),
//                 Text('BUSINESS', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: tc.withOpacity(0.5), letterSpacing: 1.5)),
//               ],
//             )),
//             Container(width: 1, height: 40, margin: const EdgeInsets.symmetric(horizontal: 16), color: d.dividerColor),
//             Expanded(flex: 2, child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('CONTACT', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: sc.withOpacity(0.5), letterSpacing: 1.5)),
//                 const SizedBox(height: 3),
//                 Row(children: [
//                   Icon(Icons.phone, color: sc, size: 13),
//                   const SizedBox(width: 5),
//                   Expanded(child: Text(phone, style: TextStyle(fontSize: _phoneNumberFontSize.clamp(10, 14), fontWeight: FontWeight.bold, color: sc), maxLines: 1, overflow: TextOverflow.ellipsis)),
//                 ]),
//               ],
//             )),
//           ]),
//         );
//       case BarLayoutStyle.classic:
//       default:
//         return Container(
//           decoration: bgDecor,
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//           child: Row(children: [
//             Expanded(child: Row(children: [
//               Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: ibg, borderRadius: BorderRadius.circular(8)), child: Icon(Icons.business, color: tc, size: 20)),
//               const SizedBox(width: 12),
//               Expanded(child: Text(businessName, style: TextStyle(fontSize: _businessNameFontSize, fontWeight: FontWeight.bold, color: tc), maxLines: 1, overflow: TextOverflow.ellipsis)),
//             ])),
//             Container(height: 50, width: 1, margin: const EdgeInsets.symmetric(horizontal: 15), color: d.dividerColor),
//             Expanded(child: Row(children: [
//               Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: ibg, borderRadius: BorderRadius.circular(8)), child: Icon(Icons.phone, color: tc, size: 20)),
//               const SizedBox(width: 12),
//               Expanded(child: Text(phone, style: TextStyle(fontSize: _phoneNumberFontSize, fontWeight: FontWeight.bold, color: tc), maxLines: 1, overflow: TextOverflow.ellipsis)),
//             ])),
//           ]),
//         );
//     }
//   }

//   void _showBottomInfoSheet(TextElement? nameEl, TextElement? mobileEl) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (_) => StatefulBuilder(builder: (ctx, set) => Container(
//         decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//         padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
//         child: Column(mainAxisSize: MainAxisSize.min, children: [
//           Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
//           const SizedBox(height: 16),
//           ListTile(
//             leading: CircleAvatar(backgroundColor: Colors.purple.shade100, child: Icon(Icons.business, color: Colors.purple.shade700)),
//             title: const Text('Business Name', style: TextStyle(fontWeight: FontWeight.w600)),
//             subtitle: Text(nameEl?.text ?? 'Tap to edit'),
//             trailing: const Icon(Icons.edit, size: 18),
//             onTap: () { Navigator.pop(ctx); if (nameEl != null) _showEditDialog(title: 'Business Name', currentValue: nameEl.text, icon: Icons.business, onSave: (v) async { await _saveBusinessName(v); setState(() => nameEl.text = v); }); },
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Row(children: [
//               const Text('Name Size:', style: TextStyle(fontSize: 12)),
//               Expanded(child: Slider(value: _businessNameFontSize, min: 10, max: 40, divisions: 30, activeColor: Colors.purple, onChanged: (v) { setState(() => _businessNameFontSize = v); set(() {}); })),
//               Text('${_businessNameFontSize.round()}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
//             ]),
//           ),
//           const Divider(),
//           ListTile(
//             leading: CircleAvatar(backgroundColor: Colors.blue.shade100, child: Icon(Icons.phone, color: Colors.blue.shade700)),
//             title: const Text('Phone Number', style: TextStyle(fontWeight: FontWeight.w600)),
//             subtitle: Text(phoneNumber ?? mobileEl?.text ?? 'Tap to edit'),
//             trailing: const Icon(Icons.edit, size: 18),
//             onTap: () { Navigator.pop(ctx); if (mobileEl != null) _showEditDialog(title: 'Phone Number', currentValue: mobileEl.text, icon: Icons.phone, keyboardType: TextInputType.phone, onSave: (v) { setState(() { mobileEl.text = v; phoneNumber = v; }); }); },
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Row(children: [
//               const Text('Phone Size:', style: TextStyle(fontSize: 12)),
//               Expanded(child: Slider(value: _phoneNumberFontSize, min: 10, max: 40, divisions: 30, activeColor: Colors.blue, onChanged: (v) { setState(() => _phoneNumberFontSize = v); set(() {}); })),
//               Text('${_phoneNumberFontSize.round()}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
//             ]),
//           ),
//         ]),
//       )),
//     );
//   }
// }

// // ── Wave clipper for the actual info bar ──
// class _WaveInfoBarClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final path = Path();
//     path.moveTo(0, 16);
//     path.quadraticBezierTo(size.width * 0.15, 4, size.width * 0.35, 12);
//     path.quadraticBezierTo(size.width * 0.55, 22, size.width * 0.75, 10);
//     path.quadraticBezierTo(size.width * 0.9, 2, size.width, 8);
//     path.lineTo(size.width, size.height);
//     path.lineTo(0, size.height);
//     path.close();
//     return path;
//   }
//   @override
//   bool shouldReclip(_WaveInfoBarClipper old) => false ;
// }




























import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:posternova/helper/storage_helper.dart';
import 'package:posternova/providers/customer/customer_provider.dart';
import 'package:posternova/views/chat/chat_module.dart';
import 'package:posternova/widgets/language_widget.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ════════════════════════════════════════════════════════
//  ENUMS
// ════════════════════════════════════════════════════════

enum BottomTab { none, text, frames, effects, animation, design }

enum PosterAnimation {
  none,
  flipInX,
  flipInY,
  wobble,
  rollIn,
  largeZoom,
  rotateLeft,
  rotateRight,
  bounce,
  fadeIn
}

enum PosterEffectType { none, sparkle, stars, snow, confetti }

enum BarLayoutStyle {
  classic,
  stacked,
  badgeChip,
  centered,
  cardSplit,
  minimal,
  ribbon,
  neon,
  wave,
  magazine,
}

class BottomBarDesign {
  final String id;
  final String name;
  final BarLayoutStyle layoutStyle;
  final Gradient? gradient;
  final Color? solidColor;
  final Color primaryColor;
  final Color secondaryColor;
  final Color iconBgColor;
  final Color dividerColor;
  final double borderRadiusTop;
  final bool showTopBorder;
  final Color topBorderColor;
  final bool showIcons;
  final double elevation;

  const BottomBarDesign({
    required this.id,
    required this.name,
    required this.layoutStyle,
    required this.primaryColor,
    required this.secondaryColor,
    required this.iconBgColor,
    required this.dividerColor,
    this.gradient,
    this.solidColor,
    this.borderRadiusTop = 0,
    this.showTopBorder = true,
    this.topBorderColor = const Color(0x33FFFFFF),
    this.showIcons = true,
    this.elevation = 0,
  });
}

const List<BottomBarDesign> kBottomBarDesigns = [
  BottomBarDesign(id: 'classic', name: 'Classic', layoutStyle: BarLayoutStyle.classic, solidColor: Color(0xF0000000), primaryColor: Colors.white, secondaryColor: Color(0xAAFFFFFF), iconBgColor: Color(0x449C27B0), dividerColor: Colors.white30, topBorderColor: Colors.white24),
  BottomBarDesign(id: 'stacked', name: 'Stacked', layoutStyle: BarLayoutStyle.stacked, gradient: LinearGradient(colors: [Color(0xFF1A237E), Color(0xFF283593)], begin: Alignment.topLeft, end: Alignment.bottomRight), primaryColor: Colors.white, secondaryColor: Color(0xAAFFFFFF), iconBgColor: Color(0x447986CB), dividerColor: Color(0x557986CB), topBorderColor: Color(0x887986CB)),
  BottomBarDesign(id: 'badge', name: 'Badge', layoutStyle: BarLayoutStyle.badgeChip, solidColor: Color(0xFF1A1A1A), primaryColor: Color(0xFFFFE500), secondaryColor: Colors.white70, iconBgColor: Color(0x44FFE500), dividerColor: Colors.transparent, topBorderColor: Color(0x88FFE500), showTopBorder: true),
  BottomBarDesign(id: 'centered', name: 'Centered', layoutStyle: BarLayoutStyle.centered, gradient: LinearGradient(colors: [Color(0xFF880E4F), Color(0xFFAD1457)], begin: Alignment.centerLeft, end: Alignment.centerRight), primaryColor: Colors.white, secondaryColor: Color(0xDDFFFFFF), iconBgColor: Colors.transparent, dividerColor: Colors.white30, topBorderColor: Color(0x55F48FB1), showIcons: false),
  BottomBarDesign(id: 'card_split', name: 'Cards', layoutStyle: BarLayoutStyle.cardSplit, solidColor: Color(0xEE111111), primaryColor: Colors.white, secondaryColor: Color(0xAAFFFFFF), iconBgColor: Color(0x4400BCD4), dividerColor: Colors.transparent, topBorderColor: Colors.transparent, showTopBorder: false, elevation: 8),
  BottomBarDesign(id: 'minimal', name: 'Minimal', layoutStyle: BarLayoutStyle.minimal, solidColor: Color(0xCC000000), primaryColor: Color(0xFFFFFFFF), secondaryColor: Color(0x99FFFFFF), iconBgColor: Colors.transparent, dividerColor: Color(0x55FFFFFF), topBorderColor: Colors.transparent, showIcons: false, showTopBorder: false),
  BottomBarDesign(id: 'ribbon', name: 'Ribbon', layoutStyle: BarLayoutStyle.ribbon, gradient: LinearGradient(colors: [Color(0xFF004D40), Color(0xFF00695C), Color(0xFF00897B)], begin: Alignment.centerLeft, end: Alignment.centerRight), primaryColor: Colors.white, secondaryColor: Color(0xCCFFFFFF), iconBgColor: Color(0x4480CBC4), dividerColor: Colors.white30, topBorderColor: Color(0x8880CBC4)),
  BottomBarDesign(id: 'neon', name: 'Neon', layoutStyle: BarLayoutStyle.neon, solidColor: Color(0xFF0A0A0A), primaryColor: Color(0xFF00FF88), secondaryColor: Color(0xAA00FF88), iconBgColor: Color(0x2200FF88), dividerColor: Color(0x8800FF88), topBorderColor: Color(0xFF00FF88), elevation: 0),
  BottomBarDesign(id: 'wave', name: 'Wave', layoutStyle: BarLayoutStyle.wave, gradient: LinearGradient(colors: [Color(0xFF4A148C), Color(0xFF6A1B9A)], begin: Alignment.topLeft, end: Alignment.bottomRight), primaryColor: Colors.white, secondaryColor: Color(0xCCFFFFFF), iconBgColor: Color(0x44CE93D8), dividerColor: Colors.white24, topBorderColor: Colors.transparent, showTopBorder: false, borderRadiusTop: 24),
  BottomBarDesign(id: 'magazine', name: 'Magazine', layoutStyle: BarLayoutStyle.magazine, gradient: LinearGradient(colors: [Color(0xFFB71C1C), Color(0xFFC62828)], begin: Alignment.centerLeft, end: Alignment.centerRight), primaryColor: Colors.white, secondaryColor: Color(0xCCFFFFFF), iconBgColor: Color(0x44EF9A9A), dividerColor: Colors.white30, topBorderColor: Color(0x55EF9A9A)),
  BottomBarDesign(id: 'gold', name: 'Gold', layoutStyle: BarLayoutStyle.classic, gradient: LinearGradient(colors: [Color(0xFF1A1A1A), Color(0xFF3D2B00)], begin: Alignment.centerLeft, end: Alignment.centerRight), primaryColor: Color(0xFFFFD700), secondaryColor: Color(0xAAFFD700), iconBgColor: Color(0x44FFD700), dividerColor: Color(0x66FFD700), topBorderColor: Color(0xAAFFD700)),
  BottomBarDesign(id: 'white', name: 'White', layoutStyle: BarLayoutStyle.stacked, solidColor: Colors.white, primaryColor: Color(0xFF1A1A1A), secondaryColor: Color(0x996A1B9A), iconBgColor: Color(0x1A6A1B9A), dividerColor: Color(0x226A1B9A), topBorderColor: Color(0x336A1B9A), borderRadiusTop: 18),
];

// ════════════════════════════════════════════════════════
//  SPARKLE EFFECT
// ════════════════════════════════════════════════════════

class _Sparkle {
  double x, y, size, opacity, speed, rotation, rotationSpeed;
  _Sparkle({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.speed,
    required this.rotation,
    required this.rotationSpeed,
  });
}

class _SparkleParticlesPainter extends CustomPainter {
  final List<_Sparkle> sparkles;
  final PosterEffectType effectType;
  _SparkleParticlesPainter(this.sparkles, this.effectType);

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in sparkles) {
      final paint = Paint()
        ..color = _color(effectType).withOpacity(s.opacity.clamp(0.0, 1.0))
        ..style = PaintingStyle.fill;
      canvas.save();
      canvas.translate(s.x * size.width, s.y * size.height);
      canvas.rotate(s.rotation);
      switch (effectType) {
        case PosterEffectType.sparkle:
          _drawSparkle(canvas, paint, s.size);
          break;
        case PosterEffectType.stars:
          _drawStar(canvas, paint, s.size);
          break;
        case PosterEffectType.snow:
          canvas.drawCircle(Offset.zero, s.size * 0.5, paint);
          break;
        case PosterEffectType.confetti:
          canvas.drawRect(
            Rect.fromCenter(center: Offset.zero, width: s.size * 0.6, height: s.size * 1.2),
            paint,
          );
          break;
        default:
          break;
      }
      canvas.restore();
    }
  }

  Color _color(PosterEffectType t) {
    switch (t) {
      case PosterEffectType.sparkle:
        return Colors.white;
      case PosterEffectType.stars:
        return Colors.yellowAccent;
      case PosterEffectType.snow:
        return Colors.lightBlueAccent;
      case PosterEffectType.confetti:
        return Colors.pinkAccent;
      default:
        return Colors.white;
    }
  }

  void _drawSparkle(Canvas canvas, Paint paint, double size) {
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final angle = i * pi / 4;
      final r = i.isEven ? size : size * 0.25;
      final x = cos(angle) * r;
      final y = sin(angle) * r;
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withOpacity(paint.color.opacity * 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
  }

  void _drawStar(Canvas canvas, Paint paint, double size) {
    final path = Path();
    for (int i = 0; i < 10; i++) {
      final angle = i * pi / 5 - pi / 2;
      final r = i.isEven ? size : size * 0.4;
      final x = cos(angle) * r;
      final y = sin(angle) * r;
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_SparkleParticlesPainter old) => true;
}

class PosterEffectOverlay extends StatefulWidget {
  final PosterEffectType effectType;
  final double width, height;
  const PosterEffectOverlay({
    super.key,
    required this.effectType,
    required this.width,
    required this.height,
  });

  @override
  State<PosterEffectOverlay> createState() => _PosterEffectOverlayState();
}

class _PosterEffectOverlayState extends State<PosterEffectOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late List<_Sparkle> _sparkles;
  final Random _rnd = Random();

  @override
  void initState() {
    super.initState();
    _initSparkles();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..addListener(_update);
    if (widget.effectType != PosterEffectType.none) _ctrl.repeat();
  }

  @override
  void didUpdateWidget(PosterEffectOverlay old) {
    super.didUpdateWidget(old);
    if (widget.effectType != old.effectType) {
      _initSparkles();
      widget.effectType != PosterEffectType.none ? _ctrl.repeat() : _ctrl.stop();
    }
  }

  int get _count {
    switch (widget.effectType) {
      case PosterEffectType.sparkle:
        return 20;
      case PosterEffectType.stars:
        return 25;
      case PosterEffectType.snow:
        return 35;
      case PosterEffectType.confetti:
        return 30;
      default:
        return 0;
    }
  }

  void _initSparkles() => _sparkles = List.generate(_count, (_) => _rand());

  _Sparkle _rand() => _Sparkle(
        x: _rnd.nextDouble(),
        y: _rnd.nextDouble(),
        size: _rnd.nextDouble() * 14 + 6,
        opacity: _rnd.nextDouble(),
        speed: _rnd.nextDouble() * 0.003 + 0.001,
        rotation: _rnd.nextDouble() * 2 * pi,
        rotationSpeed: (_rnd.nextDouble() - 0.5) * 0.05,
      );

  void _update() {
    if (!mounted) return;
    setState(() {
      for (final s in _sparkles) {
        s.rotation += s.rotationSpeed;
        s.opacity = (s.opacity + (_rnd.nextDouble() - 0.5) * 0.15).clamp(0.1, 1.0);
        switch (widget.effectType) {
          case PosterEffectType.snow:
            s.y += s.speed;
            s.x += sin(s.rotation) * 0.002;
            break;
          case PosterEffectType.confetti:
            s.y += s.speed * 1.5;
            s.x += cos(s.rotation) * 0.003;
            break;
          case PosterEffectType.sparkle:
          case PosterEffectType.stars:
            if (_rnd.nextDouble() < 0.02) {
              s.x = _rnd.nextDouble();
              s.y = _rnd.nextDouble();
              s.opacity = 1.0;
              s.size = _rnd.nextDouble() * 18 + 6;
            }
            break;
          default:
            break;
        }
        if (s.y > 1.05 || s.x < -0.05 || s.x > 1.05) {
          s.x = _rnd.nextDouble();
          s.y = -0.05;
          s.opacity = 0.8;
        }
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.effectType == PosterEffectType.none) return const SizedBox.shrink();
    return IgnorePointer(
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: CustomPaint(
          painter: _SparkleParticlesPainter(_sparkles, widget.effectType),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
//  FRAME MODEL & PAINTER
// ════════════════════════════════════════════════════════

class PosterFrame {
  final String id, name;
  final Color borderColor;
  final double borderWidth, borderRadius;
  final List<Color> gradientColors;
  final bool isDefault;

  const PosterFrame({
    required this.id,
    required this.name,
    required this.borderColor,
    this.borderWidth = 8.0,
    this.borderRadius = 0.0,
    this.gradientColors = const [],
    this.isDefault = false,
  });
}

class FrameBorderPainter extends CustomPainter {
  final PosterFrame frame;
  FrameBorderPainter(this.frame);

  @override
  void paint(Canvas canvas, Size size) {
    final hw = frame.borderWidth / 2;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(hw, hw, size.width - frame.borderWidth, size.height - frame.borderWidth),
      Radius.circular(frame.borderRadius),
    );
    if (frame.gradientColors.isNotEmpty) {
      canvas.drawRRect(
        rrect,
        Paint()
          ..shader = LinearGradient(
                  colors: frame.gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight)
              .createShader(Rect.fromLTWH(0, 0, size.width, size.height))
          ..style = PaintingStyle.stroke
          ..strokeWidth = frame.borderWidth,
      );
    } else {
      canvas.drawRRect(
        rrect,
        Paint()
          ..color = frame.borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = frame.borderWidth,
      );
    }
  }

  @override
  bool shouldRepaint(FrameBorderPainter old) => true;
}

// ════════════════════════════════════════════════════════
//  ANIMATION WRAPPER
// ════════════════════════════════════════════════════════

class AnimatedPosterWrapper extends StatefulWidget {
  final PosterAnimation animation;
  final Widget child;
  const AnimatedPosterWrapper({
    super.key,
    required this.animation,
    required this.child,
  });

  @override
  State<AnimatedPosterWrapper> createState() => _AnimatedPosterWrapperState();
}

class _AnimatedPosterWrapperState extends State<AnimatedPosterWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    if (widget.animation != PosterAnimation.none) _ctrl.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(AnimatedPosterWrapper old) {
    super.didUpdateWidget(old);
    if (widget.animation != old.animation) {
      if (widget.animation == PosterAnimation.none) {
        _ctrl.stop();
        _ctrl.reset();
      } else {
        _ctrl.repeat(reverse: true);
      }
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animation == PosterAnimation.none) return widget.child;
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, child) {
        switch (widget.animation) {
          case PosterAnimation.flipInX:
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateX((_anim.value - 0.5) * 0.3),
              child: child,
            );
          case PosterAnimation.flipInY:
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateY((_anim.value - 0.5) * 0.3),
              child: child,
            );
          case PosterAnimation.wobble:
            return Transform.rotate(
                angle: sin(_anim.value * 2 * pi) * 0.04, child: child);
          case PosterAnimation.rollIn:
            return Transform.rotate(
                angle: (_anim.value - 0.5) * 0.15, child: child);
          case PosterAnimation.largeZoom:
            return Transform.scale(
                scale: 1.0 + _anim.value * 0.04, child: child);
          case PosterAnimation.rotateLeft:
            return Transform.rotate(
                angle: -_anim.value * 0.06, child: child);
          case PosterAnimation.rotateRight:
            return Transform.rotate(
                angle: _anim.value * 0.06, child: child);
          case PosterAnimation.bounce:
            return Transform.translate(
                offset: Offset(0, -_anim.value * 8), child: child);
          case PosterAnimation.fadeIn:
            return Opacity(
                opacity: 0.85 + _anim.value * 0.15, child: child);
          default:
            return child!;
        }
      },
      child: widget.child,
    );
  }
}

// ════════════════════════════════════════════════════════
//  BOTTOM PANELS
// ════════════════════════════════════════════════════════

class FramesPanel extends StatefulWidget {
  final PosterFrame? selectedFrame;
  final ValueChanged<PosterFrame?> onFrameSelected;
  const FramesPanel({
    super.key,
    required this.selectedFrame,
    required this.onFrameSelected,
  });

  @override
  State<FramesPanel> createState() => _FramesPanelState();
}

class _FramesPanelState extends State<FramesPanel> {
  int _selectedColorIndex = -1;

  static const List<Color> _suggestedColors = [
    Color(0xFF00BFA5),
    Color(0xFF8D6E63),
    Color(0xFF90A4AE),
    Color(0xFF66BB6A),
    Color(0xFFFFA726),
    Color(0xFF26A69A),
    Color(0xFF4CAF50),
    Color(0xFF00ACC1),
    Color(0xFFB2DFDB),
  ];

  final List<PosterFrame> _frames = const [
    PosterFrame(id: 'default', name: 'Use\nDefault', borderColor: Colors.transparent, isDefault: true),
    PosterFrame(id: 'gold', name: 'Gold', borderColor: Color(0xFFFFD700), borderWidth: 10, gradientColors: [Color(0xFFFFD700), Color(0xFFFFA000)]),
    PosterFrame(id: 'modern', name: 'Modern', borderColor: Color(0xFF2196F3), borderWidth: 8, borderRadius: 12),
    PosterFrame(id: 'elegant', name: 'Elegant', borderColor: Color(0xFF9C27B0), borderWidth: 12, gradientColors: [Color(0xFF9C27B0), Color(0xFFE040FB)]),
    PosterFrame(id: 'business', name: 'Business', borderColor: Color(0xFF37474F), borderWidth: 8),
    PosterFrame(id: 'nature', name: 'Nature', borderColor: Color(0xFF388E3C), borderWidth: 10, borderRadius: 8),
    PosterFrame(id: 'sunset', name: 'Sunset', borderColor: Color(0xFFFF5722), borderWidth: 10, gradientColors: [Color(0xFFFF5722), Color(0xFFFF9800)]),
    PosterFrame(id: 'ocean', name: 'Ocean', borderColor: Color(0xFF0288D1), borderWidth: 10, gradientColors: [Color(0xFF0288D1), Color(0xFF00BCD4)], borderRadius: 16),
    PosterFrame(id: 'rose', name: 'Rose', borderColor: Color(0xFFE91E63), borderWidth: 8, gradientColors: [Color(0xFFE91E63), Color(0xFFF48FB1)]),
    PosterFrame(id: 'silver', name: 'Silver', borderColor: Color(0xFF9E9E9E), borderWidth: 10, gradientColors: [Color(0xFFBDBDBD), Color(0xFF757575)]),
    PosterFrame(id: 'royal', name: 'Royal', borderColor: Color(0xFF283593), borderWidth: 12, gradientColors: [Color(0xFF283593), Color(0xFF3949AB)]),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          const Text('Suggested Colours',
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _suggestedColors.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final isSel = _selectedColorIndex == i;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedColorIndex = i);
                    widget.onFrameSelected(PosterFrame(
                        id: 'color_$i',
                        name: 'Color',
                        borderColor: _suggestedColors[i],
                        borderWidth: 10));
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _suggestedColors[i],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: isSel ? Colors.white : Colors.transparent,
                          width: 2.5),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 108,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _frames.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final f = _frames[i];
                final isSel = widget.selectedFrame?.id == f.id;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedColorIndex = -1);
                    widget.onFrameSelected(f.isDefault ? null : f);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 86,
                    height: 108,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: isSel ? Colors.white : Colors.grey.shade300,
                          width: isSel ? 2.5 : 1),
                      boxShadow: isSel
                          ? [
                              BoxShadow(
                                  color: Colors.white.withOpacity(0.4),
                                  blurRadius: 8)
                            ]
                          : [],
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _FrameThumb(frame: f),
                          const SizedBox(height: 6),
                          Text(f.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87)),
                        ]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FrameThumb extends StatelessWidget {
  final PosterFrame frame;
  const _FrameThumb({required this.frame});

  @override
  Widget build(BuildContext context) {
    if (frame.isDefault) {
      return Container(
          width: 58,
          height: 66,
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border.all(
                  color: const Color(0xFFFFE500),
                  width: 2,
                  style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(4)),
          child: const Center(
              child: Text('Use\nDefault',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 8, color: Colors.black54))));
    }
    if (frame.gradientColors.isNotEmpty) {
      return Container(
          width: 58,
          height: 66,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: frame.gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(frame.borderRadius)),
          child: Container(
              margin: EdgeInsets.all(frame.borderWidth * 0.5),
              color: Colors.white));
    }
    return Container(
        width: 58,
        height: 66,
        decoration: BoxDecoration(
            border: Border.all(color: frame.borderColor, width: 3),
            borderRadius: BorderRadius.circular(frame.borderRadius)));
  }
}

class AnimationPanel extends StatelessWidget {
  final PosterAnimation currentAnimation;
  final ValueChanged<PosterAnimation> onAnimationSelected;
  const AnimationPanel(
      {super.key,
      required this.currentAnimation,
      required this.onAnimationSelected});

  static const List<({PosterAnimation type, String label, IconData icon})>
      _opts = [
    (type: PosterAnimation.none, label: 'Remove', icon: Icons.block),
    (type: PosterAnimation.flipInX, label: 'FlipInX', icon: Icons.flip),
    (type: PosterAnimation.flipInY, label: 'FlipInY', icon: Icons.flip_camera_android),
    (type: PosterAnimation.wobble, label: 'Wobble', icon: Icons.waves),
    (type: PosterAnimation.rollIn, label: 'RollIn', icon: Icons.rotate_right),
    (type: PosterAnimation.largeZoom, label: 'LargeZoom', icon: Icons.zoom_in),
    (type: PosterAnimation.rotateLeft, label: 'RotateLeft', icon: Icons.rotate_left),
    (type: PosterAnimation.rotateRight, label: 'RotateRight', icon: Icons.rotate_right_outlined),
    (type: PosterAnimation.bounce, label: 'Bounce', icon: Icons.sports_basketball_outlined),
    (type: PosterAnimation.fadeIn, label: 'FadeIn', icon: Icons.brightness_medium),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Animation',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            const SizedBox(height: 12),
            SizedBox(
              height: 92,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _opts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) {
                  final opt = _opts[i];
                  final isSel = currentAnimation == opt.type;
                  return GestureDetector(
                    onTap: () => onAnimationSelected(opt.type),
                    child:
                        Column(mainAxisSize: MainAxisSize.min, children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: opt.type == PosterAnimation.none
                              ? Colors.grey.shade800
                              : Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: isSel
                                  ? Colors.white
                                  : Colors.grey.shade700,
                              width: isSel ? 2.5 : 1),
                          boxShadow: isSel
                              ? [
                                  BoxShadow(
                                      color:
                                          Colors.white.withOpacity(0.3),
                                      blurRadius: 8)
                                ]
                              : [],
                        ),
                        child: Center(
                          child: opt.type == PosterAnimation.none
                              ? const Text('Remove\nAnimation',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 8.5,
                                      fontWeight: FontWeight.w600))
                              : Icon(opt.icon,
                                  color: const Color(0xFFFFE500),
                                  size: 28),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(opt.label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: isSel
                                  ? Colors.white
                                  : Colors.white60,
                              fontSize: 9,
                              fontWeight: isSel
                                  ? FontWeight.bold
                                  : FontWeight.normal)),
                    ]),
                  );
                },
              ),
            ),
          ]),
    );
  }
}

class TextToolsPanel extends StatelessWidget {
  final VoidCallback onAddText, onAddLogo, onAddImage;
  const TextToolsPanel(
      {super.key,
      required this.onAddText,
      required this.onAddLogo,
      required this.onAddImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Text & Elements',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            const SizedBox(height: 12),
            Row(children: [
              _ToolBtn(icon: Icons.text_fields, label: 'Add Text', onTap: onAddText),
              const SizedBox(width: 12),
              _ToolBtn(icon: Icons.image_outlined, label: 'Add Image', onTap: onAddImage),
              const SizedBox(width: 12),
              _ToolBtn(icon: Icons.business_center_outlined, label: 'Add Logo', onTap: onAddLogo),
            ]),
          ]),
    );
  }
}

class _ToolBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ToolBtn(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade700)),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white, size: 28),
                  const SizedBox(height: 6),
                  Text(label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 10)),
                ])),
      );
}

class EffectsPanel extends StatelessWidget {
  final PosterEffectType currentEffect;
  final ValueChanged<PosterEffectType> onEffectSelected;
  const EffectsPanel(
      {super.key,
      required this.currentEffect,
      required this.onEffectSelected});

  @override
  Widget build(BuildContext context) {
    final effects = [
      _EffectOption(type: PosterEffectType.none, label: 'Remove', preview: _buildRemovePreview()),
      _EffectOption(type: PosterEffectType.sparkle, label: 'Sparkle', preview: _buildSparklePreview()),
      _EffectOption(type: PosterEffectType.stars, label: 'Stars', preview: _buildStarsPreview()),
      _EffectOption(type: PosterEffectType.snow, label: 'Snow', preview: _buildSnowPreview()),
      _EffectOption(type: PosterEffectType.confetti, label: 'Confetti', preview: _buildConfettiPreview()),
    ];

    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Effect',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: effects.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final opt = effects[i];
                final isSelected = currentEffect == opt.type;
                return GestureDetector(
                  onTap: () => onEffectSelected(opt.type),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Colors.white
                                : Colors.transparent,
                            width: 2.5,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                      color:
                                          Colors.white.withOpacity(0.35),
                                      blurRadius: 10,
                                      spreadRadius: 2)
                                ]
                              : [],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: opt.preview,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        opt.label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : Colors.white60,
                          fontSize: 10,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemovePreview() => Container(
        color: Colors.grey.shade800,
        child: const Center(
          child: Text('Remove\nEffect',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70)),
        ),
      );

  Widget _buildSparklePreview() => Container(
        color: const Color(0xFFFFB300),
        child: Stack(children: [
          Positioned(top: 8, left: 10, child: Icon(Icons.auto_awesome, color: Colors.white, size: 16)),
          Positioned(bottom: 10, right: 6, child: Icon(Icons.auto_awesome, color: Colors.white, size: 22)),
          Positioned(top: 28, right: 18, child: Icon(Icons.auto_awesome, color: Colors.white70, size: 11)),
          Positioned(bottom: 22, left: 6, child: Icon(Icons.auto_awesome, color: Colors.white60, size: 10)),
        ]),
      );

  Widget _buildStarsPreview() => Container(
        color: const Color(0xFFFFD700),
        child: Stack(children: [
          Positioned(top: 8, left: 8, child: Icon(Icons.star, color: Colors.white, size: 18)),
          Positioned(bottom: 8, right: 6, child: Icon(Icons.star, color: Colors.white, size: 22)),
          Positioned(top: 30, right: 20, child: Icon(Icons.star, color: Colors.white70, size: 12)),
          Positioned(bottom: 24, left: 4, child: Icon(Icons.star, color: Colors.white60, size: 10)),
        ]),
      );

  Widget _buildSnowPreview() => Container(
        color: const Color(0xFF64B5F6),
        child: Stack(children: [
          Positioned(top: 8, left: 10, child: Icon(Icons.ac_unit, color: Colors.white, size: 16)),
          Positioned(bottom: 8, right: 8, child: Icon(Icons.ac_unit, color: Colors.white, size: 20)),
          Positioned(top: 30, right: 18, child: Icon(Icons.ac_unit, color: Colors.white70, size: 11)),
          Positioned(bottom: 26, left: 4, child: Icon(Icons.ac_unit, color: Colors.white60, size: 10)),
        ]),
      );

  Widget _buildConfettiPreview() => Container(
        color: const Color(0xFFE91E63),
        child: Stack(children: [
          Positioned(top: 8, left: 10, child: Icon(Icons.celebration, color: Colors.white, size: 16)),
          Positioned(bottom: 8, right: 6, child: Icon(Icons.celebration, color: Colors.white, size: 22)),
          Positioned(top: 30, right: 18, child: Icon(Icons.celebration, color: Colors.white70, size: 11)),
          Positioned(bottom: 24, left: 4, child: Icon(Icons.celebration, color: Colors.white60, size: 10)),
        ]),
      );
}

class _EffectOption {
  final PosterEffectType type;
  final String label;
  final Widget preview;
  const _EffectOption(
      {required this.type, required this.label, required this.preview});
}

class DesignPanel extends StatelessWidget {
  final BottomBarDesign currentDesign;
  final ValueChanged<BottomBarDesign> onDesignSelected;
  const DesignPanel(
      {super.key,
      required this.currentDesign,
      required this.onDesignSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Text('Bottom Bar Style',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            const SizedBox(width: 10),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                  color: const Color(0xFFFFE500),
                  borderRadius: BorderRadius.circular(12)),
              child: Text(currentDesign.name,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 11)),
            ),
          ]),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: kBottomBarDesigns.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final d = kBottomBarDesigns[i];
                final isSelected = currentDesign.id == d.id;
                return GestureDetector(
                  onTap: () => onDesignSelected(d),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 110,
                        height: 94,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFFFE500)
                                : Colors.grey.shade700,
                            width: isSelected ? 2.5 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                      color: const Color(0xFFFFE500)
                                          .withOpacity(0.3),
                                      blurRadius: 10,
                                      spreadRadius: 1)
                                ]
                              : [],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _BarStylePreview(design: d),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isSelected)
                            const Icon(Icons.check_circle,
                                color: Color(0xFFFFE500), size: 12),
                          if (isSelected) const SizedBox(width: 3),
                          Text(d.name,
                              style: TextStyle(
                                color: isSelected
                                    ? const Color(0xFFFFE500)
                                    : Colors.white60,
                                fontSize: 11,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              )),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BarStylePreview extends StatelessWidget {
  final BottomBarDesign design;
  const _BarStylePreview({required this.design});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: design.gradient,
        color: design.gradient == null ? design.solidColor : null,
      ),
      child: Stack(
        children: [
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 40,
              child: Container(
                  color: const Color(0xFFE0E0E0),
                  child: Center(
                      child: Icon(Icons.image,
                          color: Colors.grey.shade400, size: 22)))),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 40,
              child: _buildBarLayout()),
        ],
      ),
    );
  }

  Widget _buildBarLayout() {
    final tc = design.primaryColor;
    final sc = design.secondaryColor;
    final ibg = design.iconBgColor;

    Widget _bar(Color c, double maxW) => Flexible(
          child: Container(
            height: 4,
            constraints: BoxConstraints(maxWidth: maxW),
            decoration: BoxDecoration(
                color: c, borderRadius: BorderRadius.circular(2)),
          ),
        );

    switch (design.layoutStyle) {
      case BarLayoutStyle.stacked:
        return Container(
          decoration: BoxDecoration(
            gradient: design.gradient,
            color: design.gradient == null ? design.solidColor : null,
            border: design.showTopBorder
                ? Border(
                    top: BorderSide(
                        color: design.topBorderColor, width: 1))
                : null,
            borderRadius: design.borderRadiusTop > 0
                ? BorderRadius.vertical(
                    top: Radius.circular(design.borderRadiusTop))
                : null,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Icon(Icons.business, color: tc, size: 8),
                const SizedBox(width: 3),
                _bar(tc.withOpacity(0.9), 44),
              ]),
              const SizedBox(height: 3),
              Row(children: [
                Icon(Icons.phone, color: sc, size: 8),
                const SizedBox(width: 3),
                _bar(sc.withOpacity(0.7), 32),
              ]),
            ],
          ),
        );

      case BarLayoutStyle.badgeChip:
        return Container(
          decoration: BoxDecoration(
            gradient: design.gradient,
            color: design.gradient == null ? design.solidColor : null,
            border: Border(
                top:
                    BorderSide(color: design.topBorderColor, width: 1.5)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5, vertical: 3),
                  decoration: BoxDecoration(
                    color: ibg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: tc.withOpacity(0.5), width: 1),
                  ),
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.business, color: tc, size: 8),
                        const SizedBox(width: 3),
                        Flexible(
                            child: Container(
                                height: 4,
                                constraints:
                                    const BoxConstraints(maxWidth: 18),
                                decoration: BoxDecoration(
                                    color: tc,
                                    borderRadius:
                                        BorderRadius.circular(2)))),
                      ]),
                ),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5, vertical: 3),
                  decoration: BoxDecoration(
                    color: ibg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: tc.withOpacity(0.5), width: 1),
                  ),
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.phone, color: tc, size: 8),
                        const SizedBox(width: 3),
                        Flexible(
                            child: Container(
                                height: 4,
                                constraints:
                                    const BoxConstraints(maxWidth: 18),
                                decoration: BoxDecoration(
                                    color: tc,
                                    borderRadius:
                                        BorderRadius.circular(2)))),
                      ]),
                ),
              ),
            ],
          ),
        );

      case BarLayoutStyle.centered:
        return Container(
          decoration: BoxDecoration(
            gradient: design.gradient,
            color: design.gradient == null ? design.solidColor : null,
            border: Border(
                top: BorderSide(color: design.topBorderColor, width: 1)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                        child: Container(
                            height: 5,
                            constraints:
                                const BoxConstraints(maxWidth: 55),
                            decoration: BoxDecoration(
                                color: tc,
                                borderRadius:
                                    BorderRadius.circular(3)))),
                  ]),
              const SizedBox(height: 4),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                        child: Container(
                            height: 3,
                            constraints:
                                const BoxConstraints(maxWidth: 38),
                            decoration: BoxDecoration(
                                color: sc,
                                borderRadius:
                                    BorderRadius.circular(3)))),
                  ]),
            ],
          ),
        );

      case BarLayoutStyle.cardSplit:
        return Container(
          decoration: BoxDecoration(
              gradient: design.gradient,
              color: design.gradient == null
                  ? design.solidColor
                  : null),
          padding:
              const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
          child: Row(children: [
            Expanded(
                child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 4, vertical: 4),
              decoration: BoxDecoration(
                  color: ibg,
                  borderRadius: BorderRadius.circular(6)),
              child: Row(children: [
                Icon(Icons.business, color: tc, size: 8),
                const SizedBox(width: 3),
                _bar(tc, 22),
              ]),
            )),
            const SizedBox(width: 4),
            Expanded(
                child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 4, vertical: 4),
              decoration: BoxDecoration(
                  color: ibg,
                  borderRadius: BorderRadius.circular(6)),
              child: Row(children: [
                Icon(Icons.phone, color: tc, size: 8),
                const SizedBox(width: 3),
                _bar(tc, 22),
              ]),
            )),
          ]),
        );

      case BarLayoutStyle.minimal:
        return Container(
          color: design.solidColor,
          padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              Expanded(
                  child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                          color: tc,
                          borderRadius: BorderRadius.circular(2)))),
              Container(
                  width: 1,
                  height: 16,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 6),
                  color: design.dividerColor),
              Expanded(
                  child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                          color: sc,
                          borderRadius: BorderRadius.circular(2)))),
            ],
          ),
        );

      case BarLayoutStyle.ribbon:
        return Container(
          decoration: BoxDecoration(
            gradient: design.gradient,
            border: Border(
                top: BorderSide(
                    color: design.topBorderColor, width: 2)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            children: [
              Container(
                  width: 3,
                  height: 28,
                  color: tc.withOpacity(0.7),
                  margin: const EdgeInsets.only(right: 5)),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 4,
                      decoration: BoxDecoration(
                          color: tc,
                          borderRadius:
                              BorderRadius.circular(2))),
                  const SizedBox(height: 3),
                  Container(
                      height: 3,
                      width: double.infinity,
                      constraints:
                          const BoxConstraints(maxWidth: 32),
                      decoration: BoxDecoration(
                          color: tc.withOpacity(0.6),
                          borderRadius:
                              BorderRadius.circular(2))),
                ],
              )),
            ],
          ),
        );

      case BarLayoutStyle.neon:
        return Container(
          decoration: BoxDecoration(
            color: design.solidColor,
            border: Border(
                top: BorderSide(
                    color: design.topBorderColor, width: 1.5)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(children: [
            Expanded(
                child: Row(children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: tc, width: 1),
                  boxShadow: [
                    BoxShadow(
                        color: tc.withOpacity(0.5),
                        blurRadius: 4)
                  ],
                ),
                child: Icon(Icons.business, color: tc, size: 7),
              ),
              const SizedBox(width: 3),
              Expanded(
                  child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: tc,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                              color: tc.withOpacity(0.4),
                              blurRadius: 3)
                        ],
                      ))),
            ])),
            Container(
                width: 1,
                height: 20,
                color: design.dividerColor),
            Expanded(
                child: Row(children: [
              const SizedBox(width: 4),
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: tc, width: 1),
                  boxShadow: [
                    BoxShadow(
                        color: tc.withOpacity(0.5),
                        blurRadius: 4)
                  ],
                ),
                child: Icon(Icons.phone, color: tc, size: 7),
              ),
              const SizedBox(width: 3),
              Expanded(
                  child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: tc,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                              color: tc.withOpacity(0.4),
                              blurRadius: 3)
                        ],
                      ))),
            ])),
          ]),
        );

      case BarLayoutStyle.wave:
        return ClipPath(
          clipper: _WaveClipper(),
          child: Container(
            decoration: BoxDecoration(
              gradient: design.gradient,
              color: design.gradient == null
                  ? design.solidColor
                  : null,
            ),
            padding: const EdgeInsets.fromLTRB(6, 10, 6, 4),
            child: Row(children: [
              Expanded(
                  child: Row(children: [
                Icon(Icons.business,
                    color: design.primaryColor, size: 8),
                const SizedBox(width: 3),
                Expanded(
                    child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                            color: design.primaryColor,
                            borderRadius:
                                BorderRadius.circular(2)))),
              ])),
              Container(
                  width: 1,
                  height: 16,
                  color: design.dividerColor),
              Expanded(
                  child: Row(children: [
                const SizedBox(width: 4),
                Icon(Icons.phone,
                    color: design.secondaryColor, size: 8),
                const SizedBox(width: 3),
                Expanded(
                    child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                            color: design.secondaryColor,
                            borderRadius:
                                BorderRadius.circular(2)))),
              ])),
            ]),
          ),
        );

      case BarLayoutStyle.magazine:
        return Container(
          decoration: BoxDecoration(
            gradient: design.gradient,
            color: design.gradient == null
                ? design.solidColor
                : null,
            border: Border(
                top: BorderSide(
                    color: design.topBorderColor, width: 1)),
          ),
          padding:
              const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Row(children: [
            Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 6,
                        decoration: BoxDecoration(
                            color: design.primaryColor,
                            borderRadius:
                                BorderRadius.circular(2))),
                    const SizedBox(height: 2),
                    Container(
                        height: 3,
                        decoration: BoxDecoration(
                            color: design.primaryColor
                                .withOpacity(0.5),
                            borderRadius:
                                BorderRadius.circular(2))),
                  ],
                )),
            Container(
                width: 1,
                height: 24,
                margin:
                    const EdgeInsets.symmetric(horizontal: 4),
                color: design.dividerColor),
            Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 3,
                        decoration: BoxDecoration(
                            color: design.secondaryColor,
                            borderRadius:
                                BorderRadius.circular(2))),
                    const SizedBox(height: 2),
                    Container(
                        height: 3,
                        decoration: BoxDecoration(
                            color: design.secondaryColor
                                .withOpacity(0.6),
                            borderRadius:
                                BorderRadius.circular(2))),
                  ],
                )),
          ]),
        );

      case BarLayoutStyle.classic:
      default:
        return Container(
          decoration: BoxDecoration(
            gradient: design.gradient,
            color: design.gradient == null
                ? design.solidColor
                : null,
            border: design.showTopBorder
                ? Border(
                    top: BorderSide(
                        color: design.topBorderColor, width: 1))
                : null,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(children: [
            Expanded(
                child: Row(children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                    color: ibg,
                    borderRadius: BorderRadius.circular(4)),
                child: Icon(Icons.business, color: tc, size: 9),
              ),
              const SizedBox(width: 4),
              Expanded(
                  child: Container(
                      height: 5,
                      decoration: BoxDecoration(
                          color: tc,
                          borderRadius:
                              BorderRadius.circular(2)))),
            ])),
            Container(
                width: 1, height: 22, color: design.dividerColor),
            Expanded(
                child: Row(children: [
              const SizedBox(width: 4),
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                    color: ibg,
                    borderRadius: BorderRadius.circular(4)),
                child: Icon(Icons.phone, color: tc, size: 9),
              ),
              const SizedBox(width: 4),
              Expanded(
                  child: Container(
                      height: 5,
                      decoration: BoxDecoration(
                          color: tc,
                          borderRadius:
                              BorderRadius.circular(2)))),
            ])),
          ]),
        );
    }
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 8);
    path.quadraticBezierTo(
        size.width * 0.25, 0, size.width * 0.5, 6);
    path.quadraticBezierTo(
        size.width * 0.75, 12, size.width, 4);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_WaveClipper old) => false;
}

// ════════════════════════════════════════════════════════
//  DATA MODELS
// ════════════════════════════════════════════════════════

class PosterTemplate {
  String id, name, categoryName, description, title, email, mobile;
  double width, height;
  String? backgroundImage;
  Color backgroundColor;
  List<TextElement> textElements;
  List<ImageElement> imageElements;
  DesignData designData;

  PosterTemplate({
    required this.id,
    required this.name,
    required this.categoryName,
    required this.description,
    required this.title,
    required this.email,
    required this.mobile,
    required this.width,
    required this.height,
    this.backgroundImage,
    this.backgroundColor = Colors.white,
    this.textElements = const [],
    this.imageElements = const [],
    required this.designData,
  });

  factory PosterTemplate.fromApiResponse(Map<String, dynamic> r) {
    final p = r['poster'] as Map<String, dynamic>;
    final d = p['designData'] as Map<String, dynamic>;
    final ts = TextSettings.fromJson(d['textSettings'] ?? {});
    final tst = TextStyles.fromJson(d['textStyles'] ?? {});
    final tv = TextVisibility.fromJson(d['textVisibility'] ?? {});

    List<TextElement> textElements = [];
    if (tv.isVisible('title'))
      textElements.add(TextElement(
          id: 'title',
          text: p['title'] ?? '',
          x: ts.titleX,
          y: ts.titleY,
          width: 800,
          height: 200,
          fontSize: tst.title.fontSize ?? 36,
          color: tst.title.color ?? Colors.black,
          fontWeight: tst.title.fontWeight ?? FontWeight.bold,
          fontFamily: tst.title.fontFamily ?? 'Times New Roman',
          textAlign: TextAlign.center));
    if (tv.isVisible('description'))
      textElements.add(TextElement(
          id: 'description',
          text: p['description'] ?? '',
          x: ts.descriptionX,
          y: ts.descriptionY,
          width: 900,
          height: 400,
          fontSize: tst.description.fontSize ?? 20,
          color: tst.description.color ?? Colors.black,
          fontWeight: tst.description.fontWeight ?? FontWeight.bold,
          fontFamily: tst.description.fontFamily ?? 'Times New Roman'));
    if (tv.isVisible('name'))
      textElements.add(TextElement(
          id: 'name',
          text: 'Business Name',
          x: ts.nameX,
          y: ts.nameY,
          width: 400,
          height: 100,
          fontSize: 2,
          color: tst.name.color ?? Colors.black,
          fontWeight: tst.name.fontWeight ?? FontWeight.bold,
          fontFamily: tst.name.fontFamily ?? 'Arial'));

    List<ImageElement> imageElements = [];
    if (d['overlayImages'] != null) {
      final oi = d['overlayImages'] as List;
      final ov = (d['overlaySettings']?['overlays'] as List?) ?? [];
      for (int i = 0; i < oi.length; i++) {
        final img = oi[i];
        final o = i < ov.length ? ov[i] : null;
        imageElements.add(ImageElement(
            id: img['_id'] ?? 'ov_$i',
            imageUrl: img['url'] ?? '',
            x: _pd(o?['x'], 324),
            y: _pd(o?['y'], 521),
            width: _pd(o?['width'], 252),
            height: _pd(o?['height'], 252)));
      }
    }

    return PosterTemplate(
      id: p['_id'] ?? 'tpl_${DateTime.now().millisecondsSinceEpoch}',
      name: p['name'] ?? 'Untitled',
      categoryName: p['categoryName'] ?? '',
      description: p['description'] ?? '',
      title: p['title'] ?? '',
      email: p['email'] ?? '',
      mobile: p['mobile'] ?? '',
      width: 900,
      height: 1200,
      backgroundImage: d['bgImage']?['url'],
      textElements: textElements,
      imageElements: imageElements,
      designData: DesignData.fromJson(d),
    );
  }

  static double _pd(dynamic v, double d) {
    if (v == null) return d;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? d;
    return d;
  }
}

class DesignData {
  DesignData();
  factory DesignData.fromJson(Map<String, dynamic> j) => DesignData();
}

class TextSettings {
  double nameX, nameY, emailX, emailY, mobileX, mobileY, titleX, titleY,
      descriptionX, descriptionY, tagsX, tagsY;
  TextSettings(
      {this.nameX = 0,
      this.nameY = 0,
      this.emailX = 0,
      this.emailY = 0,
      this.mobileX = 0,
      this.mobileY = 0,
      this.titleX = 0,
      this.titleY = 0,
      this.descriptionX = 0,
      this.descriptionY = 0,
      this.tagsX = 0,
      this.tagsY = 0});
  factory TextSettings.fromJson(Map<String, dynamic> j) => TextSettings(
      nameX: _p(j['nameX'], 0),
      nameY: _p(j['nameY'], 0),
      emailX: _p(j['emailX'], 0),
      emailY: _p(j['emailY'], 0),
      mobileX: _p(j['mobileX'], 0),
      mobileY: _p(j['mobileY'], 0),
      titleX: _p(j['titleX'], 0),
      titleY: _p(j['titleY'], 0),
      descriptionX: _p(j['descriptionX'], 0),
      descriptionY: _p(j['descriptionY'], 0),
      tagsX: _p(j['tagsX'], 0),
      tagsY: _p(j['tagsY'], 0));
  static double _p(dynamic v, double d) {
    if (v == null) return d;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? d;
    return d;
  }
}

class TextStyles {
  TextStyle name, email, mobile, title, description, tags;
  TextStyles(
      {required this.name,
      required this.email,
      required this.mobile,
      required this.title,
      required this.description,
      required this.tags});
  factory TextStyles.fromJson(Map<String, dynamic> j) => TextStyles(
      name: _ts(j['name'] ?? {}),
      email: _ts(j['email'] ?? {}),
      mobile: _ts(j['mobile'] ?? {}),
      title: _ts(j['title'] ?? {}),
      description: _ts(j['description'] ?? {}),
      tags: _ts(j['tags'] ?? {}));
  static TextStyle _ts(Map<String, dynamic> j) => TextStyle(
      fontSize: _p(j['fontSize'], 16),
      color: _c(j['color']),
      fontFamily: j['fontFamily'] ?? 'Arial',
      fontWeight: _fw(j['fontWeight'] ?? 'normal'),
      fontStyle: j['fontStyle'] == 'italic'
          ? FontStyle.italic
          : FontStyle.normal);
  static Color _c(dynamic v) {
    if (v == null) return Colors.black;
    if (v is int) return Color(v);
    if (v is String) {
      String h = v.replaceAll('#', '');
      if (h.length == 6) h = 'FF$h';
      final i = int.tryParse(h, radix: 16);
      if (i != null) return Color(i);
    }
    return Colors.black;
  }

  static double _p(dynamic v, double d) {
    if (v == null) return d;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? d;
    return d;
  }

  static FontWeight _fw(String w) {
    switch (w.toLowerCase()) {
      case 'bold': return FontWeight.bold;
      case 'w600': return FontWeight.w600;
      case 'w300': return FontWeight.w300;
      default: return FontWeight.normal;
    }
  }
}

class TextVisibility {
  String name, email, mobile, title, description, tags;
  TextVisibility(
      {this.name = 'visible',
      this.email = 'visible',
      this.mobile = 'visible',
      this.title = 'visible',
      this.description = 'visible',
      this.tags = 'visible'});
  factory TextVisibility.fromJson(Map<String, dynamic> j) =>
      TextVisibility(
          name: j['name'] ?? 'visible',
          email: j['email'] ?? 'visible',
          mobile: j['mobile'] ?? 'visible',
          title: j['title'] ?? 'visible',
          description: j['description'] ?? 'visible',
          tags: j['tags'] ?? 'visible');
  bool isVisible(String f) {
    switch (f) {
      case 'name': return name == 'visible';
      case 'email': return email == 'visible';
      case 'mobile': return mobile == 'visible';
      case 'title': return title == 'visible';
      case 'description': return description == 'visible';
      default: return true;
    }
  }
}

class TextElement {
  String id, text, fontFamily;
  double x, y, width, height, fontSize, rotation;
  Color color;
  FontWeight fontWeight;
  TextAlign textAlign;
  bool isSelected;
  TextElement({
    required this.id,
    required this.text,
    required this.x,
    required this.y,
    this.width = 200,
    this.height = 50,
    this.fontSize = 16,
    this.color = Colors.black,
    this.fontWeight = FontWeight.normal,
    this.fontFamily = 'Roboto',
    this.textAlign = TextAlign.left,
    this.isSelected = false,
    this.rotation = 0,
  });
}

class ImageElement {
  String id, imageUrl;
  double x, y, width, height, rotation, borderRadius;
  bool isSelected;
  ImageElement({
    required this.id,
    required this.imageUrl,
    required this.x,
    required this.y,
    this.width = 100,
    this.height = 100,
    this.isSelected = false,
    this.rotation = 0,
    this.borderRadius = 4,
  });
}

class ProfileElement {
  String id, imageUrl;
  double x, y, width, height, rotation;
  bool isSelected;
  ProfileElement({
    required this.id,
    required this.imageUrl,
    required this.x,
    required this.y,
    this.width = 200,
    this.height = 200,
    this.isSelected = false,
    this.rotation = 0,
  });
}

// ════════════════════════════════════════════════════════
//  POSTER PREVIEW SCREEN
// ════════════════════════════════════════════════════════

class PosterPreviewScreen extends StatefulWidget {
  final Widget posterWidget;
  final String posterName;
  final VoidCallback onSave;
  final VoidCallback onShare;

  const PosterPreviewScreen({
    super.key,
    required this.posterWidget,
    required this.posterName,
    required this.onSave,
    required this.onShare,
  });

  @override
  State<PosterPreviewScreen> createState() => _PosterPreviewScreenState();
}

class _PosterPreviewScreenState extends State<PosterPreviewScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  double _scale = 1.0;
  double _prevScale = 1.0;

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 420));
    _fadeAnim =
        CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _slideAnim =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
            .animate(CurvedAnimation(
                parent: _entryCtrl, curve: Curves.easeOutCubic));
    _entryCtrl.forward();
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.3),
                  radius: 1.2,
                  colors: [Color(0x226A1B9A), Color(0xFF0D0D0D)],
                ),
              ),
            ),
          ),
          Column(
            children: [
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 6),
                  child: Row(
                    children: [
                      Material(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => Navigator.of(context).pop(),
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(Icons.close,
                                color: Colors.white, size: 22),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Preview',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                    letterSpacing: 1.2)),
                            Text(
                              widget.posterName,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.pinch,
                                  color: Colors.white54, size: 14),
                              SizedBox(width: 4),
                              Text('Pinch to zoom',
                                  style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 11)),
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onScaleStart: (_) => _prevScale = _scale,
                  onScaleUpdate: (d) => setState(
                      () => _scale = (_prevScale * d.scale).clamp(0.5, 4.0)),
                  child: Center(
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: SlideTransition(
                        position: _slideAnim,
                        child: Transform.scale(
                          scale: _scale,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF6A1B9A)
                                      .withOpacity(0.35),
                                  blurRadius: 40,
                                  spreadRadius: 4,
                                  offset: const Offset(0, 10),
                                ),
                                BoxShadow(
                                  color:
                                      Colors.black.withOpacity(0.6),
                                  blurRadius: 20,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: widget.posterWidget,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SafeArea(
                top: false,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A2E),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _PreviewActionButton(
                          icon: Icons.save_alt_rounded,
                          label: 'Save',
                          color: const Color(0xFF6A1B9A),
                          onTap: () {
                            Navigator.of(context).pop();
                            widget.onSave();
                          },
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: _PreviewActionButton(
                          icon: Icons.share_rounded,
                          label: 'Share',
                          color: const Color(0xFF1565C0),
                          onTap: () {
                            Navigator.of(context).pop();
                            widget.onShare();
                          },
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: _PreviewActionButton(
                          icon: Icons.edit_rounded,
                          label: 'Edit',
                          color: const Color(0xFF2E7D32),
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreviewActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _PreviewActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(height: 4),
              Text(label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
//  MAIN SCREEN
// ════════════════════════════════════════════════════════

class SamplePosterScreen extends StatefulWidget {
  final String posterId;
  const SamplePosterScreen({super.key, required this.posterId});

  @override
  State<SamplePosterScreen> createState() => _ApiPosterEditorState();
}

class _ApiPosterEditorState extends State<SamplePosterScreen> {
  final TextEditingController _fontSizeCtrl = TextEditingController();

  // ── KEY CHANGE: One RepaintBoundary key that wraps everything
  //    including animation + effects ──
  final GlobalKey _canvasKey = GlobalKey();

  PosterTemplate? _template;
  bool _isLoading = true;
  String? _errorMessage;

  TextElement? _selectedText;
  ImageElement? _selectedImage;
  ProfileElement? _selectedProfile;
  bool _showToolbar = false;

  double _currentScale = 1.0,
      _previousScale = 1.0,
      _baseScale = 1.0;
  Offset _currentOffset = Offset.zero,
      _startOffset = Offset.zero,
      _focusPoint = Offset.zero;
  Offset? _initialFocalPoint;

  String? phoneNumber, email, userId, profileImageUrl;
  Uint8List? _logoImage, _profileImageBytes;
  ProfileElement? _profileImageElement;
  ImageElement? _logoImageElement;
  double _businessNameFontSize = 20.0, _phoneNumberFontSize = 20.0;
  BottomBarDesign _selectedBarDesign = kBottomBarDesigns[0];

  BottomTab _activeTab = BottomTab.none;
  PosterEffectType _currentEffect = PosterEffectType.none;
  PosterFrame? _selectedFrame;
  PosterAnimation _currentAnimation = PosterAnimation.none;

  final ImagePicker _picker = ImagePicker();

  final List<String> _fontFamilies = [
    'Roboto', 'Arial', 'Times New Roman', 'Helvetica', 'Verdana', 'Georgia',
    'Montserrat', 'Poppins', 'Lato', 'Open Sans', 'Raleway', 'Nunito',
    'Oswald', 'Playfair Display', 'Dancing Script', 'Pacifico', 'Lobster',
    'Bebas Neue', 'Caveat', 'Permanent Marker', 'Quicksand', 'Inter', 'Manrope'
  ];
  final List<FontWeight> _fontWeights = [
    FontWeight.w100, FontWeight.w200, FontWeight.w300, FontWeight.w400,
    FontWeight.w500, FontWeight.w600, FontWeight.w700, FontWeight.w800,
    FontWeight.w900
  ];

  @override
  void initState() {
    super.initState();
    _loadPosterFromApi();
    _loadUserData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        Provider.of<LanguageProvider>(context, listen: false)
            .addListener(_onLangChanged);
      } catch (_) {}
    });
  }

  void _onLangChanged() {
    try {
      if (userId != null)
        Provider.of<CreateCustomerProvider>(context, listen: false)
            .fetchUser(userId!);
    } catch (_) {}
  }

  @override
  void dispose() {
    try {
      Provider.of<LanguageProvider>(context, listen: false)
          .removeListener(_onLangChanged);
    } catch (_) {}
    super.dispose();
  }

  // ── LOADING ──

  Future<void> _loadUserData() async {
    final data = await AuthPreferences.getUserData();
    if (data != null) {
      setState(() {
        phoneNumber = data.user.mobile ?? phoneNumber;
        profileImageUrl = data.user.profileImage;
        email = data.user.email ?? email;
        userId = data.user.id ?? userId;
      });
      if (profileImageUrl != null && profileImageUrl!.isNotEmpty)
        _loadProfileImage();
      if (_template != null) _updateTextWithUserData();
    }
  }

  Future<void> _loadPosterFromApi() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      final res = await http.get(
          Uri.parse(
              'http://31.97.206.144:4061/api/poster/singlecanvasposters/${widget.posterId}'),
          headers: {'Content-Type': 'application/json'});
      if (res.statusCode == 200) {
        final tpl =
            PosterTemplate.fromApiResponse(json.decode(res.body));
        setState(() {
          _template = tpl;
          _isLoading = false;
        });
        _updateTextWithUserData();
        await _loadSavedBusinessName();
      } else {
        throw Exception('Status: ${res.statusCode}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadSavedBusinessName() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('business_name');
    if (saved != null && saved.isNotEmpty && _template != null) {
      setState(() {
        _template!.textElements
            .firstWhere((e) => e.id == 'name',
                orElse: () =>
                    TextElement(id: 'name', text: '', x: 0, y: 0))
            .text = saved;
      });
    }
  }

  Future<void> _saveBusinessName(String n) async {
    final p = await SharedPreferences.getInstance();
    await p.setString('business_name', n);
  }

  Future<void> _loadProfileImage() async {
    try {
      final res = await http.get(Uri.parse(profileImageUrl!));
      if (res.statusCode == 200)
        setState(() {
          _profileImageBytes = res.bodyBytes;
          _profileImageElement = ProfileElement(
              id: 'profile_image',
              imageUrl: '',
              x: 10,
              y: 10,
              width: 200,
              height: 200);
        });
    } catch (_) {}
  }

  void _updateTextWithUserData() {
    if (_template == null) return;
    setState(() {
      for (var el in _template!.textElements) {
        if (el.id == 'email' && email != null && email!.isNotEmpty)
          el.text = email!;
        if (el.id == 'mobile' &&
            phoneNumber != null &&
            phoneNumber!.isNotEmpty) el.text = phoneNumber!;
      }
    });
  }

  // ── TAB ──

  void _setTab(BottomTab tab) => setState(() {
        _activeTab = _activeTab == tab ? BottomTab.none : tab;
        if (_activeTab != BottomTab.none) {
          _deselectAll();
          _showToolbar = false;
        }
      });

  // ── SELECTION ──

  void _selectText(TextElement el) => setState(() {
        _deselectAllSilent();
        el.isSelected = true;
        _selectedText = el;
        _selectedImage = null;
        _selectedProfile = null;
        _showToolbar = true;
        _activeTab = BottomTab.none;
      });
  void _selectImage(ImageElement el) => setState(() {
        _deselectAllSilent();
        el.isSelected = true;
        _selectedImage = el;
        _selectedText = null;
        _selectedProfile = null;
        _showToolbar = true;
        _activeTab = BottomTab.none;
      });
  void _selectProfile(ProfileElement el) => setState(() {
        _deselectAllSilent();
        el.isSelected = true;
        _selectedProfile = el;
        _selectedText = null;
        _selectedImage = null;
        _showToolbar = true;
        _activeTab = BottomTab.none;
      });

  void _deselectAllSilent() {
    _template?.textElements.forEach((e) => e.isSelected = false);
    _template?.imageElements.forEach((e) => e.isSelected = false);
    _profileImageElement?.isSelected = false;
    _logoImageElement?.isSelected = false;
  }

  void _deselectAll() => setState(() {
        _deselectAllSilent();
        _selectedText = null;
        _selectedImage = null;
        _selectedProfile = null;
        _showToolbar = false;
      });

  // ── MOVE / RESIZE ──

  void _moveText(TextElement el, Offset d) => setState(() {
        el.x = (el.x + d.dx)
            .clamp(-_template!.width * 0.5, _template!.width * 1.5);
        el.y = (el.y + d.dy)
            .clamp(-_template!.height * 0.5, _template!.height * 1.5);
      });
  void _moveImage(ImageElement el, Offset d) => setState(() {
        el.x = (el.x + d.dx)
            .clamp(0, _template!.width - el.width);
        el.y = (el.y + d.dy)
            .clamp(0, _template!.height - el.height);
      });
  void _moveProfile(ProfileElement el, Offset d) => setState(() {
        el.x = (el.x + d.dx)
            .clamp(0, _template!.width - el.width);
        el.y = (el.y + d.dy)
            .clamp(0, _template!.height - el.height);
      });
  void _resizeImage(ImageElement el, double s) => setState(() {
        final ns =
            (_baseScale * s).clamp(50.0, _template!.width * 0.8);
        el.width = ns;
        el.height = ns;
      });
  void _resizeProfile(ProfileElement el, double s) => setState(() {
        final ns =
            (_baseScale * s).clamp(50.0, _template!.width * 0.8);
        el.width = ns;
        el.height = ns;
      });

  // ── DELETE ──

  void _deleteSelected() {
    if (_selectedText != null) {
      setState(() {
        _template!.textElements.remove(_selectedText);
        _selectedText = null;
        _showToolbar = false;
      });
    } else if (_selectedImage != null) {
      setState(() {
        if (_selectedImage!.id == 'logo_image') {
          _logoImageElement = null;
          _logoImage = null;
        } else {
          _template!.imageElements.remove(_selectedImage);
        }
        _selectedImage = null;
        _showToolbar = false;
      });
    } else if (_selectedProfile != null) {
      setState(() {
        _profileImageElement = null;
        _profileImageBytes = null;
        _selectedProfile = null;
        _showToolbar = false;
      });
    }
  }

  // ── ADD ──

  void _addText() {
    if (_template == null) return;
    final el = TextElement(
        id: 'txt_${DateTime.now().millisecondsSinceEpoch}',
        text: 'New Text',
        x: 350,
        y: 350,
        fontSize: 50,
        color: Colors.black);
    setState(() {
      _template!.textElements.add(el);
      _selectText(el);
    });
  }

  Future<void> _pickLogo() async {
    final f = await _picker.pickImage(source: ImageSource.gallery);
    if (f != null) {
      final bytes = await f.readAsBytes();
      setState(() {
        _logoImage = bytes;
        _logoImageElement = ImageElement(
            id: 'logo_image',
            imageUrl: '',
            x: _template != null ? _template!.width - 120 : 20,
            y: 20,
            width: 100,
            height: 100);
      });
    }
  }

  Future<void> _pickAdditionalImage() async {
    final f = await _picker.pickImage(source: ImageSource.gallery);
    if (f != null) {
      final bytes = await f.readAsBytes();
      final tmp = await getTemporaryDirectory();
      final file = File(
          '${tmp.path}/add_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(bytes);
      setState(() {
        _template?.imageElements.add(ImageElement(
            id: 'add_${DateTime.now().millisecondsSinceEpoch}',
            imageUrl: file.path,
            x: _template!.width / 2 - 100,
            y: _template!.height / 2 - 100,
            width: 200,
            height: 200));
      });
    }
  }

  // ══════════════════════════════════════════════════════
  //  CAPTURE HELPER
  //  ▸ Waits for the next frame so animations/effects are
  //    actively painting when toImage() is called.
  //  ▸ The RepaintBoundary (_canvasKey) now wraps INSIDE
  //    the AnimatedPosterWrapper so the transform is baked in.
  // ══════════════════════════════════════════════════════
  Future<Uint8List> _capturePosterBytes() async {
    // Wait a couple frames so animation/effect is mid-cycle
    await Future.delayed(const Duration(milliseconds: 80));
    await WidgetsBinding.instance.endOfFrame;

    final boundary = _canvasKey.currentContext!.findRenderObject()
        as RenderRepaintBoundary;
    final img = await boundary.toImage(pixelRatio: 3.0);
    final byteData =
        await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  // ── SAVE / SHARE ──

  Future<void> _savePoster() async {
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const AlertDialog(
              content: Row(children: [
            CircularProgressIndicator(),
            SizedBox(width: 13),
            Text('Saving...')
          ])));
      final bytes = await _capturePosterBytes();
      await Gal.putImageBytes(bytes,
          album: 'Posters',
          name:
              'poster_${DateTime.now().millisecondsSinceEpoch}.png');
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Saved!'),
          backgroundColor: Colors.green));
    } catch (e) {
      if (Navigator.of(context).canPop())
        Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red));
    }
  }

  Future<void> _sharePoster() async {
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const AlertDialog(
              content: Row(children: [
            CircularProgressIndicator(),
            SizedBox(width: 12),
            Text('Preparing...')
          ])));
      final bytes = await _capturePosterBytes();
      final tmp = await getTemporaryDirectory();
      final file = File(
          '${tmp.path}/share_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(bytes);
      Navigator.of(context).pop();
      await Share.shareXFiles([XFile(file.path)],
          text: 'Check out my poster!');
    } catch (e) {
      if (Navigator.of(context).canPop())
        Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red));
    }
  }

  // ── PREVIEW ──

  void _openPreview() {
    if (_template == null) return;
    _deselectAll();
    // Pass the LIVE poster canvas (with animation/effects active)
    // into the preview screen via a fitted box wrapper
    final posterWidget = FittedBox(
      fit: BoxFit.contain,
      child: _buildPosterCanvas(interactive: false),
    );
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: animation,
          child: PosterPreviewScreen(
            posterWidget: posterWidget,
            posterName: _template!.name,
            onSave: _savePoster,
            onShare: _sharePoster,
          ),
        ),
        transitionDuration: const Duration(milliseconds: 380),
        reverseTransitionDuration:
            const Duration(milliseconds: 280),
      ),
    );
  }

  // ── DIALOGS ──

  void _showEditDialog(
      {required String title,
      required String currentValue,
      required IconData icon,
      TextInputType keyboardType = TextInputType.text,
      required Function(String) onSave}) {
    final ctrl = TextEditingController(text: currentValue);
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Row(children: [
                Icon(icon, color: Colors.deepPurple),
                const SizedBox(width: 12),
                Text(title)
              ]),
              content: TextField(
                  controller: ctrl,
                  keyboardType: keyboardType,
                  autofocus: true,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      prefixIcon: Icon(icon))),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel')),
                ElevatedButton(
                    onPressed: () {
                      onSave(ctrl.text);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white),
                    child: const Text('Save'))
              ],
            ));
  }

  void _showColorPicker() {
    if (_selectedText == null) return;
    Color temp = _selectedText!.color;
    showDialog(
        context: context,
        builder: (_) => StatefulBuilder(
            builder: (ctx, set) => AlertDialog(
                  title: const Text('Pick Color'),
                  content: SingleChildScrollView(
                      child: ColorPicker(
                          pickerColor: temp,
                          onColorChanged: (c) => set(() => temp = c),
                          pickerAreaHeightPercent: 0.4,
                          enableAlpha: false,
                          hexInputBar: false,
                          labelTypes: const [])),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: () {
                          setState(
                              () => _selectedText!.color = temp);
                          Navigator.pop(ctx);
                        },
                        child: const Text('Apply'))
                  ],
                )));
  }

  void _showCustomerDialog() async {
    try {
      final cp = Provider.of<CreateCustomerProvider>(context,
          listen: false);
      if (cp.customers.isEmpty && userId != null)
        await cp.fetchUser(userId!);
      if (cp.customers.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('No customers found.'),
            backgroundColor: Colors.orange));
        return;
      }
      Set<String> sel = {};
      showDialog(
          context: context,
          builder: (_) => StatefulBuilder(
              builder: (ctx, set) => AlertDialog(
                    title: const Text('Share with Customers'),
                    content: SizedBox(
                      width: double.maxFinite,
                      height: 350,
                      child: ListView.builder(
                          itemCount: cp.customers.length,
                          itemBuilder: (_, i) {
                            final c = cp.customers[i];
                            final id = c['_id'] as String;
                            return CheckboxListTile(
                                title: Text(c['name'] ?? ''),
                                subtitle:
                                    Text(c['mobile'] ?? ''),
                                value: sel.contains(id),
                                onChanged: (v) => set(() =>
                                    v!
                                        ? sel.add(id)
                                        : sel.remove(id)),
                                activeColor: Colors.deepPurple);
                          }),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel')),
                      ElevatedButton(
                          onPressed: sel.isEmpty
                              ? null
                              : () async {
                                  Navigator.pop(ctx);
                                  await _sharePosterWithCustomers(
                                      sel, cp.customers);
                                },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white),
                          child:
                              Text('Share (${sel.length})')),
                    ],
                  )));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red));
    }
  }

  Future<void> _sharePosterWithCustomers(
      Set<String> ids,
      List<Map<String, dynamic>> customers) async {
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const AlertDialog(
              content: Row(children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Preparing...')
          ])));
      final bytes = await _capturePosterBytes();
      final tmp = await getTemporaryDirectory();
      final file = File(
          '${tmp.path}/share_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(bytes);
      Navigator.of(context).pop();
      final selected =
          customers.where((c) => ids.contains(c['_id'])).toList();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ChatModule(
                  posterImagePath: file.path,
                  selectedCustomers: selected)));
    } catch (e) {
      if (Navigator.of(context).canPop())
        Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red));
    }
  }

  // ── BUILD ELEMENTS ──

  Widget _buildTextEl(TextElement el) => Positioned(
        left: el.x,
        top: el.y,
        child: GestureDetector(
          onTap: () => _selectText(el),
          onPanUpdate: (d) => _moveText(el, d.delta),
          child: Transform.rotate(
              angle: el.rotation * pi / 180,
              child: Container(
                constraints: BoxConstraints(
                    minWidth: 50,
                    maxWidth: _template!.width * 3,
                    minHeight: 20,
                    maxHeight: _template!.height * 3),
                decoration: el.isSelected
                    ? BoxDecoration(
                        border: Border.all(
                            color: Colors.blueAccent.withOpacity(0.6),
                            width: 1))
                    : null,
                child: Text(el.text,
                    style: TextStyle(
                        fontSize: el.fontSize,
                        color: el.color,
                        fontWeight: el.fontWeight,
                        fontFamily: el.fontFamily,
                        height: 1.2),
                    textAlign: el.textAlign,
                    maxLines: null,
                    overflow: TextOverflow.visible,
                    softWrap: true),
              )),
        ),
      );

  Widget _buildImageEl(ImageElement el) => Positioned(
        left: el.x,
        top: el.y,
        width: el.width,
        height: el.height,
        child: GestureDetector(
          onTap: () => _selectImage(el),
          onScaleStart: (d) {
            _baseScale = el.width;
            _initialFocalPoint = d.focalPoint;
          },
          onScaleUpdate: (d) {
            if (d.scale != 1.0) _resizeImage(el, d.scale);
            if (_initialFocalPoint != null) {
              _moveImage(
                  el, d.focalPoint - _initialFocalPoint!);
              _initialFocalPoint = d.focalPoint;
            }
          },
          onScaleEnd: (_) => _initialFocalPoint = null,
          child: Transform.rotate(
              angle: el.rotation * pi / 180,
              child: Container(
                decoration: el.isSelected
                    ? BoxDecoration(
                        border: Border.all(
                            color: Colors.blueAccent.withOpacity(0.6),
                            width: 1))
                    : null,
                child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(el.borderRadius),
                    child: el.imageUrl.startsWith('http')
                        ? Image.network(el.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                Container(
                                    color: Colors.grey.shade300))
                        : (el.imageUrl.isNotEmpty
                            ? Image.file(File(el.imageUrl),
                                fit: BoxFit.fill)
                            : Container(
                                color: Colors.grey.shade300))),
              )),
        ),
      );

  Widget _buildProfileEl() {
    if (_profileImageBytes == null || _profileImageElement == null)
      return const SizedBox.shrink();
    final el = _profileImageElement!;
    return Positioned(
      left: el.x,
      top: el.y,
      width: el.width,
      height: el.height,
      child: GestureDetector(
        onTap: () => _selectProfile(el),
        onScaleStart: (d) {
          _baseScale = el.width;
          _initialFocalPoint = d.focalPoint;
        },
        onScaleUpdate: (d) {
          if (d.scale != 1.0) _resizeProfile(el, d.scale);
          if (_initialFocalPoint != null) {
            _moveProfile(
                el, d.focalPoint - _initialFocalPoint!);
            _initialFocalPoint = d.focalPoint;
          }
        },
        onScaleEnd: (_) => _initialFocalPoint = null,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.memory(_profileImageBytes!,
                fit: BoxFit.fill)),
      ),
    );
  }

  Widget _buildLogoEl() {
    if (_logoImage == null || _logoImageElement == null)
      return const SizedBox.shrink();
    final el = _logoImageElement!;
    return Positioned(
      left: el.x,
      top: el.y,
      width: el.width,
      height: el.height,
      child: GestureDetector(
        onTap: () => _selectImage(el),
        onScaleStart: (d) {
          _baseScale = el.width;
          _initialFocalPoint = d.focalPoint;
        },
        onScaleUpdate: (d) {
          if (d.scale != 1.0) _resizeImage(el, d.scale);
          if (_initialFocalPoint != null) {
            _moveImage(
                el, d.focalPoint - _initialFocalPoint!);
            _initialFocalPoint = d.focalPoint;
          }
        },
        onScaleEnd: (_) => _initialFocalPoint = null,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.memory(_logoImage!, fit: BoxFit.cover)),
      ),
    );
  }

  // ── ELEMENT TOOLBAR ──

  String _fwLabel(FontWeight w) {
    switch (w) {
      case FontWeight.w100: return 'Thin';
      case FontWeight.w200: return 'XLight';
      case FontWeight.w300: return 'Light';
      case FontWeight.w400: return 'Regular';
      case FontWeight.w500: return 'Medium';
      case FontWeight.w600: return 'SemiBold';
      case FontWeight.w700: return 'Bold';
      case FontWeight.w800: return 'XBold';
      default: return 'Black';
    }
  }

  Widget _buildElementToolbar() {
    if (!_showToolbar || _activeTab != BottomTab.none)
      return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          if (_selectedText != null) ...[
            IconButton(
                icon: const Icon(Icons.edit,
                    color: Colors.deepPurple),
                onPressed: () => _showEditDialog(
                    title: 'Edit Text',
                    currentValue: _selectedText!.text,
                    icon: Icons.edit,
                    onSave: (v) =>
                        setState(() => _selectedText!.text = v))),
            const VerticalDivider(width: 16),
            const Text('Size:', style: TextStyle(fontSize: 12)),
            SizedBox(
                width: 130,
                child: Slider(
                    value: _selectedText!.fontSize,
                    min: 8,
                    max: 300,
                    divisions: 60,
                    label:
                        '${_selectedText!.fontSize.round()}',
                    onChanged: (v) => setState(
                        () => _selectedText!.fontSize = v))),
            Text('${_selectedText!.fontSize.round()}px',
                style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.bold)),
            const VerticalDivider(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4)),
              child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                value: _selectedText!.fontFamily,
                items: _fontFamilies
                    .toSet()
                    .map((f) => DropdownMenuItem(
                        value: f,
                        child: Text(f,
                            style: TextStyle(
                                fontFamily: f, fontSize: 13))))
                    .toList(),
                onChanged: (v) {
                  if (v != null)
                    setState(
                        () => _selectedText!.fontFamily = v);
                },
              )),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4)),
              child: DropdownButtonHideUnderline(
                  child: DropdownButton<FontWeight>(
                value: _selectedText!.fontWeight,
                items: _fontWeights
                    .map((w) => DropdownMenuItem(
                        value: w,
                        child: Text(_fwLabel(w),
                            style: TextStyle(
                                fontWeight: w, fontSize: 13))))
                    .toList(),
                onChanged: (v) {
                  if (v != null)
                    setState(
                        () => _selectedText!.fontWeight = v);
                },
              )),
            ),
            const VerticalDivider(width: 16),
            IconButton(
                icon: Icon(Icons.format_align_left,
                    color:
                        _selectedText!.textAlign == TextAlign.left
                            ? Colors.deepPurple
                            : Colors.grey),
                onPressed: () => setState(() =>
                    _selectedText!.textAlign = TextAlign.left)),
            IconButton(
                icon: Icon(Icons.format_align_center,
                    color: _selectedText!.textAlign ==
                            TextAlign.center
                        ? Colors.deepPurple
                        : Colors.grey),
                onPressed: () => setState(() =>
                    _selectedText!.textAlign =
                        TextAlign.center)),
            IconButton(
                icon: Icon(Icons.format_align_right,
                    color: _selectedText!.textAlign ==
                            TextAlign.right
                        ? Colors.deepPurple
                        : Colors.grey),
                onPressed: () => setState(() =>
                    _selectedText!.textAlign = TextAlign.right)),
            const VerticalDivider(width: 16),
            IconButton(
                icon: Icon(Icons.color_lens,
                    color: _selectedText!.color),
                onPressed: _showColorPicker),
            const VerticalDivider(width: 16),
            IconButton(
                icon: const Icon(Icons.delete,
                    color: Colors.red),
                onPressed: _deleteSelected),
          ] else if (_selectedImage != null) ...[
            const Text('Size:', style: TextStyle(fontSize: 12)),
            SizedBox(
                width: 120,
                child: Slider(
                    value: _selectedImage!.width,
                    min: 20,
                    max: 800,
                    divisions: 50,
                    label: '${_selectedImage!.width.round()}',
                    onChanged: (v) => setState(() {
                          final ar = _selectedImage!.width /
                              _selectedImage!.height;
                          _selectedImage!.width = v;
                          _selectedImage!.height = v / ar;
                        }))),
            const VerticalDivider(width: 16),
            const Text('Corner:', style: TextStyle(fontSize: 12)),
            SizedBox(
                width: 100,
                child: Slider(
                    value: _selectedImage!.borderRadius,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    label:
                        '${_selectedImage!.borderRadius.round()}',
                    onChanged: (v) => setState(
                        () => _selectedImage!.borderRadius = v))),
            const VerticalDivider(width: 16),
            IconButton(
                icon: const Icon(Icons.delete,
                    color: Colors.red),
                onPressed: _deleteSelected),
          ] else if (_selectedProfile != null) ...[
            const Text('Size:', style: TextStyle(fontSize: 12)),
            SizedBox(
                width: 120,
                child: Slider(
                    value: _selectedProfile!.width,
                    min: 50,
                    max: 600,
                    divisions: 50,
                    label:
                        '${_selectedProfile!.width.round()}',
                    onChanged: (v) => setState(() {
                          _selectedProfile!.width = v;
                          _selectedProfile!.height = v;
                        }))),
            const VerticalDivider(width: 16),
            IconButton(
                icon: const Icon(Icons.delete,
                    color: Colors.red),
                onPressed: _deleteSelected),
          ],
        ]),
      ),
    );
  }

  // ── BOTTOM PANEL ──

  Widget _buildActivePanel() {
    switch (_activeTab) {
      case BottomTab.text:
        return TextToolsPanel(
            onAddText: _addText,
            onAddLogo: _pickLogo,
            onAddImage: _pickAdditionalImage);
      case BottomTab.frames:
        return FramesPanel(
            selectedFrame: _selectedFrame,
            onFrameSelected: (f) =>
                setState(() => _selectedFrame = f));
      case BottomTab.effects:
        return EffectsPanel(
            currentEffect: _currentEffect,
            onEffectSelected: (e) =>
                setState(() => _currentEffect = e));
      case BottomTab.animation:
        return AnimationPanel(
            currentAnimation: _currentAnimation,
            onAnimationSelected: (a) =>
                setState(() => _currentAnimation = a));
      case BottomTab.design:
        return DesignPanel(
            currentDesign: _selectedBarDesign,
            onDesignSelected: (d) =>
                setState(() => _selectedBarDesign = d));
      default:
        return const SizedBox.shrink();
    }
  }

  // ── BOTTOM NAV ──

  Widget _buildBottomNav() {
    final items = [
      (BottomTab.text, Icons.text_fields, 'Text'),
      (BottomTab.frames, Icons.crop_square, 'Frames'),
      (BottomTab.effects, Icons.auto_awesome, 'Effects'),
      (BottomTab.animation, Icons.animation, 'Animation'),
      (BottomTab.design, Icons.style, 'Design'),
    ];
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, -2))
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: items.map((item) {
            final (tab, icon, label) = item;
            final isActive = _activeTab == tab;
            return Expanded(
              child: GestureDetector(
                onTap: () => _setTab(tab),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            color: isActive
                                ? const Color(0xFFFFE500)
                                : Colors.transparent,
                            width: 2.5)),
                  ),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon,
                            color: isActive
                                ? const Color(0xFFFFE500)
                                : Colors.white54,
                            size: 22),
                        const SizedBox(height: 3),
                        Text(label,
                            style: TextStyle(
                                color: isActive
                                    ? const Color(0xFFFFE500)
                                    : Colors.white54,
                                fontSize: 10,
                                fontWeight: isActive
                                    ? FontWeight.bold
                                    : FontWeight.normal)),
                      ]),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════
  //  POSTER CANVAS BUILDER
  //
  //  KEY ARCHITECTURE CHANGE:
  //  The RepaintBoundary is placed INSIDE AnimatedPosterWrapper
  //  so when we call toImage() it captures the poster content
  //  AT THE CURRENT ANIMATION FRAME POSITION including:
  //    • Particle effects (snow, sparkle, stars, confetti)
  //    • Frame border overlay
  //    • Info bar design
  //    • All text/image/logo elements
  //
  //  The outer transform (zoom/pan) is NOT included — we only
  //  want the raw poster at full resolution.
  // ══════════════════════════════════════════════════════
  Widget _buildPosterCanvas({bool interactive = true}) {
    if (_template == null) return const SizedBox.shrink();

    // Core poster content (no animation wrapper here — animation
    // goes OUTSIDE the RepaintBoundary in editor view but the
    // capture key is on the inner content for full-res export)
    final posterContent = Container(
      width: _template!.width,
      height: _template!.height,
      decoration: BoxDecoration(
        color: _template!.backgroundColor,
        boxShadow: interactive
            ? [
                BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 14,
                    offset: const Offset(0, 7))
              ]
            : [],
      ),
      child: Stack(clipBehavior: Clip.hardEdge, children: [
        // Background
        if (_template!.backgroundImage != null)
          Positioned.fill(
              child: Image.network(_template!.backgroundImage!,
                  fit: BoxFit.fill,
                  errorBuilder: (_, __, ___) =>
                      Container(color: _template!.backgroundColor))),

        // Text elements
        ..._template!.textElements.map(_buildTextEl),
        // Image elements
        ..._template!.imageElements.map(_buildImageEl),
        // Profile image
        _buildProfileEl(),
        // Logo
        _buildLogoEl(),

        // ── EFFECTS overlay (particles rendered live) ──
        if (_currentEffect != PosterEffectType.none)
          Positioned.fill(
              child: PosterEffectOverlay(
                  effectType: _currentEffect,
                  width: _template!.width,
                  height: _template!.height)),

        // ── FRAME border overlay ──
        if (_selectedFrame != null && !_selectedFrame!.isDefault)
          Positioned.fill(
              child: IgnorePointer(
                  child: CustomPaint(
                      painter:
                          FrameBorderPainter(_selectedFrame!)))),

        // ── Business info bar ──
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: interactive
              ? GestureDetector(
                  onTap: () {
                    final nameEl = _template?.textElements
                        .firstWhere((e) => e.id == 'name',
                            orElse: () => TextElement(
                                id: 'name',
                                text: 'Business Name',
                                x: 0,
                                y: 0));
                    final mobileEl = _template?.textElements
                        .firstWhere((e) => e.id == 'mobile',
                            orElse: () => TextElement(
                                id: 'mobile',
                                text: '',
                                x: 0,
                                y: 0));
                    _showBottomInfoSheet(nameEl, mobileEl);
                  },
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 450),
                    transitionBuilder: (child, anim) =>
                        FadeTransition(
                      opacity: anim,
                      child: SlideTransition(
                        position: Tween<Offset>(
                                begin: const Offset(0, 0.3),
                                end: Offset.zero)
                            .animate(CurvedAnimation(
                                parent: anim,
                                curve: Curves.easeOutCubic)),
                        child: child,
                      ),
                    ),
                    child: KeyedSubtree(
                        key: ValueKey(_selectedBarDesign.id),
                        child: _buildInfoBar()),
                  ),
                )
              : _buildInfoBar(),
        ),
      ]),
    );

    if (!interactive) {
      // Preview mode: wrap with animation so preview shows live animation
      return AnimatedPosterWrapper(
        animation: _currentAnimation,
        child: posterContent,
      );
    }

    // Editor mode: RepaintBoundary wraps the posterContent directly
    // (not the AnimatedPosterWrapper) so captures are full-res.
    // The animation wrapper is applied OUTSIDE for visual effect only.
    return posterContent;
  }

  // ── MAIN BUILD ──

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A1B9A),
        foregroundColor: Colors.white,
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios)),
        title: Text(_template?.name ?? 'Poster Editor',
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600)),
        actions: [
          if (_template != null)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: TextButton.icon(
                onPressed: _openPreview,
                icon: const Icon(Icons.visibility_rounded,
                    color: Color(0xFFFFE500), size: 18),
                label: const Text('Preview',
                    style: TextStyle(
                        color: Color(0xFFFFE500),
                        fontSize: 13,
                        fontWeight: FontWeight.bold)),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white10,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
          if (_selectedText != null ||
              _selectedImage != null ||
              _selectedProfile != null)
            IconButton(
                icon: const Icon(Icons.delete_outline,
                    color: Colors.redAccent),
                onPressed: _deleteSelected),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (_) => [
              const PopupMenuItem(
                  value: 'save',
                  child: Row(children: [
                    Icon(Icons.save_alt),
                    SizedBox(width: 8),
                    Text('Save to Gallery')
                  ])),
              const PopupMenuItem(
                  value: 'share',
                  child: Row(children: [
                    Icon(Icons.share),
                    SizedBox(width: 8),
                    Text('Share')
                  ])),
              const PopupMenuItem(
                  value: 'customers',
                  child: Row(children: [
                    Icon(Icons.people),
                    SizedBox(width: 8),
                    Text('Share to Customers')
                  ])),
            ],
            onSelected: (v) {
              if (v == 'save') _savePoster();
              if (v == 'share') _sharePoster();
              if (v == 'customers') _showCustomerDialog();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading poster...')
              ]))
          : _errorMessage != null
              ? Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    const Icon(Icons.error,
                        size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(_errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                        onPressed: _loadPosterFromApi,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white)),
                  ]))
              : _template == null
                  ? const Center(child: Text('No poster data'))
                  : Column(children: [
                      _buildElementToolbar(),
                      Expanded(
                        child: GestureDetector(
                          onScaleStart: (d) {
                            _focusPoint = d.focalPoint;
                            _previousScale = _currentScale;
                            _startOffset = _currentOffset;
                          },
                          onScaleUpdate: (d) => setState(() {
                            if (d.scale != 1.0)
                              _currentScale = (_previousScale *
                                      d.scale)
                                  .clamp(0.5, 3.0);
                            _currentOffset = _startOffset +
                                (d.focalPoint - _focusPoint);
                          }),
                          onScaleEnd: (_) {
                            _previousScale = _currentScale;
                            _startOffset = _currentOffset;
                          },
                          onTap: () {
                            _deselectAll();
                            setState(
                                () => _activeTab = BottomTab.none);
                          },
                          child: Transform(
                            transform: Matrix4.identity()
                              ..translate(_currentOffset.dx,
                                  _currentOffset.dy)
                              ..scale(_currentScale),
                            child: Center(
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context)
                                                .size
                                                .width *
                                            0.95,
                                    maxHeight:
                                        MediaQuery.of(context)
                                                .size
                                                .height *
                                            0.72),
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  // ── ANIMATION wraps the RepaintBoundary ──
                                  // This means the visual animation is shown in
                                  // editor view. The RepaintBoundary inside
                                  // captures the un-transformed content at full
                                  // poster resolution (no FittedBox scaling).
                                  child: AnimatedPosterWrapper(
                                    animation: _currentAnimation,
                                    child: RepaintBoundary(
                                      key: _canvasKey,
                                      child: _buildPosterCanvas(
                                          interactive: true),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      AnimatedSwitcher(
                        duration:
                            const Duration(milliseconds: 250),
                        transitionBuilder: (child, anim) =>
                            SlideTransition(
                          position: Tween<Offset>(
                                  begin: const Offset(0, 1),
                                  end: Offset.zero)
                              .animate(CurvedAnimation(
                                  parent: anim,
                                  curve: Curves.easeOut)),
                          child: child,
                        ),
                        child: _activeTab != BottomTab.none
                            ? KeyedSubtree(
                                key: ValueKey(_activeTab),
                                child: _buildActivePanel())
                            : const SizedBox.shrink(
                                key: ValueKey('none')),
                      ),
                      _buildBottomNav(),
                    ]),
    );
  }

  // ── Build info bar ──
  Widget _buildInfoBar() {
    final d = _selectedBarDesign;
    final businessName = _template?.textElements
            .firstWhere((e) => e.id == 'name',
                orElse: () => TextElement(
                    id: 'name', text: 'Business Name', x: 0, y: 0))
            .text ??
        'Business Name';
    final phone = phoneNumber ??
        _template?.textElements
            .firstWhere((e) => e.id == 'mobile',
                orElse: () => TextElement(
                    id: 'mobile', text: 'Not Set', x: 0, y: 0))
            .text ??
        'Not Set';
    final tc = d.primaryColor;
    final sc = d.secondaryColor;
    final ibg = d.iconBgColor;

    BoxDecoration bgDecor = BoxDecoration(
      gradient: d.gradient,
      color: d.gradient == null ? d.solidColor : null,
      borderRadius: d.borderRadiusTop > 0
          ? BorderRadius.vertical(
              top: Radius.circular(d.borderRadiusTop))
          : null,
      border: d.showTopBorder
          ? Border(
              top: BorderSide(color: d.topBorderColor, width: 1.5))
          : null,
    );

    switch (d.layoutStyle) {
      case BarLayoutStyle.stacked:
        return Container(
          decoration: bgDecor,
          padding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 12),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Row(children: [
              Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: ibg,
                      borderRadius: BorderRadius.circular(8)),
                  child: Icon(Icons.business, color: tc, size: 18)),
              const SizedBox(width: 12),
              Expanded(
                  child: Text(businessName,
                      style: TextStyle(
                          fontSize: _businessNameFontSize,
                          fontWeight: FontWeight.bold,
                          color: tc),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis)),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: ibg,
                      borderRadius: BorderRadius.circular(8)),
                  child: Icon(Icons.phone, color: sc, size: 18)),
              const SizedBox(width: 12),
              Expanded(
                  child: Text(phone,
                      style: TextStyle(
                          fontSize: _phoneNumberFontSize,
                          fontWeight: FontWeight.w600,
                          color: sc),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis)),
            ]),
          ]),
        );

      case BarLayoutStyle.badgeChip:
        return Container(
          decoration: bgDecor,
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                    color: ibg,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                        color: tc.withOpacity(0.6), width: 1.5)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.business, color: tc, size: 16),
                  const SizedBox(width: 8),
                  Text(businessName,
                      style: TextStyle(
                          fontSize: _businessNameFontSize
                              .clamp(10, 16),
                          fontWeight: FontWeight.bold,
                          color: tc),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ]),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                    color: ibg,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                        color: tc.withOpacity(0.6), width: 1.5)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.phone, color: tc, size: 16),
                  const SizedBox(width: 8),
                  Text(phone,
                      style: TextStyle(
                          fontSize: _phoneNumberFontSize
                              .clamp(10, 16),
                          fontWeight: FontWeight.bold,
                          color: tc),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ]),
              ),
            ],
          ),
        );

      case BarLayoutStyle.centered:
        return Container(
          decoration: bgDecor,
          padding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 14),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(businessName,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: _businessNameFontSize,
                    fontWeight: FontWeight.bold,
                    color: tc,
                    letterSpacing: 0.5),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(phone,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: _phoneNumberFontSize,
                    fontWeight: FontWeight.w500,
                    color: sc),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ]),
        );

      case BarLayoutStyle.cardSplit:
        return Container(
          color: d.solidColor ?? Colors.black.withOpacity(0.85),
          padding: const EdgeInsets.symmetric(
              horizontal: 12, vertical: 10),
          child: Row(children: [
            Expanded(
                child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: ibg.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: tc.withOpacity(0.2), width: 1),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3))
                  ]),
              child: Row(children: [
                Icon(Icons.business, color: tc, size: 18),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(businessName,
                        style: TextStyle(
                            fontSize: _businessNameFontSize
                                .clamp(10, 16),
                            fontWeight: FontWeight.bold,
                            color: tc),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis)),
              ]),
            )),
            const SizedBox(width: 10),
            Expanded(
                child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: ibg.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: tc.withOpacity(0.2), width: 1),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3))
                  ]),
              child: Row(children: [
                Icon(Icons.phone, color: tc, size: 18),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(phone,
                        style: TextStyle(
                            fontSize: _phoneNumberFontSize
                                .clamp(10, 16),
                            fontWeight: FontWeight.bold,
                            color: tc),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis)),
              ]),
            )),
          ]),
        );

      case BarLayoutStyle.minimal:
        return Container(
          color: d.solidColor,
          padding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 10),
          child: Row(children: [
            Expanded(
                child: Text(businessName,
                    style: TextStyle(
                        fontSize: _businessNameFontSize,
                        fontWeight: FontWeight.w600,
                        color: tc,
                        letterSpacing: 0.3),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis)),
            Container(
                width: 1,
                height: 20,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                color: d.dividerColor),
            Expanded(
                child: Text(phone,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: _phoneNumberFontSize,
                        fontWeight: FontWeight.w400,
                        color: sc),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis)),
          ]),
        );

      case BarLayoutStyle.ribbon:
        return Container(
          decoration: bgDecor,
          padding: const EdgeInsets.symmetric(
              horizontal: 0, vertical: 14),
          child: Row(children: [
            Container(
                width: 5,
                color: tc.withOpacity(0.8),
                margin: const EdgeInsets.only(right: 14)),
            Expanded(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(businessName,
                    style: TextStyle(
                        fontSize: _businessNameFontSize,
                        fontWeight: FontWeight.bold,
                        color: tc),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(children: [
                  Icon(Icons.phone, color: sc, size: 13),
                  const SizedBox(width: 6),
                  Expanded(
                      child: Text(phone,
                          style: TextStyle(
                              fontSize: _phoneNumberFontSize
                                  .clamp(10, 14),
                              color: sc),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis)),
                ]),
              ],
            )),
            const SizedBox(width: 16),
          ]),
        );

      case BarLayoutStyle.neon:
        return Container(
          decoration: BoxDecoration(
              color: d.solidColor,
              border: Border(
                  top: BorderSide(color: tc, width: 1.5)),
              boxShadow: [
                BoxShadow(
                    color: tc.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 0,
                    offset: const Offset(0, -3))
              ]),
          padding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 13),
          child: Row(children: [
            Expanded(
                child: Row(children: [
              Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: tc, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                            color: tc.withOpacity(0.5),
                            blurRadius: 8)
                      ]),
                  child: Icon(Icons.business,
                      color: tc, size: 16)),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(businessName,
                      style: TextStyle(
                          fontSize: _businessNameFontSize,
                          fontWeight: FontWeight.bold,
                          color: tc,
                          shadows: [
                            Shadow(
                                color: tc.withOpacity(0.8),
                                blurRadius: 8)
                          ]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis)),
            ])),
            Container(
                width: 1,
                height: 36,
                margin: const EdgeInsets.symmetric(horizontal: 14),
                color: d.dividerColor),
            Expanded(
                child: Row(children: [
              Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: tc, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                            color: tc.withOpacity(0.5),
                            blurRadius: 8)
                      ]),
                  child: Icon(Icons.phone,
                      color: tc, size: 16)),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(phone,
                      style: TextStyle(
                          fontSize: _phoneNumberFontSize,
                          fontWeight: FontWeight.bold,
                          color: tc,
                          shadows: [
                            Shadow(
                                color: tc.withOpacity(0.8),
                                blurRadius: 8)
                          ]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis)),
            ])),
          ]),
        );

      case BarLayoutStyle.wave:
        return ClipPath(
          clipper: _WaveInfoBarClipper(),
          child: Container(
            decoration: BoxDecoration(
                gradient: d.gradient,
                color:
                    d.gradient == null ? d.solidColor : null),
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 14),
            child: Row(children: [
              Expanded(
                  child: Row(children: [
                Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        color: ibg,
                        borderRadius:
                            BorderRadius.circular(8)),
                    child: Icon(Icons.business,
                        color: tc, size: 18)),
                const SizedBox(width: 12),
                Expanded(
                    child: Text(businessName,
                        style: TextStyle(
                            fontSize: _businessNameFontSize,
                            fontWeight: FontWeight.bold,
                            color: tc),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis)),
              ])),
              Container(
                  width: 1,
                  height: 36,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 14),
                  color: d.dividerColor),
              Expanded(
                  child: Row(children: [
                Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        color: ibg,
                        borderRadius:
                            BorderRadius.circular(8)),
                    child: Icon(Icons.phone,
                        color: sc, size: 18)),
                const SizedBox(width: 12),
                Expanded(
                    child: Text(phone,
                        style: TextStyle(
                            fontSize: _phoneNumberFontSize,
                            fontWeight: FontWeight.bold,
                            color: sc),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis)),
              ])),
            ]),
          ),
        );

      case BarLayoutStyle.magazine:
        return Container(
          decoration: bgDecor,
          padding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 12),
          child: Row(children: [
            Expanded(
                flex: 3,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(businessName,
                        style: TextStyle(
                            fontSize:
                                _businessNameFontSize + 2,
                            fontWeight: FontWeight.w900,
                            color: tc,
                            letterSpacing: 0.5),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 3),
                    Text('BUSINESS',
                        style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                            color: tc.withOpacity(0.5),
                            letterSpacing: 1.5)),
                  ],
                )),
            Container(
                width: 1,
                height: 40,
                margin: const EdgeInsets.symmetric(
                    horizontal: 16),
                color: d.dividerColor),
            Expanded(
                flex: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CONTACT',
                        style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                            color: sc.withOpacity(0.5),
                            letterSpacing: 1.5)),
                    const SizedBox(height: 3),
                    Row(children: [
                      Icon(Icons.phone, color: sc, size: 13),
                      const SizedBox(width: 5),
                      Expanded(
                          child: Text(phone,
                              style: TextStyle(
                                  fontSize:
                                      _phoneNumberFontSize
                                          .clamp(10, 14),
                                  fontWeight: FontWeight.bold,
                                  color: sc),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis)),
                    ]),
                  ],
                )),
          ]),
        );

      case BarLayoutStyle.classic:
      default:
        return Container(
          decoration: bgDecor,
          padding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 15),
          child: Row(children: [
            Expanded(
                child: Row(children: [
              Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: ibg,
                      borderRadius:
                          BorderRadius.circular(8)),
                  child: Icon(Icons.business,
                      color: tc, size: 20)),
              const SizedBox(width: 12),
              Expanded(
                  child: Text(businessName,
                      style: TextStyle(
                          fontSize: _businessNameFontSize,
                          fontWeight: FontWeight.bold,
                          color: tc),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis)),
            ])),
            Container(
                height: 50,
                width: 1,
                margin: const EdgeInsets.symmetric(
                    horizontal: 15),
                color: d.dividerColor),
            Expanded(
                child: Row(children: [
              Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: ibg,
                      borderRadius:
                          BorderRadius.circular(8)),
                  child: Icon(Icons.phone,
                      color: tc, size: 20)),
              const SizedBox(width: 12),
              Expanded(
                  child: Text(phone,
                      style: TextStyle(
                          fontSize: _phoneNumberFontSize,
                          fontWeight: FontWeight.bold,
                          color: tc),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis)),
            ])),
          ]),
        );
    }
  }

  void _showBottomInfoSheet(
      TextElement? nameEl, TextElement? mobileEl) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
          builder: (ctx, set) => Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20))),
                padding:
                    const EdgeInsets.fromLTRB(16, 16, 16, 20),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius:
                                  BorderRadius.circular(2))),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: CircleAvatar(
                            backgroundColor:
                                Colors.purple.shade100,
                            child: Icon(Icons.business,
                                color: Colors.purple.shade700)),
                        title: const Text('Business Name',
                            style: TextStyle(
                                fontWeight: FontWeight.w600)),
                        subtitle:
                            Text(nameEl?.text ?? 'Tap to edit'),
                        trailing:
                            const Icon(Icons.edit, size: 18),
                        onTap: () {
                          Navigator.pop(ctx);
                          if (nameEl != null)
                            _showEditDialog(
                                title: 'Business Name',
                                currentValue: nameEl.text,
                                icon: Icons.business,
                                onSave: (v) async {
                                  await _saveBusinessName(v);
                                  setState(
                                      () => nameEl.text = v);
                                });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16),
                        child: Row(children: [
                          const Text('Name Size:',
                              style: TextStyle(fontSize: 12)),
                          Expanded(
                              child: Slider(
                                  value: _businessNameFontSize,
                                  min: 10,
                                  max: 40,
                                  divisions: 30,
                                  activeColor: Colors.purple,
                                  onChanged: (v) {
                                    setState(() =>
                                        _businessNameFontSize =
                                            v);
                                    set(() {});
                                  })),
                          Text(
                              '${_businessNameFontSize.round()}',
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        ]),
                      ),
                      const Divider(),
                      ListTile(
                        leading: CircleAvatar(
                            backgroundColor:
                                Colors.blue.shade100,
                            child: Icon(Icons.phone,
                                color: Colors.blue.shade700)),
                        title: const Text('Phone Number',
                            style: TextStyle(
                                fontWeight: FontWeight.w600)),
                        subtitle: Text(phoneNumber ??
                            mobileEl?.text ??
                            'Tap to edit'),
                        trailing:
                            const Icon(Icons.edit, size: 18),
                        onTap: () {
                          Navigator.pop(ctx);
                          if (mobileEl != null)
                            _showEditDialog(
                                title: 'Phone Number',
                                currentValue: mobileEl.text,
                                icon: Icons.phone,
                                keyboardType:
                                    TextInputType.phone,
                                onSave: (v) {
                                  setState(() {
                                    mobileEl.text = v;
                                    phoneNumber = v;
                                  });
                                });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16),
                        child: Row(children: [
                          const Text('Phone Size:',
                              style: TextStyle(fontSize: 12)),
                          Expanded(
                              child: Slider(
                                  value: _phoneNumberFontSize,
                                  min: 10,
                                  max: 40,
                                  divisions: 30,
                                  activeColor: Colors.blue,
                                  onChanged: (v) {
                                    setState(() =>
                                        _phoneNumberFontSize =
                                            v);
                                    set(() {});
                                  })),
                          Text(
                              '${_phoneNumberFontSize.round()}',
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        ]),
                      ),
                    ]),
              )),
    );
  }
}

// ── Wave clipper for info bar ──
class _WaveInfoBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 16);
    path.quadraticBezierTo(
        size.width * 0.15, 4, size.width * 0.35, 12);
    path.quadraticBezierTo(
        size.width * 0.55, 22, size.width * 0.75, 10);
    path.quadraticBezierTo(
        size.width * 0.9, 2, size.width, 8);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_WaveInfoBarClipper old) => false;
}