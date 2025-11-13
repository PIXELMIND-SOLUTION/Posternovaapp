
// // import 'package:flutter/material.dart';
// // import 'package:posternova/providers/redeem/redeem_provider.dart';
// // import 'package:posternova/widgets/language_widget.dart';
// // import 'package:provider/provider.dart';

// // class BankDetailsScreen extends StatefulWidget {
// //   const BankDetailsScreen({super.key});

// //   @override
// //   State<BankDetailsScreen> createState() => _BankDetailsScreenState();
// // }

// // class _BankDetailsScreenState extends State<BankDetailsScreen> {
// //   final _formKey = GlobalKey<FormState>();
// //   final _accountHolderController = TextEditingController();
// //   final _accountNumberController = TextEditingController();
// //   final _ifscCodeController = TextEditingController();
// //   final _bankNameController = TextEditingController();

// //   String _selectedAccountType = 'Checking';

// //   static const Color _primary = Color(0xFF6842FF);
// //   static const Color _bg = Color(0xFFF7F8FA);
// //   static const BorderRadius _radius16 = BorderRadius.all(Radius.circular(16));

// //   @override
// //   void initState() {
// //     super.initState();
// //     // If you need to load history, keep this hook
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       context.read<RedeemProvider>();
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     _accountHolderController.dispose();
// //     _accountNumberController.dispose();
// //     _ifscCodeController.dispose();
// //     _bankNameController.dispose();
// //     super.dispose();
// //   }

// //   Future<void> _submitRedemption() async {
// //     if (!_formKey.currentState!.validate()) return;

// //     final redeemProvider = context.read<RedeemProvider>();
// //     redeemProvider.clearError();

// //     final success = await redeemProvider.submitRedemption(
// //       accountHolderName: _accountHolderController.text.trim(),
// //       accountNumber: _accountNumberController.text.trim(),
// //       ifscCode: _ifscCodeController.text.trim(),
// //       bankName: _bankNameController.text.trim(),
// //     );

// //     if (!mounted) return;

// //     if (success) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text('Redemption request submitted successfully!'),
// //           backgroundColor: Colors.green,
// //         ),
// //       );
// //       _showSuccessDialog();
// //     } else {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text(
// //             redeemProvider.errorMessage ??
// //                 'Failed to submit redemption request',
// //           ),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //     }
// //   }

