// import 'dart:ui';
// import 'package:edit_ezy_project/providers/auth/auth_provider.dart';
// import 'package:edit_ezy_project/providers/business/business_category_provider.dart';
// import 'package:edit_ezy_project/providers/plans/getall_plan_provider.dart';
// import 'package:edit_ezy_project/views/subscriptions/animated_plan_listscreen.dart';
// import 'package:edit_ezy_project/views/subscriptions/plandetail_payment_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:flutter/services.dart';
// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:convert';

// class BusinessDataScreen extends StatefulWidget {
//   const BusinessDataScreen({super.key});

//   @override
//   State<BusinessDataScreen> createState() => _BusinessDataScreenState();
// }

// class _BusinessDataScreenState extends State<BusinessDataScreen>
//     with TickerProviderStateMixin {
//   Map<String, String> businessData = {
//     'name': '',
//     'email': '',
//     'phone': '',
//     'about': '',
//     'designation': '',
//     'whatsapp': '',
//     'address': '',
//     'gst': '',
//     'timings': '',
//   };
//   bool isLoading = true;
//   bool _isLoading = false;

//   // Animation controllers
//   late AnimationController _fadeController;
//   late AnimationController _slideController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;

//   // Add variables to store the logo and additional images
//   File? _logoImage;
//   File? _additionalImage;
//   Uint8List? _additionalImageBytes;
//   Uint8List? _logoBytes;

//   @override
//   void initState() {
//     super.initState();
    
//     // Initialize animations
//     _fadeController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _slideController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );
    
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
//     );
    
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    
//     _loadBusinessData();

