import 'package:flutter/material.dart';
import 'dart:async';
import '../models/models.dart';
import '../services/services.dart';
import '../constants/app_constants.dart';

class MyAppointmentsProvider extends ChangeNotifier {
  final AppointmentService _appointmentService = AppointmentService();
  List<AppointmentResponse> _appointments = [];
  bool _isLoading = false;
  String? _errorMessage;
  DateTime _selectedDate = DateTime.now();

  DateTime? _filterDateFrom;
  DateTime? _filterDateTo;
  RoomResponse? _filterRoom;
  bool _showMyAppointments = false;
  bool _showOtherAppointments = false;
  bool _showCancelledAppointments = false;

  int? _currentUserId;

  List<AppointmentResponse> get appointments => _appointments;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get hasAppointments => _appointments.isNotEmpty;
  DateTime get selectedDate => _selectedDate;

  DateTime? get filterDateFrom => _filterDateFrom;
  DateTime? get filterDateTo => _filterDateTo;
  RoomResponse? get filterRoom => _filterRoom;
  bool get showMyAppointments => _showMyAppointments;
  bool get showOtherAppointments => _showOtherAppointments;
  bool get showCancelledAppointments => _showCancelledAppointments;
  bool get hasActiveFilters {
    return _filterDateFrom != null ||
        _filterDateTo != null ||
        _filterRoom != null ||
        _showMyAppointments ||
        _showOtherAppointments ||
        _showCancelledAppointments;
  }

