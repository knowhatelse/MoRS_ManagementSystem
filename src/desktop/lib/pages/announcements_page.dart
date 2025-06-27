import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/announcement_service.dart';
import '../constants/app_constants.dart';
import '../constants/announcement_constants.dart';
import '../utils/app_utils.dart';
import '../widgets/create_announcement_dialog.dart';
import '../widgets/view_announcement_dialog.dart';

class AnnouncementsPage extends StatefulWidget {
  final UserResponse user;

  const AnnouncementsPage({super.key, required this.user});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  final AnnouncementService _announcementService = AnnouncementService();
  List<AnnouncementResponse> _announcements = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnnouncements();
  }

  Future<void> _loadAnnouncements() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final announcements = await _announcementService.getAnnouncements();
      announcements.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      setState(() {
        _announcements = announcements;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        AppUtils.showErrorSnackBar(
          context,
          AnnouncementConstants.loadingErrorMessage,
        );
      }
    }
  }

  Future<void> _deleteAnnouncement(AnnouncementResponse announcement) async {
    final confirmed = await _showDeleteConfirmationDialog(announcement);
    if (confirmed == true) {
      final success = await _announcementService.deleteAnnouncementById(
        announcement.id,
      );
      if (success) {
        setState(() {
          _announcements.removeWhere((a) => a.id == announcement.id);
        });
        if (mounted) {
          AppUtils.showSuccessSnackbar(
            context,
            AnnouncementConstants.deleteSuccessMessage,
          );
        }
      } else {
        if (mounted) {
          AppUtils.showErrorSnackBar(
            context,
            AnnouncementConstants.deleteErrorMessage,
          );
        }
      }
    }
  }

  Future<bool?> _showDeleteConfirmationDialog(
    AnnouncementResponse announcement,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(AnnouncementConstants.deleteConfirmationTitle),
          content: Text(
            AnnouncementConstants.deleteConfirmationMessage(
              announcement.title,
              announcement.user?.fullName ?? 'Nepoznat',
              _formatDate(announcement.createdAt),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(AnnouncementConstants.cancelButton),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text(AnnouncementConstants.deleteButton),
            ),
          ],
        );
      },
    );
  }

  void _showAnnouncementDetails(AnnouncementResponse announcement) {
    showDialog(
      context: context,
      builder: (context) => ViewAnnouncementDialog(announcement: announcement),
    );
  }

  void _showCreateAnnouncementDialog() {
    showDialog(
      context: context,
      builder: (context) => CreateAnnouncementDialog(
        currentUser: widget.user,
        onCreateAnnouncement: (request) async {
          await _announcementService.createAnnouncement(request);
          await _loadAnnouncements();
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(
              AnnouncementConstants.pageHorizontalPadding,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AnnouncementConstants.tableSidePadding,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        AnnouncementConstants.pageTitle,
                        style: TextStyle(
                          fontSize: AnnouncementConstants.titleFontSize,
                          fontWeight: FontWeight.w600,
                          color: AppConstants.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AnnouncementConstants.tableSidePadding,
                    ),
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppConstants.primaryBlue,
                            ),
                          )
                        : _announcements.isEmpty
                        ? const Center(
                            child: Text(
                              AnnouncementConstants.noDataMessage,
                              style: TextStyle(
                                fontSize: AnnouncementConstants.noDataFontSize,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : _buildAnnouncementsTable(),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton(
              onPressed: _showCreateAnnouncementDialog,
              backgroundColor: AppConstants.primaryBlue,
              foregroundColor: Colors.white,
              shape: const CircleBorder(),
              elevation: 8,
              tooltip: AnnouncementConstants.createTooltip,
              child: const Icon(
                Icons.add,
                size: AnnouncementConstants.fabIconSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementsTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTableHeader(),
          Expanded(
            child: ListView.builder(
              itemCount: _announcements.length,
              itemBuilder: (context, index) {
                return _buildAnnouncementRow(_announcements[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppConstants.primaryBlue,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppConstants.borderRadius),
          topRight: Radius.circular(AppConstants.borderRadius),
        ),
      ),
      child: const Row(
        children: [
          Expanded(
            flex: AnnouncementConstants.titleColumnFlex,
            child: Text(
              AnnouncementConstants.titleHeader,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: AnnouncementConstants.tableHeaderFontSize,
              ),
            ),
          ),
          Expanded(
            flex: AnnouncementConstants.dateColumnFlex,
            child: Text(
              AnnouncementConstants.dateHeader,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: AnnouncementConstants.tableHeaderFontSize,
              ),
            ),
          ),
          Expanded(
            flex: AnnouncementConstants.createdByColumnFlex,
            child: Text(
              AnnouncementConstants.createdByHeader,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: AnnouncementConstants.tableHeaderFontSize,
              ),
            ),
          ),
          SizedBox(
            width: AnnouncementConstants.deleteColumnWidth,
            child: Text(
              AnnouncementConstants.deleteHeader,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: AnnouncementConstants.tableHeaderFontSize,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementRow(AnnouncementResponse announcement, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade100, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 3,
            spreadRadius: 0,
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showAnnouncementDetails(announcement),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                flex: AnnouncementConstants.titleColumnFlex,
                child: Text(
                  announcement.title,
                  style: const TextStyle(
                    fontSize: AnnouncementConstants.tableRowFontSize,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: AnnouncementConstants.dateColumnFlex,
                child: Text(
                  _formatDate(announcement.createdAt),
                  style: const TextStyle(
                    fontSize: AnnouncementConstants.tableRowFontSize,
                  ),
                ),
              ),
              Expanded(
                flex: AnnouncementConstants.createdByColumnFlex,
                child: Text(
                  announcement.user?.fullName ?? 'Nepoznat korisnik',
                  style: const TextStyle(
                    fontSize: AnnouncementConstants.tableRowFontSize,
                  ),
                ),
              ),
              SizedBox(
                width: AnnouncementConstants.deleteColumnWidth,
                child: IconButton(
                  onPressed: () => _deleteAnnouncement(announcement),
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: AnnouncementConstants.deleteIconSize,
                  ),
                  tooltip: AnnouncementConstants.deleteTooltip,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
