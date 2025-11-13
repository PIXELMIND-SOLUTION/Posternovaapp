import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({super.key});

  @override
  State<UserDetails> createState() => _AddUserDataState();
}

class _AddUserDataState extends State<UserDetails> {
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;
  final picker = ImagePicker();

  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController gstController = TextEditingController();

  String? selectedBusinessType;
  bool _isSaving = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    businessNameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    gstController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = basename(pickedFile.path);
      final savedImage =
          await File(pickedFile.path).copy('${directory.path}/$fileName');

      setState(() {
        _imageFile = savedImage;
      });
    }
  }

  Future<void> _saveData() async {
    setState(() => _isSaving = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('businessName', businessNameController.text);
    await prefs.setString('mobile', mobileController.text);
    await prefs.setString('email', emailController.text);
    await prefs.setString('gst', gstController.text);
    if (_imageFile != null) {
      await prefs.setString('imagePath', _imageFile!.path);
    }
    if (selectedBusinessType != null) {
      await prefs.setString('businessType', selectedBusinessType!);
    }
    setState(() => _isSaving = false);
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    businessNameController.text = prefs.getString('businessName') ?? '';
    mobileController.text = prefs.getString('mobile') ?? '';
    emailController.text = prefs.getString('email') ?? '';
    gstController.text = prefs.getString('gst') ?? '';
    selectedBusinessType = prefs.getString('businessType');

    final imagePath = prefs.getString('imagePath');
    if (imagePath != null && File(imagePath).existsSync()) {
      setState(() {
        _imageFile = File(imagePath);
      });
    }
    
    setState(() => _isLoading = false);
  }

  InputDecoration _inputDecoration(String label, IconData icon, BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDarkMode ? const Color(0xFF4A9EFF) : const Color(0xFF3498DB);
    
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Theme.of(context).hintColor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: Icon(
        icon,
        color: accentColor.withOpacity(0.7),
        size: 20,
      ),
      filled: true,
      fillColor: isDarkMode 
          ? const Color(0xFF1E1E1E) 
          : Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDarkMode 
              ? Colors.grey.withOpacity(0.2)
              : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDarkMode 
              ? Colors.grey.withOpacity(0.2)
              : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: accentColor,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F7FA);
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF2C3E50);
    final secondaryTextColor = isDarkMode ? const Color(0xFFB0B0B0) : const Color(0xFF7F8C8D);
    final accentColor = isDarkMode ? const Color(0xFF4A9EFF) : const Color(0xFF3498DB);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.arrow_back,
              color: accentColor,
              size: 20,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Business Profile',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: textColor,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDarkMode
                              ? Colors.black.withOpacity(0.3)
                              : Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      accentColor.withOpacity(0.3),
                                      accentColor.withOpacity(0.1),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: accentColor.withOpacity(0.2),
                                      blurRadius: 15,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: ClipOval(
                                    child: _imageFile != null
                                        ? Image.file(
                                            _imageFile!,
                                            fit: BoxFit.cover,
                                            width: 122,
                                            height: 122,
                                          )
                                        : Container(
                                            color: isDarkMode
                                                ? const Color(0xFF2A2A2A)
                                                : Colors.grey[100],
                                            child: Icon(
                                              Icons.store,
                                              size: 60,
                                              color: accentColor.withOpacity(0.5),
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Material(
                                  elevation: 4,
                                  shape: const CircleBorder(),
                                  child: Container(
                                    height: 44,
                                    width: 44,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          accentColor,
                                          accentColor.withOpacity(0.8),
                                        ],
                                      ),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.camera_alt_rounded,
                                        size: 20,
                                      ),
                                      color: Colors.white,
                                      onPressed: _pickImage,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Add Business Logo',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Upload your business logo or brand image',
                            style: TextStyle(
                              fontSize: 12,
                              color: secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: accentColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.business_center,
                                  color: accentColor,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Business Details',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: businessNameController,
                            decoration: _inputDecoration(
                              'Business Name',
                              Icons.store_outlined,
                              context,
                            ),
                            validator: (value) =>
                                value!.isEmpty ? 'Please enter business name' : null,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: selectedBusinessType,
                            items: ['Gold Shop', 'Retail Store', 'Service Provider', 'Others']
                                .map((type) => DropdownMenuItem<String>(
                                      value: type,
                                      child: Text(
                                        type,
                                        style: TextStyle(
                                          color: textColor,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            decoration: _inputDecoration(
                              'Business Type',
                              Icons.category_outlined,
                              context,
                            ),
                            onChanged: (value) {
                              setState(() {
                                selectedBusinessType = value;
                              });
                            },
                            validator: (value) =>
                                value == null ? 'Please select business type' : null,
                            dropdownColor: cardColor,
                            icon: Icon(
                              Icons.arrow_drop_down_rounded,
                              color: accentColor.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: accentColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.contact_mail,
                                  color: accentColor,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Contact Information',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: mobileController,
                            decoration: _inputDecoration(
                              'Mobile Number',
                              Icons.phone_outlined,
                              context,
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) =>
                                value!.isEmpty ? 'Please enter mobile number' : null,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: emailController,
                            decoration: _inputDecoration(
                              'Email Address',
                              Icons.email_outlined,
                              context,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter email address';
                              }
                              if (!value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                            style: TextStyle(
                              color: textColor,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: gstController,
                            decoration: _inputDecoration(
                              'GST Number (Optional)',
                              Icons.receipt_long_outlined,
                              context,
                            ),
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.characters,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: _isSaving
                                  ? null
                                  : () async {
                                      if (_formKey.currentState!.validate()) {
                                        await _saveData();
                                        if (mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Row(
                                                children: [
                                                  Icon(
                                                    Icons.check_circle,
                                                    color: Colors.white,
                                                  ),
                                                  const SizedBox(width: 12),
                                                  const Text(
                                                    'Profile saved successfully!',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              behavior: SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              backgroundColor: Colors.green[600],
                                              margin: const EdgeInsets.all(16),
                                            ),
                                          );
                                        }
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentColor,
                                foregroundColor: Colors.white,
                                elevation: 2,
                                shadowColor: accentColor.withOpacity(0.3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                disabledBackgroundColor: accentColor.withOpacity(0.6),
                              ),
                              child: _isSaving
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.save_outlined, size: 20),
                                        SizedBox(width: 8),
                                        Text(
                                          'Save Profile',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}