import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthenticationService _authService = AuthenticationService();
  bool _isLoading = false;

  // Validation state variables
  String? _emailError;
  String? _passwordError;

  // Custom color #525fe1
  static const Color customBlue = Color(0xFF525FE1);
  @override
  void initState() {
    super.initState();
    _emailController.addListener(_clearEmailError);
    _passwordController.addListener(_clearPasswordError);
  }

  void _clearEmailError() {
    if (_emailError != null) {
      setState(() {
        _emailError = null;
        if (_passwordError == 'Neispravna email adresa ili lozinka') {
          _passwordError = null;
        }
      });
    }
  }

  void _clearPasswordError() {
    if (_passwordError != null) {
      setState(() {
        _passwordError = null;
        // If both fields have the same authentication error, clear both
        if (_emailError == 'Neispravna email adresa ili lozinka') {
          _emailError = null;
        }
      });
    }
  }

  @override
  void dispose() {
    _emailController.removeListener(_clearEmailError);
    _passwordController.removeListener(_clearPasswordError);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // Clear previous errors
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    // Basic validation
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    bool hasErrors = false;

    if (email.isEmpty) {
      setState(() {
        _emailError = 'Unesite email adresu';
      });
      hasErrors = true;
    } else if (!_isValidEmail(email)) {
      setState(() {
        _emailError = 'Unesite ispravnu email adresu';
      });
      hasErrors = true;
    }

    if (password.isEmpty) {
      setState(() {
        _passwordError = 'Unesite lozinku';
      });
      hasErrors = true;
    }

    if (hasErrors) {
      return;
    }

    setState(() {
      _isLoading = true;
    });
    try {
      final loginRequest = LoginRequest(email: email, password: password);

      final userResponse = await _authService.login(
        loginRequest,
      ); // Login successful
      if (mounted) {
        _showSuccessSnackBar('Welcome back, ${userResponse.fullName}!');
        // Navigate to main screen
        Navigator.pushReplacementNamed(
          context,
          '/main',
          arguments: userResponse,
        );
      }
    } on ApiException catch (e) {
      if (mounted) {
        // Check if it's an authentication error (401 Unauthorized)
        if (e.statusCode == 401) {
          // Highlight both email and password fields red with Serbian error message
          setState(() {
            _emailError = 'Neispravna email adresa ili lozinka';
            _passwordError = 'Neispravna email adresa ili lozinka';
          });
        } else {
          _showErrorSnackBar(e.message);
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('An unexpected error occurred. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          // Unfocus any currently focused input field when tapping outside
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: Image.asset(
                      'lib/assets/images/mors-logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // "Prijava" text
                  const Text(
                    'Prijava',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: customBlue,
                    ),
                  ),
                  const SizedBox(height: 40), // Email input field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: _emailError != null
                                    ? Colors.red
                                    : Colors.grey.shade400,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: _emailError != null
                                    ? Colors.red
                                    : Colors.grey.shade400,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: _emailError != null
                                    ? Colors.red
                                    : customBlue,
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: _emailError != null
                                  ? Colors.red
                                  : Colors.grey.shade600,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),
                      if (_emailError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                          child: Text(
                            _emailError!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Password input field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Lozinka',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: _passwordError != null
                                    ? Colors.red
                                    : Colors.grey.shade400,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: _passwordError != null
                                    ? Colors.red
                                    : Colors.grey.shade400,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: _passwordError != null
                                    ? Colors.red
                                    : customBlue,
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            prefixIcon: Icon(
                              Icons.lock_outlined,
                              color: _passwordError != null
                                  ? Colors.red
                                  : Colors.grey.shade600,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),
                      if (_passwordError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                          child: Text(
                            _passwordError!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 40), // Login button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: customBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Prijavi se',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
