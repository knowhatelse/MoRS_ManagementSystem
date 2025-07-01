import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/malfunction_report_service.dart';
import '../constants/app_constants.dart';
import '../constants/report_constants.dart';
import '../utils/app_utils.dart';
import '../widgets/report_filter_dialog.dart';
import '../widgets/view_report_dialog.dart';

class ReportPage extends StatefulWidget {
  final UserResponse user;

  const ReportPage({super.key, required this.user});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final MalfunctionReportService _malfunctionReportService =
      MalfunctionReportService();
  List<MalfunctionReportResponse> _reports = [];
  List<MalfunctionReportResponse> _filteredReports = [];
  bool _isLoading = true;

  RoomResponse? _filterRoom;
  UserResponse? _filterUser;
  DateTime? _filterDate;
  bool? _filterIsArchived;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final query = MalfunctionReportQuery(
        roomId: _filterRoom?.id,
        userId: _filterUser?.id,
        date: _filterDate,
        isArchived: _filterIsArchived,
        isRoomIncluded: true,
        isUserIncluded: true,
      );

      final reports = await _malfunctionReportService.getMalfunctionReports(
        query,
      );
     
      reports.sort((a, b) {
        if (a.isArchived != b.isArchived) {
          return a.isArchived ? 1 : -1;
        }
        return b.date.compareTo(a.date);
      });

