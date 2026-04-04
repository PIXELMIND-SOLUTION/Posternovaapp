// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:posternova/models/invoice_model.dart';
// import 'package:posternova/providers/invoices/invoice_provider.dart';
// import 'package:posternova/widgets/invoice_number_widget.dart';
// import 'package:posternova/widgets/language_widget.dart';
// import 'package:provider/provider.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:shared_preferences/shared_preferences.dart';

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

//   String _gstRate = '';

//   String _userName = '';
//   String _userMobile = '';
//   String _userAddress = '';
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
//     'Dozen',
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
//         _gstRate = prefs.getString('gst_rate') ?? '';

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
//           const SnackBar(
//             content: Text('Logo saved successfully'),
//             backgroundColor: Colors.green,
//           ),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error picking image: $e'),
//           backgroundColor: Colors.red,
//         ),
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
//         _speech.listen(
//           onResult: (result) {
//             if (_activeController != null && mounted) {
//               setState(() {
//                 _activeController!.text = result.recognizedWords;
//                 _syncUserInfoAcrossEntries();
//               });
//             }
//           },
//         );
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
//           const SnackBar(
//             content: Text('Please select units for all products'),
//             backgroundColor: Colors.orange,
//           ),
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
//           wastage: _isGoldShop
//               ? double.tryParse(entry.wastageController.text) ?? 0.0
//               : 0.0,
//           isGoldItem: _isGoldShop,
//           description: entry.descriptionController.text.trim(),
//           imagelogo: _logoImageBase64 ?? '',
//         );
//       }).toList();

