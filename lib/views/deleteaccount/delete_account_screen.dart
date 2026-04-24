
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:posternova/helper/storage_helper.dart';
// import 'dart:convert';

// import 'package:posternova/views/AuthModule/auth_screen.dart';
// import 'package:posternova/widgets/language_widget.dart';

// class DeleteAccountScreen extends StatefulWidget {
//   const DeleteAccountScreen({super.key});

//   @override
//   State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
// }

// class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
//   bool _isDeleting = false;
//   final TextEditingController _confirmController = TextEditingController();
//   String _requiredConfirmation = 'DELETE';
//   String? _errorText;
//   bool _acknowledgedWarning = false;

//   @override
//   void dispose() {
//     _confirmController.dispose();
//     super.dispose();
//   }

//   Future<void> _deleteAccount() async {
//     setState(() {
//       _isDeleting = true;
//       _errorText = null;
//     });

//     try {
//       final userData = await AuthPreferences.getUserData();
//       final token = await AuthPreferences.getToken();

//       if (userData?.user?.id == null) {
//         throw Exception('User ID not found in stored data');
//       }

//       final userId = userData!.user!.id;
//       final url = Uri.parse('http://31.97.206.144:4061/api/users/delete-user/$userId');

//       final response = await http
//           .delete(url, headers: {
//         'Content-Type': 'application/json',
//         if (token != null) 'Authorization': 'Bearer $token',
//       }).timeout(const Duration(seconds: 30));

//       if (response.statusCode == 200 || response.statusCode == 204) {
//         await AuthPreferences.clearUserData();

//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               backgroundColor: Colors.green,
//               content: Text("Your account has been deleted successfully"),
//               duration: Duration(seconds: 2),
//             ),
//           );

//           Navigator.of(context).pushAndRemoveUntil(
//             MaterialPageRoute(builder: (context) => const AuthScreen()),
//             (route) => false,
//           );
//         }
//       } else {
//         final errorMessage = _parseErrorMessage(response.body, response.statusCode);
//         throw Exception(errorMessage);
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _errorText = e.toString();
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             backgroundColor: Colors.red,
//             content: Text("Failed to delete account: ${e.toString()}"),
//             duration: const Duration(seconds: 4),
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isDeleting = false);
//       }
//     }
//   }

//   String _parseErrorMessage(String responseBody, int statusCode) {
//     try {
//       final Map<String, dynamic> errorData = jsonDecode(responseBody);
//       return errorData['message'] ??
//           'HTTP $statusCode: ${errorData['error'] ?? 'Unknown error'}';
//     } catch (e) {
//       return 'HTTP $statusCode: Unable to delete account. Please try again.';
//     }
//   }

//   void _onDeletePressed() {
//     if (_confirmController.text.trim().toUpperCase() != _requiredConfirmation) {
//       setState(() {
//         _errorText = 'Please type "$_requiredConfirmation" to confirm.';
//       });
//       return;
//     }

