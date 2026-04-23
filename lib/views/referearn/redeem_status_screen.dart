import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RedemptionStatusScreen extends StatefulWidget {
  final String userId;
  
  const RedemptionStatusScreen({
    super.key,
    required this.userId,
  });

  @override
  State<RedemptionStatusScreen> createState() => _RedemptionStatusScreenState();
}

class _RedemptionStatusScreenState extends State<RedemptionStatusScreen> {
  bool _isLoading = true;
  String _status = '';
  String _message = '';
  
  static const Color _primary = Color(0xFF6842FF);

  @override
  void initState() {
    super.initState();
    _checkRedemptionStatus();
  }

  Future<void> _checkRedemptionStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('http://82.29.162.67:4061/api/users/getredemptionstatus/${widget.userId}'),
        headers: {
          'Content-Type': 'application/json',
          // Add auth token if required
          // 'Authorization': 'Bearer ${await AuthPreferences.getToken()}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _status = data['status'] ?? '';
          _message = data['message'] ?? '';
          _isLoading = false;
        });

        // If approved, show success and update wallet
        if (_status == 'approved') {
          _showApprovedDialog();
        }
      } else {
        setState(() {
          _isLoading = false;
          _status = 'error';
          _message = 'Failed to fetch redemption status';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _status = 'error';
        _message = 'Error: $e';
      });
    }
  }

  void _showApprovedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          title: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 10),
              Text('Approved!'),
            ],
          ),
          content: const Text(
            'Your redemption has been approved! '
            'The amount has been added to your wallet.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Close status screen
                Navigator.of(context).pop(); // Close bank details screen
                // Optionally refresh wallet
                // context.read<WalletProvider>().fetchWalletBalance();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Color _getStatusColor() {
    switch (_status) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon() {
    switch (_status) {
      case 'approved':
        return Icons.check_circle;
      case 'pending':
        return Icons.hourglass_empty;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  String _getStatusTitle() {
    switch (_status) {
      case 'approved':
        return 'Redemption Approved';
      case 'pending':
        return 'Redemption Pending';
      case 'rejected':
        return 'Redemption Rejected';
      default:
        return 'Redemption Status';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? null : const Color(0xFFF7F8FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Redemption Status',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(_primary),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Checking redemption status...',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  
                  // Status Icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: _getStatusColor().withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _getStatusColor(),
                        width: 3,
                      ),
                    ),
                    child: Icon(
                      _getStatusIcon(),
                      size: 60,
                      color: _getStatusColor(),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Status Title
                  Text(
                    _getStatusTitle(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Status Message
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? Theme.of(context).cardColor : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.1 : 0.03),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.message,
                          size: 40,
                          color: _getStatusColor(),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _message,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Additional info based on status
                  if (_status == 'pending') ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.info_outline, color: Colors.orange),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                             'Your redemption request is under review. Once approved, the amount will be credited to your wallet.',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else if (_status == 'approved') ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.account_balance_wallet, color: Colors.green),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'The amount has been successfully added to your wallet!',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else if (_status == 'rejected') ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.error_outline, color: Colors.red),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Please contact support for more information.',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 32),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _checkRedemptionStatus,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Refresh'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(
                              color: isDark ? Colors.grey.shade700 : Colors.grey.shade400,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            foregroundColor: _primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Done',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}