//       final success = await Provider.of<ProductInvoiceProvider>(
//         context,
//         listen: false,
//       ).addInvoice(products);
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               success
//                   ? 'Invoice created successfully'
//                   : 'Failed to create invoice',
//             ),
//             backgroundColor: success ? Colors.green : Colors.red,
//           ),
//         );
//         if (success) Navigator.of(context).pop();
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
//         );
//       }
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black87),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const AppText(
//           'create_invoice',
//           style: TextStyle(
//             color: Colors.black87,
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(1),
//           child: Container(color: Colors.grey[200], height: 1),
//         ),
//       ),
//       body: SafeArea(
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               // Business Info Header
//               Container(
//                 color: Colors.white,
//                 padding: const EdgeInsets.all(16),
//                 child: Row(
//                   children: [
//                     GestureDetector(
//                       onTap: _pickImage,
//                       child: Container(
//                         width: 70,
//                         height: 70,
//                         decoration: BoxDecoration(
//                           color: Colors.blue[50],
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color: Colors.blue[100]!,
//                             width: 2,
//                           ),
//                         ),
//                         child: _logoImageBase64 != null
//                             ? ClipRRect(
//                                 borderRadius: BorderRadius.circular(10),
//                                 child: Image.memory(
//                                   base64Decode(_logoImageBase64!),
//                                   fit: BoxFit.cover,
//                                 ),
//                               )
//                             : _logoImagePath != null
//                             ? ClipRRect(
//                                 borderRadius: BorderRadius.circular(10),
//                                 child: Image.file(
//                                   File(_logoImagePath!),
//                                   fit: BoxFit.cover,
//                                 ),
//                               )
//                             : Icon(
//                                 Icons.add_photo_alternate_outlined,
//                                 color: Colors.blue[300],
//                                 size: 32,
//                               ),
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           AppText(
//                             _userName.isEmpty ? 'business_name' : _userName,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.black87,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           if (_userMobile.isNotEmpty)
//                             Row(
//                               children: [
//                                 Icon(
//                                   Icons.phone,
//                                   size: 14,
//                                   color: Colors.grey[600],
//                                 ),
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   _userMobile,
//                                   style: TextStyle(
//                                     fontSize: 13,
//                                     color: Colors.grey[700],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           if (_userAddress.isNotEmpty) ...[
//                             const SizedBox(height: 2),
//                             Row(
//                               children: [
//                                 Icon(
//                                   Icons.location_on,
//                                   size: 14,
//                                   color: Colors.grey[600],
//                                 ),
//                                 const SizedBox(width: 4),
//                                 Expanded(
//                                   child: Text(
//                                     _userAddress,
//                                     style: TextStyle(
//                                       fontSize: 13,
//                                       color: Colors.grey[700],
//                                     ),
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 8),

//               // Product Entries List
//               Expanded(
//                 child: ListView.builder(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 8,
//                   ),
//                   itemCount: _productEntries.length,
//                   itemBuilder: (context, index) {
//                     final entry = _productEntries[index];
//                     return _buildModernProductCard(entry, index);
//                   },
//                 ),
//               ),

//               // Bottom Action Bar
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 10,
//                       offset: const Offset(0, -5),
//                     ),
//                   ],
//                 ),
//                 padding: const EdgeInsets.all(16),
//                 child: SafeArea(
//                   top: false,
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: OutlinedButton.icon(
//                           onPressed: () {
//                             setState(() {
//                               final newEntry = ProductEntry()
//                                 ..unit = units.first;
//                               if (_productEntries.isNotEmpty) {
//                                 final first = _productEntries.first;
//                                 newEntry.nameController.text =
//                                     first.nameController.text;
//                                 newEntry.mobileController.text =
//                                     first.mobileController.text;
//                                 newEntry.addressController.text =
//                                     first.addressController.text;
//                               }
//                               _productEntries.add(newEntry);
//                             });
//                           },
//                           icon: const Icon(Icons.add_circle_outline),
//                           label: const AppText('add_more'),
//                           style: OutlinedButton.styleFrom(
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             side: BorderSide(
//                               color: Colors.blue[700]!,
//                               width: 1.5,
//                             ),
//                             foregroundColor: Colors.blue[700],
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         flex: 2,
//                         child: ElevatedButton.icon(
//                           onPressed: _isLoading ? null : _saveInvoice,
//                           icon: _isLoading
//                               ? const SizedBox(
//                                   height: 20,
//                                   width: 20,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2,
//                                     valueColor: AlwaysStoppedAnimation<Color>(
//                                       Colors.white,
//                                     ),
//                                   ),
//                                 )
//                               : const Icon(
//                                   Icons.check_circle_outline,
//                                   color: Colors.white,
//                                 ),
//                           label: AppText(
//                             _isLoading ? 'creating' : 'create',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w600,
//                               fontSize: 16,
//                             ),
//                           ),
//                           style: ElevatedButton.styleFrom(
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             backgroundColor: Colors.blue[700],
//                             disabledBackgroundColor: Colors.blue[300],
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             elevation: 0,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildModernProductCard(ProductEntry entry, int index) {
//     final bool showUserInfo = index == 0;
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // Card Header
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.blue[50],
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(16),
//                 topRight: Radius.circular(16),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 6,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.blue[700],
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     '${AppText.translate(context, 'item')} ${index + 1}',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),
//                 const Spacer(),
//                 if (_productEntries.length > 1)
//                   IconButton(
//                     onPressed: () {
//                       setState(() => _productEntries.removeAt(index));
//                     },
//                     icon: const Icon(
//                       Icons.delete_outline_rounded,
//                       color: Colors.red,
//                     ),
//                     tooltip: 'Remove item',
//                   ),
//               ],
//             ),
//           ),

//           // Card Content
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (showUserInfo) ...[
//                   _buildSectionTitle('customer_information'),
//                   const SizedBox(height: 12),
//                   _buildModernTextField(
//                     entry.nameController,
//                     'customer_name',
//                     Icons.person_outline,
//                     inputType: TextInputType.text,
//                     onChanged: (v) => _syncUserInfoAcrossEntries(),
//                   ),
//                   const SizedBox(height: 12),
//                   _buildModernTextField(
//                     entry.mobileController,
//                     'customer_mobile',
//                     Icons.phone_outlined,
//                     inputType: TextInputType.phone,
//                     onChanged: (v) => _syncUserInfoAcrossEntries(),
//                   ),
//                   const SizedBox(height: 12),
//                   _buildModernTextField(
//                     entry.addressController,
//                     'customer_address',
//                     Icons.location_on_outlined,
//                     maxLines: 2,
//                     onChanged: (v) => _syncUserInfoAcrossEntries(),
//                   ),
//                   const SizedBox(height: 20),
//                   _buildSectionTitle('product_details'),
//                   const SizedBox(height: 12),
//                 ],

//                 _buildModernTextField(
//                   entry.productNameController,
//                   'product_name',
//                   Icons.inventory_2_outlined,
//                   inputType: TextInputType.text,
//                 ),
//                 const SizedBox(height: 12),

//                 Row(
//                   children: [
//                     Expanded(
//                       flex: 2,
//                       child: _buildModernTextField(
//                         entry.quantityController,
//                         'quantity',
//                         Icons.format_list_numbered,
//                         inputType: TextInputType.number,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: DropdownButtonFormField<String>(
//                         value: entry.unit,
//                         isExpanded: true,
//                         decoration: InputDecoration(
//                           labelText: 'Unit',
//                           labelStyle: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: 14,
//                           ),
//                           contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 16,
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide(color: Colors.grey[300]!),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide(color: Colors.grey[300]!),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide(
//                               color: Colors.blue[700]!,
//                               width: 2,
//                             ),
//                           ),
//                           filled: true,
//                           fillColor: Colors.grey[50],
//                         ),
//                         items: units
//                             .map(
//                               (u) => DropdownMenuItem(
//                                 value: u,
//                                 child: Text(
//                                   u,
//                                   style: const TextStyle(fontSize: 14),
//                                 ),
//                               ),
//                             )
//                             .toList(),
//                         onChanged: (v) => setState(() => entry.unit = v),
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 12),
//                 _buildModernTextField(
//                   entry.descriptionController,
//                   'description',
//                   Icons.description_outlined,
//                   maxLines: 2,
//                   isRequired: false,
//                 ),

//                 if (_isGoldShop) ...[
//                   const SizedBox(height: 12),
//                   _buildModernTextField(
//                     entry.wastageController,
//                     'Wastage',
//                     Icons.scale_outlined,
//                     inputType: TextInputType.number,
//                   ),
//                 ],

//                 const SizedBox(height: 20),
//                 _buildSectionTitle('total_and_taxes'),
//                 const SizedBox(height: 12),

//                 Row(
//                   children: [
//                     Expanded(
//                       child: _buildModernTextField(
//                         entry.priceController,
//                         'price',
//                         Icons.currency_rupee,
//                         inputType: TextInputType.number,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: _buildModernTextField(
//                         entry.offerPriceController,
//                         'offer_price',
//                         Icons.local_offer_outlined,
//                         inputType: TextInputType.number,
//                         isRequired: false,
//                       ),
//                     ),
//                   ],
//                 ),

//                 if (_gstRate.isNotEmpty) ...[
//                   const SizedBox(height: 12),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 12,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.blue[50],
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.blue[100]!),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(
//                           Icons.percent_outlined,
//                           color: Colors.blue[700],
//                           size: 20,
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           'GST Rate: $_gstRate%',
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.blue[700],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],

//                 const SizedBox(height: 12),
//                 _buildModernTextField(
//                   entry.hsnController,
//                   'hsn',
//                   Icons.qr_code,
//                   inputType: TextInputType.number,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return AppText(
//       title,
//       style: TextStyle(
//         fontSize: 15,
//         fontWeight: FontWeight.w600,
//         color: Colors.grey[800],
//       ),
//     );
//   }

//   // Widget _buildModernTextField(
//   //   TextEditingController controller,
//   //   String labelKey,
//   //   IconData icon, {
//   //   TextInputType inputType = TextInputType.text,
//   //   int maxLines = 1,
//   //   Function(String)? onChanged,
//   // }) {
//   //   final label = AppText.translate(context, labelKey);
//   //   return TextFormField(
//   //     controller: controller,
//   //     keyboardType: inputType,
//   //     maxLines: maxLines,
//   //     onChanged: onChanged,
//   //     style: const TextStyle(fontSize: 15),
//   //     decoration: InputDecoration(
//   //       labelText: label,
//   //       labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
//   //       prefixIcon: Icon(icon, color: Colors.grey[600], size: 22),
//   //       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//   //       border: OutlineInputBorder(
//   //         borderRadius: BorderRadius.circular(12),
//   //         borderSide: BorderSide(color: Colors.grey[300]!),
//   //       ),
//   //       enabledBorder: OutlineInputBorder(
//   //         borderRadius: BorderRadius.circular(12),
//   //         borderSide: BorderSide(color: Colors.grey[300]!),
//   //       ),
//   //       focusedBorder: OutlineInputBorder(
//   //         borderRadius: BorderRadius.circular(12),
//   //         borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
//   //       ),
//   //       errorBorder: OutlineInputBorder(
//   //         borderRadius: BorderRadius.circular(12),
//   //         borderSide: const BorderSide(color: Colors.red),
//   //       ),
//   //       focusedErrorBorder: OutlineInputBorder(
//   //         borderRadius: BorderRadius.circular(12),
//   //         borderSide: const BorderSide(color: Colors.red, width: 2),
//   //       ),
//   //       filled: true,
//   //       fillColor: Colors.grey[50],
//   //     ),
//   //     validator: (value) {
//   //       if (value == null || value.trim().isEmpty) {
//   //         if (_isGoldShop || !(label == 'Taguru' || label == 'Wastage')) {
//   //           return 'Please enter $label';
//   //         }
//   //       }
//   //       if (inputType == TextInputType.number && value != null && value.isNotEmpty) {
//   //         try {
//   //           double.parse(value);
//   //         } catch (e) {
//   //           return 'Please enter a valid number';
//   //         }
//   //       }
//   //       return null;
//   //     },
//   //   );
//   // }

//   //   Widget _buildModernTextField(
//   //   TextEditingController controller,
//   //   String labelKey,
//   //   IconData icon, {
//   //   TextInputType inputType = TextInputType.text,
//   //   int maxLines = 1,
//   //   Function(String)? onChanged,
//   // }) {
//   //   final label = AppText.translate(context, labelKey);
//   //   final theme = Theme.of(context);
//   //   final isDarkMode = theme.brightness == Brightness.dark;
//   //   final textColor = isDarkMode ? const Color.fromARGB(255, 0, 0, 0) : Colors.black87;

//   //   return TextFormField(
//   //     controller: controller,
//   //     keyboardType: inputType,
//   //     maxLines: maxLines,
//   //     onChanged: onChanged,
//   //     style: TextStyle(
//   //       fontSize: 15,
//   //       color: textColor, // Add this line
//   //     ),
//   //     decoration: InputDecoration(
//   //       labelText: label,
//   //       labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
//   //       prefixIcon: Icon(icon, color: Colors.grey[600], size: 22),
//   //       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//   //       border: OutlineInputBorder(
//   //         borderRadius: BorderRadius.circular(12),
//   //         borderSide: BorderSide(color: Colors.grey[300]!),
//   //       ),
//   //       enabledBorder: OutlineInputBorder(
//   //         borderRadius: BorderRadius.circular(12),
//   //         borderSide: BorderSide(color: Colors.grey[300]!),
//   //       ),
//   //       focusedBorder: OutlineInputBorder(
//   //         borderRadius: BorderRadius.circular(12),
//   //         borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
//   //       ),
//   //       errorBorder: OutlineInputBorder(
//   //         borderRadius: BorderRadius.circular(12),
//   //         borderSide: const BorderSide(color: Colors.red),
//   //       ),
//   //       focusedErrorBorder: OutlineInputBorder(
//   //         borderRadius: BorderRadius.circular(12),
//   //         borderSide: const BorderSide(color: Colors.red, width: 2),
//   //       ),
//   //       filled: true,
//   //       fillColor: Colors.grey[50],
//   //     ),
//   //     validator: (value) {
//   //       if (value == null || value.trim().isEmpty) {
//   //         if (_isGoldShop || !(label == 'Taguru' || label == 'Wastage')) {
//   //           return 'Please enter $label';
//   //         }
//   //       }
//   //       if (inputType == TextInputType.number && value != null && value.isNotEmpty) {
//   //         try {
//   //           double.parse(value);
//   //         } catch (e) {
//   //           return 'Please enter a valid number';
//   //         }
//   //       }
//   //       return null;
//   //     },
//   //   );
//   // }

//   Widget _buildModernTextField(
//     TextEditingController controller,
//     String labelKey,
//     IconData icon, {
//     TextInputType inputType = TextInputType.text,
//     int maxLines = 1,
//     Function(String)? onChanged,
//     bool isRequired = true, // Add this parameter
//   }) {
//     final label = AppText.translate(context, labelKey);
//     final theme = Theme.of(context);
//     final isDarkMode = theme.brightness == Brightness.dark;
//     final textColor = isDarkMode
//         ? const Color.fromARGB(255, 0, 0, 0)
//         : Colors.black87;
//     final bool isPhoneField = inputType == TextInputType.phone;

//     return TextFormField(
//       controller: controller,
//       keyboardType: inputType,
//       maxLines: maxLines,
//       onChanged: onChanged,
//       style: TextStyle(fontSize: 15, color: textColor),
//       inputFormatters: isPhoneField
//           ? [
//               FilteringTextInputFormatter.digitsOnly,
//               LengthLimitingTextInputFormatter(10),
//             ]
//           : null,
//       decoration: InputDecoration(
//         labelText: isRequired
//             ? label
//             : '$label (Optional)', // Add optional indicator
//         labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
//         prefixIcon: Icon(icon, color: Colors.grey[600], size: 22),
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 16,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey[300]!),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey[300]!),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Colors.red),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Colors.red, width: 2),
//         ),
//         filled: true,
//         fillColor: Colors.grey[50],
//       ),
//       validator: (value) {
//         // Skip validation if field is not required
//         if (!isRequired) {
//           // Still validate number format if it's a number field and has a value
//           if (inputType == TextInputType.number &&
//               value != null &&
//               value.isNotEmpty) {
//             try {
//               double.parse(value);
//             } catch (e) {
//               return 'Please enter a valid number';
//             }
//           }
//           return null;
//         }

