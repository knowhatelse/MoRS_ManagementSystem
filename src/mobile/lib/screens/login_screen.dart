import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../constants/app_constants.dart';
import '../utils/app_utils.dart';

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

  String? _emailError;
  String? _passwordError;

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
        if (_passwordError == AppStrings.invalidEmailOrPassword) {
          _passwordError = null;
        }
      });
    }
  }

  void _clearPasswordError() {
    if (_passwordError != null) {
      setState(() {
        _passwordError = null;
        if (_emailError == AppStrings.invalidEmailOrPassword) {
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
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    bool hasErrors = false;

    if (email.isEmpty) {
      setState(() {
        _emailError = AppStrings.enterEmail;
      });
      hasErrors = true;
    } else if (!AppUtils.isValidEmail(email)) {
      setState(() {
        _emailError = AppStrings.enterValidEmail;
      });
      hasErrors = true;
    }

    if (password.isEmpty) {
      setState(() {
        _passwordError = AppStrings.enterPassword;
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
      final userResponse = await _authService.login(loginRequest);

      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/main',
          arguments: userResponse,
        );
      }
    } on ApiException catch (e) {
      if (mounted) {
        if (e.statusCode == 401) {
          setState(() {
            _emailError = AppStrings.invalidEmailOrPassword;
            _passwordError = AppStrings.invalidEmailOrPassword;
          });
        } else if (e.statusCode == 403) {
          if (e.message == AppStrings.accessDenied) {
            AppUtils.showErrorSnackBar(context, AppStrings.accessDenied);
          } else if (e.message == AppStrings.noRoleAssigned) {
            AppUtils.showErrorSnackBar(context, AppStrings.noRoleAssigned);
          } else {
            AppUtils.showErrorSnackBar(context, AppStrings.accessDenied);
          }
        } else {
          AppUtils.showErrorSnackBar(context, AppStrings.serverNotResponding);
        }
      }
    } catch (e) {
      if (mounted) {
        AppUtils.showErrorSnackBar(context, AppStrings.unexpectedError);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: GestureDetector(
        onTap: () {
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
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: Image.asset(
                      'assets/images/mors-logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    AppStrings.login,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: AppConstants.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 40),
                  CustomTextField(
                    controller: _emailController,
                    hintText: AppStrings.email,
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    errorText: _emailError,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _passwordController,
                    hintText: AppStrings.password,
                    prefixIcon: Icons.lock_outlined,
                    obscureText: true,
                    errorText: _passwordError,
                  ),
                  const SizedBox(height: 40),
                  CustomButton(
                    text: AppStrings.loginButton,
                    onPressed: _handleLogin,
                    isLoading: _isLoading,
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