// //   void _showSuccessDialog() {
// //     showDialog(
// //       context: context,
// //       barrierDismissible: false,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
// //           title: Row(
// //             children: const [
// //               Icon(Icons.check_circle, color: Colors.green, size: 28),
// //               SizedBox(width: 10),
// //               Text('Success!'),
// //             ],
// //           ),
// //           content: const Text(
// //             'Your redemption request has been submitted successfully. '
// //             'You will receive confirmation once it\'s processed.',
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () {
// //                 Navigator.of(context).pop(); // dialog
// //                 Navigator.of(context).pop(); // screen
// //               },
// //               child: const Text('OK'),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }

// //   InputDecoration _inputDecoration({
// //     required BuildContext context,
// //     required String label,
// //     IconData? prefix,
// //   }) {
// //     return InputDecoration(
// //       labelText: AppText.translate(context, label),
// //       prefixIcon: prefix != null ? Icon(prefix) : null,
// //       filled: true,
// //       fillColor: Colors.white,
// //       contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
// //       border: OutlineInputBorder(
// //         borderRadius: BorderRadius.circular(12),
// //         borderSide: BorderSide(color: Colors.grey.shade300),
// //       ),
// //       enabledBorder: OutlineInputBorder(
// //         borderRadius: BorderRadius.circular(12),
// //         borderSide: BorderSide(color: Colors.grey.shade300),
// //       ),
// //       focusedBorder: OutlineInputBorder(
// //         borderRadius: BorderRadius.circular(12),
// //         borderSide: const BorderSide(color: _primary, width: 1.4),
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: _bg,
// //       appBar: AppBar(
// //         elevation: 0,
// //         backgroundColor: Colors.transparent,
// //         leading: IconButton(
// //           onPressed: () => Navigator.of(context).pop(),
// //           icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
// //         ),
// //         centerTitle: true,
// //         title: const AppText(
// //           'bank_details',
// //           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
// //         ),
// //       ),
// //       body: Consumer<RedeemProvider>(
// //         builder: (context, redeemProvider, _) {
// //           return Column(
// //             children: [
// //               // Gradient header
// //               Container(
// //                 margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
// //                 padding: const EdgeInsets.all(18),
// //                 decoration: BoxDecoration(
// //                   gradient: const LinearGradient(
// //                     colors: [Color(0xFF6E62FF), Color(0xFF8A7BFF)],
// //                     begin: Alignment.topLeft,
// //                     end: Alignment.bottomRight,
// //                   ),
// //                   borderRadius: _radius16,
// //                   boxShadow: [
// //                     BoxShadow(
// //                       color: _primary.withOpacity(0.18),
// //                       blurRadius: 16,
// //                       offset: const Offset(0, 8),
// //                     ),
// //                   ],
// //                 ),
// //                 child: Row(
// //                   children: [
// //                     Container(
// //                       width: 54,
// //                       height: 54,
// //                       decoration: BoxDecoration(
// //                         color: Colors.white.withOpacity(0.15),
// //                         borderRadius: BorderRadius.circular(14),
// //                         border: Border.all(color: Colors.white24),
// //                       ),
// //                       child: const Icon(Icons.account_balance,
// //                           color: Colors.white, size: 28),
// //                     ),
// //                     const SizedBox(width: 14),
// //                     Expanded(
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: const [
// //                           AppText(
// //                             'add_bank_details',
// //                             style: TextStyle(
// //                               color: Colors.white,
// //                               fontWeight: FontWeight.w700,
// //                               fontSize: 16,
// //                             ),
// //                           ),
// //                           SizedBox(height: 4),
// //                           AppText(
// //                             'secure_bank_info',
// //                             style: TextStyle(
// //                               color: Colors.white70,
// //                               fontSize: 12,
// //                               height: 1.2,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),

// //               // Body
// //               Expanded(
// //                 child: SingleChildScrollView(
// //                   padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
// //                   child: Form(
// //                     key: _formKey,
// //                     child: Column(
// //                       children: [
// //                         const SizedBox(height: 14),

// //                         // Card: Bank info
// //                         Container(
// //                           width: double.infinity,
// //                           padding: const EdgeInsets.all(18),
// //                           decoration: BoxDecoration(
// //                             color: Colors.white,
// //                             borderRadius: _radius16,
// //                             boxShadow: [
// //                               BoxShadow(
// //                                 color: Colors.black.withOpacity(0.03),
// //                                 blurRadius: 12,
// //                                 offset: const Offset(0, 6),
// //                               ),
// //                             ],
// //                           ),
// //                           child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               const AppText(
// //                                 'bank_info',
// //                                 style: TextStyle(
// //                                   fontSize: 16,
// //                                   fontWeight: FontWeight.w700,
// //                                   color: Colors.black87,
// //                                 ),
// //                               ),
// //                               const SizedBox(height: 14),

// //                               // Account Holder Name
// //                               TextFormField(
// //                                 controller: _accountHolderController,
// //                                 decoration: _inputDecoration(
// //                                   context: context,
// //                                   label: 'account_holder_name',
// //                                   prefix: Icons.person_outline,
// //                                 ),
// //                                 validator: (value) {
// //                                   if (value == null || value.isEmpty) {
// //                                     return 'Please enter account holder name';
// //                                   }
// //                                   if (value.length < 2) {
// //                                     return 'Account holder name must be at least 2 characters';
// //                                   }
// //                                   return null;
// //                                 },
// //                               ),
// //                               const SizedBox(height: 12),

// //                               // Bank Name
// //                               TextFormField(
// //                                 controller: _bankNameController,
// //                                 decoration: _inputDecoration(
// //                                   context: context,
// //                                   label: 'bank_name',
// //                                   prefix: Icons.account_balance,
// //                                 ),
// //                                 validator: (value) {
// //                                   if (value == null || value.isEmpty) {
// //                                     return 'Please enter bank name';
// //                                   }
// //                                   return null;
// //                                 },
// //                               ),
// //                               const SizedBox(height: 12),

// //                               // Account Type
// //                               DropdownButtonFormField<String>(
// //                                 value: _selectedAccountType,
// //                                 decoration: _inputDecoration(
// //                                   context: context,
// //                                   label: 'account_type',
// //                                   prefix: Icons.account_box_outlined,
// //                                 ),
// //                                 items: const ['Checking', 'Savings']
// //                                     .map((String value) => DropdownMenuItem(
// //                                           value: value,
// //                                           child: Text(value),
// //                                         ))
// //                                     .toList(),
// //                                 onChanged: (String? newValue) {
// //                                   setState(() {
// //                                     _selectedAccountType = newValue!;
// //                                   });
// //                                 },
// //                               ),
// //                               const SizedBox(height: 12),

// //                               // Account Number
// //                               TextFormField(
// //                                 controller: _accountNumberController,
// //                                 keyboardType: TextInputType.number,
// //                                 decoration: _inputDecoration(
// //                                   context: context,
// //                                   label: 'account_number',
// //                                   prefix: Icons.credit_card,
// //                                 ).copyWith(
// //                                   helperText:
// //                                       'Enter the full account number without spaces',
// //                                 ),
// //                                 validator: (value) {
// //                                   if (value == null || value.isEmpty) {
// //                                     return 'Please enter account number';
// //                                   }
// //                                   if (value.length < 8) {
// //                                     return 'Account number must be at least 8 digits';
// //                                   }
// //                                   return null;
// //                                 },
// //                               ),
// //                               const SizedBox(height: 12),

// //                               // IFSC Code
// //                               TextFormField(
// //                                 controller: _ifscCodeController,
// //                                 textCapitalization:
// //                                     TextCapitalization.characters,
// //                                 decoration: _inputDecoration(
// //                                   context: context,
// //                                   label: 'IFSC Code',
// //                                   prefix: Icons.code,
// //                                 ),
// //                                 validator: (value) {
// //                                   if (value == null || value.isEmpty) {
// //                                     return 'Please enter IFSC code';
// //                                   }
// //                                   if (value.length != 11) {
// //                                     return 'IFSC code must be 11 characters';
// //                                   }
// //                                   final ifscPattern =
// //                                       RegExp(r'^[A-Z]{4}[0][A-Z0-9]{6}$');
// //                                   if (!ifscPattern.hasMatch(value.toUpperCase())) {
// //                                     return 'Please enter a valid IFSC code';
// //                                   }
// //                                   return null;
// //                                 },
// //                               ),
// //                             ],
// //                           ),
// //                         ),

// //                         const SizedBox(height: 16),

// //                         const SizedBox(height: 12),

// //                         // Actions
// //                         Row(
// //                           children: [
// //                             Expanded(
// //                               child: OutlinedButton(
// //                                 onPressed: redeemProvider.isSubmittingRedemption
// //                                     ? null
// //                                     : () => Navigator.of(context).pop(),
// //                                 style: OutlinedButton.styleFrom(
// //                                   padding:
// //                                       const EdgeInsets.symmetric(vertical: 16),
// //                                   side: BorderSide(color: Colors.grey.shade400),
// //                                   shape: RoundedRectangleBorder(
// //                                     borderRadius: BorderRadius.circular(12),
// //                                   ),
// //                                   foregroundColor: Colors.black87,
// //                                 ),
// //                                 child: const AppText(
// //                                   'cancel',
// //                                   style: TextStyle(fontSize: 16),
// //                                 ),
// //                               ),
// //                             ),
// //                             const SizedBox(width: 12),
// //                             Expanded(
// //                               child: ElevatedButton(
// //                                 onPressed: redeemProvider.isSubmittingRedemption
// //                                     ? null
// //                                     : _submitRedemption,
// //                                 style: ElevatedButton.styleFrom(
// //                                   backgroundColor: _primary,
// //                                   foregroundColor: Colors.white,
// //                                   padding:
// //                                       const EdgeInsets.symmetric(vertical: 16),
// //                                   shape: RoundedRectangleBorder(
// //                                     borderRadius: BorderRadius.circular(12),
// //                                   ),
// //                                   elevation: 0,
// //                                 ),
// //                                 child: redeemProvider.isSubmittingRedemption
// //                                     ? Row(
// //                                         mainAxisAlignment:
// //                                             MainAxisAlignment.center,
// //                                         children: const [
// //                                           SizedBox(
// //                                             width: 20,
// //                                             height: 20,
// //                                             child: CircularProgressIndicator(
// //                                               strokeWidth: 2,
// //                                               valueColor:
// //                                                   AlwaysStoppedAnimation<Color>(
// //                                                 Colors.white,
// //                                               ),
// //                                             ),
// //                                           ),
// //                                           SizedBox(width: 10),
// //                                           Text(
// //                                             'Submitting...',
// //                                             style: TextStyle(
// //                                               fontSize: 16,
// //                                               fontWeight: FontWeight.bold,
// //                                             ),
// //                                           ),
// //                                         ],
// //                                       )
// //                                     : const AppText(
// //                                         'save_details',
// //                                         style: TextStyle(
// //                                           fontSize: 16,
// //                                           fontWeight: FontWeight.bold,
// //                                         ),
// //                                       ),
// //                               ),
// //                             ),
// //                           ],
// //                         ),

// //                         // Redemption History
// //                         if (redeemProvider.redemptionHistory.isNotEmpty) ...[
// //                           const SizedBox(height: 20),
// //                           Container(
// //                             width: double.infinity,
// //                             padding: const EdgeInsets.all(18),
// //                             decoration: BoxDecoration(
// //                               color: Colors.white,
// //                               borderRadius: _radius16,
// //                               boxShadow: [
// //                                 BoxShadow(
// //                                   color: Colors.black.withOpacity(0.03),
// //                                   blurRadius: 12,
// //                                   offset: const Offset(0, 6),
// //                                 ),
// //                               ],
// //                             ),
// //                             child: Column(
// //                               crossAxisAlignment: CrossAxisAlignment.start,
// //                               children: [
// //                                 Row(
// //                                   children: const [
// //                                     Icon(Icons.history, color: _primary),
// //                                     SizedBox(width: 10),
// //                                     Text(
// //                                       'Recent Redemptions',
// //                                       style: TextStyle(
// //                                         fontSize: 16,
// //                                         fontWeight: FontWeight.w700,
// //                                         color: Colors.black87,
// //                                       ),
// //                                     ),
// //                                   ],
// //                                 ),
// //                                 const SizedBox(height: 12),
// //                                 ...redeemProvider.redemptionHistory
// //                                     .take(3)
// //                                     .map((redemption) {
// //                                   final maskedAccount =
// //                                       redemption.accountNumber.length > 8
// //                                           ? '${redemption.accountNumber.substring(0, 4)}${'*' * (redemption.accountNumber.length - 8)}${redemption.accountNumber.substring(redemption.accountNumber.length - 4)}'
// //                                           : redemption.accountNumber;
// //                                   final statusColor =
// //                                       redemption.getStatusColor();
// //                                   return Container(
// //                                     margin: const EdgeInsets.only(bottom: 12),
// //                                     padding: const EdgeInsets.all(14),
// //                                     decoration: BoxDecoration(
// //                                       color: Colors.grey.shade50,
// //                                       borderRadius: BorderRadius.circular(12),
// //                                       border: Border.all(
// //                                           color: Colors.grey.shade200),
// //                                     ),
// //                                     child: Column(
// //                                       crossAxisAlignment:
// //                                           CrossAxisAlignment.start,
// //                                       children: [
// //                                         Row(
// //                                           mainAxisAlignment:
// //                                               MainAxisAlignment.spaceBetween,
// //                                           children: [
// //                                             Text(
// //                                               '₹${redemption.amount.toStringAsFixed(2)}',
// //                                               style: const TextStyle(
// //                                                 fontSize: 16,
// //                                                 fontWeight: FontWeight.w700,
// //                                                 color: Colors.black87,
// //                                               ),
// //                                             ),
// //                                             Container(
// //                                               padding:
// //                                                   const EdgeInsets.symmetric(
// //                                                       horizontal: 10,
// //                                                       vertical: 6),
// //                                               decoration: BoxDecoration(
// //                                                 color:
// //                                                     statusColor.withOpacity(0.1),
// //                                                 borderRadius:
// //                                                     BorderRadius.circular(24),
// //                                                 border: Border.all(
// //                                                     color: statusColor),
// //                                               ),
// //                                               child: Text(
// //                                                 redemption.getFormattedStatus(),
// //                                                 style: TextStyle(
// //                                                   fontSize: 12,
// //                                                   fontWeight: FontWeight.w700,
// //                                                   color: statusColor,
// //                                                 ),
// //                                               ),
// //                                             ),
// //                                           ],
// //                                         ),
// //                                         const SizedBox(height: 8),
// //                                         Text(
// //                                           '${redemption.bankName} • $maskedAccount',
// //                                           style: TextStyle(
// //                                             fontSize: 14,
// //                                             color: Colors.grey.shade700,
// //                                           ),
// //                                         ),
// //                                         const SizedBox(height: 4),
// //                                         Text(
// //                                           'Submitted: ${_formatDate(redemption.createdAt)}',
// //                                           style: TextStyle(
// //                                             fontSize: 12,
// //                                             color: Colors.grey.shade600,
// //                                           ),
// //                                         ),
// //                                       ],
// //                                     ),
// //                                   );
// //                                 }).toList(),
// //                                 // if (redeemProvider.redemptionHistory.length > 3)
// //                                 //   Align(
// //                                 //     alignment: Alignment.centerRight,
// //                                 //     child: TextButton(
// //                                 //       onPressed: () {
// //                                 //         // TODO: navigate to full history screen
// //                                 //       },
// //                                 //       child: const Text('View All Redemptions'),
// //                                 //     ),
// //                                 //   ),
// //                               ],
// //                             ),
// //                           ),
// //                         ],
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           );
// //         },
// //       ),
// //     );
// //   }

// //   String _formatDate(DateTime date) {
// //     return '${date.day}/${date.month}/${date.year} '
// //         '${date.hour.toString().padLeft(2, '0')}:'
// //         '${date.minute.toString().padLeft(2, '0')}';
// //   }
// // }

















// import 'package:flutter/material.dart';
// import 'package:posternova/providers/redeem/redeem_provider.dart';
// import 'package:posternova/widgets/language_widget.dart';
// import 'package:provider/provider.dart';

// class BankDetailsScreen extends StatefulWidget {
//   const BankDetailsScreen({super.key});

//   @override
//   State<BankDetailsScreen> createState() => _BankDetailsScreenState();
// }

// class _BankDetailsScreenState extends State<BankDetailsScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _accountHolderController = TextEditingController();
//   final _accountNumberController = TextEditingController();
//   final _ifscCodeController = TextEditingController();
//   final _bankNameController = TextEditingController();
//   final _upiIdController = TextEditingController();

//   String _selectedAccountType = 'Checking';

//   static const Color _primary = Color(0xFF6842FF);
//   static const Color _bg = Color(0xFFF7F8FA);
//   static const BorderRadius _radius16 = BorderRadius.all(Radius.circular(16));

//   @override
//   void initState() {
//     super.initState();
//     // If you need to load history, keep this hook
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<RedeemProvider>();
//     });
//   }

//   @override
//   void dispose() {
//     _accountHolderController.dispose();
//     _accountNumberController.dispose();
//     _ifscCodeController.dispose();
//     _bankNameController.dispose();
//     _upiIdController.dispose();
//     super.dispose();
//   }

//   Future<void> _submitRedemption() async {
//     if (!_formKey.currentState!.validate()) return;

//     final redeemProvider = context.read<RedeemProvider>();
//     redeemProvider.clearError();

//     final success = await redeemProvider.submitRedemption(
//       accountHolderName: _accountHolderController.text.trim(),
//       accountNumber: _accountNumberController.text.trim(),
//       ifscCode: _ifscCodeController.text.trim(),
//       bankName: _bankNameController.text.trim(),
//       upiId: _upiIdController.text.trim(),
//     );

//     if (!mounted) return;

//     if (success) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Redemption request submitted successfully!'),
//           backgroundColor: Colors.green,
//         ),
//       );
//       _showSuccessDialog();
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             redeemProvider.errorMessage ??
//                 'Failed to submit redemption request',
//           ),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   void _showSuccessDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//           title: Row(
//             children: const [
//               Icon(Icons.check_circle, color: Colors.green, size: 28),
//               SizedBox(width: 10),
//               Text('Success!'),
//             ],
//           ),
//           content: const Text(
//             'Your redemption request has been submitted successfully. '
//             'You will receive confirmation once it\'s processed.',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // dialog
//                 Navigator.of(context).pop(); // screen
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   InputDecoration _inputDecoration({
//     required BuildContext context,
//     required String label,
//     IconData? prefix,
//   }) {
//     return InputDecoration(
//       labelText: AppText.translate(context, label),
//       prefixIcon: prefix != null ? Icon(prefix) : null,
//       filled: true,
//       fillColor: Colors.white,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: Colors.grey.shade300),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: Colors.grey.shade300),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: _primary, width: 1.4),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _bg,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         leading: IconButton(
//           onPressed: () => Navigator.of(context).pop(),
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
//         ),
//         centerTitle: true,
//         title: const AppText(
//           'bank_details',
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
//         ),
//       ),
//       body: Consumer<RedeemProvider>(
//         builder: (context, redeemProvider, _) {
//           return Column(
//             children: [
//               // Gradient header
//               Container(
//                 margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
//                 padding: const EdgeInsets.all(18),
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF6E62FF), Color(0xFF8A7BFF)],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: _radius16,
//                   boxShadow: [
//                     BoxShadow(
//                       color: _primary.withOpacity(0.18),
//                       blurRadius: 16,
//                       offset: const Offset(0, 8),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 54,
//                       height: 54,
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.15),
//                         borderRadius: BorderRadius.circular(14),
//                         border: Border.all(color: Colors.white24),
//                       ),
//                       child: const Icon(Icons.account_balance,
//                           color: Colors.white, size: 28),
//                     ),
//                     const SizedBox(width: 14),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: const [
//                           AppText(
//                             'add_bank_details',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w700,
//                               fontSize: 16,
//                             ),
//                           ),
//                           SizedBox(height: 4),
//                           AppText(
//                             'secure_bank_info',
//                             style: TextStyle(
//                               color: Colors.white70,
//                               fontSize: 12,
//                               height: 1.2,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Body
//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       children: [
//                         const SizedBox(height: 14),

