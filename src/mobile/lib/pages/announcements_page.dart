import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/empty_page_widget.dart';
import '../widgets/announcement_form_dialog.dart';
import '../constants/app_constants.dart';
import '../models/announcement/announcement_response.dart';
import '../providers/announcement_provider.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  @override
  void initState() {
    super.initState();
    // Load announcements when the page is first opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnnouncementProvider>().loadAnnouncements();
    });
  }

  Future<void> _createAnnouncement() async {
    final success = await showAnnouncementFormDialog(context);
    if (success == true && mounted) {
      // Announcement was created successfully
      // The provider will already have updated the list
    }
  }

  Future<void> _editAnnouncement(AnnouncementResponse announcement) async {
    final success = await showAnnouncementFormDialog(
      context,
      announcement: announcement,
    );
    if (success == true && mounted) {
      // Announcement was updated successfully
      // The provider will already have updated the list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AnnouncementProvider>(
      builder: (context, provider, child) {
        // Show loading indicator
        if (provider.isLoading && !provider.hasAnnouncements) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Show error message
        if (provider.hasError && !provider.hasAnnouncements) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading announcements',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  provider.errorMessage ?? '',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => provider.loadAnnouncements(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Show empty state
        if (!provider.hasAnnouncements) {
          return Scaffold(
            body: const EmptyPageWidget(
              icon: Icons.campaign,
              title: AppStrings.announcements,
              message: 'No announcements available',
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: _createAnnouncement,
              backgroundColor: AppConstants.primaryBlue,
              child: const Icon(Icons.add, color: Colors.white),
              tooltip: 'Create Announcement',
            ),
          );
        }

        // Show announcements list with pull-to-refresh
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: provider.refreshAnnouncements,
            child: Column(
              children: [
                // Header with data source toggle
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Data Source: ${provider.useMockData ? 'Mock' : 'API'}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      IconButton(
                        onPressed: provider.toggleDataSource,
                        icon: Icon(
                          provider.useMockData ? Icons.storage : Icons.cloud,
                          size: 20,
                        ),
                        tooltip: 'Toggle data source',
                      ),
                    ],
                  ),
                ),
                
                // Announcements list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: provider.announcements.length,
                    itemBuilder: (context, index) {
                      final announcement = provider.announcements[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        elevation: 2,
                        child: InkWell(
                          onTap: () => _editAnnouncement(announcement),
                          borderRadius: BorderRadius.circular(8.0),
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
                                      Expanded(
                                        child: Text(
                                          'By: ${announcement.user!.fullName}',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Colors.grey[600],
                                          ),
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
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _createAnnouncement,
            backgroundColor: AppConstants.primaryBlue,
            child: const Icon(Icons.add, color: Colors.white),
            tooltip: 'Create Announcement',
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
