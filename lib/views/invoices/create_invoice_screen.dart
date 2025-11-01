import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:posternova/providers/invoices/invoice_provider.dart';
import 'package:posternova/views/invoices/add_invoice_data.dart';
import 'package:posternova/views/invoices/invoice_detail_screen.dart';
import 'package:posternova/views/invoices/user_details.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CreateInvoiceScreen extends StatefulWidget {
  const CreateInvoiceScreen({super.key});

  @override
  State<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInvoices();
  }

  Future<void> _loadInvoices() async {
    final provider = Provider.of<ProductInvoiceProvider>(
      context,
      listen: false,
    );
    await provider.loadInvoices();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  String _generateInvoiceNumber(String id) {
    return "INV-${id.substring(0, 7).toUpperCase()}";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final backgroundColor = isDarkMode
        ? const Color(0xFF121212)
        : const Color(0xFFF5F7FA);
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF2C3E50);
    final secondaryTextColor = isDarkMode
        ? const Color(0xFFB0B0B0)
        : const Color(0xFF7F8C8D);
    final accentColor = isDarkMode
        ? const Color(0xFF4A9EFF)
        : const Color(0xFF3498DB);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.receipt_long, color: accentColor, size: 24),
            ),
            const SizedBox(width: 12),
            Text(
              'Invoices',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: textColor,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserDetails()),
              );
            },
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.person_outline, color: accentColor, size: 20),
            ),
          ),
          const SizedBox(width: 8),
        ],
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading invoices...',
                    style: TextStyle(color: secondaryTextColor, fontSize: 14),
                  ),
                ],
              ),
            )
          : Consumer<ProductInvoiceProvider>(
              builder: (context, invoiceProvider, _) {
                final invoices = invoiceProvider.invoices;

                if (invoices.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.description_outlined,
                            size: 80,
                            color: accentColor.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'No Invoices Yet',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 48),
                          child: Text(
                            'Start creating professional invoices',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: secondaryTextColor,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'All Invoices',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${invoices.length} ${invoices.length == 1 ? 'invoice' : 'invoices'} total',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: secondaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                        itemCount: invoices.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final invoice = invoices[index];
                          final invoiceDate = _formatDate(invoice.createdAt);
                          final dueDate = _formatDate(
                            invoice.createdAt.add(const Duration(days: 30)),
                          );

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      InvoiceDetailScreen(invoice: invoice),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isDarkMode
                                      ? Colors.grey.withOpacity(0.2)
                                      : Colors.grey.withOpacity(0.1),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isDarkMode
                                        ? Colors.black.withOpacity(0.2)
                                        : Colors.black.withOpacity(0.04),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: accentColor.withOpacity(0.08),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: accentColor.withOpacity(
                                                  0.15,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Icon(
                                                Icons
                                                    .insert_drive_file_outlined,
                                                color: accentColor,
                                                size: 18,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              _generateInvoiceNumber(
                                                invoice.id,
                                              ),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                                color: textColor,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16,
                                          color: secondaryTextColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: _buildInfoColumn(
                                                'Issue Date',
                                                invoiceDate,
                                                Icons.calendar_today_outlined,
                                                textColor,
                                                secondaryTextColor,
                                              ),
                                            ),
                                            Container(
                                              width: 1,
                                              height: 40,
                                              color: isDarkMode
                                                  ? Colors.grey.withOpacity(0.2)
                                                  : Colors.grey.withOpacity(
                                                      0.2,
                                                    ),
                                            ),
                                            Expanded(
                                              child: _buildInfoColumn(
                                                'Due Date',
                                                dueDate,
                                                Icons.event_outlined,
                                                textColor,
                                                secondaryTextColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        // Container(
                                        //   padding: const EdgeInsets.all(12),
                                        //   decoration: BoxDecoration(
                                        //     color: accentColor.withOpacity(
                                        //       0.08,
                                        //     ),
                                        //     borderRadius: BorderRadius.circular(
                                        //       12,
                                        //     ),
                                        //   ),
                                        //   child: Row(
                                        //     mainAxisAlignment:
                                        //         MainAxisAlignment.spaceBetween,
                                        //     children: [
                                        //       Row(
                                        //         children: [
                                        //           Icon(
                                        //             Icons
                                        //                 .account_balance_wallet_outlined,
                                        //             color: accentColor,
                                        //             size: 20,
                                        //           ),
                                        //           const SizedBox(width: 8),
                                        //           Text(
                                        //             'Total Amount',
                                        //             style: TextStyle(
                                        //               fontSize: 13,
                                        //               color: secondaryTextColor,
                                        //               fontWeight:
                                        //                   FontWeight.w500,
                                        //             ),
                                        //           ),
                                        //         ],
                                        //       ),
                                        //       Text(
                                        //         '\$${invoice.totalAmount.toStringAsFixed(2)}',
                                        //         style: TextStyle(
                                        //           fontWeight: FontWeight.w700,
                                        //           fontSize: 20,
                                        //           color: accentColor,
                                        //           letterSpacing: 0.5,
                                        //         ),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddInvoiceData()),
          ).then((_) => _loadInvoices());
        },
        icon: const Icon(Icons.add, color: Colors.white, size: 22),
        label: const Text(
          'Create New Invoice',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
        backgroundColor: isDarkMode
            ? const Color(0xFF4A9EFF)
            : const Color(0xFF3498DB),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildInfoColumn(
    String label,
    String value,
    IconData icon,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return Column(
      children: [
        Icon(icon, size: 18, color: secondaryTextColor),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: secondaryTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
