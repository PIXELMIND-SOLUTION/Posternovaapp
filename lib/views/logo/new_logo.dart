// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:gal/gal.dart';
// import 'package:http/http.dart' as http;

// // ─────────────────────────────────────────────
// //  DATA MODELS
// // ─────────────────────────────────────────────

// class LogoPlaceholder {
//   final String id;
//   final String type;
//   final String label;
//   final String defaultValue;
//   final Offset position;
//   final Size size;
//   final TextStyle style;
//   final bool required;
//   final int maxLength;
//   final TextAlign textAlign;

//   LogoPlaceholder({
//     required this.id,
//     required this.type,
//     required this.label,
//     required this.defaultValue,
//     required this.position,
//     required this.size,
//     required this.style,
//     required this.required,
//     required this.maxLength,
//     required this.textAlign,
//   });

//   factory LogoPlaceholder.fromJson(Map<String, dynamic> json) {
//     return LogoPlaceholder(
//       id: json['id'],
//       type: json['type'],
//       label: json['label'],
//       defaultValue: json['defaultValue'],
//       position: Offset(
//         json['position']['x'].toDouble(),
//         json['position']['y'].toDouble(),
//       ),
//       size: Size(
//         json['position']['width'].toDouble(),
//         json['position']['height'].toDouble(),
//       ),
//       style: _parseTextStyle(json['style']),
//       required: json['required'] ?? false,
//       maxLength: json['maxLength'] ?? 100,
//       textAlign: _parseTextAlign(json['style']['textAlign'] ?? 'center'),
//     );
//   }

//   static TextStyle _parseTextStyle(Map<String, dynamic> style) {
//     return TextStyle(
//       fontSize: (style['fontSize'] ?? 24).toDouble(),
//       fontFamily: style['fontFamily'] ?? 'Roboto',
//       fontWeight: style['fontWeight'] == 'bold'
//           ? FontWeight.bold
//           : FontWeight.normal,
//       color: Color(
//         int.parse(style['color'].replaceFirst('#', 'FF'), radix: 16),
//       ),
//       letterSpacing: (style['letterSpacing'] ?? 0).toDouble(),
//       shadows: style['textShadow'] != null
//           ? [
//               Shadow(
//                 color: Colors.black.withOpacity(0.3),
//                 offset: const Offset(2, 2),
//                 blurRadius: 4,
//               ),
//             ]
//           : null,
//     );
//   }

//   static TextAlign _parseTextAlign(String align) {
//     switch (align.toLowerCase()) {
//       case 'left':
//         return TextAlign.left;
//       case 'right':
//         return TextAlign.right;
//       case 'center':
//       default:
//         return TextAlign.center;
//     }
//   }
// }

// class LogoData {
//   final String id;
//   final String name;
//   final String category;
//   final String imageUrl;
//   final String imageType;
//   final List<LogoPlaceholder> placeholders;
//   final bool isPremium;
//   final List<String> tags;

//   LogoData({
//     required this.id,
//     required this.name,
//     required this.category,
//     required this.imageUrl,
//     required this.imageType,
//     required this.placeholders,
//     required this.isPremium,
//     required this.tags,
//   });

//   factory LogoData.fromJson(Map<String, dynamic> json) {
//     final logo = json['logo'];
//     return LogoData(
//       id: logo['_id'],
//       name: logo['name'],
//       category: logo['category'],
//       imageUrl: logo['image']['url'],
//       imageType: logo['image']['type'],
//       placeholders: (logo['placeholders'] as List)
//           .map((p) => LogoPlaceholder.fromJson(p))
//           .toList(),
//       isPremium: logo['metadata']['isPremium'] ?? false,
//       tags: List<String>.from(logo['metadata']['tags'] ?? []),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// //  EDITABLE LAYER MODEL (text + stickers)
// // ─────────────────────────────────────────────

// enum LayerType { text, sticker }

// class EditableLayer {
//   final String id;
//   LayerType type;
//   String content; // text string or emoji
//   Offset position;
//   double fontSize;
//   Color color;
//   FontWeight fontWeight;
//   bool isSelected;

//   EditableLayer({
//     required this.id,
//     required this.type,
//     required this.content,
//     required this.position,
//     this.fontSize = 24,
//     this.color = Colors.white,
//     this.fontWeight = FontWeight.bold,
//     this.isSelected = false,
//   });
// }

// // ─────────────────────────────────────────────
// //  MAIN LOGO EDITOR SCREEN
// // ─────────────────────────────────────────────

// class LogoEditorScreen extends StatefulWidget {
//   final LogoData logoData;
//   const LogoEditorScreen({super.key, required this.logoData});

//   @override
//   State<LogoEditorScreen> createState() => _LogoEditorScreenState();
// }

// class _LogoEditorScreenState extends State<LogoEditorScreen> {
//   // ── Placeholder text values (from API) ──────────────────────
//   final Map<String, String> _textValues = {};

//   // ── Draggable layers (user-added text + stickers) ────────────
//   final List<EditableLayer> _layers = [];
//   String? _selectedLayerId;

//   // ── Canvas drag offsets per placeholder id ───────────────────
//   final Map<String, Offset> _placeholderOffsets = {};

//   // ── UI state ────────────────────────────────────────────────
//   final GlobalKey _canvasKey = GlobalKey();
//   bool _isSaving = false;
//   bool _isCapturing = false; // true during gallery save — hides selection UI
//   bool _isLoading = true;
//   ui.Image? _loadedImage;

//   // Canvas size (fixed logical size)
//   static const double _canvasSize = 320.0;

//   // Bottom toolbar tab
//   int _activeTab = 0; // 0=Text, 1=Stickers, 2=Color

//   // Sticker options
//   static const List<String> _stickers = [
//     '⭐',
//     '🔥',
//     '💎',
//     '🎯',
//     '🏆',
//     '✨',
//     '🎨',
//     '🚀',
//     '💡',
//     '🎵',
//     '❤️',
//     '👑',
//     '🌟',
//     '💪',
//     '🎉',
//     '🌈',
//     '🦋',
//     '🌸',
//     '🍀',
//     '⚡',
//     '🎸',
//     '🎤',
//     '📸',
//     '🎬',
//   ];

//   // Color palette
//   static const List<Color> _colorPalette = [
//     Colors.white,
//     Colors.black,
//     Color(0xFFFF6B6B),
//     Color(0xFFFFD93D),
//     Color(0xFF6BCB77),
//     Color(0xFF4D96FF),
//     Color(0xFFFF6FC8),
//     Color(0xFFFF9A3C),
//     Color(0xFF845EC2),
//     Color(0xFF00C9A7),
//     Color(0xFFF9F871),
//     Color(0xFFFF8066),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _initializeTextValues();
//     _loadLogoImage();
//   }