//                         // Card: Bank info
//                         Container(
//                           width: double.infinity,
//                           padding: const EdgeInsets.all(18),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: _radius16,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.03),
//                                 blurRadius: 12,
//                                 offset: const Offset(0, 6),
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const AppText(
//                                 'bank_info',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w700,
//                                   color: Colors.black87,
//                                 ),
//                               ),
//                               const SizedBox(height: 14),

//                               // Account Holder Name
//                               TextFormField(
//                                 controller: _accountHolderController,
//                                 decoration: _inputDecoration(
//                                   context: context,
//                                   label: 'account_holder_name',
//                                   prefix: Icons.person_outline,
//                                 ),
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter account holder name';
//                                   }
//                                   if (value.length < 2) {
//                                     return 'Account holder name must be at least 2 characters';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                               const SizedBox(height: 12),

//                               // Bank Name
//                               TextFormField(
//                                 controller: _bankNameController,
//                                 decoration: _inputDecoration(
//                                   context: context,
//                                   label: 'bank_name',
//                                   prefix: Icons.account_balance,
//                                 ),
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter bank name';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                               const SizedBox(height: 12),

//                               // Account Type
//                               DropdownButtonFormField<String>(
//                                 value: _selectedAccountType,
//                                 decoration: _inputDecoration(
//                                   context: context,
//                                   label: 'account_type',
//                                   prefix: Icons.account_box_outlined,
//                                 ),
//                                 items: const ['Checking', 'Savings']
//                                     .map((String value) => DropdownMenuItem(
//                                           value: value,
//                                           child: Text(value),
//                                         ))
//                                     .toList(),
//                                 onChanged: (String? newValue) {
//                                   setState(() {
//                                     _selectedAccountType = newValue!;
//                                   });
//                                 },
//                               ),
//                               const SizedBox(height: 12),

//                               // Account Number
//                               TextFormField(
//                                 controller: _accountNumberController,
//                                 keyboardType: TextInputType.number,
                               
//                                 decoration: _inputDecoration(
//                                   context: context,
//                                   label: 'account_number',
//                                   prefix: Icons.credit_card,
                                  
                                  
//                                 ).copyWith(
//                                   helperText:
//                                       'Enter the full account number without spaces',
//                                 ),
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter account number';
//                                   }
//                                   if (value.length < 8) {
//                                     return 'Account number must be at least 8 digits';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                               const SizedBox(height: 12),

//                               // IFSC Code
//                               TextFormField(
//                                 controller: _ifscCodeController,
//                                 textCapitalization:
//                                     TextCapitalization.characters,
//                                 decoration: _inputDecoration(
//                                   context: context,
//                                   label: 'IFSC Code',
//                                   prefix: Icons.code,
//                                 ),
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter IFSC code';
//                                   }
//                                   if (value.length != 11) {
//                                     return 'IFSC code must be 11 characters';
//                                   }
//                                   final ifscPattern =
//                                       RegExp(r'^[A-Z]{4}[0][A-Z0-9]{6}$');
//                                   if (!ifscPattern.hasMatch(value.toUpperCase())) {
//                                     return 'Please enter a valid IFSC code';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                               const SizedBox(height: 12),

//                               // UPI ID
//                               TextFormField(
//                                 controller: _upiIdController,
//                                 keyboardType: TextInputType.emailAddress,
//                                 decoration: _inputDecoration(
//                                   context: context,
//                                   label: 'UPI ID',
//                                   prefix: Icons.payment,
//                                 ).copyWith(
//                                   helperText: 'Enter your UPI ID (e.g., name@upi)',
//                                 ),
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter UPI ID';
//                                   }
//                                   // UPI ID format: username@provider
//                                   final upiPattern = RegExp(r'^[\w.-]+@[\w.-]+$');
//                                   if (!upiPattern.hasMatch(value)) {
//                                     return 'Please enter a valid UPI ID (e.g., name@upi)';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),

//                         const SizedBox(height: 16),

//                         const SizedBox(height: 12),

//                         // Actions
//                         Row(
//                           children: [
//                             Expanded(
//                               child: OutlinedButton(
//                                 onPressed: redeemProvider.isSubmittingRedemption
//                                     ? null
//                                     : () => Navigator.of(context).pop(),
//                                 style: OutlinedButton.styleFrom(
//                                   padding:
//                                       const EdgeInsets.symmetric(vertical: 16),
//                                   side: BorderSide(color: Colors.grey.shade400),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   foregroundColor: Colors.black87,
//                                 ),
//                                 child: const AppText(
//                                   'cancel',
//                                   style: TextStyle(fontSize: 16),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: ElevatedButton(
//                                 onPressed: redeemProvider.isSubmittingRedemption
//                                     ? null
//                                     : _submitRedemption,
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: _primary,
//                                   foregroundColor: Colors.white,
//                                   padding:
//                                       const EdgeInsets.symmetric(vertical: 16),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   elevation: 0,
//                                 ),
//                                 child: redeemProvider.isSubmittingRedemption
//                                     ? Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: const [
//                                           SizedBox(
//                                             width: 20,
//                                             height: 20,
//                                             child: CircularProgressIndicator(
//                                               strokeWidth: 2,
//                                               valueColor:
//                                                   AlwaysStoppedAnimation<Color>(
//                                                 Colors.white,
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(width: 10),
//                                           Text(
//                                             'Submitting...',
//                                             style: TextStyle(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ],
//                                       )
//                                     : const AppText(
//                                         'save_details',
//                                         style: TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                               ),
//                             ),
//                           ],
//                         ),

//                         // Redemption History
//                         if (redeemProvider.redemptionHistory.isNotEmpty) ...[
//                           const SizedBox(height: 20),
//                           Container(
//                             width: double.infinity,
//                             padding: const EdgeInsets.all(18),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: _radius16,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.03),
//                                   blurRadius: 12,
//                                   offset: const Offset(0, 6),
//                                 ),
//                               ],
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: const [
//                                     Icon(Icons.history, color: _primary),
//                                     SizedBox(width: 10),
//                                     Text(
//                                       'Recent Redemptions',
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w700,
//                                         color: Colors.black87,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 12),
//                                 ...redeemProvider.redemptionHistory
//                                     .take(3)
//                                     .map((redemption) {
//                                   final maskedAccount =
//                                       redemption.accountNumber.length > 8
//                                           ? '${redemption.accountNumber.substring(0, 4)}${'*' * (redemption.accountNumber.length - 8)}${redemption.accountNumber.substring(redemption.accountNumber.length - 4)}'
//                                           : redemption.accountNumber;
//                                   final statusColor =
//                                       redemption.getStatusColor();
//                                   return Container(
//                                     margin: const EdgeInsets.only(bottom: 12),
//                                     padding: const EdgeInsets.all(14),
//                                     decoration: BoxDecoration(
//                                       color: Colors.grey.shade50,
//                                       borderRadius: BorderRadius.circular(12),
//                                       border: Border.all(
//                                           color: Colors.grey.shade200),
//                                     ),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Text(
//                                               '₹${redemption.amount.toStringAsFixed(2)}',
//                                               style: const TextStyle(
//                                                 fontSize: 16,
//                                                 fontWeight: FontWeight.w700,
//                                                 color: Colors.black87,
//                                               ),
//                                             ),
//                                             Container(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 10,
//                                                       vertical: 6),
//                                               decoration: BoxDecoration(
//                                                 color:
//                                                     statusColor.withOpacity(0.1),
//                                                 borderRadius:
//                                                     BorderRadius.circular(24),
//                                                 border: Border.all(
//                                                     color: statusColor),
//                                               ),
//                                               child: Text(
//                                                 redemption.getFormattedStatus(),
//                                                 style: TextStyle(
//                                                   fontSize: 12,
//                                                   fontWeight: FontWeight.w700,
//                                                   color: statusColor,
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         const SizedBox(height: 8),
//                                         Text(
//                                           '${redemption.bankName} • $maskedAccount',
//                                           style: TextStyle(
//                                             fontSize: 14,
//                                             color: Colors.grey.shade700,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 4),
//                                         Text(
//                                           'Submitted: ${_formatDate(redemption.createdAt)}',
//                                           style: TextStyle(
//                                             fontSize: 12,
//                                             color: Colors.grey.shade600,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 }).toList(),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   String _formatDate(DateTime date) {
//     return '${date.day}/${date.month}/${date.year} '
//         '${date.hour.toString().padLeft(2, '0')}:'
//         '${date.minute.toString().padLeft(2, '0')}';
//   }
// }












import 'package:flutter/material.dart';
import 'package:posternova/providers/redeem/redeem_provider.dart';
import 'package:posternova/widgets/language_widget.dart';
import 'package:provider/provider.dart';

class BankDetailsScreen extends StatefulWidget {
  const BankDetailsScreen({super.key});

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountHolderController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _ifscCodeController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _upiIdController = TextEditingController();

  String _selectedAccountType = 'Checking';

  static const Color _primary = Color(0xFF6842FF);
  static const Color _bg = Color(0xFFF7F8FA);
  static const BorderRadius _radius16 = BorderRadius.all(Radius.circular(16));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RedeemProvider>();
    });
  }

  @override
  void dispose() {
    _accountHolderController.dispose();
    _accountNumberController.dispose();
    _ifscCodeController.dispose();
    _bankNameController.dispose();
    _upiIdController.dispose();
    super.dispose();
  }

  Future<void> _submitRedemption() async {
    if (!_formKey.currentState!.validate()) return;

    final redeemProvider = context.read<RedeemProvider>();
    redeemProvider.clearError();

    final success = await redeemProvider.submitRedemption(
      accountHolderName: _accountHolderController.text.trim(),
      accountNumber: _accountNumberController.text.trim(),
      ifscCode: _ifscCodeController.text.trim(),
      bankName: _bankNameController.text.trim(),
      upiId: _upiIdController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Redemption request submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      _showSuccessDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            redeemProvider.errorMessage ??
                'Failed to submit redemption request',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 10),
              Text('Success!'),
            ],
          ),
          content: const Text(
            'Your redemption request has been submitted successfully. '
            'You will receive confirmation once it\'s processed.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // dialog
                Navigator.of(context).pop(); // screen
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  InputDecoration _inputDecoration({
    required BuildContext context,
    required String label,
    IconData? prefix,
    bool isRequired = false,
  }) {
    return InputDecoration(
      labelText: '${AppText.translate(context, label)}${isRequired ? ' *' : ' (Optional)'}',
      prefixIcon: prefix != null ? Icon(prefix) : null,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: isRequired ? _primary : Colors.grey.shade400, width: 1.4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
        ),
        centerTitle: true,
        title: const AppText(
          'bank_details',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ),
      body: Consumer<RedeemProvider>(
        builder: (context, redeemProvider, _) {
          return Column(
            children: [
              // Gradient header
              Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6E62FF), Color(0xFF8A7BFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: _radius16,
                  boxShadow: [
                    BoxShadow(
                      color: _primary.withOpacity(0.18),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Icon(Icons.account_balance,
                          color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          AppText(
                            'add_bank_details',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          AppText(
                            'secure_bank_info',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Body
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 14),

                        // Card: Bank info
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: _radius16,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const AppText(
                                'bank_info',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 14),

                              // UPI ID - MANDATORY
                              TextFormField(
                                controller: _upiIdController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: _inputDecoration(
                                  context: context,
                                  label: 'UPI ID',
                                  prefix: Icons.payment,
                                  isRequired: true,
                                ).copyWith(
                                  helperText: 'Enter your UPI ID (e.g., name@upi)',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter UPI ID';
                                  }
                                  // UPI ID format: username@provider
                                  final upiPattern = RegExp(r'^[\w.-]+@[\w.-]+$');
                                  if (!upiPattern.hasMatch(value)) {
                                    return 'Please enter a valid UPI ID (e.g., name@upi)';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),

                              // Account Holder Name - OPTIONAL
                              TextFormField(
                                controller: _accountHolderController,
                                decoration: _inputDecoration(
                                  context: context,
                                  label: 'account_holder_name',
                                  prefix: Icons.person_outline,
                                ),
                                validator: (value) {
                                  // Only validate if user enters something
                                  if (value != null && value.isNotEmpty && value.length < 2) {
                                    return 'Account holder name must be at least 2 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),

                              // Bank Name - OPTIONAL
                              TextFormField(
                                controller: _bankNameController,
                                decoration: _inputDecoration(
                                  context: context,
                                  label: 'bank_name',
                                  prefix: Icons.account_balance,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Account Type - OPTIONAL
                              DropdownButtonFormField<String>(
                                value: _selectedAccountType,
                                decoration: _inputDecoration(
                                  context: context,
                                  label: 'account_type',
                                  prefix: Icons.account_box_outlined,
                                ),
                                items: const ['Checking', 'Savings']
                                    .map((String value) => DropdownMenuItem(
                                          value: value,
                                          child: Text(value),
                                        ))
                                    .toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedAccountType = newValue!;
                                  });
                                },
                              ),
                              const SizedBox(height: 12),

                              // Account Number - OPTIONAL
                              TextFormField(
                                controller: _accountNumberController,
                                keyboardType: TextInputType.number,
                                decoration: _inputDecoration(
                                  context: context,
                                  label: 'account_number',
                                  prefix: Icons.credit_card,
                                ).copyWith(
                                  helperText:
                                      'Enter the full account number without spaces',
                                ),
                                validator: (value) {
                                  // Only validate if user enters something
                                  if (value != null && value.isNotEmpty && value.length < 8) {
                                    return 'Account number must be at least 8 digits';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),

                              // IFSC Code - OPTIONAL
                              TextFormField(
                                controller: _ifscCodeController,
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: _inputDecoration(
                                  context: context,
                                  label: 'IFSC Code',
                                  prefix: Icons.code,
                                ),
                                validator: (value) {
                                  // Only validate if user enters something
                                  if (value != null && value.isNotEmpty) {
                                    if (value.length != 11) {
                                      return 'IFSC code must be 11 characters';
                                    }
                                    final ifscPattern =
                                        RegExp(r'^[A-Z]{4}[0][A-Z0-9]{6}$');
                                    if (!ifscPattern.hasMatch(value.toUpperCase())) {
                                      return 'Please enter a valid IFSC code';
                                    }
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        const SizedBox(height: 12),

                        // Actions
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: redeemProvider.isSubmittingRedemption
                                    ? null
                                    : () => Navigator.of(context).pop(),
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  side: BorderSide(color: Colors.grey.shade400),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  foregroundColor: Colors.black87,
                                ),
                                child: const AppText(
                                  'cancel',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: redeemProvider.isSubmittingRedemption
                                    ? null
                                    : _submitRedemption,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _primary,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: redeemProvider.isSubmittingRedemption
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'Submitting...',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      )
                                    : const AppText(
                                        'save_details',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),

                        // Redemption History
                        if (redeemProvider.redemptionHistory.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: _radius16,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Icon(Icons.history, color: _primary),
                                    SizedBox(width: 10),
                                    Text(
                                      'Recent Redemptions',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                ...redeemProvider.redemptionHistory
                                    .take(3)
                                    .map((redemption) {
                                  final maskedAccount =
                                      redemption.accountNumber.length > 8
                                          ? '${redemption.accountNumber.substring(0, 4)}${'*' * (redemption.accountNumber.length - 8)}${redemption.accountNumber.substring(redemption.accountNumber.length - 4)}'
                                          : redemption.accountNumber;
                                  final statusColor =
                                      redemption.getStatusColor();
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Colors.grey.shade200),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '₹${redemption.amount.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 6),
                                              decoration: BoxDecoration(
                                                color:
                                                    statusColor.withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(24),
                                                border: Border.all(
                                                    color: statusColor),
                                              ),
                                              child: Text(
                                                redemption.getFormattedStatus(),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  color: statusColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '${redemption.bankName} • $maskedAccount',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Submitted: ${_formatDate(redemption.createdAt)}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}