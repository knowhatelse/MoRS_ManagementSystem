import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/appointment_service.dart';
import '../constants/app_constants.dart';
import '../constants/planer_constants.dart';
import '../utils/app_utils.dart';
import '../widgets/appointment_attendees_dialog.dart';
import '../widgets/appointment_filter_dialog.dart';
import '../widgets/appointment_graph_dialog.dart';
import '../constants/appointment_constants.dart';

class PlanerPage extends StatefulWidget {
  final UserResponse user;

  const PlanerPage({super.key, required this.user});

  @override
  State<PlanerPage> createState() => _PlanerPageState();
}

class _PlanerPageState extends State<PlanerPage> {
  final AppointmentService _appointmentService = AppointmentService();
  List<AppointmentResponse> _appointments = [];
  List<AppointmentResponse> _filteredAppointments = [];
  bool _isLoading = true;

  DateTime? _filterDateFrom;
  DateTime? _filterDateTo;
  TimeOfDay? _filterTimeFrom;
  TimeOfDay? _filterTimeTo;
  RoomResponse? _filterRoom;
  AppointmentTypeResponse? _filterAppointmentType;
  bool? _filterIsRepeating;
  UserResponse? _filterUser;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
  
    setState(() {
      _isLoading = true;
    });

    try {
      final query = AppointmentQuery(
        isCancelled: false,
        isRoomIncluded: true,
        isAppointmentTypeIncluded: true,
        isAppointmentScheduleIncluded: true,
        isUserIncluded: true,
        areAttendeesIncluded: true,
      );

      final appointments = await _appointmentService.getAppointments(
        query: query,
      );
     
      setState(() {
        _appointments = appointments;
        _filteredAppointments = appointments;
        _isLoading = false;
      });
    } catch (e) {
      
      setState(() {
        _isLoading = false;
      });
      AppUtils.showErrorSnackBar(context, PlanerConstants.loadingErrorMessage);
    }
  }

  Future<void> _deleteAppointment(AppointmentResponse appointment) async {
    final confirmed = await _showDeleteConfirmationDialog(appointment);
    if (confirmed == true) {
      try {
        await _appointmentService.deleteAppointment(appointment.id);
        setState(() {
          _appointments.removeWhere((a) => a.id == appointment.id);
          _filteredAppointments = _applyFilters(_appointments);
        });
        if (mounted) {
          AppUtils.showSuccessSnackbar(
            context,
            PlanerConstants.deleteSuccessMessage,
          );
        }
      } catch (e) {
        if (mounted) {
          AppUtils.showErrorSnackBar(
            context,
            PlanerConstants.deleteErrorMessage,
          );
        }
      }
    }
  }

  Future<bool?> _showDeleteConfirmationDialog(AppointmentResponse appointment) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(PlanerConstants.deleteConfirmationTitle),
          content: Text(
            PlanerConstants.deleteConfirmationMessage(
              appointment.appointmentType.name,
              appointment.room.name,
              appointment.formattedDateTime,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(PlanerConstants.cancelButton),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text(PlanerConstants.deleteButton),
            ),
          ],
        );
      },
    );
  }

  void _showAppointmentAttendees(AppointmentResponse appointment) {
    showDialog(
      context: context,
      builder: (context) =>
          AppointmentAttendeesDialog(appointment: appointment),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AppointmentFilterDialog(
        initialDateFrom: _filterDateFrom,
        initialDateTo: _filterDateTo,
        initialTimeFrom: _filterTimeFrom,
        initialTimeTo: _filterTimeTo,
        initialRoom: _filterRoom,
        initialAppointmentType: _filterAppointmentType,
        initialIsRepeating: _filterIsRepeating,
        initialUser: _filterUser,
        onApplyFilters:
            (
              dateFrom,
              dateTo,
              timeFrom,
              timeTo,
              room,
              appointmentType,
              isRepeating,
              user,
            ) {
              setState(() {
                _filterDateFrom = dateFrom;
                _filterDateTo = dateTo;
                _filterTimeFrom = timeFrom;
                _filterTimeTo = timeTo;
                _filterRoom = room;
                _filterAppointmentType = appointmentType;
                _filterIsRepeating = isRepeating;
                _filterUser = user;
                _filteredAppointments = _applyFilters(_appointments);
              });
            },
      ),
    );
  }

  void _showGraphDialog() {
    showDialog(
      context: context,
      builder: (context) =>
          AppointmentGraphDialog(appointments: _filteredAppointments),
    );
  }

  List<AppointmentResponse> _applyFilters(
    List<AppointmentResponse> appointments,
  ) {
    return appointments.where((appointment) {
      if (_filterDateFrom != null) {
        final appointmentDate = appointment.appointmentSchedule.date;
        if (appointmentDate.isBefore(_filterDateFrom!)) {
          return false;
        }
      }

      if (_filterDateTo != null) {
        final appointmentDate = appointment.appointmentSchedule.date;
        if (appointmentDate.isAfter(_filterDateTo!)) {
          return false;
        }
      }

      if (_filterTimeFrom != null) {
        final appointmentTime = TimeOfDay(
          hour: appointment.appointmentSchedule.time.timeFrom.inHours,
          minute:
              (appointment.appointmentSchedule.time.timeFrom.inMinutes % 60),
        );
        final filterTimeFromMinutes =
            _filterTimeFrom!.hour * 60 + _filterTimeFrom!.minute;
        final appointmentTimeMinutes =
            appointmentTime.hour * 60 + appointmentTime.minute;
        if (appointmentTimeMinutes < filterTimeFromMinutes) {
          return false;
        }
      }

      if (_filterTimeTo != null) {
        final appointmentTime = TimeOfDay(
          hour: appointment.appointmentSchedule.time.timeFrom.inHours,
          minute:
              (appointment.appointmentSchedule.time.timeFrom.inMinutes % 60),
        );
        final filterTimeToMinutes =
            _filterTimeTo!.hour * 60 + _filterTimeTo!.minute;
        final appointmentTimeMinutes =
            appointmentTime.hour * 60 + appointmentTime.minute;
        if (appointmentTimeMinutes > filterTimeToMinutes) {
          return false;
        }
      }

      if (_filterRoom != null) {
        if (appointment.room.id != _filterRoom!.id) {
          return false;
        }
      }

      if (_filterAppointmentType != null) {
        if (appointment.appointmentType.id != _filterAppointmentType!.id) {
          return false;
        }
      }

      if (_filterIsRepeating != null) {
        if (appointment.isRepeating != _filterIsRepeating!) {
          return false;
        }
      }

      if (_filterUser != null) {
        if (appointment.bookedByUser?.id != _filterUser!.id) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  void _clearFilters() {
    setState(() {
      _filterDateFrom = null;
      _filterDateTo = null;
      _filterTimeFrom = null;
      _filterTimeTo = null;
      _filterRoom = null;
      _filterAppointmentType = null;
      _filterIsRepeating = null;
      _filterUser = null;
      _filteredAppointments = _appointments;
    });
  }

  bool _hasActiveFilters() {
    return _filterDateFrom != null ||
        _filterDateTo != null ||
        _filterTimeFrom != null ||
        _filterTimeTo != null ||
        _filterRoom != null ||
        _filterAppointmentType != null ||
        _filterIsRepeating != null ||
        _filterUser != null;
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
              PlanerConstants.pageHorizontalPadding,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: PlanerConstants.tableSidePadding,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        PlanerConstants.pageTitle,
                        style: TextStyle(
                          fontSize: PlanerConstants.titleFontSize,
                          fontWeight: FontWeight.w600,
                          color: AppConstants.primaryBlue,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _showGraphDialog,
                            icon: const Icon(Icons.show_chart),
                            tooltip: AppointmentConstants.graphButtonTooltip,
                            color: AppConstants.primaryBlue,
                          ),
                          const SizedBox(width: 8),
                          if (_hasActiveFilters())
                            TextButton.icon(
                              onPressed: _clearFilters,
                              icon: const Icon(
                                Icons.clear,
                                size: PlanerConstants.clearIconSize,
                              ),
                              label: const Text(
                                PlanerConstants.clearFiltersLabel,
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.orange.shade700,
                              ),
                            ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: _loadAppointments,
                            icon: Icon(
                              Icons.refresh,
                              color: AppConstants.primaryBlue,
                            ),
                            tooltip: PlanerConstants.refreshTooltip,
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
                      horizontal: PlanerConstants.tableSidePadding,
                    ),
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppConstants.primaryBlue,
                            ),
                          )
                        : _filteredAppointments.isEmpty
                        ? const Center(
                            child: Text(
                              PlanerConstants.noDataMessage,
                              style: TextStyle(
                                fontSize: PlanerConstants.noDataFontSize,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : _buildAppointmentsTable(),
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
              heroTag: 'filter',
              tooltip: 'Filtriraj termine',
              child: const Icon(
                Icons.filter_list,
                size: PlanerConstants.fabIconSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsTable() {
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
              itemCount: _filteredAppointments.length,
              itemBuilder: (context, index) {
                return _buildAppointmentRow(
                  _filteredAppointments[index],
                  index,
                );
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
              'Tip Termina',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Prostorija',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Datum',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Vrijeme',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Rezervirao',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(
            width: 60,
            child: Text(
              'Obriši',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentRow(AppointmentResponse appointment, int index) {
    Color roomColor = Colors.white;
    try {
      roomColor = Color(
        int.parse(appointment.room.color.replaceFirst('#', '0xFF')),
      );
    } catch (e) {
      roomColor = Colors.white;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: roomColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: roomColor.withValues(alpha: 0.3), width: 1),
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
        onTap: () => _showAppointmentAttendees(appointment),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  appointment.appointmentType.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  appointment.room.name,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  _formatDate(appointment.appointmentSchedule.date),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  appointment.appointmentSchedule.time.formattedTimeRange,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  appointment.bookedByUser?.fullName ?? 'N/A',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              SizedBox(
                width: 60,
                child: IconButton(
                  onPressed: () => _deleteAppointment(appointment),
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 20,
                  ),
                  tooltip: 'Obriši termin',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
