import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:posternova/providers/auth/login_provider.dart';
import 'dart:io';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final _dobController = TextEditingController();
  final _anniversaryController = TextEditingController();
  
  bool _isLoading = true;
  bool _isSaving = false;
  String? _profileImageUrl;
  File? _selectedImage;
  String? _name;
  String? _email;
  String? _mobile;
  
  final String _baseUrl = 'http://194.164.148.244:4061/api/users';

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.user?.user.id;

    if (userId == null) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('User not logged in');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/get-profile/$userId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _name = data['name'] ?? '';
          _email = data['email'] ?? '';
          _mobile = data['mobile'] ?? '';
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      // Upload image immediately using AuthProvider
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.user?.user.id;

      if (userId != null) {
        final success = await authProvider.uploadProfileImage(
          userId,
          pickedFile.path,
        );

        if (success) {
          setState(() {
            _profileImageUrl = authProvider.user?.user.profileImage;
          });
          _showSuccessSnackBar('Profile image updated successfully');
        } else {
          setState(() {
            _selectedImage = null;
          });
          _showErrorSnackBar(authProvider.error ?? 'Failed to upload image');
        }
      }
    }
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        controller.text = 
            '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}';
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.user?.user.id;

    if (userId == null) {
      _showErrorSnackBar('User not logged in');
      return;
    }

    setState(() => _isSaving = true);

    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('$_baseUrl/edit-profile'),
      );

      request.fields['userId'] = userId;
      request.fields['dob'] = _dobController.text;
      request.fields['marriageAnniversaryDate'] = _anniversaryController.text;

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        _showSuccessSnackBar('Profile updated successfully');
        Navigator.pop(context, true);
      } else {
        throw Exception('Failed to update profile: $responseBody');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to update profile: $e');
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Edit Profile',style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildProfileHeader(authProvider),
                      _buildForm(),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildProfileHeader(AuthProvider authProvider) {
    final isUploading = authProvider.isLoading;
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple, Colors.deepPurple.shade300],
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
                    border: Border.all(color: Colors.white, width: 4),
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
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : (_profileImageUrl != null
                            ? NetworkImage(_profileImageUrl!)
                            : null) as ImageProvider?,
                    child: _selectedImage == null && _profileImageUrl == null
                        ? const Icon(Icons.person, size: 60, color: Colors.grey)
                        : (isUploading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
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
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.deepPurple,
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isUploading ? 'Uploading...' : 'Tap to change photo',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Personal Information'),
            const SizedBox(height: 16),
            _buildReadOnlyField(
              label: 'Full Name',
              value: _name ?? '',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            _buildReadOnlyField(
              label: 'Email',
              value: _email ?? '',
              icon: Icons.email_outlined,
            ),
            const SizedBox(height: 16),
            _buildReadOnlyField(
              label: 'Mobile Number',
              value: _mobile ?? '',
              icon: Icons.phone_outlined,
            ),
            // const SizedBox(height: 24),
            // _buildSectionTitle('Important Dates'),
            // const SizedBox(height: 16),
            // _buildDateField(
            //   controller: _dobController,
            //   label: 'Date of Birth',
            //   icon: Icons.cake_outlined,
            // ),
            // const SizedBox(height: 16),
            // _buildDateField(
            //   controller: _anniversaryController,
            //   label: 'Marriage Anniversary',
            //   icon: Icons.favorite_outline,
            // ),
            const SizedBox(height: 32),
            // SizedBox(
            //   width: double.infinity,
            //   height: 54,
            //   child: ElevatedButton(
            //     onPressed: _isSaving ? null : _saveProfile,
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.deepPurple,
            //       foregroundColor: Colors.white,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(12),
            //       ),
            //       elevation: 2,
            //     ),
            //     child: _isSaving
            //         ? const SizedBox(
            //             height: 24,
            //             width: 24,
            //             child: CircularProgressIndicator(
            //               color: Colors.white,
            //               strokeWidth: 2,
            //             ),
            //           )
            //         : const Text(
            //             'Save Changes',
            //             style: TextStyle(
            //               fontSize: 16,
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //   ),
            // ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.grey[600]),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.lock_outline,
          color: Colors.grey[400],
          size: 20,
        ),
      ),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () => _selectDate(controller),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        suffixIcon: const Icon(Icons.calendar_today, color: Colors.deepPurple),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  @override
  void dispose() {
    _dobController.dispose();
    _anniversaryController.dispose();
    super.dispose();
  }
}