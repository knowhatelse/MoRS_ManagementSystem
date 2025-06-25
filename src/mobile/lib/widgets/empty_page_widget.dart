import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class EmptyPageWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const EmptyPageWidget({
    super.key,
    required this.icon,
    required this.title,
    this.message = AppStrings.comingSoonMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(message, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