//   void _initializeTextValues() {
//     for (var placeholder in widget.logoData.placeholders) {
//       if (placeholder.type == 'text') {
//         _textValues[placeholder.id] = placeholder.defaultValue;
//         _placeholderOffsets[placeholder.id] = placeholder.position;
//       }
//     }
//   }

//   Future<void> _loadLogoImage() async {
//     try {
//       final response = await http.get(Uri.parse(widget.logoData.imageUrl));
//       if (response.statusCode == 200) {
//         final Uint8List bytes = response.bodyBytes;
//         final ui.Codec codec = await ui.instantiateImageCodec(bytes);
//         final ui.FrameInfo frame = await codec.getNextFrame();
//         setState(() {
//           _loadedImage = frame.image;
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() => _isLoading = false);
//       debugPrint('Error loading image: $e');
//     }
//   }

//   Future<void> _saveLogoToGallery() async {
//     setState(() => _isSaving = true);

//     try {
//       // Deselect all and set saving mode before capture
//       setState(() {
//         _selectedLayerId = null;
//         _isCapturing = true;
//       });
//       await Future.delayed(const Duration(milliseconds: 150));

//       final RenderRepaintBoundary? boundary =
//           _canvasKey.currentContext?.findRenderObject()
//               as RenderRepaintBoundary?;
//       if (boundary == null) return;

//       final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
//       final ByteData? byteData = await image.toByteData(
//         format: ui.ImageByteFormat.png,
//       );
//       final bytes = byteData?.buffer.asUint8List();

