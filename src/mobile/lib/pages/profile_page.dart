import 'package:flutter/material.dart';
import '../widgets/empty_page_widget.dart';
import '../constants/app_constants.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyPageWidget(icon: Icons.person, title: AppStrings.profile);
  }
}
