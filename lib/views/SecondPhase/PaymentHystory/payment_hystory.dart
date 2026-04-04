// // Navigate to the payment history screen
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:posternova/constants/api_constant.dart';

// class PaymentHistoryScreen extends StatefulWidget {
//   final String userId;

//   const PaymentHistoryScreen({Key? key, required this.userId})
//     : super(key: key);

//   @override
//   State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
// }

// class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
//   List<PaymentModel> _payments = [];
//   bool _isLoading = true;
//   String? _errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _fetchPaymentHistory();
//   }

//   Future<void> _fetchPaymentHistory() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       final url = Uri.parse(
//         '${ApiConstants.baseUrl}/mypaymentshistory/${widget.userId}',
//       );
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = json.decode(response.body);

//         if (responseData['success'] == true) {
//           final List<dynamic> data = responseData['data'];
//           setState(() {
//             _payments = data
//                 .map((item) => PaymentModel.fromJson(item))
//                 .toList();
//             _isLoading = false;
//           });
//         } else {
//           setState(() {
//             _errorMessage =
//                 responseData['message'] ?? 'Failed to load payment history';
//             _isLoading = false;
//           });
//         }
//       } else {
//         setState(() {
//           _errorMessage = 'Server error: ${response.statusCode}';
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Network error: $e';
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         title: const Text(
//           'Payment History',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
//         ),
//         elevation: 0,
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black87,
//         centerTitle: false,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: _fetchPaymentHistory,
//             tooltip: 'Refresh',
//           ),
//         ],
//       ),
//       body: _buildBody(),
//     );
//   }

//   Widget _buildBody() {
//     if (_isLoading) {
//       return const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressIndicator(color: Color(0xFF2563EB)),
//             SizedBox(height: 16),
//             Text(
//               'Loading payment history...',
//               style: TextStyle(color: Colors.grey, fontSize: 14),
//             ),
//           ],
//         ),
//       );
//     }

//     if (_errorMessage != null) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
//               const SizedBox(height: 16),
//               Text(
//                 'Something went wrong',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.grey.shade700,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 _errorMessage!,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton.icon(
//                 onPressed: _fetchPaymentHistory,
//                 icon: const Icon(Icons.refresh),
//                 label: const Text('Try Again'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF2563EB),
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 24,
//                     vertical: 12,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     if (_payments.isEmpty) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.receipt_outlined,
//                 size: 80,
//                 color: Colors.grey.shade400,
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 'No payments found',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.grey.shade600,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'You haven\'t made any payments yet',
//                 style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return RefreshIndicator(
//       onRefresh: _fetchPaymentHistory,
//       child: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: _payments.length,
//         itemBuilder: (context, index) {
//           final payment = _payments[index];
//           return PaymentCard(payment: payment);
//         },
//       ),
//     );
//   }
// }

// class PaymentCard extends StatelessWidget {
//   final PaymentModel payment;

//   const PaymentCard({Key? key, required this.payment}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Media preview (if mediaUrl exists)
//           if (payment.mediaUrl != null && payment.mediaUrl!.isNotEmpty)
//             ClipRRect(
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 topRight: Radius.circular(20),
//               ),
//               child: payment.mediaType == 'image'
//                   ? Image.network(
//                       payment.mediaUrl!,
//                       height: 200,
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) {
//                         return Container(
//                           height: 200,
//                           color: Colors.grey.shade200,
//                           child: const Center(
//                             child: Icon(
//                               Icons.broken_image,
//                               size: 48,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         );
//                       },
//                     )
//                   : Container(
//                       height: 200,
//                       color: Colors.grey.shade200,
//                       child: const Center(
//                         child: Icon(
//                           Icons.video_library,
//                           size: 48,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ),
//             ),

//           // Content
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Item name and status badge
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: Text(
//                         payment.itemName,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 6,
//                       ),
//                       decoration: BoxDecoration(
//                         color: _getStatusColor(payment.status).withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             _getStatusIcon(payment.status),
//                             size: 14,
//                             color: _getStatusColor(payment.status),
//                           ),
//                           const SizedBox(width: 4),
//                           Text(
//                             payment.status.toUpperCase(),
//                             style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600,
//                               color: _getStatusColor(payment.status),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),

//                 // Amount
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 6,
//                       ),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF2563EB).withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Text(
//                         '\$${payment.amount.toStringAsFixed(2)}',
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF2563EB),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),

