import 'package:flutter/material.dart';
import '../widgets/empty_page_widget.dart';
import '../constants/app_constants.dart';
import '../models/models.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  List<AnnouncementResponse> announcements = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMockAnnouncements();
  }

  void _loadMockAnnouncements() {
    // Mock data for demonstration
    setState(() {
      announcements = [
        AnnouncementResponse(
          id: 1,
          title: 'Welcome to MoRS Management System',
          content: 'This is the mobile application for managing our facilities and services.',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          user: UserResponse(
            id: 1,
            name: 'System',
            surname: 'Administrator',
            email: 'admin@mors.com',
            phoneNumber: '+1234567890',
            isRestricted: false,
          ),
        ),
        AnnouncementResponse(
          id: 2,
          title: 'Maintenance Schedule',
          content: 'Please note that scheduled maintenance will occur this weekend.',
          createdAt: DateTime.now().subtract(const Duration(hours: 6)),
          user: UserResponse(
            id: 2,
            name: 'Maintenance',
            surname: 'Team',
            email: 'maintenance@mors.com',
            phoneNumber: '+1234567891',
            isRestricted: false,
          ),
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {    if (announcements.isEmpty) {
      return const EmptyPageWidget(
        icon: Icons.campaign,
        title: AppStrings.announcements,
        message: 'No announcements available',
      );
    }    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: announcements.length,
      itemBuilder: (context, index) {
        final announcement = announcements[index];        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  announcement.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  announcement.content,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (announcement.user != null)
                      Text(
                        'By: ${announcement.user!.fullName}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    Text(
                      _formatDate(announcement.createdAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}