//         // Original validation for required fields
//         if (value == null || value.trim().isEmpty) {
//           if (_isGoldShop || !(label == 'Taguru' || label == 'Wastage')) {
//             return 'Please enter $label';
//           }
//         }
//         if (inputType == TextInputType.number &&
//             value != null &&
//             value.isNotEmpty) {
//           try {
//             double.parse(value);
//           } catch (e) {
//             return 'Please enter a valid number';
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
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:posternova/models/invoice_model.dart';
import 'package:posternova/providers/invoices/invoice_provider.dart';
import 'package:posternova/views/invoices/image_cropper.dart';
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

  String _gstRate = '';

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
    'Dozen',
  ];

  bool get _isDarkMode => Theme.of(context).brightness == Brightness.dark;

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
        _gstRate = prefs.getString('gst_rate') ?? '';

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
      final picker = ImagePicker();
      final XFile? picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );

      if (picked == null) return;

      // Open cropper with optional aspect ratio (e.g., 1:1 for logo)
      final File? croppedFile = await Navigator.push<File>(
        context,
        MaterialPageRoute(
          builder: (_) => ImageCropperScreen(
            imageFile: File(picked.path),
            aspectRatio: 1.0, // 1:1 square for logo, set null for free crop
            title: 'Crop Logo',
          ),
        ),
      );

      if (croppedFile == null) return;

      final bytes = await croppedFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('logo_image', base64Image);

      if (mounted) {
        setState(() {
          _logoImagePath = croppedFile.path;
          _logoImageBase64 = base64Image;
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logo saved successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
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
        _speech.listen(
          onResult: (result) {
            if (_activeController != null && mounted) {
              setState(() {
                _activeController!.text = result.recognizedWords;
                _syncUserInfoAcrossEntries();
              });
            }
          },
        );
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
          const SnackBar(
            content: Text('Please select units for all products'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
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
          wastage: _isGoldShop
              ? double.tryParse(entry.wastageController.text) ?? 0.0
              : 0.0,
          isGoldItem: _isGoldShop,
          description: entry.descriptionController.text.trim(),
          imagelogo: _logoImageBase64 ?? '',
        );
      }).toList();

      final success = await Provider.of<ProductInvoiceProvider>(
        context,
        listen: false,
      ).addInvoice(products);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Invoice created successfully'
                  : 'Failed to create invoice',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        if (success) Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = _isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0F172A) : Colors.grey[50],
      appBar: AppBar(
        backgroundColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const AppText(
          'create_invoice',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
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
                color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? const Color(0xFF0F172A)
                              : Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDarkMode
                                ? Colors.grey[700]!
                                : Colors.blue[100]!,
                            width: 2,
                          ),
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
                            : Icon(
                                Icons.add_photo_alternate_outlined,
                                color: isDarkMode
                                    ? Colors.grey[500]
                                    : Colors.blue[300],
                                size: 32,
                              ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            _userName.isEmpty ? 'business_name' : _userName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (_userMobile.isNotEmpty)
                            Row(
                              children: [
                                Icon(
                                  Icons.phone,
                                  size: 14,
                                  color: isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _userMobile,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          if (_userAddress.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 14,
                                  color: isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    _userAddress,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isDarkMode
                                          ? Colors.grey[400]
                                          : Colors.grey[700],
                                    ),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
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
                  color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
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
                              final newEntry = ProductEntry()
                                ..unit = units.first;
                              if (_productEntries.isNotEmpty) {
                                final first = _productEntries.first;
                                newEntry.nameController.text =
                                    first.nameController.text;
                                newEntry.mobileController.text =
                                    first.mobileController.text;
                                newEntry.addressController.text =
                                    first.addressController.text;
                              }
                              _productEntries.add(newEntry);
                            });
                          },
                          icon: const Icon(Icons.add_circle_outline),
                          label: const AppText('add_more'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(
                              color: const Color(0xFFF5C518),
                              width: 1.5,
                            ),
                            foregroundColor: const Color(0xFFF5C518),
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
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.white,
                                ),
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
                            backgroundColor: const Color(0xFFF5C518),
                            foregroundColor: Colors.black87,
                            disabledBackgroundColor: const Color(
                              0xFFF5C518,
                            ).withOpacity(0.6),
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
    final isDarkMode = _isDarkMode;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.04),
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
              color: isDarkMode ? const Color(0xFF0F172A) : Colors.blue[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5C518),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${AppText.translate(context, 'item')} ${index + 1}',
                    style: const TextStyle(
                      color: Colors.black87,
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
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.red,
                    ),
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
                  _buildSectionTitle('customer_information'),
                  const SizedBox(height: 12),
                  _buildModernTextField(
                    entry.nameController,
                    'customer_name',
                    Icons.person_outline,
                    inputType: TextInputType.text,
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
                  _buildSectionTitle('product_details'),
                  const SizedBox(height: 12),
                ],

                _buildModernTextField(
                  entry.productNameController,
                  'product_name',
                  Icons.inventory_2_outlined,
                  inputType: TextInputType.text,
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
                        dropdownColor: isDarkMode
                            ? const Color(0xFF1E293B)
                            : Colors.white,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black87,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Unit',
                          labelStyle: TextStyle(
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[600],
                            fontSize: 14,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: isDarkMode
                                  ? Colors.grey[700]!
                                  : Colors.grey[300]!,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: isDarkMode
                                  ? Colors.grey[700]!
                                  : Colors.grey[300]!,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFF5C518),
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: isDarkMode
                              ? const Color(0xFF0F172A)
                              : Colors.grey[50],
                        ),
                        items: units
                            .map(
                              (u) => DropdownMenuItem(
                                value: u,
                                child: Text(
                                  u,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
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
                  isRequired: false,
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
                _buildSectionTitle('total_and_taxes'),
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
                        isRequired: false,
                      ),
                    ),
                  ],
                ),

                if (_gstRate.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? const Color(0xFF0F172A)
                          : Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDarkMode
                            ? Colors.grey[700]!
                            : Colors.blue[100]!,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.percent_outlined,
                          color: const Color(0xFFF5C518),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'GST Rate: $_gstRate%',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xFFF5C518),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

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
    final isDarkMode = _isDarkMode;

    return AppText(
      title,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: isDarkMode ? Colors.white : Colors.grey[800],
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
    bool isRequired = true,
  }) {
    final label = AppText.translate(context, labelKey);
    final isDarkMode = _isDarkMode;
    final bool isPhoneField = inputType == TextInputType.phone;

    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      maxLines: maxLines,
      onChanged: onChanged,
      style: TextStyle(
        fontSize: 15,
        color: isDarkMode ? Colors.white : Colors.black87,
      ),
      inputFormatters: isPhoneField
          ? [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ]
          : null,
      decoration: InputDecoration(
        labelText: isRequired ? label : '$label (Optional)',
        labelStyle: TextStyle(
          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          fontSize: 14,
        ),
        prefixIcon: Icon(
          icon,
          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          size: 22,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF5C518), width: 2),
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
        fillColor: isDarkMode ? const Color(0xFF0F172A) : Colors.grey[50],
      ),
      validator: (value) {
        if (!isRequired) {
          if (inputType == TextInputType.number &&
              value != null &&
              value.isNotEmpty) {
            try {
              double.parse(value);
            } catch (e) {
              return 'Please enter a valid number';
            }
          }
          return null;
        }

        if (value == null || value.trim().isEmpty) {
          if (_isGoldShop || !(label == 'Taguru' || label == 'Wastage')) {
            return 'Please enter $label';
          }
        }
        if (inputType == TextInputType.number &&
            value != null &&
            value.isNotEmpty) {
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
