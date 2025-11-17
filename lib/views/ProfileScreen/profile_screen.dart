// // import 'package:flutter/material.dart';
// // import 'package:posternova/providers/auth/login_provider.dart';
// // import 'package:posternova/views/AuthModule/auth_screen.dart';
// // import 'package:provider/provider.dart';

// // class ProfileScreen extends StatelessWidget {
// //   const ProfileScreen({Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Consumer<AuthProvider>(
// //       builder: (context, authProvider, child) {
// //         final user = authProvider.user;
// //         final userName = user?.user.name ?? 'Guest User';
// //         final userEmail = user?.user.mobile ?? 'Not available';

// //         return Container(
// //           decoration: const BoxDecoration(
// //             gradient: LinearGradient(
// //               begin: Alignment.topLeft,
// //               end: Alignment.bottomRight,
// //               colors: [Color(0xFF0A0E21), Color(0xFF1D1E33), Color(0xFF0A0E21)],
// //             ),
// //           ),
// //           child: SafeArea(
// //             child: SingleChildScrollView(
// //               child: Padding(
// //                 padding: const EdgeInsets.all(20.0),
// //                 child: Column(
// //                   children: [
// //                     const SizedBox(height: 20),

// //                     // Profile Picture
// //                     Stack(
// //                       children: [
// //                         Container(
// //                           padding: const EdgeInsets.all(4),
// //                           decoration: BoxDecoration(
// //                             shape: BoxShape.circle,
// //                             gradient: LinearGradient(
// //                               colors: [
// //                                 Colors.purple.shade400,
// //                                 Colors.blue.shade400,
// //                               ],
// //                             ),
// //                             boxShadow: [
// //                               BoxShadow(
// //                                 color: Colors.purple.withOpacity(0.5),
// //                                 blurRadius: 20,
// //                                 spreadRadius: 5,
// //                               ),
// //                             ],
// //                           ),
// //                           child: Container(
// //                             padding: const EdgeInsets.all(50),
// //                             decoration: const BoxDecoration(
// //                               color: Color(0xFF1D1E33),
// //                               shape: BoxShape.circle,
// //                             ),
// //                             child:
// //                                 user?.user.profileImage != null &&
// //                                     user!.user.profileImage!.isNotEmpty
// //                                 ? ClipOval(
// //                                     child: Image.network(
// //                                       user.user.profileImage!,
// //                                       width: 60,
// //                                       height: 60,
// //                                       fit: BoxFit.cover,
// //                                       errorBuilder:
// //                                           (context, error, stackTrace) {
// //                                             return const Icon(
// //                                               Icons.person,
// //                                               size: 60,
// //                                               color: Colors.white,
// //                                             );
// //                                           },
// //                                     ),
// //                                   )
// //                                 : const Icon(
// //                                     Icons.person,
// //                                     size: 60,
// //                                     color: Colors.white,
// //                                   ),
// //                           ),
// //                         ),
// //                         Positioned(
// //                           bottom: 0,
// //                           right: 0,
// //                           child: Container(
// //                             padding: const EdgeInsets.all(8),
// //                             decoration: BoxDecoration(
// //                               gradient: LinearGradient(
// //                                 colors: [
// //                                   Colors.purple.shade400,
// //                                   Colors.blue.shade400,
// //                                 ],
// //                               ),
// //                               shape: BoxShape.circle,
// //                               border: Border.all(
// //                                 color: const Color(0xFF0A0E21),
// //                                 width: 3,
// //                               ),
// //                             ),
// //                             child: const Icon(
// //                               Icons.edit,
// //                               color: Colors.white,
// //                               size: 20,
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),

// //                     const SizedBox(height: 20),

// //                     // Name and Email/Mobile
// //                     Text(
// //                       userName,
// //                       style: const TextStyle(
// //                         fontSize: 28,
// //                         fontWeight: FontWeight.bold,
// //                         color: Colors.white,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 5),
// //                     Text(
// //                       userEmail,
// //                       style: TextStyle(
// //                         fontSize: 14,
// //                         color: Colors.grey.shade400,
// //                       ),
// //                     ),

// //                     const SizedBox(height: 120),

