import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/empty_page_widget.dart';
import '../widgets/announcement_detail_dialog.dart';
import '../constants/app_constants.dart';
import '../providers/announcement_provider.dart';
import '../utils/app_utils.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnnouncementProvider>().loadAnnouncements();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      context.read<AnnouncementProvider>().loadAnnouncements();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AnnouncementProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && !provider.hasAnnouncements) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.hasError && !provider.hasAnnouncements) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  AppStrings.loadingAnnouncementsFailed,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  provider.errorMessage ?? AppStrings.unexpectedError,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => provider.loadAnnouncements(),
                  icon: const Icon(Icons.refresh),
                  label: Text(AppStrings.tryAgain),
                ),
              ],
            ),
          );
        }
        if (!provider.hasAnnouncements) {
          return const Scaffold(
            body: EmptyPageWidget(
              icon: Icons.campaign,
              title: AppStrings.announcements,
              message: 'Nema dostupnih obavijesti',
            ),
          );
        }
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              await provider.refreshAnnouncements();
              if (provider.hasError && mounted) {
                AppUtils.showNetworkErrorSnackbar(
                  context,
                  provider.errorMessage ?? AppStrings.unexpectedError,
                );
              }
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: provider.announcements.length,
              itemBuilder: (context, index) {
                final announcement = provider.announcements[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  elevation: 2,
                  child: InkWell(
                    onTap: () =>
                        showAnnouncementDetailDialog(context, announcement),
                    borderRadius: BorderRadius.circular(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            announcement.title,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            announcement.content,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (announcement.user != null)
                                Expanded(
                                  child: Text(
                                    'Autor: ${announcement.user!.fullName}',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: Colors.grey[600]),
                                  ),
                                ),
                              Text(
                                _formatDate(announcement.createdAt),
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: Colors.grey[600]),
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
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day.$month.$year $hour:$minute';
  }
}
