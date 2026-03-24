// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:gal/gal.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:math' as math;
// import 'package:photo_manager/photo_manager.dart';
// import 'package:posternova/helper/storage_helper.dart';
// import 'package:posternova/models/create_poster_model.dart';
// import 'package:posternova/providers/auth/login_provider.dart';
// import 'package:posternova/providers/customer/customer_provider.dart';
// import 'package:posternova/views/chat/chat_module.dart';
// import 'package:posternova/widgets/language_widget.dart';
// import 'package:provider/provider.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:url_launcher/url_launcher.dart';

// class MakeLogo extends StatefulWidget {
//   // final String?editedImage;
//   // final String image;
//   // final String?id;

//   final String? editedImage;
//   final String? image; // Make this optional
//   final String? id;
//   final String? categoryId; // Add categoryId
//   final PosterSize? posterSize;
//   // const MakeLogo({super.key, required this.image,this.id,this.editedImage});

//   const MakeLogo({
//     super.key,
//     this.image,
//     this.id,
//     this.editedImage,
//     this.categoryId,
//     this.posterSize,
//   });

//   @override
//   State<MakeLogo> createState() => _EditLogoState();
// }

// class _EditLogoState extends State<MakeLogo>
//     with SingleTickerProviderStateMixin {
//   final List<_EditableImage> _images = [];
//   final List<_EditableText> _texts = [];
//   final List<_EditableShape> _shapes = [];
//   final List<_EditableElement> _elements = [];

//   final GlobalKey _canvasKey = GlobalKey();
//   bool _isLoading = false;
//   bool _isSaving = false;
//   late AnimationController _fabAnimationController;
//   late Animation<double> _fabAnimation;

//   String? userId;
//   String? phoneNumber;
//   String? email;

//   final List<String> _fontFamilies = [
//     'Roboto',
//     'Arial',
//     'Times New Roman',
//     'Courier New',
//     'Georgia',
//     'Verdana',
//     'Comic Sans MS',
//     'Impact',
//     'Trebuchet MS',
//     'Lucida Grande',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _loadSubscriptions();
//     _fabAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _fabAnimation = CurvedAnimation(
//       parent: _fabAnimationController,
//       curve: Curves.easeInOut,
//     );
//   }

//   @override
//   void dispose() {
//     _fabAnimationController.dispose();
//     super.dispose();
//   }

//   Future<void> _saveLogoToServer() async {
//     setState(() {
//       _isSaving = true;
//     });

//     try {
//       final Uint8List? logoImage = await _captureCanvasAsImage();

//       if (logoImage == null) {
//         throw Exception('Failed to capture the canvas');
//       }

//       final userData = await AuthPreferences.getUserData();
//       final userId = userData?.user.id;

//       if (userId == null) {
//         throw Exception('User not logged in');
//       }

//       if (widget.id == null || widget.id!.isEmpty) {
//         throw Exception('Logo ID is missing');
//       }

//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse('http://31.97.206.144:4061/api/users/user-history'),
//       );

//       request.fields['userId'] = userId;
//       request.fields['logoId'] = widget.id!;

//       request.files.add(
//         http.MultipartFile.fromBytes(
//           'editedImage',
//           logoImage,
//           filename: 'logo_${DateTime.now().millisecondsSinceEpoch}.png',
//         ),
//       );

//       final response = await request.send();
//       final responseBody = await response.stream.bytesToString();

//       print('Response status: ${response.statusCode}');
//       print('Response body: $responseBody');