// //                     // Menu Options
// //                     _buildMenuItem(
// //                       icon: Icons.settings_outlined,
// //                       title: 'Settings',
// //                       onTap: () {},
// //                     ),
// //                     _buildMenuItem(
// //                       icon: Icons.policy,
// //                       title: 'Privacy & Policy',
// //                       onTap: () {},
// //                     ),
// //                     _buildMenuItem(
// //                       icon: Icons.info_outline,
// //                       title: 'About',
// //                       onTap: () {},
// //                     ),
// //                     _buildMenuItem(
// //                       icon: Icons.logout,
// //                       title: 'Logout',
// //                       onTap: () => _handleLogout(context, authProvider),
// //                       isDestructive: true,
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   Future<void> _handleLogout(
// //     BuildContext context,
// //     AuthProvider authProvider,
// //   ) async {
// //     // Show confirmation dialog
// //     final shouldLogout = await showDialog<bool>(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           backgroundColor: const Color(0xFF1D1E33),
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(20),
// //             side: BorderSide(color: Colors.purple.withOpacity(0.3)),
// //           ),
// //           title: const Text('Logout', style: TextStyle(color: Colors.white)),
// //           content: const Text(
// //             'Are you sure you want to logout?',
// //             style: TextStyle(color: Colors.grey),
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () => Navigator.of(context).pop(false),
// //               child: Text(
// //                 'Cancel',
// //                 style: TextStyle(color: Colors.grey.shade400),
// //               ),
// //             ),
// //             TextButton(
// //               onPressed: () => Navigator.of(context).pop(true),
// //               style: TextButton.styleFrom(
// //                 backgroundColor: Colors.red.withOpacity(0.2),
// //               ),
// //               child: const Text('Logout', style: TextStyle(color: Colors.red)),
// //             ),
// //           ],
// //         );
// //       },
// //     );

// //     if (shouldLogout == true) {
// //       // Show loading indicator
// //       showDialog(
// //         context: context,
// //         barrierDismissible: false,
// //         builder: (BuildContext context) {
// //           return const Center(
// //             child: CircularProgressIndicator(
// //               valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
// //             ),
// //           );
// //         },
// //       );

// //       // Perform logout
// //       final success = await authProvider.logout();

// //       // Close loading dialog
// //       if (context.mounted) {
// //         Navigator.of(context).pop();
// //       }

// //       if (success) {
// //         // Navigate to login screen
// //         if (context.mounted) {
// //           Navigator.pushAndRemoveUntil(
// //             context,
// //             MaterialPageRoute(builder: (context) => const AuthScreen()),
// //             (Route<dynamic> route) => false,
// //           );
// //         }
// //       } else {
// //         // Show error message
// //         if (context.mounted) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(
// //               content: const Text('Failed to logout. Please try again.'),
// //               backgroundColor: Colors.red.shade400,
// //               behavior: SnackBarBehavior.floating,
// //             ),
// //           );
// //         }
// //       }
// //     }
// //   }

// //   Widget _buildMenuItem({
// //     required IconData icon,
// //     required String title,
// //     required VoidCallback onTap,
// //     String? badge,
// //     bool isDestructive = false,
// //   }) {
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 30),
// //       decoration: BoxDecoration(
// //         color: const Color(0xFF1D1E33),
// //         borderRadius: BorderRadius.circular(15),
// //         border: Border.all(
// //           color: isDestructive
// //               ? Colors.red.withOpacity(0.3)
// //               : Colors.purple.withOpacity(0.2),
// //         ),
// //       ),
// //       child: ListTile(
// //         onTap: onTap,
// //         leading: Container(
// //           padding: const EdgeInsets.all(8),
// //           decoration: BoxDecoration(
// //             color: isDestructive
// //                 ? Colors.red.withOpacity(0.2)
// //                 : Colors.purple.withOpacity(0.2),
// //             borderRadius: BorderRadius.circular(10),
// //           ),
// //           child: Icon(
// //             icon,
// //             color: isDestructive ? Colors.red.shade300 : Colors.purple.shade300,
// //             size: 24,
// //           ),
// //         ),
// //         title: Text(
// //           title,
// //           style: TextStyle(
// //             color: isDestructive ? Colors.red.shade300 : Colors.white,
// //             fontSize: 16,
// //             fontWeight: FontWeight.w500,
// //           ),
// //         ),
// //         trailing: Row(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             if (badge != null)
// //               Container(
// //                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //                 decoration: BoxDecoration(
// //                   gradient: LinearGradient(
// //                     colors: [Colors.purple.shade400, Colors.blue.shade400],
// //                   ),
// //                   borderRadius: BorderRadius.circular(8),
// //                 ),
// //                 child: Text(
// //                   badge,
// //                   style: const TextStyle(
// //                     color: Colors.white,
// //                     fontSize: 10,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //               ),
// //             const SizedBox(width: 8),
// //             Icon(
// //               Icons.arrow_forward_ios,
// //               color: Colors.grey.shade600,
// //               size: 16,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // import 'package:flutter/material.dart';
// // import 'package:posternova/providers/auth/login_provider.dart';
// // import 'package:posternova/views/AI/chat_ai.dart';
// // import 'package:posternova/views/AuthModule/auth_screen.dart';
// // import 'package:posternova/views/ProfileScreen/settings.dart';
// // import 'package:posternova/views/about/about_screen.dart';
// // import 'package:posternova/views/backgroundremover/background_remover.dart';
// // import 'package:posternova/views/deleteaccount/delete_account_screen.dart';
// // import 'package:posternova/views/invoices/create_invoice_screen.dart';
// // import 'package:posternova/views/referearn/referearn_screen.dart';
// // import 'package:provider/provider.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'dart:io';

// // class ProfileScreen extends StatelessWidget {
// //   const ProfileScreen({Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Consumer<AuthProvider>(
// //       builder: (context, authProvider, child) {
// //         final user = authProvider.user;
// //         final userName = user?.user.name ?? 'Guest User';
// //         final userEmail = user?.user.mobile ?? 'Not available';

// //         return Container(
// //           decoration: const BoxDecoration(
// //             gradient: LinearGradient(
// //               begin: Alignment.topLeft,
// //               end: Alignment.bottomRight,
// //               colors: [Color(0xFF0A0E21), Color(0xFF1D1E33), Color(0xFF0A0E21)],
// //             ),
// //           ),
// //           child: SafeArea(
// //             child: SingleChildScrollView(
// //               child: Padding(
// //                 padding: const EdgeInsets.all(20.0),
// //                 child: Column(
// //                   children: [
// //                     const SizedBox(height: 20),

// //                     // Profile Picture
// //                     Stack(
// //                       children: [
// //                         Container(
// //                           padding: const EdgeInsets.all(4),
// //                           decoration: BoxDecoration(
// //                             shape: BoxShape.circle,
// //                             gradient: LinearGradient(
// //                               colors: [
// //                                 Colors.purple.shade400,
// //                                 Colors.blue.shade400,
// //                               ],
// //                             ),
// //                             boxShadow: [
// //                               BoxShadow(
// //                                 color: Colors.purple.withOpacity(0.5),
// //                                 blurRadius: 20,
// //                                 spreadRadius: 5,
// //                               ),
// //                             ],
// //                           ),
// //                           child: Container(
// //                             padding: const EdgeInsets.all(50),
// //                             decoration: const BoxDecoration(
// //                               color: Color(0xFF1D1E33),
// //                               shape: BoxShape.circle,
// //                             ),
// //                             child: authProvider.isLoading
// //                                 ? const CircularProgressIndicator(
// //                                     valueColor: AlwaysStoppedAnimation<Color>(
// //                                       Colors.purple,
// //                                     ),
// //                                   )
// //                                 : user?.user.profileImage != null &&
// //                                       user!.user.profileImage!.isNotEmpty
// //                                 ? ClipOval(
// //                                     child: Image.network(
// //                                       user.user.profileImage!,
// //                                       width: 60,
// //                                       height: 60,
// //                                       fit: BoxFit.cover,
// //                                       errorBuilder:
// //                                           (context, error, stackTrace) {
// //                                             return const Icon(
// //                                               Icons.person,
// //                                               size: 60,
// //                                               color: Colors.white,
// //                                             );
// //                                           },
// //                                     ),
// //                                   )
// //                                 : const Icon(
// //                                     Icons.person,
// //                                     size: 60,
// //                                     color: Colors.white,
// //                                   ),
// //                           ),
// //                         ),
// //                         Positioned(
// //                           bottom: 0,
// //                           right: 0,
// //                           child: GestureDetector(
// //                             onTap: () =>
// //                                 _pickAndUploadImage(context, authProvider),
// //                             child: Container(
// //                               padding: const EdgeInsets.all(8),
// //                               decoration: BoxDecoration(
// //                                 gradient: LinearGradient(
// //                                   colors: [
// //                                     Colors.purple.shade400,
// //                                     Colors.blue.shade400,
// //                                   ],
// //                                 ),
// //                                 shape: BoxShape.circle,
// //                                 border: Border.all(
// //                                   color: const Color(0xFF0A0E21),
// //                                   width: 3,
// //                                 ),
// //                               ),
// //                               child: const Icon(
// //                                 Icons.edit,
// //                                 color: Colors.white,
// //                                 size: 20,
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),

// //                     const SizedBox(height: 20),

