import '../appointment_schedule/create_appointment_schedule_request.dart';

class CreateAppointmentRequest {
  final bool isRepeating;
  final CreateAppointmentScheduleRequest appointmentSchedule;
  final int roomId;
  final int appointmentTypeId;
  final int bookedByUserId;
  final List<int>? attendeesIds;

  CreateAppointmentRequest({
    required this.isRepeating,
    required this.appointmentSchedule,
    required this.roomId,
    required this.appointmentTypeId,
    required this.bookedByUserId,
    this.attendeesIds,
  });

  factory CreateAppointmentRequest.fromJson(Map<String, dynamic> json) {
    return CreateAppointmentRequest(
      isRepeating: json['isRepeating'],
      appointmentSchedule: CreateAppointmentScheduleRequest.fromJson(
        json['appointmentSchedule'],
      ),
      roomId: json['roomId'],
      appointmentTypeId: json['appointmentTypeId'],
      bookedByUserId: json['bookedByUserId'],
      attendeesIds: json['attendeesIds'] != null
          ? List<int>.from(json['attendeesIds'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isRepeating': isRepeating,
      'appointmentSchedule': appointmentSchedule.toJson(),
      'roomId': roomId,
      'appointmentTypeId': appointmentTypeId,
      'bookedByUserId': bookedByUserId,
      'attendeesIds': attendeesIds,
    };
  }
}