//       if (bytes != null) {
//         await Gal.putImageBytes(
//           bytes,
//           name: 'Logo_${DateTime.now().millisecondsSinceEpoch}',
//           album: 'Logo Maker',
//         );
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Row(
//                 children: [
//                   Icon(Icons.check_circle, color: Colors.white),
//                   SizedBox(width: 12),
//                   Text('Logo saved to gallery!'),
//                 ],
//               ),
//               backgroundColor: Color(0xFF6C63FF),
//               behavior: SnackBarBehavior.floating,
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to save: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } finally {
//       setState(() {
//         _isSaving = false;
//         _isCapturing = false;
//       });
//     }
//   }

//   // ── Layer management ─────────────────────────────────────────

//   void _addTextLayer() {
//     final layer = EditableLayer(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       type: LayerType.text,
//       content: 'New Text',
//       position: const Offset(60, 130),
//       fontSize: 22,
//       color: Colors.white,
//       fontWeight: FontWeight.bold,
//     );
//     setState(() {
//       _layers.add(layer);
//       _selectedLayerId = layer.id;
//     });
//     _openLayerTextEditor(layer);
//   }

//   void _addSticker(String emoji) {
//     final layer = EditableLayer(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       type: LayerType.sticker,
//       content: emoji,
//       position: const Offset(120, 100),
//       fontSize: 48,
//     );
//     setState(() {
//       _layers.add(layer);
//       _selectedLayerId = layer.id;
//     });
//   }

//   void _deleteSelectedLayer() {
//     if (_selectedLayerId == null) return;
//     setState(() {
//       _layers.removeWhere((l) => l.id == _selectedLayerId);
//       _selectedLayerId = null;
//     });
//   }

//   EditableLayer? get _selectedLayer {
//     try {
//       return _layers.firstWhere((l) => l.id == _selectedLayerId);
//     } catch (_) {
//       return null;
//     }
//   }

//   // ── Text editor ──────────────────────────────────────────────

//   void _openPlaceholderEditor(LogoPlaceholder placeholder) {
//     final controller = TextEditingController(text: _textValues[placeholder.id]);
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => _TextEditorBottomSheet(
//         label: placeholder.label,
//         controller: controller,
//         currentText: _textValues[placeholder.id] ?? '',
//         maxLength: placeholder.maxLength,
//         isRequired: placeholder.required,
//         onSave: (newText) {
//           setState(() => _textValues[placeholder.id] = newText);
//         },
//       ),
//     );
//   }

//   void _openLayerTextEditor(EditableLayer layer) {
//     final controller = TextEditingController(text: layer.content);
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => _TextEditorBottomSheet(
//         label: 'Edit Text',
//         controller: controller,
//         currentText: layer.content,
//         maxLength: 60,
//         isRequired: false,
//         onSave: (newText) {
//           setState(() => layer.content = newText);
//         },
//       ),
//     );
//   }

//   // ── Build ────────────────────────────────────────────────────

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF0F2F8),
//       appBar: _buildAppBar(),
//       body: _isLoading
//           ? const Center(
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
//               ),
//             )
//           : Column(
//               children: [
//                 Expanded(child: _buildCanvas()),
//                 _buildBottomPanel(),
//               ],
//             ),
//     );
//   }

//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 0,
//       leading: IconButton(
//         icon: Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: Colors.grey[100],
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: const Icon(
//             Icons.arrow_back_ios_new,
//             size: 18,
//             color: Color(0xFF2D3142),
//           ),
//         ),
//         onPressed: () => Navigator.pop(context),
//       ),
//       title: Text(
//         widget.logoData.name,
//         style: const TextStyle(
//           color: Color(0xFF2D3142),
//           fontWeight: FontWeight.bold,
//           fontSize: 18,
//         ),
//       ),
//       centerTitle: true,
//       actions: [
//         if (_selectedLayerId != null)
//           IconButton(
//             icon: const Icon(Icons.delete_outline, color: Colors.red),
//             onPressed: _deleteSelectedLayer,
//             tooltip: 'Delete selected',
//           ),
//         if (widget.logoData.isPremium)
//           Container(
//             margin: const EdgeInsets.only(right: 8),
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
//               ),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: const Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.stars, size: 14, color: Colors.white),
//                 SizedBox(width: 4),
//                 Text(
//                   'PREMIUM',
//                   style: TextStyle(
//                     fontSize: 10,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         IconButton(
//           icon: _isSaving
//               ? const SizedBox(
//                   width: 20,
//                   height: 20,
//                   child: CircularProgressIndicator(strokeWidth: 2),
//                 )
//               : Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF6C63FF).withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: const Icon(
//                     Icons.download_outlined,
//                     color: Color(0xFF6C63FF),
//                     size: 20,
//                   ),
//                 ),
//           onPressed: _isSaving ? null : _saveLogoToGallery,
//         ),
//         const SizedBox(width: 8),
//       ],
//     );
//   }

//   Widget _buildCanvas() {
//     return Center(
//       child: Container(
//         margin: const EdgeInsets.all(20),
//         width: _canvasSize,
//         height: _canvasSize,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.12),
//               blurRadius: 24,
//               offset: const Offset(0, 6),
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(20),
//           child: RepaintBoundary(
//             key: _canvasKey,
//             child: SizedBox(
//               width: _canvasSize,
//               height: _canvasSize,
//               child: Stack(
//                 children: [
//                   // ── Solid white base — guarantees correct bg on export ──
//                   Positioned.fill(child: Container(color: Colors.white)),

//                   // ── Background image ──
//                   if (_loadedImage != null)
//                     Positioned.fill(
//                       child: CustomPaint(
//                         painter: _BackgroundPainter(image: _loadedImage!),
//                       ),
//                     ),

//                   // ── API placeholder texts (draggable) ──
//                   ...widget.logoData.placeholders
//                       .where((p) => p.type == 'text')
//                       .map((p) => _buildDraggablePlaceholderText(p)),

//                   // ── User-added layers (text + stickers) ──
//                   ..._layers.map((layer) => _buildDraggableLayer(layer)),

//                   // ── Tap canvas to deselect — hidden during save capture ──
//                   if (!_isCapturing)
//                     Positioned.fill(
//                       child: GestureDetector(
//                         onTap: () => setState(() => _selectedLayerId = null),
//                         behavior: HitTestBehavior.translucent,
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDraggablePlaceholderText(LogoPlaceholder placeholder) {
//     final offset = _placeholderOffsets[placeholder.id] ?? placeholder.position;
//     final isSelected = _selectedLayerId == placeholder.id;

//     return Positioned(
//       left: offset.dx,
//       top: offset.dy,
//       child: GestureDetector(
//         onTap: () {
//           setState(() => _selectedLayerId = placeholder.id);
//           _openPlaceholderEditor(placeholder);
//         },
//         onPanUpdate: (details) {
//           setState(() {
//             final current =
//                 _placeholderOffsets[placeholder.id] ?? placeholder.position;
//             _placeholderOffsets[placeholder.id] = Offset(
//               (current.dx + details.delta.dx).clamp(
//                 0,
//                 _canvasSize - placeholder.size.width,
//               ),
//               (current.dy + details.delta.dy).clamp(
//                 0,
//                 _canvasSize - placeholder.size.height,
//               ),
//             );
//           });
//         },
//         child: Container(
//           width: placeholder.size.width,
//           height: placeholder.size.height,
//           decoration: isSelected && !_isCapturing
//               ? BoxDecoration(
//                   border: Border.all(
//                     color: const Color(0xFF6C63FF),
//                     width: 1.5,
//                   ),
//                   borderRadius: BorderRadius.circular(6),
//                 )
//               : null,
//           alignment: _alignFromTextAlign(placeholder.textAlign),
//           child: Text(
//             _textValues[placeholder.id] ?? placeholder.defaultValue,
//             // Ensure text is always visible: add a contrasting outline shadow
//             style: placeholder.style.copyWith(
//               shadows: [
//                 // Contrasting halo so any text color is readable on any bg
//                 Shadow(
//                   color: _contrastShadowColor(
//                     placeholder.style.color ?? Colors.white,
//                   ),
//                   offset: const Offset(0, 0),
//                   blurRadius: 6,
//                 ),
//                 Shadow(
//                   color: _contrastShadowColor(
//                     placeholder.style.color ?? Colors.white,
//                   ),
//                   offset: const Offset(1, 1),
//                   blurRadius: 2,
//                 ),
//                 ...(placeholder.style.shadows ?? []),
//               ],
//             ),
//             textAlign: placeholder.textAlign,
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDraggableLayer(EditableLayer layer) {
//     final isSelected = _selectedLayerId == layer.id;
//     final isText = layer.type == LayerType.text;

//     return Positioned(
//       left: layer.position.dx,
//       top: layer.position.dy,
//       child: GestureDetector(
//         onTap: () {
//           setState(() => _selectedLayerId = layer.id);
//           if (isText) _openLayerTextEditor(layer);
//         },
//         onPanUpdate: (details) {
//           setState(() {
//             layer.position = Offset(
//               (layer.position.dx + details.delta.dx).clamp(0, _canvasSize - 80),
//               (layer.position.dy + details.delta.dy).clamp(0, _canvasSize - 50),
//             );
//           });
//         },
//         child: Container(
//           padding: const EdgeInsets.all(4),
//           decoration: isSelected && !_isCapturing
//               ? BoxDecoration(
//                   border: Border.all(
//                     color: const Color(0xFF6C63FF),
//                     width: 1.5,
//                   ),
//                   borderRadius: BorderRadius.circular(6),
//                 )
//               : null,
//           child: Text(
//             layer.content,
//             style: TextStyle(
//               fontSize: layer.fontSize,
//               color: isText ? layer.color : null,
//               fontWeight: isText ? layer.fontWeight : FontWeight.normal,
//               shadows: isText
//                   ? [
//                       // Contrasting halo ensures text is visible on any bg
//                       Shadow(
//                         color: _contrastShadowColor(layer.color),
//                         offset: const Offset(0, 0),
//                         blurRadius: 6,
//                       ),
//                       Shadow(
//                         color: _contrastShadowColor(layer.color),
//                         offset: const Offset(1, 1),
//                         blurRadius: 2,
//                       ),
//                     ]
//                   : null,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // ── Bottom Panel ─────────────────────────────────────────────

//   Widget _buildBottomPanel() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 12,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const SizedBox(height: 10),
//           Container(
//             width: 40,
//             height: 4,
//             decoration: BoxDecoration(
//               color: Colors.grey[300],
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//           const SizedBox(height: 12),

//           // ── Tab buttons ──
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Row(
//               children: [
//                 _tabButton(0, Icons.text_fields, 'Text'),
//                 const SizedBox(width: 8),
//                 _tabButton(1, Icons.emoji_emotions_outlined, 'Stickers'),
//                 const SizedBox(width: 8),
//                 _tabButton(2, Icons.palette_outlined, 'Color'),
//                 const Spacer(),
//                 // Quick add text button
//                 GestureDetector(
//                   onTap: _addTextLayer,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 14,
//                       vertical: 8,
//                     ),
//                     decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                         colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
//                       ),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: const Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(Icons.add, color: Colors.white, size: 16),
//                         SizedBox(width: 4),
//                         Text(
//                           'Add Text',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),

//           // ── Tab content ──
//           AnimatedSwitcher(
//             duration: const Duration(milliseconds: 200),
//             child: _buildTabContent(),
//           ),
//           const SizedBox(height: 16),
//         ],
//       ),
//     );
//   }

//   Widget _tabButton(int index, IconData icon, String label) {
//     final isActive = _activeTab == index;
//     return GestureDetector(
//       onTap: () => setState(() => _activeTab = index),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//         decoration: BoxDecoration(
//           color: isActive
//               ? const Color(0xFF6C63FF).withOpacity(0.12)
//               : Colors.grey[100],
//           borderRadius: BorderRadius.circular(20),
//           border: isActive
//               ? Border.all(color: const Color(0xFF6C63FF), width: 1.5)
//               : null,
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               icon,
//               size: 16,
//               color: isActive ? const Color(0xFF6C63FF) : Colors.grey[600],
//             ),
//             const SizedBox(width: 4),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: isActive ? const Color(0xFF6C63FF) : Colors.grey[600],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTabContent() {
//     switch (_activeTab) {
//       case 0:
//         return _buildTextTab();
//       case 1:
//         return _buildStickerTab();
//       case 2:
//         return _buildColorTab();
//       default:
//         return const SizedBox.shrink();
//     }
//   }

//   Widget _buildTextTab() {
//     final placeholders = widget.logoData.placeholders
//         .where((p) => p.type == 'text')
//         .toList();
//     final textLayers = _layers.where((l) => l.type == LayerType.text).toList();
//     final allItems = [
//       ...placeholders.map(
//         (p) => _PlaceholderChipData(
//           id: p.id,
//           label: p.label,
//           text: _textValues[p.id] ?? p.defaultValue,
//           onTap: () => _openPlaceholderEditor(p),
//         ),
//       ),
//       ...textLayers.map(
//         (l) => _PlaceholderChipData(
//           id: l.id,
//           label: 'Custom',
//           text: l.content,
//           onTap: () {
//             setState(() => _selectedLayerId = l.id);
//             _openLayerTextEditor(l);
//           },
//         ),
//       ),
//     ];

//     return SizedBox(
//       height: 70,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         itemCount: allItems.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 10),
//         itemBuilder: (_, i) {
//           final item = allItems[i];
//           return GestureDetector(
//             onTap: item.onTap,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
//                 ),
//                 borderRadius: BorderRadius.circular(30),
//                 boxShadow: [
//                   BoxShadow(
//                     color: const Color(0xFF6C63FF).withOpacity(0.3),
//                     blurRadius: 8,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(Icons.edit, color: Colors.white, size: 15),
//                   const SizedBox(width: 8),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         item.label,
//                         style: const TextStyle(
//                           fontSize: 10,
//                           color: Colors.white70,
//                         ),
//                       ),
//                       Text(
//                         item.text.length > 14
//                             ? '${item.text.substring(0, 14)}…'
//                             : item.text,
//                         style: const TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildStickerTab() {
//     return SizedBox(
//       height: 80,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         itemCount: _stickers.length,
//         itemBuilder: (_, i) {
//           return GestureDetector(
//             onTap: () => _addSticker(_stickers[i]),
//             child: Container(
//               width: 60,
//               height: 60,
//               margin: const EdgeInsets.only(right: 10),
//               decoration: BoxDecoration(
//                 color: Colors.grey[100],
//                 borderRadius: BorderRadius.circular(14),
//                 border: Border.all(color: Colors.grey[200]!, width: 1),
//               ),
//               child: Center(
//                 child: Text(_stickers[i], style: const TextStyle(fontSize: 28)),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildColorTab() {
//     final sel = _selectedLayer;
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           if (sel == null)
//             Text(
//               'Tap a text layer on the canvas to select it, then pick a color.',
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey[500],
//                 fontStyle: FontStyle.italic,
//               ),
//             )
//           else
//             Text(
//               'Color for "${sel.content.length > 12 ? '${sel.content.substring(0, 12)}…' : sel.content}"',
//               style: const TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF2D3142),
//               ),
//             ),
//           const SizedBox(height: 10),
//           Wrap(
//             spacing: 10,
//             runSpacing: 10,
//             children: _colorPalette.map((color) {
//               final isSelected = sel != null && sel.color.value == color.value;
//               return GestureDetector(
//                 onTap: sel == null
//                     ? null
//                     : () => setState(() => sel.color = color),
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 150),
//                   width: 36,
//                   height: 36,
//                   decoration: BoxDecoration(
//                     color: color,
//                     shape: BoxShape.circle,
//                     border: Border.all(
//                       color: isSelected
//                           ? const Color(0xFF6C63FF)
//                           : Colors.grey[300]!,
//                       width: isSelected ? 3 : 1,
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: color.withOpacity(0.4),
//                         blurRadius: 4,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: isSelected
//                       ? Icon(
//                           Icons.check,
//                           size: 18,
//                           color: color == Colors.white
//                               ? Colors.black
//                               : Colors.white,
//                         )
//                       : null,
//                 ),
//               );
//             }).toList(),
//           ),
//           const SizedBox(height: 4),
//         ],
//       ),
//     );
//   }

//   /// Returns a contrasting shadow color (dark for light text, light for dark text).
//   /// This ensures text is always legible regardless of the logo background.
//   Color _contrastShadowColor(Color textColor) {
//     final luminance = textColor.computeLuminance();
//     return luminance > 0.4
//         ? Colors.black.withOpacity(0.65) // dark shadow for light text
//         : Colors.white.withOpacity(0.65); // light glow for dark text
//   }

//   Alignment _alignFromTextAlign(TextAlign ta) {
//     switch (ta) {
//       case TextAlign.left:
//         return Alignment.centerLeft;
//       case TextAlign.right:
//         return Alignment.centerRight;
//       default:
//         return Alignment.center;
//     }
//   }
// }

// // Helper model for text tab chips
// class _PlaceholderChipData {
//   final String id;
//   final String label;
//   final String text;
//   final VoidCallback onTap;
//   _PlaceholderChipData({
//     required this.id,
//     required this.label,
//     required this.text,
//     required this.onTap,
//   });
// }

// // ─────────────────────────────────────────────
// //  BACKGROUND PAINTER (image only, no text)
// // ─────────────────────────────────────────────

// class _BackgroundPainter extends CustomPainter {
//   final ui.Image image;
//   _BackgroundPainter({required this.image});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final srcRect = Rect.fromLTWH(
//       0,
//       0,
//       image.width.toDouble(),
//       image.height.toDouble(),
//     );
//     final dstRect = Rect.fromLTWH(0, 0, size.width, size.height);
//     canvas.drawImageRect(image, srcRect, dstRect, Paint());
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

// // ─────────────────────────────────────────────
// //  TEXT EDITOR BOTTOM SHEET
// // ─────────────────────────────────────────────

// class _TextEditorBottomSheet extends StatefulWidget {
//   final String label;
//   final TextEditingController controller;
//   final String currentText;
//   final int maxLength;
//   final bool isRequired;
//   final Function(String) onSave;

//   const _TextEditorBottomSheet({
//     required this.label,
//     required this.controller,
//     required this.currentText,
//     required this.maxLength,
//     required this.isRequired,
//     required this.onSave,
//   });

//   @override
//   State<_TextEditorBottomSheet> createState() => _TextEditorBottomSheetState();
// }

// class _TextEditorBottomSheetState extends State<_TextEditorBottomSheet> {
//   late String _currentText;

//   @override
//   void initState() {
//     super.initState();
//     _currentText = widget.currentText;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//       ),
//       child: Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//         ),
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 40,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               widget.label,
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF2D3142),
//               ),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               widget.isRequired ? 'Required field' : 'Optional',
//               style: TextStyle(
//                 fontSize: 12,
//                 color: widget.isRequired ? Colors.orange : Colors.grey,
//               ),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: widget.controller,
//               autofocus: true,
//               maxLength: widget.maxLength,
//               maxLines: 2,
//               decoration: InputDecoration(
//                 hintText: 'Enter text...',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(
//                     color: Color(0xFF6C63FF),
//                     width: 2,
//                   ),
//                 ),
//               ),
//               onChanged: (v) => setState(() => _currentText = v),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: () => Navigator.pop(context),
//                     style: OutlinedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: const Text('Cancel'),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       widget.onSave(_currentText);
//                       Navigator.pop(context);
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF6C63FF),
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: const Text(
//                       'Apply',
//                       style: TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

// ══════════════════════════════════════════════════════════════
//  pubspec.yaml dependencies needed:
//
//  dependencies:
//    google_fonts: ^6.2.1
//    gal: ^2.3.0
//    http: ^1.2.0
// ══════════════════════════════════════════════════════════════

// ─────────────────────────────────────────────
//  DATA MODELS
// ─────────────────────────────────────────────

class LogoPlaceholder {
  final String id;
  final String type;
  final String label;
  final String defaultValue;
  final Offset position;
  final Size size;
  final TextStyle style;
  final bool required;
  final int maxLength;
  final TextAlign textAlign;

  LogoPlaceholder({
    required this.id,
    required this.type,
    required this.label,
    required this.defaultValue,
    required this.position,
    required this.size,
    required this.style,
    required this.required,
    required this.maxLength,
    required this.textAlign,
  });

  factory LogoPlaceholder.fromJson(Map<String, dynamic> json) {
    return LogoPlaceholder(
      id: json['id'],
      type: json['type'],
      label: json['label'],
      defaultValue: json['defaultValue'],
      position: Offset(
        json['position']['x'].toDouble(),
        json['position']['y'].toDouble(),
      ),
      size: Size(
        json['position']['width'].toDouble(),
        json['position']['height'].toDouble(),
      ),
      style: _parseTextStyle(json['style']),
      required: json['required'] ?? false,
      maxLength: json['maxLength'] ?? 100,
      textAlign: _parseTextAlign(json['style']['textAlign'] ?? 'center'),
    );
  }

  static TextStyle _parseTextStyle(Map<String, dynamic> style) {
    return TextStyle(
      fontSize: (style['fontSize'] ?? 24).toDouble(),
      fontWeight: style['fontWeight'] == 'bold'
          ? FontWeight.bold
          : FontWeight.normal,
      color: Color(
        int.parse(style['color'].replaceFirst('#', 'FF'), radix: 16),
      ),
      letterSpacing: (style['letterSpacing'] ?? 0).toDouble(),
    );
  }

  static TextAlign _parseTextAlign(String align) {
    switch (align.toLowerCase()) {
      case 'left':
        return TextAlign.left;
      case 'right':
        return TextAlign.right;
      default:
        return TextAlign.center;
    }
  }
}

class LogoData {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final String imageType;
  final List<LogoPlaceholder> placeholders;
  final bool isPremium;
  final List<String> tags;

  LogoData({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.imageType,
    required this.placeholders,
    required this.isPremium,
    required this.tags,
  });

  factory LogoData.fromJson(Map<String, dynamic> json) {
    final logo = json['logo'];
    return LogoData(
      id: logo['_id'],
      name: logo['name'],
      category: logo['category'],
      imageUrl: logo['image']['url'],
      imageType: logo['image']['type'],
      placeholders: (logo['placeholders'] as List)
          .map((p) => LogoPlaceholder.fromJson(p))
          .toList(),
      isPremium: logo['metadata']['isPremium'] ?? false,
      tags: List<String>.from(logo['metadata']['tags'] ?? []),
    );
  }
}

// ─────────────────────────────────────────────
//  GOOGLE FONTS CATALOGUE
// ─────────────────────────────────────────────

class GFontEntry {
  final String name;
  final TextStyle Function({TextStyle? textStyle}) font;

  GFontEntry(this.name, this.font);
}

final List<GFontEntry> kGoogleFonts = [
  GFontEntry('Montserrat', GoogleFonts.montserrat),
  GFontEntry('Roboto', GoogleFonts.roboto),
  GFontEntry('Playfair Display', GoogleFonts.playfairDisplay),
  GFontEntry('Raleway', GoogleFonts.raleway),
  GFontEntry('Lato', GoogleFonts.lato),
  GFontEntry('Oswald', GoogleFonts.oswald),
  GFontEntry('Pacifico', GoogleFonts.pacifico),
  GFontEntry('Dancing Script', GoogleFonts.dancingScript),
  GFontEntry('Bebas Neue', GoogleFonts.bebasNeue),
  GFontEntry('Righteous', GoogleFonts.righteous),
  GFontEntry('Abril Fatface', GoogleFonts.abrilFatface),
  GFontEntry('Lobster', GoogleFonts.lobster),
  GFontEntry('Cinzel', GoogleFonts.cinzel),
  GFontEntry('Exo 2', GoogleFonts.exo2),
  GFontEntry('Nunito', GoogleFonts.nunito),
  GFontEntry('Poppins', GoogleFonts.poppins),
  GFontEntry('Source Code Pro', GoogleFonts.sourceCodePro),
  GFontEntry('Titan One', GoogleFonts.titanOne),
  GFontEntry('Satisfy', GoogleFonts.satisfy),
  GFontEntry('Permanent Marker', GoogleFonts.permanentMarker),
  GFontEntry('Shadows Into Light', GoogleFonts.shadowsIntoLight),
  GFontEntry('Comfortaa', GoogleFonts.comfortaa),
  GFontEntry('Press Start 2P', GoogleFonts.pressStart2p),
];

// ─────────────────────────────────────────────
//  UNIFIED EDITABLE LAYER
//  Both API placeholder texts and user-added text/stickers
//  are represented as EditableLayer so they share the same
//  drag / pinch / color / font pipeline.
// ─────────────────────────────────────────────

enum LayerType { text, sticker }

class EditableLayer {
  final String id;
  final LayerType type;

  String content;
  Offset position;
  double fontSize;

  // text-only styling
  Color color;
  FontWeight fontWeight;
  String fontFamily;
  TextAlign textAlign;

  // true = originally from the API (cannot be deleted, shown as "Logo Text")
  final bool isPlaceholder;
  final int maxLength;

  EditableLayer({
    required this.id,
    required this.type,
    required this.content,
    required this.position,
    this.fontSize = 24,
    this.color = Colors.white,
    this.fontWeight = FontWeight.bold,
    this.fontFamily = 'Montserrat',
    this.textAlign = TextAlign.center,
    this.isPlaceholder = false,
    this.maxLength = 80,
  });

  /// Resolved TextStyle using the chosen Google Font.
  TextStyle get textStyle {
    final base = TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      letterSpacing: 0.5,
    );
    try {
      final entry = kGoogleFonts.firstWhere((e) => e.name == fontFamily);
      return entry.font(textStyle: base);
    } catch (_) {
      return base;
    }
  }

  /// Auto-contrasting halo so text is always readable on any background.
  List<Shadow> get visibilityShadows {
    final lum = color.computeLuminance();
    final sc = lum > 0.4
        ? Colors.black.withOpacity(0.7)
        : Colors.white.withOpacity(0.7);
    return [
      Shadow(color: sc, offset: Offset.zero, blurRadius: 8),
      Shadow(color: sc, offset: const Offset(1, 1), blurRadius: 2),
    ];
  }
}

// ─────────────────────────────────────────────
//  MAIN SCREEN
// ─────────────────────────────────────────────

class LogoEditorScreen extends StatefulWidget {
  final LogoData logoData;
  const LogoEditorScreen({super.key, required this.logoData});

  @override
  State<LogoEditorScreen> createState() => _LogoEditorScreenState();
}

class _LogoEditorScreenState extends State<LogoEditorScreen> {
  final List<EditableLayer> _layers = [];
  String? _selectedId;

  final GlobalKey _canvasKey = GlobalKey();
  bool _isSaving = false;
  bool _isCapturing = false;
  bool _isLoading = true;
  ui.Image? _loadedImage;

  static const double _canvasSize = 320.0;

  // bottom panel tab: 0=Text 1=Stickers 2=Fonts
  int _activeTab = 0;

  // pinch state
  double _fontSizeAtScaleStart = 24.0;

  static const List<String> _stickers = [
    '⭐',
    '🔥',
    '💎',
    '🎯',
    '🏆',
    '✨',
    '🎨',
    '🚀',
    '💡',
    '🎵',
    '❤️',
    '👑',
    '🌟',
    '💪',
    '🎉',
    '🌈',
    '🦋',
    '🌸',
    '🍀',
    '⚡',
    '🎸',
    '🎤',
    '📸',
    '🎬',
  ];

  static const List<Color> _palette = [
    Colors.white,
    Colors.black,
    Color(0xFFFF6B6B),
    Color(0xFFFFD93D),
    Color(0xFF6BCB77),
    Color(0xFF4D96FF),
    Color(0xFFFF6FC8),
    Color(0xFFFF9A3C),
    Color(0xFF845EC2),
    Color(0xFF00C9A7),
    Color(0xFFF9F871),
    Color(0xFFFF8066),
    Color(0xFF2D3142),
    Color(0xFF4ECDC4),
    Color(0xFFC7F2A4),
    Color(0xFFE8C1F4),
  ];

  // ── Init ─────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _initLayers();
    _loadImage();
  }

  /// Convert every API placeholder into an EditableLayer.
  void _initLayers() {
    for (final p in widget.logoData.placeholders) {
      if (p.type != 'text') continue;
      _layers.add(
        EditableLayer(
          id: p.id,
          type: LayerType.text,
          content: p.defaultValue,
          position: p.position,
          fontSize: p.style.fontSize ?? 24,
          color: p.style.color ?? Colors.white,
          fontWeight: p.style.fontWeight ?? FontWeight.bold,
          fontFamily: 'Montserrat',
          textAlign: p.textAlign,
          isPlaceholder: true,
          maxLength: p.maxLength,
        ),
      );
    }
  }

  Future<void> _loadImage() async {
    try {
      final res = await http.get(Uri.parse(widget.logoData.imageUrl));
      if (res.statusCode == 200) {
        final codec = await ui.instantiateImageCodec(res.bodyBytes);
        final frame = await codec.getNextFrame();
        if (mounted) {
          setState(() {
            _loadedImage = frame.image;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── Helpers ──────────────────────────────────────────────────

  EditableLayer? get _selected => _selectedId == null
      ? null
      : _layers.cast<EditableLayer?>().firstWhere(
          (l) => l!.id == _selectedId,
          orElse: () => null,
        );

  void _select(String id) => setState(() {
    _selectedId = id;
    _activeTab = 0;
  });

  void _deselect() => setState(() => _selectedId = null);

  void _deleteSelected() {
    final sel = _selected;
    if (sel == null) return;
    if (sel.isPlaceholder) {
      _deselect();
      return;
    }
    setState(() {
      _layers.removeWhere((l) => l.id == _selectedId);
      _selectedId = null;
    });
  }

  void _addText() {
    final layer = EditableLayer(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: LayerType.text,
      content: 'New Text',
      position: const Offset(60, 130),
      fontSize: 22,
      color: Colors.white,
      fontFamily: 'Montserrat',
    );
    setState(() {
      _layers.add(layer);
      _selectedId = layer.id;
    });
    _openEditSheet(layer);
  }

  void _addSticker(String emoji) {
    final layer = EditableLayer(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: LayerType.sticker,
      content: emoji,
      position: const Offset(110, 110),
      fontSize: 48,
    );
    setState(() {
      _layers.add(layer);
      _selectedId = layer.id;
    });
  }

  // ── Save ─────────────────────────────────────────────────────

  Future<void> _save() async {
    setState(() {
      _isSaving = true;
      _selectedId = null;
      _isCapturing = true;
    });
    await Future.delayed(const Duration(milliseconds: 150));
    try {
      final boundary =
          _canvasKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) return;
      final img = await boundary.toImage(pixelRatio: 3.0);
      final bd = await img.toByteData(format: ui.ImageByteFormat.png);
      final bytes = bd?.buffer.asUint8List();
      if (bytes != null) {
        await Gal.putImageBytes(
          bytes,
          name: 'Logo_${DateTime.now().millisecondsSinceEpoch}',
          album: 'Logo Maker',
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Text('Logo saved to gallery!'),
                ],
              ),
              backgroundColor: Color(0xFF6C63FF),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted)
        setState(() {
          _isSaving = false;
          _isCapturing = false;
        });
    }
  }

  // ── Open edit sheet ──────────────────────────────────────────

  void _openEditSheet(EditableLayer layer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _LayerEditSheet(
        layer: layer,
        palette: _palette,
        fonts: kGoogleFonts,
        canDelete: !layer.isPlaceholder,
        onChanged: () => setState(() {}),
        onDelete: () {
          Navigator.pop(context);
          _deleteSelected();
        },
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      appBar: _appBar(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
              ),
            )
          : Column(
              children: [
                Expanded(child: _canvas()),
                _bottomPanel(),
              ],
            ),
    );
  }

  // ── App bar ──────────────────────────────────────────────────

  PreferredSizeWidget _appBar() {
    final sel = _selected;
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: Color(0xFF2D3142),
          ),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        widget.logoData.name,
        style: const TextStyle(
          color: Color(0xFF2D3142),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
      actions: [
        if (sel != null && !sel.isPlaceholder)
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: _deleteSelected,
          ),
        if (widget.logoData.isPremium)
          Container(
            margin: const EdgeInsets.only(right: 6),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.stars, size: 14, color: Colors.white),
                SizedBox(width: 4),
                Text(
                  'PREMIUM',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        IconButton(
          icon: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C63FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.download_outlined,
                    color: Color(0xFF6C63FF),
                    size: 20,
                  ),
                ),
          onPressed: _isSaving ? null : _save,
        ),
        const SizedBox(width: 6),
      ],
    );
  }

  // ── Canvas ───────────────────────────────────────────────────

  Widget _canvas() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        width: _canvasSize,
        height: _canvasSize,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 24,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: RepaintBoundary(
            key: _canvasKey,
            child: SizedBox(
              width: _canvasSize,
              height: _canvasSize,
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  // Solid white base — ensures clean export background
                  Positioned.fill(child: Container(color: Colors.white)),

                  // Logo background image
                  if (_loadedImage != null)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _BgPainter(image: _loadedImage!),
                      ),
                    ),

                  // All layers (placeholders + user-added)
                  ..._layers.map(_layerWidget),

                  // Deselect tap (hidden during capture)
                  if (!_isCapturing)
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: _deselect,
                        behavior: HitTestBehavior.translucent,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _layerWidget(EditableLayer layer) {
    final isSelected = layer.id == _selectedId && !_isCapturing;
    final isText = layer.type == LayerType.text;

    return Positioned(
      left: layer.position.dx,
      top: layer.position.dy,
      child: GestureDetector(
        onTap: () {
          _select(layer.id);
          if (isText) _openEditSheet(layer);
        },
        // Remove onPanUpdate and use onScaleUpdate for both
        onScaleStart: (_) => _fontSizeAtScaleStart = layer.fontSize,
        onScaleUpdate: (d) {
          setState(() {
            // Handle drag (pan) - when pointerCount is 1
            if (d.pointerCount == 1) {
              layer.position = Offset(
                (layer.position.dx + d.focalPointDelta.dx).clamp(
                  0.0,
                  _canvasSize - 20,
                ),
                (layer.position.dy + d.focalPointDelta.dy).clamp(
                  0.0,
                  _canvasSize - 20,
                ),
              );
            }
            // Handle pinch (scale) - when pointerCount is 2
            else if (d.pointerCount >= 2) {
              layer.fontSize = (_fontSizeAtScaleStart * d.scale).clamp(
                8.0,
                120.0,
              );
            }
          });
        },
        onScaleEnd: (_) {},
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: isSelected
              ? BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF6C63FF),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                )
              : null,
          child: isText
              ? Text(
                  layer.content,
                  style: layer.textStyle.copyWith(
                    shadows: layer.visibilityShadows,
                  ),
                  textAlign: layer.textAlign,
                )
              : Text(layer.content, style: TextStyle(fontSize: layer.fontSize)),
        ),
      ),
    );
  }

  // ── Bottom panel ─────────────────────────────────────────────

  Widget _bottomPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),

          // Tab row + Add Text button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _tabBtn(0, Icons.text_fields_rounded, 'Text'),
                const SizedBox(width: 8),
                _tabBtn(1, Icons.emoji_emotions_outlined, 'Stickers'),
                const SizedBox(width: 8),
                _tabBtn(2, Icons.font_download_outlined, 'Fonts'),
                const Spacer(),
                _addTextBtn(),
              ],
            ),
          ),
          const SizedBox(height: 12),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: KeyedSubtree(
              key: ValueKey(_activeTab),
              child: _tabContent(),
            ),
          ),
          const SizedBox(height: 14),
        ],
      ),
    );
  }

  Widget _tabBtn(int idx, IconData icon, String label) {
    final active = _activeTab == idx;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = idx),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active
              ? const Color(0xFF6C63FF).withOpacity(0.12)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: active
              ? Border.all(color: const Color(0xFF6C63FF), width: 1.5)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: active ? const Color(0xFF6C63FF) : Colors.grey[600],
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: active ? const Color(0xFF6C63FF) : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addTextBtn() => GestureDetector(
    onTap: _addText,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add, color: Colors.white, size: 15),
          SizedBox(width: 4),
          Text(
            'Add Text',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _tabContent() {
    switch (_activeTab) {
      case 0:
        return _textTab();
      case 1:
        return _stickerTab();
      case 2:
        return _fontTab();
      default:
        return const SizedBox.shrink();
    }
  }

  // Text chips
  Widget _textTab() {
    final texts = _layers.where((l) => l.type == LayerType.text).toList();
    if (texts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Text(
          'Tap "Add Text" to add a text layer.',
          style: TextStyle(color: Colors.grey[400], fontSize: 13),
        ),
      );
    }
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: texts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final l = texts[i];
          final isActive = l.id == _selectedId;
          return GestureDetector(
            onTap: () {
              _select(l.id);
              _openEditSheet(l);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isActive
                      ? [const Color(0xFF4B44B8), const Color(0xFF3830A0)]
                      : [const Color(0xFF6C63FF), const Color(0xFF5A52D5)],
                ),
                borderRadius: BorderRadius.circular(30),
                border: isActive
                    ? Border.all(color: Colors.white, width: 1.5)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withOpacity(0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.edit, color: Colors.white, size: 14),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l.isPlaceholder ? 'Logo Text' : 'Custom',
                        style: const TextStyle(
                          fontSize: 9,
                          color: Colors.white60,
                        ),
                      ),
                      Text(
                        l.content.length > 14
                            ? '${l.content.substring(0, 14)}…'
                            : l.content,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _stickerTab() => SizedBox(
    height: 80,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _stickers.length,
      itemBuilder: (_, i) => GestureDetector(
        onTap: () => _addSticker(_stickers[i]),
        child: Container(
          width: 60,
          height: 60,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey[200]!, width: 1),
          ),
          child: Center(
            child: Text(_stickers[i], style: const TextStyle(fontSize: 28)),
          ),
        ),
      ),
    ),
  );

  Widget _fontTab() {
    final sel = _selected;
    if (sel == null || sel.type != LayerType.text) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(
          'Select a text layer on the canvas first.',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 13,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: kGoogleFonts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final f = kGoogleFonts[i];
          final active = sel.fontFamily == f.name;
          final preview = f.font(
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          );
          return GestureDetector(
            onTap: () => setState(() => sel.fontFamily = f.name),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: active ? const Color(0xFF6C63FF) : Colors.grey[100],
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: active ? const Color(0xFF6C63FF) : Colors.grey[300]!,
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Aa',
                    style: preview.copyWith(
                      fontSize: 18,
                      color: active ? Colors.white : const Color(0xFF2D3142),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    f.name,
                    style: TextStyle(
                      fontSize: 9,
                      color: active ? Colors.white70 : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  LAYER EDIT BOTTOM SHEET
//  Three tabs: Text input | Color picker | Font picker
// ─────────────────────────────────────────────

class _LayerEditSheet extends StatefulWidget {
  final EditableLayer layer;
  final List<Color> palette;
  final List<GFontEntry> fonts;
  final bool canDelete;
  final VoidCallback onChanged;
  final VoidCallback onDelete;

  const _LayerEditSheet({
    required this.layer,
    required this.palette,
    required this.fonts,
    required this.canDelete,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  State<_LayerEditSheet> createState() => _LayerEditSheetState();
}

class _LayerEditSheetState extends State<_LayerEditSheet>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _ctrl;
  late final TabController _tabCtrl;

  late Color _color;
  late String _fontFamily;
  late FontWeight _fontWeight;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.layer.content);
    _tabCtrl = TabController(length: 3, vsync: this);
    _color = widget.layer.color;
    _fontFamily = widget.layer.fontFamily;
    _fontWeight = widget.layer.fontWeight;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _tabCtrl.dispose();
    super.dispose();
  }

  void _apply() {
    final text = _ctrl.text.trim();
    if (text.isNotEmpty) widget.layer.content = text;
    widget.layer.color = _color;
    widget.layer.fontFamily = _fontFamily;
    widget.layer.fontWeight = _fontWeight;
    widget.onChanged();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),

            // Header row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text(
                    'Edit Text',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  const Spacer(),
                  if (widget.canDelete)
                    TextButton.icon(
                      onPressed: widget.onDelete,
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 18,
                      ),
                      label: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red, fontSize: 13),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                ],
              ),
            ),

            // Tabs
            TabBar(
              controller: _tabCtrl,
              indicatorColor: const Color(0xFF6C63FF),
              labelColor: const Color(0xFF6C63FF),
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(text: 'Text'),
                Tab(text: 'Color'),
                Tab(text: 'Font'),
              ],
            ),

            // Tab views
            SizedBox(
              height: 240,
              child: TabBarView(
                controller: _tabCtrl,
                children: [_textPane(), _colorPane(), _fontPane()],
              ),
            ),

            // Apply
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _apply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Text pane ────────────────────────────────────────────────
  Widget _textPane() => Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _ctrl,
          autofocus: true,
          maxLength: widget.layer.maxLength,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: 'Enter text…',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
            ),
            contentPadding: const EdgeInsets.all(14),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Text(
              'Bold',
              style: TextStyle(fontSize: 13, color: Color(0xFF2D3142)),
            ),
            const Spacer(),
            Switch(
              value: _fontWeight == FontWeight.bold,
              activeColor: const Color(0xFF6C63FF),
              onChanged: (v) => setState(
                () => _fontWeight = v ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  // ── Color pane ───────────────────────────────────────────────
  Widget _colorPane() => SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Selected:',
              style: TextStyle(fontSize: 13, color: Color(0xFF2D3142)),
            ),
            const SizedBox(width: 12),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[300]!, width: 1.5),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: widget.palette.map((c) {
            final active = _color.value == c.value;
            return GestureDetector(
              onTap: () => setState(() => _color = c),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: c,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: active ? const Color(0xFF6C63FF) : Colors.grey[300]!,
                    width: active ? 3 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: c.withOpacity(0.4),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: active
                    ? Icon(
                        Icons.check,
                        size: 18,
                        color: c.computeLuminance() > 0.4
                            ? Colors.black
                            : Colors.white,
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    ),
  );

  // ── Font pane ────────────────────────────────────────────────
  Widget _fontPane() => ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    itemCount: widget.fonts.length,
    itemBuilder: (_, i) {
      final f = widget.fonts[i];
      final active = _fontFamily == f.name;
      final style = f.font(
        textStyle: TextStyle(
          fontSize: 17,
          fontWeight: _fontWeight,
          color: active ? Colors.white : const Color(0xFF2D3142),
        ),
      );
      return GestureDetector(
        onTap: () => setState(() => _fontFamily = f.name),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF6C63FF) : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: active ? const Color(0xFF6C63FF) : Colors.grey[200]!,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Expanded(child: Text('Aa  ${f.name}', style: style)),
              if (active)
                const Icon(Icons.check_circle, color: Colors.white, size: 18),
            ],
          ),
        ),
      );
    },
  );
}

// ─────────────────────────────────────────────
//  BACKGROUND PAINTER  (image only, no text)
// ─────────────────────────────────────────────

class _BgPainter extends CustomPainter {
  final ui.Image image;
  const _BgPainter({required this.image});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint(),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