//                 // Divider
//                 Divider(color: Colors.grey.shade200, height: 1),
//                 const SizedBox(height: 12),

//                 // Details grid
//                 Wrap(
//                   spacing: 16,
//                   runSpacing: 12,
//                   children: [
//                     _buildDetailItem(
//                       icon: Icons.receipt,
//                       label: 'Item ID',
//                       value: payment.itemId,
//                     ),
//                     _buildDetailItem(
//                       icon: Icons.credit_card,
//                       label: 'Transaction',
//                       value: payment.transactionId ?? 'N/A',
//                     ),
//                     _buildDetailItem(
//                       icon: Icons.calendar_today,
//                       label: 'Created',
//                       value: _formatDate(payment.createdAt),
//                     ),
//                     if (payment.paidAt != null)
//                       _buildDetailItem(
//                         icon: Icons.check_circle,
//                         label: 'Paid At',
//                         value: _formatDate(payment.paidAt!),
//                       ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailItem({
//     required IconData icon,
//     required String label,
//     required String value,
//   }) {
//     return Container(
//       constraints: const BoxConstraints(minWidth: 120),
//       child: Row(
//         children: [
//           Icon(icon, size: 16, color: Colors.grey.shade600),
//           const SizedBox(width: 6),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 11,
//                   color: Colors.grey.shade500,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 value,
//                 style: TextStyle(
//                   fontSize: 13,
//                   color: Colors.grey.shade800,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'paid':
//         return const Color(0xFF10B981);
//       case 'pending':
//         return const Color(0xFFF59E0B);
//       case 'failed':
//         return const Color(0xFFEF4444);
//       default:
//         return Colors.grey;
//     }
//   }

//   IconData _getStatusIcon(String status) {
//     switch (status.toLowerCase()) {
//       case 'paid':
//         return Icons.check_circle;
//       case 'pending':
//         return Icons.hourglass_empty;
//       case 'failed':
//         return Icons.error;
//       default:
//         return Icons.circle;
//     }
//   }

//   String _formatDate(String? dateString) {
//     if (dateString == null) return 'N/A';
//     try {
//       final date = DateTime.parse(dateString);
//       return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
//     } catch (e) {
//       return dateString;
//     }
//   }
// }

// class PaymentModel {
//   final String id;
//   final String userId;
//   final String itemName;
//   final String itemId;
//   final double amount;
//   final String? mediaUrl;
//   final String? mediaType;
//   final String status;
//   final String? transactionId;
//   final String? paidAt;
//   final String createdAt;
//   final String updatedAt;

//   PaymentModel({
//     required this.id,
//     required this.userId,
//     required this.itemName,
//     required this.itemId,
//     required this.amount,
//     this.mediaUrl,
//     this.mediaType,
//     required this.status,
//     this.transactionId,
//     this.paidAt,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory PaymentModel.fromJson(Map<String, dynamic> json) {
//     return PaymentModel(
//       id: json['_id'] ?? '',
//       userId: json['userId'] ?? '',
//       itemName: json['itemName'] ?? '',
//       itemId: json['itemId'] ?? '',
//       amount: (json['amount'] ?? 0).toDouble(),
//       mediaUrl: json['mediaUrl'],
//       mediaType: json['mediaType'],
//       status: json['status'] ?? 'pending',
//       transactionId: json['transactionId'],
//       paidAt: json['paidAt'],
//       createdAt: json['createdAt'] ?? '',
//       updatedAt: json['updatedAt'] ?? '',
//     );
//   }
// }

// Navigate to the payment history screen
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:posternova/constants/api_constant.dart';

class PaymentHistoryScreen extends StatefulWidget {
  final String userId;

  const PaymentHistoryScreen({Key? key, required this.userId})
    : super(key: key);

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  List<PaymentModel> _payments = [];
  bool _isLoading = true;
  String? _errorMessage;

