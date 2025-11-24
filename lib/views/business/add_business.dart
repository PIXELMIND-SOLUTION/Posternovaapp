// import 'dart:convert';
// import 'dart:io';
// import 'package:edit_ezy_project/providers/business/business_category_provider.dart';
// import 'package:edit_ezy_project/providers/business/business_poster_provider.dart';
// import 'package:edit_ezy_project/views/business/business_data_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';


// class AddBusinessScreen extends StatefulWidget {
//   const AddBusinessScreen({super.key});

//   @override
//   State<AddBusinessScreen> createState() => _VirtualBusinessScreenState();
// }

// class _VirtualBusinessScreenState extends State<AddBusinessScreen> {
//   Map<String, String>? businessData;

//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       Provider.of<BusinessPosterProvider>(context, listen: false)
//           .fetchPosters();
//       Provider.of<BusinessCategoryProvider>(context, listen: false)
//           .fetchCategories();
//     });
//     _loadBusinessData();
//   }

//   Future<void> _loadBusinessData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final data = {
//       'name': prefs.getString('business_name') ?? '',
//       'email': prefs.getString('email') ?? '',
//       'phone': prefs.getString('phone_number') ?? '',
//     };
//     setState(() {
//       businessData = data;
//     });
//   }

//   void _navigateToCreateBusinessPost() async {
//     await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => const CreateBusinessPostScreen(),
//       ),
//     );
//     _loadBusinessData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final posterProvider = Provider.of<BusinessPosterProvider>(context);
//     final categoryProvider = Provider.of<BusinessCategoryProvider>(context);
//     final theme = Theme.of(context);

//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: theme.primaryColor,
//         foregroundColor: Colors.white,
//         leading: IconButton(
//           onPressed: () => Navigator.of(context).pop(),
//           icon: const Icon(Icons.arrow_back_ios_new, size: 20),
//         ),
//         title: const Text(
//           'Virtual Business Card',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//             letterSpacing: 0.5,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: posterProvider.isLoading || categoryProvider.isLoading
//           ? const Center(
//               child: CircularProgressIndicator(
//                 strokeWidth: 3,
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//               ),
//             )
//           : posterProvider.error != null
//               ? _buildErrorWidget('Poster Error: ${posterProvider.error}')
//               : categoryProvider.errorMessage != null
//                   ? _buildErrorWidget('Category Error: ${categoryProvider.errorMessage}')
//                   : _buildMainContent(),
//       floatingActionButton: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: theme.primaryColor.withOpacity(0.3),
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: FloatingActionButton.extended(
//           onPressed: _navigateToCreateBusinessPost,
//           backgroundColor: theme.primaryColor,
//           foregroundColor: Colors.white,
//           elevation: 0,
//           icon: const Icon(Icons.add_business, size: 20),
//           label: const Text(
//             'Create Business Card',
//             style: TextStyle(
//               fontWeight: FontWeight.w600,
//               fontSize: 14,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildErrorWidget(String error) {
//     return Center(
//       child: Container(
//         margin: const EdgeInsets.all(24),
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: Colors.red[50],
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.red[200]!),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.error_outline, color: Colors.red[400], size: 48),
//             const SizedBox(height: 16),
//             Text(
//               error,
//               style: TextStyle(
//                 color: Colors.red[700],
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMainContent() {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 24),
//           if (businessData != null && businessData!['name']!.isNotEmpty)
//             _buildBusinessInfoSection()
//           else
//             _buildEmptyStateSection(),
//           const SizedBox(height: 100), // Space for FAB
//         ],
//       ),
//     );
//   }