// //                     // Name and Email/Mobile
// //                     Text(
// //                       userName,
// //                       style: const TextStyle(
// //                         fontSize: 28,
// //                         fontWeight: FontWeight.bold,
// //                         color: Colors.white,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 5),
// //                     Text(
// //                       userEmail,
// //                       style: TextStyle(
// //                         fontSize: 14,
// //                         color: Colors.grey.shade400,
// //                       ),
// //                     ),

// //                     const SizedBox(height: 110),
// //                     // Menu Options
// //                     // _buildMenuItem(
// //                     //   icon: Icons.settings_outlined,
// //                     //   title: 'Settings',
// //                     //   onTap: () {},
// //                     // ),
// //                     _buildMenuItem(
// //                       icon: Icons.policy,
// //                       title: 'Privacy & Policy',
// //                       onTap: () {},
// //                     ),
// //                     _buildMenuItem(
// //                       icon: Icons.info_outline,
// //                       title: 'About',
// //                       onTap: () {
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder: (context) => AboutScreen(),
// //                           ),
// //                         );
// //                       },
// //                     ),
// //                     _buildMenuItem(
// //                       icon: Icons.request_page,
// //                       title: 'Invoice',
// //                       onTap: () {
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder: (context) => CreateInvoiceScreen(),
// //                           ),
// //                         );
// //                       },
// //                     ),

// //                     _buildMenuItem(
// //                       icon: Icons.chat_bubble_outline,
// //                       title: 'Chat with AI',
// //                       onTap: () {
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(builder: (context) => AiScreen()),
// //                         );
// //                       },
// //                     ),
// //                     _buildMenuItem(
// //                       icon: Icons.delete,
// //                       title: 'Delete Account',
// //                       onTap: () {
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder: (context) => DeleteAccountScreen(),
// //                           ),
// //                         );
// //                       },
// //                     ),
// //                     _buildMenuItem(
// //                       icon: Icons.redeem,
// //                       title: 'Refer Earn',
// //                       onTap: () {
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder: (context) => ReferEarnScreen(),
// //                           ),
// //                         );
// //                       },
// //                     ),

