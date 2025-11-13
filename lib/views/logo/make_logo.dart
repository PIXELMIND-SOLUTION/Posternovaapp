// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:math' as math;
// import 'package:photo_manager/photo_manager.dart';
// import 'package:posternova/providers/auth/login_provider.dart';
// import 'package:provider/provider.dart';

// class MakeLogo extends StatefulWidget {
//   final String image;
//   const MakeLogo({super.key, required this.image});

//   @override
//   State<MakeLogo> createState() => _EditLogoState();
// }

// class _EditLogoState extends State<MakeLogo> {
//   // Replace the single background image with a list of editable images
//   final List<_EditableImage> _images = [];
//   final List<_EditableText> _texts = [];
//   final List<_EditableShape> _shapes = [];
//   final List<_EditableElement> _elements = [];

//   final GlobalKey _canvasKey = GlobalKey();
//   bool _isLoading = false;
//   bool _isSaving = false;

//   // Available font families
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

//   Future<void> _saveLogoToGallery() async {
//     setState(() {
//       _isSaving = true;
//     });

//     try {
//       // Request permission
//       final PermissionState result =
//           await PhotoManager.requestPermissionExtend();
//       if (result.isAuth) {
//         // Capture the canvas as an image
//         final Uint8List? logoImage = await _captureCanvasAsImage();

//         if (logoImage != null) {
//           // Save to gallery
//           final AssetEntity? asset = await PhotoManager.editor.saveImage(
//             filename: '',
//             logoImage,
//             title: 'Logo_${DateTime.now().millisecondsSinceEpoch}.png',
//           );

//           if (asset != null) {
//             // Show success message
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('Logo saved to gallery successfully!'),
//                 backgroundColor: Colors.green,
//               ),
//             );
//           } else {
//             throw Exception('Failed to save the image');
//           }
//         } else {
//           throw Exception('Failed to capture the canvas');
//         }
//       } else {
//         throw Exception('Permission denied');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to save: ${e.toString()}'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       setState(() {
//         _isSaving = false;
//       });
//     }
//   }

//   Future<Uint8List?> _captureCanvasAsImage() async {
//     try {
//       await Future.delayed(const Duration(milliseconds: 20));

//       final RenderRepaintBoundary? boundary = _canvasKey.currentContext
//           ?.findRenderObject() as RenderRepaintBoundary?;

//       if (boundary == null) {
//         debugPrint('Render boundary is null');
//         return null;
//       }
//       final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
//       final ByteData? byteData =
//           await image.toByteData(format: ui.ImageByteFormat.png);

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
//         _images.add(_EditableImage(
//           imageFile: File(pickedFile.path),
//           offset: const Offset(100, 100), 
//           size: const Size(150, 150),
//         ));
//       });
//     }
//   }

//   void _addShape(ShapeType shapeType) {
//     setState(() {
//       _shapes.add(_EditableShape(
//         shapeType: shapeType,
//         color: Colors.orange,
//         size: const Size(80, 80),
//         offset: const Offset(100, 100),
//       ));
//     });
//   }

//   void _addElement(Map<String, dynamic> elementData) {
//     setState(() {
//       _elements.add(_EditableElement(
//         icon: elementData['icon'],
//         name: elementData['name'],
//         color: Colors.indigo,
//         size: const Size(60, 60),
//         offset: const Offset(100, 100),
//       ));
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
//         _selectedText = null; // Deselect if tapping the same text
//       } else {
//         _selectedText = text;
//         _selectedShape = null;
//         _selectedElement = null;
//         _selectedImage = null; 
//       }
//     });
//   }

//   // Select or deselect shape
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

//   // Select or deselect image
//   void _selectImage(_EditableImage image) {
//     setState(() {
//       if (_selectedImage == image) {
//         _selectedImage = null; // Deselect if tapping the same image
//       } else {
//         _selectedImage = image;
//         _selectedText = null;
//         _selectedShape = null;
//         _selectedElement = null;
//       }
//     });
//   }

//   // Deselect all items
//   void _deselectAll() {
//     setState(() {
//       _selectedText = null;
//       _selectedShape = null;
//       _selectedElement = null;
//       _selectedImage = null; // Deselect any selected image
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _loadSubscriptions();
//   }

//   Future<void> _loadSubscriptions() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       final userId = authProvider.user?.user.id;
//       // Get this from your auth state
   
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   // Method to handle image editing
//   void _showEditImagePopup(_EditableImage editableImage) {
//     double selectedSize = editableImage.size.width;

//     showModalBottomSheet(
//       context: context,
//       builder: (_) {
//         return StatefulBuilder(builder: (context, setModalState) {
//           return Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text('Edit Image',
//                     style:
//                         TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 16),

//                 // Size slider
//                 const Text('Size:'),
//                 Slider(
//                   value: selectedSize,
//                   min: 50,
//                   max: 300,
//                   divisions: 25,
//                   label: selectedSize.round().toString(),
//                   onChanged: (value) {
//                     setModalState(() {
//                       selectedSize = value;
//                     });
//                   },
//                 ),

//                 // Save and Delete buttons row
//                 const SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           _images.remove(editableImage);
//                           _selectedImage = null;
//                         });
//                         Navigator.pop(context);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                       ),
//                       child: const Text(
//                         'Delete Image',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           editableImage.size = Size(selectedSize, selectedSize);
//                         });
//                         Navigator.pop(context);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                       ),
//                       child: const Text(
//                         'Save Changes',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         });
//       },
//     );
//   }

//   // Method to handle shape editing
//   void _showEditShapePopup(_EditableShape editableShape) {
//     Color selectedColor = editableShape.color;
//     double selectedSize = editableShape.size.width;

//     showModalBottomSheet(
//       context: context,
//       builder: (_) {
//         return StatefulBuilder(builder: (context, setModalState) {
//           return Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text('Edit Shape',
//                     style:
//                         TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 16),

//                 // Color selection
//                 const Text('Color:'),
//                 const SizedBox(height: 8),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     _colorPicker(Colors.blue, (color) {
//                       setModalState(() => selectedColor = color);
//                     }),
//                     _colorPicker(Colors.red, (color) {
//                       setModalState(() => selectedColor = color);
//                     }),
//                     _colorPicker(Colors.green, (color) {
//                       setModalState(() => selectedColor = color);
//                     }),
//                     _colorPicker(Colors.orange, (color) {
//                       setModalState(() => selectedColor = color);
//                     }),
//                     _colorPicker(Colors.purple, (color) {
//                       setModalState(() => selectedColor = color);
//                     }),
//                   ],
//                 ),