//       // ✅ Check mounted before using context after async gap
//       if (!mounted) return;

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Row(
//               children: [
//                 Icon(Icons.check_circle, color: Colors.white),
//                 SizedBox(width: 12),
//                 Text('Logo saved successfully!'),
//               ],
//             ),
//             backgroundColor: Colors.green[600],
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             margin: const EdgeInsets.all(16),
//           ),
//         );
//       } else {
//         throw Exception('Server error: ${response.statusCode} - $responseBody');
//       }
//     } catch (e) {
//       print('Error saving logo: $e');

//       // ✅ Check mounted before using context after async gap
//       if (!mounted) return;

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Row(
//             children: [
//               const Icon(Icons.error, color: Colors.white),
//               const SizedBox(width: 12),
//               // Expanded(child: Text('Failed to save: ${e.toString()}')),
//             ],
//           ),
//           backgroundColor: Colors.red[600],
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           margin: const EdgeInsets.all(16),
//         ),
//       );
//     } finally {
//       // ✅ Check mounted before calling setState
//       if (mounted) {
//         setState(() {
//           _isSaving = false;
//         });
//       }
//     }
//   }

//   Future<void> _saveLogoToGallery() async {
//     setState(() => _isSaving = true);

//     try {
//       final Uint8List? logoImage = await _captureCanvasAsImage();

//       if (logoImage == null) {
//         throw Exception('Failed to capture the canvas');
//       }

//       await Gal.putImageBytes(
//         logoImage,
//         name: 'Logo_${DateTime.now().millisecondsSinceEpoch}',
//       );

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Row(
//             children: [
//               Icon(Icons.check_circle, color: Colors.white),
//               SizedBox(width: 12),
//               Text('Logo saved successfully!'),
//             ],
//           ),
//           backgroundColor: Colors.green[600],
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           margin: const EdgeInsets.all(16),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           backgroundColor: Colors.green,
//           content: Text('Logo saved Successfully'),
//         ),
//         // SnackBar(
//         //   content: Row(
//         //     children: [
//         //       // const Icon(Icons.error, color: Colors.white),
//         //       const SizedBox(width: 12),
//         //       // Expanded(child: Text('Failed to save: ${e.toString()}')),
//         //     ],
//         //   ),
//         //   backgroundColor: Colors.red[600],
//         //   behavior: SnackBarBehavior.floating,
//         //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         //   margin: const EdgeInsets.all(16),
//         // ),
//       );
//     } finally {
//       setState(() => _isSaving = false);
//     }
//   }

//   Future<Uint8List?> _captureCanvasAsImage() async {
//     try {
//       await Future.delayed(const Duration(milliseconds: 20));

//       final RenderRepaintBoundary? boundary =
//           _canvasKey.currentContext?.findRenderObject()
//               as RenderRepaintBoundary?;

//       if (boundary == null) {
//         debugPrint('Render boundary is null');
//         return null;
//       }
//       final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
//       final ByteData? byteData = await image.toByteData(
//         format: ui.ImageByteFormat.png,
//       );

//       if (byteData != null) {
//         return byteData.buffer.asUint8List();
//       }
//       debugPrint('ByteData is null');
//       return null;
//     } catch (e) {
//       debugPrint('Error capturing canvas: $e');
//       return null;
//     }
//   }

//   _EditableText? _selectedText;
//   _EditableShape? _selectedShape;
//   _EditableElement? _selectedElement;
//   _EditableImage? _selectedImage;

//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _images.add(
//           _EditableImage(
//             imageFile: File(pickedFile.path),
//             offset: const Offset(100, 100),
//             size: const Size(150, 150),
//           ),
//         );
//       });
//     }
//   }

//   void _addShape(ShapeType shapeType) {
//     setState(() {
//       _shapes.add(
//         _EditableShape(
//           shapeType: shapeType,
//           color: const Color(0xFF6C63FF),
//           size: const Size(80, 80),
//           offset: const Offset(100, 100),
//         ),
//       );
//     });
//   }

//   void _addElement(Map<String, dynamic> elementData) {
//     setState(() {
//       _elements.add(
//         _EditableElement(
//           icon: elementData['icon'],
//           name: elementData['name'],
//           color: const Color(0xFF6C63FF),
//           size: const Size(60, 60),
//           offset: const Offset(100, 100),
//         ),
//       );
//     });
//   }

//   void _deleteSelectedItem() {
//     setState(() {
//       if (_selectedText != null) {
//         _texts.remove(_selectedText);
//         _selectedText = null;
//       }

//       if (_selectedShape != null) {
//         _shapes.remove(_selectedShape);
//         _selectedShape = null;
//       }

//       if (_selectedElement != null) {
//         _elements.remove(_selectedElement);
//         _selectedElement = null;
//       }

//       if (_selectedImage != null) {
//         _images.remove(_selectedImage);
//         _selectedImage = null;
//       }
//     });
//   }

//   void _selectText(_EditableText text) {
//     setState(() {
//       if (_selectedText == text) {
//         _selectedText = null;
//       } else {
//         _selectedText = text;
//         _selectedShape = null;
//         _selectedElement = null;
//         _selectedImage = null;
//       }
//     });
//   }

//   void _selectShape(_EditableShape shape) {
//     setState(() {
//       if (_selectedShape == shape) {
//         _selectedShape = null;
//       } else {
//         _selectedShape = shape;
//         _selectedText = null;
//         _selectedElement = null;
//         _selectedImage = null;
//       }
//     });
//   }

//   void _selectElement(_EditableElement element) {
//     setState(() {
//       if (_selectedElement == element) {
//         _selectedElement = null;
//       } else {
//         _selectedElement = element;
//         _selectedText = null;
//         _selectedShape = null;
//         _selectedImage = null;
//       }
//     });
//   }

//   void _selectImage(_EditableImage image) {
//     setState(() {
//       if (_selectedImage == image) {
//         _selectedImage = null;
//       } else {
//         _selectedImage = image;
//         _selectedText = null;
//         _selectedShape = null;
//         _selectedElement = null;
//       }
//     });
//   }

//   void _deselectAll() {
//     setState(() {
//       _selectedText = null;
//       _selectedShape = null;
//       _selectedElement = null;
//       _selectedImage = null;
//     });
//   }

//   // Future<void> _loadSubscriptions() async {
//   //   setState(() {
//   //     _isLoading = true;
//   //   });

//   //   try {
//   //     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//   //     final userId = authProvider.user?.user.id;
//   //   } finally {
//   //     setState(() {
//   //       _isLoading = false;
//   //     });
//   //   }
//   // }

//   Future<void> _loadSubscriptions() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       final userData = await AuthPreferences.getUserData();

//       setState(() {
//         userId = authProvider.user?.user.id ?? userData?.user.id;
//         phoneNumber = userData?.user.mobile;
//         email = userData?.user.email;
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _showEditImagePopup(_EditableImage editableImage) {
//     double selectedSize = editableImage.size.width;

//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (_) {
//         return StatefulBuilder(
//           builder: (context, setModalState) {
//             return Container(
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//               ),
//               padding: const EdgeInsets.all(24),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     width: 40,
//                     height: 4,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[300],
//                       borderRadius: BorderRadius.circular(2),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   const Text(
//                     'Edit Image',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF2D3142),
//                     ),
//                   ),
//                   const SizedBox(height: 24),

//                   Row(
//                     children: [
//                       Icon(
//                         Icons.photo_size_select_large,
//                         color: Colors.grey[600],
//                         size: 20,
//                       ),
//                       const SizedBox(width: 8),
//                       const Text(
//                         'Size',
//                         style: TextStyle(fontWeight: FontWeight.w600),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   SliderTheme(
//                     data: SliderThemeData(
//                       activeTrackColor: const Color(0xFF6C63FF),
//                       inactiveTrackColor: Colors.grey[200],
//                       thumbColor: const Color(0xFF6C63FF),
//                       overlayColor: const Color(0xFF6C63FF).withOpacity(0.2),
//                       thumbShape: const RoundSliderThumbShape(
//                         enabledThumbRadius: 10,
//                       ),
//                       overlayShape: const RoundSliderOverlayShape(
//                         overlayRadius: 20,
//                       ),
//                     ),
//                     child: Slider(
//                       value: selectedSize,
//                       min: 50,
//                       max: 300,
//                       divisions: 25,
//                       label: selectedSize.round().toString(),
//                       onChanged: (value) {
//                         setModalState(() {
//                           selectedSize = value;
//                         });
//                       },
//                     ),
//                   ),

//                   const SizedBox(height: 24),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: OutlinedButton.icon(
//                           onPressed: () {
//                             setState(() {
//                               _images.remove(editableImage);
//                               _selectedImage = null;
//                             });
//                             Navigator.pop(context);
//                           },
//                           icon: const Icon(Icons.delete_outline),
//                           label: const Text('Delete'),
//                           style: OutlinedButton.styleFrom(
//                             foregroundColor: Colors.red[600],
//                             side: BorderSide(color: Colors.red[200]!),
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: ElevatedButton.icon(
//                           onPressed: () {
//                             setState(() {
//                               editableImage.size = Size(
//                                 selectedSize,
//                                 selectedSize,
//                               );
//                             });
//                             Navigator.pop(context);
//                           },
//                           icon: const Icon(Icons.check),
//                           label: const Text('Apply'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF6C63FF),
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             elevation: 0,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Future<void> _showCustomerSelectionDialog() async {
//     final customerProvider = Provider.of<CreateCustomerProvider>(
//       context,
//       listen: false,
//     );

//     if (customerProvider.customers.isEmpty) {
//       await customerProvider.fetchUser(userId.toString());
//     }

//     if (customerProvider.customers.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('No customers available. Please add customers first.'),
//           backgroundColor: Colors.orange,
//         ),
//       );
//       return;
//     }

//     List<String> religions = customerProvider.customers
//         .where(
//           (customer) =>
//               customer['religion'] != null &&
//               customer['religion'].toString().trim().isNotEmpty,
//         )
//         .map((customer) => customer['religion'].toString().trim())
//         .toSet()
//         .toList();

//     religions.sort();
//     religions.insert(0, 'All');

//     String selectedReligion = 'All';
//     Set<String> selectedCustomerIds = {};

//     List<Map<String, dynamic>> filteredCustomers() {
//       if (selectedReligion == 'All') {
//         return customerProvider.customers;
//       } else {
//         return customerProvider.customers
//             .where(
//               (customer) =>
//                   customer['religion']?.toString() == selectedReligion,
//             )
//             .toList();
//       }
//     }

//     final screenW = MediaQuery.sizeOf(context).width;
//     final screenH = MediaQuery.sizeOf(context).height;
//     final bool isSmall = screenW < 400;
//     final double dialogWidth = screenW < 600 ? screenW * 0.92 : 520.0;
//     final double dialogMaxH = screenH * 0.82;

//     showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setDialogState) {
//           final filtered = filteredCustomers();
//           final bool allSelected =
//               filtered.isNotEmpty &&
//               selectedCustomerIds.length == filtered.length &&
//               filtered.every(
//                 (c) => selectedCustomerIds.contains(c['_id'] as String),
//               );

//           return Dialog(
//             insetPadding: EdgeInsets.symmetric(
//               horizontal: isSmall ? 10 : 24,
//               vertical: 32,
//             ),
//             shape: const RoundedRectangleBorder(),
//             clipBehavior: Clip.antiAliasWithSaveLayer,
//             backgroundColor: Colors.white,
//             child: SizedBox(
//               width: dialogWidth,
//               height: dialogMaxH,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   // Header
//                   Container(
//                     decoration: const BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [Color(0xFF6366F1), Color(0xFF818CF8)],
//                         begin: Alignment.centerLeft,
//                         end: Alignment.centerRight,
//                       ),
//                     ),
//                     padding: const EdgeInsets.only(
//                       left: 20,
//                       right: 12,
//                       top: 18,
//                       bottom: 16,
//                     ),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         const Icon(
//                           Icons.people_rounded,
//                           color: Colors.white,
//                           size: 24,
//                         ),
//                         const SizedBox(width: 10),
//                         const Text(
//                           'Share Customers',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.w700,
//                             letterSpacing: 0.2,
//                           ),
//                         ),
//                         const Spacer(),
//                         if (selectedCustomerIds.isNotEmpty)
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 10,
//                               vertical: 3,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.25),
//                               borderRadius: BorderRadius.circular(14),
//                             ),
//                             child: Text(
//                               '${selectedCustomerIds.length}',
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ),
//                         const SizedBox(width: 4),
//                         IconButton(
//                           onPressed: () => Navigator.pop(context),
//                           icon: const Icon(
//                             Icons.close_rounded,
//                             color: Colors.white,
//                             size: 20,
//                           ),
//                           padding: EdgeInsets.zero,
//                           constraints: const BoxConstraints(),
//                         ),
//                       ],
//                     ),
//                   ),

//                   // Religion filter chips
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 10,
//                     ),
//                     child: SizedBox(
//                       height: 36,
//                       child: ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         physics: const BouncingScrollPhysics(),
//                         itemCount: religions.length,
//                         itemBuilder: (_, index) {
//                           final r = religions[index];
//                           final bool isActive = r == selectedReligion;
//                           return Padding(
//                             padding: EdgeInsets.only(
//                               right: index < religions.length - 1 ? 8 : 0,
//                             ),
//                             child: AnimatedContainer(
//                               duration: const Duration(milliseconds: 220),
//                               curve: Curves.easeInOut,
//                               decoration: BoxDecoration(
//                                 color: isActive
//                                     ? const Color(0xFF6366F1)
//                                     : const Color(0xFFF1F1FF),
//                                 borderRadius: BorderRadius.circular(18),
//                               ),
//                               child: InkWell(
//                                 borderRadius: BorderRadius.circular(18),
//                                 onTap: () {
//                                   setDialogState(() {
//                                     selectedReligion = r;
//                                     selectedCustomerIds.clear();
//                                   });
//                                 },
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 14,
//                                     vertical: 6,
//                                   ),
//                                   child: Text(
//                                     r,
//                                     style: TextStyle(
//                                       fontSize: 13,
//                                       fontWeight: FontWeight.w600,
//                                       color: isActive
//                                           ? Colors.white
//                                           : const Color(0xFF6366F1),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),

//                   // Info row
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: Row(
//                       children: [
//                         Text(
//                           '${filtered.length} customer${filtered.length != 1 ? 's' : ''}',
//                           style: const TextStyle(
//                             color: Color(0xFF6366F1),
//                             fontWeight: FontWeight.w600,
//                             fontSize: 13,
//                           ),
//                         ),
//                         const Spacer(),
//                         if (filtered.isNotEmpty)
//                           InkWell(
//                             onTap: () {
//                               setDialogState(() {
//                                 if (allSelected) {
//                                   selectedCustomerIds.clear();
//                                 } else {
//                                   selectedCustomerIds = filtered
//                                       .map((c) => c['_id'] as String)
//                                       .toSet();
//                                 }
//                               });
//                             },
//                             borderRadius: BorderRadius.circular(6),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 6,
//                                 vertical: 2,
//                               ),
//                               child: Row(
//                                 children: [
//                                   Icon(
//                                     allSelected
//                                         ? Icons.deselect
//                                         : Icons.select_all,
//                                     size: 18,
//                                     color: const Color(0xFF6366F1),
//                                   ),
//                                   const SizedBox(width: 4),
//                                   Text(
//                                     allSelected ? 'Deselect All' : 'Select All',
//                                     style: const TextStyle(
//                                       fontSize: 12,
//                                       color: Color(0xFF6366F1),
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 8),

//                   // Customer list
//                   Expanded(
//                     child: filtered.isEmpty
//                         ? Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 const Icon(
//                                   Icons.group_off_rounded,
//                                   size: 52,
//                                   color: Color(0xFFD1D5DB),
//                                 ),
//                                 const SizedBox(height: 12),
//                                 const Text(
//                                   'No customers found',
//                                   style: TextStyle(
//                                     color: Color(0xFF6B7280),
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                                 if (selectedReligion != 'All')
//                                   Padding(
//                                     padding: const EdgeInsets.only(top: 4),
//                                     child: Text(
//                                       'in "$selectedReligion"',
//                                       style: const TextStyle(
//                                         color: Color(0xFF9CA3AF),
//                                         fontSize: 13,
//                                       ),
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           )
//                         : ListView.builder(
//                             padding: const EdgeInsets.symmetric(horizontal: 8),
//                             itemCount: filtered.length,
//                             itemBuilder: (context, index) {
//                               final customer = filtered[index];
//                               final customerId = customer['_id'] as String;
//                               final bool isSelected = selectedCustomerIds
//                                   .contains(customerId);
//                               final String name =
//                                   customer['name']?.toString() ?? 'Unknown';
//                               final String? mobile = customer['mobile']
//                                   ?.toString();
//                               final String? email = customer['email']
//                                   ?.toString();
//                               final String? religion = customer['religion']
//                                   ?.toString();
//                               final String initial = name.isNotEmpty
//                                   ? name[0].toUpperCase()
//                                   : 'U';

//                               return AnimatedContainer(
//                                 duration: const Duration(milliseconds: 200),
//                                 curve: Curves.easeInOut,
//                                 margin: const EdgeInsets.only(bottom: 4),
//                                 decoration: BoxDecoration(
//                                   color: isSelected
//                                       ? const Color(0xFFEEEFFF)
//                                       : Colors.white,
//                                   borderRadius: BorderRadius.circular(12),
//                                   border: Border.all(
//                                     color: isSelected
//                                         ? const Color(0xFF6366F1)
//                                         : const Color(0xFFE8E8F0),
//                                     width: isSelected ? 1.5 : 1,
//                                   ),
//                                 ),
//                                 child: InkWell(
//                                   onTap: () {
//                                     setDialogState(() {
//                                       if (isSelected) {
//                                         selectedCustomerIds.remove(customerId);
//                                       } else {
//                                         selectedCustomerIds.add(customerId);
//                                       }
//                                     });
//                                   },
//                                   borderRadius: BorderRadius.circular(12),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(10),
//                                     child: Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       children: [
//                                         SizedBox(
//                                           width: 22,
//                                           height: 22,
//                                           child: Checkbox(
//                                             value: isSelected,
//                                             onChanged: (_) {
//                                               setDialogState(() {
//                                                 if (isSelected) {
//                                                   selectedCustomerIds.remove(
//                                                     customerId,
//                                                   );
//                                                 } else {
//                                                   selectedCustomerIds.add(
//                                                     customerId,
//                                                   );
//                                                 }
//                                               });
//                                             },
//                                             activeColor: const Color(
//                                               0xFF6366F1,
//                                             ),
//                                             side: const BorderSide(
//                                               color: Color(0xFFB0B0C0),
//                                             ),
//                                           ),
//                                         ),
//                                         const SizedBox(width: 8),
//                                         CircleAvatar(
//                                           radius: 22,
//                                           backgroundColor: const Color(
//                                             0xFF6366F1,
//                                           ),
//                                           child: Text(
//                                             initial,
//                                             style: const TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w700,
//                                               fontSize: 15,
//                                             ),
//                                           ),
//                                         ),
//                                         const SizedBox(width: 10),
//                                         Expanded(
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               Text(
//                                                 name,
//                                                 style: const TextStyle(
//                                                   fontSize: 14,
//                                                   fontWeight: FontWeight.w600,
//                                                   color: Color(0xFF1E1B4B),
//                                                 ),
//                                                 maxLines: 1,
//                                                 overflow: TextOverflow.ellipsis,
//                                               ),
//                                               if (mobile != null ||
//                                                   email != null)
//                                                 const SizedBox(height: 2),
//                                               if (mobile != null)
//                                                 Text(
//                                                   mobile,
//                                                   style: const TextStyle(
//                                                     fontSize: 12,
//                                                     color: Color(0xFF6B7280),
//                                                   ),
//                                                 ),
//                                               if (email != null)
//                                                 Text(
//                                                   email,
//                                                   style: const TextStyle(
//                                                     fontSize: 11,
//                                                     color: Color(0xFF9CA3AF),
//                                                   ),
//                                                   maxLines: 1,
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                 ),
//                                             ],
//                                           ),
//                                         ),
//                                         if (religion != null)
//                                           Container(
//                                             padding: const EdgeInsets.symmetric(
//                                               horizontal: 8,
//                                               vertical: 3,
//                                             ),
//                                             decoration: BoxDecoration(
//                                               color: const Color(0xFFF1F1FF),
//                                               borderRadius:
//                                                   BorderRadius.circular(20),
//                                             ),
//                                             child: Text(
//                                               religion,
//                                               style: const TextStyle(
//                                                 fontSize: 10,
//                                                 color: Color(0xFF6366F1),
//                                                 fontWeight: FontWeight.w600,
//                                               ),
//                                             ),
//                                           ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                   ),

//                   // Footer
//                   Container(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: isSmall ? 12 : 16,
//                       vertical: 14,
//                     ),
//                     decoration: const BoxDecoration(
//                       color: Color(0xFFF9FAFB),
//                       border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
//                     ),
//                     child: Row(
//                       children: [
//                         TextButton(
//                           style: TextButton.styleFrom(
//                             foregroundColor: const Color(0xFF6B7280),
//                             padding: EdgeInsets.symmetric(
//                               horizontal: isSmall ? 12 : 16,
//                               vertical: 10,
//                             ),
//                           ),
//                           onPressed: () => Navigator.pop(context),
//                           child: const Text(
//                             'Cancel',
//                             style: TextStyle(fontWeight: FontWeight.w600),
//                           ),
//                         ),
//                         const Spacer(),
//                         AnimatedOpacity(
//                           opacity: selectedCustomerIds.isNotEmpty ? 1.0 : 0.45,
//                           duration: const Duration(milliseconds: 200),
//                           child: ElevatedButton.icon(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFF6366F1),
//                               foregroundColor: Colors.white,
//                               disabledBackgroundColor: const Color(0xFFACAFE8),
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: isSmall ? 16 : 22,
//                                 vertical: 10,
//                               ),
//                               elevation: 0,
//                             ),
//                             onPressed: selectedCustomerIds.isEmpty
//                                 ? null
//                                 : () async {
//                                     Navigator.pop(context);
//                                     await _shareLogoWithSelectedCustomers(
//                                       selectedCustomerIds,
//                                       filteredCustomers(),
//                                     );
//                                   },
//                             icon: const Icon(Icons.share_rounded, size: 18),
//                             label: Text(
//                               'Share (${selectedCustomerIds.length})',
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.w700,
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Future<void> _shareLogoWithSelectedCustomers(
//     Set<String> selectedCustomerIds,
//     List<Map<String, dynamic>> allCustomers,
//   ) async {
//     BuildContext? dialogContext;

//     try {
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) {
//           dialogContext = context; // Store dialog context
//           return const AlertDialog(
//             content: Row(
//               children: [
//                 CircularProgressIndicator(),
//                 SizedBox(width: 16),
//                 Text('Preparing logo...'),
//               ],
//             ),
//           );
//         },
//       );

//       // Generate logo image
//       final Uint8List? logoImage = await _captureCanvasAsImage();

//       if (logoImage == null) {
//         throw Exception('Failed to capture the logo');
//       }

//       final directory = await getTemporaryDirectory();
//       final file = File(
//         '${directory.path}/logo_share_${DateTime.now().millisecondsSinceEpoch}.png',
//       );
//       await file.writeAsBytes(logoImage);

//       // Close loading dialog safely
//       if (dialogContext != null && Navigator.canPop(dialogContext!)) {
//         Navigator.of(dialogContext!).pop();
//       }

//       final selectedCustomers = allCustomers
//           .where((c) => selectedCustomerIds.contains(c['_id']))
//           .toList();

//       if (selectedCustomers.isEmpty) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('No customers selected'),
//               backgroundColor: Colors.orange,
//             ),
//           );
//         }
//         return;
//       }

//       // Navigate to ChatModule with logo and selected customers
//       if (mounted) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ChatModule(
//               posterImagePath: file.path,
//               selectedCustomers: selectedCustomers,
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       // Close loading dialog safely in case of error
//       if (dialogContext != null && Navigator.canPop(dialogContext!)) {
//         Navigator.of(dialogContext!).pop();
//       }

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error: $e'),
//             backgroundColor: Colors.red,
//             duration: const Duration(seconds: 4),
//           ),
//         );
//       }
//     }
//   }

//   void _showEditShapePopup(_EditableShape editableShape) {
//     Color selectedColor = editableShape.color;
//     double selectedSize = editableShape.size.width;

//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (_) {
//         return StatefulBuilder(
//           builder: (context, setModalState) {
//             return Container(
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//               ),
//               padding: const EdgeInsets.all(24),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     width: 40,
//                     height: 4,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[300],
//                       borderRadius: BorderRadius.circular(2),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   const Text(
//                     'Edit Shape',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF2D3142),
//                     ),
//                   ),
//                   const SizedBox(height: 24),

//                   Row(
//                     children: [
//                       Icon(Icons.palette, color: Colors.grey[600], size: 20),
//                       const SizedBox(width: 8),
//                       const Text(
//                         'Color',
//                         style: TextStyle(fontWeight: FontWeight.w600),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   Wrap(
//                     spacing: 12,
//                     children: [
//                       _modernColorPicker(
//                         const Color(0xFF6C63FF),
//                         selectedColor,
//                         (color) {
//                           setModalState(() => selectedColor = color);
//                         },
//                       ),
//                       _modernColorPicker(
//                         const Color(0xFFFF6B6B),
//                         selectedColor,
//                         (color) {
//                           setModalState(() => selectedColor = color);
//                         },
//                       ),
//                       _modernColorPicker(
//                         const Color(0xFF4ECDC4),
//                         selectedColor,
//                         (color) {
//                           setModalState(() => selectedColor = color);
//                         },
//                       ),
//                       _modernColorPicker(
//                         const Color(0xFFFFA502),
//                         selectedColor,
//                         (color) {
//                           setModalState(() => selectedColor = color);
//                         },
//                       ),
//                       _modernColorPicker(
//                         const Color(0xFF95E1D3),
//                         selectedColor,
//                         (color) {
//                           setModalState(() => selectedColor = color);
//                         },
//                       ),
//                       _modernColorPicker(
//                         const Color(0xFFF38181),
//                         selectedColor,
//                         (color) {
//                           setModalState(() => selectedColor = color);
//                         },
//                       ),
//                       _modernColorPicker(
//                         const ui.Color.fromARGB(255, 0, 0, 0),
//                         selectedColor,
//                         (color) {
//                           setModalState(() => selectedColor = color);
//                         },
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 24),
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.photo_size_select_large,
//                         color: Colors.grey[600],
//                         size: 20,
//                       ),
//                       const SizedBox(width: 8),
//                       const Text(
//                         'Size',
//                         style: TextStyle(fontWeight: FontWeight.w600),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   SliderTheme(
//                     data: SliderThemeData(
//                       activeTrackColor: const Color(0xFF6C63FF),
//                       inactiveTrackColor: Colors.grey[200],
//                       thumbColor: const Color(0xFF6C63FF),
//                       overlayColor: const Color(0xFF6C63FF).withOpacity(0.2),
//                       thumbShape: const RoundSliderThumbShape(
//                         enabledThumbRadius: 10,
//                       ),
//                       overlayShape: const RoundSliderOverlayShape(
//                         overlayRadius: 20,
//                       ),
//                     ),
//                     child: Slider(
//                       value: selectedSize,
//                       min: 20,
//                       max: 200,
//                       divisions: 18,
//                       label: selectedSize.round().toString(),
//                       onChanged: (value) {
//                         setModalState(() {
//                           selectedSize = value;
//                         });
//                       },
//                     ),
//                   ),

//                   const SizedBox(height: 24),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: OutlinedButton.icon(
//                           onPressed: () {
//                             setState(() {
//                               _shapes.remove(editableShape);
//                               _selectedShape = null;
//                             });
//                             Navigator.pop(context);
//                           },
//                           icon: const Icon(Icons.delete_outline),
//                           label: const Text('Delete'),
//                           style: OutlinedButton.styleFrom(
//                             foregroundColor: Colors.red[600],
//                             side: BorderSide(color: Colors.red[200]!),
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: ElevatedButton.icon(
//                           onPressed: () {
//                             setState(() {
//                               editableShape.color = selectedColor;
//                               editableShape.size = Size(
//                                 selectedSize,
//                                 selectedSize,
//                               );
//                             });
//                             Navigator.pop(context);
//                           },
//                           icon: const Icon(Icons.check),
//                           label: const Text('Apply'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF6C63FF),
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             elevation: 0,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   void _showEditElementPopup(_EditableElement editableElement) {
//     Color selectedColor = editableElement.color;
//     double selectedSize = editableElement.size.width;

//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (_) {
//         return StatefulBuilder(
//           builder: (context, setModalState) {
//             return Container(
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//               ),
//               padding: const EdgeInsets.all(24),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     width: 40,
//                     height: 4,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[300],
//                       borderRadius: BorderRadius.circular(2),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     'Edit ${editableElement.name}',
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF2D3142),
//                     ),
//                   ),
//                   const SizedBox(height: 24),

//                   Row(
//                     children: [
//                       Icon(Icons.palette, color: Colors.grey[600], size: 20),
//                       const SizedBox(width: 8),
//                       const Text(
//                         'Color',
//                         style: TextStyle(fontWeight: FontWeight.w600),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   Wrap(
//                     spacing: 12,
//                     children: [
//                       _modernColorPicker(
//                         const Color(0xFF6C63FF),
//                         selectedColor,
//                         (color) {
//                           setModalState(() => selectedColor = color);
//                         },
//                       ),
//                       _modernColorPicker(
//                         const Color(0xFFFF6B6B),
//                         selectedColor,
//                         (color) {
//                           setModalState(() => selectedColor = color);
//                         },
//                       ),
//                       _modernColorPicker(
//                         const Color(0xFF4ECDC4),
//                         selectedColor,
//                         (color) {
//                           setModalState(() => selectedColor = color);
//                         },
//                       ),
//                       _modernColorPicker(
//                         const Color(0xFFFFA502),
//                         selectedColor,
//                         (color) {
//                           setModalState(() => selectedColor = color);
//                         },
//                       ),
//                       _modernColorPicker(
//                         const Color(0xFF95E1D3),
//                         selectedColor,
//                         (color) {
//                           setModalState(() => selectedColor = color);
//                         },
//                       ),
//                       _modernColorPicker(
//                         const Color(0xFFF38181),
//                         selectedColor,
//                         (color) {
//                           setModalState(() => selectedColor = color);
//                         },
//                       ),
//                       _modernColorPicker(
//                         const ui.Color.fromARGB(255, 0, 0, 0),
//                         selectedColor,
//                         (color) {
//                           setModalState(() => selectedColor = color);
//                         },
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 24),
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.photo_size_select_large,
//                         color: Colors.grey[600],
//                         size: 20,
//                       ),
//                       const SizedBox(width: 8),
//                       const Text(
//                         'Size',
//                         style: TextStyle(fontWeight: FontWeight.w600),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   SliderTheme(
//                     data: SliderThemeData(
//                       activeTrackColor: const Color(0xFF6C63FF),
//                       inactiveTrackColor: Colors.grey[200],
//                       thumbColor: const Color(0xFF6C63FF),
//                       overlayColor: const Color(0xFF6C63FF).withOpacity(0.2),
//                       thumbShape: const RoundSliderThumbShape(
//                         enabledThumbRadius: 10,
//                       ),
//                       overlayShape: const RoundSliderOverlayShape(
//                         overlayRadius: 20,
//                       ),
//                     ),
//                     child: Slider(
//                       value: selectedSize,
//                       min: 20,
//                       max: 200,
//                       divisions: 18,
//                       label: selectedSize.round().toString(),
//                       onChanged: (value) {
//                         setModalState(() {
//                           selectedSize = value;
//                         });
//                       },
//                     ),
//                   ),

//                   const SizedBox(height: 24),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: OutlinedButton.icon(
//                           onPressed: () {
//                             setState(() {
//                               _elements.remove(editableElement);
//                               _selectedElement = null;
//                             });
//                             Navigator.pop(context);
//                           },
//                           icon: const Icon(Icons.delete_outline),
//                           label: const Text('Delete'),
//                           style: OutlinedButton.styleFrom(
//                             foregroundColor: Colors.red[600],
//                             side: BorderSide(color: Colors.red[200]!),
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: ElevatedButton.icon(
//                           onPressed: () {
//                             setState(() {
//                               editableElement.color = selectedColor;
//                               editableElement.size = Size(
//                                 selectedSize,
//                                 selectedSize,
//                               );
//                             });
//                             Navigator.pop(context);
//                           },
//                           icon: const Icon(Icons.check),
//                           label: const Text('Apply'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF6C63FF),
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             elevation: 0,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   void _showAddTextPopup() {
//     final TextEditingController textController = TextEditingController();
//     Color selectedColor = const Color(0xFF2D3142);
//     String selectedFontFamily = _fontFamilies[0];
//     double selectedFontSize = 24.0;
//     bool isBold = false;
//     bool isItalic = false;

//     showDialog(
//       context: context,
//       builder: (_) {
//         return StatefulBuilder(
//           builder: (context, setDialogState) {
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Container(
//                 constraints: const BoxConstraints(maxWidth: 500),
//                 padding: const EdgeInsets.all(24),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Add Text',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF2D3142),
//                         ),
//                       ),
//                       const SizedBox(height: 24),

//                       TextField(
//                         controller: textController,
//                         decoration: InputDecoration(
//                           labelText: 'Enter your text',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: const BorderSide(
//                               color: Color(0xFF6C63FF),
//                               width: 2,
//                             ),
//                           ),
//                         ),
//                         autofocus: true,
//                         onChanged: (value) => setDialogState(() {}),
//                       ),

//                       const SizedBox(height: 24),
//                       const Text(
//                         'Font Family',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Container(
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey[300]!),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         padding: const EdgeInsets.symmetric(horizontal: 12),
//                         child: DropdownButtonHideUnderline(
//                           child: DropdownButton<String>(
//                             value: selectedFontFamily,
//                             isExpanded: true,
//                             items: _fontFamilies.map((font) {
//                               return DropdownMenuItem<String>(
//                                 value: font,
//                                 child: Text(
//                                   font,
//                                   style: TextStyle(fontFamily: font),
//                                 ),
//                               );
//                             }).toList(),
//                             onChanged: (value) {
//                               setDialogState(() {
//                                 selectedFontFamily = value!;
//                               });
//                             },
//                           ),
//                         ),
//                       ),

//                       const SizedBox(height: 24),
//                       Row(
//                         children: [
//                           const Text(
//                             'Font Size',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               fontSize: 16,
//                             ),
//                           ),
//                           const Spacer(),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 4,
//                             ),
//                             decoration: BoxDecoration(
//                               color: const Color(0xFF6C63FF).withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Text(
//                               '${selectedFontSize.round()}',
//                               style: const TextStyle(
//                                 color: Color(0xFF6C63FF),
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       SliderTheme(
//                         data: SliderThemeData(
//                           activeTrackColor: const Color(0xFF6C63FF),
//                           inactiveTrackColor: Colors.grey[200],
//                           thumbColor: const Color(0xFF6C63FF),
//                           overlayColor: const Color(
//                             0xFF6C63FF,
//                           ).withOpacity(0.2),
//                           thumbShape: const RoundSliderThumbShape(
//                             enabledThumbRadius: 10,
//                           ),
//                           overlayShape: const RoundSliderOverlayShape(
//                             overlayRadius: 20,
//                           ),
//                         ),
//                         child: Slider(
//                           value: selectedFontSize,
//                           min: 10,
//                           max: 48,
//                           divisions: 38,
//                           onChanged: (value) {
//                             setDialogState(() {
//                               selectedFontSize = value;
//                             });
//                           },
//                         ),
//                       ),

//                       const SizedBox(height: 24),
//                       const Text(
//                         'Font Style',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: _styleToggleButton(
//                               label: 'Bold',
//                               icon: Icons.format_bold,
//                               isSelected: isBold,
//                               onTap: () {
//                                 setDialogState(() {
//                                   isBold = !isBold;
//                                 });
//                               },
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: _styleToggleButton(
//                               label: 'Italic',
//                               icon: Icons.format_italic,
//                               isSelected: isItalic,
//                               onTap: () {
//                                 setDialogState(() {
//                                   isItalic = !isItalic;
//                                 });
//                               },
//                             ),
//                           ),
//                         ],
//                       ),

//                       const SizedBox(height: 24),
//                       const Text(
//                         'Color',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Wrap(
//                         spacing: 12,
//                         children: [
//                           _modernColorPicker(
//                             const Color(0xFF2D3142),
//                             selectedColor,
//                             (color) {
//                               setDialogState(() => selectedColor = color);
//                             },
//                           ),
//                           _modernColorPicker(
//                             const Color(0xFFFF6B6B),
//                             selectedColor,
//                             (color) {
//                               setDialogState(() => selectedColor = color);
//                             },
//                           ),
//                           _modernColorPicker(
//                             const Color(0xFF6C63FF),
//                             selectedColor,
//                             (color) {
//                               setDialogState(() => selectedColor = color);
//                             },
//                           ),
//                           _modernColorPicker(
//                             const Color(0xFF4ECDC4),
//                             selectedColor,
//                             (color) {
//                               setDialogState(() => selectedColor = color);
//                             },
//                           ),
//                           _modernColorPicker(
//                             const Color(0xFFFFA502),
//                             selectedColor,
//                             (color) {
//                               setDialogState(() => selectedColor = color);
//                             },
//                           ),
//                           _modernColorPicker(
//                             const Color(0xFF95E1D3),
//                             selectedColor,
//                             (color) {
//                               setDialogState(() => selectedColor = color);
//                             },
//                           ),
//                         ],
//                       ),

//                       const SizedBox(height: 24),
//                       const Text(
//                         'Preview',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.all(20),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey[300]!),
//                           borderRadius: BorderRadius.circular(12),
//                           color: Colors.grey[50],
//                         ),
//                         child: Center(
//                           child: Text(
//                             textController.text.isEmpty
//                                 ? 'Sample Text'
//                                 : textController.text,
//                             style: TextStyle(
//                               color: selectedColor,
//                               fontSize: selectedFontSize,
//                               fontFamily: selectedFontFamily,
//                               fontWeight: isBold
//                                   ? FontWeight.bold
//                                   : FontWeight.normal,
//                               fontStyle: isItalic
//                                   ? FontStyle.italic
//                                   : FontStyle.normal,
//                             ),
//                           ),
//                         ),
//                       ),

//                       const SizedBox(height: 24),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: OutlinedButton(
//                               onPressed: () => Navigator.pop(context),
//                               style: OutlinedButton.styleFrom(
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 16,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 side: BorderSide(color: Colors.grey[300]!),
//                               ),
//                               child: const Text('Cancel'),
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 if (textController.text.isNotEmpty) {
//                                   setState(() {
//                                     _texts.add(
//                                       _EditableText(
//                                         text: textController.text,
//                                         color: selectedColor,
//                                         fontSize: selectedFontSize,
//                                         fontFamily: selectedFontFamily,
//                                         isBold: isBold,
//                                         isItalic: isItalic,
//                                         offset: const Offset(100, 100),
//                                       ),
//                                     );
//                                   });
//                                   Navigator.pop(context);
//                                 }
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: const Color(0xFF6C63FF),
//                                 foregroundColor: Colors.white,
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 16,
//                                 ),
//                                 elevation: 0,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                               child: const Text('Add Text'),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   void _showEditTextPopup(_EditableText editableText) {
//     final TextEditingController textController = TextEditingController(
//       text: editableText.text,
//     );
//     Color selectedColor = editableText.color;
//     String selectedFontFamily = editableText.fontFamily;
//     double selectedFontSize = editableText.fontSize;
//     bool isBold = editableText.isBold;
//     bool isItalic = editableText.isItalic;

//     showDialog(
//       context: context,
//       builder: (_) {
//         return StatefulBuilder(
//           builder: (context, setDialogState) {
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Container(
//                 constraints: const BoxConstraints(maxWidth: 500),
//                 padding: const EdgeInsets.all(24),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Edit Text',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF2D3142),
//                         ),
//                       ),
//                       const SizedBox(height: 24),

//                       TextField(
//                         controller: textController,
//                         decoration: InputDecoration(
//                           labelText: 'Enter your text',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: const BorderSide(
//                               color: Color(0xFF6C63FF),
//                               width: 2,
//                             ),
//                           ),
//                         ),
//                         autofocus: true,
//                         onChanged: (value) => setDialogState(() {}),
//                       ),

//                       const SizedBox(height: 24),
//                       const Text(
//                         'Font Family',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Container(
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey[300]!),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         padding: const EdgeInsets.symmetric(horizontal: 12),
//                         child: DropdownButtonHideUnderline(
//                           child: DropdownButton<String>(
//                             value: selectedFontFamily,
//                             isExpanded: true,
//                             items: _fontFamilies.map((font) {
//                               return DropdownMenuItem<String>(
//                                 value: font,
//                                 child: Text(
//                                   font,
//                                   style: TextStyle(fontFamily: font),
//                                 ),
//                               );
//                             }).toList(),
//                             onChanged: (value) {
//                               setDialogState(() {
//                                 selectedFontFamily = value!;
//                               });
//                             },
//                           ),
//                         ),
//                       ),

//                       const SizedBox(height: 24),
//                       Row(
//                         children: [
//                           const Text(
//                             'Font Size',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               fontSize: 16,
//                             ),
//                           ),
//                           const Spacer(),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 4,
//                             ),
//                             decoration: BoxDecoration(
//                               color: const Color(0xFF6C63FF).withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Text(
//                               '${selectedFontSize.round()}',
//                               style: const TextStyle(
//                                 color: Color(0xFF6C63FF),
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       SliderTheme(
//                         data: SliderThemeData(
//                           activeTrackColor: const Color(0xFF6C63FF),
//                           inactiveTrackColor: Colors.grey[200],
//                           thumbColor: const Color(0xFF6C63FF),
//                           overlayColor: const Color(
//                             0xFF6C63FF,
//                           ).withOpacity(0.2),
//                           thumbShape: const RoundSliderThumbShape(
//                             enabledThumbRadius: 10,
//                           ),
//                           overlayShape: const RoundSliderOverlayShape(
//                             overlayRadius: 20,
//                           ),
//                         ),
//                         child: Slider(
//                           value: selectedFontSize,
//                           min: 10,
//                           max: 48,
//                           divisions: 38,
//                           onChanged: (value) {
//                             setDialogState(() {
//                               selectedFontSize = value;
//                             });
//                           },
//                         ),
//                       ),

//                       const SizedBox(height: 24),
//                       const Text(
//                         'Font Style',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: _styleToggleButton(
//                               label: 'Bold',
//                               icon: Icons.format_bold,
//                               isSelected: isBold,
//                               onTap: () {
//                                 setDialogState(() {
//                                   isBold = !isBold;
//                                 });
//                               },
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: _styleToggleButton(
//                               label: 'Italic',
//                               icon: Icons.format_italic,
//                               isSelected: isItalic,
//                               onTap: () {
//                                 setDialogState(() {
//                                   isItalic = !isItalic;
//                                 });
//                               },
//                             ),
//                           ),
//                         ],
//                       ),

//                       const SizedBox(height: 24),
//                       const Text(
//                         'Color',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Wrap(
//                         spacing: 12,
//                         children: [
//                           _modernColorPicker(
//                             const Color(0xFF2D3142),
//                             selectedColor,
//                             (color) {
//                               setDialogState(() => selectedColor = color);
//                             },
//                           ),
//                           _modernColorPicker(
//                             const Color(0xFFFF6B6B),
//                             selectedColor,
//                             (color) {
//                               setDialogState(() => selectedColor = color);
//                             },
//                           ),
//                           _modernColorPicker(
//                             const Color(0xFF6C63FF),
//                             selectedColor,
//                             (color) {
//                               setDialogState(() => selectedColor = color);
//                             },
//                           ),
//                           _modernColorPicker(
//                             const Color(0xFF4ECDC4),
//                             selectedColor,
//                             (color) {
//                               setDialogState(() => selectedColor = color);
//                             },
//                           ),
//                           _modernColorPicker(
//                             const Color(0xFFFFA502),
//                             selectedColor,
//                             (color) {
//                               setDialogState(() => selectedColor = color);
//                             },
//                           ),
//                           _modernColorPicker(
//                             const Color(0xFF95E1D3),
//                             selectedColor,
//                             (color) {
//                               setDialogState(() => selectedColor = color);
//                             },
//                           ),
//                         ],
//                       ),

//                       const SizedBox(height: 24),
//                       const Text(
//                         'Preview',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.all(20),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey[300]!),
//                           borderRadius: BorderRadius.circular(12),
//                           color: Colors.grey[50],
//                         ),
//                         child: Center(
//                           child: Text(
//                             textController.text.isEmpty
//                                 ? 'Sample Text'
//                                 : textController.text,
//                             style: TextStyle(
//                               color: selectedColor,
//                               fontSize: selectedFontSize,
//                               fontFamily: selectedFontFamily,
//                               fontWeight: isBold
//                                   ? FontWeight.bold
//                                   : FontWeight.normal,
//                               fontStyle: isItalic
//                                   ? FontStyle.italic
//                                   : FontStyle.normal,
//                             ),
//                           ),
//                         ),
//                       ),

//                       const SizedBox(height: 24),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: OutlinedButton.icon(
//                               onPressed: () {
//                                 setState(() {
//                                   _texts.remove(editableText);
//                                   _selectedText = null;
//                                 });
//                                 Navigator.pop(context);
//                               },
//                               icon: const Icon(Icons.delete_outline),
//                               label: const Text('Delete'),
//                               style: OutlinedButton.styleFrom(
//                                 foregroundColor: Colors.red[600],
//                                 side: BorderSide(color: Colors.red[200]!),
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 16,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: ElevatedButton.icon(
//                               onPressed: () {
//                                 if (textController.text.isNotEmpty) {
//                                   setState(() {
//                                     editableText.text = textController.text;
//                                     editableText.color = selectedColor;
//                                     editableText.fontSize = selectedFontSize;
//                                     editableText.fontFamily =
//                                         selectedFontFamily;
//                                     editableText.isBold = isBold;
//                                     editableText.isItalic = isItalic;
//                                   });
//                                   Navigator.pop(context);
//                                 }
//                               },
//                               icon: const Icon(Icons.check),
//                               label: const Text('Save'),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: const Color(0xFF6C63FF),
//                                 foregroundColor: Colors.white,
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 16,
//                                 ),
//                                 elevation: 0,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _styleToggleButton({
//     required String label,
//     required IconData icon,
//     required bool isSelected,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         decoration: BoxDecoration(
//           color: isSelected ? const Color(0xFF6C63FF) : Colors.white,
//           border: Border.all(
//             color: isSelected ? const Color(0xFF6C63FF) : Colors.grey[300]!,
//             width: 2,
//           ),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               icon,
//               color: isSelected ? Colors.white : Colors.grey[700],
//               size: 20,
//             ),
//             const SizedBox(width: 8),
//             Text(
//               label,
//               style: TextStyle(
//                 color: isSelected ? Colors.white : Colors.grey[700],
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _modernColorPicker(
//     Color color,
//     Color selectedColor,
//     Function(Color) onTap,
//   ) {
//     final bool isSelected = color == selectedColor;
//     return GestureDetector(
//       onTap: () => onTap(color),
//       child: Container(
//         width: 48,
//         height: 48,
//         decoration: BoxDecoration(
//           color: color,
//           shape: BoxShape.circle,
//           border: Border.all(
//             color: isSelected ? color : Colors.grey[300]!,
//             width: isSelected ? 3 : 2,
//           ),
//           boxShadow: isSelected
//               ? [
//                   BoxShadow(
//                     color: color.withOpacity(0.4),
//                     blurRadius: 8,
//                     spreadRadius: 2,
//                   ),
//                 ]
//               : null,
//         ),
//         child: isSelected
//             ? const Icon(Icons.check, color: Colors.white, size: 24)
//             : null,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.grey[100],
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: const Icon(
//               Icons.arrow_back_ios_new,
//               color: Color(0xFF2D3142),
//               size: 18,
//             ),
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const AppText(
//           'logo_maker',
//           style: TextStyle(
//             color: Color(0xFF2D3142),
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           if (_selectedText != null ||
//               _selectedShape != null ||
//               _selectedElement != null ||
//               _selectedImage != null)
//             IconButton(
//               icon: Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.red[50],
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(
//                   Icons.delete_outline,
//                   color: Colors.red[600],
//                   size: 20,
//                 ),
//               ),
//               onPressed: _deleteSelectedItem,
//             ),
//           IconButton(
//             icon: _isSaving
//                 ? Container(
//                     padding: const EdgeInsets.all(8),
//                     child: const SizedBox(
//                       width: 20,
//                       height: 20,
//                       child: CircularProgressIndicator(strokeWidth: 2),
//                     ),
//                   )
//                 : Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF6C63FF).withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: const Icon(
//                       Icons.file_download_outlined,
//                       color: Color(0xFF6C63FF),
//                       size: 20,
//                     ),
//                   ),
//             onPressed: _isSaving ? null : _saveLogoToGallery,
//           ),
//           const SizedBox(width: 8),

//           TextButton(
//             onPressed: _isSaving ? null : _saveLogoToServer,
//             child: _isSaving
//                 ? const SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: CircularProgressIndicator(strokeWidth: 2),
//                   )
//                 : const AppText(
//                     'save_logo',
//                     style: TextStyle(color: Colors.blue),
//                   ),
//           ),

//           PopupMenuButton<String>(
//             icon: Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.grey[100],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: const Icon(
//                 Icons.more_vert,
//                 color: Color(0xFF2D3142),
//                 size: 20,
//               ),
//             ),
//             itemBuilder: (context) => [
//               const PopupMenuItem(
//                 value: 'share_customers',
//                 child: Row(
//                   children: [
//                     Icon(Icons.people, color: Colors.deepPurple),
//                     SizedBox(width: 8),
//                     Text('Share to Customers'),
//                   ],
//                 ),
//               ),
//             ],
//             onSelected: (value) {
//               if (value == 'save_server') {
//                 _saveLogoToServer();
//               } else if (value == 'share_customers') {
//                 _showCustomerSelectionDialog();
//               }
//             },
//           ),

//           // TextButton(onPressed: (){

//           // }, child: Text('Save Logo',style: TextStyle(color: Colors.blue),)),

//           // IconButton(onPressed: (){

//           // }, icon: Icon(Icons.download))
//         ],
//       ),
//       body: _isLoading
//           ? const Center(
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
//               ),
//             )
//           : Column(
//               children: [
//                 Expanded(
//                   child: Center(
//                     child: Container(
//                       margin: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(20),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.08),
//                             blurRadius: 20,
//                             offset: const Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(20),
//                         child: RepaintBoundary(
//                           key: _canvasKey,
//                           child: GestureDetector(
//                             onTap: _deselectAll,
//                             child: Container(
//                               width: widget.posterSize?.width.toDouble() ?? 400,
//                               height:
//                                   widget.posterSize?.height.toDouble() ?? 400,
//                               decoration: BoxDecoration(color: Colors.white),
//                               child: Stack(
//                                 children: [
//                                   // Background logo template image
//                                   if (widget.image != null &&
//                                       widget.image!.isNotEmpty)
//                                     Positioned.fill(
//                                       child: Image.network(
//                                         widget.image!,
//                                         fit: BoxFit.cover,
//                                         loadingBuilder: (context, child, loadingProgress) {
//                                           if (loadingProgress == null)
//                                             return child;
//                                           return Center(
//                                             child: CircularProgressIndicator(
//                                               value:
//                                                   loadingProgress
//                                                           .expectedTotalBytes !=
//                                                       null
//                                                   ? loadingProgress
//                                                             .cumulativeBytesLoaded /
//                                                         loadingProgress
//                                                             .expectedTotalBytes!
//                                                   : null,
//                                             ),
//                                           );
//                                         },
//                                         errorBuilder:
//                                             (context, error, stackTrace) {
//                                               return const Center(
//                                                 child: Icon(
//                                                   Icons.error_outline,
//                                                   size: 48,
//                                                 ),
//                                               );
//                                             },
//                                       ),
//                                     ),
//                                   // Editable elements on top
//                                   ..._images.map(
//                                     (image) => _buildEditableImage(image),
//                                   ),
//                                   ..._texts.map(
//                                     (text) => _buildEditableText(text),
//                                   ),
//                                   ..._shapes.map(
//                                     (shape) => _buildEditableShape(shape),
//                                   ),
//                                   ..._elements.map(
//                                     (element) => _buildEditableElement(element),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),

//                 // Expanded(
//                 //   child: Container(
//                 //     width:
//                 //         widget.posterSize?.width.toDouble() ?? double.infinity,
//                 //     height:
//                 //         widget.posterSize?.height.toDouble() ?? double.infinity,
//                 //     decoration: BoxDecoration(
//                 //       color: Colors.white, // Default background if no image
//                 //       image: widget.image != null
//                 //           ? DecorationImage(
//                 //               image: NetworkImage(widget.image!),
//                 //               fit: BoxFit.cover,
//                 //             )
//                 //           : null,
//                 //     ),
//                 //     child: Stack(
//                 //       children: [
//                 //         ..._images.map((image) => _buildEditableImage(image)),
//                 //         ..._texts.map((text) => _buildEditableText(text)),
//                 //         ..._shapes.map((shape) => _buildEditableShape(shape)),
//                 //         ..._elements.map(
//                 //           (element) => _buildEditableElement(element),
//                 //         ),
//                 //       ],
//                 //     ),
//                 //   ),
//                 //   // child: Container(
//                 //   //   margin: const EdgeInsets.all(16),
//                 //   //   decoration: BoxDecoration(
//                 //   //     color: Colors.white,
//                 //   //     borderRadius: BorderRadius.circular(20),
//                 //   //     boxShadow: [
//                 //   //       BoxShadow(
//                 //   //         color: Colors.black.withOpacity(0.08),
//                 //   //         blurRadius: 20,
//                 //   //         offset: const Offset(0, 4),
//                 //   //       ),
//                 //   //     ],
//                 //   //   ),
//                 //   //   child: ClipRRect(
//                 //   //     borderRadius: BorderRadius.circular(20),
//                 //   //     child: RepaintBoundary(
//                 //   //       key: _canvasKey,
//                 //   //       child: GestureDetector(
//                 //   //         onTap: _deselectAll,
//                 //   //         child: Container(
//                 //   //           width: double.infinity,
//                 //   //           height: double.infinity,
//                 //   //           decoration: BoxDecoration(
//                 //   //             image: DecorationImage(
//                 //   //               image: NetworkImage(widget.image),
//                 //   //               fit: BoxFit.cover,
//                 //   //             ),
//                 //   //           ),
//                 //   //           child: Stack(
//                 //   //             children: [
//                 //   //               ..._images.map((image) => _buildEditableImage(image)),
//                 //   //               ..._texts.map((text) => _buildEditableText(text)),
//                 //   //               ..._shapes.map((shape) => _buildEditableShape(shape)),
//                 //   //               ..._elements.map((element) => _buildEditableElement(element)),
//                 //   //             ],
//                 //   //           ),
//                 //   //         ),
//                 //   //       ),
//                 //   //     ),
//                 //   //   ),
//                 //   // ),
//                 // ),
//                 Container(
//                   padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: const BorderRadius.vertical(
//                       top: Radius.circular(24),
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 10,
//                         offset: const Offset(0, -2),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Container(
//                         width: 40,
//                         height: 4,
//                         decoration: BoxDecoration(
//                           color: Colors.grey[300],
//                           borderRadius: BorderRadius.circular(2),
//                         ),
//                       ),
//                       const SizedBox(height: 20),

//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           _buildModernToolButton(
//                             icon: Icons.text_fields,
//                             label: 'text',
//                             gradient: const LinearGradient(
//                               colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
//                             ),
//                             onTap: _showAddTextPopup,
//                           ),
//                           _buildModernToolButton(
//                             icon: Icons.image_outlined,
//                             label: 'image',
//                             gradient: const LinearGradient(
//                               colors: [Color(0xFFFF6B6B), Color(0xFFEE5A6F)],
//                             ),
//                             onTap: _pickImage,
//                           ),
//                           _buildModernToolButton(
//                             icon: Icons.category_outlined,
//                             label: 'shapes',
//                             gradient: const LinearGradient(
//                               colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
//                             ),
//                             onTap: () => _showShapesBottomSheet(),
//                           ),
//                           _buildModernToolButton(
//                             icon: Icons.stars_outlined,
//                             label: 'elements',
//                             gradient: const LinearGradient(
//                               colors: [Color(0xFFFFA502), Color(0xFFFF8C42)],
//                             ),
//                             onTap: () => _showElementsBottomSheet(),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }

//   Widget _buildModernToolButton({
//     required IconData icon,
//     required String label,
//     required Gradient gradient,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 64,
//             height: 64,
//             decoration: BoxDecoration(
//               gradient: gradient,
//               borderRadius: BorderRadius.circular(18),
//               boxShadow: [
//                 BoxShadow(
//                   color: (gradient.colors.first).withOpacity(0.3),
//                   blurRadius: 12,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Icon(icon, color: Colors.white, size: 28),
//           ),
//           const SizedBox(height: 8),
//           AppText(
//             label,
//             style: const TextStyle(
//               fontSize: 13,
//               color: Color(0xFF2D3142),
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showShapesBottomSheet() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
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
//             const Text(
//               'Choose Shape',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF2D3142),
//               ),
//             ),
//             const SizedBox(height: 24),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildModernShapeOption(
//                   ShapeType.circle,
//                   Icons.circle_outlined,
//                   'Circle',
//                 ),
//                 _buildModernShapeOption(
//                   ShapeType.rectangle,
//                   Icons.crop_square_rounded,
//                   'Square',
//                 ),
//                 _buildModernShapeOption(
//                   ShapeType.triangle,
//                   Icons.change_history,
//                   'Triangle',
//                 ),
//                 _buildModernShapeOption(
//                   ShapeType.star,
//                   Icons.star_outline,
//                   'Star',
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildModernShapeOption(
//     ShapeType shapeType,
//     IconData icon,
//     String label,
//   ) {
//     return GestureDetector(
//       onTap: () {
//         _addShape(shapeType);
//         Navigator.pop(context);
//       },
//       child: Column(
//         children: [
//           Container(
//             width: 70,
//             height: 70,
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
//               ),
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color(0xFF4ECDC4).withOpacity(0.3),
//                   blurRadius: 10,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Icon(icon, color: Colors.white, size: 32),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF2D3142),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showElementsBottomSheet() {
//     final elements = [
//       {'icon': Icons.favorite, 'name': 'Heart'},
//       {'icon': Icons.star, 'name': 'Star'},
//       {'icon': Icons.lightbulb_outline, 'name': 'Bulb'},
//       {'icon': Icons.music_note, 'name': 'Music'},
//       {'icon': Icons.camera_alt_outlined, 'name': 'Camera'},
//       {'icon': Icons.phone_outlined, 'name': 'Phone'},
//       {'icon': Icons.email_outlined, 'name': 'Email'},
//       {'icon': Icons.location_on_outlined, 'name': 'Location'},
//     ];

//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
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
//             const Text(
//               'Choose Element',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF2D3142),
//               ),
//             ),
//             const SizedBox(height: 24),
//             SizedBox(
//               height: 220,
//               child: GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 4,
//                   crossAxisSpacing: 16,
//                   mainAxisSpacing: 16,
//                   childAspectRatio: 0.85,
//                 ),
//                 itemCount: elements.length,
//                 itemBuilder: (context, index) {
//                   final element = elements[index];
//                   return GestureDetector(
//                     onTap: () {
//                       _addElement(element);
//                       Navigator.pop(context);
//                     },
//                     child: Column(
//                       children: [
//                         Container(
//                           width: 50,
//                           height: 50,
//                           decoration: BoxDecoration(
//                             gradient: const LinearGradient(
//                               colors: [Color(0xFFFFA502), Color(0xFFFF8C42)],
//                             ),
//                             borderRadius: BorderRadius.circular(14),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: const Color(0xFFFFA502).withOpacity(0.3),
//                                 blurRadius: 8,
//                                 offset: const Offset(0, 3),
//                               ),
//                             ],
//                           ),
//                           child: Icon(
//                             element['icon'] as IconData,
//                             color: Colors.white,
//                             size: 26,
//                           ),
//                         ),
//                         const SizedBox(height: 6),
//                         Text(
//                           element['name'] as String,
//                           style: const TextStyle(
//                             fontSize: 11,
//                             fontWeight: FontWeight.w600,
//                             color: Color(0xFF2D3142),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEditableImage(_EditableImage editableImage) {
//     return Positioned(
//       left: editableImage.offset.dx,
//       top: editableImage.offset.dy,
//       child: GestureDetector(
//         onTap: () => _selectImage(editableImage),
//         onDoubleTap: () => _showEditImagePopup(editableImage),
//         onPanUpdate: (details) {
//           setState(() {
//             editableImage.offset += details.delta;
//           });
//         },
//         child: Container(
//           width: editableImage.size.width,
//           height: editableImage.size.height,
//           decoration: BoxDecoration(
//             border: _selectedImage == editableImage
//                 ? Border.all(color: const Color(0xFF6C63FF), width: 3)
//                 : null,
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: _selectedImage == editableImage
//                 ? [
//                     BoxShadow(
//                       color: const Color(0xFF6C63FF).withOpacity(0.3),
//                       blurRadius: 10,
//                       spreadRadius: 2,
//                     ),
//                   ]
//                 : null,
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: Image.file(editableImage.imageFile, fit: BoxFit.cover),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildEditableText(_EditableText editableText) {
//     return Positioned(
//       left: editableText.offset.dx,
//       top: editableText.offset.dy,
//       child: GestureDetector(
//         onTap: () => _selectText(editableText),
//         onDoubleTap: () => _showEditTextPopup(editableText),
//         onPanUpdate: (details) {
//           setState(() {
//             editableText.offset += details.delta;
//           });
//         },
//         child: Container(
//           padding: _selectedText == editableText
//               ? const EdgeInsets.all(8)
//               : null,
//           decoration: _selectedText == editableText
//               ? BoxDecoration(
//                   border: Border.all(color: const Color(0xFF6C63FF), width: 2),
//                   borderRadius: BorderRadius.circular(8),
//                   color: const Color(0xFF6C63FF).withOpacity(0.1),
//                 )
//               : null,
//           child: Text(
//             editableText.text,
//             style: TextStyle(
//               color: editableText.color,
//               fontSize: editableText.fontSize,
//               fontFamily: editableText.fontFamily,
//               fontWeight: editableText.isBold
//                   ? FontWeight.bold
//                   : FontWeight.normal,
//               fontStyle: editableText.isItalic
//                   ? FontStyle.italic
//                   : FontStyle.normal,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildEditableShape(_EditableShape editableShape) {
//     return Positioned(
//       left: editableShape.offset.dx,
//       top: editableShape.offset.dy,
//       child: GestureDetector(
//         onTap: () => _selectShape(editableShape),
//         onDoubleTap: () => _showEditShapePopup(editableShape),
//         onPanUpdate: (details) {
//           setState(() {
//             editableShape.offset += details.delta;
//           });
//         },
//         child: Container(
//           width: editableShape.size.width,
//           height: editableShape.size.height,
//           decoration: BoxDecoration(
//             border: _selectedShape == editableShape
//                 ? Border.all(color: const Color(0xFF6C63FF), width: 3)
//                 : null,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: _buildShapeWidget(editableShape),
//         ),
//       ),
//     );
//   }

//   Widget _buildEditableElement(_EditableElement editableElement) {
//     return Positioned(
//       left: editableElement.offset.dx,
//       top: editableElement.offset.dy,
//       child: GestureDetector(
//         onTap: () => _selectElement(editableElement),
//         onDoubleTap: () => _showEditElementPopup(editableElement),
//         onPanUpdate: (details) {
//           setState(() {
//             editableElement.offset += details.delta;
//           });
//         },
//         child: Container(
//           width: editableElement.size.width,
//           height: editableElement.size.height,
//           decoration: BoxDecoration(
//             border: _selectedElement == editableElement
//                 ? Border.all(color: const Color(0xFF6C63FF), width: 3)
//                 : null,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(
//             editableElement.icon,
//             color: editableElement.color,
//             size: editableElement.size.width * 0.8,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildShapeWidget(_EditableShape shape) {
//     switch (shape.shapeType) {
//       case ShapeType.circle:
//         return Container(
//           decoration: BoxDecoration(color: shape.color, shape: BoxShape.circle),
//         );
//       case ShapeType.rectangle:
//         return Container(
//           decoration: BoxDecoration(
//             color: shape.color,
//             borderRadius: BorderRadius.circular(8),
//           ),
//         );
//       case ShapeType.triangle:
//         return CustomPaint(
//           painter: TrianglePainter(shape.color),
//           size: shape.size,
//         );
//       case ShapeType.star:
//         return CustomPaint(painter: StarPainter(shape.color), size: shape.size);
//     }
//   }
// }

// class _EditableImage {
//   File imageFile;
//   Offset offset;
//   Size size;

//   _EditableImage({
//     required this.imageFile,
//     required this.offset,
//     required this.size,
//   });
// }

// class _EditableText {
//   String text;
//   Color color;
//   double fontSize;
//   String fontFamily;
//   bool isBold;
//   bool isItalic;
//   Offset offset;

//   _EditableText({
//     required this.text,
//     required this.color,
//     required this.fontSize,
//     required this.fontFamily,
//     required this.isBold,
//     required this.isItalic,
//     required this.offset,
//   });
// }

// class _EditableShape {
//   ShapeType shapeType;
//   Color color;
//   Size size;
//   Offset offset;

//   _EditableShape({
//     required this.shapeType,
//     required this.color,
//     required this.size,
//     required this.offset,
//   });
// }

// class _EditableElement {
//   IconData icon;
//   String name;
//   Color color;
//   Size size;
//   Offset offset;

//   _EditableElement({
//     required this.icon,
//     required this.name,
//     required this.color,
//     required this.size,
//     required this.offset,
//   });
// }

// enum ShapeType { circle, rectangle, triangle, star }

// class TrianglePainter extends CustomPainter {
//   final Color color;

//   TrianglePainter(this.color);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = color
//       ..style = PaintingStyle.fill;

//     final Path path = Path();
//     path.moveTo(size.width / 2, 0);
//     path.lineTo(0, size.height);
//     path.lineTo(size.width, size.height);
//     path.close();

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

// class StarPainter extends CustomPainter {
//   final Color color;

//   StarPainter(this.color);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = color
//       ..style = PaintingStyle.fill;

//     final Path path = Path();
//     final double centerX = size.width / 2;
//     final double centerY = size.height / 2;
//     final double outerRadius = math.min(centerX, centerY);
//     final double innerRadius = outerRadius * 0.4;

//     for (int i = 0; i < 10; i++) {
//       final double angle = (i * math.pi) / 5;
//       final double radius = i.isEven ? outerRadius : innerRadius;
//       final double x = centerX + radius * math.cos(angle - math.pi / 2);
//       final double y = centerY + radius * math.sin(angle - math.pi / 2);

//       if (i == 0) {
//         path.moveTo(x, y);
//       } else {
//         path.lineTo(x, y);
//       }
//     }
//     path.close();
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

// import 'dart:async';
// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:gal/gal.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:math' as math;
// import 'package:posternova/helper/storage_helper.dart';
// import 'package:posternova/models/create_poster_model.dart';
// import 'package:posternova/providers/auth/login_provider.dart';
// import 'package:posternova/providers/customer/customer_provider.dart';
// import 'package:posternova/views/chat/chat_module.dart';
// import 'package:posternova/widgets/language_widget.dart';
// import 'package:provider/provider.dart';

// // ─────────────────────────────────────────────
// //  DATA MODELS
// // ─────────────────────────────────────────────

// class LogoTextItem {
//   String id;
//   String text;
//   Offset position;
//   double fontSize;
//   Color color;
//   Color backgroundColor;
//   bool hasBorder;
//   bool hasShadow;
//   bool isBold;
//   bool isItalic;
//   bool isUnderline;
//   TextAlign align;
//   double rotation;
//   String fontFamily;

//   LogoTextItem({
//     required this.id,
//     required this.text,
//     this.position = const Offset(100, 150),
//     this.fontSize = 24,
//     this.color = Colors.black,
//     this.backgroundColor = Colors.transparent,
//     this.hasBorder = false,
//     this.hasShadow = false,
//     this.isBold = false,
//     this.isItalic = false,
//     this.isUnderline = false,
//     this.align = TextAlign.center,
//     this.rotation = 0,
//     this.fontFamily = 'Roboto',
//   });

//   LogoTextItem copyWith({
//     String? id,
//     String? text,
//     Offset? position,
//     double? fontSize,
//     Color? color,
//     Color? backgroundColor,
//     bool? hasBorder,
//     bool? hasShadow,
//     bool? isBold,
//     bool? isItalic,
//     bool? isUnderline,
//     TextAlign? align,
//     double? rotation,
//     String? fontFamily,
//   }) {
//     return LogoTextItem(
//       id: id ?? this.id,
//       text: text ?? this.text,
//       position: position ?? this.position,
//       fontSize: fontSize ?? this.fontSize,
//       color: color ?? this.color,
//       backgroundColor: backgroundColor ?? this.backgroundColor,
//       hasBorder: hasBorder ?? this.hasBorder,
//       hasShadow: hasShadow ?? this.hasShadow,
//       isBold: isBold ?? this.isBold,
//       isItalic: isItalic ?? this.isItalic,
//       isUnderline: isUnderline ?? this.isUnderline,
//       align: align ?? this.align,
//       rotation: rotation ?? this.rotation,
//       fontFamily: fontFamily ?? this.fontFamily,
//     );
//   }
// }

// class LogoImageItem {
//   final String id;
//   File imageFile;
//   Offset position;
//   Size size;
//   double rotation;

//   LogoImageItem({
//     required this.id,
//     required this.imageFile,
//     this.position = const Offset(100, 100),
//     this.size = const Size(150, 150),
//     this.rotation = 0,
//   });

//   LogoImageItem copyWith({
//     File? imageFile,
//     Offset? position,
//     Size? size,
//     double? rotation,
//   }) {
//     return LogoImageItem(
//       id: id,
//       imageFile: imageFile ?? this.imageFile,
//       position: position ?? this.position,
//       size: size ?? this.size,
//       rotation: rotation ?? this.rotation,
//     );
//   }
// }

// class LogoShapeItem {
//   final String id;
//   ShapeType shapeType;
//   Color color;
//   Size size;
//   Offset position;
//   double rotation;

//   LogoShapeItem({
//     required this.id,
//     required this.shapeType,
//     this.color = const Color(0xFF6C63FF),
//     this.size = const Size(80, 80),
//     this.position = const Offset(100, 100),
//     this.rotation = 0,
//   });

//   LogoShapeItem copyWith({
//     ShapeType? shapeType,
//     Color? color,
//     Size? size,
//     Offset? position,
//     double? rotation,
//   }) {
//     return LogoShapeItem(
//       id: id,
//       shapeType: shapeType ?? this.shapeType,
//       color: color ?? this.color,
//       size: size ?? this.size,
//       position: position ?? this.position,
//       rotation: rotation ?? this.rotation,
//     );
//   }
// }

// class LogoElementItem {
//   final String id;
//   IconData icon;
//   String name;
//   Color color;
//   Size size;
//   Offset position;
//   double rotation;

//   LogoElementItem({
//     required this.id,
//     required this.icon,
//     required this.name,
//     this.color = const Color(0xFFFFA502),
//     this.size = const Size(60, 60),
//     this.position = const Offset(100, 100),
//     this.rotation = 0,
//   });

//   LogoElementItem copyWith({
//     IconData? icon,
//     String? name,
//     Color? color,
//     Size? size,
//     Offset? position,
//     double? rotation,
//   }) {
//     return LogoElementItem(
//       id: id,
//       icon: icon ?? this.icon,
//       name: name ?? this.name,
//       color: color ?? this.color,
//       size: size ?? this.size,
//       position: position ?? this.position,
//       rotation: rotation ?? this.rotation,
//     );
//   }
// }

// enum ShapeType { circle, rectangle, triangle, star }

// // ─────────────────────────────────────────────
// //  MAIN LOGO MAKER SCREEN
// // ─────────────────────────────────────────────

// class MakeLogo extends StatefulWidget {
//   final String? image;
//   final String? id;
//   final String? editedImage;
//   final String? categoryId;
//   final PosterSize? posterSize;

//   const MakeLogo({
//     super.key,
//     this.image,
//     this.id,
//     this.editedImage,
//     this.categoryId,
//     this.posterSize,
//   });

//   @override
//   State<MakeLogo> createState() => _MakeLogoState();
// }

// class _MakeLogoState extends State<MakeLogo> {
//   // ── Elements ───────────────────────────────────────────────────
//   final List<LogoTextItem> _texts = [];
//   final List<LogoImageItem> _images = [];
//   final List<LogoShapeItem> _shapes = [];
//   final List<LogoElementItem> _elements = [];

//   // ── Selection state ────────────────────────────────────────────
//   String? _selectedTextId;
//   String? _selectedImageId;
//   String? _selectedShapeId;
//   String? _selectedElementId;

//   // ── Gesture tracking for resizing ─────────────────────────────
//   String? _resizingTextId;
//   Offset _resizeStartOffset = Offset.zero;
//   double _resizeStartFontSize = 24;

//   // ── UI state ──────────────────────────────────────────────────
//   final GlobalKey _canvasKey = GlobalKey();
//   bool _isLoading = false;
//   bool _isSaving = false;
//   bool _showToolsPanel = true;

//   // ── User data ─────────────────────────────────────────────────
//   String? userId;
//   String? phoneNumber;
//   String? email;

//   // ── Font families ─────────────────────────────────────────────
//   final List<String> _fontFamilies = [
//     'Roboto',
//     'Arial',
//     'Times New Roman',
//     'Courier New',
//     'Georgia',
//     'Verdana',
//     'Comic Sans MS',
//     'Impact',
//     'Trebuchet MS',
//     'Lucida Grande',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   // ════════════════════════════════════════════════════════════════
//   //  USER DATA
//   // ════════════════════════════════════════════════════════════════

//   Future<void> _loadUserData() async {
//     setState(() => _isLoading = true);
//     try {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       final userData = await AuthPreferences.getUserData();

//       setState(() {
//         userId = authProvider.user?.user.id ?? userData?.user.id;
//         phoneNumber = userData?.user.mobile;
//         email = userData?.user.email;
//       });
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   // ════════════════════════════════════════════════════════════════
//   //  CAPTURE & SAVE
//   // ════════════════════════════════════════════════════════════════

//   Future<Uint8List?> _captureCanvasAsImage() async {
//     try {
//       await Future.delayed(const Duration(milliseconds: 20));

//       final RenderRepaintBoundary? boundary =
//           _canvasKey.currentContext?.findRenderObject()
//               as RenderRepaintBoundary?;

//       if (boundary == null) return null;

//       final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
//       final ByteData? byteData = await image.toByteData(
//         format: ui.ImageByteFormat.png,
//       );

//       return byteData?.buffer.asUint8List();
//     } catch (e) {
//       debugPrint('Error capturing canvas: $e');
//       return null;
//     }
//   }

//   Future<void> _saveLogoToGallery() async {
//     setState(() => _isSaving = true);

//     try {
//       final Uint8List? logoImage = await _captureCanvasAsImage();

//       if (logoImage == null) {
//         throw Exception('Failed to capture the canvas');
//       }

//       await Gal.putImageBytes(
//         logoImage,
//         name: 'Logo_${DateTime.now().millisecondsSinceEpoch}',
//         album: 'Logo Maker',
//       );

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Row(
//               children: [
//                 Icon(Icons.check_circle, color: Colors.white),
//                 SizedBox(width: 12),
//                 Text('Logo saved to gallery!'),
//               ],
//             ),
//             backgroundColor: Color(0xFF6C63FF),
//             behavior: SnackBarBehavior.floating,
//             duration: Duration(seconds: 2),
//           ),
//         );
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
//       setState(() => _isSaving = false);
//     }
//   }

//   Future<void> _saveLogoToServer() async {
//     setState(() => _isSaving = true);

//     try {
//       final Uint8List? logoImage = await _captureCanvasAsImage();

//       if (logoImage == null) {
//         throw Exception('Failed to capture the canvas');
//       }

//       final userData = await AuthPreferences.getUserData();
//       final userId = userData?.user.id;

//       if (userId == null) {
//         throw Exception('User not logged in');
//       }

//       if (widget.id == null || widget.id!.isEmpty) {
//         throw Exception('Logo ID is missing');
//       }

//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse('http://31.97.206.144:4061/api/users/user-history'),
//       );

//       request.fields['userId'] = userId;
//       request.fields['logoId'] = widget.id!;

//       request.files.add(
//         http.MultipartFile.fromBytes(
//           'editedImage',
//           logoImage,
//           filename: 'logo_${DateTime.now().millisecondsSinceEpoch}.png',
//         ),
//       );

//       final response = await request.send();
//       final responseBody = await response.stream.bytesToString();

//       if (!mounted) return;

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Row(
//               children: [
//                 Icon(Icons.check_circle, color: Colors.white),
//                 SizedBox(width: 12),
//                 Text('Logo saved successfully!'),
//               ],
//             ),
//             backgroundColor: Color(0xFF6C63FF),
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       } else {
//         throw Exception('Server error: ${response.statusCode}');
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to save: ${e.toString()}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) setState(() => _isSaving = false);
//     }
//   }

//   // ════════════════════════════════════════════════════════════════
//   //  ADD ELEMENTS
//   // ════════════════════════════════════════════════════════════════

//   void _addText() {
//     final item = LogoTextItem(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       text: 'Tap to edit',
//       position: Offset(100, 150 + _texts.length * 40.0),
//       fontSize: 24,
//       color: Colors.black,
//     );
//     setState(() {
//       _texts.add(item);
//       _selectedTextId = item.id;
//     });
//     _openTextEditor(item);
//   }

//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _images.add(
//           LogoImageItem(
//             id: DateTime.now().millisecondsSinceEpoch.toString(),
//             imageFile: File(pickedFile.path),
//             position: const Offset(100, 100),
//             size: const Size(150, 150),
//           ),
//         );
//       });
//     }
//   }

//   void _addShape(ShapeType shapeType) {
//     setState(() {
//       _shapes.add(
//         LogoShapeItem(
//           id: DateTime.now().millisecondsSinceEpoch.toString(),
//           shapeType: shapeType,
//           color: const Color(0xFF6C63FF),
//           position: const Offset(100, 100),
//           size: const Size(80, 80),
//         ),
//       );
//     });
//   }

//   void _addElement(Map<String, dynamic> elementData) {
//     setState(() {
//       _elements.add(
//         LogoElementItem(
//           id: DateTime.now().millisecondsSinceEpoch.toString(),
//           icon: elementData['icon'],
//           name: elementData['name'],
//           color: const Color(0xFFFFA502),
//           position: const Offset(100, 100),
//           size: const Size(60, 60),
//         ),
//       );
//     });
//   }

//   // ════════════════════════════════════════════════════════════════
//   //  DELETE SELECTED ITEM
//   // ════════════════════════════════════════════════════════════════

//   void _deleteSelectedItem() {
//     setState(() {
//       if (_selectedTextId != null) {
//         _texts.removeWhere((t) => t.id == _selectedTextId);
//         _selectedTextId = null;
//       }
//       if (_selectedImageId != null) {
//         _images.removeWhere((i) => i.id == _selectedImageId);
//         _selectedImageId = null;
//       }
//       if (_selectedShapeId != null) {
//         _shapes.removeWhere((s) => s.id == _selectedShapeId);
//         _selectedShapeId = null;
//       }
//       if (_selectedElementId != null) {
//         _elements.removeWhere((e) => e.id == _selectedElementId);
//         _selectedElementId = null;
//       }
//     });
//   }

//   // ════════════════════════════════════════════════════════════════
//   //  SELECTION METHODS
//   // ════════════════════════════════════════════════════════════════

//   void _selectText(String id) {
//     setState(() {
//       _selectedTextId = id;
//       _selectedImageId = null;
//       _selectedShapeId = null;
//       _selectedElementId = null;
//     });
//   }

//   void _selectImage(String id) {
//     setState(() {
//       _selectedImageId = id;
//       _selectedTextId = null;
//       _selectedShapeId = null;
//       _selectedElementId = null;
//     });
//   }

//   void _selectShape(String id) {
//     setState(() {
//       _selectedShapeId = id;
//       _selectedTextId = null;
//       _selectedImageId = null;
//       _selectedElementId = null;
//     });
//   }

//   void _selectElement(String id) {
//     setState(() {
//       _selectedElementId = id;
//       _selectedTextId = null;
//       _selectedImageId = null;
//       _selectedShapeId = null;
//     });
//   }

//   void _deselectAll() {
//     setState(() {
//       _selectedTextId = null;
//       _selectedImageId = null;
//       _selectedShapeId = null;
//       _selectedElementId = null;
//     });
//   }

//   // ════════════════════════════════════════════════════════════════
//   //  TEXT EDITING
//   // ════════════════════════════════════════════════════════════════

//   void _openTextEditor(LogoTextItem item) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => _TextEditorSheet(
//         item: item,
//         fontFamilies: _fontFamilies,
//         onChanged: (updated) {
//           setState(() {
//             final idx = _texts.indexWhere((t) => t.id == updated.id);
//             if (idx != -1) _texts[idx] = updated;
//           });
//         },
//       ),
//     );
//   }

//   // ════════════════════════════════════════════════════════════════
//   //  SHARE WITH CUSTOMERS
//   // ════════════════════════════════════════════════════════════════

//   Future<void> _shareWithCustomers() async {
//     final customerProvider = Provider.of<CreateCustomerProvider>(
//       context,
//       listen: false,
//     );

//     if (customerProvider.customers.isEmpty) {
//       await customerProvider.fetchUser(userId.toString());
//     }

//     if (customerProvider.customers.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('No customers available. Please add customers first.'),
//           backgroundColor: Colors.orange,
//         ),
//       );
//       return;
//     }

//     // Show customer selection dialog
//     final selectedCustomers = await _showCustomerSelectionDialog(
//       customerProvider,
//     );
//     if (selectedCustomers.isEmpty) return;

//     // Capture and share logo
//     final logoImage = await _captureCanvasAsImage();
//     if (logoImage == null) return;

//     final directory = await getTemporaryDirectory();
//     final file = File(
//       '${directory.path}/logo_share_${DateTime.now().millisecondsSinceEpoch}.png',
//     );
//     await file.writeAsBytes(logoImage);

//     if (mounted) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ChatModule(
//             posterImagePath: file.path,
//             selectedCustomers: selectedCustomers,
//           ),
//         ),
//       );
//     }
//   }

//   Future<List<Map<String, dynamic>>> _showCustomerSelectionDialog(
//     CreateCustomerProvider customerProvider,
//   ) async {
//     final completer = Completer<List<Map<String, dynamic>>>();

//     List<String> religions = customerProvider.customers
//         .where(
//           (c) =>
//               c['religion'] != null &&
//               c['religion'].toString().trim().isNotEmpty,
//         )
//         .map((c) => c['religion'].toString().trim())
//         .toSet()
//         .toList();

//     religions.sort();
//     religions.insert(0, 'All');

//     String selectedReligion = 'All';
//     Set<String> selectedCustomerIds = {};

//     List<Map<String, dynamic>> filteredCustomers() {
//       if (selectedReligion == 'All') {
//         return customerProvider.customers;
//       } else {
//         return customerProvider.customers
//             .where((c) => c['religion']?.toString() == selectedReligion)
//             .toList();
//       }
//     }

//     showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setDialogState) {
//           final filtered = filteredCustomers();
//           final bool allSelected =
//               filtered.isNotEmpty &&
//               selectedCustomerIds.length == filtered.length &&
//               filtered.every((c) => selectedCustomerIds.contains(c['_id']));

//           return AlertDialog(
//             title: const Text('Share with Customers'),
//             content: SizedBox(
//               width: MediaQuery.of(context).size.width * 0.9,
//               height: MediaQuery.of(context).size.height * 0.7,
//               child: Column(
//                 children: [
//                   // Religion filter
//                   SizedBox(
//                     height: 40,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: religions.length,
//                       itemBuilder: (_, index) {
//                         final r = religions[index];
//                         final isActive = r == selectedReligion;
//                         return Padding(
//                           padding: const EdgeInsets.only(right: 8),
//                           child: FilterChip(
//                             label: Text(r),
//                             selected: isActive,
//                             onSelected: (_) {
//                               setDialogState(() {
//                                 selectedReligion = r;
//                                 selectedCustomerIds.clear();
//                               });
//                             },
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   // Select All button
//                   Row(
//                     children: [
//                       const Spacer(),
//                       TextButton(
//                         onPressed: () {
//                           setDialogState(() {
//                             if (allSelected) {
//                               selectedCustomerIds.clear();
//                             } else {
//                               selectedCustomerIds = filtered
//                                   .map((c) => c['_id'] as String)
//                                   .toSet();
//                             }
//                           });
//                         },
//                         child: Text(
//                           allSelected ? 'Deselect All' : 'Select All',
//                         ),
//                       ),
//                     ],
//                   ),
//                   // Customer list
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: filtered.length,
//                       itemBuilder: (_, index) {
//                         final customer = filtered[index];
//                         final customerId = customer['_id'] as String;
//                         final isSelected = selectedCustomerIds.contains(
//                           customerId,
//                         );
//                         final name = customer['name']?.toString() ?? 'Unknown';
//                         final mobile = customer['mobile']?.toString();

//                         return CheckboxListTile(
//                           title: Text(name),
//                           subtitle: mobile != null ? Text(mobile) : null,
//                           value: isSelected,
//                           onChanged: (_) {
//                             setDialogState(() {
//                               if (isSelected) {
//                                 selectedCustomerIds.remove(customerId);
//                               } else {
//                                 selectedCustomerIds.add(customerId);
//                               }
//                             });
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('Cancel'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   final selectedCustomers = customerProvider.customers
//                       .where((c) => selectedCustomerIds.contains(c['_id']))
//                       .toList();
//                   Navigator.pop(context);
//                   completer.complete(selectedCustomers);
//                 },
//                 child: Text('Share (${selectedCustomerIds.length})'),
//               ),
//             ],
//           );
//         },
//       ),
//     );

//     return completer.future;
//   }

//   // ════════════════════════════════════════════════════════════════
//   //  BUILD METHODS
//   // ════════════════════════════════════════════════════════════════

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA),
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
//                 _buildBottomTools(),
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
//       title: const AppText(
//         'logo_maker',
//         style: TextStyle(
//           color: Color(0xFF2D3142),
//           fontWeight: FontWeight.bold,
//           fontSize: 20,
//         ),
//       ),
//       centerTitle: true,
//       actions: [
//         if (_selectedTextId != null ||
//             _selectedImageId != null ||
//             _selectedShapeId != null ||
//             _selectedElementId != null)
//           IconButton(
//             icon: Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.red[50],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(
//                 Icons.delete_outline,
//                 color: Colors.red[600],
//                 size: 20,
//               ),
//             ),
//             onPressed: _deleteSelectedItem,
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
//         TextButton(
//           onPressed: _isSaving ? null : _saveLogoToServer,
//           child: _isSaving
//               ? const SizedBox(
//                   width: 20,
//                   height: 20,
//                   child: CircularProgressIndicator(strokeWidth: 2),
//                 )
//               : const AppText(
//                   'save_logo',
//                   style: TextStyle(color: Colors.blue),
//                 ),
//         ),
//         PopupMenuButton<String>(
//           icon: Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.grey[100],
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: const Icon(
//               Icons.more_vert,
//               color: Color(0xFF2D3142),
//               size: 20,
//             ),
//           ),
//           itemBuilder: (context) => [
//             const PopupMenuItem(
//               value: 'share_customers',
//               child: Row(
//                 children: [
//                   Icon(Icons.people, color: Colors.deepPurple),
//                   SizedBox(width: 8),
//                   Text('Share to Customers'),
//                 ],
//               ),
//             ),
//           ],
//           onSelected: (value) {
//             if (value == 'share_customers') _shareWithCustomers();
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildCanvas() {
//     return Center(
//       child: Container(
//         margin: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.08),
//               blurRadius: 20,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(20),
//           child: RepaintBoundary(
//             key: _canvasKey,
//             child: GestureDetector(
//               onTap: _deselectAll,
//               child: Container(
//                 width: widget.posterSize?.width.toDouble() ?? 400,
//                 height: widget.posterSize?.height.toDouble() ?? 400,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   image: widget.image != null && widget.image!.isNotEmpty
//                       ? DecorationImage(
//                           image: NetworkImage(widget.image!),
//                           fit: BoxFit.cover,
//                         )
//                       : null,
//                 ),
//                 child: Stack(
//                   children: [
//                     // Images
//                     ..._images.map((image) => _buildImageWidget(image)),
//                     // Shapes
//                     ..._shapes.map((shape) => _buildShapeWidget(shape)),
//                     // Elements (icons)
//                     ..._elements.map((element) => _buildElementWidget(element)),
//                     // Texts
//                     ..._texts.map((text) => _buildTextWidget(text)),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildImageWidget(LogoImageItem item) {
//     final isSelected = _selectedImageId == item.id;
//     return Positioned(
//       left: item.position.dx,
//       top: item.position.dy,
//       child: GestureDetector(
//         onTap: () => _selectImage(item.id),
//         onDoubleTap: () => _showEditImagePopup(item),
//         onPanUpdate: (details) {
//           setState(() {
//             final idx = _images.indexWhere((i) => i.id == item.id);
//             if (idx != -1) {
//               _images[idx] = _images[idx].copyWith(
//                 position: item.position + details.delta,
//               );
//             }
//           });
//         },
//         child: Transform.rotate(
//           angle: item.rotation,
//           child: Container(
//             width: item.size.width,
//             height: item.size.height,
//             decoration: BoxDecoration(
//               border: isSelected
//                   ? Border.all(color: const Color(0xFF6C63FF), width: 3)
//                   : null,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: isSelected
//                   ? [
//                       BoxShadow(
//                         color: const Color(0xFF6C63FF).withOpacity(0.3),
//                         blurRadius: 10,
//                         spreadRadius: 2,
//                       ),
//                     ]
//                   : null,
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: Image.file(item.imageFile, fit: BoxFit.cover),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildShapeWidget(LogoShapeItem item) {
//     final isSelected = _selectedShapeId == item.id;
//     return Positioned(
//       left: item.position.dx,
//       top: item.position.dy,
//       child: GestureDetector(
//         onTap: () => _selectShape(item.id),
//         onDoubleTap: () => _showEditShapePopup(item),
//         onPanUpdate: (details) {
//           setState(() {
//             final idx = _shapes.indexWhere((s) => s.id == item.id);
//             if (idx != -1) {
//               _shapes[idx] = _shapes[idx].copyWith(
//                 position: item.position + details.delta,
//               );
//             }
//           });
//         },
//         child: Transform.rotate(
//           angle: item.rotation,
//           child: Container(
//             width: item.size.width,
//             height: item.size.height,
//             decoration: BoxDecoration(
//               border: isSelected
//                   ? Border.all(color: const Color(0xFF6C63FF), width: 3)
//                   : null,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: _buildShapePainter(item),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildShapePainter(LogoShapeItem shape) {
//     switch (shape.shapeType) {
//       case ShapeType.circle:
//         return Container(
//           decoration: BoxDecoration(color: shape.color, shape: BoxShape.circle),
//         );
//       case ShapeType.rectangle:
//         return Container(
//           decoration: BoxDecoration(
//             color: shape.color,
//             borderRadius: BorderRadius.circular(8),
//           ),
//         );
//       case ShapeType.triangle:
//         return CustomPaint(
//           painter: TrianglePainter(shape.color),
//           size: shape.size,
//         );
//       case ShapeType.star:
//         return CustomPaint(painter: StarPainter(shape.color), size: shape.size);
//     }
//   }

//   Widget _buildElementWidget(LogoElementItem item) {
//     final isSelected = _selectedElementId == item.id;
//     return Positioned(
//       left: item.position.dx,
//       top: item.position.dy,
//       child: GestureDetector(
//         onTap: () => _selectElement(item.id),
//         onDoubleTap: () => _showEditElementPopup(item),
//         onPanUpdate: (details) {
//           setState(() {
//             final idx = _elements.indexWhere((e) => e.id == item.id);
//             if (idx != -1) {
//               _elements[idx] = _elements[idx].copyWith(
//                 position: item.position + details.delta,
//               );
//             }
//           });
//         },
//         child: Transform.rotate(
//           angle: item.rotation,
//           child: Container(
//             width: item.size.width,
//             height: item.size.height,
//             decoration: BoxDecoration(
//               border: isSelected
//                   ? Border.all(color: const Color(0xFF6C63FF), width: 3)
//                   : null,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(
//               item.icon,
//               color: item.color,
//               size: item.size.width * 0.8,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextWidget(LogoTextItem item) {
//     final isSelected = _selectedTextId == item.id;
//     return Positioned(
//       left: item.position.dx,
//       top: item.position.dy,
//       child: GestureDetector(
//         onTap: () => _selectText(item.id),
//         onDoubleTap: () => _openTextEditor(item),
//         onPanUpdate: (details) {
//           setState(() {
//             final idx = _texts.indexWhere((t) => t.id == item.id);
//             if (idx != -1) {
//               _texts[idx] = _texts[idx].copyWith(
//                 position: item.position + details.delta,
//               );
//             }
//           });
//         },
//         child: Stack(
//           clipBehavior: Clip.none,
//           children: [
//             if (isSelected)
//               Positioned(
//                 top: -14,
//                 right: -8,
//                 child: GestureDetector(
//                   onTap: () => _showEditTextPopup(item),
//                   child: Container(
//                     width: 24,
//                     height: 24,
//                     decoration: const BoxDecoration(
//                       color: Color(0xFF6C63FF),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(
//                       Icons.edit,
//                       size: 12,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             Container(
//               decoration: isSelected
//                   ? BoxDecoration(
//                       border: Border.all(
//                         color: const Color(0xFF6C63FF),
//                         width: 2,
//                       ),
//                       borderRadius: BorderRadius.circular(8),
//                       color: const Color(0xFF6C63FF).withOpacity(0.1),
//                     )
//                   : null,
//               padding: isSelected ? const EdgeInsets.all(8) : EdgeInsets.zero,
//               child: Transform.rotate(
//                 angle: item.rotation,
//                 child: Container(
//                   decoration: item.hasBorder
//                       ? BoxDecoration(
//                           border: Border.all(color: item.color, width: 1),
//                           borderRadius: BorderRadius.circular(4),
//                         )
//                       : null,
//                   color: item.backgroundColor == Colors.transparent
//                       ? null
//                       : item.backgroundColor,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 4,
//                     vertical: 2,
//                   ),
//                   child: Text(
//                     item.text,
//                     textAlign: item.align,
//                     style: TextStyle(
//                       fontSize: item.fontSize,
//                       color: item.color,
//                       fontWeight: item.isBold
//                           ? FontWeight.bold
//                           : FontWeight.normal,
//                       fontStyle: item.isItalic
//                           ? FontStyle.italic
//                           : FontStyle.normal,
//                       decoration: item.isUnderline
//                           ? TextDecoration.underline
//                           : TextDecoration.none,
//                       shadows: item.hasShadow
//                           ? [
//                               const Shadow(
//                                 color: Colors.black38,
//                                 offset: Offset(2, 2),
//                                 blurRadius: 4,
//                               ),
//                             ]
//                           : null,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             if (isSelected)
//               Positioned(
//                 right: -6,
//                 bottom: -6,
//                 child: GestureDetector(
//                   onPanStart: (d) {
//                     _resizingTextId = item.id;
//                     _resizeStartOffset = d.globalPosition;
//                     _resizeStartFontSize = item.fontSize;
//                   },
//                   onPanUpdate: (d) {
//                     if (_resizingTextId != item.id) return;
//                     final delta =
//                         (d.globalPosition.dx -
//                             _resizeStartOffset.dx +
//                             d.globalPosition.dy -
//                             _resizeStartOffset.dy) /
//                         2;
//                     final newSize = (_resizeStartFontSize + delta).clamp(
//                       12.0,
//                       72.0,
//                     );
//                     setState(() {
//                       final idx = _texts.indexWhere((t) => t.id == item.id);
//                       if (idx != -1) {
//                         _texts[idx] = _texts[idx].copyWith(fontSize: newSize);
//                       }
//                     });
//                   },
//                   onPanEnd: (_) => _resizingTextId = null,
//                   child: Container(
//                     width: 20,
//                     height: 20,
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF6C63FF),
//                       shape: BoxShape.circle,
//                       border: Border.all(color: Colors.white, width: 1.5),
//                     ),
//                     child: const Icon(
//                       Icons.open_in_full,
//                       size: 11,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBottomTools() {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 40,
//             height: 4,
//             decoration: BoxDecoration(
//               color: Colors.grey[300],
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _buildToolButton(
//                 icon: Icons.text_fields,
//                 label: 'text',
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
//                 ),
//                 onTap: _addText,
//               ),
//               _buildToolButton(
//                 icon: Icons.image_outlined,
//                 label: 'image',
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFFFF6B6B), Color(0xFFEE5A6F)],
//                 ),
//                 onTap: _pickImage,
//               ),
//               _buildToolButton(
//                 icon: Icons.category_outlined,
//                 label: 'shapes',
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
//                 ),
//                 onTap: () => _showShapesBottomSheet(),
//               ),
//               _buildToolButton(
//                 icon: Icons.stars_outlined,
//                 label: 'elements',
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFFFFA502), Color(0xFFFF8C42)],
//                 ),
//                 onTap: () => _showElementsBottomSheet(),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildToolButton({
//     required IconData icon,
//     required String label,
//     required Gradient gradient,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 64,
//             height: 64,
//             decoration: BoxDecoration(
//               gradient: gradient,
//               borderRadius: BorderRadius.circular(18),
//               boxShadow: [
//                 BoxShadow(
//                   color: (gradient.colors.first).withOpacity(0.3),
//                   blurRadius: 12,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Icon(icon, color: Colors.white, size: 28),
//           ),
//           const SizedBox(height: 8),
//           AppText(
//             label,
//             style: const TextStyle(
//               fontSize: 13,
//               color: Color(0xFF2D3142),
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showShapesBottomSheet() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
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
//             const Text(
//               'Choose Shape',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF2D3142),
//               ),
//             ),
//             const SizedBox(height: 24),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildShapeOption(
//                   ShapeType.circle,
//                   Icons.circle_outlined,
//                   'Circle',
//                 ),
//                 _buildShapeOption(
//                   ShapeType.rectangle,
//                   Icons.crop_square_rounded,
//                   'Square',
//                 ),
//                 _buildShapeOption(
//                   ShapeType.triangle,
//                   Icons.change_history,
//                   'Triangle',
//                 ),
//                 _buildShapeOption(ShapeType.star, Icons.star_outline, 'Star'),
//               ],
//             ),
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildShapeOption(ShapeType shapeType, IconData icon, String label) {
//     return GestureDetector(
//       onTap: () {
//         _addShape(shapeType);
//         Navigator.pop(context);
//       },
//       child: Column(
//         children: [
//           Container(
//             width: 70,
//             height: 70,
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
//               ),
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color(0xFF4ECDC4).withOpacity(0.3),
//                   blurRadius: 10,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Icon(icon, color: Colors.white, size: 32),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF2D3142),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showElementsBottomSheet() {
//     final elements = [
//       {'icon': Icons.favorite, 'name': 'Heart'},
//       {'icon': Icons.star, 'name': 'Star'},
//       {'icon': Icons.lightbulb_outline, 'name': 'Bulb'},
//       {'icon': Icons.music_note, 'name': 'Music'},
//       {'icon': Icons.camera_alt_outlined, 'name': 'Camera'},
//       {'icon': Icons.phone_outlined, 'name': 'Phone'},
//       {'icon': Icons.email_outlined, 'name': 'Email'},
//       {'icon': Icons.location_on_outlined, 'name': 'Location'},
//     ];

//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
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
//             const Text(
//               'Choose Element',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF2D3142),
//               ),
//             ),
//             const SizedBox(height: 24),
//             SizedBox(
//               height: 220,
//               child: GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 4,
//                   crossAxisSpacing: 16,
//                   mainAxisSpacing: 16,
//                   childAspectRatio: 0.85,
//                 ),
//                 itemCount: elements.length,
//                 itemBuilder: (context, index) {
//                   final element = elements[index];
//                   return GestureDetector(
//                     onTap: () {
//                       _addElement(element);
//                       Navigator.pop(context);
//                     },
//                     child: Column(
//                       children: [
//                         Container(
//                           width: 50,
//                           height: 50,
//                           decoration: BoxDecoration(
//                             gradient: const LinearGradient(
//                               colors: [Color(0xFFFFA502), Color(0xFFFF8C42)],
//                             ),
//                             borderRadius: BorderRadius.circular(14),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: const Color(0xFFFFA502).withOpacity(0.3),
//                                 blurRadius: 8,
//                                 offset: const Offset(0, 3),
//                               ),
//                             ],
//                           ),
//                           child: Icon(
//                             element['icon'] as IconData,
//                             color: Colors.white,
//                             size: 26,
//                           ),
//                         ),
//                         const SizedBox(height: 6),
//                         Text(
//                           element['name'] as String,
//                           style: const TextStyle(
//                             fontSize: 11,
//                             fontWeight: FontWeight.w600,
//                             color: Color(0xFF2D3142),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ════════════════════════════════════════════════════════════════
//   //  EDIT POPUPS
//   // ════════════════════════════════════════════════════════════════

//   void _showEditImagePopup(LogoImageItem item) {
//     double selectedSize = item.size.width;
//     double selectedRotation = item.rotation;

//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (_) => StatefulBuilder(
//         builder: (context, setModalState) => Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//           ),
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'Edit Image',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 24),
//               const Text('Size', style: TextStyle(fontWeight: FontWeight.w600)),
//               Slider(
//                 value: selectedSize,
//                 min: 50,
//                 max: 300,
//                 activeColor: const Color(0xFF6C63FF),
//                 onChanged: (v) => setModalState(() => selectedSize = v),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Rotation',
//                 style: TextStyle(fontWeight: FontWeight.w600),
//               ),
//               Slider(
//                 value: selectedRotation,
//                 min: -math.pi,
//                 max: math.pi,
//                 activeColor: const Color(0xFF6C63FF),
//                 onChanged: (v) => setModalState(() => selectedRotation = v),
//               ),
//               const SizedBox(height: 24),
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton.icon(
//                       onPressed: () {
//                         setState(() {
//                           _images.removeWhere((i) => i.id == item.id);
//                           _selectedImageId = null;
//                         });
//                         Navigator.pop(context);
//                       },
//                       icon: const Icon(Icons.delete_outline),
//                       label: const Text('Delete'),
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: Colors.red,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: () {
//                         setState(() {
//                           final idx = _images.indexWhere(
//                             (i) => i.id == item.id,
//                           );
//                           if (idx != -1) {
//                             _images[idx] = _images[idx].copyWith(
//                               size: Size(selectedSize, selectedSize),
//                               rotation: selectedRotation,
//                             );
//                           }
//                         });
//                         Navigator.pop(context);
//                       },
//                       icon: const Icon(Icons.check),
//                       label: const Text('Apply'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF6C63FF),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showEditShapePopup(LogoShapeItem item) {
//     Color selectedColor = item.color;
//     double selectedSize = item.size.width;
//     double selectedRotation = item.rotation;

//     final colors = [
//       const Color(0xFF6C63FF),
//       const Color(0xFFFF6B6B),
//       const Color(0xFF4ECDC4),
//       const Color(0xFFFFA502),
//       const Color(0xFF95E1D3),
//       const Color(0xFFF38181),
//       Colors.black,
//     ];

//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (_) => StatefulBuilder(
//         builder: (context, setModalState) => Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//           ),
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'Edit Shape',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 24),
//               const Text(
//                 'Color',
//                 style: TextStyle(fontWeight: FontWeight.w600),
//               ),
//               const SizedBox(height: 8),
//               Wrap(
//                 spacing: 12,
//                 children: colors
//                     .map(
//                       (c) => _colorPicker(c, selectedColor, (color) {
//                         setModalState(() => selectedColor = color);
//                       }),
//                     )
//                     .toList(),
//               ),
//               const SizedBox(height: 16),
//               const Text('Size', style: TextStyle(fontWeight: FontWeight.w600)),
//               Slider(
//                 value: selectedSize,
//                 min: 20,
//                 max: 200,
//                 activeColor: const Color(0xFF6C63FF),
//                 onChanged: (v) => setModalState(() => selectedSize = v),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Rotation',
//                 style: TextStyle(fontWeight: FontWeight.w600),
//               ),
//               Slider(
//                 value: selectedRotation,
//                 min: -math.pi,
//                 max: math.pi,
//                 activeColor: const Color(0xFF6C63FF),
//                 onChanged: (v) => setModalState(() => selectedRotation = v),
//               ),
//               const SizedBox(height: 24),
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton.icon(
//                       onPressed: () {
//                         setState(() {
//                           _shapes.removeWhere((s) => s.id == item.id);
//                           _selectedShapeId = null;
//                         });
//                         Navigator.pop(context);
//                       },
//                       icon: const Icon(Icons.delete_outline),
//                       label: const Text('Delete'),
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: Colors.red,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: () {
//                         setState(() {
//                           final idx = _shapes.indexWhere(
//                             (s) => s.id == item.id,
//                           );
//                           if (idx != -1) {
//                             _shapes[idx] = _shapes[idx].copyWith(
//                               color: selectedColor,
//                               size: Size(selectedSize, selectedSize),
//                               rotation: selectedRotation,
//                             );
//                           }
//                         });
//                         Navigator.pop(context);
//                       },
//                       icon: const Icon(Icons.check),
//                       label: const Text('Apply'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF6C63FF),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showEditElementPopup(LogoElementItem item) {
//     Color selectedColor = item.color;
//     double selectedSize = item.size.width;
//     double selectedRotation = item.rotation;

//     final colors = [
//       const Color(0xFFFFA502),
//       const Color(0xFFFF6B6B),
//       const Color(0xFF4ECDC4),
//       const Color(0xFF6C63FF),
//       const Color(0xFF95E1D3),
//       const Color(0xFFF38181),
//     ];

//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (_) => StatefulBuilder(
//         builder: (context, setModalState) => Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//           ),
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 'Edit ${item.name}',
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 24),
//               const Text(
//                 'Color',
//                 style: TextStyle(fontWeight: FontWeight.w600),
//               ),
//               const SizedBox(height: 8),
//               Wrap(
//                 spacing: 12,
//                 children: colors
//                     .map(
//                       (c) => _colorPicker(c, selectedColor, (color) {
//                         setModalState(() => selectedColor = color);
//                       }),
//                     )
//                     .toList(),
//               ),
//               const SizedBox(height: 16),
//               const Text('Size', style: TextStyle(fontWeight: FontWeight.w600)),
//               Slider(
//                 value: selectedSize,
//                 min: 20,
//                 max: 200,
//                 activeColor: const Color(0xFF6C63FF),
//                 onChanged: (v) => setModalState(() => selectedSize = v),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Rotation',
//                 style: TextStyle(fontWeight: FontWeight.w600),
//               ),
//               Slider(
//                 value: selectedRotation,
//                 min: -math.pi,
//                 max: math.pi,
//                 activeColor: const Color(0xFF6C63FF),
//                 onChanged: (v) => setModalState(() => selectedRotation = v),
//               ),
//               const SizedBox(height: 24),
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton.icon(
//                       onPressed: () {
//                         setState(() {
//                           _elements.removeWhere((e) => e.id == item.id);
//                           _selectedElementId = null;
//                         });
//                         Navigator.pop(context);
//                       },
//                       icon: const Icon(Icons.delete_outline),
//                       label: const Text('Delete'),
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: Colors.red,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: () {
//                         setState(() {
//                           final idx = _elements.indexWhere(
//                             (e) => e.id == item.id,
//                           );
//                           if (idx != -1) {
//                             _elements[idx] = _elements[idx].copyWith(
//                               color: selectedColor,
//                               size: Size(selectedSize, selectedSize),
//                               rotation: selectedRotation,
//                             );
//                           }
//                         });
//                         Navigator.pop(context);
//                       },
//                       icon: const Icon(Icons.check),
//                       label: const Text('Apply'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF6C63FF),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showEditTextPopup(LogoTextItem item) {
//     _openTextEditor(item);
//   }

//   Widget _colorPicker(Color color, Color selectedColor, Function(Color) onTap) {
//     final isSelected = color == selectedColor;
//     return GestureDetector(
//       onTap: () => onTap(color),
//       child: Container(
//         width: 48,
//         height: 48,
//         decoration: BoxDecoration(
//           color: color,
//           shape: BoxShape.circle,
//           border: Border.all(
//             color: isSelected ? color : Colors.grey[300]!,
//             width: isSelected ? 3 : 2,
//           ),
//           boxShadow: isSelected
//               ? [
//                   BoxShadow(
//                     color: color.withOpacity(0.4),
//                     blurRadius: 8,
//                     spreadRadius: 2,
//                   ),
//                 ]
//               : null,
//         ),
//         child: isSelected
//             ? const Icon(Icons.check, color: Colors.white, size: 24)
//             : null,
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// //  TEXT EDITOR BOTTOM SHEET
// // ─────────────────────────────────────────────

// class _TextEditorSheet extends StatefulWidget {
//   final LogoTextItem item;
//   final List<String> fontFamilies;
//   final ValueChanged<LogoTextItem> onChanged;

//   const _TextEditorSheet({
//     required this.item,
//     required this.fontFamilies,
//     required this.onChanged,
//   });

//   @override
//   State<_TextEditorSheet> createState() => _TextEditorSheetState();
// }

// class _TextEditorSheetState extends State<_TextEditorSheet> {
//   late TextEditingController _ctrl;
//   late LogoTextItem _current;
//   late String _selectedFontFamily;

//   @override
//   void initState() {
//     super.initState();
//     _current = widget.item;
//     _ctrl = TextEditingController(text: widget.item.text);
//     _selectedFontFamily = widget.item.fontFamily;
//   }

//   @override
//   void dispose() {
//     _ctrl.dispose();
//     super.dispose();
//   }

//   void _update(LogoTextItem updated) {
//     setState(() => _current = updated);
//     widget.onChanged(updated);
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
//             const Text(
//               'Edit Text',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _ctrl,
//               autofocus: true,
//               maxLines: 3,
//               decoration: InputDecoration(
//                 hintText: 'Enter text...',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               onChanged: (v) => _update(_current.copyWith(text: v)),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 const Text(
//                   'Font',
//                   style: TextStyle(fontWeight: FontWeight.w600),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: DropdownButton<String>(
//                     value: _selectedFontFamily,
//                     isExpanded: true,
//                     items: widget.fontFamilies.map((font) {
//                       return DropdownMenuItem<String>(
//                         value: font,
//                         child: Text(font, style: TextStyle(fontFamily: font)),
//                       );
//                     }).toList(),
//                     onChanged: (v) {
//                       if (v != null) {
//                         setState(() => _selectedFontFamily = v);
//                         _update(_current.copyWith(fontFamily: v));
//                       }
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 const Text(
//                   'Size',
//                   style: TextStyle(fontWeight: FontWeight.w600),
//                 ),
//                 Expanded(
//                   child: Slider(
//                     value: _current.fontSize,
//                     min: 12,
//                     max: 72,
//                     activeColor: const Color(0xFF6C63FF),
//                     onChanged: (v) => _update(_current.copyWith(fontSize: v)),
//                   ),
//                 ),
//                 Text('${_current.fontSize.round()}'),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _styleChip(
//                   'B',
//                   _current.isBold,
//                   () => _update(_current.copyWith(isBold: !_current.isBold)),
//                   bold: true,
//                 ),
//                 _styleChip(
//                   'I',
//                   _current.isItalic,
//                   () =>
//                       _update(_current.copyWith(isItalic: !_current.isItalic)),
//                   italic: true,
//                 ),
//                 _styleChip(
//                   'U',
//                   _current.isUnderline,
//                   () => _update(
//                     _current.copyWith(isUnderline: !_current.isUnderline),
//                   ),
//                   underline: true,
//                 ),
//                 _styleChip(
//                   'Shadow',
//                   _current.hasShadow,
//                   () => _update(
//                     _current.copyWith(hasShadow: !_current.hasShadow),
//                   ),
//                 ),
//                 _styleChip(
//                   'Border',
//                   _current.hasBorder,
//                   () => _update(
//                     _current.copyWith(hasBorder: !_current.hasBorder),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             const Text('Color', style: TextStyle(fontWeight: FontWeight.w600)),
//             const SizedBox(height: 8),
//             Wrap(
//               spacing: 12,
//               children: [
//                 _colorPicker(
//                   Colors.black,
//                   _current.color,
//                   (c) => _update(_current.copyWith(color: c)),
//                 ),
//                 _colorPicker(
//                   Colors.red,
//                   _current.color,
//                   (c) => _update(_current.copyWith(color: c)),
//                 ),
//                 _colorPicker(
//                   Colors.blue,
//                   _current.color,
//                   (c) => _update(_current.copyWith(color: c)),
//                 ),
//                 _colorPicker(
//                   Colors.green,
//                   _current.color,
//                   (c) => _update(_current.copyWith(color: c)),
//                 ),
//                 _colorPicker(
//                   Colors.orange,
//                   _current.color,
//                   (c) => _update(_current.copyWith(color: c)),
//                 ),
//                 _colorPicker(
//                   Colors.purple,
//                   _current.color,
//                   (c) => _update(_current.copyWith(color: c)),
//                 ),
//                 _colorPicker(
//                   const Color(0xFF6C63FF),
//                   _current.color,
//                   (c) => _update(_current.copyWith(color: c)),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton.icon(
//                     onPressed: () {
//                       setState(() {
//                         _update(
//                           _current.copyWith(
//                             backgroundColor: Colors.transparent,
//                           ),
//                         );
//                       });
//                     },
//                     icon: const Icon(Icons.format_color_fill),
//                     label: const Text('Clear BG'),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: () => Navigator.pop(context),
//                     icon: const Icon(Icons.check),
//                     label: const Text('Done'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF6C63FF),
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

//   Widget _styleChip(
//     String label,
//     bool active,
//     VoidCallback onTap, {
//     bool bold = false,
//     bool italic = false,
//     bool underline = false,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//         decoration: BoxDecoration(
//           color: active ? const Color(0xFF6C63FF) : Colors.grey[100],
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             fontSize: 13,
//             fontWeight: bold ? FontWeight.bold : FontWeight.normal,
//             fontStyle: italic ? FontStyle.italic : FontStyle.normal,
//             decoration: underline
//                 ? TextDecoration.underline
//                 : TextDecoration.none,
//             color: active ? Colors.white : Colors.black87,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _colorPicker(Color color, Color selectedColor, Function(Color) onTap) {
//     final isSelected = color == selectedColor;
//     return GestureDetector(
//       onTap: () => onTap(color),
//       child: Container(
//         width: 40,
//         height: 40,
//         decoration: BoxDecoration(
//           color: color,
//           shape: BoxShape.circle,
//           border: Border.all(
//             color: isSelected ? color : Colors.grey[300]!,
//             width: isSelected ? 3 : 2,
//           ),
//         ),
//         child: isSelected
//             ? const Icon(Icons.check, color: Colors.white, size: 20)
//             : null,
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// //  SHAPE PAINTERS
// // ─────────────────────────────────────────────

// class TrianglePainter extends CustomPainter {
//   final Color color;

//   TrianglePainter(this.color);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = color
//       ..style = PaintingStyle.fill;
//     final Path path = Path()
//       ..moveTo(size.width / 2, 0)
//       ..lineTo(0, size.height)
//       ..lineTo(size.width, size.height)
//       ..close();
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

// class StarPainter extends CustomPainter {
//   final Color color;

//   StarPainter(this.color);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = color
//       ..style = PaintingStyle.fill;
//     final Path path = Path();
//     final double centerX = size.width / 2;
//     final double centerY = size.height / 2;
//     final double outerRadius = math.min(centerX, centerY);
//     final double innerRadius = outerRadius * 0.4;

//     for (int i = 0; i < 10; i++) {
//       final double angle = (i * math.pi) / 5;
//       final double radius = i.isEven ? outerRadius : innerRadius;
//       final double x = centerX + radius * math.cos(angle - math.pi / 2);
//       final double y = centerY + radius * math.sin(angle - math.pi / 2);
//       if (i == 0) {
//         path.moveTo(x, y);
//       } else {
//         path.lineTo(x, y);
//       }
//     }
//     path.close();
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

// ─────────────────────────────────────────────
//  DATA MODELS
// ─────────────────────────────────────────────

class StickerTextItem {
  String id;
  String text;
  Offset position;
  double fontSize;
  Color color;
  Color backgroundColor;
  bool hasBorder;
  bool hasShadow;
  bool isBold;
  bool isItalic;
  bool isUnderline;
  TextAlign align;
  double rotation;

  StickerTextItem({
    required this.id,
    required this.text,
    this.position = const Offset(50, 100),
    this.fontSize = 24,
    this.color = Colors.white,
    this.backgroundColor = Colors.transparent,
    this.hasBorder = false,
    this.hasShadow = false,
    this.isBold = false,
    this.isItalic = false,
    this.isUnderline = false,
    this.align = TextAlign.center,
    this.rotation = 0,
  });

  StickerTextItem copyWith({
    String? id,
    String? text,
    Offset? position,
    double? fontSize,
    Color? color,
    Color? backgroundColor,
    bool? hasBorder,
    bool? hasShadow,
    bool? isBold,
    bool? isItalic,
    bool? isUnderline,
    TextAlign? align,
    double? rotation,
  }) {
    return StickerTextItem(
      id: id ?? this.id,
      text: text ?? this.text,
      position: position ?? this.position,
      fontSize: fontSize ?? this.fontSize,
      color: color ?? this.color,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      hasBorder: hasBorder ?? this.hasBorder,
      hasShadow: hasShadow ?? this.hasShadow,
      isBold: isBold ?? this.isBold,
      isItalic: isItalic ?? this.isItalic,
      isUnderline: isUnderline ?? this.isUnderline,
      align: align ?? this.align,
      rotation: rotation ?? this.rotation,
    );
  }
}

class ExtraStickerItem {
  String emoji;
  Offset position;
  double scale;
  double rotation;

  ExtraStickerItem({
    required this.emoji,
    required this.position,
    this.scale = 1.0,
    this.rotation = 0.0,
  });
}

// ─────────────────────────────────────────────
//  MAIN STICKER EDITOR SCREEN
// ─────────────────────────────────────────────

class MakeLogo extends StatefulWidget {
  final String stickerUrl;
  const MakeLogo({super.key, required this.stickerUrl});

  @override
  State<MakeLogo> createState() => _MakeLogoState();
}

class _MakeLogoState extends State<MakeLogo> with TickerProviderStateMixin {
  // ── Main sticker transform state ──────────────────────────────────
  Offset _position = const Offset(0, 0);
  double _scale = 1.0;
  double _rotation = 0.0;
  bool _flipH = false;
  bool _flipV = false;
  bool _isSelected = true;

  // ── Gesture tracking ─────────────────────────────────────────────
  Offset? _panStart;
  Offset _basePosition = const Offset(0, 0);
  double _baseScale = 1.0;
  double _baseRotation = 0.0;

  // ── Extra stickers (emojis) ──────────────────────────────────────
  final List<ExtraStickerItem> _extraStickers = [];
  String? _selectedExtraId;

  // ── Text overlays ────────────────────────────────────────────────
  final List<StickerTextItem> _textItems = [];
  String? _selectedTextId;

  // ── Color tint ───────────────────────────────────────────────────
  Color _tintColor = Colors.transparent;
  double _tintOpacity = 0.0;

  // ── UI state ─────────────────────────────────────────────────────
  bool _showBottomSheet = false;
  String? _resizingTextId;
  Offset _resizeStartOffset = Offset.zero;
  double _resizeStartFontSize = 24;

  // ── Repaint key for export ───────────────────────────────────────
  final GlobalKey _canvasKey = GlobalKey();

  // ── Sticker size ─────────────────────────────────────────────────
  static const double _stickerBaseSize = 200;

  @override
  void initState() {
    super.initState();
  }

  // ── Layout callback: centre sticker once canvas size known ───────
  void _initPosition(Size canvasSize) {
    if (_position == Offset.zero) {
      _position = Offset(
        canvasSize.width / 2 - (_stickerBaseSize * _scale) / 2,
        canvasSize.height / 2 - (_stickerBaseSize * _scale) / 2,
      );
    }
  }

  // ════════════════════════════════════════════════════════════════
  //  BUILD
  // ════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(child: _buildCanvas()),
            _buildBottomPanel(),
          ],
        ),
      ),
    );
  }

  // ── Top bar ──────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF161616),
        border: Border(bottom: BorderSide(color: Color(0xFF2A2A2A))),
      ),
      child: Row(
        children: [
          _iconBtn(Icons.close, () => Navigator.of(context).maybePop()),
          const SizedBox(width: 8),
          const Text(
            'Sticker Editor',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          // Download button
          GestureDetector(
            onTap: _onDownload,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C4DFF), Color(0xFFE040FB)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.download, color: Colors.white, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Canvas ───────────────────────────────────────────────────────
  Widget _buildCanvas() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        _initPosition(size);

        return GestureDetector(
          onTap: () => setState(() {
            _isSelected = false;
            _selectedTextId = null;
            _selectedExtraId = null;
            _showBottomSheet = false;
          }),
          child: Stack(
            children: [
              // 👇 ONLY for UI (NOT for export)
              _CheckerBackground(size: size),

              // 👇 ONLY this will be exported
              RepaintBoundary(
                key: _canvasKey,
                child: Material(
                  // ✅ ADD THIS
                  type: MaterialType.transparency,
                  child: Stack(
                    children: [
                      ..._extraStickers.asMap().entries.map(
                        (entry) =>
                            _buildExtraStickerWidget(entry.value, entry.key),
                      ),
                      ..._textItems.map((t) => _buildTextWidget(t)),
                      _buildMainSticker(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Main sticker (draggable + scale + rotate) ────────────────────
  Widget _buildMainSticker() {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onTap: () => setState(() {
          _isSelected = true;
          _selectedTextId = null;
          _selectedExtraId = null;
        }),
        onScaleStart: (d) {
          _panStart = d.focalPoint;
          _basePosition = _position;
          _baseScale = _scale;
          _baseRotation = _rotation;
        },
        onScaleUpdate: (d) {
          setState(() {
            final delta = d.focalPoint - _panStart!;
            _position = _basePosition + delta;
            _scale = (_baseScale * d.scale).clamp(0.3, 5.0);
            _rotation = _baseRotation + d.rotation;
          });
        },
        child: Transform.rotate(
          angle: _rotation,
          child: Transform(
            transform: Matrix4.diagonal3Values(
              _flipH ? -1.0 : 1.0,
              _flipV ? -1.0 : 1.0,
              1.0,
            ),
            alignment: Alignment.center,
            child: Stack(
              children: [
                // Tint overlay + image
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    _tintColor.withOpacity(_tintOpacity),
                    BlendMode.srcATop,
                  ),
                  child: Image.network(
                    widget.stickerUrl,
                    width: _stickerBaseSize * _scale,
                    height: _stickerBaseSize * _scale,
                    fit: BoxFit.contain,
                    loadingBuilder: (_, child, progress) => progress == null
                        ? child
                        : SizedBox(
                            width: _stickerBaseSize * _scale,
                            height: _stickerBaseSize * _scale,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF7C4DFF),
                              ),
                            ),
                          ),
                  ),
                ),
                // Selection border
                if (_isSelected)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF7C4DFF),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                // Delete handle
                if (_isSelected)
                  Positioned(
                    top: -12,
                    right: -12,
                    child: _handle(
                      Icons.close,
                      const Color(0xFFFF4444),
                      _showDeleteConfirm,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Extra sticker widget ─────────────────────────────────────────
  Widget _buildExtraStickerWidget(ExtraStickerItem item, int index) {
    final isSelected = _selectedExtraId == index.toString();
    return Positioned(
      left: item.position.dx,
      top: item.position.dy,
      child: GestureDetector(
        onTap: () => setState(() {
          _selectedExtraId = index.toString();
          _isSelected = false;
          _selectedTextId = null;
        }),
        onPanUpdate: (d) {
          setState(() {
            _extraStickers[index] = ExtraStickerItem(
              emoji: item.emoji,
              position: item.position + d.delta,
              scale: item.scale,
              rotation: item.rotation,
            );
          });
        },
        child: Transform.rotate(
          angle: item.rotation,
          child: Stack(
            children: [
              Text(item.emoji, style: TextStyle(fontSize: 60 * item.scale)),
              if (isSelected)
                Positioned(
                  top: -10,
                  right: -10,
                  child: _handle(Icons.close, const Color(0xFFFF4444), () {
                    setState(() => _extraStickers.removeAt(index));
                  }),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Text widget ───────────────────────────────────────────────────
  Widget _buildTextWidget(StickerTextItem item) {
    final isSelected = _selectedTextId == item.id;
    return Positioned(
      left: item.position.dx,
      top: item.position.dy,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTextId = item.id;
            _isSelected = false;
            _selectedExtraId = null;
            _showBottomSheet = true;
          });
          _openTextEditor(item);
        },
        onPanUpdate: (d) {
          setState(() {
            final idx = _textItems.indexWhere((t) => t.id == item.id);
            if (idx != -1) {
              _textItems[idx] = _textItems[idx].copyWith(
                position: item.position + Offset(d.delta.dx, d.delta.dy),
              );
            }
          });
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (isSelected)
              Positioned(
                top: -14,
                left: -4,
                child: GestureDetector(
                  onTap: () => setState(() {
                    _textItems.removeWhere((t) => t.id == item.id);
                    _selectedTextId = null;
                  }),
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            Container(
              decoration: isSelected
                  ? BoxDecoration(
                      border: Border.all(color: Colors.blueAccent, width: 1.5),
                      color: Colors.blue.withOpacity(0.05),
                    )
                  : null,
              padding: const EdgeInsets.all(4),
              child: Container(
                decoration: item.hasBorder
                    ? BoxDecoration(
                        border: Border.all(color: item.color, width: 1),
                      )
                    : null,
                color: item.backgroundColor == Colors.transparent
                    ? null
                    : item.backgroundColor,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Transform.rotate(
                  angle: item.rotation,
                  child: Text(
                    item.text,
                    textAlign: item.align,
                    style: TextStyle(
                      fontSize: item.fontSize,
                      color: item.color,
                      fontWeight: item.isBold
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontStyle: item.isItalic
                          ? FontStyle.italic
                          : FontStyle.normal,
                      decoration: item.isUnderline
                          ? TextDecoration.underline
                          : TextDecoration.none,
                      shadows: item.hasShadow
                          ? [
                              const Shadow(
                                color: Colors.black38,
                                offset: Offset(2, 2),
                                blurRadius: 4,
                              ),
                            ]
                          : null,
                    ),
                  ),
                ),
              ),
            ),
            if (isSelected)
              Positioned(
                right: -6,
                bottom: -6,
                child: GestureDetector(
                  onPanStart: (d) {
                    _resizingTextId = item.id;
                    _resizeStartOffset = d.globalPosition;
                    _resizeStartFontSize = item.fontSize;
                  },
                  onPanUpdate: (d) {
                    if (_resizingTextId != item.id) return;
                    final delta =
                        (d.globalPosition.dx -
                            _resizeStartOffset.dx +
                            d.globalPosition.dy -
                            _resizeStartOffset.dy) /
                        2;
                    final newSize = (_resizeStartFontSize + delta).clamp(
                      8.0,
                      96.0,
                    );
                    setState(() {
                      final idx = _textItems.indexWhere((t) => t.id == item.id);
                      if (idx != -1) {
                        _textItems[idx] = _textItems[idx].copyWith(
                          fontSize: newSize,
                        );
                      }
                    });
                  },
                  onPanEnd: (_) => _resizingTextId = null,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: const Icon(
                      Icons.open_in_full,
                      size: 11,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── Bottom Panel ─────────────────────────────────────────────────
  Widget _buildBottomPanel() {
    return Container(
      color: const Color(0xFF161616),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_showBottomSheet && _selectedTextId != null)
            _buildTextToolsPanel(),
          if (!_showBottomSheet) _buildMainToolsPanel(),
        ],
      ),
    );
  }

  // ── Main Tools Panel ─────────────────────────────────────────────
  Widget _buildMainToolsPanel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _toolButton(Icons.text_fields, 'Add Text', _addText),
          _toolButton(Icons.emoji_emotions, 'Sticker', _addEmoji),
          _toolButton(Icons.flip, 'Flip', _showFlipOptions),
          _toolButton(Icons.color_lens, 'Tint', _showTintOptions),
          _toolButton(Icons.rotate_right, 'Rotate', _showRotateOptions),
        ],
      ),
    );
  }

  // ── Text Tools Panel ─────────────────────────────────────────────
  Widget _buildTextToolsPanel() {
    final selectedText = _textItems.firstWhere(
      (t) => t.id == _selectedTextId,
      orElse: () => StickerTextItem(id: '', text: ''),
    );
    if (selectedText.id.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _toolButton(
                Icons.edit,
                'Edit',
                () => _openTextEditor(selectedText),
              ),
              _toolButton(
                Icons.font_download,
                'Font',
                () => _showFontSizePicker(selectedText),
              ),
              _toolButton(
                Icons.format_color_text,
                'Color',
                () => _showColorPicker(selectedText),
              ),
              _toolButton(
                Icons.format_color_fill,
                'BG',
                () => _showBgColorPicker(selectedText),
              ),
              _toolButton(
                Icons.close,
                'Close',
                () => setState(() => _showBottomSheet = false),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _styleButton(
                'B',
                selectedText.isBold,
                () => _toggleTextStyle(selectedText, 'bold'),
              ),
              _styleButton(
                'I',
                selectedText.isItalic,
                () => _toggleTextStyle(selectedText, 'italic'),
              ),
              _styleButton(
                'U',
                selectedText.isUnderline,
                () => _toggleTextStyle(selectedText, 'underline'),
              ),
              _styleButton(
                'Shadow',
                selectedText.hasShadow,
                () => _toggleTextStyle(selectedText, 'shadow'),
              ),
              _styleButton(
                'Border',
                selectedText.hasBorder,
                () => _toggleTextStyle(selectedText, 'border'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _toolButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _styleButton(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF7C4DFF) : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // ── Text Operations ──────────────────────────────────────────────
  void _addText() {
    final item = StickerTextItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: 'Tap to edit',
      position: Offset(100, 200 + _textItems.length * 40.0),
      fontSize: 24,
      color: Colors.white,
    );
    setState(() {
      _textItems.add(item);
      _selectedTextId = item.id;
      _showBottomSheet = true;
    });
    _openTextEditor(item);
  }

  void _openTextEditor(StickerTextItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _TextEditorSheet(
        item: item,
        onChanged: (updated) {
          setState(() {
            final idx = _textItems.indexWhere((t) => t.id == updated.id);
            if (idx != -1) _textItems[idx] = updated;
          });
        },
      ),
    );
  }

  void _toggleTextStyle(StickerTextItem item, String style) {
    setState(() {
      final idx = _textItems.indexWhere((t) => t.id == item.id);
      if (idx != -1) {
        switch (style) {
          case 'bold':
            _textItems[idx] = _textItems[idx].copyWith(isBold: !item.isBold);
            break;
          case 'italic':
            _textItems[idx] = _textItems[idx].copyWith(
              isItalic: !item.isItalic,
            );
            break;
          case 'underline':
            _textItems[idx] = _textItems[idx].copyWith(
              isUnderline: !item.isUnderline,
            );
            break;
          case 'shadow':
            _textItems[idx] = _textItems[idx].copyWith(
              hasShadow: !item.hasShadow,
            );
            break;
          case 'border':
            _textItems[idx] = _textItems[idx].copyWith(
              hasBorder: !item.hasBorder,
            );
            break;
        }
      }
    });
  }

  void _showFontSizePicker(StickerTextItem item) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Font Size',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 12),
            Slider(
              value: item.fontSize,
              min: 10,
              max: 72,
              divisions: 62,
              activeColor: const Color(0xFF7C4DFF),
              label: item.fontSize.toStringAsFixed(0),
              onChanged: (v) {
                setState(() {
                  final idx = _textItems.indexWhere((t) => t.id == item.id);
                  if (idx != -1) {
                    _textItems[idx] = _textItems[idx].copyWith(fontSize: v);
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showColorPicker(StickerTextItem item) {
    final colors = [
      Colors.white,
      Colors.black,
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.teal,
      const Color(0xFFD4AF37),
      Colors.cyan,
    ];
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Text Colour',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: colors
                  .map(
                    (c) => GestureDetector(
                      onTap: () {
                        setState(() {
                          final idx = _textItems.indexWhere(
                            (t) => t.id == item.id,
                          );
                          if (idx != -1) {
                            _textItems[idx] = _textItems[idx].copyWith(
                              color: c,
                            );
                          }
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: c,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showBgColorPicker(StickerTextItem item) {
    final colors = [
      Colors.transparent,
      Colors.black87,
      Colors.white,
      Colors.red.shade700,
      Colors.blue.shade700,
      Colors.green.shade700,
      const Color(0xFFD4AF37),
      Colors.purple.shade700,
    ];
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Background Colour',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: colors
                  .map(
                    (c) => GestureDetector(
                      onTap: () {
                        setState(() {
                          final idx = _textItems.indexWhere(
                            (t) => t.id == item.id,
                          );
                          if (idx != -1) {
                            _textItems[idx] = _textItems[idx].copyWith(
                              backgroundColor: c,
                            );
                          }
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: c == Colors.transparent ? Colors.white : c,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: c == Colors.transparent
                            ? const Center(
                                child: Text(
                                  '∅',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            : null,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  // ── Emoji Operations ─────────────────────────────────────────────
  void _addEmoji() {
    showModalBottomSheet(
      context: context,
      builder: (_) => _EmojiPickerSheet(
        onEmojiSelected: (emoji) {
          setState(() {
            _extraStickers.add(
              ExtraStickerItem(emoji: emoji, position: Offset(100, 150)),
            );
          });
        },
      ),
    );
  }

  // ── Flip Options ─────────────────────────────────────────────────
  void _showFlipOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Flip Sticker',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _flipOption('Flip Horizontal', () {
                  setState(() => _flipH = !_flipH);
                  Navigator.pop(context);
                }),
                _flipOption('Flip Vertical', () {
                  setState(() => _flipV = !_flipV);
                  Navigator.pop(context);
                }),
                _flipOption('Reset', () {
                  setState(() {
                    _flipH = false;
                    _flipV = false;
                    _rotation = 0;
                  });
                  Navigator.pop(context);
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _flipOption(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF5C518),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  // ── Tint Options ─────────────────────────────────────────────────
  void _showTintOptions() {
    final colors = [
      Colors.transparent,
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.cyan,
      Colors.blue,
      Colors.purple,
      Colors.pink,
      Colors.white,
      Colors.black,
    ];
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Color Tint',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: colors
                  .map(
                    (c) => GestureDetector(
                      onTap: () {
                        setState(() => _tintColor = c);
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: c == Colors.transparent ? Colors.white : c,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _tintColor == c
                                ? Colors.blueAccent
                                : Colors.grey.shade300,
                            width: _tintColor == c ? 2.5 : 1,
                          ),
                        ),
                        child: c == Colors.transparent
                            ? const Center(
                                child: Text(
                                  '∅',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            : null,
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Opacity', style: TextStyle(fontSize: 12)),
                Expanded(
                  child: Slider(
                    value: _tintOpacity,
                    min: 0,
                    max: 1,
                    activeColor: const Color(0xFF7C4DFF),
                    onChanged: (v) => setState(() => _tintOpacity = v),
                  ),
                ),
                Text(
                  '${(_tintOpacity * 100).round()}%',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Rotate Options ───────────────────────────────────────────────
  void _showRotateOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Rotate Sticker',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _rotateOption('-90°', () {
                  setState(() => _rotation -= math.pi / 2);
                  Navigator.pop(context);
                }),
                _rotateOption('+90°', () {
                  setState(() => _rotation += math.pi / 2);
                  Navigator.pop(context);
                }),
                _rotateOption('Reset', () {
                  setState(() => _rotation = 0);
                  Navigator.pop(context);
                }),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Fine Tune', style: TextStyle(fontSize: 12)),
                Expanded(
                  child: Slider(
                    value: _rotation,
                    min: -math.pi,
                    max: math.pi,
                    activeColor: const Color(0xFF7C4DFF),
                    onChanged: (v) => setState(() => _rotation = v),
                  ),
                ),
                Text(
                  '${(_rotation * 180 / math.pi).round()}°',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _rotateOption(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF7C4DFF),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ── Delete Confirm ───────────────────────────────────────────────
  void _showDeleteConfirm() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Remove Sticker',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Remove this sticker from the canvas?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              'Remove',
              style: TextStyle(color: Color(0xFFFF4444)),
            ),
          ),
        ],
      ),
    );
  }

  // ── Download to Gallery ──────────────────────────────────────────
  Future<void> _onDownload() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7C4DFF)),
          ),
        ),
      );

      final boundary =
          _canvasKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) {
        Navigator.pop(context);
        return;
      }

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData?.buffer.asUint8List();

      Navigator.pop(context);

      if (bytes != null) {
        final tempDir = await getTemporaryDirectory();
        final fileName = 'sticker_${DateTime.now().millisecondsSinceEpoch}.png';
        final file = File('${tempDir.path}/$fileName');
        await file.writeAsBytes(bytes);

        final hasAccess = await Gal.hasAccess();
        if (!hasAccess) await Gal.requestAccess();
        await Gal.putImage(file.path, album: 'Sticker Editor');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sticker saved to gallery! ✨'),
              backgroundColor: Color(0xFF7C4DFF),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _iconBtn(IconData icon, VoidCallback? onTap, {Color? color}) =>
      IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: color ?? Colors.white),
        iconSize: 22,
      );

  Widget _handle(IconData icon, Color color, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 14),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  CHECKERBOARD BACKGROUND
// ─────────────────────────────────────────────
class _CheckerBackground extends StatelessWidget {
  final Size size;
  const _CheckerBackground({required this.size});

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: size, painter: _CheckerPainter());
}

class _CheckerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const cellSize = 20.0;
    final paint1 = Paint()..color = const Color(0xFF1A1A1A);
    final paint2 = Paint()..color = const Color(0xFF222222);
    for (double y = 0; y < size.height; y += cellSize) {
      for (double x = 0; x < size.width; x += cellSize) {
        final even = ((x / cellSize).floor() + (y / cellSize).floor()) % 2 == 0;
        canvas.drawRect(
          Rect.fromLTWH(x, y, cellSize, cellSize),
          even ? paint1 : paint2,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────
//  TEXT EDITOR BOTTOM SHEET
// ─────────────────────────────────────────────
class _TextEditorSheet extends StatefulWidget {
  final StickerTextItem item;
  final ValueChanged<StickerTextItem> onChanged;

  const _TextEditorSheet({
    Key? key,
    required this.item,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<_TextEditorSheet> createState() => _TextEditorSheetState();
}

class _TextEditorSheetState extends State<_TextEditorSheet> {
  late TextEditingController _ctrl;
  late StickerTextItem _current;

  @override
  void initState() {
    super.initState();
    _current = widget.item;
    _ctrl = TextEditingController(text: widget.item.text);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _update(StickerTextItem updated) {
    setState(() => _current = updated);
    widget.onChanged(updated);
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _ctrl,
              autofocus: true,
              maxLines: 3,
              minLines: 1,
              decoration: InputDecoration(
                hintText: 'Enter text…',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (v) => _update(_current.copyWith(text: v)),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Size', style: TextStyle(fontSize: 12)),
                Expanded(
                  child: Slider(
                    value: _current.fontSize,
                    min: 10,
                    max: 72,
                    divisions: 62,
                    activeColor: const Color(0xFF7C4DFF),
                    label: _current.fontSize.toStringAsFixed(0),
                    onChanged: (v) => _update(_current.copyWith(fontSize: v)),
                  ),
                ),
                Text(
                  _current.fontSize.toStringAsFixed(0),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _styleChip(
                  'B',
                  _current.isBold,
                  () => _update(_current.copyWith(isBold: !_current.isBold)),
                  bold: true,
                ),
                _styleChip(
                  'I',
                  _current.isItalic,
                  () =>
                      _update(_current.copyWith(isItalic: !_current.isItalic)),
                  italic: true,
                ),
                _styleChip(
                  'U',
                  _current.isUnderline,
                  () => _update(
                    _current.copyWith(isUnderline: !_current.isUnderline),
                  ),
                  underline: true,
                ),
                _styleChip(
                  'Shadow',
                  _current.hasShadow,
                  () => _update(
                    _current.copyWith(hasShadow: !_current.hasShadow),
                  ),
                ),
                _styleChip(
                  'Border',
                  _current.hasBorder,
                  () => _update(
                    _current.copyWith(hasBorder: !_current.hasBorder),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C4DFF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _styleChip(
    String label,
    bool active,
    VoidCallback onTap, {
    bool bold = false,
    bool italic = false,
    bool underline = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF7C4DFF) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: active ? Colors.white : Colors.black87,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            fontStyle: italic ? FontStyle.italic : FontStyle.normal,
            decoration: underline
                ? TextDecoration.underline
                : TextDecoration.none,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  EMOJI PICKER SHEET
// ─────────────────────────────────────────────
class _EmojiPickerSheet extends StatelessWidget {
  final Function(String) onEmojiSelected;

  const _EmojiPickerSheet({required this.onEmojiSelected});

  @override
  Widget build(BuildContext context) {
    final emojis = [
      '😀',
      '😂',
      '🥹',
      '😍',
      '🤩',
      '😎',
      '🥳',
      '🫶',
      '👍',
      '🔥',
      '✨',
      '💥',
      '💯',
      '🎉',
      '❤️',
      '💜',
      '🌈',
      '⭐',
      '🦄',
      '🍀',
      '🎵',
      '🎯',
      '🏆',
      '💎',
      '🚀',
      '🌟',
      '👑',
      '🎀',
      '🍭',
      '🌺',
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Add Emoji',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: emojis.length,
            itemBuilder: (_, i) => GestureDetector(
              onTap: () {
                onEmojiSelected(emojis[i]);
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(emojis[i], style: const TextStyle(fontSize: 28)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