  Future<void> loadMyAppointments(int userId) async {
    _currentUserId = userId;
    _setLoading(true);
    _clearError();
    try {
      final bookedAppointments = await _appointmentService.getAppointments(
        query: AppointmentQuery.forUser(userId),
      );
      final todaysAppointments = await _appointmentService.getAppointments(
        query: AppointmentQuery.forDate(DateTime.now()),
      );
      final attendeeAppointments = todaysAppointments.where((appointment) {
        final isAttendee = appointment.attendees.any(
          (attendee) => attendee.id == userId,
        );
        final isNotBooker = appointment.bookedByUser?.id != userId;
        return isAttendee && isNotBooker;
      }).toList();
      final allUserAppointments = <AppointmentResponse>[];
      allUserAppointments.addAll(bookedAppointments);

      for (final appointment in attendeeAppointments) {
        if (!allUserAppointments.any((a) => a.id == appointment.id)) {
          allUserAppointments.add(appointment);
        }
      }

      List<AppointmentResponse> filteredAppointments = _applyFilters(
        allUserAppointments,
      );
      filteredAppointments = _sortAppointmentsByTime(filteredAppointments);

      _appointments = filteredAppointments;
      notifyListeners();
    } on TimeoutException {
      _setError(AppStrings.connectionTimeout);
    } on ApiException catch (e) {
      if (e.message.toLowerCase().contains('timeout') ||
          e.message.toLowerCase().contains('not responding')) {
        _setError(AppStrings.serverNotResponding);
      } else if (e.message.toLowerCase().contains('connection') ||
          e.message.toLowerCase().contains('unreachable')) {
        _setError(AppStrings.noInternetConnection);
      } else if (e.statusCode >= 500) {
        _setError(AppStrings.serverMaintenance);
      } else {
        _setError(AppStrings.loadingAppointmentsFailed);
      }
    } catch (e) {
      if (e.toString().contains('Map<String, dynamic>')) {
        _setError(
          'Greška pri prikazivanju termina: Neispravni podaci sa servera',
        );
      } else {
        _setError('${AppStrings.loadingAppointmentsFailed}: $e');
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshMyAppointments() async {
    if (_currentUserId != null) {
      await loadMyAppointments(_currentUserId!);
    }
  }

  Future<void> changeDate(DateTime newDate) async {
    _selectedDate = DateTime(newDate.year, newDate.month, newDate.day);
    if (_currentUserId != null) {
      await loadMyAppointments(_currentUserId!);
    }
  }

  AppointmentResponse? getAppointmentById(int id) {
    try {
      return _appointments.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  String get formattedSelectedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final selected = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );

    if (selected == today) {
      return 'Today';
    } else if (selected == tomorrow) {
      return 'Tomorrow';
    } else {
      return '${_selectedDate.day.toString().padLeft(2, '0')}.${_selectedDate.month.toString().padLeft(2, '0')}.${_selectedDate.year}';
    }
  }

  bool get isToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );
    return selected == today;
  }

  Future<void> applyFilters(
    DateTime? dateFrom,
    DateTime? dateTo,
    RoomResponse? room,
    bool showMy,
    bool showOther,
    bool showCancelled,
  ) async {
    _filterDateFrom = dateFrom;
    _filterDateTo = dateTo;
    _filterRoom = room;
    _showMyAppointments = showMy;
    _showOtherAppointments = showOther;
    _showCancelledAppointments = showCancelled;

    if (_currentUserId != null) {
      await loadMyAppointments(_currentUserId!);
    }
  }

  Future<void> clearFilters() async {
    _filterDateFrom = null;
    _filterDateTo = null;
    _filterRoom = null;
    _showMyAppointments = false;
    _showOtherAppointments = false;
    _showCancelledAppointments = false;

    if (_currentUserId != null) {
      await loadMyAppointments(_currentUserId!);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  List<AppointmentResponse> _applyFilters(
    List<AppointmentResponse> appointments,
  ) {
    return appointments.where((appointment) {
      if (_filterDateFrom != null) {
        if (appointment.appointmentSchedule.date.isBefore(_filterDateFrom!)) {
          return false;
        }
      }

      if (_filterDateTo != null) {
        if (appointment.appointmentSchedule.date.isAfter(_filterDateTo!)) {
          return false;
        }
      }

      if (_filterRoom != null) {
        if (appointment.room.id != _filterRoom!.id) {
          return false;
        }
      }

      final hasAnyAppointmentTypeFilter =
          _showMyAppointments ||
          _showOtherAppointments ||
          _showCancelledAppointments;

      if (hasAnyAppointmentTypeFilter) {
        bool shouldShow = false;

        if (_showMyAppointments &&
            appointment.bookedByUser?.id == _currentUserId) {
          shouldShow = true;
        }

        if (_showOtherAppointments) {
          final isAttendee = appointment.attendees.any(
            (attendee) => attendee.id == _currentUserId,
          );
          final isNotBookedByMe =
              appointment.bookedByUser?.id != _currentUserId;
          if (isAttendee && isNotBookedByMe) {
            shouldShow = true;
          }
        }

        if (_showCancelledAppointments && appointment.isCancelled) {
          shouldShow = true;
        }

        if (!shouldShow) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  List<AppointmentResponse> _sortAppointmentsByTime(
    List<AppointmentResponse> appointments,
  ) {
    final sortedAppointments = List<AppointmentResponse>.from(appointments);

    sortedAppointments.sort((a, b) {
      if (a.isCancelled != b.isCancelled) {
        return a.isCancelled ? 1 : -1;
      }

      final dateComparison = b.appointmentSchedule.date.compareTo(
        a.appointmentSchedule.date,
      );
      if (dateComparison != 0) {
        return dateComparison;
      }

      final aStartTime = a.appointmentSchedule.time.timeFrom;
      final bStartTime = b.appointmentSchedule.time.timeFrom;

      final aMinutes = aStartTime.inMinutes;
      final bMinutes = bStartTime.inMinutes;

      return bMinutes.compareTo(aMinutes);
    });

    return sortedAppointments;
  }

  Future<bool> cancelAppointment(int appointmentId) async {
    try {
      _setLoading(true);
      final updateRequest = UpdateAppointmentRequest(isCancelled: true);

      await _appointmentService.updateAppointment(appointmentId, updateRequest);

      if (_currentUserId != null) {
        await loadMyAppointments(_currentUserId!);
      }

      return true;
    } catch (e) {
      _setError('Greška pri otkazivanju termina: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteAppointment(int appointmentId) async {
    try {
      _setLoading(true);

      await _appointmentService.deleteAppointment(appointmentId);

      if (_currentUserId != null) {
        await loadMyAppointments(_currentUserId!);
      }

      return true;
    } catch (e) {
      _setError('Greška pri brisanju termina: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