//     // Ensure categories are loaded
//     Future.microtask(() {
//       if (!Provider.of<BusinessCategoryProvider>(context, listen: false)
//           .isLoading) {
//         Provider.of<BusinessCategoryProvider>(context, listen: false)
//             .fetchCategories();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _fadeController.dispose();
//     _slideController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadSubscriptions() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       final userId = authProvider.user?.user.id;
//       // await Provider.of<SubscriptionProvider>(context, listen: false)
//       //     .fetchSubscriptions(userId.toString());
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _loadBusinessData() async {
//     final prefs = await SharedPreferences.getInstance();

//     // Load logo data
//     final String? logoPath = prefs.getString('logo_path');
//     final String? logoBase64 = prefs.getString('logo_base64');

//     if (logoPath != null) {
//       final file = File(logoPath);
//       if (await file.exists()) {
//         _logoImage = file;
//       } else if (logoBase64 != null) {
//         _logoBytes = base64Decode(logoBase64);
//       }
//     } else if (logoBase64 != null) {
//       _logoBytes = base64Decode(logoBase64);
//     }

//     final String? additionalImagePath =
//         prefs.getString('additional_image_path');
//     final String? additionalImageBase64 =
//         prefs.getString('additional_image_base64');

//     if (additionalImagePath != null) {
//       final file = File(additionalImagePath);
//       if (await file.exists()) {
//         _additionalImage = file;
//       } else if (additionalImageBase64 != null) {
//         _additionalImageBytes = base64Decode(additionalImageBase64);
//       }
//     } else if (additionalImageBase64 != null) {
//       _additionalImageBytes = base64Decode(additionalImageBase64);
//     }

//     setState(() {
//       businessData = {
//         'name': prefs.getString('business_name') ?? 'Software Company',
//         'email': prefs.getString('email') ?? 'nvarma7475@gmail.com',
//         'phone': prefs.getString('phone_number') ?? '',
//         'about': prefs.getString('about') ?? '',
//         'designation': prefs.getString('designation') ?? '',
//         'whatsapp': prefs.getString('whatsapp_number') ?? '9666317749',
//         'address': prefs.getString('address') ?? 'Mig2, 205',
//         'gst': prefs.getString('gst_number') ?? '',
//         'timings': prefs.getString('business_timings') ?? 'Software Company',
//       };
//       isLoading = false;
//     });
    
//     // Start animations after data loads
//     _fadeController.forward();
//     _slideController.forward();
//   }

//   Future<void> _generateAndDownloadPDF() async {
//     try {
//       // Show modern loading dialog
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) => Dialog(
//           backgroundColor: Colors.transparent,
//           child: Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   'Generating PDF...',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.grey[700],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );

//       final pdf = pw.Document();

//       // Load logo image for PDF if available
//       pw.MemoryImage? logoImage;
//       if (_logoImage != null) {
//         final logoBytes = await _logoImage!.readAsBytes();
//         logoImage = pw.MemoryImage(logoBytes);
//       } else if (_logoBytes != null) {
//         logoImage = pw.MemoryImage(_logoBytes!);
//       }

//       // Load additional image for PDF if available
//       pw.MemoryImage? additionalImage;
//       if (_additionalImage != null) {
//         final additionalBytes = await _additionalImage!.readAsBytes();
//         additionalImage = pw.MemoryImage(additionalBytes);
//       } else if (_additionalImageBytes != null) {
//         additionalImage = pw.MemoryImage(_additionalImageBytes!);
//       }

//       pdf.addPage(
//         pw.MultiPage(
//           pageFormat: PdfPageFormat.a4,
//           margin: const pw.EdgeInsets.all(20),
//           build: (pw.Context context) {
//             return [
//               // Logo Section
//               if (logoImage != null)
//                 pw.Container(
//                   alignment: pw.Alignment.center,
//                   margin: const pw.EdgeInsets.only(bottom: 20),
//                   child: pw.Image(logoImage, height: 100, width: 200),
//                 ),

//               // Company Header
//               pw.Container(
//                 alignment: pw.Alignment.center,
//                 margin: const pw.EdgeInsets.only(bottom: 20),
//                 child: pw.Column(
//                   children: [
//                     pw.Text(
//                       businessData['name']!,
//                       style: pw.TextStyle(
//                         fontSize: 24,
//                         fontWeight: pw.FontWeight.bold,
//                       ),
//                     ),
//                     pw.SizedBox(height: 10),
//                     pw.Text(
//                       businessData['about']!,
//                       style: const pw.TextStyle(fontSize: 12),
//                       textAlign: pw.TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),

//               // About Us Section
//               _buildPDFSection(
//                 title: 'About Us',
//                 content: [
//                   'Name: ${businessData['name']}',
//                   'Designation: ${businessData['designation']}',
//                   '',
//                   businessData['about']!,
//                 ],
//               ),

//               pw.SizedBox(height: 20),

//               // Contact Details Section
//               _buildPDFSection(
//                 title: 'Contact Details',
//                 content: [
//                   if (businessData['whatsapp']!.isNotEmpty)
//                     'WhatsApp: ${businessData['whatsapp']}',
//                   if (businessData['email']!.isNotEmpty)
//                     'Email: ${businessData['email']}',
//                   if (businessData['phone']!.isNotEmpty)
//                     'Phone: ${businessData['phone']}',
//                   if (businessData['address']!.isNotEmpty)
//                     'Address: ${businessData['address']}',
//                 ],
//               ),

//               pw.SizedBox(height: 20),

//               // Business Info Section
//               _buildPDFSection(
//                 title: 'Business Info',
//                 content: [
//                   if (businessData['gst']!.isNotEmpty)
//                     'GST No: ${businessData['gst']}',
//                   if (businessData['timings']!.isNotEmpty)
//                     'Business Timings: ${businessData['timings']}',
//                 ],
//               ),

//               pw.SizedBox(height: 20),

//               // Additional Image Section
//               if (additionalImage != null)
//                 pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [
//                     pw.Text(
//                       'Product Images',
//                       style: pw.TextStyle(
//                         fontSize: 18,
//                         fontWeight: pw.FontWeight.bold,
//                       ),
//                     ),
//                     pw.SizedBox(height: 10),
//                     pw.Container(
//                       alignment: pw.Alignment.center,
//                       child: pw.Image(additionalImage, height: 200, width: 300),
//                     ),
//                   ],
//                 ),
//             ];
//           },
//         ),
//       );

//       // Generate PDF bytes
//       final pdfBytes = await pdf.save();

//       // Hide loading indicator
//       Navigator.of(context).pop();

//       // Try to save to Downloads folder (Android 10+)
//       try {
//         if (Platform.isAndroid) {
//           // For Android, use the Downloads directory
//           final directory = Directory('/storage/emulated/0/Download');
//           if (await directory.exists()) {
//             final file = File(
//                 '${directory.path}/${businessData['name']}_business_profile.pdf');
//             await file.writeAsBytes(pdfBytes);

//             _showSuccessSnackBar('PDF saved to Downloads folder', () async {
//               // You can use open_file package to open the PDF
//               // await OpenFile.open(file.path);
//             });
//           } else {
//             throw Exception('Downloads folder not accessible');
//           }
//         } else {
//           // For iOS, use documents directory
//           final directory = await getApplicationDocumentsDirectory();
//           final file = File(
//               '${directory.path}/${businessData['name']}_business_profile.pdf');
//           await file.writeAsBytes(pdfBytes);

//           _showSuccessSnackBar('PDF saved successfully', null);
//         }
//       } catch (e) {
//         // Fallback: Save to app documents directory
//         final directory = await getApplicationDocumentsDirectory();
//         final file = File(
//             '${directory.path}/${businessData['name']}_business_profile.pdf');
//         await file.writeAsBytes(pdfBytes);

//         _showWarningSnackBar('PDF saved to app storage', () async {
//           await Share.shareXFiles([XFile(file.path)]);
//         });
//       }
//     } catch (e) {
//       // Hide loading indicator if it's still showing
//       if (Navigator.of(context).canPop()) {
//         Navigator.of(context).pop();
//       }

//       _showErrorSnackBar('Failed to generate PDF: $e');
//     }
//   }

//   // Helper method to build PDF sections
//   pw.Widget _buildPDFSection({
//     required String title,
//     required List<String> content,
//   }) {
//     return pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         pw.Container(
//           width: double.infinity,
//           padding: const pw.EdgeInsets.all(10),
//           decoration: pw.BoxDecoration(
//             color: PdfColors.blue,
//             borderRadius: pw.BorderRadius.circular(5),
//           ),
//           child: pw.Text(
//             title,
//             style: pw.TextStyle(
//               fontSize: 16,
//               fontWeight: pw.FontWeight.bold,
//               color: PdfColors.white,
//             ),
//           ),
//         ),
//         pw.Container(
//           width: double.infinity,
//           padding: const pw.EdgeInsets.all(15),
//           decoration: pw.BoxDecoration(
//             border: pw.Border.all(color: PdfColors.grey),
//             borderRadius: const pw.BorderRadius.only(
//               bottomLeft: pw.Radius.circular(5),
//               bottomRight: pw.Radius.circular(5),
//             ),
//           ),
//           child: pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: content
//                 .map((text) => pw.Padding(
//                       padding: const pw.EdgeInsets.only(bottom: 5),
//                       child: pw.Text(text,
//                           style: const pw.TextStyle(fontSize: 12)),
//                     ))
//                 .toList(),
//           ),
//         ),
//       ],
//     );
//   }

//   Future<void> _shareBusinessCard() async {
//     try {
//       // Show modern loading dialog
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) => Dialog(
//           backgroundColor: Colors.transparent,
//           child: Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   'Preparing to share...',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.grey[700],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );

//       final pdf = pw.Document();

//       // Load logo image for PDF if available
//       pw.MemoryImage? logoImage;
//       if (_logoImage != null) {
//         final logoBytes = await _logoImage!.readAsBytes();
//         logoImage = pw.MemoryImage(logoBytes);
//       } else if (_logoBytes != null) {
//         logoImage = pw.MemoryImage(_logoBytes!);
//       }

//       // Load additional image for PDF if available
//       pw.MemoryImage? additionalImage;
//       if (_additionalImage != null) {
//         final additionalBytes = await _additionalImage!.readAsBytes();
//         additionalImage = pw.MemoryImage(additionalBytes);
//       } else if (_additionalImageBytes != null) {
//         additionalImage = pw.MemoryImage(_additionalImageBytes!);
//       }

//       pdf.addPage(
//         pw.MultiPage(
//           pageFormat: PdfPageFormat.a4,
//           margin: const pw.EdgeInsets.all(20),
//           build: (pw.Context context) {
//             return [
//               // Logo Section
//               if (logoImage != null)
//                 pw.Container(
//                   alignment: pw.Alignment.center,
//                   margin: const pw.EdgeInsets.only(bottom: 20),
//                   child: pw.Image(logoImage, height: 100, width: 200),
//                 ),

//               // Company Header
//               pw.Container(
//                 alignment: pw.Alignment.center,
//                 margin: const pw.EdgeInsets.only(bottom: 20),
//                 child: pw.Column(
//                   children: [
//                     pw.Text(
//                       businessData['name']!,
//                       style: pw.TextStyle(
//                         fontSize: 24,
//                         fontWeight: pw.FontWeight.bold,
//                       ),
//                     ),
//                     pw.SizedBox(height: 10),
//                     pw.Text(
//                       businessData['about']!,
//                       style: const pw.TextStyle(fontSize: 12),
//                       textAlign: pw.TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),

//               // About Us Section
//               _buildPDFSection(
//                 title: 'About Us',
//                 content: [
//                   'Name: ${businessData['name']}',
//                   'Designation: ${businessData['designation']}',
//                   '',
//                   businessData['about']!,
//                 ],
//               ),

//               pw.SizedBox(height: 20),

//               // Contact Details Section
//               _buildPDFSection(
//                 title: 'Contact Details',
//                 content: [
//                   if (businessData['whatsapp']!.isNotEmpty)
//                     'WhatsApp: ${businessData['whatsapp']}',
//                   if (businessData['email']!.isNotEmpty)
//                     'Email: ${businessData['email']}',
//                   if (businessData['phone']!.isNotEmpty)
//                     'Phone: ${businessData['phone']}',
//                   if (businessData['address']!.isNotEmpty)
//                     'Address: ${businessData['address']}',
//                 ],
//               ),

//               pw.SizedBox(height: 20),

//               // Business Info Section
//               _buildPDFSection(
//                 title: 'Business Info',
//                 content: [
//                   if (businessData['gst']!.isNotEmpty)
//                     'GST No: ${businessData['gst']}',
//                   if (businessData['timings']!.isNotEmpty)
//                     'Business Timings: ${businessData['timings']}',
//                 ],
//               ),

//               pw.SizedBox(height: 20),

//               // Additional Image Section
//               if (additionalImage != null)
//                 pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [
//                     pw.Text(
//                       'Product Images',
//                       style: pw.TextStyle(
//                         fontSize: 18,
//                         fontWeight: pw.FontWeight.bold,
//                       ),
//                     ),
//                     pw.SizedBox(height: 10),
//                     pw.Container(
//                       alignment: pw.Alignment.center,
//                       child: pw.Image(additionalImage, height: 200, width: 300),
//                     ),
//                   ],
//                 ),
//             ];
//           },
//         ),
//       );

//       final directory = await getTemporaryDirectory();
//       final file = File(
//           '${directory.path}/${businessData['name']}_business_profile.pdf');
//       await file.writeAsBytes(await pdf.save());

//       // Hide loading indicator
//       Navigator.of(context).pop();

//       await Share.shareXFiles(
//         [XFile(file.path)],
//         text: 'Check out ${businessData['name']} business profile!',
//         subject: '${businessData['name']} - Business Profile',
//       );
//     } catch (e) {
//       // Hide loading indicator if it's still showing
//       if (Navigator.of(context).canPop()) {
//         Navigator.of(context).pop();
//       }

//       _showErrorSnackBar('Failed to share: $e');
//     }
//   }

//   void _showUpgradeDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Container(
//           padding: const EdgeInsets.all(24),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             gradient: const LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
//             ),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Icon(
//                 Icons.workspace_premium,
//                 size: 48,
//                 color: Colors.white,
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Premium Feature',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               const Text(
//                 'Unlock advanced features with a subscription plan',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.white70,
//                 ),
//               ),
//               const SizedBox(height: 24),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextButton(
//                       onPressed: () => Navigator.of(context).pop(),
//                       style: TextButton.styleFrom(
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           side: const BorderSide(color: Colors.white),
//                         ),
//                       ),
//                       child: const Text('Maybe Later'),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                         showSubscriptionModal(context);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         foregroundColor: const Color(0xFF6366F1),
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text(
//                         'Upgrade Now',
//                         style: TextStyle(fontWeight: FontWeight.bold),
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

//   void showSubscriptionModal(BuildContext context) {
//     final planProvider =
//         Provider.of<GetAllPlanProvider>(context, listen: false);
//     if (planProvider.plans.isEmpty && !planProvider.isLoading) {
//       planProvider.fetchAllPlans();
//     }

//     showGeneralDialog(
//       context: context,
//       barrierDismissible: true,
//       barrierLabel: 'Subscription Modal',
//       barrierColor: Colors.black.withOpacity(0.6),
//       transitionDuration: const Duration(milliseconds: 600),
//       pageBuilder: (context, animation, secondaryAnimation) {
//         return const SizedBox.shrink();
//       },
//       transitionBuilder: (context, animation, secondaryAnimation, child) {
//         final curvedAnimation = CurvedAnimation(
//           parent: animation,
//           curve: Curves.easeOutBack,
//         );

//         return BackdropFilter(
//           filter: ImageFilter.blur(
//             sigmaX: 4 * animation.value,
//             sigmaY: 4 * animation.value,
//           ),
//           child: SlideTransition(
//             position: Tween<Offset>(
//               begin: const Offset(0, 0.2),
//               end: Offset.zero,
//             ).animate(curvedAnimation),
//             child: ScaleTransition(
//               scale: Tween<double>(
//                 begin: 0.8,
//                 end: 1.0,
//               ).animate(curvedAnimation),
//               child: FadeTransition(
//                 opacity: Tween<double>(
//                   begin: 0.0,
//                   end: 1.0,
//                 ).animate(curvedAnimation),
//                 child: Center(
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 16),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.2),
//                           blurRadius: 20,
//                           offset: const Offset(0, 10),
//                         ),
//                       ],
//                     ),
//                     constraints: BoxConstraints(
//                       maxHeight: MediaQuery.of(context).size.height * 0.85,
//                       maxWidth: 500,
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(20),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Container(
//                             decoration: const BoxDecoration(
//                               gradient: LinearGradient(
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//                                 colors: [
//                                   Color(0xFF6366F1),
//                                   Color(0xFF8B5CF6),
//                                 ],
//                               ),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 vertical: 16.0,
//                                 horizontal: 20.0,
//                               ),
//                               child: Row(
//                                 children: [
//                                   const Icon(
//                                     Icons.workspace_premium,
//                                     color: Colors.white,
//                                     size: 28,
//                                   ),
//                                   const SizedBox(width: 12),
//                                   const Expanded(
//                                     child: Text(
//                                       'Choose Your Plan',
//                                       style: TextStyle(
//                                         fontSize: 22,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                   Material(
//                                     color: Colors.transparent,
//                                     child: InkWell(
//                                       borderRadius: BorderRadius.circular(30),
//                                       onTap: () => Navigator.pop(context),
//                                       child: Container(
//                                         padding: const EdgeInsets.all(8),
//                                         decoration: BoxDecoration(
//                                           color: Colors.white.withOpacity(0.2),
//                                           shape: BoxShape.circle,
//                                         ),
//                                         child: const Icon(
//                                           Icons.close,
//                                           color: Colors.white,
//                                           size: 20,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Flexible(
//                             child: Consumer<GetAllPlanProvider>(
//                               builder: (context, provider, child) {
//                                 if (provider.isLoading) {
//                                   return _buildLoadingState();
//                                 }

//                                 if (provider.error != null) {
//                                   return _buildErrorState(provider);
//                                 }

//                                 if (provider.plans.isNotEmpty) {
//                                   return AnimatedPlanList(
//                                     plans: provider.plans,
//                                     onPlanSelected: (plan) {
//                                       Navigator.of(context).pop();
//                                       Navigator.push(
//                                         context,
//                                         PageRouteBuilder(
//                                           pageBuilder: (context, animation,
//                                                   secondaryAnimation) =>
//                                               PlanDetailsAndPaymentScreen(
//                                                   plan: plan),
//                                           transitionsBuilder: (context,
//                                               animation,
//                                               secondaryAnimation,
//                                               child) {
//                                             const begin = Offset(1.0, 0.0);
//                                             const end = Offset.zero;
//                                             const curve = Curves.easeOutCubic;

//                                             var tween = Tween(
//                                                     begin: begin, end: end)
//                                                 .chain(
//                                                     CurveTween(curve: curve));
//                                             var offsetAnimation =
//                                                 animation.drive(tween);

//                                             return SlideTransition(
//                                               position: offsetAnimation,
//                                               child: FadeTransition(
//                                                 opacity: animation,
//                                                 child: child,
//                                               ),
//                                             );
//                                           },
//                                           transitionDuration:
//                                               const Duration(milliseconds: 500),
//                                         ),
//                                       );
//                                     },
//                                   );
//                                 }

//                                 return _buildEmptyState();
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildLoadingState() {
//     return Container(
//       height: 200,
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const SizedBox(
//               width: 40,
//               height: 40,
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
//                 strokeWidth: 3,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Loading plans...',
//               style: TextStyle(
//                 color: Colors.grey.shade600,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildErrorState(GetAllPlanProvider provider) {
//     return Container(
//       height: 200,
//       child: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.error_outline,
//                 color: Colors.red.shade400,
//                 size: 48,
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 'Failed to load plans',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.red.shade400,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'Please try again later',
//                 style: TextStyle(
//                   color: Colors.grey.shade600,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton.icon(
//                 onPressed: () => provider.fetchAllPlans(),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF6366F1),
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 12,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 icon: const Icon(Icons.refresh),
//                 label: const Text('Try Again'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Container(
//       height: 200,
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.subscriptions_outlined,
//               size: 48,
//               color: Colors.grey.shade400,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'No plans available',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey.shade600,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               'Please check back later',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey.shade500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Modern SnackBar helpers
//   void _showSuccessSnackBar(String message, VoidCallback? action) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(Icons.check_circle, color: Colors.white),
//             const SizedBox(width: 12),
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: const Color(0xFF10B981),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         margin: const EdgeInsets.all(16),
//         action: action != null
//             ? SnackBarAction(
//                 label: 'Open',
//                 textColor: Colors.white,
//                 onPressed: action,
//               )
//             : null,
//       ),
//     );
//   }

//   void _showWarningSnackBar(String message, VoidCallback? action) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(Icons.warning, color: Colors.white),
//             const SizedBox(width: 12),
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: const Color(0xFFF59E0B),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         margin: const EdgeInsets.all(16),
//         duration: const Duration(seconds: 4),
//         action: action != null
//             ? SnackBarAction(
//                 label: 'Share',
//                 textColor: Colors.white,
//                 onPressed: action,
//               )
//             : null,
//       ),
//     );
//   }

//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(Icons.error, color: Colors.white),
//             const SizedBox(width: 12),
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: const Color(0xFFEF4444),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final categoryProvider = Provider.of<BusinessCategoryProvider>(context);

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       body: CustomScrollView(
//         slivers: [
//           // Modern App Bar
//           SliverAppBar(
//             expandedHeight: 120,
//             floating: false,
//             pinned: true,
//             elevation: 0,
//             backgroundColor: Colors.white,
//             foregroundColor: const Color(0xFF1E293B),
//             flexibleSpace: FlexibleSpaceBar(
//               title: const Text(
//                 'Business Profile',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 18,
//                 ),
//               ),
//               centerTitle: true,
//               background: Container(
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       Color(0xFFF8FAFC),
//                       Color(0xFFE2E8F0),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             bottom: PreferredSize(
//               preferredSize: const Size.fromHeight(1),
//               child: Container(
//                 height: 1,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       Colors.transparent,
//                       Colors.grey.shade200,
//                       Colors.transparent,
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
          
//           // Content
//           SliverToBoxAdapter(
//             child: isLoading || categoryProvider.isLoading
//                 ? _buildLoadingScreen()
//                 : FadeTransition(
//                     opacity: _fadeAnimation,
//                     child: SlideTransition(
//                       position: _slideAnimation,
//                       child: Padding(
//                         padding: const EdgeInsets.all(20.0),
//                         child: Column(
//                           children: [
//                             _buildModernBusinessCard(),
//                             const SizedBox(height: 24),
//                             _buildModernActionButtons(),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLoadingScreen() {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.7,
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.1),
//                     blurRadius: 10,
//                     offset: const Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
//                     strokeWidth: 3,
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     'Loading business data...',
//                     style: TextStyle(
//                       color: Colors.grey[600],
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildModernBusinessCard() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // Header with logo and company info
//           _buildModernHeader(),
          
//           // Content sections
//           _buildModernAboutSection(),
//           _buildModernContactSection(),
//           _buildModernBusinessInfoSection(),
//           _buildModernProductSection(),
//         ],
//       ),
//     );
//   }

//   Widget _buildModernHeader() {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             Color(0xFF6366F1),
//             Color(0xFF8B5CF6),
//           ],
//         ),
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       child: Column(
//         children: [
//           // Logo section
//           _buildModernLogo(),
//           const SizedBox(height: 20),
          
//           // Company name and description
//           Text(
//             businessData['name']!,
//             style: const TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           if (businessData['about']!.isNotEmpty) ...[
//             const SizedBox(height: 8),
//             Text(
//               businessData['about']!,
//               style: const TextStyle(
//                 fontSize: 14,
//                 color: Colors.white70,
//               ),
//               textAlign: TextAlign.center,
//               maxLines: 3,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildModernLogo() {
//     Widget logoWidget;
    
//     if (_logoImage != null) {
//       logoWidget = ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child: Image.file(
//           _logoImage!,
//           height: 80,
//           width: 80,
//           fit: BoxFit.cover,
//         ),
//       );
//     } else if (_logoBytes != null) {
//       logoWidget = ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child: Image.memory(
//           _logoBytes!,
//           height: 80,
//           width: 80,
//           fit: BoxFit.cover,
//         ),
//       );
//     } else {
//       logoWidget = Container(
//         height: 80,
//         width: 80,
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.2),
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: Colors.white.withOpacity(0.3)),
//         ),
//         child: const Icon(
//           Icons.business,
//           size: 40,
//           color: Colors.white,
//         ),
//       );
//     }

//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: logoWidget,
//     );
//   }

//   Widget _buildModernAboutSection() {
//     if (businessData['name']!.isEmpty && 
//         businessData['designation']!.isEmpty && 
//         businessData['about']!.isEmpty) {
//       return const SizedBox.shrink();
//     }

//     return _buildModernSection(
//       icon: Icons.person_outline,
//       title: 'About Us',
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (businessData['name']!.isNotEmpty)
//             _buildModernInfoTile(
//               icon: Icons.business_center,
//               label: 'Company',
//               value: businessData['name']!,
//             ),
//           if (businessData['designation']!.isNotEmpty)
//             _buildModernInfoTile(
//               icon: Icons.work_outline,
//               label: 'Position',
//               value: businessData['designation']!,
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildModernContactSection() {
//     final hasContactInfo = businessData['whatsapp']!.isNotEmpty ||
//         businessData['email']!.isNotEmpty ||
//         businessData['phone']!.isNotEmpty ||
//         businessData['address']!.isNotEmpty;

//     if (!hasContactInfo) return const SizedBox.shrink();

//     return _buildModernSection(
//       icon: Icons.contact_phone_outlined,
//       title: 'Contact Information',
//       child: Column(
//         children: [
//           if (businessData['whatsapp']!.isNotEmpty)
//             _buildModernInfoTile(
//               icon: Icons.chat,
//               label: 'WhatsApp',
//               value: businessData['whatsapp']!,
//               actionIcon: Icons.open_in_new,
//               onTap: () {
//                 // Add WhatsApp launch functionality
//               },
//             ),
//           if (businessData['email']!.isNotEmpty)
//             _buildModernInfoTile(
//               icon: Icons.email_outlined,
//               label: 'Email',
//               value: businessData['email']!,
//               actionIcon: Icons.open_in_new,
//               onTap: () {
//                 // Add email launch functionality
//               },
//             ),
//           if (businessData['phone']!.isNotEmpty)
//             _buildModernInfoTile(
//               icon: Icons.phone_outlined,
//               label: 'Phone',
//               value: businessData['phone']!,
//               actionIcon: Icons.call,
//               onTap: () {
//                 // Add phone call functionality
//               },
//             ),
//           if (businessData['address']!.isNotEmpty)
//             _buildModernInfoTile(
//               icon: Icons.location_on_outlined,
//               label: 'Address',
//               value: businessData['address']!,
//               actionIcon: Icons.map,
//               onTap: () {
//                 // Add map launch functionality
//               },
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildModernBusinessInfoSection() {
//     final hasBusinessInfo = businessData['gst']!.isNotEmpty ||
//         businessData['timings']!.isNotEmpty;

//     if (!hasBusinessInfo) return const SizedBox.shrink();

//     return _buildModernSection(
//       icon: Icons.business_outlined,
//       title: 'Business Details',
//       child: Column(
//         children: [
//           if (businessData['gst']!.isNotEmpty)
//             _buildModernInfoTile(
//               icon: Icons.receipt_long,
//               label: 'GST Number',
//               value: businessData['gst']!,
//             ),
//           // if (businessData['timings']!.isNotEmpty)
//           //   _buildModernInfoTile(
//           //     icon: Icons.access_time,
//           //     label: 'Business Hours',
//           //     value: businessData['timings']!,
//           //   ),
//         ],
//       ),
//     );
//   }

//   Widget _buildModernProductSection() {
//     return _buildModernSection(
//       icon: Icons.inventory_2_outlined,
//       title: 'Product Showcase',
//       child: _buildModernProductImages(),
//     );
//   }

//   Widget _buildModernProductImages() {
//     if (_additionalImage != null || _additionalImageBytes != null) {
//       return Container(
//         height: 220,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(16),
//           child: _additionalImage != null
//               ? Image.file(
//                   _additionalImage!,
//                   fit: BoxFit.cover,
//                 )
//               : Image.memory(
//                   _additionalImageBytes!,
//                   fit: BoxFit.cover,
//                 ),
//         ),
//       );
//     }

//     return Container(
//       height: 160,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         color: const Color(0xFFF1F5F9),
//         border: Border.all(
//           color: const Color(0xFFE2E8F0),
//           width: 2,
//         ),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: const Color(0xFF6366F1).withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.add_photo_alternate_outlined,
//               size: 32,
//               color: Color(0xFF6366F1),
//             ),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             'No product images yet',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//               color: Colors.grey[600],
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             'Add images to showcase your products',
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey[500],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildModernSection({
//     required IconData icon,
//     required String title,
//     required Widget child,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 2),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Section header
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF6366F1).withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Icon(
//                     icon,
//                     size: 20,
//                     color: const Color(0xFF6366F1),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF1E293B),
//                   ),
//                 ),
//               ],
//             ),
//           ),
          
//           // Section content
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//             child: child,
//           ),
          
//           const SizedBox(height: 8),
//         ],
//       ),
//     );
//   }

//   Widget _buildModernInfoTile({
//     required IconData icon,
//     required String label,
//     required String value,
//     IconData? actionIcon,
//     VoidCallback? onTap,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF8FAFC),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: const Color(0xFFE2E8F0),
//           width: 1,
//         ),
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(12),
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF6366F1).withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Icon(
//                     icon,
//                     size: 18,
//                     color: const Color(0xFF6366F1),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         label,
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.grey[600],
//                           letterSpacing: 0.5,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         value,
//                         style: const TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w500,
//                           color: Color(0xFF1E293B),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 if (actionIcon != null)
//                   Icon(
//                     actionIcon,
//                     size: 18,
//                     color: const Color(0xFF6366F1),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildModernActionButtons() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF6366F1).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Icon(
//                   Icons.file_download_outlined,
//                   size: 20,
//                   color: Color(0xFF6366F1),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               const Text(
//                 'Export & Share',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF1E293B),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildModernButton(
//                   icon: Icons.file_download_outlined,
//                   label: 'Download PDF',
//                   onPressed: _generateAndDownloadPDF,
//                   isPrimary: true,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildModernButton(
//                   icon: Icons.share_outlined,
//                   label: 'Share Profile',
//                   onPressed: _shareBusinessCard,
//                   isPrimary: false,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildModernButton({
//     required IconData icon,
//     required String label,
//     required VoidCallback onPressed,
//     required bool isPrimary,
//   }) {
//     return Container(
//       height: 52,
//       child: ElevatedButton.icon(
//         onPressed: onPressed,
//         icon: Icon(
//           icon,
//           size: 20,
//           color: isPrimary ? Colors.white : const Color(0xFF6366F1),
//         ),
//         label: Text(
//           label,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: isPrimary ? Colors.white : const Color(0xFF6366F1),
//           ),
//         ),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: isPrimary 
//               ? const Color(0xFF6366F1) 
//               : Colors.white,
//           foregroundColor: isPrimary 
//               ? Colors.white 
//               : const Color(0xFF6366F1),
//           elevation: 0,
//           shadowColor: Colors.transparent,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(14),
//             side: isPrimary 
//                 ? BorderSide.none 
//                 : const BorderSide(
//                     color: Color(0xFF6366F1),
//                     width: 1.5,
//                   ),
//           ),
//         ),
//       ),
//     );
//   }
// }