//   Widget _buildBusinessInfoSection() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).primaryColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(
//                   Icons.business_center,
//                   color: Theme.of(context).primaryColor,
//                   size: 20,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               const Text(
//                 'Your Business Information',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w700,
//                   color: Color(0xFF1A1A1A),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           Container(
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 10,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Material(
//               color: Colors.transparent,
//               child: InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => BusinessDataScreen(),
//                     ),
//                   );
//                 },
//                 borderRadius: BorderRadius.circular(16),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Container(
//                             width: 48,
//                             height: 48,
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [
//                                   Theme.of(context).primaryColor,
//                                   Theme.of(context).primaryColor.withOpacity(0.7),
//                                 ],
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//                               ),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: const Icon(
//                               Icons.store,
//                               color: Colors.white,
//                               size: 24,
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   businessData!['name'] ?? '',
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w600,
//                                     color: Color(0xFF1A1A1A),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   'Business Profile',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.grey[600],
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Icon(
//                             Icons.arrow_forward_ios,
//                             size: 16,
//                             color: Colors.grey[400],
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                       _buildInfoRow(Icons.email_outlined, businessData!['email'] ?? ''),
//                       const SizedBox(height: 12),
//                       _buildInfoRow(Icons.phone_outlined, businessData!['phone'] ?? ''),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoRow(IconData icon, String text) {
//     return Row(
//       children: [
//         Icon(
//           icon,
//           size: 18,
//           color: Colors.grey[600],
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Text(
//             text,
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[700],
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildEmptyStateSection() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(32),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Container(
//               width: 80,
//               height: 80,
//               decoration: BoxDecoration(
//                 color: Theme.of(context).primaryColor.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Icon(
//                 Icons.business_center_outlined,
//                 size: 40,
//                 color: Theme.of(context).primaryColor,
//               ),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               'Create Your Business Card',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF1A1A1A),
//               ),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               'Get started by creating your professional business card to showcase your business information.',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[600],
//                 height: 1.5,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CreateBusinessPostScreen extends StatefulWidget {
//   const CreateBusinessPostScreen({super.key});

//   @override
//   State<CreateBusinessPostScreen> createState() =>
//       _CreateBusinessPostScreenState();
// }

// class _CreateBusinessPostScreenState extends State<CreateBusinessPostScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final businessNameController = TextEditingController();
//   final ownerNameController = TextEditingController();
//   final designationController = TextEditingController();
//   final phoneNumberController = TextEditingController();
//   final whatsappNumberController = TextEditingController();
//   final emailController = TextEditingController();
//   final websiteController = TextEditingController();
//   final addressController = TextEditingController();
//   final gstNumberController = TextEditingController();

//   File? _logoImage;
//   File? _additionalImage;
//   final ImagePicker _picker = ImagePicker();
//   bool _isSubmitting = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadSavedData();
//   }

//   @override
//   void dispose() {
//     businessNameController.dispose();
//     ownerNameController.dispose();
//     designationController.dispose();
//     phoneNumberController.dispose();
//     whatsappNumberController.dispose();
//     emailController.dispose();
//     websiteController.dispose();
//     addressController.dispose();
//     gstNumberController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadSavedData() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       businessNameController.text = prefs.getString('business_name') ?? '';
//       ownerNameController.text = prefs.getString('owner_name') ?? '';
//       designationController.text = prefs.getString('designation') ?? '';
//       phoneNumberController.text = prefs.getString('phone_number') ?? '';
//       whatsappNumberController.text = prefs.getString('whatsapp_number') ?? '';
//       emailController.text = prefs.getString('email') ?? '';
//       websiteController.text = prefs.getString('website') ?? '';
//       addressController.text = prefs.getString('address') ?? '';
//       gstNumberController.text = prefs.getString('gst_number') ?? '';

//       final String? logoPath = prefs.getString('logo_path');
//       if (logoPath != null) {
//         _logoImage = File(logoPath);
//       }

//       final String? additionalImagePath = prefs.getString('additional_image_path');
//       if (additionalImagePath != null) {
//         _additionalImage = File(additionalImagePath);
//       }
//     });
//   }

//   Future<void> _pickLogoFromGallery() async {
//     final XFile? pickedFile = await _picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 80,
//     );

//     if (pickedFile != null) {
//       setState(() {
//         _logoImage = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _pickAdditionalImageFromGallery() async {
//     final XFile? pickedFile = await _picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 80,
//     );

//     if (pickedFile != null) {
//       setState(() {
//         _additionalImage = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _saveDataToPrefs() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('business_name', businessNameController.text);
//     await prefs.setString('owner_name', ownerNameController.text);
//     await prefs.setString('designation', designationController.text);
//     await prefs.setString('phone_number', phoneNumberController.text);
//     await prefs.setString('whatsapp_number', whatsappNumberController.text);
//     await prefs.setString('email', emailController.text);
//     await prefs.setString('website', websiteController.text);
//     await prefs.setString('address', addressController.text);
//     await prefs.setString('gst_number', gstNumberController.text);

//     if (_logoImage != null) {
//       await prefs.setString('logo_path', _logoImage!.path);
//       final bytes = await _logoImage!.readAsBytes();
//       await prefs.setString('logo_base64', base64Encode(bytes));
//     }

//     if (_additionalImage != null) {
//       await prefs.setString('additional_image_path', _additionalImage!.path);
//       final bytes = await _additionalImage!.readAsBytes();
//       await prefs.setString('additional_image_base64', base64Encode(bytes));
//     }
//   }

//   InputDecoration _inputDecoration(String label, IconData icon) {
//     return InputDecoration(
//       labelText: label,
//       labelStyle: TextStyle(
//         color: Colors.grey[700],
//         fontSize: 14,
//         fontWeight: FontWeight.w500,
//       ),
//       prefixIcon: Container(
//         margin: const EdgeInsets.only(right: 12),
//         child: Icon(
//           icon,
//           color: Theme.of(context).primaryColor,
//           size: 20,
//         ),
//       ),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: Colors.grey[300]!),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: Colors.grey[300]!),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Colors.red, width: 1),
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Colors.red, width: 2),
//       ),
//       filled: true,
//       fillColor: Colors.grey[50],
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//     );
//   }

//   String? _requiredValidator(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return 'This field is required';
//     }
//     return null;
//   }

//   String? _emailValidator(String? value) {
//     if (value == null || value.isEmpty) return 'Email is required';
//     final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');
//     if (!emailRegex.hasMatch(value)) return 'Enter a valid email address';
//     return null;
//   }

//   String? _phoneValidator(String? value) {
//     if (value == null || value.isEmpty) return 'Phone number is required';
//     if (value.length != 10) return 'Enter a valid 10-digit phone number';
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
    
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: theme.primaryColor,
//         foregroundColor: Colors.white,
//         leading: IconButton(
//           onPressed: () => Navigator.of(context).pop(),
//           icon: const Icon(Icons.arrow_back_ios_new, size: 20),
//         ),
//         title: const Text(
//           'Create Business Card',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//             letterSpacing: 0.5,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 width: double.infinity,
//                 color: theme.primaryColor,
//                 child: Container(
//                   height: 20,
//                   decoration: const BoxDecoration(
//                     color: Colors.grey,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(20),
//                       topRight: Radius.circular(20),
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 color: Colors.grey[50],
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildSectionHeader('Business Logo', Icons.image_outlined),
//                     const SizedBox(height: 16),
//                     _buildImagePicker(
//                       image: _logoImage,
//                       onTap: _pickLogoFromGallery,
//                       placeholder: 'Upload Business Logo',
//                       icon: Icons.add_photo_alternate_outlined,
//                     ),

//                     const SizedBox(height: 32),
//                     _buildSectionHeader('Basic Information', Icons.info_outlined),
//                     const SizedBox(height: 16),

//                     _buildFormField(
//                       controller: businessNameController,
//                       label: 'Business Name',
//                       icon: Icons.business_outlined,
//                       validator: _requiredValidator,
//                     ),

//                     _buildFormField(
//                       controller: ownerNameController,
//                       label: 'Owner Name',
//                       icon: Icons.person_outlined,
//                       validator: _requiredValidator,
//                     ),

//                     _buildFormField(
//                       controller: designationController,
//                       label: 'Designation',
//                       icon: Icons.work_outline,
//                       validator: _requiredValidator,
//                     ),

//                     const SizedBox(height: 24),
//                     _buildSectionHeader('Contact Information', Icons.contact_phone_outlined),
//                     const SizedBox(height: 16),

//                     _buildFormField(
//                       controller: phoneNumberController,
//                       label: 'Phone Number',
//                       icon: Icons.phone_outlined,
//                       keyboardType: TextInputType.phone,
//                       validator: _phoneValidator,
//                     ),

//                     _buildFormField(
//                       controller: whatsappNumberController,
//                       label: 'WhatsApp Number',
//                       icon: Icons.chat_outlined,
//                       keyboardType: TextInputType.phone,
//                       validator: _phoneValidator,
//                     ),

//                     _buildFormField(
//                       controller: emailController,
//                       label: 'Email Address',
//                       icon: Icons.email_outlined,
//                       keyboardType: TextInputType.emailAddress,
//                       validator: _emailValidator,
//                     ),

//                     // _buildFormField(
//                     //   controller: websiteController,
//                     //   label: 'Website (Optional)',
//                     //   icon: Icons.language_outlined,
//                     //   keyboardType: TextInputType.url,
//                     // ),

//                     _buildFormField(
//                       controller: addressController,
//                       label: 'Business Address',
//                       icon: Icons.location_on_outlined,
//                       validator: _requiredValidator,
//                       maxLines: 2,
//                     ),

//                     _buildFormField(
//                       controller: gstNumberController,
//                       label: 'GST Number (Optional)',
//                       icon: Icons.receipt_long_outlined,
//                     ),

//                     const SizedBox(height: 32),
//                     _buildSectionHeader('Supporting Image', Icons.image_outlined),
//                     const SizedBox(height: 16),
                    
//                     _buildImagePicker(
//                       image: _additionalImage,
//                       onTap: _pickAdditionalImageFromGallery,
//                       placeholder: 'Upload Certificate or Banner',
//                       icon: Icons.add_photo_alternate_outlined,
//                     ),

//                     const SizedBox(height: 40),
                    
//                     SizedBox(
//                       width: double.infinity,
//                       height: 56,
//                       child: ElevatedButton(
//                         onPressed: _isSubmitting ? null : _handleSubmit,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: theme.primaryColor,
//                           foregroundColor: Colors.white,
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           disabledBackgroundColor: Colors.grey[300],
//                         ),
//                         child: _isSubmitting
//                             ? const SizedBox(
//                                 width: 20,
//                                 height: 20,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                                 ),
//                               )
//                             : const Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(Icons.check_circle_outline, size: 20),
//                                   SizedBox(width: 8),
//                                   Text(
//                                     'Save Business Card',
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                       ),
//                     ),
                    
//                     const SizedBox(height: 24),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionHeader(String title, IconData icon) {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(6),
//           decoration: BoxDecoration(
//             color: Theme.of(context).primaryColor.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(6),
//           ),
//           child: Icon(
//             icon,
//             color: Theme.of(context).primaryColor,
//             size: 16,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             color: Color(0xFF1A1A1A),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildFormField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     TextInputType? keyboardType,
//     String? Function(String?)? validator,
//     int maxLines = 1,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       child: TextFormField(
//         controller: controller,
//         decoration: _inputDecoration(label, icon),
//         keyboardType: keyboardType,
//         validator: validator,
//         maxLines: maxLines,
//         style: const TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w400,
//         ),
//       ),
//     );
//   }

//   Widget _buildImagePicker({
//     required File? image,
//     required VoidCallback onTap,
//     required String placeholder,
//     required IconData icon,
//   }) {
//     return Container(
//       height: 160,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: image != null ? Theme.of(context).primaryColor : Colors.grey[300]!,
//           width: image != null ? 2 : 1,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(16),
//           child: image != null
//               ? Stack(
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(15),
//                       child: Image.file(
//                         image,
//                         fit: BoxFit.cover,
//                         width: double.infinity,
//                         height: double.infinity,
//                       ),
//                     ),
//                     Positioned(
//                       top: 8,
//                       right: 8,
//                       child: Container(
//                         padding: const EdgeInsets.all(4),
//                         decoration: BoxDecoration(
//                           color: Colors.black.withOpacity(0.6),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: const Icon(
//                           Icons.edit,
//                           color: Colors.white,
//                           size: 16,
//                         ),
//                       ),
//                     ),
//                   ],
//                 )
//               : Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).primaryColor.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Icon(
//                         icon,
//                         size: 32,
//                         color: Theme.of(context).primaryColor,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       placeholder,
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.grey[700],
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'Tap to select image',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey[500],
//                       ),
//                     ),
//                   ],
//                 ),
//         ),
//       ),
//     );
//   }

//   Future<void> _handleSubmit() async {
//     if (_formKey.currentState?.validate() ?? false) {
//       setState(() {
//         _isSubmitting = true;
//       });

//       try {
//         await _saveDataToPrefs();

//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: const Row(
//                 children: [
//                   Icon(Icons.check_circle, color: Colors.white, size: 20),
//                   SizedBox(width: 12),
//                   Text(
//                     'Business card saved successfully!',
//                     style: TextStyle(fontWeight: FontWeight.w500),
//                   ),
//                 ],
//               ),
//               backgroundColor: Colors.green[600],
//               behavior: SnackBarBehavior.floating,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               margin: const EdgeInsets.all(16),
//             ),
//           );

//           // Clear form after successful submission
//           _clearForm();
//           Navigator.of(context).pop();
//         }
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Row(
//                 children: [
//                   const Icon(Icons.error_outline, color: Colors.white, size: 20),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Text(
//                       'Failed to save business card: ${e.toString()}',
//                       style: const TextStyle(fontWeight: FontWeight.w500),
//                     ),
//                   ),
//                 ],
//               ),
//               backgroundColor: Colors.red[600],
//               behavior: SnackBarBehavior.floating,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               margin: const EdgeInsets.all(16),
//             ),
//           );
//         }
//       } finally {
//         if (mounted) {
//           setState(() {
//             _isSubmitting = false;
//           });
//         }
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Row(
//             children: [
//               Icon(Icons.warning_outlined, color: Colors.white, size: 20),
//               SizedBox(width: 12),
//               Text(
//                 'Please fill all required fields correctly',
//                 style: TextStyle(fontWeight: FontWeight.w500),
//               ),
//             ],
//           ),
//           backgroundColor: Colors.orange[600],
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           margin: const EdgeInsets.all(16),
//         ),
//       );
//     }
//   }

//   void _clearForm() {
//     businessNameController.clear();
//     ownerNameController.clear();
//     designationController.clear();
//     phoneNumberController.clear();
//     whatsappNumberController.clear();
//     emailController.clear();
//     websiteController.clear();
//     addressController.clear();
//     gstNumberController.clear();

//     setState(() {
//       _logoImage = null;
//       _additionalImage = null;
//     });
//   }
// }