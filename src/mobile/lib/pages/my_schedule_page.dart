import 'package:flutter/material.dart';
import '../widgets/empty_page_widget.dart';
import '../constants/app_constants.dart';

class MySchedulePage extends StatelessWidget {
  const MySchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyPageWidget(
      icon: Icons.schedule,
      title: AppStrings.mySchedule,
    );
  }
}
