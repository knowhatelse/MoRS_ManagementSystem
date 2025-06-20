import '../models/models.dart';
import 'appointment_service.dart';
import 'room_service.dart';
import 'appointment_type_service.dart';
import 'time_slot_service.dart';


class AppointmentServiceManager {
  static final AppointmentServiceManager _instance =
      AppointmentServiceManager._internal();
  factory AppointmentServiceManager() => _instance;
  AppointmentServiceManager._internal();

  final AppointmentService _appointmentService = AppointmentService();
  final RoomService _roomService = RoomService();
  final AppointmentTypeService _appointmentTypeService =
      AppointmentTypeService();
  final TimeSlotService _timeSlotService = TimeSlotService();

  AppointmentService get appointments => _appointmentService;
  RoomService get rooms => _roomService;
  AppointmentTypeService get appointmentTypes => _appointmentTypeService;
  TimeSlotService get timeSlots => _timeSlotService;


  Future<AppointmentCreationData> getAppointmentCreationData() async {
    try {
      final futures = await Future.wait([
        _roomService.getActiveRooms(),
        _appointmentTypeService.getAppointmentTypes(),
      ]);
      return AppointmentCreationData(
        rooms: futures[0] as List<RoomResponse>,
        appointmentTypes: futures[1] as List<AppointmentTypeResponse>,
      );
    } catch (e) {
      rethrow;
    }
  }


  Future<AppointmentResponse> createAppointmentWithValidation(
    CreateAppointmentRequest request,
  ) async {
    try {
      final room = await _roomService.getRoomById(request.roomId);
      if (room == null || !room.isActive) {
        throw Exception('Selected room is not available');
      }

      final appointmentType = await _appointmentTypeService
          .getAppointmentTypeById(request.appointmentTypeId);
      if (appointmentType == null) {
        throw Exception('Selected appointment type is not available');
      }

      final canBook = await _appointmentService.canBookAppointment(
        request.roomId,
        request.appointmentSchedule.date,
        request.appointmentSchedule.time.timeFrom,
        request.appointmentSchedule.time.timeTo,
      );

      if (!canBook) {
        throw Exception('Time slot is already booked');
      }

      return await _appointmentService.createAppointment(request);
    } catch (e) {
      rethrow;
    }
  }

  Future<AppointmentDashboardData> getDashboardData(int userId) async {
    try {
      final futures = await Future.wait([
        _appointmentService.getAppointmentsByUser(userId),
        _appointmentService.getTodaysAppointments(),
        _appointmentService.getUpcomingAppointments(),
      ]);
      final userAppointments = futures[0];
      final todaysAppointments = futures[1];
      final upcomingAppointments = futures[2];

      return AppointmentDashboardData(
        userAppointments: userAppointments,
        todaysAppointments: todaysAppointments,
        upcomingAppointments: upcomingAppointments,
        userUpcomingCount: userAppointments
            .where(
              (apt) =>
                  apt.appointmentSchedule.date.isAfter(DateTime.now()) &&
                  !apt.isCancelled,
            )
            .length,
        userTodayCount: userAppointments
            .where(
              (apt) =>
                  _isSameDay(apt.appointmentSchedule.date, DateTime.now()) &&
                  !apt.isCancelled,
            )
            .length,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AppointmentResponse>> getCalendarAppointments(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await _appointmentService.getAppointmentsForDateRange(
      startDate,
      endDate,
    );
  }

  Future<List<RoomAvailability>> getRoomAvailability(DateTime date) async {
    try {
      final futures = await Future.wait([
        _roomService.getActiveRooms(),
        _appointmentService.getAppointmentsForDate(date),
      ]);
      final rooms = futures[0] as List<RoomResponse>;
      final appointments = futures[1] as List<AppointmentResponse>;

      return rooms.map((room) {
        final roomAppointments = appointments
            .where((apt) => apt.room.id == room.id && !apt.isCancelled)
            .toList();

        return RoomAvailability(
          room: room,
          appointments: roomAppointments,
          isFullyBooked: _isRoomFullyBooked(roomAppointments),
        );
      }).toList();
    } catch (e) {
      rethrow;
    }
  }
 
  Future<List<AppointmentResponse>> searchAppointments({
    String? searchTerm,
    DateTime? dateFrom,
    DateTime? dateTo,
    int? roomId,
    int? appointmentTypeId,
    bool? isCancelled,
  }) async {
    final query = AppointmentQuery(
      dateFrom: dateFrom,
      dateTo: dateTo,
      roomId: roomId,
      isCancelled: isCancelled,
      isRoomIncluded: true,
      isAppointmentTypeIncluded: true,
      isAppointmentScheduleIncluded: true,
      isUserIncluded: true,
      areAttendeesIncluded: true,
    );

    final appointments = await _appointmentService.getAppointments(
      query: query,
    );

    if (searchTerm != null && searchTerm.isNotEmpty) {
      final lowerSearchTerm = searchTerm.toLowerCase();
      return appointments.where((apt) {
        return apt.room.name.toLowerCase().contains(lowerSearchTerm) ||
            apt.appointmentType.name.toLowerCase().contains(lowerSearchTerm) ||
            apt.bookedByUser?.name.toLowerCase().contains(lowerSearchTerm) ==
                true ||
            apt.attendees.any(
              (attendee) =>
                  attendee.name.toLowerCase().contains(lowerSearchTerm),
            );
      }).toList();
    }

    return appointments;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool _isRoomFullyBooked(List<AppointmentResponse> appointments) {
    return appointments.length >= 8;
  }
}

class AppointmentCreationData {
  final List<RoomResponse> rooms;
  final List<AppointmentTypeResponse> appointmentTypes;

  AppointmentCreationData({
    required this.rooms,
    required this.appointmentTypes,
  });
}

class AppointmentDashboardData {
  final List<AppointmentResponse> userAppointments;
  final List<AppointmentResponse> todaysAppointments;
  final List<AppointmentResponse> upcomingAppointments;
  final int userUpcomingCount;
  final int userTodayCount;

  AppointmentDashboardData({
    required this.userAppointments,
    required this.todaysAppointments,
    required this.upcomingAppointments,
    required this.userUpcomingCount,
    required this.userTodayCount,
  });
}

class RoomAvailability {
  final RoomResponse room;
  final List<AppointmentResponse> appointments;
  final bool isFullyBooked;

  RoomAvailability({
    required this.room,
    required this.appointments,
    required this.isFullyBooked,
  });

  int get availableSlots => 8 - appointments.length;
}
