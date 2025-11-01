// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:posternova/models/invoice_model.dart';
// import 'package:posternova/providers/invoices/invoice_provider.dart';
// import 'package:posternova/widgets/invoice_number_widget.dart';
// import 'package:posternova/widgets/language_widget.dart';
// import 'package:provider/provider.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:shared_preferences/shared_preferences.dart';

// // Redesigned, professional AddInvoiceScreen
// class AddInvoiceData extends StatefulWidget {
//   const AddInvoiceData({super.key});

//   @override
//   State<AddInvoiceData> createState() => _AddInvoiceScreenState();
// }

// class _AddInvoiceScreenState extends State<AddInvoiceData> {
//   bool _isListening = false;
//   TextEditingController? _activeController;
//   late stt.SpeechToText _speech;
//   final _formKey = GlobalKey<FormState>();
//   final List<ProductEntry> _productEntries = [ProductEntry()];
//   bool _isLoading = false;
//   bool _isGoldShop = false;

//   // User profile data
//   String _userName = '';
//   String _userMobile = '';
//   String _userAddress = '';

//   // Logo image
//   String? _logoImagePath;
//   String? _logoImageBase64;
//   final ImagePicker _picker = ImagePicker();

//   final List<String> units = [
//     'Kg',
//     'Gram',
//     'Milligram',
//     'Liter',
//     'Milliliter',
//     'Piece',
//     'Pack',
//     'Dozen'
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _speech = stt.SpeechToText();
//     _initializeSpeech();

//     if (_productEntries.isNotEmpty) _productEntries.first.unit = units.first;
//     _loadUserData();
//     _checkBusinessType();
//     _loadLogoImage();
//   }

//   Future<void> _checkBusinessType() async {
//     final prefs = await SharedPreferences.getInstance();
//     final businessType = prefs.getString('businessType') ?? '';
//     if (mounted) {
//       setState(() {
//         _isGoldShop = businessType == 'Gold Shop';
//       });
//     }
//   }

//   Future<void> _loadUserData() async {
//     final prefs = await SharedPreferences.getInstance();
//     if (mounted) {
//       setState(() {
//         _userName = prefs.getString('user_name') ?? '';
//         _userMobile = prefs.getString('user_mobile') ?? '';
//         _userAddress = prefs.getString('user_address') ?? '';

//         for (var entry in _productEntries) {
//           entry.nameController.text = _userName;
//           entry.mobileController.text = _userMobile;
//           entry.addressController.text = _userAddress;
//         }
//       });
//     }
//   }

//   Future<void> _loadLogoImage() async {
//     final prefs = await SharedPreferences.getInstance();
//     final logoBase64 = prefs.getString('logo_image');
//     if (logoBase64 != null && logoBase64.isNotEmpty && mounted) {
//       setState(() => _logoImageBase64 = logoBase64);
//     }
//   }

//   Future<void> _saveUserData() async {
//     if (_productEntries.isNotEmpty) {
//       final entry = _productEntries.first;
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('user_name', entry.nameController.text);
//       await prefs.setString('user_mobile', entry.mobileController.text);
//       await prefs.setString('user_address', entry.addressController.text);
//     }
//   }

//   Future<void> _pickImage() async {
//     try {
//       final XFile? image = await _picker.pickImage(
//         source: ImageSource.gallery,
//         maxWidth: 600,
//         maxHeight: 600,
//         imageQuality: 85,
//       );
//       if (image != null) {
//         final bytes = await image.readAsBytes();
//         final base64Image = base64Encode(bytes);
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('logo_image', base64Image);
//         if (mounted) {
//           setState(() {
//             _logoImagePath = image.path;
//             _logoImageBase64 = base64Image;
//           });
//         }
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Logo saved'), backgroundColor: Colors.green),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error picking image: $e'), backgroundColor: Colors.red),
//       );
//     }
//   }

//   Future<void> _initializeSpeech() async {
//     bool available = await _speech.initialize(
//       onStatus: (status) => debugPrint('Speech status: $status'),
//       onError: (error) => debugPrint('Speech error: $error'),
//     );
//     if (!available) debugPrint('Speech recognition not available');
//   }

//   @override
//   void dispose() {
//     _speech.stop();
//     for (var e in _productEntries) {
//       e.dispose();
//     }
//     super.dispose();
//   }

