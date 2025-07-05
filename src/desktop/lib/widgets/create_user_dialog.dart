import 'package:flutter/material.dart';
import '../../constants/users_page_constants.dart';
import '../../models/user/user_response.dart';
import '../../models/user/create_user_request.dart';
import '../../services/user_service.dart';
import '../../services/base_api_service.dart';
import '../../utils/app_utils.dart';
import '../constants/app_constants.dart';

class CreateUserDialog extends StatefulWidget {
  final Future<bool> Function(UserResponse) onUserCreated;
  const CreateUserDialog({super.key, required this.onUserCreated});

  @override
  State<CreateUserDialog> createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends State<CreateUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final UserService _userService = UserService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  int? _roleId;
  bool _isLoading = false;
  String? _error;
  final Map<String, bool> _touched = {
    'name': false,
    'surname': false,
    'email': false,
    'phone': false,
    'role': false,
  };
  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onFieldChanged);
    _surnameController.addListener(_onFieldChanged);
    _emailController.addListener(_onFieldChanged);
    _phoneController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    setState(() {});
  }

  bool _validateForm() {
    return _validateName(_nameController.text) == null &&
        _validateSurname(_surnameController.text) == null &&
        _validateEmail(_emailController.text) == null &&
        _validatePhone(_phoneController.text) == null &&
        _validateRole(_roleId) == null;
  }

  Future<void> _submit() async {
    if (!_validateForm()) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final user = await _userService.createUser(
        CreateUserRequest(
          name: _nameController.text.trim(),
          surname: _surnameController.text.trim(),
          email: _emailController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          roleId: _roleId!,
        ),
      );
      final result = await widget.onUserCreated(user);
      if (mounted) {
        Navigator.of(context).pop(result);
      }
    } catch (e) {
      if (mounted) {
        String errorMessage;
        if (e is ApiException) {
          final message = e.message.toLowerCase();

          if (message.contains('email') &&
              (message.contains('exists') ||
                  message.contains('već postoji') ||
                  message.contains('duplicate') ||
                  message.contains('taken') ||
                  message.contains('already'))) {
            errorMessage = 'Korisnik sa unetim emailom već postoji.';
          } else if ((message.contains('phone') ||
                  message.contains('telefon')) &&
              (message.contains('exists') ||
                  message.contains('već postoji') ||
                  message.contains('duplicate') ||
                  message.contains('taken') ||
                  message.contains('already'))) {
            errorMessage = 'Korisnik sa unetim brojem telefona već postoji.';
          } else if (e.statusCode == 400) {
            errorMessage =
                'Korisnik sa unetim emailom ili brojem telefona već postoji.';
          } else {
            errorMessage = 'Greška pri kreiranju korisnika. Server ne odgovara';
          }
        } else {
          errorMessage = 'Greška pri kreiranju korisnika. Server ne odgovara';
        }

        AppUtils.showErrorSnackBar(context, errorMessage);
        Navigator.of(context).pop(false);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ime je obavezno';
    }
    if (value.trim().length < 2) {
      return 'Ime mora imati najmanje 2 karaktera';
    }
    if (value.trim().length > 50) {
      return 'Ime može imati najviše 50 karaktera';
    }
    return null;
  }

  String? _validateSurname(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Prezime je obavezno';
    }
    if (value.trim().length < 2) {
      return 'Prezime mora imati najmanje 2 karaktera';
    }
    if (value.trim().length > 50) {
      return 'Prezime može imati najviše 50 karaktera';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email je obavezan';
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Neispravan email';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Broj telefona je obavezan';
    }
    final trimmed = value.trim();
    if (trimmed.contains(' ')) {
      return 'Broj telefona ne smije sadržavati razmake';
    }
    if (!RegExp(r'^06').hasMatch(trimmed)) {
      return 'Broj telefona mora počinjati sa 06';
    }
    if (RegExp(r'[^0-9]').hasMatch(trimmed)) {
      return 'Broj telefona ne smije sadržavati slova ili specijalne znakove';
    }
    if (trimmed.length < 9) {
      return 'Broj telefona mora imati najmanje 9 cifara';
    }
    if (trimmed.length > 10) {
      return 'Broj telefona može imati najviše 10 cifara';
    }
    return null;
  }

  String? _validateRole(int? value) {
    if (value == null) {
      return 'Tip korisnika je obavezan';
    }
    if (!UsersPageConstants.userRoles.any((r) => r['id'] == value)) {
      return 'Tip korisnika je obavezan';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final nameError = _touched['name']!
        ? _validateName(_nameController.text)
        : null;
    final surnameError = _touched['surname']!
        ? _validateSurname(_surnameController.text)
        : null;
    final emailError = _touched['email']!
        ? _validateEmail(_emailController.text)
        : null;
    final phoneError = _touched['phone']!
        ? _validatePhone(_phoneController.text)
        : null;
    final roleError = _touched['role']! ? _validateRole(_roleId) : null;
    return AlertDialog(
      backgroundColor: Colors.white,
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppConstants.primaryBlue,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.add, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                UsersPageConstants.createUserTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close, color: Colors.white, size: 20),
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Focus(
                onFocusChange: (hasFocus) {
                  if (!hasFocus) setState(() => _touched['name'] = true);
                },
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: UsersPageConstants.columnName,
                    border: const OutlineInputBorder(),
                    errorText: nameError,
                  ),
                  onChanged: (_) => setState(() {}),
                  enabled: !_isLoading,
                  autovalidateMode: AutovalidateMode.disabled,
                  onTap: () => setState(() => _touched['name'] = true),
                ),
              ),
              const SizedBox(height: 16),
              Focus(
                onFocusChange: (hasFocus) {
                  if (!hasFocus) setState(() => _touched['surname'] = true);
                },
                child: TextFormField(
                  controller: _surnameController,
                  decoration: InputDecoration(
                    labelText: UsersPageConstants.columnSurname,
                    border: const OutlineInputBorder(),
                    errorText: surnameError,
                  ),
                  onChanged: (_) => setState(() {}),
                  enabled: !_isLoading,
                  autovalidateMode: AutovalidateMode.disabled,
                  onTap: () => setState(() => _touched['surname'] = true),
                ),
              ),
              const SizedBox(height: 16),
              Focus(
                onFocusChange: (hasFocus) {
                  if (!hasFocus) setState(() => _touched['email'] = true);
                },
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: UsersPageConstants.columnEmail,
                    border: const OutlineInputBorder(),
                    errorText: emailError,
                  ),
                  onChanged: (_) => setState(() {}),
                  enabled: !_isLoading,
                  autovalidateMode: AutovalidateMode.disabled,
                  onTap: () => setState(() => _touched['email'] = true),
                ),
              ),
              const SizedBox(height: 16),
              Focus(
                onFocusChange: (hasFocus) {
                  if (!hasFocus) setState(() => _touched['phone'] = true);
                },
                child: TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: UsersPageConstants.columnPhone,
                    border: const OutlineInputBorder(),
                    errorText: phoneError,
                  ),
                  onChanged: (_) => setState(() {}),
                  enabled: !_isLoading,
                  autovalidateMode: AutovalidateMode.disabled,
                  onTap: () => setState(() => _touched['phone'] = true),
                ),
              ),
              const SizedBox(height: 16),
              Focus(
                onFocusChange: (hasFocus) {
                  if (!hasFocus) setState(() => _touched['role'] = true);
                },
                child: DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: UsersPageConstants.columnRole,
                    border: const OutlineInputBorder(),
                    errorText: roleError,
                  ),
                  value: _roleId,
                  items: UsersPageConstants.userRoles
                      .map(
                        (role) => DropdownMenuItem<int>(
                          value: role['id'],
                          child: Text(role['label']),
                        ),
                      )
                      .toList(),
                  onChanged: _isLoading
                      ? null
                      : (v) => setState(() {
                          _roleId = v;
                          _touched['role'] = true;
                        }),
                  validator: (v) => _validateRole(v),
                  autovalidateMode: AutovalidateMode.disabled,
                  onTap: () => setState(() => _touched['role'] = true),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Otkaži'),
        ),
        ElevatedButton(
          onPressed: _isLoading || !_validateForm() ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.primaryBlue,
            foregroundColor: Colors.white,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text('Kreiraj'),
        ),
      ],
    );
  }
}
