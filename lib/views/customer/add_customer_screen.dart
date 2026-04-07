// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:posternova/helper/storage_helper.dart';
// import 'package:posternova/providers/customer/customer_provider.dart';
// import 'package:posternova/widgets/language_widget.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';

// class AddCustomer extends StatefulWidget {
//   const AddCustomer({super.key});

//   @override
//   State<AddCustomer> createState() => _AddnewCustomersState();
// }

// class _AddnewCustomersState extends State<AddCustomer> {
//   final _formKey = GlobalKey<FormState>();
//   String? selectedGender;
//   String? selectedReligion;
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _mobileController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _dobController = TextEditingController();
//   final TextEditingController _anniversaryController = TextEditingController();
//   bool _isLoading = false;

//   String userId = '';

//   DateTime? selectedDob;
//   DateTime? selectedAnniversary;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   Future<void> _loadUserData() async {
//     final userData = await AuthPreferences.getUserData();
//     print(userData);
//     if (userData != null && userData.user != null) {
//       setState(() {
//         userId = userData.user.id;
//       });
//       print('User ID: $userId');
//     } else {
//       print("No User ID");
//     }
//   }

//   Future<void> _selectDate(
//     BuildContext context,
//     TextEditingController controller,
//     bool isDob,
//   ) async {
//     final DateTime now = DateTime.now();

//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: now,
//       firstDate: DateTime(1900),
//       lastDate: DateTime(now.year + 50),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: Color(0xFF6366F1),
//               onPrimary: Colors.white,
//               surface: Colors.white,
//               onSurface: Colors.black,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );

//     if (picked != null) {
//       setState(() {
//         if (isDob) {
//           selectedDob = picked;
//         } else {
//           selectedAnniversary = picked;
//         }
//         controller.text = DateFormat('dd/MM/yyyy').format(picked);
//       });
//     }
//   }

//   String _formatDateForApi(DateTime? date) {
//     if (date == null) return '';
//     return DateFormat('yyyy-MM-dd').format(date);
//   }

//   String? _validateDate(String? value, bool isDob) {
//     if (value == null || value.isEmpty) {
//       return isDob ? 'Please enter a date of birth' : null;
//     }

//     if (isDob && selectedDob != null) {
//       final now = DateTime.now();
//       if (selectedDob!.isAfter(now)) {
//         return 'Date of birth cannot be in the future';
//       }

//       final age = now.difference(selectedDob!).inDays / 365.25;
//       if (age > 150) {
//         return 'Please enter a valid date of birth';
//       }
//     }

//     return null;
//   }