//   void _startListening(TextEditingController controller) async {
//     _activeController = controller;
//     if (!_isListening) {
//       bool available = await _speech.initialize(
//         onStatus: (status) {
//           if (status == 'done' && mounted) setState(() => _isListening = false);
//         },
//         onError: (error) => debugPrint('Speech error: $error'),
//       );
//       if (available) {
//         setState(() => _isListening = true);
//         _speech.listen(onResult: (result) {
//           if (_activeController != null && mounted) {
//             setState(() {
//               _activeController!.text = result.recognizedWords;
//               _syncUserInfoAcrossEntries();
//             });
//           }
//         });
//       }
//     } else {
//       setState(() => _isListening = false);
//       _speech.stop();
//     }
//   }

//   void _syncUserInfoAcrossEntries() {
//     if (_productEntries.isEmpty) return;
//     final first = _productEntries.first;
//     final name = first.nameController.text;
//     final mobile = first.mobileController.text;
//     final address = first.addressController.text;
//     for (int i = 1; i < _productEntries.length; i++) {
//       _productEntries[i].nameController.text = name;
//       _productEntries[i].mobileController.text = mobile;
//       _productEntries[i].addressController.text = address;
//     }
//   }

//   Future<void> _saveInvoice() async {
//     if (!_formKey.currentState!.validate()) return;
//     for (var e in _productEntries) {
//       if (e.unit == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Select units for all products'), backgroundColor: Colors.red),
//         );
//         return;
//       }
//     }

//     setState(() => _isLoading = true);
//     try {
//       await _saveUserData();
//       final List<ProductItem> products = _productEntries.map((entry) {
//         final invoiceNumberStr = generateInvoiceNumber().toString();
//         return ProductItem(
//           invoiceNumber: invoiceNumberStr,
//           productName: entry.productNameController.text.trim(),
//           quantity: double.tryParse(entry.quantityController.text) ?? 0.0,
//           invoiceDate: DateTime.now(),
//           unit: entry.unit ?? units.first,
//           price: double.tryParse(entry.priceController.text) ?? 0.0,
//           offerPrice: double.tryParse(entry.offerPriceController.text) ?? 0.0,
//           name: _productEntries.first.nameController.text.trim(),
//           mobilenumber: _productEntries.first.mobileController.text.trim(),
//           address: _productEntries.first.addressController.text.trim(),
//           hsn: _productEntries.first.hsnController.text.trim(),
//           wastage: _isGoldShop ? double.tryParse(entry.wastageController.text) ?? 0.0 : 0.0,
//           isGoldItem: _isGoldShop,
//           description: entry.descriptionController.text.trim(),
//           imagelogo: _logoImageBase64 ?? '',
//         );
//       }).toList();

//       final success = await Provider.of<ProductInvoiceProvider>(context, listen: false).addInvoice(products);
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(success ? 'Invoice created' : 'Failed to create invoice'), backgroundColor: success ? Colors.green : Colors.red),
//         );
//         if (success) Navigator.of(context).pop();
//       }
//     } catch (e) {
//       if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: const AppText('create_invoice', style: TextStyle(fontWeight: FontWeight.bold)),
//         centerTitle: true,
//         elevation: 2,
//         actions: [
//           IconButton(
//             tooltip: 'Choose Logo',
//             onPressed: _pickImage,
//             icon: const Icon(Icons.image_outlined),
//           )
//         ],
//       ),
//       body: SafeArea(
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               // Header card with logo and summary
//               Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Card(
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   elevation: 2,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//                     child: Row(
//                       children: [
//                         Container(
//                           width: 72,
//                           height: 72,
//                           decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey.shade100),
//                           child: _logoImageBase64 != null
//                               ? ClipRRect(
//                                   borderRadius: BorderRadius.circular(10),
//                                   child: Image.memory(base64Decode(_logoImageBase64!), fit: BoxFit.cover),
//                                 )
//                               : _logoImagePath != null
//                                   ? ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.file(File(_logoImagePath!), fit: BoxFit.cover))
//                                   : Center(child: Icon(Icons.storefront_outlined, size: 36, color: theme.primaryColor)),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(AppText.translate(context, 'invoice_preview'), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
//                               const SizedBox(height: 6),
//                               Text('${AppText.translate(context, 'customer')}: $_userName', style: theme.textTheme.bodyMedium),
//                               Text('${AppText.translate(context, 'mobile')}: $_userMobile', style: theme.textTheme.bodyMedium),
//                             ],
//                           ),
//                         ),
//                         // IconButton(
//                         //   onPressed: () {
//                         //     setState(() {
//                         //       _productEntries.clear();
//                         //       _productEntries.add(ProductEntry()..unit = units.first);
//                         //     });
//                         //   },
//                         //   icon: const Icon(Icons.refresh_rounded),
//                         //   tooltip: 'Reset form',
//                         // )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),

