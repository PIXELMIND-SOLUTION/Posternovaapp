// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class WalletScreen extends StatefulWidget {
//   const WalletScreen({super.key});

//   @override
//   State<WalletScreen> createState() => _WalletScreenState();
// }

// class _WalletScreenState extends State<WalletScreen> {
//   int walletAmount = 0;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchWallet();
//   }

//   Future<void> fetchWallet() async {
//     try {
//       final response = await http.get(
//         Uri.parse(
//           'http://31.97.206.144:4061/api/users/wallet/68d40e3f1503cc1836db8be6',
//         ),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         setState(() {
//           walletAmount = data['wallet'] ?? 0;
//           isLoading = false;
//         });
//       } else {
//         setState(() => isLoading = false);
//       }
//     } catch (e) {
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Wallet"), centerTitle: true),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Wallet Card
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       color: Colors.black87,
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           "Your Balance",
//                           style: TextStyle(color: Colors.white70, fontSize: 16),
//                         ),
//                         const SizedBox(height: 10),
//                         Text(
//                           "₹ $walletAmount",
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 32,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 20),

//                   // Info Text
//                   const Text(
//                     "Welcome to Editezy Wallet",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),

//                   const SizedBox(height: 10),

//                   const Text(
//                     "Using this wallet, you can download posters, reels, videos, business cards and more. Enjoy seamless access to premium content with your wallet balance.",
//                     style: TextStyle(fontSize: 14, color: Colors.grey),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:posternova/helper/storage_helper.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int walletAmount = 0;
  bool isLoading = true;
  String? errorMessage;

  bool get _isDarkMode => Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();
    fetchWallet();
  }

  Future<void> fetchWallet() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Get user ID from storage
      final userData = await AuthPreferences.getUserData();
      final userId = userData?.user.id;

      if (userId == null) {
        setState(() {
          errorMessage = 'User not logged in';
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('http://31.97.228.17:4061/api/users/wallet/$userId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          walletAmount = data['wallet'] ?? 0;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load wallet balance';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Network error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = _isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0F172A) : Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Wallet",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchWallet,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final isDarkMode = _isDarkMode;

    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: const Color(0xFFF5C518)),
            const SizedBox(height: 16),
            Text(
              'Loading wallet balance...',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: isDarkMode ? Colors.red[400] : Colors.red.shade300,
              ),
              const SizedBox(height: 16),
              Text(
                'Something went wrong',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.grey[300] : Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: fetchWallet,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF5C518),
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Wallet Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDarkMode
                    ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                    : [
                        const Color(0xFFF5C518),
                        const Color(0xFFF5C518).withOpacity(0.7),
                      ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: (isDarkMode ? Colors.black : Colors.grey).withOpacity(
                    isDarkMode ? 0.3 : 0.1,
                  ),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      size: 28,
                      color: isDarkMode
                          ? const Color(0xFFF5C518)
                          : Colors.black87,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Your Balance",
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  "₹ $walletAmount",
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: (isDarkMode ? Colors.white : Colors.black87)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Available Balance',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Info Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: (isDarkMode ? Colors.black : Colors.grey).withOpacity(
                    isDarkMode ? 0.2 : 0.05,
                  ),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 24,
                      color: const Color(0xFFF5C518),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Welcome to Edit Ezy Wallet",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  "Using this wallet, you can download posters, reels, videos, business cards and more. Enjoy seamless access to premium content with your wallet balance.",
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5C518).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        size: 20,
                        color: const Color(0xFFF5C518),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Add money to your wallet to unlock premium features",
                          style: TextStyle(
                            fontSize: 13,
                            color: isDarkMode ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
