// business_card_form_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

import 'package:posternova/helper/storage_helper.dart';
import 'package:posternova/views/business/business_details.dart';

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

  bool get _isDarkMode => Theme.of(context).brightness == Brightness.dark;

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
        'http://82.29.162.67:4061/api/users/addbusinessdetails/$userId',
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
      print("yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy${response.body}");

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
    final isDarkMode = _isDarkMode;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
        ),
        backgroundColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = _isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0F172A) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
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
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: isDarkMode
                ? const Color(0xFF334155)
                : const Color(0xFFEEEEEE),
            height: 1,
          ),
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
                    color: isDarkMode
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _logoFile == null
                          ? (isDarkMode
                                ? const Color(0xFF334155)
                                : const Color(0xFFDDDDDD))
                          : const Color(0xFFF5C518),
                      width: 1.5,
                    ),
                  ),
                  child: _logoFile == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 32,
                              color: const Color(0xFFF5C518),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Tap to select logo',
                              style: TextStyle(
                                color: const Color(0xFFF5C518),
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
                      foregroundColor: const Color(0xFFF5C518),
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
                    backgroundColor: const Color(0xFFF5C518),
                    foregroundColor: Colors.black87,
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
                            color: Colors.black87,
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
    final isDarkMode = _isDarkMode;

    return Text(
      text,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: isDarkMode ? Colors.white : Colors.black87,
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
    final isDarkMode = _isDarkMode;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(
            color: isDarkMode ? Colors.grey[500] : Colors.black26,
            fontSize: 13,
          ),
          labelStyle: TextStyle(
            fontSize: 13,
            color: isDarkMode ? Colors.grey[400] : Colors.black54,
          ),
          filled: true,
          fillColor: isDarkMode
              ? const Color(0xFF1E293B)
              : const Color(0xFFF8F8F8),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: isDarkMode
                  ? const Color(0xFF334155)
                  : const Color(0xFFDDDDDD),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: isDarkMode
                  ? const Color(0xFF334155)
                  : const Color(0xFFDDDDDD),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFF5C518), width: 1.5),
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
    final isDarkMode = _isDarkMode;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF334155) : const Color(0xFFEEEEEE),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: link['platform'],
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              decoration: _miniDeco('Platform', 'linkedin'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 5,
            child: TextFormField(
              controller: link['url'],
              keyboardType: TextInputType.url,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              decoration: _miniDeco('URL', 'https://...'),
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () => _removeSocialLink(index),
            child: Icon(
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
    final isDarkMode = _isDarkMode;

    return InputDecoration(
      labelText: label,
      hintText: hint,
      isDense: true,
      hintStyle: TextStyle(
        fontSize: 11,
        color: isDarkMode ? Colors.grey[500] : Colors.black26,
      ),
      labelStyle: TextStyle(
        fontSize: 11,
        color: isDarkMode ? Colors.grey[400] : Colors.black45,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      filled: true,
      fillColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: isDarkMode ? const Color(0xFF334155) : const Color(0xFFDDDDDD),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: isDarkMode ? const Color(0xFF334155) : const Color(0xFFDDDDDD),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFF5C518)),
      ),
    );
  }
}
