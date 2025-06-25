import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import '../models/models.dart';
import '../services/services.dart';
import '../constants/app_constants.dart';
import '../utils/app_utils.dart';
import '../screens/paypal_screen.dart';

class ProfilePage extends StatefulWidget {
  final UserResponse currentUser;

  const ProfilePage({super.key, required this.currentUser});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  final UserService _userService = UserService();
  final ProfilePictureService _profilePictureService = ProfilePictureService();
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  bool _isSaving = false;
  bool _passwordVisible = false;
  bool _hasChanges = false;
  String? _passwordError;

  UserResponse? _currentUserData;

  String _originalEmail = '';
  String _originalPhone = '';
  String _originalPassword = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _emailController.addListener(_onFieldChanged);
    _passwordController.addListener(_onFieldChanged);
    _phoneController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    final hasEmailChanged = _emailController.text.trim() != _originalEmail;
    final hasPhoneChanged = _phoneController.text.trim() != _originalPhone;
    final hasPasswordChanged =
        _passwordController.text.trim().isNotEmpty &&
        _passwordController.text.trim() != _originalPassword;

    _validatePassword();

    final hasAnyChanges =
        hasEmailChanged || hasPhoneChanged || hasPasswordChanged;

    if (_hasChanges != hasAnyChanges) {
      setState(() {
        _hasChanges = hasAnyChanges;
      });
    }
  }

  void _validatePassword() {
    final password = _passwordController.text.trim();
    String? error;

    if (password.isNotEmpty) {
      if (password.length < 6) {
        error = 'Lozinka mora imati najmanje 6 karaktera';
      } else if (password.length > 100) {
        error = 'Lozinka može imati najviše 100 karaktera';
      }
    }

    if (_passwordError != error) {
      setState(() {
        _passwordError = error;
      });
    }
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userData = await _userService.getUserById(widget.currentUser.id);

      if (userData != null) {
        setState(() {
          _currentUserData = userData;
          _originalEmail = userData.email;
          _originalPhone = userData.phoneNumber;
          _originalPassword = '';

          _emailController.text = userData.email;
          _phoneController.text = userData.phoneNumber;
          _passwordController.text = '';
          _hasChanges = false;
        });
      }
    } catch (e) {
      if (mounted) {
        AppUtils.showErrorSnackBar(
          context,
          'Greška pri učitavanju korisničkih podataka',
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateProfilePicture() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Kamera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galerija'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              if (_currentUserData?.profilePicture != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text(
                    'Ukloni profilnu sliku',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _deleteProfilePicture();
                  },
                ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Otkaži'),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        final base64String = base64Encode(bytes);

        if (_currentUserData?.profilePicture != null) {
          await _profilePictureService.deleteProfilePicture(
            _currentUserData!.profilePicture!.id,
          );
        }

        final request = CreateProfilePictureRequest(
          userId: widget.currentUser.id,
          base64Data: base64String,
        );

        await _profilePictureService.createProfilePicture(request);

        await _loadUserData();

        if (mounted) {
          AppUtils.showSuccessSnackbar(
            context,
            'Profilna slika je uspješno ažurirana',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        AppUtils.showErrorSnackBar(
          context,
          'Greška pri ažuriranju profilne slike',
        );
      }
    }
  }

  Future<void> _deleteProfilePicture() async {
    if (_currentUserData?.profilePicture == null) return;

    try {
      await _profilePictureService.deleteProfilePicture(
        _currentUserData!.profilePicture!.id,
      );
      await _loadUserData();

      if (mounted) {
        AppUtils.showSuccessSnackbar(
          context,
          'Profilna slika je uspješno uklonjena',
        );
      }
    } catch (e) {
      if (mounted) {
        AppUtils.showErrorSnackBar(
          context,
          'Greška pri uklanjanju profilne slike',
        );
      }
    }
  }

  Future<void> _saveChanges() async {
    if (!_hasChanges) return;

    if (_passwordError != null) {
      AppUtils.showErrorSnackBar(
        context,
        'Molimo ispravite greške prije snimanja promjena',
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final hasEmailChanged = _emailController.text.trim() != _originalEmail;
      final hasPhoneChanged = _phoneController.text.trim() != _originalPhone;
      final hasPasswordChanged =
          _passwordController.text.trim().isNotEmpty &&
          _passwordController.text.trim() != _originalPassword;

      final emailToUpdate = hasEmailChanged
          ? _emailController.text.trim()
          : _currentUserData!.email;

      final phoneToUpdate = hasPhoneChanged
          ? _phoneController.text.trim()
          : _currentUserData!.phoneNumber;

      final request = UpdateUserRequest(
        name: _currentUserData!.name,
        surname: _currentUserData!.surname,
        email: emailToUpdate,
        phoneNumber: phoneToUpdate,
        isRestricted: _currentUserData!.isRestricted,
        roleId: _currentUserData!.role?.id ?? 1,
      );

      await _userService.updateUser(widget.currentUser.id, request);

      if (hasPasswordChanged) {
        final passwordRequest = UpdatePasswordRequest(
          newPassword: _passwordController.text.trim(),
        );

        await _userService.updatePassword(
          widget.currentUser.id,
          passwordRequest,
        );
      }

      await _loadUserData();
      setState(() {
        _hasChanges = false;
        _originalEmail = emailToUpdate;
        _originalPhone = phoneToUpdate;
        if (hasPasswordChanged) {
          _originalPassword = _passwordController.text.trim();
          _passwordController.clear();
          _passwordError = null;
        }
      });

      if (mounted) {
        AppUtils.showSuccessSnackbar(context, 'Podaci su uspješno ažurirani');
      }
    } catch (e) {
      if (mounted) {
        AppUtils.showErrorSnackBar(context, 'Greška pri ažuriranju podataka');
      }
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Odjava'),
          content: const Text('Da li ste sigurni da se želite odjaviti?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Otkaži'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text(
                'Odjavi se',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _currentUserData == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppConstants.primaryBlue),
        ),
      );
    }
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _updateProfilePicture,
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: ClipOval(child: _buildProfilePicture()),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: const BoxDecoration(
                            color: AppConstants.primaryBlue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  _currentUserData!.fullName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryBlue,
                  ),
                ),

                const SizedBox(height: 4),

                if (_currentUserData!.role != null)
                  Text(
                    _currentUserData!.role!.name,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),

                const SizedBox(height: 24),

                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 10),

                _buildTextField(
                  controller: _phoneController,
                  label: 'Telefon',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 10),
                _buildTextField(
                  controller: _passwordController,
                  label: 'Unesite novu lozinku',
                  icon: Icons.lock_outlined,
                  obscureText: !_passwordVisible,
                  errorText: _passwordError,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: _passwordError != null
                          ? Colors.red
                          : Colors.grey[600],
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _hasChanges ? _saveChanges : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _hasChanges
                          ? AppConstants.primaryBlue
                          : Colors.grey.shade400,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadius,
                        ),
                      ),
                      elevation: _hasChanges ? 2 : 0,
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.save, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Sačuvaj promjene',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PayPalScreen(
                            totalAmount: 25.0,
                            currentUser: widget.currentUser,
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppConstants.primaryBlue),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadius,
                        ),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.payment,
                          color: AppConstants.primaryBlue,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Plati članarinu',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppConstants.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _logout,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadius,
                        ),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, color: Colors.red, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Odjavi se',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePicture() {
    if (_currentUserData?.profilePicture?.base64Data != null &&
        _currentUserData!.profilePicture!.base64Data.isNotEmpty) {
      try {
        final base64String = _currentUserData!.profilePicture!.base64Data;
        String cleanBase64 = base64String.trim();

        if (cleanBase64.startsWith('data:')) {
          final commaIndex = cleanBase64.indexOf(',');
          if (commaIndex != -1) {
            cleanBase64 = cleanBase64.substring(commaIndex + 1);
          }
        }

        cleanBase64 = cleanBase64.replaceAll(RegExp(r'\s+'), '');

        while (cleanBase64.length % 4 != 0) {
          cleanBase64 += '=';
        }
        final bytes = base64Decode(cleanBase64);
        if (bytes.isNotEmpty && bytes.length > 500) {
          return Image.memory(
            bytes,
            key: ValueKey(_currentUserData!.profilePicture!.id),
            width: 120,
            height: 120,
            fit: BoxFit.cover,
            gaplessPlayback: true,
            errorBuilder: (context, error, stackTrace) {
              return _buildDefaultProfilePicture();
            },
          );
        }
      } catch (e) {
        return _buildDefaultProfilePicture();
      }
    }
    return _buildDefaultProfilePicture();
  }

  Widget _buildDefaultProfilePicture() {
    return Container(
      width: 120,
      height: 120,
      decoration: const BoxDecoration(
        color: AppConstants.primaryBlue,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.person, size: 60, color: Colors.white),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    String? errorText,
  }) {
    bool fieldChanged = false;
    bool hasError = errorText != null;

    if (controller == _emailController) {
      fieldChanged = controller.text.trim() != _originalEmail;
    } else if (controller == _phoneController) {
      fieldChanged = controller.text.trim() != _originalPhone;
    } else if (controller == _passwordController) {
      fieldChanged =
          controller.text.trim().isNotEmpty &&
          controller.text.trim() != _originalPassword;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            border: Border.all(
              color: hasError
                  ? Colors.red
                  : (fieldChanged
                        ? AppConstants.primaryBlue
                        : Colors.grey.shade300),
              width: hasError || fieldChanged ? 2 : 1,
            ),
            color: hasError
                ? Colors.red.withValues(alpha: 0.05)
                : (fieldChanged
                      ? AppConstants.primaryBlue.withValues(alpha: 0.05)
                      : Colors.white),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            scrollPadding: const EdgeInsets.only(bottom: 200.0),
            enableInteractiveSelection: true,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(
                icon,
                color: hasError
                    ? Colors.red
                    : (fieldChanged
                          ? AppConstants.primaryBlue
                          : Colors.grey[600]),
                size: 20,
              ),
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              labelStyle: TextStyle(
                color: hasError
                    ? Colors.red
                    : (fieldChanged
                          ? AppConstants.primaryBlue
                          : Colors.grey[600]),
                fontSize: 14,
              ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              errorText,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
