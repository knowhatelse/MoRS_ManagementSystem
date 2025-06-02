import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final VoidCallback onNotificationPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.onNotificationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.primaryBlue,
        boxShadow: [AppConstants.topBarShadow],
      ),
      child: SafeArea(
        bottom: false,
        child: Container(
          height: AppConstants.topBarHeight,
          padding: AppConstants.screenPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: onNotificationPressed,
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: AppConstants.iconSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
