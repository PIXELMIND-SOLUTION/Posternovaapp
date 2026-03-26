// business_card_form_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

import 'package:posternova/helper/storage_helper.dart';

class BusinessCardFormScreen extends StatefulWidget {
  final String templateId;

  const BusinessCardFormScreen({super.key, required this.templateId});

  @override
  State<BusinessCardFormScreen> createState() => _BusinessCardFormScreenState();
}

class _BusinessCardFormScreenState extends State<BusinessCardFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _titleController = TextEditingController();
  final _companyController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _websiteController = TextEditingController();

  File? _logoFile;
  bool _submitting = false;

  final List<Map<String, TextEditingController>> _socialLinks = [
    {
      'platform': TextEditingController(text: 'linkedin'),
      'url': TextEditingController(),
    },
    {
      'platform': TextEditingController(text: 'twitter'),
      'url': TextEditingController(),
    },
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _companyController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _websiteController.dispose();
    for (final link in _socialLinks) {
      link['platform']!.dispose();
      link['url']!.dispose();
    }
    super.dispose();
  }

  Future<void> _pickLogo() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() => _logoFile = File(picked.path));
    }
  }

  void _addSocialLink() {
    setState(() {
      _socialLinks.add({
        'platform': TextEditingController(),
        'url': TextEditingController(),
      });
    });
  }

  void _removeSocialLink(int index) {
    setState(() {
      _socialLinks[index]['platform']!.dispose();
      _socialLinks[index]['url']!.dispose();
      _socialLinks.removeAt(index);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_logoFile == null) {
      _showSnack('Please select a logo image');
      return;
    }

    setState(() => _submitting = true);

    try {
      final userData = await AuthPreferences.getUserData();
      final userId = userData?.user.id;

      final uri = Uri.parse(
        'http://31.97.206.144:4061/api/users/addbusinessdetails/$userId',
      );

      final request = http.MultipartRequest('POST', uri);

      request.fields['name'] = _nameController.text.trim();
      request.fields['title'] = _titleController.text.trim();
      request.fields['company'] = _companyController.text.trim();
      request.fields['email'] = _emailController.text.trim();
      request.fields['phone'] = _phoneController.text.trim();
      request.fields['address'] = _addressController.text.trim();
      request.fields['website'] = _websiteController.text.trim();
      request.fields['templateId'] = widget.templateId;

      // Social links as JSON string
      final socialLinksJson = jsonEncode(
        _socialLinks
            .where(
              (l) =>
                  l['platform']!.text.trim().isNotEmpty &&
                  l['url']!.text.trim().isNotEmpty,
            )
            .map(
              (l) => {
                'platform': l['platform']!.text.trim(),
                'url': l['url']!.text.trim(),
              },
            )
            .toList(),
      );
      request.fields['socialLinks'] = socialLinksJson;

      request.files.add(
        await http.MultipartFile.fromPath('logo', _logoFile!.path),
      );

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => BusinessCardResultScreen(
                userId: userId.toString(),
                templateId: widget.templateId,
              ),
            ),
          );
        }
      } else {
        _showSnack(data['message'] ?? 'Submission failed');
      }
    } catch (e) {
      _showSnack('Error: $e');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Business Card Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFEEEEEE), height: 1),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo picker
              _sectionLabel('Logo *'),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickLogo,
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _logoFile == null
                          ? const Color(0xFFDDDDDD)
                          : Colors.blue,
                      width: 1.5,
                    ),
                  ),
                  child: _logoFile == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 32,
                              color: Colors.blue,
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Tap to select logo',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(_logoFile!, fit: BoxFit.contain),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // Basic fields
              _sectionLabel('Personal Info'),
              const SizedBox(height: 12),
              _field(
                controller: _nameController,
                label: 'Full Name',
                hint: 'John Doe',
              ),
              _field(
                controller: _titleController,
                label: 'Title / Role',
                hint: 'Developer',
              ),
              _field(
                controller: _companyController,
                label: 'Company',
                hint: 'Google',
              ),
              _field(
                controller: _emailController,
                label: 'Email',
                hint: 'john@gmail.com',
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Email is required';
                  if (!v.contains('@')) return 'Enter a valid email';
                  return null;
                },
              ),
              _field(
                controller: _phoneController,
                label: 'Phone',
                hint: '9999999999',
                keyboardType: TextInputType.phone,
              ),
              _field(
                controller: _addressController,
                label: 'Address',
                hint: 'India',
              ),
              _field(
                controller: _websiteController,
                label: 'Website',
                hint: 'https://google.com',
                keyboardType: TextInputType.url,
                required: false,
              ),

              const SizedBox(height: 20),

              // Social links
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _sectionLabel('Social Links'),
                  TextButton.icon(
                    onPressed: _addSocialLink,
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add', style: TextStyle(fontSize: 13)),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ..._socialLinks.asMap().entries.map((e) {
                final i = e.key;
                final link = e.value;
                return _socialLinkRow(i, link);
              }),

              const SizedBox(height: 32),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: _submitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'Generate Business Card',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool required = true,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black26, fontSize: 13),
          labelStyle: const TextStyle(fontSize: 13, color: Colors.black54),
          filled: true,
          fillColor: const Color(0xFFF8F8F8),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.blue, width: 1.5),
          ),
        ),
        validator:
            validator ??
            (required
                ? (v) => (v == null || v.trim().isEmpty)
                      ? '$label is required'
                      : null
                : null),
      ),
    );
  }

  Widget _socialLinkRow(int index, Map<String, TextEditingController> link) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: link['platform'],
              decoration: _miniDeco('Platform', 'linkedin'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 5,
            child: TextFormField(
              controller: link['url'],
              keyboardType: TextInputType.url,
              decoration: _miniDeco('URL', 'https://...'),
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () => _removeSocialLink(index),
            child: const Icon(
              Icons.remove_circle_outline,
              color: Colors.red,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _miniDeco(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      isDense: true,
      hintStyle: const TextStyle(fontSize: 11, color: Colors.black26),
      labelStyle: const TextStyle(fontSize: 11, color: Colors.black45),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.blue),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// business_card_result_screen.dart
// ─────────────────────────────────────────────────────────────────────────────

class BusinessCardResultScreen extends StatefulWidget {
  final String userId;
  final String templateId;

  const BusinessCardResultScreen({
    super.key,
    required this.userId,
    required this.templateId,
  });

  @override
  State<BusinessCardResultScreen> createState() =>
      _BusinessCardResultScreenState();
}

class _BusinessCardResultScreenState extends State<BusinessCardResultScreen> {
  bool _loading = true;
  String? _error;
  String? _overlaidImage;
  String? _overlaidPdf;

  @override
  void initState() {
    super.initState();
    _fetchResult();
  }

  Future<void> _fetchResult() async {
    try {
      final uri = Uri.parse(
        'http://31.97.206.144:4061/api/users/getsinglebusinesscards'
        '/${widget.userId}/${widget.templateId}',
      );
      final response = await http.get(uri);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        setState(() {
          _overlaidImage = data['overlaidImage'] as String?;
          _overlaidPdf = data['overlaidPdf'] as String?;
          _loading = false;
        });
      } else {
        setState(() {
          _error = data['message'] ?? 'Failed to load result';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _loading = false;
      });
    }
  }

  Future<void> _downloadPdf() async {
    if (_overlaidPdf == null) return;

    try {
      // Launch URL — add url_launcher to pubspec if not already present
      // await launchUrl(Uri.parse(_overlaidPdf!));

      // Simple fallback: show snack with URL
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF: $_overlaidPdf'),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(label: 'OK', onPressed: () {}),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not open PDF: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Your Business Card',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFEEEEEE), height: 1),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? _buildError()
          : _buildResult(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 56, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _loading = true;
                  _error = null;
                });
                _fetchResult();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResult() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Success badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 18),
                SizedBox(width: 6),
                Text(
                  'Your card is ready!',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Card preview
          if (_overlaidImage != null) ...[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Preview',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  _overlaidImage!,
                  fit: BoxFit.contain,
                  loadingBuilder: (_, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      height: 220,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          value: progress.expectedTotalBytes != null
                              ? progress.cumulativeBytesLoaded /
                                    progress.expectedTotalBytes!
                              : null,
                          color: Colors.blue,
                          strokeWidth: 2.5,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    height: 220,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 48,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(height: 28),

          // Action buttons
          if (_overlaidPdf != null)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _downloadPdf,
                icon: const Icon(Icons.picture_as_pdf_outlined, size: 20),
                label: const Text(
                  'Download PDF',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
              ),
            ),

          const SizedBox(height: 12),

          // Go back to browse more
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
              icon: const Icon(Icons.grid_view_rounded, size: 18),
              label: const Text(
                'Browse More Templates',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue,
                side: const BorderSide(color: Colors.blue, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