//     if (!_acknowledgedWarning) {
//       setState(() {
//         _errorText = 'Please acknowledge the warning by checking the box above.';
//       });
//       return;
//     }

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (ctx) => AlertDialog(
//         title: const Text('Final Confirmation'),
//         content: const Text(
//           'Are you absolutely sure you want to delete your account? This action is permanent and cannot be reversed.',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(ctx).pop(),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             style: TextButton.styleFrom(foregroundColor: Colors.red),
//             onPressed: () {
//               Navigator.of(ctx).pop();
//               _deleteAccount();
//             },
//             child: const Text('Delete Account'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;

//     return Scaffold(
//       appBar: AppBar(
//         title: const AppText(
//           'delete_account',
          
//           style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
//         ),

//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: theme.scaffoldBackgroundColor,
//         leading: IconButton(onPressed: (){
//           Navigator.of(context).pop();
//         }, icon: Icon(Icons.arrow_back_ios)),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header Section
//               AppText(
//                 'delete_account',
//                 style: theme.textTheme.headlineMedium?.copyWith(
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               AppText(
//                 'sorry_to_see_you_go',
//                 style: theme.textTheme.bodyMedium?.copyWith(
//                   color: theme.textTheme.bodySmall?.color,
//                 ),
//               ),
//               const SizedBox(height: 32),

//               // Warning Card
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: isDark ? Colors.red.shade900.withOpacity(0.2) : Colors.red.shade50,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: isDark ? Colors.red.shade800 : Colors.red.shade200,
//                     width: 1,
//                   ),
//                 ),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Icon(
//                       Icons.warning_amber_rounded,
//                       color: Colors.red.shade700,
//                       size: 24,
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           AppText(
//                             'warning',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                               color: Colors.red.shade700,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           AppText(
//                             'action_permanent',
//                             style: theme.textTheme.bodyMedium,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24),

//               // What will be deleted section
//               // Text(
//               //   'What will be deleted',
//               //   style: theme.textTheme.titleMedium?.copyWith(
//               //     fontWeight: FontWeight.bold,
//               //   ),
//               // ),
//               const SizedBox(height: 16),
//               // _InfoTile(
//               //   icon: Icons.person_outline,
//               //   title: 'Profile Information',
//               //   description: 'Your personal details and preferences',
//               // ),
//               // const SizedBox(height: 12),
//               // _InfoTile(
//               //   icon: Icons.history,
//               //   title: 'Activity History',
//               //   description: 'All your past orders and interactions',
//               // ),
//               // const SizedBox(height: 12),
//               // _InfoTile(
//               //   icon: Icons.cloud_outlined,
//               //   title: 'Saved Data',
//               //   description: 'All content and files associated with your account',
//               // ),
//               const SizedBox(height: 32),

//               // Alternative options
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.lightbulb_outline,
//                           color: theme.primaryColor,
//                           size: 20,
//                         ),
//                         const SizedBox(width: 8),
//                         AppText(
//                           'before_you_go',
//                           style: theme.textTheme.titleSmall?.copyWith(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     // Text(
//                     //   'Consider contacting our support team if you're experiencing issues. We're here to help and may be able to resolve your concerns.',
//                     //   style: theme.textTheme.bodySmall,
//                     // ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 32),

//               // Acknowledgment checkbox
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: _errorText != null && !_acknowledgedWarning
//                         ? Colors.red
//                         : theme.dividerColor,
//                   ),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: CheckboxListTile(
//                   value: _acknowledgedWarning,
//                   onChanged: _isDeleting
//                       ? null
//                       : (value) {
//                           setState(() {
//                             _acknowledgedWarning = value ?? false;
//                             if (_errorText != null) _errorText = null;
//                           });
//                         },
//                   contentPadding: EdgeInsets.zero,
//                   controlAffinity: ListTileControlAffinity.leading,
//                   title: AppText(
//                     'delete_confirm_understand',
//                     style: theme.textTheme.bodyMedium,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 24),

//               // Confirmation input
//               Text(
//                 'Type DELETE to confirm',
//                 style: theme.textTheme.titleSmall?.copyWith(
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               TextField(
//                 controller: _confirmController,
//                 enabled: !_isDeleting,
//                 textCapitalization: TextCapitalization.characters,
//                 decoration: InputDecoration(
//                   hintText: 'DELETE',
//                   errorText: _errorText,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide(color: theme.dividerColor),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide(color: theme.primaryColor, width: 2),
//                   ),
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 16,
//                   ),
//                 ),
//                 onChanged: (_) {
//                   if (_errorText != null) setState(() => _errorText = null);
//                 },
//               ),
//               const SizedBox(height: 32),

//               // Delete button
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red.shade600,
//                     foregroundColor: Colors.white,
//                     disabledBackgroundColor: Colors.grey.shade400,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     elevation: 0,
//                   ),
//                   onPressed: _isDeleting ? null : _onDeletePressed,
//                   child: _isDeleting
//                       ? const SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                             strokeWidth: 2,
//                           ),
//                         )
//                       : const AppText(
//                           'delete_account',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                 ),
//               ),
//               const SizedBox(height: 12),

//               // Cancel button
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: OutlinedButton(
//                   style: OutlinedButton.styleFrom(
//                     foregroundColor: theme.textTheme.bodyLarge?.color,
//                     side: BorderSide(color: theme.dividerColor),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   onPressed: _isDeleting ? null : () => Navigator.of(context).pop(),
//                   child: const Text(
//                     'Cancel',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _InfoTile extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String description;

//   const _InfoTile({
//     required this.icon,
//     required this.title,
//     required this.description,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: theme.primaryColor.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(
//             icon,
//             size: 20,
//             color: theme.primaryColor,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: theme.textTheme.bodyMedium?.copyWith(
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 description,
//                 style: theme.textTheme.bodySmall?.copyWith(
//                   color: theme.textTheme.bodySmall?.color,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }





















import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:posternova/helper/storage_helper.dart';
import 'dart:convert';

import 'package:posternova/views/AuthModule/auth_screen.dart';
import 'package:posternova/widgets/language_widget.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  bool _isDeleting = false;
  final TextEditingController _confirmController = TextEditingController();
  final String _requiredConfirmation = 'DELETE';
  String? _errorText;
  bool _acknowledgedWarning = false;

  @override
  void dispose() {
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _deleteAccount() async {
    setState(() {
      _isDeleting = true;
      _errorText = null;
    });

    try {
      final userData = await AuthPreferences.getUserData();
      final token = await AuthPreferences.getToken();

      if (userData?.user?.id == null) {
        throw Exception('User ID not found');
      }

      final userId = userData!.user!.id;
      final url = Uri.parse(
          'http://31.97.228.17:4061/api/users/delete-user/$userId');

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        await AuthPreferences.clearUserData();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor:
                  Theme.of(context).colorScheme.primary,
              content: Text(
                "Account deleted successfully",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          );

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const AuthScreen()),
            (route) => false,
          );
        }
      } else {
        throw Exception(_parseErrorMessage(response.body, response.statusCode));
      }
    } catch (e) {
      setState(() => _errorText = e.toString());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Text(
            "Error: ${e.toString()}",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onError,
            ),
          ),
        ),
      );
    } finally {
      setState(() => _isDeleting = false);
    }
  }

  String _parseErrorMessage(String body, int code) {
    try {
      final data = jsonDecode(body);
      return data['message'] ?? 'Error ($code)';
    } catch (_) {
      return 'Error ($code)';
    }
  }

  void _onDeletePressed() {
    if (_confirmController.text.trim().toUpperCase() != _requiredConfirmation) {
      setState(() {
        _errorText = 'Type "$_requiredConfirmation" to confirm';
      });
      return;
    }

    if (!_acknowledgedWarning) {
      setState(() {
        _errorText = 'Please accept the warning';
      });
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          'Confirm',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        content: Text(
          'This action is permanent. Are you sure?',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor:
                  Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              Navigator.pop(context);
              _deleteAccount();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        title: const AppText(
          'delete_account',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              'delete_account',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            AppText(
              'sorry_to_see_you_go',
              style: theme.textTheme.bodyMedium,
            ),

            const SizedBox(height: 30),

            /// WARNING CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.error,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning,
                      color: theme.colorScheme.error),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppText(
                      'action_permanent',
                      style: theme.textTheme.bodyMedium,
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// BEFORE YOU GO
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? theme.colorScheme.surfaceVariant
                    : theme.colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline,
                      color: theme.colorScheme.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppText(
                      'before_you_go',
                      style: theme.textTheme.bodyMedium,
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// CHECKBOX
            CheckboxListTile(
              value: _acknowledgedWarning,
              onChanged: (val) {
                setState(() {
                  _acknowledgedWarning = val ?? false;
                });
              },
              title: AppText(
                'delete_confirm_understand',
                style: theme.textTheme.bodyMedium,
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),

            const SizedBox(height: 20),

            /// TEXT FIELD
            Text(
              'Type DELETE to confirm',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _confirmController,
              style: TextStyle(
                color: theme.textTheme.bodyLarge?.color,
              ),
              decoration: InputDecoration(
                hintText: 'DELETE',
                hintStyle: TextStyle(color: theme.hintColor),
                errorText: _errorText,
                filled: true,
                fillColor: isDark
                    ? theme.colorScheme.surfaceVariant.withOpacity(0.3)
                    : theme.colorScheme.surfaceVariant.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// DELETE BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: theme.colorScheme.onError,
                ),
                onPressed: _isDeleting ? null : _onDeletePressed,
                child: _isDeleting
                    ? CircularProgressIndicator(
                        color: theme.colorScheme.onError,
                      )
                    : const Text('Delete Account'),
              ),
            ),

            const SizedBox(height: 10),

            /// CANCEL BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.onSurface,
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}