import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:image_picker/image_picker.dart';
import 'package:posternova/helper/storage_helper.dart';
import 'package:posternova/providers/auth/login_provider.dart';
import 'package:posternova/views/ProfileScreen/cropper.dart';
import 'package:posternova/widgets/language_widget.dart';
import 'package:provider/provider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:path_provider/path_provider.dart';

// ---------------------------------------------------------------------------
// Inline Cropper Screen — returns the cropped File via Navigator.pop(context, file)
// ---------------------------------------------------------------------------
class _ProfileImageCropperScreen extends StatefulWidget {
  final File imageFile;
  const _ProfileImageCropperScreen({required this.imageFile});

  @override
  State<_ProfileImageCropperScreen> createState() =>
      _ProfileImageCropperScreenState();
}

class _ProfileImageCropperScreenState
    extends State<_ProfileImageCropperScreen> {
  final GlobalKey<ExtendedImageEditorState> _editorKey =
      GlobalKey<ExtendedImageEditorState>();

  double? _aspectRatio;
  Map<String, double> _aspectRatios = {};

  bool get _isDarkMode => Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();
    _loadOriginalImageSize();
  }

  Future<void> _loadOriginalImageSize() async {
    final data = await widget.imageFile.readAsBytes();
    final decodedImage = await decodeImageFromList(data);
    final originalRatio =
        decodedImage.width.toDouble() / decodedImage.height.toDouble();

    if (!mounted) return;
    setState(() {
      _aspectRatios = {
        'Original': originalRatio,
        '1:1': 1.0,
        '16:9': 16 / 9,
        '9:16': 9 / 16,
        '4:3': 4 / 3,
        '3:4': 3 / 4,
      };
      _aspectRatio = originalRatio;
    });
  }

  Future<void> _cropAndReturn() async {
    final state = _editorKey.currentState;
    if (state == null) return;

    final Uint8List? croppedData = await _cropImageData(state);
    if (croppedData == null) return;

    final tempDir = await getTemporaryDirectory();
    final filePath =
        '${tempDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File(filePath);
    await file.writeAsBytes(croppedData);

    if (mounted) Navigator.pop(context, file);
  }

  Future<Uint8List?> _cropImageData(ExtendedImageEditorState state) async {
    final Rect cropRect = state.getCropRect()!;
    final Uint8List data = state.rawImageData!;
    final ui.Image image = await decodeImageFromList(data);

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawImageRect(
      image,
      cropRect,
      Rect.fromLTWH(0, 0, cropRect.width, cropRect.height),
      Paint(),
    );

    final picture = recorder.endRecording();
    final ui.Image croppedImage = await picture.toImage(
      cropRect.width.toInt(),
      cropRect.height.toInt(),
    );

    final byteData = await croppedImage.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return byteData?.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = _isDarkMode;

    if (_aspectRatios.isEmpty) {
      return Scaffold(
        backgroundColor: isDarkMode ? const Color(0xFF0F172A) : Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: const Color(0xFFF5C518)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0F172A) : Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5C518),
        foregroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Navigator.pop(context, null),
        ),
        title: const Text(
          'Crop Photo',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton.icon(
            onPressed: _cropAndReturn,
            icon: const Icon(Icons.check, color: Colors.black87),
            label: const Text(
              'Use Photo',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ExtendedImage.file(
                widget.imageFile,
                fit: BoxFit.contain,
                mode: ExtendedImageMode.editor,
                extendedImageEditorKey: _editorKey,
                initEditorConfigHandler: (_) => EditorConfig(
                  maxScale: 8.0,
                  cropRectPadding: const EdgeInsets.all(20.0),
                  hitTestSize: 20.0,
                  cropAspectRatio: _aspectRatio == 0.0 ? null : _aspectRatio,
                ),
                cacheRawData: true,
              ),
            ),
            _buildAspectRatioBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildAspectRatioBar() {
    final isDarkMode = _isDarkMode;

    return Container(
      height: 80,
      color: isDarkMode ? const Color(0xFF1E293B) : Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: _aspectRatios.entries.map((entry) {
          final selected = _aspectRatio == entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: ChoiceChip(
              label: Text(entry.key),
              selected: selected,
              onSelected: (_) => setState(() => _aspectRatio = entry.value),
              selectedColor: const Color(0xFFF5C518),
              backgroundColor: isDarkMode
                  ? const Color(0xFF0F172A)
                  : Colors.grey[800],
              labelStyle: TextStyle(
                color: selected
                    ? Colors.black87
                    : (isDarkMode ? Colors.grey[300] : Colors.grey[300]),
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// EditProfile
// ---------------------------------------------------------------------------
class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _dobController = TextEditingController();
  final _anniversaryController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  String? _profileImageUrl;
  File? _selectedImage;

  final String _baseUrl = 'http://31.97.228.17:4061/api/users';

  bool get _isDarkMode => Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      String? userId = authProvider.user?.user.id;

      if (userId == null) {
        final userData = await AuthPreferences.getUserData();
        userId = userData?.user.id;
      }

      if (userId == null) {
        setState(() => _isLoading = false);
        _showErrorSnackBar('User not logged in');
        return;
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/get-profile/$userId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _nameController.text = data['name'] ?? '';
          _emailController.text = data['email'] ?? '';
          _mobileController.text = data['mobile'] ?? '';
          _dobController.text = data['dob'] ?? '';
          _anniversaryController.text = data['marriageAnniversaryDate'] ?? '';
          _profileImageUrl = data['profileImage'];
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Failed to load profile: $e');
    }
  }

  // Future<void> _pickImage() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(
  //     source: ImageSource.gallery,
  //     maxWidth: 1024,
  //     maxHeight: 1024,
  //     imageQuality: 85,
  //   );

  //   if (pickedFile == null) return;

  //   final File? croppedFile = await Navigator.push<File?>(
  //     context,
  //     MaterialPageRoute(
  //       builder: (_) =>
  //           _ProfileImageCropperScreen(imageFile: File(pickedFile.path)),
  //     ),
  //   );

  //   if (croppedFile == null) return;

  //   setState(() => _selectedImage = croppedFile);

  //   final authProvider = Provider.of<AuthProvider>(context, listen: false);
  //   final userId = authProvider.user?.user.id;
  //   if (userId == null) return;

  //   final success = await authProvider.uploadProfileImage(
  //     userId,
  //     croppedFile.path,
  //   );

  //   if (success) {
  //     setState(() {
  //       _profileImageUrl = authProvider.user?.user.profileImage;
  //     });
  //     _showSuccessSnackBar('Profile image updated successfully');
  //   } else {
  //     setState(() => _selectedImage = null);
  //     _showErrorSnackBar(authProvider.error ?? 'Failed to upload image');
  //   }
  // }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (pickedFile == null) return;

    // Use the updated CropperScreen
    final File? croppedFile = await Navigator.push<File?>(
      context,
      MaterialPageRoute(
        builder: (_) => CropperScreen(imageFile: File(pickedFile.path)),
      ),
    );

    if (croppedFile == null) return; // User cancelled cropping

    setState(() => _selectedImage = croppedFile);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.user?.user.id;
    if (userId == null) return;

    final success = await authProvider.uploadProfileImage(
      userId,
      croppedFile.path,
    );

    if (success) {
      setState(() {
        _profileImageUrl = authProvider.user?.user.profileImage;
      });
      _showSuccessSnackBar('Profile image updated successfully');
    } else {
      setState(() => _selectedImage = null);
      _showErrorSnackBar(authProvider.error ?? 'Failed to upload image');
    }
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final isDarkMode = _isDarkMode;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFF5C518),
              onPrimary: Colors.black87,
              surface: Color(0xFF1E293B),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: isDarkMode
                ? const Color(0xFF1E293B)
                : Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        controller.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.user?.user.id;

    if (userId == null) {
      _showErrorSnackBar('User not logged in');
      return;
    }

    final originalName = authProvider.user?.user.name ?? '';
    final originalEmail = authProvider.user?.user.email ?? '';
    final originalDob = _dobController.text.trim();
    final originalAnniversary = _anniversaryController.text.trim();

    setState(() => _isSaving = true);

    try {
      final response = await http.put(
        Uri.parse('http://31.97.228.17:4061/api/users/update-user/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'mobile': _mobileController.text.trim(),
          'dob': _dobController.text.trim(),
          'marriageAnniversaryDate': _anniversaryController.text.trim(),
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        await authProvider.refreshUserData();
        if (!mounted) return;

        setState(() => _isSaving = false);

        final List<String> updatedFields = [];
        if (_nameController.text.trim() != originalName)
          updatedFields.add('Name');
        if (_emailController.text.trim() != originalEmail)
          updatedFields.add('Email');
        if (_dobController.text.trim() != originalDob)
          updatedFields.add('Date of birth');
        if (_anniversaryController.text.trim() != originalAnniversary)
          updatedFields.add('Anniversary date');

        final message = updatedFields.isNotEmpty
            ? '${updatedFields.join(', ')} updated successfully'
            : 'Profile updated successfully';

        _showSuccessSnackBar(message);
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) Navigator.pop(context, true);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        _showErrorSnackBar('Failed to update profile: $e');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    final isDarkMode = _isDarkMode;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.white),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    final isDarkMode = _isDarkMode;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.white),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = _isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0F172A) : Colors.grey[50],
      appBar: AppBar(
        title: const AppText(
          'edit_profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 48, 81, 217),
        foregroundColor: Colors.black87,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: const Color.fromARGB(255, 48, 81, 217)),
            )
          : Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return SingleChildScrollView(
                  child: Column(
                    children: [_buildProfileHeader(authProvider), _buildForm()],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildProfileHeader(AuthProvider authProvider) {
    final isDarkMode = _isDarkMode;
    final isUploading = authProvider.isLoading;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
              : [
                  const Color.fromARGB(255, 48, 81, 217),
                  const Color.fromARGB(255, 48, 81, 217),
                ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          GestureDetector(
            onTap: isUploading ? null : _pickImage,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDarkMode
                          ? const Color.fromARGB(255, 48, 81, 217)
                          : Colors.white,
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: isDarkMode
                        ? const Color(0xFF1E293B)
                        : Colors.grey[300],
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : (_profileImageUrl != null
                                  ? NetworkImage(_profileImageUrl!)
                                  : null)
                              as ImageProvider?,
                    child: _selectedImage == null && _profileImageUrl == null
                        ? Icon(
                            Icons.person,
                            size: 60,
                            color: isDarkMode ? Colors.grey[600] : Colors.grey,
                          )
                        : (isUploading
                              ? const CircularProgressIndicator(
                                  color: const Color.fromARGB(255, 48, 81, 217),
                                  strokeWidth: 3,
                                )
                              : null),
                  ),
                ),
                if (!isUploading)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? const Color(0xFF1E293B)
                            : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: isDarkMode
                            ? const Color.fromARGB(255, 48, 81, 217)
                            : const Color.fromARGB(255, 48, 81, 217),
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppText(
            isUploading ? 'Uploading...' : 'tap_change_photo',
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black87,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildForm() {
    final isDarkMode = _isDarkMode;

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('personal_information'),
            const SizedBox(height: 16),
            _buildEditableField(
              controller: _nameController,
              label: 'business_name',
              icon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildEditableField(
              controller: _emailController,
              label: 'email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                ).hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildEditableField(
              controller: _mobileController,
              label: 'mobile_number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              readOnly: true,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your mobile number';
                }
                if (value.length < 10) {
                  return 'Please enter a valid mobile number';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('important_dates'),
            const SizedBox(height: 16),
            _buildDateField(
              controller: _dobController,
              label: 'date_of_birth',
              icon: Icons.cake_outlined,
            ),
            const SizedBox(height: 16),
            _buildDateField(
              controller: _anniversaryController,
              label: 'marriage_anniversary',
              icon: Icons.favorite_outline,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 48, 81, 217),
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  disabledBackgroundColor: const Color(
                    0xFFF5C518,
                  ).withOpacity(0.6),
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.black87,
                          strokeWidth: 2,
                        ),
                      )
                    : const AppText(
                        'update_profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    final isDarkMode = _isDarkMode;

    return AppText(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: isDarkMode ? Colors.white : Colors.black87,
      ),
    );
  }

  Widget _buildEditableField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool readOnly = false,
  }) {
    final isDarkMode = _isDarkMode;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      readOnly: readOnly,
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        labelText: AppText.translate(context, label),
        labelStyle: TextStyle(
          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
        ),
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 48, 81, 217)),
        suffixIcon: readOnly
            ? Icon(
                Icons.lock,
                color: isDarkMode ? Colors.grey[600] : Colors.grey,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF5C518), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    final isDarkMode = _isDarkMode;

    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () => _selectDate(controller),
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        labelText: AppText.translate(context, label),
        labelStyle: TextStyle(
          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
        ),
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 48, 81, 217)),
        suffixIcon: const Icon(Icons.calendar_today, color: const Color.fromARGB(255, 48, 81, 217)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: const Color.fromARGB(255, 48, 81, 217), width: 2),
        ),
        filled: true,
        fillColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _dobController.dispose();
    _anniversaryController.dispose();
    super.dispose();
  }
}
