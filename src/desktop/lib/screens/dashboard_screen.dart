import 'package:flutter/material.dart';
import '../models/models.dart';
import '../constants/app_constants.dart';
import '../widgets/desktop_header.dart';
import '../pages/announcements_page.dart';
import '../pages/planer_page.dart';
import '../pages/room_page.dart';
import '../pages/report_page.dart';
import '../pages/users_page.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  final UserResponse user;

  const DashboardScreen({super.key, required this.user});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  static const List<String> _pageTitles = [
    'Obavijesti',
    'Planer',
    'Prostorije',
    'Prijave',
    'Email',
    'Korisnici',
  ];

  void _onNavigationTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _handleLogout() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: Column(
        children: [
          DesktopHeader(
            selectedIndex: _selectedIndex,
            onNavigationTapped: _onNavigationTapped,
            onLogoutPressed: _handleLogout,
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return AnnouncementsPage(user: widget.user);
      case 1:
        return PlanerPage(user: widget.user);
      case 2:
        return RoomPage(user: widget.user);
      case 3:
        return ReportPage(user: widget.user);
      case 5:
        return UsersPage(user: widget.user);
      default:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getIconForPage(_selectedIndex),
                size: 80,
                color: AppConstants.primaryBlue.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 20),
              Text(
                _pageTitles[_selectedIndex],
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.primaryBlue,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Stranica u razvoju',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        );
    }
  }

  IconData _getIconForPage(int index) {
    switch (index) {
      case 0:
        return Icons.campaign_outlined;
      case 1:
        return Icons.calendar_today_outlined;
      case 2:
        return Icons.meeting_room_outlined;
      case 3:
        return Icons.report_problem_outlined;
      case 4:
        return Icons.email_outlined;
      case 5:
        return Icons.people_outline;
      default:
        return Icons.campaign_outlined;
    }
  }
}
