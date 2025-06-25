import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class AppUtils {
  static bool isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  static void showSnackBar(
    BuildContext context,
    String message, {
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor ?? AppConstants.primaryBlue,
        duration: duration,
      ),
    );
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    showSnackBar(context, message, backgroundColor: AppConstants.errorColor);
  }

  static void showSuccessSnackbar(BuildContext context, String message) {
    showSnackBar(context, message, backgroundColor: Colors.green);
  }

  static void showNetworkErrorSnackbar(BuildContext context, String message) {
    showSnackBar(context, message, backgroundColor: AppConstants.errorColor);
  }

  static void showServerNotRespondingSnackbar(BuildContext context) {
    showNetworkErrorSnackbar(context, AppStrings.serverNotResponding);
  }

  static void showConnectionTimeoutSnackbar(BuildContext context) {
    showNetworkErrorSnackbar(context, AppStrings.connectionTimeout);
  }

  static void showUnexpectedErrorSnackbar(BuildContext context) {
    showNetworkErrorSnackbar(context, AppStrings.unexpectedError);
  }
}
