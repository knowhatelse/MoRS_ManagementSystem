import 'package:flutter/material.dart';
import '../widgets/empty_page_widget.dart';
import '../constants/app_constants.dart';

class AnnouncementsPage extends StatelessWidget {
  const AnnouncementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyPageWidget(
      icon: Icons.campaign,
      title: AppStrings.announcements,
    );
  }
}
