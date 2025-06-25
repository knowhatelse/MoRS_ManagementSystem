import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_navigation.dart';
import '../widgets/notification_sidebar.dart';
import '../pages/announcements_page.dart';
import '../pages/schedule_page.dart';
import '../pages/my_appointments_page.dart';
import '../pages/report_problem_page.dart';
import '../pages/profile_page.dart';
import '../providers/announcement_provider.dart';
import '../providers/notification_provider.dart';
import '../constants/app_constants.dart';

class MainScreen extends StatefulWidget {
  final UserResponse user;

  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().startPolling(
        userId: widget.user.id,
        interval: const Duration(seconds: 30),
      );
    });
  }

  @override
  void dispose() {
    context.read<NotificationProvider>().stopPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      resizeToAvoidBottomInset: false,
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

    if (index == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<AnnouncementProvider>().loadAnnouncements();
      });
    }
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const AnnouncementsPage();
      case 1:
        return SchedulePage(currentUser: widget.user);
      case 2:
        return MyAppointmentsPage(currentUser: widget.user);
      case 3:
        return ReportProblemPage(currentUser: widget.user);
      case 4:
        return ProfilePage(currentUser: widget.user);
      default:
        return const AnnouncementsPage();
    }
  }

  void _showNotifications() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) {
        return NotificationSidebar(
          currentUser: widget.user,
          animation: animation,
        );
      },
    );
  }
}