//   void _showSuccessDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(32),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   width: 80,
//                   height: 80,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF10B981).withOpacity(0.1),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.check_circle_rounded,
//                     color: Color(0xFF10B981),
//                     size: 48,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 const Text(
//                   'Customer Added',
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF0F172A),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   'The customer has been successfully added to your database.',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 15,
//                     color: Colors.grey.shade600,
//                     height: 1.5,
//                   ),
//                 ),
//                 const SizedBox(height: 28),
//                 SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                       Navigator.of(context).pop();
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF6366F1),
//                       foregroundColor: Colors.white,
//                       elevation: 0,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: const Text(
//                       'Done',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(32),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   width: 80,
//                   height: 80,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFEF4444).withOpacity(0.1),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.error_outline_rounded,
//                     color: Color(0xFFEF4444),
//                     size: 48,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 const Text(
//                   'Error',
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF0F172A),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   message,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 15,
//                     color: Colors.grey.shade600,
//                     height: 1.5,
//                   ),
//                 ),
//                 const SizedBox(height: 28),
//                 SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: () => Navigator.of(context).pop(),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFEF4444),
//                       foregroundColor: Colors.white,
//                       elevation: 0,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: const Text(
//                       'Try Again',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildInputField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     String? hint,
//     TextInputType? keyboardType,
//     String? Function(String?)? validator,
//     bool readOnly = false,
//     VoidCallback? onTap,
//     List<TextInputFormatter>? inputFormatters,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 4, bottom: 8),
//           child: Text(
//             label,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF334155),
//             ),
//           ),
//         ),
//         TextFormField(
//           controller: controller,
//           keyboardType: keyboardType,
//           validator: validator,
//           readOnly: readOnly,
//           onTap: onTap,
//           inputFormatters: inputFormatters,
//           style: const TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF0F172A),
//           ),
//           decoration: InputDecoration(
//             hintText: hint,
//             prefixIcon: Icon(icon, size: 22, color: const Color(0xFF6366F1)),
//             hintStyle: TextStyle(
//               color: Colors.grey.shade400,
//               fontSize: 15,
//               fontWeight: FontWeight.w400,
//             ),
//             filled: true,
//             fillColor: const Color(0xFFF8FAFC),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(14),
//               borderSide: BorderSide(color: Colors.grey.shade200),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(14),
//               borderSide: BorderSide(color: Colors.grey.shade200),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(14),
//               borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
//             ),
//             errorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(14),
//               borderSide: const BorderSide(color: Color(0xFFEF4444)),
//             ),
//             focusedErrorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(14),
//               borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 18,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildGenderDropdown() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 4, bottom: 8),
//           child: Text(
//             AppText.translate(context, 'gender'),
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF334155),
//             ),
//           ),
//         ),
//         DropdownButtonFormField<String>(
//           dropdownColor: Colors.white,
//           decoration: InputDecoration(
//             prefixIcon: const Icon(
//               Icons.wc_rounded,
//               size: 22,
//               color: Color(0xFF6366F1),
//             ),
//             filled: true,
//             fillColor: const Color(0xFFF8FAFC),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(14),
//               borderSide: BorderSide(color: Colors.grey.shade200),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(14),
//               borderSide: BorderSide(color: Colors.grey.shade200),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(14),
//               borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 18,
//             ),
//           ),
//           style: const TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF0F172A),
//           ),
//           icon: const Icon(
//             Icons.arrow_drop_down_rounded,
//             color: Color(0xFF6366F1),
//           ),
//           hint: Text(
//             'Select gender',
//             style: TextStyle(
//               color: Colors.grey.shade400,
//               fontSize: 15,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//           items: ['Male', 'Female', 'Other']
//               .map(
//                 (gender) => DropdownMenuItem(
//                   value: gender,
//                   child: Text(
//                     gender,
//                     style: const TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500,
//                       color: Color(0xFF0F172A),
//                     ),
//                   ),
//                 ),
//               )
//               .toList(),
//           onChanged: (value) {
//             setState(() {
//               selectedGender = value;
//             });
//           },
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Please select a gender';
//             }
//             return null;
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildReligionDropdown() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 4, bottom: 8),
//           child: Text(
//             'Religion',
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF334155),
//             ),
//           ),
//         ),
//         DropdownButtonFormField<String>(
//           dropdownColor: Colors.white,
//           decoration: InputDecoration(
//             prefixIcon: const Icon(
//               Icons.temple_hindu_rounded,
//               size: 22,
//               color: Color(0xFF6366F1),
//             ),
//             filled: true,
//             fillColor: const Color(0xFFF8FAFC),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(14),
//               borderSide: BorderSide(color: Colors.grey.shade200),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(14),
//               borderSide: BorderSide(color: Colors.grey.shade200),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(14),
//               borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 18,
//             ),
//           ),
//           style: const TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF0F172A),
//           ),
//           icon: const Icon(
//             Icons.arrow_drop_down_rounded,
//             color: Color(0xFF6366F1),
//           ),
//           hint: Text(
//             'Select religion',
//             style: TextStyle(
//               color: Colors.grey.shade400,
//               fontSize: 15,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//           items:
//               [
//                     'Hindu',
//                     'Muslim',
//                     'Christian',
//                     'Sikh',
//                     'Buddhist',
//                     'Jain',
//                     'Other',
//                   ]
//                   .map(
//                     (religion) => DropdownMenuItem(
//                       value: religion,
//                       child: Text(
//                         religion,
//                         style: const TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w500,
//                           color: Color(0xFF0F172A),
//                         ),
//                       ),
//                     ),
//                   )
//                   .toList(),
//           onChanged: (value) {
//             setState(() {
//               selectedReligion = value;
//             });
//           },
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Please select a religion';
//             }
//             return null;
//           },
//         ),
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _mobileController.dispose();
//     _emailController.dispose();
//     _addressController.dispose();
//     _dobController.dispose();
//     _anniversaryController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final customerProvider = Provider.of<CreateCustomerProvider>(context);

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         surfaceTintColor: Colors.white,
//         leading: IconButton(
//           icon: Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: const Color(0xFFF1F5F9),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: const Icon(
//               Icons.arrow_back_ios_new_rounded,
//               size: 18,
//               color: Color(0xFF0F172A),
//             ),
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const AppText(
//           'add_customers',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//             color: Color(0xFF0F172A),
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             padding: const EdgeInsets.all(20),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Header Section
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(24),
//                     decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                         colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(14),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.2),
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                           child: const Icon(
//                             Icons.person_add_alt_1_rounded,
//                             color: Colors.white,
//                             size: 28,
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         const Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               AppText(
//                                 'new_customer',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               SizedBox(height: 4),
//                               AppText(
//                                 'fill_customer_details',
//                                 style: TextStyle(
//                                   color: Colors.white70,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 32),

//                   // Basic Information
//                   const AppText(
//                     'basic_information',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF0F172A),
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   _buildInputField(
//                     controller: _nameController,
//                     label: AppText.translate(context, 'name'),
//                     icon: Icons.person_rounded,
//                     hint: AppText.translate(context, 'enter_full_name'),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter a name';
//                       }
//                       return null;
//                     },
//                   ),

//                   const SizedBox(height: 20),

//                   // _buildInputField(
//                   //   controller: _mobileController,
//                   //   label: AppText.translate(context, 'mobile_number'),
//                   //   icon: Icons.phone_rounded,
//                   //   hint: 'Enter mobile number',
//                   //   keyboardType: TextInputType.phone,
//                   //   validator: (value) {
//                   //     if (value == null || value.isEmpty) {
//                   //       return 'Please enter a mobile number';
//                   //     }
//                   //     if (value.length < 10) {
//                   //       return 'Please enter a valid mobile number';
//                   //     }
//                   //     return null;
//                   //   },
//                   // ),
//                   _buildInputField(
//                     controller: _mobileController,
//                     label: AppText.translate(context, 'mobile_number'),
//                     icon: Icons.phone_rounded,
//                     hint: AppText.translate(context, 'enter_mobile_number'),
//                     keyboardType: TextInputType.phone,
//                     inputFormatters: [
//                       FilteringTextInputFormatter.digitsOnly, // only numbers
//                       LengthLimitingTextInputFormatter(10), // max 10 digits
//                     ],
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter a mobile number';
//                       }
//                       if (value.length != 10) {
//                         return 'Mobile number must be exactly 10 digits';
//                       }
//                       return null;
//                     },
//                   ),

//                   const SizedBox(height: 20),

//                   _buildInputField(
//                     controller: _emailController,
//                     label: '${AppText.translate(context, 'email_optional')}',
//                     icon: Icons.email_rounded,
//                     hint:
//                         '${AppText.translate(context, 'enter_email_optional')}',
//                     keyboardType: TextInputType.emailAddress,
//                     validator: (value) {
//                       if (value != null && value.isNotEmpty) {
//                         if (!RegExp(
//                           r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
//                         ).hasMatch(value)) {
//                           return 'Please enter a valid email address';
//                         }
//                       }
//                       return null;
//                     },
//                   ),

//                   const SizedBox(height: 20),

//                   _buildGenderDropdown(),

//                   const SizedBox(height: 20),

//                   _buildReligionDropdown(),

//                   const SizedBox(height: 32),

//                   // Additional Information
//                   const AppText(
//                     'additional_information',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF0F172A),
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   _buildInputField(
//                     controller: _dobController,
//                     label: AppText.translate(context, 'date_of_birth'),
//                     icon: Icons.cake_rounded,
//                     hint: 'DD/MM/YYYY',
//                     readOnly: true,
//                     onTap: () => _selectDate(context, _dobController, true),
//                     validator: (value) => _validateDate(value, true),
//                   ),

//                   const SizedBox(height: 20),

//                   _buildInputField(
//                     controller: _anniversaryController,
//                     label:
//                         '${AppText.translate(context, 'date_of_anniversary')} (Optional)',
//                     icon: Icons.favorite_rounded,
//                     hint: 'DD/MM/YYYY',
//                     readOnly: true,
//                     onTap: () =>
//                         _selectDate(context, _anniversaryController, false),
//                     validator: (value) => _validateDate(value, false),
//                   ),

//                   const SizedBox(height: 20),

//                   _buildInputField(
//                     controller: _addressController,
//                     label:
//                         '${AppText.translate(context, 'address')} (Optional)',
//                     icon: Icons.location_on_rounded,
//                     hint:
//                         '${AppText.translate(context, 'enter_address_optional')} (Optional)',
//                   ),

//                   const SizedBox(height: 32),

//                   // Save Button
//                   SizedBox(
//                     width: double.infinity,
//                     height: 56,
//                     child: ElevatedButton(
//                       onPressed: _isLoading
//                           ? null
//                           : () async {
//                               if (_formKey.currentState!.validate()) {
//                                 setState(() {
//                                   _isLoading = true;
//                                 });

//                                 try {
//                                   final success = await customerProvider
//                                       .addCustomer(
//                                         userId: userId,
//                                         name: _nameController.text.trim(),
//                                         email: _emailController.text.trim(),
//                                         mobile: _mobileController.text.trim(),
//                                         dob: _formatDateForApi(selectedDob),
//                                         address: _addressController.text.trim(),
//                                         gender: selectedGender ?? '',
//                                         anniversaryDate: _formatDateForApi(
//                                           selectedAnniversary,
//                                         ),
//                                         religion: selectedReligion ?? '',
//                                       );

//                                   setState(() {
//                                     _isLoading = false;
//                                   });

//                                   if (success) {
//                                     _showSuccessDialog();
//                                   } else {
//                                     _showErrorDialog(
//                                       'Failed to add customer. Please try again.',
//                                     );
//                                   }
//                                 } catch (e) {
//                                   setState(() {
//                                     _isLoading = false;
//                                   });
//                                   _showErrorDialog('An error occurred: $e');
//                                 }
//                               }
//                             },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF6366F1),
//                         foregroundColor: Colors.white,
//                         elevation: 0,
//                         disabledBackgroundColor: Colors.grey.shade300,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                       ),
//                       child: _isLoading
//                           ? const SizedBox(
//                               height: 24,
//                               width: 24,
//                               child: CircularProgressIndicator(
//                                 color: Colors.white,
//                                 strokeWidth: 2.5,
//                               ),
//                             )
//                           : const Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(Icons.check_circle_rounded, size: 22),
//                                 SizedBox(width: 10),
//                                 AppText(
//                                   'save',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                     ),
//                   ),

//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),

//           // Loading Overlay
//           if (customerProvider.isLoading)
//             Container(
//               color: Colors.black.withOpacity(0.5),
//               child: Center(
//                 child: Container(
//                   padding: const EdgeInsets.all(32),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: const Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       CircularProgressIndicator(
//                         color: Color(0xFF6366F1),
//                         strokeWidth: 3,
//                       ),
//                       SizedBox(height: 20),
//                       Text(
//                         'Adding Customer...',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF0F172A),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:posternova/helper/storage_helper.dart';
import 'package:posternova/providers/customer/customer_provider.dart';
import 'package:posternova/widgets/language_widget.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// ─── Theme Colors Extension ─────────────────────────────────────────────────

class AddCustomerColors {
  // Light Theme
  static const lightBackground = Colors.white;
  static const lightSurface = Color(0xFFF8FAFC);
  static const lightTextPrimary = Color(0xFF0F172A);
  static const lightTextSecondary = Color(0xFF334155);
  static const lightTextHint = Color(0xFF94A3B8);
  static const lightBorder = Color(0xFFE2E8F0);
  static const lightPrimary = Color(0xFF6366F1);
  static const lightPrimaryLight = Color(0xFF818CF8);
  static const lightSuccess = Color(0xFF10B981);
  static const lightError = Color(0xFFEF4444);
  static const lightCardBg = Color(0xFFF1F5F9);

  // Dark Theme
  static const darkBackground = Color(0xFF121212);
  static const darkSurface = Color(0xFF1E1E1E);
  static const darkTextPrimary = Color(0xFFF1F5F9);
  static const darkTextSecondary = Color(0xFF94A3B8);
  static const darkTextHint = Color(0xFF64748B);
  static const darkBorder = Color(0xFF334155);
  static const darkPrimary = Color(0xFF818CF8);
  static const darkPrimaryLight = Color(0xFF6366F1);
  static const darkSuccess = Color(0xFF34D399);
  static const darkError = Color(0xFFF87171);
  static const darkCardBg = Color(0xFF2D2D2D);
}

class AddCustomer extends StatefulWidget {
  const AddCustomer({super.key});

  @override
  State<AddCustomer> createState() => _AddnewCustomersState();
}

class _AddnewCustomersState extends State<AddCustomer> {
  final _formKey = GlobalKey<FormState>();
  String? selectedGender;
  String? selectedReligion;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _anniversaryController = TextEditingController();
  bool _isLoading = false;

  String userId = '';

  DateTime? selectedDob;
  DateTime? selectedAnniversary;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await AuthPreferences.getUserData();
    print(userData);
    if (userData != null && userData.user != null) {
      setState(() {
        userId = userData.user.id;
      });
      print('User ID: $userId');
    } else {
      print("No User ID");
    }
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
    bool isDob,
  ) async {
    final DateTime now = DateTime.now();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year + 50),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme(
              brightness: isDarkMode ? Brightness.dark : Brightness.light,
              primary: isDarkMode
                  ? AddCustomerColors.darkPrimary
                  : AddCustomerColors.lightPrimary,
              onPrimary: Colors.white,
              secondary: isDarkMode
                  ? AddCustomerColors.darkPrimary
                  : AddCustomerColors.lightPrimary,
              onSecondary: Colors.white,
              error: isDarkMode
                  ? AddCustomerColors.darkError
                  : AddCustomerColors.lightError,
              onError: Colors.white,
              surface: isDarkMode
                  ? AddCustomerColors.darkSurface
                  : Colors.white,
              onSurface: isDarkMode
                  ? AddCustomerColors.darkTextPrimary
                  : AddCustomerColors.lightTextPrimary,
            ),
            dialogBackgroundColor: isDarkMode
                ? AddCustomerColors.darkSurface
                : Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isDob) {
          selectedDob = picked;
        } else {
          selectedAnniversary = picked;
        }
        controller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  String _formatDateForApi(DateTime? date) {
    if (date == null) return '';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String? _validateDate(String? value, bool isDob) {
    if (value == null || value.isEmpty) {
      return isDob ? 'Please enter a date of birth' : null;
    }

    if (isDob && selectedDob != null) {
      final now = DateTime.now();
      if (selectedDob!.isAfter(now)) {
        return 'Date of birth cannot be in the future';
      }

      final age = now.difference(selectedDob!).inDays / 365.25;
      if (age > 150) {
        return 'Please enter a valid date of birth';
      }
    }

    return null;
  }

  void _showSuccessDialog() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: isDarkMode
              ? AddCustomerColors.darkSurface
              : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color:
                        (isDarkMode
                                ? AddCustomerColors.darkSuccess
                                : AddCustomerColors.lightSuccess)
                            .withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: isDarkMode
                        ? AddCustomerColors.darkSuccess
                        : AddCustomerColors.lightSuccess,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Customer Added',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode
                        ? AddCustomerColors.darkTextPrimary
                        : AddCustomerColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'The customer has been successfully added to your database.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: isDarkMode
                        ? AddCustomerColors.darkTextSecondary
                        : Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode
                          ? AddCustomerColors.darkPrimary
                          : AddCustomerColors.lightPrimary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: isDarkMode
              ? AddCustomerColors.darkSurface
              : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color:
                        (isDarkMode
                                ? AddCustomerColors.darkError
                                : AddCustomerColors.lightError)
                            .withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline_rounded,
                    color: isDarkMode
                        ? AddCustomerColors.darkError
                        : AddCustomerColors.lightError,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Error',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode
                        ? AddCustomerColors.darkTextPrimary
                        : AddCustomerColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: isDarkMode
                        ? AddCustomerColors.darkTextSecondary
                        : Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode
                          ? AddCustomerColors.darkError
                          : AddCustomerColors.lightError,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Try Again',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool readOnly = false,
    VoidCallback? onTap,
    List<TextInputFormatter>? inputFormatters,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDarkMode
                  ? AddCustomerColors.darkTextSecondary
                  : AddCustomerColors.lightTextSecondary,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          readOnly: readOnly,
          onTap: onTap,
          inputFormatters: inputFormatters,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: isDarkMode
                ? AddCustomerColors.darkTextPrimary
                : AddCustomerColors.lightTextPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              icon,
              size: 22,
              color: isDarkMode
                  ? AddCustomerColors.darkPrimary
                  : AddCustomerColors.lightPrimary,
            ),
            hintStyle: TextStyle(
              color: isDarkMode
                  ? AddCustomerColors.darkTextHint
                  : Colors.grey.shade400,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: isDarkMode
                ? AddCustomerColors.darkSurface
                : AddCustomerColors.lightSurface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: isDarkMode
                    ? AddCustomerColors.darkBorder
                    : AddCustomerColors.lightBorder,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: isDarkMode
                    ? AddCustomerColors.darkBorder
                    : AddCustomerColors.lightBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: isDarkMode
                    ? AddCustomerColors.darkPrimary
                    : AddCustomerColors.lightPrimary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: isDarkMode
                    ? AddCustomerColors.darkError
                    : AddCustomerColors.lightError,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: isDarkMode
                    ? AddCustomerColors.darkError
                    : AddCustomerColors.lightError,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderDropdown() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            AppText.translate(context, 'gender'),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDarkMode
                  ? AddCustomerColors.darkTextSecondary
                  : AddCustomerColors.lightTextSecondary,
            ),
          ),
        ),
        DropdownButtonFormField<String>(
          dropdownColor: isDarkMode
              ? AddCustomerColors.darkSurface
              : Colors.white,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.wc_rounded,
              size: 22,
              color: isDarkMode
                  ? AddCustomerColors.darkPrimary
                  : AddCustomerColors.lightPrimary,
            ),
            filled: true,
            fillColor: isDarkMode
                ? AddCustomerColors.darkSurface
                : AddCustomerColors.lightSurface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: isDarkMode
                    ? AddCustomerColors.darkBorder
                    : AddCustomerColors.lightBorder,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: isDarkMode
                    ? AddCustomerColors.darkBorder
                    : AddCustomerColors.lightBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: isDarkMode
                    ? AddCustomerColors.darkPrimary
                    : AddCustomerColors.lightPrimary,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
          ),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: isDarkMode
                ? AddCustomerColors.darkTextPrimary
                : AddCustomerColors.lightTextPrimary,
          ),
          icon: Icon(
            Icons.arrow_drop_down_rounded,
            color: isDarkMode
                ? AddCustomerColors.darkPrimary
                : AddCustomerColors.lightPrimary,
          ),
          hint: Text(
            'Select gender',
            style: TextStyle(
              color: isDarkMode
                  ? AddCustomerColors.darkTextHint
                  : Colors.grey.shade400,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          items: ['Male', 'Female', 'Other']
              .map(
                (gender) => DropdownMenuItem(
                  value: gender,
                  child: Text(
                    gender,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode
                          ? AddCustomerColors.darkTextPrimary
                          : AddCustomerColors.lightTextPrimary,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedGender = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a gender';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildReligionDropdown() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Religion',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDarkMode
                  ? AddCustomerColors.darkTextSecondary
                  : AddCustomerColors.lightTextSecondary,
            ),
          ),
        ),
        DropdownButtonFormField<String>(
          dropdownColor: isDarkMode
              ? AddCustomerColors.darkSurface
              : Colors.white,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.temple_hindu_rounded,
              size: 22,
              color: isDarkMode
                  ? AddCustomerColors.darkPrimary
                  : AddCustomerColors.lightPrimary,
            ),
            filled: true,
            fillColor: isDarkMode
                ? AddCustomerColors.darkSurface
                : AddCustomerColors.lightSurface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: isDarkMode
                    ? AddCustomerColors.darkBorder
                    : AddCustomerColors.lightBorder,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: isDarkMode
                    ? AddCustomerColors.darkBorder
                    : AddCustomerColors.lightBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: isDarkMode
                    ? AddCustomerColors.darkPrimary
                    : AddCustomerColors.lightPrimary,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
          ),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: isDarkMode
                ? AddCustomerColors.darkTextPrimary
                : AddCustomerColors.lightTextPrimary,
          ),
          icon: Icon(
            Icons.arrow_drop_down_rounded,
            color: isDarkMode
                ? AddCustomerColors.darkPrimary
                : AddCustomerColors.lightPrimary,
          ),
          hint: Text(
            'Select religion',
            style: TextStyle(
              color: isDarkMode
                  ? AddCustomerColors.darkTextHint
                  : Colors.grey.shade400,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          items:
              [
                    'Hindu',
                    'Muslim',
                    'Christian',
                    'Sikh',
                    'Buddhist',
                    'Jain',
                    'Other',
                  ]
                  .map(
                    (religion) => DropdownMenuItem(
                      value: religion,
                      child: Text(
                        religion,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode
                              ? AddCustomerColors.darkTextPrimary
                              : AddCustomerColors.lightTextPrimary,
                        ),
                      ),
                    ),
                  )
                  .toList(),
          onChanged: (value) {
            setState(() {
              selectedReligion = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a religion';
            }
            return null;
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _dobController.dispose();
    _anniversaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CreateCustomerProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AddCustomerColors.darkBackground
          : AddCustomerColors.lightBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDarkMode
            ? AddCustomerColors.darkSurface
            : Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AddCustomerColors.darkCardBg
                  : AddCustomerColors.lightCardBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: isDarkMode
                  ? AddCustomerColors.darkTextPrimary
                  : AddCustomerColors.lightTextPrimary,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: AppText(
          'add_customers',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: isDarkMode
                ? AddCustomerColors.darkTextPrimary
                : AddCustomerColors.lightTextPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDarkMode
                            ? [
                                AddCustomerColors.darkPrimary,
                                AddCustomerColors.darkPrimaryLight,
                              ]
                            : [
                                AddCustomerColors.lightPrimary,
                                AddCustomerColors.lightPrimaryLight,
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.person_add_alt_1_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                'new_customer',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              AppText(
                                'fill_customer_details',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Basic Information
                  AppText(
                    'basic_information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode
                          ? AddCustomerColors.darkTextPrimary
                          : AddCustomerColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildInputField(
                    controller: _nameController,
                    label: AppText.translate(context, 'name'),
                    icon: Icons.person_rounded,
                    hint: AppText.translate(context, 'enter_full_name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  _buildInputField(
                    controller: _mobileController,
                    label: AppText.translate(context, 'mobile_number'),
                    icon: Icons.phone_rounded,
                    hint: AppText.translate(context, 'enter_mobile_number'),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a mobile number';
                      }
                      if (value.length != 10) {
                        return 'Mobile number must be exactly 10 digits';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  _buildInputField(
                    controller: _emailController,
                    label: '${AppText.translate(context, 'email_optional')}',
                    icon: Icons.email_rounded,
                    hint:
                        '${AppText.translate(context, 'enter_email_optional')}',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  _buildGenderDropdown(),

                  const SizedBox(height: 20),

                  _buildReligionDropdown(),

                  const SizedBox(height: 32),

                  // Additional Information
                  AppText(
                    'additional_information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode
                          ? AddCustomerColors.darkTextPrimary
                          : AddCustomerColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildInputField(
                    controller: _dobController,
                    label: AppText.translate(context, 'date_of_birth'),
                    icon: Icons.cake_rounded,
                    hint: 'DD/MM/YYYY',
                    readOnly: true,
                    onTap: () => _selectDate(context, _dobController, true),
                    validator: (value) => _validateDate(value, true),
                  ),

                  const SizedBox(height: 20),

                  _buildInputField(
                    controller: _anniversaryController,
                    label:
                        '${AppText.translate(context, 'date_of_anniversary')} (Optional)',
                    icon: Icons.favorite_rounded,
                    hint: 'DD/MM/YYYY',
                    readOnly: true,
                    onTap: () =>
                        _selectDate(context, _anniversaryController, false),
                    validator: (value) => _validateDate(value, false),
                  ),

                  const SizedBox(height: 20),

                  _buildInputField(
                    controller: _addressController,
                    label:
                        '${AppText.translate(context, 'address')} (Optional)',
                    icon: Icons.location_on_rounded,
                    hint:
                        '${AppText.translate(context, 'enter_address_optional')} (Optional)',
                  ),

                  const SizedBox(height: 32),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });

                                try {
                                  final success = await customerProvider
                                      .addCustomer(
                                        userId: userId,
                                        name: _nameController.text.trim(),
                                        email: _emailController.text.trim(),
                                        mobile: _mobileController.text.trim(),
                                        dob: _formatDateForApi(selectedDob),
                                        address: _addressController.text.trim(),
                                        gender: selectedGender ?? '',
                                        anniversaryDate: _formatDateForApi(
                                          selectedAnniversary,
                                        ),
                                        religion: selectedReligion ?? '',
                                      );

                                  setState(() {
                                    _isLoading = false;
                                  });

                                  if (success) {
                                    _showSuccessDialog();
                                  } else {
                                    _showErrorDialog(
                                      'Failed to add customer. Please try again.',
                                    );
                                  }
                                } catch (e) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  _showErrorDialog('An error occurred: $e');
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode
                            ? AddCustomerColors.darkPrimary
                            : AddCustomerColors.lightPrimary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        disabledBackgroundColor: isDarkMode
                            ? AddCustomerColors.darkCardBg
                            : Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.check_circle_rounded,
                                  size: 22,
                                ),
                                const SizedBox(width: 10),
                                AppText(
                                  'save',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode
                                        ? AddCustomerColors.darkTextPrimary
                                        : Colors.white,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Loading Overlay
          if (customerProvider.isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AddCustomerColors.darkSurface
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        color: AddCustomerColors.lightPrimary,
                        strokeWidth: 3,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Adding Customer...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode
                              ? AddCustomerColors.darkTextPrimary
                              : AddCustomerColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
