import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:posternova/models/invoice_model.dart';
import 'package:posternova/providers/auth/login_provider.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui' as ui;
import 'package:shared_preferences/shared_preferences.dart';

class InvoiceDetailScreen extends StatefulWidget {
  final Invoice invoice;

  const InvoiceDetailScreen({super.key, required this.invoice});

  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  final GlobalKey _printableKey = GlobalKey();
  bool _isGeneratingPdf = false;
  bool _isLoading = true;
  String? _logoImageBase64;

  // Variables to store user data
  String businessName = 'Design Studio';
  String mobile = '(123) 456-7890';
  String email = 'designstudio@email.com';
  String bankAccount = '1234-5678-9012-3456';
  // String bankName = 'Bank Transfer';
  String gst = 'Not Available';
  String wastage = 'Wastage';
  String offerprice = 'offerprice';
  String description = 'description';
  String hsn = 'hsn';

  // Client data - in a real app this would be part of the invoice model
  String name = 'Narasimhavarma';

  String clientAddress = '123 Elm Street Green Valley';
  String clientPhone = '';
  String clientEmail = 'varma@email.com';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadSubscriptions();
    _loadLogoImage();
  }

  //   Future<void> _printPdf() async {
  //   try {
  //     final pdfBytes = await _generatePdf();
  //     await Printing.layoutPdf(
  //       onLayout: (PdfPageFormat format) async => pdfBytes,
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error printing PDF: $e')),
  //     );
  //   }
  // }

  Future<void> _printPdf() async {
    try {
      setState(() {
        _isGeneratingPdf = true;
      });

      final invoice = widget.invoice;
      final invoiceId = _generateInvoiceNumber(invoice.id);

      // Generate PDF bytes first
      final Uint8List pdfBytes = await _generatePdf();

      // Then print
      await Printing.layoutPdf(
        name: 'Invoice_$invoiceId.pdf',
        onLayout: (PdfPageFormat format) async => pdfBytes,
      );

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Print dialog opened')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error printing PDF: ${e.toString()}')),
        );
      }
      debugPrint('Print error details: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isGeneratingPdf = false;
        });
      }
    }
  }

  Future<void> _loadLogoImage() async {
    final prefs = await SharedPreferences.getInstance();
    final logoBase64 = prefs.getString('logo_image');

    if (logoBase64 != null && logoBase64.isNotEmpty) {
      setState(() {
        _logoImageBase64 = logoBase64;
      });
    }
  }

  Future<void> _loadSubscriptions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.user?.user.id;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Load user data from SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      businessName = prefs.getString('businessName') ?? 'Design Studio';
      clientPhone = prefs.getString('user_mobile') ?? '12345678';
      clientEmail = prefs.getString('email') ?? 'designstudio@email.com';
      // bankAccount = prefs.getString('bankAccount') ?? '1234-5678-9012-3456';
      // bankName = prefs.getString('bankName') ?? 'Bank Transfer';
      gst = prefs.getString('gst') ?? 'Not Available';
      name = prefs.getString('user_name') ?? 'Melvin';
      clientAddress = prefs.getString('user_address') ?? "No address added";
      offerprice = prefs.getString('Offer Price') ?? 'No offerprice';
      description = prefs.getString('Description') ?? 'No description';
      wastage = prefs.getString('Wastage') ?? 'No wastage';
      hsn = prefs.getString('HSN') ?? 'No hsn number';
    });
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMMM dd, yyyy').format(date);
  }

  String _generateInvoiceNumber(String id) {
    return "SI${DateTime.now().year}${id.substring(0, 3)}";
  }

  @override
  Widget build(BuildContext context) {
    final invoice = widget.invoice;
    final golditem = invoice.products[0].isGoldItem;
    final dueDate = invoice.createdAt.add(const Duration(days: 20));
    final totalAmount = invoice.products.fold<double>(0, (total, product) {
      final wastageAmount = product.offerPrice * (product.wastage / 100);

      final productTotal =
          (product.offerPrice + wastageAmount) * product.quantity;

      return productTotal;
    });

    double gstRate = 0.0;
    if (gst != 'Not Available') {
      // Try to parse the GST value (handle formats like "18%" or "18")
      String gstValue = gst.replaceAll('%', '').trim();
      try {
        gstRate = double.parse(gstValue) / 100; // Convert percentage to decimal
      } catch (e) {
        debugPrint('Error parsing GST rate: $e');
        // Keep default 0.0 if parsing fails
      }
    }

    final tax = totalAmount * gstRate;

    final totalWithTax = totalAmount + tax;

    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Invoice',
            // 'Invoice ${_generateInvoiceNumber(invoice.id)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.all(2.0),
          child: SingleChildScrollView(
            child: RepaintBoundary(
              key: _printableKey,
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 15, color: const Color(0xFF4ACBBC)),

                    // Navy header
                    Container(
                      color: const Color(0xFF0E2945),
                      width: double.infinity,
                      height: 8,
                    ),

                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with logo and invoice title
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Invoice title
                              const Text(
                                'INVOICE BILL',
                                style: TextStyle(
                                  fontSize: 38,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  letterSpacing: 1.5,
                                ),
                              ),

                              // Logo
                              Container(
                                decoration: BoxDecoration(
                                  // color: const Color(0xFFFFC84D),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(10),
                                height: 80,
                                width: 80,
                                child:
                                    _logoImageBase64 != null &&
                                        _logoImageBase64!.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: Image.memory(
                                          base64Decode(_logoImageBase64!),
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : const Center(
                                        child: Text(
                                          'd',
                                          style: TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Bill To Section
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Bill To:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Client Name: $name',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    // Text(
                                    //   'Company Name: $clientCompany',
                                    //   style: const TextStyle(fontSize: 14),
                                    // ),
                                    Text(
                                      'Billing Address: $clientAddress',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      'Phone: $clientPhone',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      'Email: $clientEmail',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),

                              // Invoice Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      // mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(width: 1),
                                        const Text(
                                          'Invoice Number: ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          _generateInvoiceNumber(invoice.id),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),

                                    // Row(
                                    //   // mainAxisAlignment: MainAxisAlignment.end,
                                    //   children: [
                                    //      SizedBox(width: 1,),
                                    //     const Text(
                                    //       'Invoice Date: ',
                                    //       style: TextStyle(
                                    //         fontSize: 12,
                                    //         fontWeight: FontWeight.w500,
                                    //       ),
                                    //     ),
                                    //     Text(
                                    //       _formatDate(invoice.createdAt),
                                    //       style: const TextStyle(
                                    //         fontSize: 12,
                                    //         fontWeight: FontWeight.bold,
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    Row(
                                      children: [
                                        const SizedBox(width: 1),
                                        const Text(
                                          'Invoice Date: ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),

                                        // 👇 FIX: Wrap dynamic text in Flexible to prevent overflow
                                        Flexible(
                                          child: Text(
                                            _formatDate(invoice.createdAt),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow
                                                .ellipsis, // optional
                                            softWrap: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),

                          // Service Details
                          const Text(
                            'Service Details:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Table header with gold background
                          // Header section
                          Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFC84D),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 8,
                            ),
                            child: Row(
                              children: [
                                // No.
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'No',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                // Product
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Product',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                // Description
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Description',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 9,
                                    ),
                                  ),
                                ),
                                // Quantity
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Quantity',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                // Price
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Price',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                SizedBox(width: 5),
                                // Offer Price
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Offer Price',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                // Wastage
                                if (golditem)
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Wastage',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                // HSN
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'HSN',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Product list section
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: invoice.products.length,
                            itemBuilder: (context, index) {
                              final product = invoice.products[index];
                              final isEven = index % 2 == 0;

                              return Container(
                                color: isEven
                                    ? Colors.grey.shade200
                                    : Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 8,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // No.
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        '${index + 1}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    // Product Name
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        product.productName,
                                        style: const TextStyle(fontSize: 10),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    // Description
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        '${product.description}',
                                        style: const TextStyle(fontSize: 10),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    // Quantity with unit
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        '${product.quantity}${product.unit.isNotEmpty ? ' ${product.unit}' : ''}',
                                        style: const TextStyle(fontSize: 10),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                      ),
                                    ),
                                    // Price
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        '${product.price.toStringAsFixed(2)}',
                                        style: const TextStyle(fontSize: 10),
                                        textAlign: TextAlign.right,
                                        maxLines: 1,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    // Offer Price
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        '${product.offerPrice.toStringAsFixed(2) ?? "-"}',
                                        style: const TextStyle(fontSize: 10),
                                        textAlign: TextAlign.right,
                                        maxLines: 1,
                                      ),
                                    ),
                                    if (golditem)
                                      // Wastage
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          '${product.wastage ?? 0}%',
                                          style: const TextStyle(fontSize: 10),
                                          textAlign: TextAlign.right,
                                          maxLines: 1,
                                        ),
                                      ),
                                    // HSN
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        '${product.hsn ?? 0}',
                                        style: const TextStyle(fontSize: 10),
                                        textAlign: TextAlign.right,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),

                          // Terms and Conditions and Summary
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Summary section first
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Subtotal',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            Text(
                                              '${totalAmount.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'GST',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            Text(
                                              'Tax (${gst != 'Not Available' ? gst : '0%'})',
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        const Divider(),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Grand Total:',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '${totalWithTax.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              // Add some space between sections
                              const SizedBox(height: 24),

                              // Terms and Conditions below
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Payment Information - Navy background
                    Container(
                      // color: const Color(0xFF0E2945),
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              // Payment Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(children: [
                                       
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(children: [
                                       
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Questions Section
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [const SizedBox(height: 8)],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // bottomNavigationBar: Padding(
        //   padding: const EdgeInsets.all(16.0),
        //   child: Row(
        //     children: [
        //       Expanded(
        //         child: ElevatedButton.icon(
        //           onPressed: _sharePdf,
        //           icon: const Icon(Icons.share, color: Colors.white),
        //           label: const Text(
        //             'Share',
        //             style: TextStyle(
        //                 fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255)),
        //           ),
        //           style: ElevatedButton.styleFrom(
        //             backgroundColor:  Colors.purple.shade300,
        //             shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(12),
        //             ),
        //             padding: const EdgeInsets.symmetric(vertical: 12),
        //           ),
        //         ),
        //       ),
        //       const SizedBox(width: 16),
        //       Expanded(
        //         child: ElevatedButton.icon(
        //           onPressed: _downloadPdf,
        //           icon: const Icon(Icons.download, color: Colors.white),
        //           label: const Text(
        //             'Download',
        //             style: TextStyle(
        //                 fontWeight: FontWeight.bold, color: Colors.white),
        //           ),
        //           style: ElevatedButton.styleFrom(
        //             backgroundColor:  Colors.green,
        //             shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(12),
        //             ),
        //             padding: const EdgeInsets.symmetric(vertical: 12),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),

        // 1. Add this import at the top of your file:

        // 2. Add this method to your _InvoiceDetailScreenState class:

        // 3. Update your bottomNavigationBar to include the Print button:
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _printPdf,
                  icon: const Icon(Icons.print, color: Colors.white),
                  label: const Text(
                    'Print',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _sharePdf,
                  icon: const Icon(Icons.share, color: Colors.white),
                  label: const Text(
                    'Share',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _downloadPdf,
                  icon: const Icon(Icons.download, color: Colors.white),
                  label: const Text(
                    'Download',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),

        // 4. Add this to your pubspec.yaml dependencies:
        // printing: ^5.11.0
      ),
    );
  }

  // IMPROVED PDF GENERATION METHOD THAT MATCHES UI
  Future<Uint8List> _generatePdf() async {
    setState(() {
      _isGeneratingPdf = true;
    });

    try {
      final invoice = widget.invoice;
      final invoiceId = _generateInvoiceNumber(invoice.id);
      final dueDate = invoice.createdAt.add(const Duration(days: 20));

      // Calculate total amount with wastage as done in the UI
      final totalAmount = invoice.products.fold<double>(0, (total, product) {
        final productTotal = product.offerPrice * product.quantity;
        final wastageAmount = product.offerPrice * (product.wastage / 100);
        return total + productTotal + wastageAmount;
      });

      double gstRate = 0.0;
      if (gst != 'Not Available') {
        String gstValue = gst.replaceAll('%', '').trim();
        try {
          gstRate = double.parse(gstValue) / 100;
        } catch (e) {
          debugPrint('Error parsing GST rate: $e');
        }
      }

      final tax = totalAmount * gstRate;
      final totalWithTax = totalAmount + tax;

      // Create a PDF document
      final pdf = pw.Document();

      // Try to load logo image for PDF if available
      pw.Widget logoWidget;
      if (_logoImageBase64 != null && _logoImageBase64!.isNotEmpty) {
        try {
          final logoImageData = base64Decode(_logoImageBase64!);
          final logoImage = pw.MemoryImage(logoImageData);
          logoWidget = pw.ClipRRect(
            horizontalRadius: 4,
            verticalRadius: 4,
            child: pw.Container(
              color: PdfColor.fromHex('FFC84D'),
              padding: const pw.EdgeInsets.all(10),
              height: 80,
              width: 80,
              child: pw.Image(logoImage, fit: pw.BoxFit.cover),
            ),
          );
        } catch (e) {
          // Fallback if image loading fails
          logoWidget = pw.Container(
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex('FFC84D'),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            padding: const pw.EdgeInsets.all(10),
            height: 80,
            width: 80,
            child: pw.Center(
              child: pw.Text(
                'd',
                style: pw.TextStyle(
                  fontSize: 40,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
            ),
          );
        }
      } else {
        // Default logo placeholder
        logoWidget = pw.Container(
          decoration: pw.BoxDecoration(
            color: PdfColor.fromHex('FFC84D'),
            borderRadius: pw.BorderRadius.circular(8),
          ),
          padding: const pw.EdgeInsets.all(10),
          height: 80,
          width: 80,
          child: pw.Center(
            child: pw.Text(
              'd',
              style: pw.TextStyle(
                fontSize: 40,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
            ),
          ),
        );
      }

      // Build the PDF document
      pdf.addPage(
        pw.MultiPage(
          pageTheme: pw.PageTheme(
            margin: const pw.EdgeInsets.all(40),
            theme: pw.ThemeData.withFont(
              base: pw.Font.helvetica(),
              bold: pw.Font.helveticaBold(),
            ),
          ),
          build: (pw.Context context) => [
            // Top teal accent and navy header
            pw.Container(height: 15, color: PdfColor.fromHex('4ACBBC')),
            pw.Container(
              color: PdfColor.fromHex('0E2945'),
              width: double.infinity,
              height: 8,
            ),
            pw.SizedBox(height: 16),

            // Header with logo and invoice title
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'INVOICE',
                  style: pw.TextStyle(
                    fontSize: 38,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  ),
                ),
                logoWidget,
              ],
            ),
            pw.SizedBox(height: 16),

            // Bill To and Invoice Details
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Bill To:',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Text(
                        'Client Name: $name',
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                      pw.Text(
                        'Billing Address: $clientAddress',
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                      pw.Text(
                        'Phone: $clientPhone',
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                      pw.Text(
                        'Email: $clientEmail',
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Text(
                            'Invoice Number: ',
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.normal,
                            ),
                          ),
                          pw.Text(
                            invoiceId,
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 4),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Text(
                            'Invoice Date: ',
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.normal,
                            ),
                          ),
                          pw.Text(
                            _formatDate(invoice.createdAt),
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 30),

            // Service Details
            pw.Text(
              'Service Details:',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),

            // Table header
            pw.Container(
              decoration: pw.BoxDecoration(
                // color: PdfColor.fromHex('FFC84DD'),
                color: PdfColor.fromHex('#3344C4'),
              ),
              padding: const pw.EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 8,
              ),
              child: pw.Row(
                children: [
                  pw.Expanded(
                    flex: 1,
                    child: pw.Text(
                      'Sl.No',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text(
                      'Product',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text(
                      'Description',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      'Quantity',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 12,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      'Price',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 12,
                      ),
                      textAlign: pw.TextAlign.right,
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      'Offer Price',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 12,
                      ),
                      textAlign: pw.TextAlign.right,
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      'Wastage',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 12,
                      ),
                      textAlign: pw.TextAlign.right,
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      'HSN',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 12,
                      ),
                      textAlign: pw.TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),

            // Product list rows
            ...List.generate(invoice.products.length, (index) {
              final product = invoice.products[index];
              final isEven = index % 2 == 0;

              return pw.Container(
                color: isEven ? PdfColor.fromHex('EEEEEE') : PdfColors.white,
                padding: const pw.EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    // Serial Number
                    pw.Expanded(
                      flex: 1,
                      child: pw.Text(
                        '${index + 1}',
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                    ),
                    // Product Name
                    pw.Expanded(
                      flex: 3,
                      child: pw.Text(
                        product.productName,
                        style: const pw.TextStyle(fontSize: 14),
                        maxLines: 1,
                      ),
                    ),
                    // Description
                    pw.Expanded(
                      flex: 3,
                      child: pw.Text(
                        '${product.description}',
                        style: const pw.TextStyle(fontSize: 14),
                        maxLines: 1,
                        textAlign: pw.TextAlign.left,
                      ),
                    ),
                    // Quantity with unit
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text(
                        '${product.quantity}${product.unit.isNotEmpty ? ' ${product.unit}' : ''}',
                        style: const pw.TextStyle(fontSize: 14),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    // Price
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text(
                        '${product.price.toStringAsFixed(2)}',
                        style: const pw.TextStyle(fontSize: 14),
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                    // Offer Price
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text(
                        '${product.offerPrice.toStringAsFixed(2)}',
                        style: const pw.TextStyle(fontSize: 14),
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                    // Wastage
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text(
                        '${product.wastage ?? 0}%',
                        style: const pw.TextStyle(fontSize: 14),
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                    // HSN
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text(
                        '${product.hsn ?? 0}',
                        style: const pw.TextStyle(fontSize: 14),
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                  ],
                ),
              );
            }),

            pw.SizedBox(height: 20),

            // Terms and Conditions and Summary
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Terms and Conditions
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Terms and Conditions:',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Text(
                        '• Payment is due upon receipt of this invoice.',
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                      pw.Text(
                        '• Late payments may incur additional charges.',
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                      pw.Text(
                        '• Please make checks payable to Your Graphic',
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                      pw.Text(
                        '  Design Studio.',
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),

                // Summary
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Subtotal',
                            style: const pw.TextStyle(fontSize: 14),
                          ),
                          pw.Text(
                            '${totalAmount.toStringAsFixed(2)}',
                            style: const pw.TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 8),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'GST',
                            style: const pw.TextStyle(fontSize: 14),
                          ),
                          pw.Text(
                            'Tax (${gst != 'Not Available' ? gst : '0%'})',
                            style: const pw.TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 8),
                      pw.Divider(),
                      pw.SizedBox(height: 8),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Grand Total:',
                            style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            '${totalWithTax.toStringAsFixed(2)}',
                            style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 20),

            // Payment Information - Navy background
            pw.Container(
              // color: PdfColor.fromHex('0E2945'),
              width: double.infinity,
              padding: const pw.EdgeInsets.all(16),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // pw.Text(
                  //   'Payment Information:',
                  //   style: pw.TextStyle(
                  //     fontSize: 18,
                  //     fontWeight: pw.FontWeight.bold,
                  //     color: PdfColors.white,
                  //   ),
                  // ),
                  pw.SizedBox(height: 16),
                  pw.Row(
                    children: [
                      // Payment Details
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(children: [
                          
                              ],
                            ),
                            pw.SizedBox(height: 4),
                            pw.Row(children: [
                               
                              ],
                            ),
                            pw.SizedBox(height: 4),
                            pw.Row(children: [
                              
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Signature
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.SizedBox(height: 20),
                            pw.Text(
                              '- Signature -',
                              style: pw.TextStyle(
                                fontSize: 14,
                                fontStyle: pw.FontStyle.italic,
                                color: PdfColors.black,
                              ),
                            ),
                            pw.SizedBox(height: 4),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Questions Section
            pw.Padding(
              padding: const pw.EdgeInsets.all(16.0),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [pw.SizedBox(height: 8)],
              ),
            ),
          ],
        ),
      );

      final pdfBytes = await pdf.save();
      return pdfBytes;
    } catch (e) {
      debugPrint('Error generating PDF: $e');
      rethrow;
    } finally {
      setState(() {
        _isGeneratingPdf = false;
      });
    }
  }

  // Implementation of share PDF functionality
  Future<void> _sharePdf() async {
    try {
      final pdfBytes = await _generatePdf();
      final tempDir = await getTemporaryDirectory();
      final invoice = widget.invoice;
      final invoiceFileName =
          'Invoice_${_generateInvoiceNumber(invoice.id)}.pdf';
      final file = File('${tempDir.path}/$invoiceFileName');
      await file.writeAsBytes(pdfBytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text:
            'Please find attached invoice ${_generateInvoiceNumber(invoice.id)}',
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error sharing PDF: $e')));
    }
  }

  // Implementation of download PDF functionality
  Future<void> _downloadPdf() async {
    try {
      final pdfBytes = await _generatePdf();
      final directory = await getApplicationDocumentsDirectory();
      final invoice = widget.invoice;
      final invoiceFileName =
          'Invoice_${_generateInvoiceNumber(invoice.id)}.pdf';
      final file = File('${directory.path}/$invoiceFileName');
      await file.writeAsBytes(pdfBytes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invoice saved to ${file.path}'),
          action: SnackBarAction(label: 'View', onPressed: () async {}),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error downloading PDF: $e')));
    }
  }
}
