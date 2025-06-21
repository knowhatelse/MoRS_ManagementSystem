import '../models/models.dart';
import 'api_config.dart';
import 'base_api_service.dart';

class AppointmentService extends BaseApiService {
  Future<List<AppointmentResponse>> getAppointments({
    AppointmentQuery? query,
  }) async {
    try {
      final queryParameters = <String, String>{};

      final effectiveQuery = query ?? AppointmentQuery();
      final finalQuery = AppointmentQuery(
        date: effectiveQuery.date,
        dateFrom: effectiveQuery.dateFrom,
        dateTo: effectiveQuery.dateTo,
        roomId: effectiveQuery.roomId,
        bookedByUserId: effectiveQuery.bookedByUserId,
        attendeeId: effectiveQuery.attendeeId,
        isCancelled: effectiveQuery.isCancelled ?? false,
        isRepeating:
            effectiveQuery.isRepeating ??
            (effectiveQuery.date != null ? true : null),
        isRoomIncluded: effectiveQuery.isRoomIncluded,
        isAppointmentTypeIncluded: effectiveQuery.isAppointmentTypeIncluded,
        isAppointmentScheduleIncluded:
            effectiveQuery.isAppointmentScheduleIncluded,
        isUserIncluded: effectiveQuery.isUserIncluded,
        areAttendeesIncluded: effectiveQuery.areAttendeesIncluded,
      );
      final queryJson = finalQuery.toJson();
      queryJson.forEach((key, value) {
        if (value != null) {
          queryParameters[key] = value.toString();
        }
      });

      final response = await get(
        ApiConfig.appointments,
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
      );
      if (response is List) {
        final appointments = <AppointmentResponse>[];
        for (int i = 0; i < response.length; i++) {
          try {
            final appointmentJson = response[i] as Map<String, dynamic>;
            final appointment = AppointmentResponse.fromJson(appointmentJson);
            appointments.add(appointment);
          } catch (e) {
            continue;
          }
        }
        return appointments;
      } else {
        throw ApiException(
          statusCode: 0,
          message: 'Invalid response format: expected list of appointments',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<AppointmentResponse> createAppointment(
    CreateAppointmentRequest request,
  ) async {
    try {
      if (!_isValidCreateRequest(request)) {
        throw ApiException(
          statusCode: 400,
          message: 'Invalid appointment request: check all required fields',
        );
      }
      final response = await post(
        ApiConfig.appointments,
        body: request.toJson(),
      );

      try {
        return AppointmentResponse.fromJson(response);
      } catch (parseError) {
        throw FormatException(
          'Response parsing failed but appointment was likely created: $parseError',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateAppointment(
    int appointmentId,
    UpdateAppointmentRequest request,
  ) async {
    try {
      await put(
        '${ApiConfig.appointments}/$appointmentId',
        body: request.toJson(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAppointment(int appointmentId) async {
    try {
      await delete('${ApiConfig.appointments}/$appointmentId');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AppointmentResponse>> getAppointmentsForDate(
    DateTime date,
  ) async {
    final query = AppointmentQuery.forDate(date);
    return getAppointments(query: query);
  }

  Future<List<AppointmentResponse>> getAppointmentsForDateRange(
    DateTime dateFrom,
    DateTime dateTo,
  ) async {
    final query = AppointmentQuery.forDateRange(dateFrom, dateTo);
    return getAppointments(query: query);
  }

  Future<List<AppointmentResponse>> getAppointmentsByUser(int userId) async {
    final query = AppointmentQuery.forUser(userId);
    return getAppointments(query: query);
  }

  Future<List<AppointmentResponse>> getUpcomingAppointments() async {
    final today = DateTime.now();
    final query = AppointmentQuery(
      dateFrom: today,
      isCancelled: false,
      isRoomIncluded: true,
      isAppointmentTypeIncluded: true,
      isAppointmentScheduleIncluded: true,
      isUserIncluded: true,
      areAttendeesIncluded: true,
    );
    return getAppointments(query: query);
  }

  Future<List<AppointmentResponse>> getTodaysAppointments() async {
    final today = DateTime.now();
    return getAppointmentsForDate(today);
  }

  Future<bool> canBookAppointment(
    int roomId,
    DateTime date,
    Duration timeFrom,
    Duration timeTo,
  ) async {
    try {
      final query = AppointmentQuery(
        date: date,
        roomId: roomId,
        isCancelled: false,
        isAppointmentScheduleIncluded: true,
      );

      final existingAppointments = await getAppointments(query: query);

      for (final appointment in existingAppointments) {
        final existingTimeFrom = appointment.appointmentSchedule.time.timeFrom;
        final existingTimeTo = appointment.appointmentSchedule.time.timeTo;

        if (_timesOverlap(timeFrom, timeTo, existingTimeFrom, existingTimeTo)) {
          return false;
        }
      }

      return true;
    } catch (e) {
      rethrow;
    }
  }

  bool _isValidCreateRequest(CreateAppointmentRequest request) {
    return request.roomId > 0 &&
        request.appointmentTypeId > 0 &&
        request.bookedByUserId > 0 &&
        request.appointmentSchedule.time.timeFrom <
            request.appointmentSchedule.time.timeTo;
  }

  bool _timesOverlap(
    Duration start1,
    Duration end1,
    Duration start2,
    Duration end2,
  ) {
    return start1 < end2 && start2 < end1;
  }
}
