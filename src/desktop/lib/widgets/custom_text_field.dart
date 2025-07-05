import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? errorText;
  final bool showPasswordToggle;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.showPasswordToggle = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: TextField(
            controller: widget.controller,
            obscureText: widget.showPasswordToggle
                ? _isObscured
                : widget.obscureText,
            keyboardType: widget.keyboardType,
            decoration: InputDecoration(
              hintText: widget.hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                borderSide: BorderSide(
                  color: widget.errorText != null
                      ? AppConstants.errorColor
                      : Colors.grey.shade400,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                borderSide: BorderSide(
                  color: widget.errorText != null
                      ? AppConstants.errorColor
                      : Colors.grey.shade400,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                borderSide: BorderSide(
                  color: widget.errorText != null
                      ? AppConstants.errorColor
                      : AppConstants.primaryBlue,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                borderSide: const BorderSide(
                  color: AppConstants.errorColor,
                  width: 2,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                borderSide: const BorderSide(
                  color: AppConstants.errorColor,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              prefixIcon: Icon(
                widget.prefixIcon,
                color: widget.errorText != null
                    ? AppConstants.errorColor
                    : Colors.grey.shade600,
              ),
              suffixIcon: widget.showPasswordToggle
                  ? IconButton(
                      icon: Icon(
                        _isObscured ? Icons.visibility : Icons.visibility_off,
                        color: widget.errorText != null
                            ? AppConstants.errorColor
                            : Colors.grey.shade600,
                      ),
                      onPressed: _togglePasswordVisibility,
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 12.0),
            child: Text(
              widget.errorText!,
              style: const TextStyle(
                color: AppConstants.errorColor,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