//                 // Size slider
//                 const SizedBox(height: 16),
//                 const Text('Size:'),
//                 Slider(
//                   value: selectedSize,
//                   min: 20,
//                   max: 200,
//                   divisions: 18,
//                   label: selectedSize.round().toString(),
//                   onChanged: (value) {
//                     setModalState(() {
//                       selectedSize = value;
//                     });
//                   },
//                 ),

//                 // Save and Delete buttons row
//                 const SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           _shapes.remove(editableShape);
//                           _selectedShape = null;
//                         });
//                         Navigator.pop(context);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                       ),
//                       child: const Text(
//                         'Delete Shape',
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           editableShape.color = selectedColor;
//                           editableShape.size = Size(selectedSize, selectedSize);
//                         });
//                         Navigator.pop(context);
//                       },
//                       child: const Text('Save Changes'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         });
//       },
//     );
//   }

//   // Method to handle element editing
//   void _showEditElementPopup(_EditableElement editableElement) {
//     Color selectedColor = editableElement.color;
//     double selectedSize = editableElement.size.width;

//     showModalBottomSheet(
//       context: context,
//       builder: (_) {
//         return StatefulBuilder(builder: (context, setModalState) {
//           return Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text('Edit ${editableElement.name}',
//                     style: const TextStyle(
//                         fontSize: 18, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 16),

//                 // Color selection
//                 const Text('Color:'),
//                 const SizedBox(height: 8),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     _colorPicker(Colors.blue, (color) {
//                       setModalState(() => selectedColor = color);
//                     }),
//                     _colorPicker(Colors.red, (color) {
//                       setModalState(() => selectedColor = color);
//                     }),
//                     _colorPicker(Colors.green, (color) {
//                       setModalState(() => selectedColor = color);
//                     }),
//                     _colorPicker(Colors.indigo, (color) {
//                       setModalState(() => selectedColor = color);
//                     }),
//                     _colorPicker(Colors.purple, (color) {
//                       setModalState(() => selectedColor = color);
//                     }),
//                   ],
//                 ),
               
                
//                 // Size slider
//                 const SizedBox(height: 16),
//                 const Text('Size:'),
//                 Slider(
//                   value: selectedSize,
//                   min: 20,
//                   max: 200,
//                   divisions: 18,
//                   label: selectedSize.round().toString(),
//                   onChanged: (value) {
//                     setModalState(() {
//                       selectedSize = value;
//                     });
//                   },
//                 ),

//                 // Save and Delete buttons row
//                 const SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           _elements.remove(editableElement);
//                           _selectedElement = null;
//                         });
//                         Navigator.pop(context);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                       ),
//                       child: const Text(
//                         'Delete Element',
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           editableElement.color = selectedColor;
//                           editableElement.size =
//                               Size(selectedSize, selectedSize);
//                         });
//                         Navigator.pop(context);
//                       },
//                       child: const Text('Save Changes'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         });
//       },
//     );
//   }

//   void _showAddTextPopup() {
//     final TextEditingController _textController = TextEditingController();
//     Color selectedColor = Colors.black;
//     String selectedFontFamily = _fontFamilies[0];
//     double selectedFontSize = 16.0;
//     bool isBold = false;
//     bool isItalic = false;

//     showDialog(
//       context: context,
//       builder: (_) {
//         return StatefulBuilder(builder: (context, setDialogState) {
//           return AlertDialog(
//             title: const Text('Add Text'),
//             content: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Text input
//                   TextField(
//                     controller: _textController,
//                     decoration: const InputDecoration(labelText: 'Enter Text'),
//                     autofocus: true,
//                   ),

//                   const SizedBox(height: 16),

//                   // Font family dropdown
//                   const Text('Font Family:',
//                       style: TextStyle(fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 8),
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: DropdownButtonHideUnderline(
//                       child: DropdownButton<String>(
//                         value: selectedFontFamily,
//                         isExpanded: true,
//                         items: _fontFamilies.map((font) {
//                           return DropdownMenuItem<String>(
//                             value: font,
//                             child:
//                                 Text(font, style: TextStyle(fontFamily: font)),
//                           );
//                         }).toList(),
//                         onChanged: (value) {
//                           setDialogState(() {
//                             selectedFontFamily = value!;
//                           });
//                         },
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 16),

//                   // Font size slider
//                   const Text('Font Size:',
//                       style: TextStyle(fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 8),
//                   Slider(
//                     value: selectedFontSize,
//                     min: 10,
//                     max: 48,
//                     divisions: 38,
//                     label: selectedFontSize.round().toString(),
//                     onChanged: (value) {
//                       setDialogState(() {
//                         selectedFontSize = value;
//                       });
//                     },
//                   ),

//                   const SizedBox(height: 16),

//                   // Font style toggles
//                   // Font style toggles
//                   const Text('Font Style:',
//                       style: TextStyle(fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: CheckboxListTile(
//                           title: const Text('Bold'),
//                           value: isBold,
//                           onChanged: (value) {
//                             setDialogState(() {
//                               isBold = value ?? false;
//                             });
//                           },
//                         ),
//                       ),
//                       Expanded(
//                         child: CheckboxListTile(
//                           title: const Text('Italic'),
//                           value: isItalic,
//                           onChanged: (value) {
//                             setDialogState(() {
//                               isItalic = value ?? false;
//                             });
//                           },
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 16),

//                   // Color selection
//                   const Text('Color:',
//                       style: TextStyle(fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       _colorPicker(Colors.black, (color) {
//                         setDialogState(() => selectedColor = color);
//                       }),
//                       _colorPicker(Colors.red, (color) {
//                         setDialogState(() => selectedColor = color);
//                       }),
//                       _colorPicker(Colors.blue, (color) {
//                         setDialogState(() => selectedColor = color);
//                       }),
//                       _colorPicker(Colors.green, (color) {
//                         setDialogState(() => selectedColor = color);
//                       }),
//                       _colorPicker(Colors.purple, (color) {
//                         setDialogState(() => selectedColor = color);
//                       }),
//                     ],
//                   ),

//                   const SizedBox(height: 16),

//                   // Preview text
//                   const Text('Preview:',
//                       style: TextStyle(fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 8),
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey),
//                       borderRadius: BorderRadius.circular(8),
//                       color: Colors.grey[50],
//                     ),
//                     child: Text(
//                       _textController.text.isEmpty
//                           ? 'Sample Text'
//                           : _textController.text,
//                       style: TextStyle(
//                         color: selectedColor,
//                         fontSize: selectedFontSize,
//                         fontFamily: selectedFontFamily,
//                         fontWeight:
//                             isBold ? FontWeight.bold : FontWeight.normal,
//                         fontStyle:
//                             isItalic ? FontStyle.italic : FontStyle.normal,
//                       ),
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
//                   if (_textController.text.isNotEmpty) {
//                     setState(() {
//                       _texts.add(_EditableText(
//                         text: _textController.text,
//                         color: selectedColor,
//                         fontSize: selectedFontSize,
//                         fontFamily: selectedFontFamily,
//                         isBold: isBold,
//                         isItalic: isItalic,
//                         offset: const Offset(100, 100),
//                       ));
//                     });
//                     Navigator.pop(context);
//                   }
//                 },
//                 child: const Text('Add Text'),
//               ),
//             ],
//           );
//         });
//       },
//     );
//   }