  bool get _isDarkMode => Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();
    _fetchPaymentHistory();
  }

  Future<void> _fetchPaymentHistory() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final url = Uri.parse(
        '${ApiConstants.baseUrl}/mypaymentshistory/${widget.userId}',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          final List<dynamic> data = responseData['data'];
          setState(() {
            _payments = data
                .map((item) => PaymentModel.fromJson(item))
                .toList();
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage =
                responseData['message'] ?? 'Failed to load payment history';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Server error: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Network error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = _isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode
          ? const Color(0xFF0F172A)
          : Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Payment History',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        elevation: 0,
        backgroundColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black87,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchPaymentHistory,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final isDarkMode = _isDarkMode;

    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: const Color(0xFFF5C518)),
            const SizedBox(height: 16),
            Text(
              'Loading payment history...',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
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
                _errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _fetchPaymentHistory,
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

    if (_payments.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_outlined,
                size: 80,
                color: isDarkMode ? Colors.grey[600] : Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No payments found',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You haven\'t made any payments yet',
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.grey[500] : Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchPaymentHistory,
      color: const Color(0xFFF5C518),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _payments.length,
        itemBuilder: (context, index) {
          final payment = _payments[index];
          return PaymentCard(payment: payment);
        },
      ),
    );
  }
}

class PaymentCard extends StatelessWidget {
  final PaymentModel payment;

  const PaymentCard({Key? key, required this.payment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isDarkMode ? Colors.black : Colors.grey).withOpacity(
              isDarkMode ? 0.3 : 0.1,
            ),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Media preview (if mediaUrl exists)
          if (payment.mediaUrl != null && payment.mediaUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: payment.mediaType == 'image'
                  ? Image.network(
                      payment.mediaUrl!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          color: isDarkMode
                              ? const Color(0xFF0F172A)
                              : Colors.grey.shade200,
                          child: Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 48,
                              color: isDarkMode
                                  ? Colors.grey[600]
                                  : Colors.grey,
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      height: 200,
                      color: isDarkMode
                          ? const Color(0xFF0F172A)
                          : Colors.grey.shade200,
                      child: Center(
                        child: Icon(
                          Icons.video_library,
                          size: 48,
                          color: isDarkMode ? Colors.grey[600] : Colors.grey,
                        ),
                      ),
                    ),
            ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item name and status badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        payment.itemName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(payment.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getStatusIcon(payment.status),
                            size: 14,
                            color: _getStatusColor(payment.status),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            payment.status.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _getStatusColor(payment.status),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Amount
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5C518).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '\$${payment.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFF5C518),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Divider
                Divider(
                  color: isDarkMode ? Colors.grey[800] : Colors.grey.shade200,
                  height: 1,
                ),
                const SizedBox(height: 12),

                // Details grid
                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  children: [
                    _buildDetailItem(
                      icon: Icons.receipt,
                      label: 'Item ID',
                      value: payment.itemId,
                      isDarkMode: isDarkMode,
                    ),
                    _buildDetailItem(
                      icon: Icons.credit_card,
                      label: 'Transaction',
                      value: payment.transactionId ?? 'N/A',
                      isDarkMode: isDarkMode,
                    ),
                    _buildDetailItem(
                      icon: Icons.calendar_today,
                      label: 'Created',
                      value: _formatDate(payment.createdAt),
                      isDarkMode: isDarkMode,
                    ),
                    if (payment.paidAt != null)
                      _buildDetailItem(
                        icon: Icons.check_circle,
                        label: 'Paid At',
                        value: _formatDate(payment.paidAt!),
                        isDarkMode: isDarkMode,
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

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    required bool isDarkMode,
  }) {
    return Container(
      constraints: const BoxConstraints(minWidth: 120),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: isDarkMode ? Colors.grey[500] : Colors.grey.shade600,
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: isDarkMode ? Colors.grey[500] : Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  color: isDarkMode ? Colors.grey[300] : Colors.grey.shade800,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return const Color(0xFF10B981);
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'failed':
        return const Color(0xFFEF4444);
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Icons.check_circle;
      case 'pending':
        return Icons.hourglass_empty;
      case 'failed':
        return Icons.error;
      default:
        return Icons.circle;
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }
}

class PaymentModel {
  final String id;
  final String userId;
  final String itemName;
  final String itemId;
  final double amount;
  final String? mediaUrl;
  final String? mediaType;
  final String status;
  final String? transactionId;
  final String? paidAt;
  final String createdAt;
  final String updatedAt;

  PaymentModel({
    required this.id,
    required this.userId,
    required this.itemName,
    required this.itemId,
    required this.amount,
    this.mediaUrl,
    this.mediaType,
    required this.status,
    this.transactionId,
    this.paidAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      itemName: json['itemName'] ?? '',
      itemId: json['itemId'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      mediaUrl: json['mediaUrl'],
      mediaType: json['mediaType'],
      status: json['status'] ?? 'pending',
      transactionId: json['transactionId'],
      paidAt: json['paidAt'],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