// //                     _buildMenuItem(
// //                       icon: Icons.crop,
// //                       title: 'Remove Background',
// //                       onTap: () {
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder: (context) => BackgroundRemoverScreen(),
// //                           ),
// //                         );
// //                       },
// //                     ),
// //                     _buildMenuItem(
// //                       icon: Icons.logout,
// //                       title: 'Logout',
// //                       onTap: () => _handleLogout(context, authProvider),
// //                       isDestructive: true,
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   Future<void> _pickAndUploadImage(
// //     BuildContext context,
// //     AuthProvider authProvider,
// //   ) async {
// //     final user = authProvider.user;

// //     if (user == null) {
// //       _showSnackBar(
// //         context,
// //         'User not found. Please login again.',
// //         isError: true,
// //       );
// //       return;
// //     }

// //     try {
// //       // Show image source selection dialog
// //       final ImageSource? source = await showDialog<ImageSource>(
// //         context: context,
// //         builder: (BuildContext context) {
// //           return AlertDialog(
// //             backgroundColor: const Color(0xFF1D1E33),
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(20),
// //               side: BorderSide(color: Colors.purple.withOpacity(0.3)),
// //             ),
// //             title: const Text(
// //               'Choose Image Source',
// //               style: TextStyle(color: Colors.white),
// //             ),
// //             content: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 ListTile(
// //                   leading: Container(
// //                     padding: const EdgeInsets.all(8),
// //                     decoration: BoxDecoration(
// //                       color: Colors.purple.withOpacity(0.2),
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                     child: const Icon(
// //                       Icons.photo_library,
// //                       color: Colors.purple,
// //                     ),
// //                   ),
// //                   title: const Text(
// //                     'Gallery',
// //                     style: TextStyle(color: Colors.white),
// //                   ),
// //                   onTap: () => Navigator.of(context).pop(ImageSource.gallery),
// //                 ),
// //                 const SizedBox(height: 10),
// //                 ListTile(
// //                   leading: Container(
// //                     padding: const EdgeInsets.all(8),
// //                     decoration: BoxDecoration(
// //                       color: Colors.purple.withOpacity(0.2),
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                     child: const Icon(Icons.camera_alt, color: Colors.purple),
// //                   ),
// //                   title: const Text(
// //                     'Camera',
// //                     style: TextStyle(color: Colors.white),
// //                   ),
// //                   onTap: () => Navigator.of(context).pop(ImageSource.camera),
// //                 ),
// //               ],
// //             ),
// //           );
// //         },
// //       );

// //       if (source == null) return;

// //       // Pick image
// //       final ImagePicker picker = ImagePicker();
// //       final XFile? image = await picker.pickImage(
// //         source: source,
// //         maxWidth: 1024,
// //         maxHeight: 1024,
// //         imageQuality: 85,
// //       );

// //       if (image == null) return;

// //       // Upload image
// //       final success = await authProvider.uploadProfileImage(
// //         user.user.id,
// //         image.path,
// //       );

// //       if (context.mounted) {
// //         if (success) {
// //           _showSnackBar(
// //             context,
// //             'Profile picture updated successfully!',
// //             isError: false,
// //           );
// //         } else {
// //           _showSnackBar(
// //             context,
// //             authProvider.error ?? 'Failed to update profile picture',
// //             isError: true,
// //           );
// //         }
// //       }
// //     } catch (e) {
// //       if (context.mounted) {
// //         _showSnackBar(context, 'Error picking image: $e', isError: true);
// //       }
// //     }
// //   }

// //   void _showSnackBar(
// //     BuildContext context,
// //     String message, {
// //     required bool isError,
// //   }) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Text(message),
// //         backgroundColor: isError ? Colors.red.shade400 : Colors.green.shade400,
// //         behavior: SnackBarBehavior.floating,
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
// //       ),
// //     );
// //   }

// //   Future<void> _handleLogout(
// //     BuildContext context,
// //     AuthProvider authProvider,
// //   ) async {
// //     // Show confirmation dialog
// //     final shouldLogout = await showDialog<bool>(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           backgroundColor: const Color(0xFF1D1E33),
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(20),
// //             side: BorderSide(color: Colors.purple.withOpacity(0.3)),
// //           ),
// //           title: const Text('Logout', style: TextStyle(color: Colors.white)),
// //           content: const Text(
// //             'Are you sure you want to logout?',
// //             style: TextStyle(color: Colors.grey),
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () => Navigator.of(context).pop(false),
// //               child: Text(
// //                 'Cancel',
// //                 style: TextStyle(color: Colors.grey.shade400),
// //               ),
// //             ),
// //             TextButton(
// //               onPressed: () => Navigator.of(context).pop(true),
// //               style: TextButton.styleFrom(
// //                 backgroundColor: Colors.red.withOpacity(0.2),
// //               ),
// //               child: const Text('Logout', style: TextStyle(color: Colors.red)),
// //             ),
// //           ],
// //         );
// //       },
// //     );

// //     if (shouldLogout == true) {
// //       // Show loading indicator
// //       showDialog(
// //         context: context,
// //         barrierDismissible: false,
// //         builder: (BuildContext context) {
// //           return const Center(
// //             child: CircularProgressIndicator(
// //               valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
// //             ),
// //           );
// //         },
// //       );

// //       // Perform logout
// //       final success = await authProvider.logout();

// //       // Close loading dialog
// //       if (context.mounted) {
// //         Navigator.of(context).pop();
// //       }

// //       if (success) {
// //         // Navigate to login screen
// //         if (context.mounted) {
// //           Navigator.pushAndRemoveUntil(
// //             context,
// //             MaterialPageRoute(builder: (context) => const AuthScreen()),
// //             (Route<dynamic> route) => false,
// //           );
// //         }
// //       } else {
// //         // Show error message
// //         if (context.mounted) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(
// //               content: const Text('Failed to logout. Please try again.'),
// //               backgroundColor: Colors.red.shade400,
// //               behavior: SnackBarBehavior.floating,
// //             ),
// //           );
// //         }
// //       }
// //     }
// //   }

// //   Widget _buildMenuItem({
// //     required IconData icon,
// //     required String title,
// //     required VoidCallback onTap,
// //     String? badge,
// //     bool isDestructive = false,
// //   }) {
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 30),
// //       decoration: BoxDecoration(
// //         color: const Color(0xFF1D1E33),
// //         borderRadius: BorderRadius.circular(15),
// //         border: Border.all(
// //           color: isDestructive
// //               ? Colors.red.withOpacity(0.3)
// //               : Colors.purple.withOpacity(0.2),
// //         ),
// //       ),
// //       child: ListTile(
// //         onTap: onTap,
// //         leading: Container(
// //           padding: const EdgeInsets.all(8),
// //           decoration: BoxDecoration(
// //             color: isDestructive
// //                 ? Colors.red.withOpacity(0.2)
// //                 : Colors.purple.withOpacity(0.2),
// //             borderRadius: BorderRadius.circular(10),
// //           ),
// //           child: Icon(
// //             icon,
// //             color: isDestructive ? Colors.red.shade300 : Colors.purple.shade300,
// //             size: 24,
// //           ),
// //         ),
// //         title: Text(
// //           title,
// //           style: TextStyle(
// //             color: isDestructive ? Colors.red.shade300 : Colors.white,
// //             fontSize: 16,
// //             fontWeight: FontWeight.w500,
// //           ),
// //         ),
// //         trailing: Row(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             if (badge != null)
// //               Container(
// //                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //                 decoration: BoxDecoration(
// //                   gradient: LinearGradient(
// //                     colors: [Colors.purple.shade400, Colors.blue.shade400],
// //                   ),
// //                   borderRadius: BorderRadius.circular(8),
// //                 ),
// //                 child: Text(
// //                   badge,
// //                   style: const TextStyle(
// //                     color: Colors.white,
// //                     fontSize: 10,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //               ),
// //             const SizedBox(width: 8),
// //             Icon(
// //               Icons.arrow_forward_ios,
// //               color: Colors.grey.shade600,
// //               size: 16,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:posternova/helper/sub_modal_helper.dart';
// import 'package:posternova/providers/auth/login_provider.dart';
// import 'package:posternova/providers/plans/get_all_plan_provider.dart';
// import 'package:posternova/providers/plans/my_plan_provider.dart';
// import 'package:posternova/views/AI/chat_ai.dart';
// import 'package:posternova/views/AuthModule/auth_screen.dart';
// import 'package:posternova/views/ProfileScreen/settings.dart';
// import 'package:posternova/views/about/about_screen.dart';
// import 'package:posternova/views/backgroundremover/background_remover.dart';
// import 'package:posternova/views/deleteaccount/delete_account_screen.dart';
// import 'package:posternova/views/invoices/create_invoice_screen.dart';
// import 'package:posternova/views/referearn/referearn_screen.dart';
// import 'package:posternova/views/subscription/payment_success_screen.dart';
// import 'package:posternova/views/subscription/plan_detail_screen.dart';
// import 'package:posternova/widgets/common_modal.dart';
// import 'package:provider/provider.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AuthProvider>(
//       builder: (context, authProvider, child) {
//         final user = authProvider.user;
//         final userName = user?.user.name ?? 'Guest User';
//         final userEmail = user?.user.mobile ?? 'Not available';

//         return Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [Color(0xFF0A0E21), Color(0xFF1D1E33), Color(0xFF0A0E21)],
//             ),
//           ),
//           child: SafeArea(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 20),

//                     // Profile Picture
//                     Stack(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(4),
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             gradient: LinearGradient(
//                               colors: [
//                                 Colors.purple.shade400,
//                                 Colors.blue.shade400,
//                               ],
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.purple.withOpacity(0.5),
//                                 blurRadius: 20,
//                                 spreadRadius: 5,
//                               ),
//                             ],
//                           ),
//                           child: Container(
//                             padding: const EdgeInsets.all(50),
//                             decoration: const BoxDecoration(
//                               color: Color(0xFF1D1E33),
//                               shape: BoxShape.circle,
//                             ),
//                             child: authProvider.isLoading
//                                 ? const CircularProgressIndicator(
//                                     valueColor: AlwaysStoppedAnimation<Color>(
//                                       Colors.purple,
//                                     ),
//                                   )
//                                 : user?.user.profileImage != null &&
//                                       user!.user.profileImage!.isNotEmpty
//                                 ? ClipOval(
//                                     child: Image.network(
//                                       user.user.profileImage!,
//                                       width: 60,
//                                       height: 60,
//                                       fit: BoxFit.cover,
//                                       errorBuilder:
//                                           (context, error, stackTrace) {
//                                             return const Icon(
//                                               Icons.person,
//                                               size: 60,
//                                               color: Colors.white,
//                                             );
//                                           },
//                                     ),
//                                   )
//                                 : const Icon(
//                                     Icons.person,
//                                     size: 60,
//                                     color: Colors.white,
//                                   ),
//                           ),
//                         ),
//                         Positioned(
//                           bottom: 0,
//                           right: 0,
//                           child: GestureDetector(
//                             onTap: () =>
//                                 _pickAndUploadImage(context, authProvider),
//                             child: Container(
//                               padding: const EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     Colors.purple.shade400,
//                                     Colors.blue.shade400,
//                                   ],
//                                 ),
//                                 shape: BoxShape.circle,
//                                 border: Border.all(
//                                   color: const Color(0xFF0A0E21),
//                                   width: 3,
//                                 ),
//                               ),
//                               child: const Icon(
//                                 Icons.edit,
//                                 color: Colors.white,
//                                 size: 20,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 20),

//                     // Name and Email/Mobile
//                     Text(
//                       userName,
//                       style: const TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     Text(
//                       userEmail,
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey.shade400,
//                       ),
//                     ),

//                     const SizedBox(height: 110),

//                     // Menu Options with Plan Check
//                     Consumer<MyPlanProvider>(
//                       builder: (context, myPlanProvider, child) {
//                         return Column(
//                           children: [
//                             _buildMenuItem(
//                               icon: Icons.policy,
//                               title: 'Privacy & Policy',
//                               onTap: () {},
//                               isPremiumRequired: false,
//                               isPurchased: myPlanProvider.isPurchase ?? false,
//                             ),
//                             _buildMenuItem(
//                               icon: Icons.info_outline,
//                               title: 'About',
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => AboutScreen(),
//                                   ),
//                                 );
//                               },
//                               isPremiumRequired: false,
//                               isPurchased: myPlanProvider.isPurchase ?? false,
//                             ),
//                             _buildMenuItem(
//                               icon: Icons.request_page,
//                               title: 'Invoice',
//                               onTap: () {
//                                 if (myPlanProvider.isPurchase == true) {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => CreateInvoiceScreen(),
//                                     ),
//                                   );
//                                 } else {
//                                   _showPremiumRequiredDialog(context);
//                                 }
//                               },
//                               isPremiumRequired: true,
//                               isPurchased: myPlanProvider.isPurchase ?? false,
//                             ),
//                             _buildMenuItem(
//                               icon: Icons.chat_bubble_outline,
//                               title: 'Chat with AI',
//                               onTap: () {
//                                 if (myPlanProvider.isPurchase == true) {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(builder: (context) => AiScreen()),
//                                   );
//                                 } else {
//                                   _showPremiumRequiredDialog(context);
//                                 }
//                               },
//                               isPremiumRequired: true,
//                               isPurchased: myPlanProvider.isPurchase ?? false,
//                             ),
//                             _buildMenuItem(
//                               icon: Icons.delete,
//                               title: 'Delete Account',
//                               onTap: () {
//                                 if (myPlanProvider.isPurchase == true) {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => DeleteAccountScreen(),
//                                     ),
//                                   );
//                                 } else {
//                                   _showPremiumRequiredDialog(context);
//                                 }
//                               },
//                               isPremiumRequired: true,
//                               isPurchased: myPlanProvider.isPurchase ?? false,
//                             ),
//                             _buildMenuItem(
//                               icon: Icons.redeem,
//                               title: 'Refer Earn',
//                               onTap: () {
//                                 if (myPlanProvider.isPurchase == true) {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => ReferEarnScreen(),
//                                     ),
//                                   );
//                                 } else {
//                                   _showPremiumRequiredDialog(context);
//                                 }
//                               },
//                               isPremiumRequired: true,
//                               isPurchased: myPlanProvider.isPurchase ?? false,
//                             ),
//                             _buildMenuItem(
//                               icon: Icons.crop,
//                               title: 'Remove Background',
//                               onTap: () {
//                                 if (myPlanProvider.isPurchase == true) {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => BackgroundRemoverScreen(),
//                                     ),
//                                   );
//                                 } else {
//                                   _showPremiumRequiredDialog(context);
//                                 }
//                               },
//                               isPremiumRequired: true,
//                               isPurchased: myPlanProvider.isPurchase ?? false,
//                             ),
//                             _buildMenuItem(
//                               icon: Icons.logout,
//                               title: 'Logout',
//                               onTap: () => _handleLogout(context, authProvider),
//                               isDestructive: true,
//                               isPremiumRequired: false,
//                               isPurchased: myPlanProvider.isPurchase ?? false,
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _showPremiumRequiredDialog(BuildContext context) {
//     CommonModal.showWarning(
//       context: context,
//       title: "Premium Feature",
//       message:
//           "This feature is available for premium users only. Upgrade your plan to access this and many more exclusive features.",
//       primaryButtonText: "Upgrade Now",
//       secondaryButtonText: "Cancel",
//       onPrimaryPressed: () {
//         showSubscriptionModal(context);
//         // Add navigation to subscription/plan screen here
//         // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => SubscriptionScreen()));
//       },
//       onSecondaryPressed: () => Navigator.of(context).pop(),
//     );
//   }

//   void showSubscriptionModal(BuildContext context) async {
//     final myPlanProvider = Provider.of<MyPlanProvider>(context, listen: false);

//     if (myPlanProvider.isPurchase == true) {
//       return;
//     }

//     final hasShownRecently = await ModalPreferences.hasShownSubscriptionModal();
//     final shouldShowAgain =
//         await ModalPreferences.shouldShowSubscriptionModalAgain(daysBetween: 7);

//     if (hasShownRecently && !shouldShowAgain) {
//       print('Subscription modal shown recently, skipping');
//       return;
//     }

//     final planProvider = Provider.of<GetAllPlanProvider>(
//       context,
//       listen: false,
//     );
//     if (planProvider.plans.isEmpty && !planProvider.isLoading) {
//       planProvider.fetchAllPlans();
//     }

//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (context) => Dialog(
//         backgroundColor: Colors.transparent,
//         child: Container(
//           constraints: const BoxConstraints(maxWidth: 400),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(24),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.15),
//                 blurRadius: 30,
//                 offset: const Offset(0, 10),
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Header Section
//               Container(
//                 padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
//                 child: Column(
//                   children: [
//                     // Close Button
//                     Align(
//                       alignment: Alignment.topRight,
//                       child: GestureDetector(
//                         onTap: () => Navigator.pop(context),
//                         child: Container(
//                           padding: const EdgeInsets.all(6),
//                           decoration: BoxDecoration(
//                             color: Colors.grey.shade100,
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(
//                             Icons.close,
//                             size: 18,
//                             color: Colors.grey.shade600,
//                           ),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 8),

//                     // Premium Icon
//                     Container(
//                       width: 70,
//                       height: 70,
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                           colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
//                         ),
//                         borderRadius: BorderRadius.circular(18),
//                         boxShadow: [
//                           BoxShadow(
//                             color: const Color(0xFFFFA500).withOpacity(0.3),
//                             blurRadius: 15,
//                             offset: const Offset(0, 6),
//                           ),
//                         ],
//                       ),
//                       child: const Icon(
//                         Icons.workspace_premium_rounded,
//                         color: Colors.white,
//                         size: 36,
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     // Title
//                     const Text(
//                       'Unlock Premium',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF1F2937),
//                         letterSpacing: -0.5,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),

//                     const SizedBox(height: 6),

//                     // Subtitle
//                     Text(
//                       'Get unlimited access to all features',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey.shade600,
//                         height: 1.3,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),

//               // Features List
//               // Container(
//               //   margin: const EdgeInsets.symmetric(horizontal: 20),
//               //   padding: const EdgeInsets.all(16),
//               //   decoration: BoxDecoration(
//               //     color: const Color(0xFFF8FAFC),
//               //     borderRadius: BorderRadius.circular(14),
//               //     border: Border.all(color: Colors.grey.shade200),
//               //   ),
//               //   child: Column(
//               //     children: [
//               //       // _buildCompactFeature('Unlimited Templates'),
//               //       // const SizedBox(height: 12),
//               //       // _buildCompactFeature('No Watermarks'),
//               //       // const SizedBox(height: 12),
//               //       // _buildCompactFeature('Priority Support'),
//               //       // const SizedBox(height: 12),
//               //       // _buildCompactFeature('Regular Updates'),
//               //     ],
//               //   ),
//               // ),
//               const SizedBox(height: 20),

//               // Plans Section
//               Container(
//                 constraints: const BoxConstraints(maxHeight: 280),
//                 child: Consumer<GetAllPlanProvider>(
//                   builder: (context, provider, child) {
//                     if (provider.isLoading) {
//                       return const Padding(
//                         padding: EdgeInsets.all(40.0),
//                         child: Center(
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               CircularProgressIndicator(
//                                 color: Color(0xFF6366F1),
//                                 strokeWidth: 3,
//                               ),
//                               SizedBox(height: 12),
//                               Text(
//                                 'Loading plans...',
//                                 style: TextStyle(
//                                   color: Color(0xFF6B7280),
//                                   fontSize: 13,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     }

//                     if (provider.error != null) {
//                       return Padding(
//                         padding: const EdgeInsets.all(24.0),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(
//                               Icons.error_outline_rounded,
//                               color: Colors.red.shade400,
//                               size: 48,
//                             ),
//                             const SizedBox(height: 12),
//                             const Text(
//                               'Unable to Load Plans',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xFF1F2937),
//                               ),
//                             ),
//                             const SizedBox(height: 6),
//                             Text(
//                               'Please try again',
//                               style: TextStyle(
//                                 color: Colors.grey.shade600,
//                                 fontSize: 13,
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             ElevatedButton.icon(
//                               onPressed: () => provider.fetchAllPlans(),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: const Color(0xFF6366F1),
//                                 foregroundColor: Colors.white,
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 20,
//                                   vertical: 12,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 elevation: 0,
//                               ),
//                               icon: const Icon(Icons.refresh_rounded, size: 18),
//                               label: const Text(
//                                 'Try Again',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }

//                     if (provider.plans.isNotEmpty) {
//                       return SingleChildScrollView(
//                         padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
//                         child: AnimatedPlanList(
//                           plans: provider.plans,
//                           onPlanSelected: (plan) {
//                             Navigator.of(context).pop();
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     PlanDetailsAndPaymentScreen(plan: plan),
//                               ),
//                             );
//                           },
//                         ),
//                       );
//                     }

//                     return Padding(
//                       padding: const EdgeInsets.all(24.0),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             Icons.shopping_bag_outlined,
//                             size: 48,
//                             color: Colors.grey.shade400,
//                           ),
//                           const SizedBox(height: 12),
//                           Text(
//                             'No Plans Available',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.grey.shade700,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             'Please check back later',
//                             style: TextStyle(
//                               color: Colors.grey.shade500,
//                               fontSize: 13,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _pickAndUploadImage(
//     BuildContext context,
//     AuthProvider authProvider,
//   ) async {
//     final user = authProvider.user;

//     if (user == null) {
//       _showSnackBar(
//         context,
//         'User not found. Please login again.',
//         isError: true,
//       );
//       return;
//     }

//     try {
//       // Show image source selection dialog
//       final ImageSource? source = await showDialog<ImageSource>(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             backgroundColor: const Color(0xFF1D1E33),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//               side: BorderSide(color: Colors.purple.withOpacity(0.3)),
//             ),
//             title: const Text(
//               'Choose Image Source',
//               style: TextStyle(color: Colors.white),
//             ),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 ListTile(
//                   leading: Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: Colors.purple.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: const Icon(
//                       Icons.photo_library,
//                       color: Colors.purple,
//                     ),
//                   ),
//                   title: const Text(
//                     'Gallery',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   onTap: () => Navigator.of(context).pop(ImageSource.gallery),
//                 ),
//                 const SizedBox(height: 10),
//                 ListTile(
//                   leading: Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: Colors.purple.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: const Icon(Icons.camera_alt, color: Colors.purple),
//                   ),
//                   title: const Text(
//                     'Camera',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   onTap: () => Navigator.of(context).pop(ImageSource.camera),
//                 ),
//               ],
//             ),
//           );
//         },
//       );

//       if (source == null) return;

//       // Pick image
//       final ImagePicker picker = ImagePicker();
//       final XFile? image = await picker.pickImage(
//         source: source,
//         maxWidth: 1024,
//         maxHeight: 1024,
//         imageQuality: 85,
//       );

//       if (image == null) return;

//       // Upload image
//       final success = await authProvider.uploadProfileImage(
//         user.user.id,
//         image.path,
//       );

//       if (context.mounted) {
//         if (success) {
//           _showSnackBar(
//             context,
//             'Profile picture updated successfully!',
//             isError: false,
//           );
//         } else {
//           _showSnackBar(
//             context,
//             authProvider.error ?? 'Failed to update profile picture',
//             isError: true,
//           );
//         }
//       }
//     } catch (e) {
//       if (context.mounted) {
//         _showSnackBar(context, 'Error picking image: $e', isError: true);
//       }
//     }
//   }

//   void _showSnackBar(
//     BuildContext context,
//     String message, {
//     required bool isError,
//   }) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: isError ? Colors.red.shade400 : Colors.green.shade400,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//     );
//   }

//   Future<void> _handleLogout(
//     BuildContext context,
//     AuthProvider authProvider,
//   ) async {
//     // Show confirmation dialog
//     final shouldLogout = await showDialog<bool>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: const Color(0xFF1D1E33),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//             side: BorderSide(color: Colors.purple.withOpacity(0.3)),
//           ),
//           title: const Text('Logout', style: TextStyle(color: Colors.white)),
//           content: const Text(
//             'Are you sure you want to logout?',
//             style: TextStyle(color: Colors.grey),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(false),
//               child: Text(
//                 'Cancel',
//                 style: TextStyle(color: Colors.grey.shade400),
//               ),
//             ),
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(true),
//               style: TextButton.styleFrom(
//                 backgroundColor: Colors.red.withOpacity(0.2),
//               ),
//               child: const Text('Logout', style: TextStyle(color: Colors.red)),
//             ),
//           ],
//         );
//       },
//     );

//     if (shouldLogout == true) {
//       // Show loading indicator
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return const Center(
//             child: CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
//             ),
//           );
//         },
//       );

//       // Perform logout
//       final success = await authProvider.logout();

//       // Close loading dialog
//       if (context.mounted) {
//         Navigator.of(context).pop();
//       }

//       if (success) {
//         // Navigate to login screen
//         if (context.mounted) {
//           Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(builder: (context) => const AuthScreen()),
//             (Route<dynamic> route) => false,
//           );
//         }
//       } else {
//         // Show error message
//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: const Text('Failed to logout. Please try again.'),
//               backgroundColor: Colors.red.shade400,
//               behavior: SnackBarBehavior.floating,
//             ),
//           );
//         }
//       }
//     }
//   }

//   Widget _buildMenuItem({
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//     String? badge,
//     bool isDestructive = false,
//     bool isPremiumRequired = false,
//     bool isPurchased = false,
//   }) {
//     final bool isLocked = isPremiumRequired && !isPurchased;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 30),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1D1E33),
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(
//           color: isDestructive
//               ? Colors.red.withOpacity(0.3)
//               : isLocked
//                   ? Colors.amber.withOpacity(0.3)
//                   : Colors.purple.withOpacity(0.2),
//         ),
//       ),
//       child: ListTile(
//         onTap: onTap,
//         leading: Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: isDestructive
//                 ? Colors.red.withOpacity(0.2)
//                 : isLocked
//                     ? Colors.amber.withOpacity(0.2)
//                     : Colors.purple.withOpacity(0.2),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Icon(
//             icon,
//             color: isDestructive
//                 ? Colors.red.shade300
//                 : isLocked
//                     ? Colors.amber.shade300
//                     : Colors.purple.shade300,
//             size: 24,
//           ),
//         ),
//         title: Text(
//           title,
//           style: TextStyle(
//             color: isDestructive
//                 ? Colors.red.shade300
//                 : isLocked
//                     ? Colors.grey.shade400
//                     : Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             if (isLocked)
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.amber.shade400, Colors.orange.shade400],
//                   ),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   children: const [
//                     Icon(
//                       Icons.lock,
//                       color: Colors.white,
//                       size: 12,
//                     ),
//                     SizedBox(width: 4),
//                     Text(
//                       'Premium',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 10,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             if (badge != null && !isLocked)
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.purple.shade400, Colors.blue.shade400],
//                   ),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   badge,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 10,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             const SizedBox(width: 8),
//             Icon(
//               Icons.arrow_forward_ios,
//               color: Colors.grey.shade600,
//               size: 16,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:posternova/helper/sub_modal_helper.dart';
import 'package:posternova/providers/auth/login_provider.dart';
import 'package:posternova/providers/plans/get_all_plan_provider.dart';
import 'package:posternova/providers/plans/my_plan_provider.dart';
import 'package:posternova/views/AI/chat_ai.dart';
import 'package:posternova/views/AuthModule/auth_screen.dart';
import 'package:posternova/views/ProfileScreen/edit_profile.dart';
import 'package:posternova/views/about/about_screen.dart';
import 'package:posternova/views/backgroundremover/background_remover.dart';
import 'package:posternova/views/deleteaccount/delete_account_screen.dart';
import 'package:posternova/views/invoices/create_invoice_screen.dart';
import 'package:posternova/views/modes/dark_light_mode_screen.dart';
import 'package:posternova/views/referearn/referearn_screen.dart';
import 'package:posternova/views/subscription/payment_success_screen.dart';
import 'package:posternova/views/subscription/plan_detail_screen.dart';
import 'package:posternova/widgets/common_modal.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;
        final userName = user?.user.name ?? 'Guest User';
        final userEmail = user?.user.mobile ?? 'Not available';

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0A0E21),
                  Color(0xFF1D1E33),
                  Color(0xFF0A0E21),
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Profile Picture
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.purple.shade400,
                                  Colors.blue.shade400,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.purple.withOpacity(0.5),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: authProvider.isLoading
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.purple,
                                    ),
                                  )
                                : user?.user.profileImage != null &&
                                      user!.user.profileImage!.isNotEmpty
                                ? ClipOval(
                                    child: Image.network(
                                      user.user.profileImage!,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return const Icon(
                                              Icons.person,
                                              size: 60,
                                              color: Colors.white,
                                            );
                                          },
                                    ),
                                  )
                                : const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.white,
                                  ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () =>
                                  _pickAndUploadImage(context, authProvider),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.purple.shade400,
                                      Colors.blue.shade400,
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF0A0E21),
                                    width: 3,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Name and Email/Mobile
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        userEmail,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade400,
                        ),
                      ),

                      const SizedBox(height: 110),

                      // Menu Options with Plan Check
                      Consumer<MyPlanProvider>(
                        builder: (context, myPlanProvider, child) {
                          return Column(
                            children: [
                              _buildMenuItem(
                                icon: Icons.policy,
                                title: 'Privacy & Policy',
                                onTap: () {},
                                isPremiumRequired: false,
                                isPurchased: myPlanProvider.isPurchase ?? false,
                              ),

                              _buildMenuItem(
                                icon: Icons.person,
                                title: 'Settings',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProfile(),
                                    ),
                                  );
                                },
                                isPremiumRequired: false,
                                isPurchased: myPlanProvider.isPurchase ?? false,
                              ),
                              _buildMenuItem(
                                icon: Icons.info_outline,
                                title: 'About',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AboutScreen(),
                                    ),
                                  );
                                },
                                isPremiumRequired: false,
                                isPurchased: myPlanProvider.isPurchase ?? false,
                              ),
                              //  _buildMenuItem(
                              //   icon: Icons.light_mode,
                              //   title: 'Modes',
                              //   onTap: () {
                              //     if(myPlanProvider.isPurchase==true){
                              //          Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //         builder: (context) => ThemeSettingsScreen(),
                              //       ),
                              //     );
                              //     }

                              //   },
                              //   // isPremiumRequired: false,
                              //   // isPurchased: myPlanProvider.isPurchase ?? false,
                              // ),
                              _buildMenuItem(
                                icon: Icons.request_page,
                                title: 'Invoice',
                                onTap: () {
                                  if (myPlanProvider.isPurchase == true) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CreateInvoiceScreen(),
                                      ),
                                    );
                                  } else {
                                    _showPremiumRequiredDialog(context);
                                  }
                                },
                                isPremiumRequired: true,
                                isPurchased: myPlanProvider.isPurchase ?? false,
                              ),
                              _buildMenuItem(
                                icon: Icons.chat_bubble_outline,
                                title: 'Chicha AI',
                                onTap: () {
                                  if (myPlanProvider.isPurchase == true) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AiScreen(),
                                      ),
                                    );
                                  } else {
                                    _showPremiumRequiredDialog(context);
                                  }
                                },
                                isPremiumRequired: true,
                                isPurchased: myPlanProvider.isPurchase ?? false,
                              ),
                              _buildMenuItem(
                                icon: Icons.delete,
                                title: 'Delete Account',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DeleteAccountScreen(),
                                    ),
                                  );
                                },
                              ),
                              _buildMenuItem(
                                icon: Icons.redeem,
                                title: 'Refer Earn',
                                onTap: () {
                                  if (myPlanProvider.isPurchase == true) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ReferEarnScreen(),
                                      ),
                                    );
                                  } else {
                                    _showPremiumRequiredDialog(context);
                                  }
                                },
                                isPremiumRequired: true,
                                isPurchased: myPlanProvider.isPurchase ?? false,
                              ),
                              _buildMenuItem(
                                icon: Icons.crop,
                                title: 'Remove Background',
                                onTap: () {
                                  if (myPlanProvider.isPurchase == true) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BackgroundRemoverScreen(),
                                      ),
                                    );
                                  } else {
                                    _showPremiumRequiredDialog(context);
                                  }
                                },
                                isPremiumRequired: true,
                                isPurchased: myPlanProvider.isPurchase ?? false,
                              ),
                              _buildMenuItem(
                                icon: Icons.logout,
                                title: 'Logout',
                                onTap: () =>
                                    _handleLogout(context, authProvider),
                                isDestructive: true,
                                isPremiumRequired: false,
                                isPurchased: myPlanProvider.isPurchase ?? false,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showPremiumRequiredDialog(BuildContext context) {
    CommonModal.showWarning(
      context: context,
      title: "Premium Feature",
      message:
          "This feature is available for premium users only. Upgrade your plan to access this and many more exclusive features.",
      primaryButtonText: "Upgrade Now",
      secondaryButtonText: "Cancel",
      onPrimaryPressed: () {
        showSubscriptionModal(context);
      },
      onSecondaryPressed: () => Navigator.of(context).pop(),
    );
  }

  void showSubscriptionModal(BuildContext context) async {
    final myPlanProvider = Provider.of<MyPlanProvider>(context, listen: false);

    if (myPlanProvider.isPurchase == true) {
      return;
    }

    final hasShownRecently = await ModalPreferences.hasShownSubscriptionModal();
    final shouldShowAgain =
        await ModalPreferences.shouldShowSubscriptionModalAgain(daysBetween: 7);

    if (hasShownRecently && !shouldShowAgain) {
      print('Subscription modal shown recently, skipping');
      return;
    }

    final planProvider = Provider.of<GetAllPlanProvider>(
      context,
      listen: false,
    );
    if (planProvider.plans.isEmpty && !planProvider.isLoading) {
      planProvider.fetchAllPlans();
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                child: Column(
                  children: [
                    // Close Button
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            size: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Premium Icon
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFA500).withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.workspace_premium_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Title
                    const Text(
                      'Unlock Premium',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 6),

                    // Subtitle
                    Text(
                      'Get unlimited access to all features',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Plans Section
              Container(
                constraints: const BoxConstraints(maxHeight: 280),
                child: Consumer<GetAllPlanProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                color: Color(0xFF6366F1),
                                strokeWidth: 3,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Loading plans...',
                                style: TextStyle(
                                  color: Color(0xFF6B7280),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (provider.error != null) {
                      return Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              color: Colors.red.shade400,
                              size: 48,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Unable to Load Plans',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Please try again',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () => provider.fetchAllPlans(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6366F1),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                              ),
                              icon: const Icon(Icons.refresh_rounded, size: 18),
                              label: const Text(
                                'Try Again',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (provider.plans.isNotEmpty) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: AnimatedPlanList(
                          plans: provider.plans,
                          onPlanSelected: (plan) {
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PlanDetailsAndPaymentScreen(plan: plan),
                              ),
                            );
                          },
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No Plans Available',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Please check back later',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 13,
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
      ),
    );
  }

  Future<void> _pickAndUploadImage(
    BuildContext context,
    AuthProvider authProvider,
  ) async {
    final user = authProvider.user;

    if (user == null) {
      _showSnackBar(
        context,
        'User not found. Please login again.',
        isError: true,
      );
      return;
    }

    try {
      // Show image source selection dialog
      final ImageSource? source = await showDialog<ImageSource>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF1D1E33),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.purple.withOpacity(0.3)),
            ),
            title: const Text(
              'Choose Image Source',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.photo_library,
                      color: Colors.purple,
                    ),
                  ),
                  title: const Text(
                    'Gallery',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () => Navigator.of(context).pop(ImageSource.gallery),
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.purple),
                  ),
                  title: const Text(
                    'Camera',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () => Navigator.of(context).pop(ImageSource.camera),
                ),
              ],
            ),
          );
        },
      );

      if (source == null) return;

      // Pick image
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image == null) return;

      // Upload image
      final success = await authProvider.uploadProfileImage(
        user.user.id,
        image.path,
      );

      if (context.mounted) {
        if (success) {
          _showSnackBar(
            context,
            'Profile picture updated successfully!',
            isError: false,
          );
        } else {
          _showSnackBar(
            context,
            authProvider.error ?? 'Failed to update profile picture',
            isError: true,
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showSnackBar(context, 'Error picking image: $e', isError: true);
      }
    }
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    required bool isError,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade400 : Colors.green.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _handleLogout(
    BuildContext context,
    AuthProvider authProvider,
  ) async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1D1E33),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.purple.withOpacity(0.3)),
          ),
          title: const Text('Logout', style: TextStyle(color: Colors.white)),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Colors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey.shade400),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red.withOpacity(0.2),
              ),
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
            ),
          );
        },
      );

      // Perform logout
      final success = await authProvider.logout();

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (success) {
        // Navigate to login screen
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AuthScreen()),
            (Route<dynamic> route) => false,
          );
        }
      } else {
        // Show error message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Failed to logout. Please try again.'),
              backgroundColor: Colors.red.shade400,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? badge,
    bool isDestructive = false,
    bool isPremiumRequired = false,
    bool isPurchased = false,
  }) {
    final bool isLocked = isPremiumRequired && !isPurchased;

    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1E33),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isDestructive
              ? Colors.red.withOpacity(0.3)
              : isLocked
              ? Colors.amber.withOpacity(0.3)
              : Colors.purple.withOpacity(0.2),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          onTap: onTap,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDestructive
                  ? Colors.red.withOpacity(0.2)
                  : isLocked
                  ? Colors.amber.withOpacity(0.2)
                  : Colors.purple.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: isDestructive
                  ? Colors.red.shade300
                  : isLocked
                  ? Colors.amber.shade300
                  : Colors.purple.shade300,
              size: 24,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: isDestructive
                  ? Colors.red.shade300
                  : isLocked
                  ? Colors.grey.shade400
                  : Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLocked)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.amber.shade400, Colors.orange.shade400],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.lock, color: Colors.white, size: 12),
                      SizedBox(width: 4),
                      Text(
                        'Premium',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              if (badge != null && !isLocked)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple.shade400, Colors.blue.shade400],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade600,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