//   void _showEditTextPopup(_EditableText editableText) {
//     final TextEditingController _textController =
//         TextEditingController(text: editableText.text);
//     Color selectedColor = editableText.color;
//     String selectedFontFamily = editableText.fontFamily;
//     double selectedFontSize = editableText.fontSize;
//     bool isBold = editableText.isBold;
//     bool isItalic = editableText.isItalic;

//     showDialog(
//       context: context,
//       builder: (_) {
//         return StatefulBuilder(builder: (context, setDialogState) {
//           return AlertDialog(
//             title: const Text('Edit Text'),
//             content: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Text input
//                   TextField(
//                     controller: _textController,
//                     decoration: const InputDecoration(labelText: 'Enter Text'),
//                     autofocus: true,
//                   ),

//                   const SizedBox(height: 16),

//                   // Font family dropdown
//                   const Text('Font Family:',
//                       style: TextStyle(fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 8),
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: DropdownButtonHideUnderline(
//                       child: DropdownButton<String>(
//                         value: selectedFontFamily,
//                         isExpanded: true,
//                         items: _fontFamilies.map((font) {
//                           return DropdownMenuItem<String>(
//                             value: font,
//                             child:
//                                 Text(font, style: TextStyle(fontFamily: font)),
//                           );
//                         }).toList(),
//                         onChanged: (value) {
//                           setDialogState(() {
//                             selectedFontFamily = value!;
//                           });
//                         },
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 16),

//                   // Font size slider
//                   const Text('Font Size:',
//                       style: TextStyle(fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 8),
//                   Slider(
//                     value: selectedFontSize,
//                     min: 10,
//                     max: 48,
//                     divisions: 38,
//                     label: selectedFontSize.round().toString(),
//                     onChanged: (value) {
//                       setDialogState(() {
//                         selectedFontSize = value;
//                       });
//                     },
//                   ),

//                   const SizedBox(height: 16),

//                   // Font style toggles
//                   const Text('Font Style:',
//                       style: TextStyle(fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: CheckboxListTile(
//                           title: const Text('Bold'),
//                           value: isBold,
//                           onChanged: (value) {
//                             setDialogState(() {
//                               isBold = value ?? false;
//                             });
//                           },
//                         ),
//                       ),
//                       Expanded(
//                         child: CheckboxListTile(
//                           title: const Text('Italic'),
//                           value: isItalic,
//                           onChanged: (value) {
//                             setDialogState(() {
//                               isItalic = value ?? false;
//                             });
//                           },
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 16),

//                   // Color selection
//                   const Text('Color:',
//                       style: TextStyle(fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       _colorPicker(Colors.black, (color) {
//                         setDialogState(() => selectedColor = color);
//                       }),
//                       _colorPicker(Colors.red, (color) {
//                         setDialogState(() => selectedColor = color);
//                       }),
//                       _colorPicker(Colors.blue, (color) {
//                         setDialogState(() => selectedColor = color);
//                       }),
//                       _colorPicker(Colors.green, (color) {
//                         setDialogState(() => selectedColor = color);
//                       }),
//                       _colorPicker(Colors.purple, (color) {
//                         setDialogState(() => selectedColor = color);
//                       }),
//                     ],
//                   ),

//                   const SizedBox(height: 16),

//                   // Preview text
//                   const Text('Preview:',
//                       style: TextStyle(fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 8),
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey),
//                       borderRadius: BorderRadius.circular(8),
//                       color: Colors.grey[50],
//                     ),
//                     child: Text(
//                       _textController.text.isEmpty
//                           ? 'Sample Text'
//                           : _textController.text,
//                       style: TextStyle(
//                         color: selectedColor,
//                         fontSize: selectedFontSize,
//                         fontFamily: selectedFontFamily,
//                         fontWeight:
//                             isBold ? FontWeight.bold : FontWeight.normal,
//                         fontStyle:
//                             isItalic ? FontStyle.italic : FontStyle.normal,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   setState(() {
//                     _texts.remove(editableText);
//                     _selectedText = null;
//                   });
//                   Navigator.pop(context);
//                 },
//                 child:
//                     const Text('Delete', style: TextStyle(color: Colors.red)),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('Cancel'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_textController.text.isNotEmpty) {
//                     setState(() {
//                       editableText.text = _textController.text;
//                       editableText.color = selectedColor;
//                       editableText.fontSize = selectedFontSize;
//                       editableText.fontFamily = selectedFontFamily;
//                       editableText.isBold = isBold;
//                       editableText.isItalic = isItalic;
//                     });
//                     Navigator.pop(context);
//                   }
//                 },
//                 child: const Text('Save Changes'),
//               ),
//             ],
//           );
//         });
//       },
//     );
//   }

