import '../time_slot/create_time_slot_request.dart';

class CreateAppointmentScheduleRequest {
  final DateTime date;
  final CreateTimeSlotRequest time;

  CreateAppointmentScheduleRequest({required this.date, required this.time});

  factory CreateAppointmentScheduleRequest.fromJson(Map<String, dynamic> json) {
    return CreateAppointmentScheduleRequest(
      date: DateTime.parse(json['date']),
      time: CreateTimeSlotRequest.fromJson(json['time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String().split('T')[0],
      'time': time.toJson(),
    };
  }
}
