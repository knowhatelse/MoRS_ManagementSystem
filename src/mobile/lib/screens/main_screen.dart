import 'package:flutter/material.dart';
import '../models/models.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_navigation.dart';
import '../pages/announcements_page.dart';
import '../pages/schedule_page.dart';
import '../pages/my_schedule_page.dart';
import '../pages/report_problem_page.dart';
import '../pages/profile_page.dart';
import '../constants/app_constants.dart';
import '../utils/app_utils.dart';

class MainScreen extends StatefulWidget {
  final UserResponse user;

  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: Column(
        children: [
          CustomAppBar(
            title: AppStrings.pageTitles[_selectedIndex],
            onNotificationPressed: _showNotifications,
          ),
          Expanded(child: _buildBody()),
          CustomBottomNavigation(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const AnnouncementsPage();
      case 1:
        return const SchedulePage();
      case 2:
        return const MySchedulePage();
      case 3:
        return const ReportProblemPage();
      case 4:
        return const ProfilePage();
      default:
        return const AnnouncementsPage();
    }
  }

  void _showNotifications() {
    AppUtils.showComingSoonSnackBar(context, AppStrings.notifications);
  }
}