//   Widget _colorPicker(Color color, Function(Color) onTap) {
//     return GestureDetector(
//       onTap: () => onTap(color),
//       child: Container(
//         width: 40,
//         height: 40,
//         decoration: BoxDecoration(
//           color: color,
//           shape: BoxShape.circle,
//           border: Border.all(color: Colors.grey, width: 2),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 2,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Make Logo',
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         actions: [
//           if (_selectedText != null ||
//               _selectedShape != null ||
//               _selectedElement != null ||
//               _selectedImage != null)
//             IconButton(
//               icon: const Icon(Icons.delete, color: Colors.red),
//               onPressed: _deleteSelectedItem,
//             ),
//           IconButton(
//             icon: _isSaving
//                 ? const SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: CircularProgressIndicator(strokeWidth: 2),
//                   )
//                 : const Icon(Icons.save_alt, color: Colors.black),
//             onPressed: _isSaving ? null : _saveLogoToGallery,
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 // Canvas area
//                 Expanded(
//                   flex: 3,
//                   child: Container(
//                     margin: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 10,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: RepaintBoundary(
//                       key: _canvasKey,
//                       child: GestureDetector(
//                         onTap: _deselectAll,
//                         child: Container(
//                           width: double.infinity,
//                           height: double.infinity,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             image: DecorationImage(
//                               image: NetworkImage(widget.image),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           child: Stack(
//                             children: [
//                               // Render all images
//                               ..._images
//                                   .map((image) => _buildEditableImage(image)),
//                               // Render all texts
//                               ..._texts.map((text) => _buildEditableText(text)),
//                               // Render all shapes
//                               ..._shapes
//                                   .map((shape) => _buildEditableShape(shape)),
//                               // Render all elements
//                               ..._elements.map(
//                                   (element) => _buildEditableElement(element)),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),

//                 // Tools section
//                 Expanded(
//                   flex: 1,
//                   child: Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius:
//                           const BorderRadius.vertical(top: Radius.circular(20)),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.05),
//                           blurRadius: 10,
//                           offset: const Offset(0, -2),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       children: [
//                         Container(
//                           width: 40,
//                           height: 4,
//                           decoration: BoxDecoration(
//                             color: Colors.grey[300],
//                             borderRadius: BorderRadius.circular(2),
//                           ),
//                         ),
//                         const SizedBox(height: 16),

//                         // Tool buttons
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             _buildToolButton(
//                               icon: Icons.text_format,
//                               label: 'AddText',
//                               onTap: _showAddTextPopup,
//                             ),
//                             _buildToolButton(
//                               icon: Icons.hide_image,
//                               label: 'AddImage',
//                               onTap: _pickImage,
//                             ),
//                             _buildToolButton(
//                               icon: Icons.rectangle,
//                               label: 'Addshapes',
//                               onTap: () => _showShapesBottomSheet(),
//                             ),
//                             _buildToolButton(
//                               icon: Icons.favorite_outline,
//                               label: 'elements',
//                               onTap: () => _showElementsBottomSheet(),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }

//   Widget _buildToolButton({
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 50,
//             height: 50,
//             decoration: BoxDecoration(
//               color: const ui.Color.fromARGB(255, 249, 212, 144),
//               borderRadius: BorderRadius.circular(30),
//               border: Border.all(color: const ui.Color.fromARGB(255, 249, 212, 144)),
              
//             ),
//             child: Icon(icon, color: Colors.white),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey[700],
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showShapesBottomSheet() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => Container(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text('Choose Shape',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildShapeOption(ShapeType.circle, Icons.circle, 'circle'),
//                 _buildShapeOption(
//                     ShapeType.rectangle, Icons.rectangle, 'rectangle'),
//                 _buildShapeOption(
//                     ShapeType.triangle, Icons.change_history, 'triangle'),
//                 _buildShapeOption(ShapeType.star, Icons.star, 'star'),
//               ],
//             ),
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
//             width: 60,
//             height: 60,
//             decoration: BoxDecoration(
//               color: Colors.orange[50],
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.orange[200]!),
//             ),
//             child: Icon(icon, color: Colors.orange[600], size: 30),
//           ),
//           const SizedBox(height: 8),
//           Text(label, style: const TextStyle(fontSize: 12)),
//         ],
//       ),
//     );
//   }

//   void _showElementsBottomSheet() {
//     final elements = [
//       {'icon': Icons.favorite, 'name': 'heart'},
//       {'icon': Icons.star, 'name': 'star'},
//       {'icon': Icons.lightbulb, 'name': 'bulb'},
//       {'icon': Icons.music_note, 'name': 'music'},
//       {'icon': Icons.camera, 'name': 'camera'},
//       {'icon': Icons.phone, 'name': 'phone'},
//       {'icon': Icons.email, 'name': 'email'},
//       {'icon': Icons.location_on, 'name': 'location'},
//     ];

//     showModalBottomSheet(
//       context: context,
//       builder: (context) => Container(
//         padding: const EdgeInsets.all(16),
//         height: 200,
//         child: Column(
//           children: [
//             const Text('Choose Element',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             Expanded(
//               child: GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 4,
//                   crossAxisSpacing: 16,
//                   mainAxisSpacing: 16,
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
//                             color: Colors.indigo[50],
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(color: Colors.indigo[200]!),
//                           ),
//                           child: Icon(element['icon'] as IconData,
//                               color: Colors.indigo[600], size: 24),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(element['name'] as String,
//                             style: const TextStyle(fontSize: 10)),
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
//                 ? Border.all()
//                 : null,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(8),
//             child: Image.file(
//               editableImage.imageFile,
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//   Widget _buildEditableText(_EditableText editableText) {
//   return Positioned(
//     left: editableText.offset.dx,
//     top: editableText.offset.dy,
//     child: GestureDetector(
//       onTap: () => _selectText(editableText),
//       onDoubleTap: () => _showEditTextPopup(editableText),
//       onPanUpdate: (details) {
//         setState(() {
//           editableText.offset += details.delta;
//         });
//       },
//       child: Text(
//         editableText.text,
//         style: TextStyle(
//           color: editableText.color,
//           fontSize: editableText.fontSize,
//           fontFamily: editableText.fontFamily,
//           fontWeight:
//               editableText.isBold ? FontWeight.bold : FontWeight.normal,
//           fontStyle:
//               editableText.isItalic ? FontStyle.italic : FontStyle.normal,
//         ),
//       ),
//     ),
//   );
// }

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
//                 ? Border.all(color: Colors.blue, width: 2)
//                 : null,
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
//                 ? Border.all()
//                 : null,
//             borderRadius: BorderRadius.circular(4),
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
//           decoration: BoxDecoration(
//             color: shape.color,
//             shape: BoxShape.circle,
//           ),
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
//         return CustomPaint(
//           painter: StarPainter(shape.color),
//           size: shape.size,
//         );
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
















import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math' as math;
import 'package:photo_manager/photo_manager.dart';
import 'package:posternova/providers/auth/login_provider.dart';
import 'package:provider/provider.dart';

class MakeLogo extends StatefulWidget {
  final String image;
  const MakeLogo({super.key, required this.image});

  @override
  State<MakeLogo> createState() => _EditLogoState();
}

class _EditLogoState extends State<MakeLogo> with SingleTickerProviderStateMixin {
  final List<_EditableImage> _images = [];
  final List<_EditableText> _texts = [];
  final List<_EditableShape> _shapes = [];
  final List<_EditableElement> _elements = [];

  final GlobalKey _canvasKey = GlobalKey();
  bool _isLoading = false;
  bool _isSaving = false;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  final List<String> _fontFamilies = [
    'Roboto',
    'Arial',
    'Times New Roman',
    'Courier New',
    'Georgia',
    'Verdana',
    'Comic Sans MS',
    'Impact',
    'Trebuchet MS',
    'Lucida Grande',
  ];

  @override
  void initState() {
    super.initState();
    _loadSubscriptions();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  Future<void> _saveLogoToGallery() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final PermissionState result = await PhotoManager.requestPermissionExtend();
      if (result.isAuth) {
        final Uint8List? logoImage = await _captureCanvasAsImage();

        if (logoImage != null) {
          final AssetEntity? asset = await PhotoManager.editor.saveImage(
            filename: '',
            logoImage,
            title: 'Logo_${DateTime.now().millisecondsSinceEpoch}.png',
          );

          if (asset != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 12),
                    Text('Logo saved successfully!'),
                  ],
                ),
                backgroundColor: Colors.green[600],
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.all(16),
              ),
            );
          } else {
            throw Exception('Failed to save the image');
          }
        } else {
          throw Exception('Failed to capture the canvas');
        }
      } else {
        throw Exception('Permission denied');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text('Failed to save: ${e.toString()}')),
            ],
          ),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  Future<Uint8List?> _captureCanvasAsImage() async {
    try {
      await Future.delayed(const Duration(milliseconds: 20));

      final RenderRepaintBoundary? boundary = _canvasKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) {
        debugPrint('Render boundary is null');
        return null;
      }
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        return byteData.buffer.asUint8List();
      }
      debugPrint('ByteData is null');
      return null;
    } catch (e) {
      debugPrint('Error capturing canvas: $e');
      return null;
    }
  }

  _EditableText? _selectedText;
  _EditableShape? _selectedShape;
  _EditableElement? _selectedElement;
  _EditableImage? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images.add(_EditableImage(
          imageFile: File(pickedFile.path),
          offset: const Offset(100, 100),
          size: const Size(150, 150),
        ));
      });
    }
  }

  void _addShape(ShapeType shapeType) {
    setState(() {
      _shapes.add(_EditableShape(
        shapeType: shapeType,
        color: const Color(0xFF6C63FF),
        size: const Size(80, 80),
        offset: const Offset(100, 100),
      ));
    });
  }

  void _addElement(Map<String, dynamic> elementData) {
    setState(() {
      _elements.add(_EditableElement(
        icon: elementData['icon'],
        name: elementData['name'],
        color: const Color(0xFF6C63FF),
        size: const Size(60, 60),
        offset: const Offset(100, 100),
      ));
    });
  }

  void _deleteSelectedItem() {
    setState(() {
      if (_selectedText != null) {
        _texts.remove(_selectedText);
        _selectedText = null;
      }

      if (_selectedShape != null) {
        _shapes.remove(_selectedShape);
        _selectedShape = null;
      }

      if (_selectedElement != null) {
        _elements.remove(_selectedElement);
        _selectedElement = null;
      }

      if (_selectedImage != null) {
        _images.remove(_selectedImage);
        _selectedImage = null;
      }
    });
  }

  void _selectText(_EditableText text) {
    setState(() {
      if (_selectedText == text) {
        _selectedText = null;
      } else {
        _selectedText = text;
        _selectedShape = null;
        _selectedElement = null;
        _selectedImage = null;
      }
    });
  }

  void _selectShape(_EditableShape shape) {
    setState(() {
      if (_selectedShape == shape) {
        _selectedShape = null;
      } else {
        _selectedShape = shape;
        _selectedText = null;
        _selectedElement = null;
        _selectedImage = null;
      }
    });
  }

  void _selectElement(_EditableElement element) {
    setState(() {
      if (_selectedElement == element) {
        _selectedElement = null;
      } else {
        _selectedElement = element;
        _selectedText = null;
        _selectedShape = null;
        _selectedImage = null;
      }
    });
  }

  void _selectImage(_EditableImage image) {
    setState(() {
      if (_selectedImage == image) {
        _selectedImage = null;
      } else {
        _selectedImage = image;
        _selectedText = null;
        _selectedShape = null;
        _selectedElement = null;
      }
    });
  }

  void _deselectAll() {
    setState(() {
      _selectedText = null;
      _selectedShape = null;
      _selectedElement = null;
      _selectedImage = null;
    });
  }

  Future<void> _loadSubscriptions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.user?.user.id;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showEditImagePopup(_EditableImage editableImage) {
    double selectedSize = editableImage.size.width;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(builder: (context, setModalState) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Edit Image',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Icon(Icons.photo_size_select_large, color: Colors.grey[600], size: 20),
                    const SizedBox(width: 8),
                    const Text('Size', style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 8),
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: const Color(0xFF6C63FF),
                    inactiveTrackColor: Colors.grey[200],
                    thumbColor: const Color(0xFF6C63FF),
                    overlayColor: const Color(0xFF6C63FF).withOpacity(0.2),
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                  ),
                  child: Slider(
                    value: selectedSize,
                    min: 50,
                    max: 300,
                    divisions: 25,
                    label: selectedSize.round().toString(),
                    onChanged: (value) {
                      setModalState(() {
                        selectedSize = value;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _images.remove(editableImage);
                            _selectedImage = null;
                          });
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Delete'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red[600],
                          side: BorderSide(color: Colors.red[200]!),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            editableImage.size = Size(selectedSize, selectedSize);
                          });
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.check),
                        label: const Text('Apply'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63FF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
      },
    );
  }

  void _showEditShapePopup(_EditableShape editableShape) {
    Color selectedColor = editableShape.color;
    double selectedSize = editableShape.size.width;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(builder: (context, setModalState) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Edit Shape',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Icon(Icons.palette, color: Colors.grey[600], size: 20),
                    const SizedBox(width: 8),
                    const Text('Color', style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  children: [
                    _modernColorPicker(const Color(0xFF6C63FF), selectedColor, (color) {
                      setModalState(() => selectedColor = color);
                    }),
                    _modernColorPicker(const Color(0xFFFF6B6B), selectedColor, (color) {
                      setModalState(() => selectedColor = color);
                    }),
                    _modernColorPicker(const Color(0xFF4ECDC4), selectedColor, (color) {
                      setModalState(() => selectedColor = color);
                    }),
                    _modernColorPicker(const Color(0xFFFFA502), selectedColor, (color) {
                      setModalState(() => selectedColor = color);
                    }),
                    _modernColorPicker(const Color(0xFF95E1D3), selectedColor, (color) {
                      setModalState(() => selectedColor = color);
                    }),
                    _modernColorPicker(const Color(0xFFF38181), selectedColor, (color) {
                      setModalState(() => selectedColor = color);
                    }),
                      _modernColorPicker(const ui.Color.fromARGB(255, 0, 0, 0), selectedColor, (color) {
                      setModalState(() => selectedColor = color);
                    }),
                  ],
                ),

                const SizedBox(height: 24),
                Row(
                  children: [
                    Icon(Icons.photo_size_select_large, color: Colors.grey[600], size: 20),
                    const SizedBox(width: 8),
                    const Text('Size', style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 8),
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: const Color(0xFF6C63FF),
                    inactiveTrackColor: Colors.grey[200],
                    thumbColor: const Color(0xFF6C63FF),
                    overlayColor: const Color(0xFF6C63FF).withOpacity(0.2),
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                  ),
                  child: Slider(
                    value: selectedSize,
                    min: 20,
                    max: 200,
                    divisions: 18,
                    label: selectedSize.round().toString(),
                    onChanged: (value) {
                      setModalState(() {
                        selectedSize = value;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _shapes.remove(editableShape);
                            _selectedShape = null;
                          });
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Delete'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red[600],
                          side: BorderSide(color: Colors.red[200]!),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            editableShape.color = selectedColor;
                            editableShape.size = Size(selectedSize, selectedSize);
                          });
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.check),
                        label: const Text('Apply'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63FF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
      },
    );
  }

  void _showEditElementPopup(_EditableElement editableElement) {
    Color selectedColor = editableElement.color;
    double selectedSize = editableElement.size.width;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(builder: (context, setModalState) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Edit ${editableElement.name}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Icon(Icons.palette, color: Colors.grey[600], size: 20),
                    const SizedBox(width: 8),
                    const Text('Color', style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  children: [
                    _modernColorPicker(const Color(0xFF6C63FF), selectedColor, (color) {
                      setModalState(() => selectedColor = color);
                    }),
                    _modernColorPicker(const Color(0xFFFF6B6B), selectedColor, (color) {
                      setModalState(() => selectedColor = color);
                    }),
                    _modernColorPicker(const Color(0xFF4ECDC4), selectedColor, (color) {
                      setModalState(() => selectedColor = color);
                    }),
                    _modernColorPicker(const Color(0xFFFFA502), selectedColor, (color) {
                      setModalState(() => selectedColor = color);
                    }),
                    _modernColorPicker(const Color(0xFF95E1D3), selectedColor, (color) {
                      setModalState(() => selectedColor = color);
                    }),
                    _modernColorPicker(const Color(0xFFF38181), selectedColor, (color) {
                      setModalState(() => selectedColor = color);
                    }),
                         _modernColorPicker(const ui.Color.fromARGB(255, 0, 0, 0), selectedColor, (color) {
                      setModalState(() => selectedColor = color);
                    }),
                  ],
                ),

                const SizedBox(height: 24),
                Row(
                  children: [
                    Icon(Icons.photo_size_select_large, color: Colors.grey[600], size: 20),
                    const SizedBox(width: 8),
                    const Text('Size', style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 8),
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: const Color(0xFF6C63FF),
                    inactiveTrackColor: Colors.grey[200],
                    thumbColor: const Color(0xFF6C63FF),
                    overlayColor: const Color(0xFF6C63FF).withOpacity(0.2),
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                  ),
                  child: Slider(
                    value: selectedSize,
                    min: 20,
                    max: 200,
                    divisions: 18,
                    label: selectedSize.round().toString(),
                    onChanged: (value) {
                      setModalState(() {
                        selectedSize = value;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _elements.remove(editableElement);
                            _selectedElement = null;
                          });
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Delete'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red[600],
                          side: BorderSide(color: Colors.red[200]!),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            editableElement.color = selectedColor;
                            editableElement.size = Size(selectedSize, selectedSize);
                          });
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.check),
                        label: const Text('Apply'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63FF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
      },
    );
  }

  void _showAddTextPopup() {
    final TextEditingController textController = TextEditingController();
    Color selectedColor = const Color(0xFF2D3142);
    String selectedFontFamily = _fontFamilies[0];
    double selectedFontSize = 24.0;
    bool isBold = false;
    bool isItalic = false;

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add Text',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    const SizedBox(height: 24),

                    TextField(
                      controller: textController,
                      decoration: InputDecoration(
                        labelText: 'Enter your text',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
                        ),
                      ),
                      autofocus: true,
                      onChanged: (value) => setDialogState(() {}),
                    ),

                    const SizedBox(height: 24),
                    const Text('Font Family', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedFontFamily,
                          isExpanded: true,
                          items: _fontFamilies.map((font) {
                            return DropdownMenuItem<String>(
                              value: font,
                              child: Text(font, style: TextStyle(fontFamily: font)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setDialogState(() {
                              selectedFontFamily = value!;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Text('Font Size', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6C63FF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${selectedFontSize.round()}',
                            style: const TextStyle(
                              color: Color(0xFF6C63FF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: const Color(0xFF6C63FF),
                        inactiveTrackColor: Colors.grey[200],
                        thumbColor: const Color(0xFF6C63FF),
                        overlayColor: const Color(0xFF6C63FF).withOpacity(0.2),
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                      ),
                      child: Slider(
                        value: selectedFontSize,
                        min: 10,
                        max: 48,
                        divisions: 38,
                        onChanged: (value) {
                          setDialogState(() {
                            selectedFontSize = value;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 24),
                    const Text('Font Style', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _styleToggleButton(
                            label: 'Bold',
                            icon: Icons.format_bold,
                            isSelected: isBold,
                            onTap: () {
                              setDialogState(() {
                                isBold = !isBold;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _styleToggleButton(
                            label: 'Italic',
                            icon: Icons.format_italic,
                            isSelected: isItalic,
                            onTap: () {
                              setDialogState(() {
                                isItalic = !isItalic;
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    const Text('Color', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      children: [
                        _modernColorPicker(const Color(0xFF2D3142), selectedColor, (color) {
                          setDialogState(() => selectedColor = color);
                        }),
                        _modernColorPicker(const Color(0xFFFF6B6B), selectedColor, (color) {
                          setDialogState(() => selectedColor = color);
                        }),
                        _modernColorPicker(const Color(0xFF6C63FF), selectedColor, (color) {
                          setDialogState(() => selectedColor = color);
                        }),
                        _modernColorPicker(const Color(0xFF4ECDC4), selectedColor, (color) {
                          setDialogState(() => selectedColor = color);
                        }),
                        _modernColorPicker(const Color(0xFFFFA502), selectedColor, (color) {
                          setDialogState(() => selectedColor = color);
                        }),
                        _modernColorPicker(const Color(0xFF95E1D3), selectedColor, (color) {
                          setDialogState(() => selectedColor = color);
                        }),
                      ],
                    ),

                    const SizedBox(height: 24),
                    const Text('Preview', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[50],
                      ),
                      child: Center(
                        child: Text(
                          textController.text.isEmpty ? 'Sample Text' : textController.text,
                          style: TextStyle(
                            color: selectedColor,
                            fontSize: selectedFontSize,
                            fontFamily: selectedFontFamily,
                            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                            fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(color: Colors.grey[300]!),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (textController.text.isNotEmpty) {
                                setState(() {
                                  _texts.add(_EditableText(
                                    text: textController.text,
                                    color: selectedColor,
                                    fontSize: selectedFontSize,
                                    fontFamily: selectedFontFamily,
                                    isBold: isBold,
                                    isItalic: isItalic,
                                    offset: const Offset(100, 100),
                                  ));
                                });
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C63FF),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Add Text'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  void _showEditTextPopup(_EditableText editableText) {
    final TextEditingController textController = TextEditingController(text: editableText.text);
    Color selectedColor = editableText.color;
    String selectedFontFamily = editableText.fontFamily;
    double selectedFontSize = editableText.fontSize;
    bool isBold = editableText.isBold;
    bool isItalic = editableText.isItalic;

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Edit Text',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    const SizedBox(height: 24),

                    TextField(
                      controller: textController,
                      decoration: InputDecoration(
                        labelText: 'Enter your text',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
                        ),
                      ),
                      autofocus: true,
                      onChanged: (value) => setDialogState(() {}),
                    ),

                    const SizedBox(height: 24),
                    const Text('Font Family', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedFontFamily,
                          isExpanded: true,
                          items: _fontFamilies.map((font) {
                            return DropdownMenuItem<String>(
                              value: font,
                              child: Text(font, style: TextStyle(fontFamily: font)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setDialogState(() {
                              selectedFontFamily = value!;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Text('Font Size', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6C63FF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${selectedFontSize.round()}',
                            style: const TextStyle(
                              color: Color(0xFF6C63FF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: const Color(0xFF6C63FF),
                        inactiveTrackColor: Colors.grey[200],
                        thumbColor: const Color(0xFF6C63FF),
                        overlayColor: const Color(0xFF6C63FF).withOpacity(0.2),
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                      ),
                      child: Slider(
                        value: selectedFontSize,
                        min: 10,
                        max: 48,
                        divisions: 38,
                        onChanged: (value) {
                          setDialogState(() {
                            selectedFontSize = value;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 24),
                    const Text('Font Style', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _styleToggleButton(
                            label: 'Bold',
                            icon: Icons.format_bold,
                            isSelected: isBold,
                            onTap: () {
                              setDialogState(() {
                                isBold = !isBold;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _styleToggleButton(
                            label: 'Italic',
                            icon: Icons.format_italic,
                            isSelected: isItalic,
                            onTap: () {
                              setDialogState(() {
                                isItalic = !isItalic;
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    const Text('Color', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      children: [
                        _modernColorPicker(const Color(0xFF2D3142), selectedColor, (color) {
                          setDialogState(() => selectedColor = color);
                        }),
                        _modernColorPicker(const Color(0xFFFF6B6B), selectedColor, (color) {
                          setDialogState(() => selectedColor = color);
                        }),
                        _modernColorPicker(const Color(0xFF6C63FF), selectedColor, (color) {
                          setDialogState(() => selectedColor = color);
                        }),
                        _modernColorPicker(const Color(0xFF4ECDC4), selectedColor, (color) {
                          setDialogState(() => selectedColor = color);
                        }),
                        _modernColorPicker(const Color(0xFFFFA502), selectedColor, (color) {
                          setDialogState(() => selectedColor = color);
                        }),
                        _modernColorPicker(const Color(0xFF95E1D3), selectedColor, (color) {
                          setDialogState(() => selectedColor = color);
                        }),
                     
                      ],
                    ),

                    const SizedBox(height: 24),
                    const Text('Preview', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[50],
                      ),
                      child: Center(
                        child: Text(
                          textController.text.isEmpty ? 'Sample Text' : textController.text,
                          style: TextStyle(
                            color: selectedColor,
                            fontSize: selectedFontSize,
                            fontFamily: selectedFontFamily,
                            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                            fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                _texts.remove(editableText);
                                _selectedText = null;
                              });
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.delete_outline),
                            label: const Text('Delete'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red[600],
                              side: BorderSide(color: Colors.red[200]!),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (textController.text.isNotEmpty) {
                                setState(() {
                                  editableText.text = textController.text;
                                  editableText.color = selectedColor;
                                  editableText.fontSize = selectedFontSize;
                                  editableText.fontFamily = selectedFontFamily;
                                  editableText.isBold = isBold;
                                  editableText.isItalic = isItalic;
                                });
                                Navigator.pop(context);
                              }
                            },
                            icon: const Icon(Icons.check),
                            label: const Text('Save'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C63FF),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Widget _styleToggleButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6C63FF) : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFF6C63FF) : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[700],
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _modernColorPicker(Color color, Color selectedColor, Function(Color) onTap) {
    final bool isSelected = color == selectedColor;
    return GestureDetector(
      onTap: () => onTap(color),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 3 : 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: isSelected
            ? const Icon(Icons.check, color: Colors.white, size: 24)
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF2D3142), size: 18),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Logo Maker',
          style: TextStyle(
            color: Color(0xFF2D3142),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_selectedText != null ||
              _selectedShape != null ||
              _selectedElement != null ||
              _selectedImage != null)
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.delete_outline, color: Colors.red[600], size: 20),
              ),
              onPressed: _deleteSelectedItem,
            ),
          IconButton(
            icon: _isSaving
                ? Container(
                    padding: const EdgeInsets.all(8),
                    child: const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C63FF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.file_download_outlined, color: Color(0xFF6C63FF), size: 20),
                  ),
            onPressed: _isSaving ? null : _saveLogoToGallery,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: RepaintBoundary(
                        key: _canvasKey,
                        child: GestureDetector(
                          onTap: _deselectAll,
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(widget.image),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                ..._images.map((image) => _buildEditableImage(image)),
                                ..._texts.map((text) => _buildEditableText(text)),
                                ..._shapes.map((shape) => _buildEditableShape(shape)),
                                ..._elements.map((element) => _buildEditableElement(element)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildModernToolButton(
                            icon: Icons.text_fields,
                            label: 'Text',
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
                            ),
                            onTap: _showAddTextPopup,
                          ),
                          _buildModernToolButton(
                            icon: Icons.image_outlined,
                            label: 'Image',
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF6B6B), Color(0xFFEE5A6F)],
                            ),
                            onTap: _pickImage,
                          ),
                          _buildModernToolButton(
                            icon: Icons.category_outlined,
                            label: 'Shapes',
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                            ),
                            onTap: () => _showShapesBottomSheet(),
                          ),
                          _buildModernToolButton(
                            icon: Icons.stars_outlined,
                            label: 'Elements',
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFA502), Color(0xFFFF8C42)],
                            ),
                            onTap: () => _showElementsBottomSheet(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildModernToolButton({
    required IconData icon,
    required String label,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: (gradient.colors.first).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF2D3142),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showShapesBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Choose Shape',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildModernShapeOption(ShapeType.circle, Icons.circle_outlined, 'Circle'),
                _buildModernShapeOption(ShapeType.rectangle, Icons.crop_square_rounded, 'Square'),
                _buildModernShapeOption(ShapeType.triangle, Icons.change_history, 'Triangle'),
                _buildModernShapeOption(ShapeType.star, Icons.star_outline, 'Star'),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildModernShapeOption(ShapeType shapeType, IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        _addShape(shapeType);
        Navigator.pop(context);
      },
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4ECDC4).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3142),
            ),
          ),
        ],
      ),
    );
  }

  void _showElementsBottomSheet() {
    final elements = [
      {'icon': Icons.favorite, 'name': 'Heart'},
      {'icon': Icons.star, 'name': 'Star'},
      {'icon': Icons.lightbulb_outline, 'name': 'Bulb'},
      {'icon': Icons.music_note, 'name': 'Music'},
      {'icon': Icons.camera_alt_outlined, 'name': 'Camera'},
      {'icon': Icons.phone_outlined, 'name': 'Phone'},
      {'icon': Icons.email_outlined, 'name': 'Email'},
      {'icon': Icons.location_on_outlined, 'name': 'Location'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Choose Element',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 220,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: elements.length,
                itemBuilder: (context, index) {
                  final element = elements[index];
                  return GestureDetector(
                    onTap: () {
                      _addElement(element);
                      Navigator.pop(context);
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFA502), Color(0xFFFF8C42)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFFA502).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            element['icon'] as IconData,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          element['name'] as String,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3142),
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
      ),
    );
  }

  Widget _buildEditableImage(_EditableImage editableImage) {
    return Positioned(
      left: editableImage.offset.dx,
      top: editableImage.offset.dy,
      child: GestureDetector(
        onTap: () => _selectImage(editableImage),
        onDoubleTap: () => _showEditImagePopup(editableImage),
        onPanUpdate: (details) {
          setState(() {
            editableImage.offset += details.delta;
          });
        },
        child: Container(
          width: editableImage.size.width,
          height: editableImage.size.height,
          decoration: BoxDecoration(
            border: _selectedImage == editableImage
                ? Border.all(color: const Color(0xFF6C63FF), width: 3)
                : null,
            borderRadius: BorderRadius.circular(12),
            boxShadow: _selectedImage == editableImage
                ? [
                    BoxShadow(
                      color: const Color(0xFF6C63FF).withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              editableImage.imageFile,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditableText(_EditableText editableText) {
    return Positioned(
      left: editableText.offset.dx,
      top: editableText.offset.dy,
      child: GestureDetector(
        onTap: () => _selectText(editableText),
        onDoubleTap: () => _showEditTextPopup(editableText),
        onPanUpdate: (details) {
          setState(() {
            editableText.offset += details.delta;
          });
        },
        child: Container(
          padding: _selectedText == editableText ? const EdgeInsets.all(8) : null,
          decoration: _selectedText == editableText
              ? BoxDecoration(
                  border: Border.all(color: const Color(0xFF6C63FF), width: 2),
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xFF6C63FF).withOpacity(0.1),
                )
              : null,
          child: Text(
            editableText.text,
            style: TextStyle(
              color: editableText.color,
              fontSize: editableText.fontSize,
              fontFamily: editableText.fontFamily,
              fontWeight: editableText.isBold ? FontWeight.bold : FontWeight.normal,
              fontStyle: editableText.isItalic ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditableShape(_EditableShape editableShape) {
    return Positioned(
      left: editableShape.offset.dx,
      top: editableShape.offset.dy,
      child: GestureDetector(
        onTap: () => _selectShape(editableShape),
        onDoubleTap: () => _showEditShapePopup(editableShape),
        onPanUpdate: (details) {
          setState(() {
            editableShape.offset += details.delta;
          });
        },
        child: Container(
          width: editableShape.size.width,
          height: editableShape.size.height,
          decoration: BoxDecoration(
            border: _selectedShape == editableShape
                ? Border.all(color: const Color(0xFF6C63FF), width: 3)
                : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: _buildShapeWidget(editableShape),
        ),
      ),
    );
  }

  Widget _buildEditableElement(_EditableElement editableElement) {
    return Positioned(
      left: editableElement.offset.dx,
      top: editableElement.offset.dy,
      child: GestureDetector(
        onTap: () => _selectElement(editableElement),
        onDoubleTap: () => _showEditElementPopup(editableElement),
        onPanUpdate: (details) {
          setState(() {
            editableElement.offset += details.delta;
          });
        },
        child: Container(
          width: editableElement.size.width,
          height: editableElement.size.height,
          decoration: BoxDecoration(
            border: _selectedElement == editableElement
                ? Border.all(color: const Color(0xFF6C63FF), width: 3)
                : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            editableElement.icon,
            color: editableElement.color,
            size: editableElement.size.width * 0.8,
          ),
        ),
      ),
    );
  }

  Widget _buildShapeWidget(_EditableShape shape) {
    switch (shape.shapeType) {
      case ShapeType.circle:
        return Container(
          decoration: BoxDecoration(
            color: shape.color,
            shape: BoxShape.circle,
          ),
        );
      case ShapeType.rectangle:
        return Container(
          decoration: BoxDecoration(
            color: shape.color,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      case ShapeType.triangle:
        return CustomPaint(
          painter: TrianglePainter(shape.color),
          size: shape.size,
        );
      case ShapeType.star:
        return CustomPaint(
          painter: StarPainter(shape.color),
          size: shape.size,
        );
    }
  }
}

class _EditableImage {
  File imageFile;
  Offset offset;
  Size size;

  _EditableImage({
    required this.imageFile,
    required this.offset,
    required this.size,
  });
}

class _EditableText {
  String text;
  Color color;
  double fontSize;
  String fontFamily;
  bool isBold;
  bool isItalic;
  Offset offset;

  _EditableText({
    required this.text,
    required this.color,
    required this.fontSize,
    required this.fontFamily,
    required this.isBold,
    required this.isItalic,
    required this.offset,
  });
}

class _EditableShape {
  ShapeType shapeType;
  Color color;
  Size size;
  Offset offset;

  _EditableShape({
    required this.shapeType,
    required this.color,
    required this.size,
    required this.offset,
  });
}

class _EditableElement {
  IconData icon;
  String name;
  Color color;
  Size size;
  Offset offset;

  _EditableElement({
    required this.icon,
    required this.name,
    required this.color,
    required this.size,
    required this.offset,
  });
}

enum ShapeType { circle, rectangle, triangle, star }

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Path path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class StarPainter extends CustomPainter {
  final Color color;

  StarPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Path path = Path();
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double outerRadius = math.min(centerX, centerY);
    final double innerRadius = outerRadius * 0.4;

    for (int i = 0; i < 10; i++) {
      final double angle = (i * math.pi) / 5;
      final double radius = i.isEven ? outerRadius : innerRadius;
      final double x = centerX + radius * math.cos(angle - math.pi / 2);
      final double y = centerY + radius * math.sin(angle - math.pi / 2);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}