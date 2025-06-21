import '../appointment_schedule/appointment_schedule_response.dart';
import '../appointment_type/appointment_type_response.dart';
import '../room/room_response.dart';
import '../user/user_response.dart';

class AppointmentResponse {
  final int id;
  final AppointmentTypeResponse appointmentType;
  final RoomResponse room;
  final AppointmentScheduleResponse appointmentSchedule;
  final List<UserResponse> attendees;
  final UserResponse? bookedByUser;
  final DateTime occuringDate;
  final bool isCancelled;
  final bool isRepeating;

  AppointmentResponse({
    required this.id,
    required this.appointmentType,
    required this.room,
    required this.appointmentSchedule,
    required this.attendees,
    this.bookedByUser,
    required this.occuringDate,
    required this.isCancelled,
    required this.isRepeating,
  });
  factory AppointmentResponse.fromJson(Map<String, dynamic> json) {
    try {
      if (json['id'] == null) {
        throw Exception('Missing required field: id');
      }
      if (json['appointmentType'] == null) {
        throw Exception('Missing required field: appointmentType');
      }
      if (json['room'] == null) {
        throw Exception('Missing required field: room');
      }
      if (json['appointmentSchedule'] == null) {
        throw Exception('Missing required field: appointmentSchedule');
      }
      if (json['attendees'] == null) {
        throw Exception('Missing required field: attendees');
      }
      if (json['occuringDate'] == null) {
        throw Exception('Missing required field: occuringDate');
      }

      return AppointmentResponse(
        id: json['id'],
        appointmentType: AppointmentTypeResponse.fromJson(
          json['appointmentType'] as Map<String, dynamic>,
        ),
        room: RoomResponse.fromJson(json['room'] as Map<String, dynamic>),
        appointmentSchedule: AppointmentScheduleResponse.fromJson(
          json['appointmentSchedule'] as Map<String, dynamic>,
        ),
        attendees: (json['attendees'] as List)
            .map(
              (attendee) =>
                  UserResponse.fromJson(attendee as Map<String, dynamic>),
            )
            .toList(),
        bookedByUser: json['bookedByUser'] != null
            ? UserResponse.fromJson(
                json['bookedByUser'] as Map<String, dynamic>,
              )
            : null,
        occuringDate: DateTime.parse(json['occuringDate']),
        isCancelled: json['isCancelled'] ?? false,
        isRepeating: json['isRepeating'] ?? false,
      );
    } catch (e) {
      throw Exception('Error parsing AppointmentResponse: $e. JSON: $json');
    }
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appointmentType': appointmentType.toJson(),
      'room': room.toJson(),
      'appointmentSchedule': appointmentSchedule.toJson(),
      'attendees': attendees.map((attendee) => attendee.toJson()).toList(),
      'bookedByUser': bookedByUser?.toJson(),
      'occuringDate': occuringDate.toIso8601String().split('T')[0],
      'isCancelled': isCancelled,
      'isRepeating': isRepeating,
    };
  }

  String get formattedOccuringDate {
    return '${occuringDate.day.toString().padLeft(2, '0')}.${occuringDate.month.toString().padLeft(2, '0')}.${occuringDate.year}';
  }

  String get formattedDateTime {
    return '$formattedOccuringDate ${appointmentSchedule.time.formattedTimeRange}';
  }

  String get attendeesNames {
    return attendees
        .map((attendee) => '${attendee.name} ${attendee.surname}')
        .join(', ');
  }

  bool get isActive => !isCancelled;

  bool get isUpcoming {
    return isActive && occuringDate.isAfter(DateTime.now());
  }

  bool get isToday {
    final now = DateTime.now();
    return isActive &&
        occuringDate.year == now.year &&
        occuringDate.month == now.month &&
        occuringDate.day == now.day;
  }
}
