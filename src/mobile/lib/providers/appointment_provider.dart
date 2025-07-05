import 'package:flutter/material.dart';
import 'dart:async';
import '../models/models.dart';
import '../services/services.dart';
import '../constants/app_constants.dart';

class AppointmentProvider extends ChangeNotifier {
  final AppointmentService _appointmentService = AppointmentService();
  List<AppointmentResponse> _appointments = [];
  bool _isLoading = false;
  String? _errorMessage;
  DateTime _selectedDate = DateTime.now();

  DateTime? _filterDate;
  TimeOfDay? _filterTimeFrom;
  TimeOfDay? _filterTimeTo;
  RoomResponse? _filterRoom;
  AppointmentTypeResponse? _filterAppointmentType;

  List<AppointmentResponse> get appointments => _appointments;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get hasAppointments => _appointments.isNotEmpty;
  DateTime get selectedDate => _selectedDate;

  DateTime? get filterDate => _filterDate;
  TimeOfDay? get filterTimeFrom => _filterTimeFrom;
  TimeOfDay? get filterTimeTo => _filterTimeTo;
  RoomResponse? get filterRoom => _filterRoom;
  AppointmentTypeResponse? get filterAppointmentType => _filterAppointmentType;
  bool get hasActiveFilters =>
      _filterDate != null ||
      _filterTimeFrom != null ||
      _filterTimeTo != null ||
      _filterRoom != null ||
      _filterAppointmentType != null;

  Future<void> loadAppointments() async {
    _setLoading(true);
    _clearError();
    try {
      AppointmentQuery query;
      if (hasActiveFilters) {
        if (_filterDate != null) {
          query = AppointmentQuery(
            date: _filterDate,
            roomId: _filterRoom?.id,
            isRoomIncluded: true,
            isAppointmentTypeIncluded: true,
            isAppointmentScheduleIncluded: true,
            isUserIncluded: true,
            areAttendeesIncluded: true,
          );
        } else {
          query = AppointmentQuery(
            date: DateTime.now(),
            roomId: _filterRoom?.id,
            isRoomIncluded: true,
            isAppointmentTypeIncluded: true,
            isAppointmentScheduleIncluded: true,
            isUserIncluded: true,
            areAttendeesIncluded: true,
          );
        }
      } else {
        query = AppointmentQuery.forDate(_selectedDate);
      }
      List<AppointmentResponse> appointments = await _appointmentService
          .getAppointments(query: query);
      if (hasActiveFilters) {
        appointments = _applyClientSideFilters(appointments);
      }

      appointments = _sortAppointmentsByTime(appointments);

      _appointments = appointments;
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
      _setError('${AppStrings.loadingAppointmentsFailed}: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshAppointments() async {
    await loadAppointments();
  }

  Future<void> changeDate(DateTime newDate) async {
    _selectedDate = DateTime(newDate.year, newDate.month, newDate.day);
    await loadAppointments();
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
    DateTime? date,
    TimeOfDay? timeFrom,
    TimeOfDay? timeTo,
    RoomResponse? room,
    AppointmentTypeResponse? appointmentType,
  ) async {
    _filterDate = date;
    _filterTimeFrom = timeFrom;
    _filterTimeTo = timeTo;
    _filterRoom = room;
    _filterAppointmentType = appointmentType;
    await loadAppointments();
  }

  Future<void> clearFilters() async {
    _filterDate = null;
    _filterTimeFrom = null;
    _filterTimeTo = null;
    _filterRoom = null;
    _filterAppointmentType = null;
    await loadAppointments();
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

  List<AppointmentResponse> _applyClientSideFilters(
    List<AppointmentResponse> appointments,
  ) {
    return appointments.where((appointment) {
      if (_filterTimeFrom != null || _filterTimeTo != null) {
        final scheduleStartTime = _durationToTimeOfDay(
          appointment.appointmentSchedule.time.timeFrom,
        );
        final scheduleEndTime = _durationToTimeOfDay(
          appointment.appointmentSchedule.time.timeTo,
        );

        if (_filterTimeFrom != null) {
          if (!_isTimeAfterOrEqual(scheduleStartTime, _filterTimeFrom!)) {
            return false;
          }
        }

        if (_filterTimeTo != null) {
          if (!_isTimeBeforeOrEqual(scheduleEndTime, _filterTimeTo!)) {
            return false;
          }
        }
      }

      if (_filterAppointmentType != null) {
        if (appointment.appointmentType.id != _filterAppointmentType!.id) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  TimeOfDay _durationToTimeOfDay(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return TimeOfDay(hour: hours, minute: minutes);
  }

  bool _isTimeAfterOrEqual(TimeOfDay time1, TimeOfDay time2) {
    final time1Minutes = time1.hour * 60 + time1.minute;
    final time2Minutes = time2.hour * 60 + time2.minute;
    return time1Minutes >= time2Minutes;
  }

  bool _isTimeBeforeOrEqual(TimeOfDay time1, TimeOfDay time2) {
    final time1Minutes = time1.hour * 60 + time1.minute;
    final time2Minutes = time2.hour * 60 + time2.minute;
    return time1Minutes <= time2Minutes;
  }

  List<AppointmentResponse> _sortAppointmentsByTime(
    List<AppointmentResponse> appointments,
  ) {
    final sortedAppointments = List<AppointmentResponse>.from(appointments);

    sortedAppointments.sort((a, b) {
      final dateComparison = a.appointmentSchedule.date.compareTo(
        b.appointmentSchedule.date,
      );
      if (dateComparison != 0) {
        return dateComparison;
      }

      final aStartTime = a.appointmentSchedule.time.timeFrom;
      final bStartTime = b.appointmentSchedule.time.timeFrom;

      final aMinutes = aStartTime.inMinutes;
      final bMinutes = bStartTime.inMinutes;

      return aMinutes.compareTo(bMinutes);
    });

    return sortedAppointments;
  }
}
