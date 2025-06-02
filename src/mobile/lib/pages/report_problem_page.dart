import 'package:flutter/material.dart';
import '../widgets/empty_page_widget.dart';
import '../constants/app_constants.dart';

class ReportProblemPage extends StatelessWidget {
  const ReportProblemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyPageWidget(
      icon: Icons.report_problem,
      title: AppStrings.reportProblem,
    );
  }
}