//               // Flexible list of product cards
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                   child: ListView.builder(
//                     itemCount: _productEntries.length,
//                     itemBuilder: (context, index) {
//                       final entry = _productEntries[index];
//                       return _productCard(entry, index);
//                     },
//                   ),
//                 ),
//               ),

//               // Bottom action bar
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//                 color: Colors.white,
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: OutlinedButton.icon(
//                         onPressed: () {
//                           setState(() {
//                             final newEntry = ProductEntry()..unit = units.first;
//                             // Copy user info
//                             if (_productEntries.isNotEmpty) {
//                               final first = _productEntries.first;
//                               newEntry.nameController.text = first.nameController.text;
//                               newEntry.mobileController.text = first.mobileController.text;
//                               newEntry.addressController.text = first.addressController.text;
//                             }
//                             _productEntries.add(newEntry);
//                           });
//                         },
//                         icon: const Icon(Icons.add),
//                         label: const AppText('add_more'),
//                         style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     SizedBox(
//                       width: 160,
//                       child: ElevatedButton(
//                         onPressed: _isLoading ? null : _saveInvoice,
//                         style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
//                         child: _isLoading
//                             ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
//                             : const AppText('create', style: TextStyle(color: Colors.black)),
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _productCard(ProductEntry entry, int index) {
//     final bool showUserInfo = index == 0;
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12, top: 6),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 1,
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: Text('${AppText.translate(context, 'item')} ${index + 1}', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
//                 ),
//                 if (_productEntries.length > 1)
//                   IconButton(
//                     onPressed: () {
//                       setState(() => _productEntries.removeAt(index));
//                     },
//                     icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
//                   )
//               ],
//             ),
//             const SizedBox(height: 8),

//             if (showUserInfo) ...[
//               _buildTextField(entry.nameController, 'customer_name', prefix: Icons.person, onChanged: (v) => _syncUserInfoAcrossEntries()),
//               const SizedBox(height: 10),
//               Row(children: [
//                 Expanded(child: _buildTextField(entry.mobileController, 'customer_mobile', prefix: Icons.smartphone, inputType: TextInputType.phone, onChanged: (v) => _syncUserInfoAcrossEntries())),
//                 const SizedBox(width: 8),
//                 // IconButton(onPressed: () => _startListening(entry.mobileController), icon: Icon(_isListening && _activeController == entry.mobileController ? Icons.mic : Icons.mic_none))
//               ]),
//               const SizedBox(height: 10),
//               _buildTextField(entry.addressController, 'customer_address', prefix: Icons.location_on, maxLines: 2, onChanged: (v) => _syncUserInfoAcrossEntries()),
//               const Divider(height: 18),
//             ],

//             _buildTextField(entry.productNameController, 'product_name', prefix: Icons.shopping_bag),
//             const SizedBox(height: 10),

//             Row(children: [
//               Expanded(child: _buildTextField(entry.quantityController, 'quantity', inputType: TextInputType.number)),
//               const SizedBox(width: 10),
//               SizedBox(
//                 width: 140,
//                 child: DropdownButtonFormField<String>(
//                   value: entry.unit,
//                   decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12)),
//                   items: units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
//                   onChanged: (v) => setState(() => entry.unit = v),
//                 ),
//               ),
//             ]),

//             const SizedBox(height: 10),
//             _buildTextField(entry.descriptionController, 'description', maxLines: 2),
//             const SizedBox(height: 10),

//             if (_isGoldShop) ...[
//               _buildTextField(entry.wastageController, 'Wastage', inputType: TextInputType.number),
//               const SizedBox(height: 10),
//             ],

//             Row(children: [
//               Expanded(child: _buildTextField(entry.priceController, 'price', inputType: TextInputType.number, prefix: Icons.currency_rupee)),
//               const SizedBox(width: 10),
//               Expanded(child: _buildTextField(entry.offerPriceController, 'offer_price', inputType: TextInputType.number, prefix: Icons.local_offer)),
//             ]),
//             const SizedBox(height: 10),
//             _buildTextField(entry.hsnController, 'hsn', inputType: TextInputType.number),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(TextEditingController controller, String labelKey,
//       {TextInputType inputType = TextInputType.text, IconData? prefix, int maxLines = 1, Function(String)? onChanged}) {
//     final label = AppText.translate(context, labelKey);
//     final isActive = _activeController == controller && _isListening;
//     return TextFormField(
//       controller: controller,
//       keyboardType: inputType,
//       maxLines: maxLines,
//       onChanged: onChanged,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: prefix != null ? Icon(prefix) : null,
//         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//         enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
//         focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2), borderRadius: BorderRadius.circular(10)),
//       ),
//       validator: (value) {
//         if (value == null || value.trim().isEmpty) {
//           if (_isGoldShop || !(label == 'Taguru' || label == 'Wastage')) return 'Enter $label';
//         }
//         if (inputType == TextInputType.number && value != null && value.isNotEmpty) {
//           try {
//             double.parse(value);
//           } catch (e) {
//             return 'Enter a valid number';
//           }
//         }
//         return null;
//       },
//     );
//   }
// }

// class ProductEntry {
//   final TextEditingController productNameController = TextEditingController();
//   final TextEditingController quantityController = TextEditingController();
//   final TextEditingController priceController = TextEditingController();
//   final TextEditingController offerPriceController = TextEditingController();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController mobileController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   final TextEditingController wastageController = TextEditingController();
//   final TextEditingController hsnController = TextEditingController();
//   String? unit;

//   void dispose() {
//     productNameController.dispose();
//     quantityController.dispose();
//     priceController.dispose();
//     offerPriceController.dispose();
//     nameController.dispose();
//     mobileController.dispose();
//     addressController.dispose();
//     descriptionController.dispose();
//     wastageController.dispose();
//     hsnController.dispose();
//   }
// }














import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:posternova/models/invoice_model.dart';
import 'package:posternova/providers/invoices/invoice_provider.dart';
import 'package:posternova/widgets/invoice_number_widget.dart';
import 'package:posternova/widgets/language_widget.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:shared_preferences/shared_preferences.dart';

class AddInvoiceData extends StatefulWidget {
  const AddInvoiceData({super.key});

  @override
  State<AddInvoiceData> createState() => _AddInvoiceScreenState();
}

class _AddInvoiceScreenState extends State<AddInvoiceData> {
  bool _isListening = false;
  TextEditingController? _activeController;
  late stt.SpeechToText _speech;
  final _formKey = GlobalKey<FormState>();
  final List<ProductEntry> _productEntries = [ProductEntry()];
  bool _isLoading = false;
  bool _isGoldShop = false;

  String _userName = '';
  String _userMobile = '';
  String _userAddress = '';
  String? _logoImagePath;
  String? _logoImageBase64;
  final ImagePicker _picker = ImagePicker();

  final List<String> units = [
    'Kg',
    'Gram',
    'Milligram',
    'Liter',
    'Milliliter',
    'Piece',
    'Pack',
    'Dozen'
  ];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initializeSpeech();
    if (_productEntries.isNotEmpty) _productEntries.first.unit = units.first;
    _loadUserData();
    _checkBusinessType();
    _loadLogoImage();
  }

  Future<void> _checkBusinessType() async {
    final prefs = await SharedPreferences.getInstance();
    final businessType = prefs.getString('businessType') ?? '';
    if (mounted) {
      setState(() {
        _isGoldShop = businessType == 'Gold Shop';
      });
    }
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _userName = prefs.getString('user_name') ?? '';
        _userMobile = prefs.getString('user_mobile') ?? '';
        _userAddress = prefs.getString('user_address') ?? '';

        for (var entry in _productEntries) {
          entry.nameController.text = _userName;
          entry.mobileController.text = _userMobile;
          entry.addressController.text = _userAddress;
        }
      });
    }
  }

  Future<void> _loadLogoImage() async {
    final prefs = await SharedPreferences.getInstance();
    final logoBase64 = prefs.getString('logo_image');
    if (logoBase64 != null && logoBase64.isNotEmpty && mounted) {
      setState(() => _logoImageBase64 = logoBase64);
    }
  }

  Future<void> _saveUserData() async {
    if (_productEntries.isNotEmpty) {
      final entry = _productEntries.first;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', entry.nameController.text);
      await prefs.setString('user_mobile', entry.mobileController.text);
      await prefs.setString('user_address', entry.addressController.text);
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 85,
      );
      if (image != null) {
        final bytes = await image.readAsBytes();
        final base64Image = base64Encode(bytes);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('logo_image', base64Image);
        if (mounted) {
          setState(() {
            _logoImagePath = image.path;
            _logoImageBase64 = base64Image;
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logo saved successfully'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _initializeSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) => debugPrint('Speech status: $status'),
      onError: (error) => debugPrint('Speech error: $error'),
    );
    if (!available) debugPrint('Speech recognition not available');
  }

  @override
  void dispose() {
    _speech.stop();
    for (var e in _productEntries) {
      e.dispose();
    }
    super.dispose();
  }

  void _startListening(TextEditingController controller) async {
    _activeController = controller;
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done' && mounted) setState(() => _isListening = false);
        },
        onError: (error) => debugPrint('Speech error: $error'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (result) {
          if (_activeController != null && mounted) {
            setState(() {
              _activeController!.text = result.recognizedWords;
              _syncUserInfoAcrossEntries();
            });
          }
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _syncUserInfoAcrossEntries() {
    if (_productEntries.isEmpty) return;
    final first = _productEntries.first;
    final name = first.nameController.text;
    final mobile = first.mobileController.text;
    final address = first.addressController.text;
    for (int i = 1; i < _productEntries.length; i++) {
      _productEntries[i].nameController.text = name;
      _productEntries[i].mobileController.text = mobile;
      _productEntries[i].addressController.text = address;
    }
  }

  Future<void> _saveInvoice() async {
    if (!_formKey.currentState!.validate()) return;
    for (var e in _productEntries) {
      if (e.unit == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select units for all products'), backgroundColor: Colors.orange),
        );
        return;
      }
    }

    setState(() => _isLoading = true);
    try {
      await _saveUserData();
      final List<ProductItem> products = _productEntries.map((entry) {
        final invoiceNumberStr = generateInvoiceNumber().toString();
        return ProductItem(
          invoiceNumber: invoiceNumberStr,
          productName: entry.productNameController.text.trim(),
          quantity: double.tryParse(entry.quantityController.text) ?? 0.0,
          invoiceDate: DateTime.now(),
          unit: entry.unit ?? units.first,
          price: double.tryParse(entry.priceController.text) ?? 0.0,
          offerPrice: double.tryParse(entry.offerPriceController.text) ?? 0.0,
          name: _productEntries.first.nameController.text.trim(),
          mobilenumber: _productEntries.first.mobileController.text.trim(),
          address: _productEntries.first.addressController.text.trim(),
          hsn: _productEntries.first.hsnController.text.trim(),
          wastage: _isGoldShop ? double.tryParse(entry.wastageController.text) ?? 0.0 : 0.0,
          isGoldItem: _isGoldShop,
          description: entry.descriptionController.text.trim(),
          imagelogo: _logoImageBase64 ?? '',
        );
      }).toList();

      final success = await Provider.of<ProductInvoiceProvider>(context, listen: false).addInvoice(products);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'Invoice created successfully' : 'Failed to create invoice'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
        if (success) Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const AppText(
          'create_invoice',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey[200],
            height: 1,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Business Info Header
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue[100]!, width: 2),
                        ),
                        child: _logoImageBase64 != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.memory(
                                  base64Decode(_logoImageBase64!),
                                  fit: BoxFit.cover,
                                ),
                              )
                            : _logoImagePath != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      File(_logoImagePath!),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Icon(Icons.add_photo_alternate_outlined, color: Colors.blue[300], size: 32),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _userName.isEmpty ? 'Business Name' : _userName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (_userMobile.isNotEmpty)
                            Row(
                              children: [
                                Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Text(
                                  _userMobile,
                                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                                ),
                              ],
                            ),
                          if (_userAddress.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    _userAddress,
                                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Product Entries List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: _productEntries.length,
                  itemBuilder: (context, index) {
                    final entry = _productEntries[index];
                    return _buildModernProductCard(entry, index);
                  },
                ),
              ),

              // Bottom Action Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              final newEntry = ProductEntry()..unit = units.first;
                              if (_productEntries.isNotEmpty) {
                                final first = _productEntries.first;
                                newEntry.nameController.text = first.nameController.text;
                                newEntry.mobileController.text = first.mobileController.text;
                                newEntry.addressController.text = first.addressController.text;
                              }
                              _productEntries.add(newEntry);
                            });
                          },
                          icon: const Icon(Icons.add_circle_outline),
                          label: const AppText('add_more'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: Colors.blue[700]!, width: 1.5),
                            foregroundColor: Colors.blue[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _saveInvoice,
                          icon: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Icon(Icons.check_circle_outline, color: Colors.white),
                          label: AppText(
                            _isLoading ? 'creating' : 'create',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.blue[700],
                            disabledBackgroundColor: Colors.blue[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernProductCard(ProductEntry entry, int index) {
    final bool showUserInfo = index == 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Card Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue[700],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${AppText.translate(context, 'item')} ${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                const Spacer(),
                if (_productEntries.length > 1)
                  IconButton(
                    onPressed: () {
                      setState(() => _productEntries.removeAt(index));
                    },
                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                    tooltip: 'Remove item',
                  ),
              ],
            ),
          ),

          // Card Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showUserInfo) ...[
                  _buildSectionTitle('Customer Information'),
                  const SizedBox(height: 12),
                  _buildModernTextField(
                    entry.nameController,
                    'customer_name',
                    Icons.person_outline,
                    onChanged: (v) => _syncUserInfoAcrossEntries(),
                  ),
                  const SizedBox(height: 12),
                  _buildModernTextField(
                    entry.mobileController,
                    'customer_mobile',
                    Icons.phone_outlined,
                    inputType: TextInputType.phone,
                    onChanged: (v) => _syncUserInfoAcrossEntries(),
                  ),
                  const SizedBox(height: 12),
                  _buildModernTextField(
                    entry.addressController,
                    'customer_address',
                    Icons.location_on_outlined,
                    maxLines: 2,
                    onChanged: (v) => _syncUserInfoAcrossEntries(),
                  ),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Product Details'),
                  const SizedBox(height: 12),
                ],

                _buildModernTextField(
                  entry.productNameController,
                  'product_name',
                  Icons.inventory_2_outlined,
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildModernTextField(
                        entry.quantityController,
                        'quantity',
                        Icons.format_list_numbered,
                        inputType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: entry.unit,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'Unit',
                          labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        items: units.map((u) => DropdownMenuItem(
                          value: u, 
                          child: Text(u, style: const TextStyle(fontSize: 14)),
                        )).toList(),
                        onChanged: (v) => setState(() => entry.unit = v),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                _buildModernTextField(
                  entry.descriptionController,
                  'description',
                  Icons.description_outlined,
                  maxLines: 2,
                ),

                if (_isGoldShop) ...[
                  const SizedBox(height: 12),
                  _buildModernTextField(
                    entry.wastageController,
                    'Wastage',
                    Icons.scale_outlined,
                    inputType: TextInputType.number,
                  ),
                ],

                const SizedBox(height: 20),
                _buildSectionTitle('Pricing'),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _buildModernTextField(
                        entry.priceController,
                        'price',
                        Icons.currency_rupee,
                        inputType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildModernTextField(
                        entry.offerPriceController,
                        'offer_price',
                        Icons.local_offer_outlined,
                        inputType: TextInputType.number,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                _buildModernTextField(
                  entry.hsnController,
                  'hsn',
                  Icons.qr_code,
                  inputType: TextInputType.number,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildModernTextField(
    TextEditingController controller,
    String labelKey,
    IconData icon, {
    TextInputType inputType = TextInputType.text,
    int maxLines = 1,
    Function(String)? onChanged,
  }) {
    final label = AppText.translate(context, labelKey);
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      maxLines: maxLines,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.grey[600], size: 22),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          if (_isGoldShop || !(label == 'Taguru' || label == 'Wastage')) {
            return 'Please enter $label';
          }
        }
        if (inputType == TextInputType.number && value != null && value.isNotEmpty) {
          try {
            double.parse(value);
          } catch (e) {
            return 'Please enter a valid number';
          }
        }
        return null;
      },
    );
  }
}

class ProductEntry {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController offerPriceController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController wastageController = TextEditingController();
  final TextEditingController hsnController = TextEditingController();
  String? unit;

  void dispose() {
    productNameController.dispose();
    quantityController.dispose();
    priceController.dispose();
    offerPriceController.dispose();
    nameController.dispose();
    mobileController.dispose();
    addressController.dispose();
    descriptionController.dispose();
    wastageController.dispose();
    hsnController.dispose();
  }
}