      setState(() {
        _reports = reports;
        _filteredReports = reports;
        _isLoading = false;
      });
    } catch (e) {
     
      setState(() {
        _isLoading = false;
      });
      AppUtils.showErrorSnackBar(context, ReportConstants.loadingErrorMessage);
    }
  }

  Future<void> _toggleArchiveReport(MalfunctionReportResponse report) async {
    final confirmed = await _showArchiveConfirmationDialog(report);
    if (confirmed == true) {
      try {
        final newArchivedStatus = !report.isArchived;
        final request = UpdateMalfunctionReportRequest(
          isArchived: newArchivedStatus,
        );
        await _malfunctionReportService.updateMalfunctionReport(
          report.id,
          request,
        );

        await _loadReports();

        if (mounted) {
          AppUtils.showSuccessSnackbar(
            context,
            report.isArchived
                ? ReportConstants.unarchiveSuccessMessage
                : ReportConstants.archiveSuccessMessage,
          );
        }
      } catch (e) {
        if (mounted) {
          AppUtils.showErrorSnackBar(
            context,
            report.isArchived
                ? ReportConstants.unarchiveErrorMessage
                : ReportConstants.archiveErrorMessage,
          );
        }
      }
    }
  }

  Future<void> _deleteReport(MalfunctionReportResponse report) async {
    final confirmed = await _showDeleteConfirmationDialog(report);
    if (confirmed == true) {
      try {
        await _malfunctionReportService.deleteMalfunctionReport(report.id);

        setState(() {
          _reports.removeWhere((r) => r.id == report.id);
          _filteredReports = _reports;
        });

        if (mounted) {
          AppUtils.showSuccessSnackbar(
            context,
            ReportConstants.deleteSuccessMessage,
          );
        }
      } catch (e) {
        if (mounted) {
          AppUtils.showErrorSnackBar(
            context,
            ReportConstants.deleteErrorMessage,
          );
        }
      }
    }
  }

  Future<bool?> _showArchiveConfirmationDialog(
    MalfunctionReportResponse report,
  ) {
    final isArchiving = !report.isArchived;

    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            isArchiving
                ? ReportConstants.archiveConfirmationTitle
                : ReportConstants.unarchiveConfirmationTitle,
          ),
          content: Text(
            isArchiving
                ? ReportConstants.archiveConfirmationMessage(
                    report.roomName,
                    report.reportedByUserName,
                    _formatDate(report.date),
                  )
                : ReportConstants.unarchiveConfirmationMessage(
                    report.roomName,
                    report.reportedByUserName,
                    _formatDate(report.date),
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(ReportConstants.cancelButton),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.orange),
              child: Text(
                isArchiving
                    ? ReportConstants.archiveButton
                    : ReportConstants.unarchiveButton,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showDeleteConfirmationDialog(
    MalfunctionReportResponse report,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(ReportConstants.deleteConfirmationTitle),
          content: Text(
            ReportConstants.deleteConfirmationMessage(
              report.roomName,
              report.reportedByUserName,
              _formatDate(report.date),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(ReportConstants.cancelButton),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text(ReportConstants.deleteButton),
            ),
          ],
        );
      },
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => ReportFilterDialog(
        initialRoom: _filterRoom,
        initialUser: _filterUser,
        initialDate: _filterDate,
        initialIsArchived: _filterIsArchived,
        onApplyFilters: (room, user, date, isArchived) {
          setState(() {
            _filterRoom = room;
            _filterUser = user;
            _filterDate = date;
            _filterIsArchived = isArchived;
          });
          _loadReports();
        },
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _filterRoom = null;
      _filterUser = null;
      _filterDate = null;
      _filterIsArchived = null;
    });
    _loadReports();
  }

  bool _hasActiveFilters() {
    return _filterRoom != null ||
        _filterUser != null ||
        _filterDate != null ||
        _filterIsArchived != null;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(
              ReportConstants.pageHorizontalPadding,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ReportConstants.tableSidePadding,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        ReportConstants.pageTitle,
                        style: TextStyle(
                          fontSize: ReportConstants.titleFontSize,
                          fontWeight: FontWeight.w600,
                          color: AppConstants.primaryBlue,
                        ),
                      ),
                      Row(
                        children: [
                          if (_hasActiveFilters())
                            TextButton.icon(
                              onPressed: _clearFilters,
                              icon: const Icon(
                                Icons.clear,
                                size: ReportConstants.clearIconSize,
                              ),
                              label: const Text(
                                ReportConstants.clearFiltersLabel,
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.orange.shade700,
                              ),
                            ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: _loadReports,
                            icon: Icon(
                              Icons.refresh,
                              color: AppConstants.primaryBlue,
                            ),
                            tooltip: ReportConstants.refreshTooltip,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: ReportConstants.tableSidePadding,
                    ),
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppConstants.primaryBlue,
                            ),
                          )
                        : _filteredReports.isEmpty
                        ? const Center(
                            child: Text(
                              ReportConstants.noDataMessage,
                              style: TextStyle(
                                fontSize: ReportConstants.noDataFontSize,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : _buildReportsTable(),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton(
              onPressed: _showFilterDialog,
              backgroundColor: AppConstants.primaryBlue,
              foregroundColor: Colors.white,
              shape: const CircleBorder(),
              elevation: 8,
              child: const Icon(
                Icons.filter_list,
                size: ReportConstants.fabIconSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsTable() {
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
              itemCount: _filteredReports.length,
              itemBuilder: (context, index) {
                return _buildReportRow(_filteredReports[index], index);
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
            flex: 2,
            child: Text(
              ReportConstants.roomHeader,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: ReportConstants.tableHeaderFontSize,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              ReportConstants.reportedByHeader,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: ReportConstants.tableHeaderFontSize,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              ReportConstants.dateHeader,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: ReportConstants.tableHeaderFontSize,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              ReportConstants.timeHeader,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: ReportConstants.tableHeaderFontSize,
              ),
            ),
          ),
          SizedBox(
            width: ReportConstants.archiveColumnWidth,
            child: Text(
              ReportConstants.archiveHeader,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: ReportConstants.tableHeaderFontSize,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: ReportConstants.deleteColumnWidth,
            child: Text(
              ReportConstants.deleteHeader,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: ReportConstants.tableHeaderFontSize,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportRow(MalfunctionReportResponse report, int index) {
    Color roomColor = Colors.white;
    try {
      roomColor = Color(int.parse(report.roomColor.replaceFirst('#', '0xFF')));
    } catch (e) {
      roomColor = Colors.white;
    }

    final backgroundColor = report.isArchived
        ? Colors.grey.withValues(alpha: 0.1)
        : roomColor.withValues(alpha: 0.1);

    final borderColor = report.isArchived
        ? Colors.grey.withValues(alpha: 0.3)
        : roomColor.withValues(alpha: 0.3);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => ViewReportDialog(report: report),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                offset: const Offset(0, 1),
                blurRadius: 3,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    report.roomName,
                    style: const TextStyle(
                      fontSize: ReportConstants.tableRowFontSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    report.reportedByUserName,
                    style: const TextStyle(
                      fontSize: ReportConstants.tableRowFontSize,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    _formatDate(report.date),
                    style: const TextStyle(
                      fontSize: ReportConstants.tableRowFontSize,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    _formatTime(report.date),
                    style: const TextStyle(
                      fontSize: ReportConstants.tableRowFontSize,
                    ),
                  ),
                ),
                SizedBox(
                  width: ReportConstants.archiveColumnWidth,
                  child: IconButton(
                    onPressed: () => _toggleArchiveReport(report),
                    icon: Icon(
                      report.isArchived
                          ? Icons.unarchive_outlined
                          : Icons.archive_outlined,
                      color: report.isArchived
                          ? Colors.grey.shade600
                          : Colors.orange,
                      size: ReportConstants.archiveIconSize,
                    ),
                    tooltip: report.isArchived
                        ? ReportConstants.unarchiveTooltip
                        : ReportConstants.archiveTooltip,
                  ),
                ),
                SizedBox(
                  width: ReportConstants.deleteColumnWidth,
                  child: IconButton(
                    onPressed: () => _deleteReport(report),
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: ReportConstants.deleteIconSize,
                    ),
                    tooltip: ReportConstants.deleteTooltip,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
