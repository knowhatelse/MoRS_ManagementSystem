import 'package:flutter/material.dart';
import '../widgets/empty_page_widget.dart';
import '../constants/app_constants.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyPageWidget(
      icon: Icons.calendar_today,
      title: AppStrings.schedule,
    );
  }
}
