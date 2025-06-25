import '../time_slot/time_slot_response.dart';

class AppointmentScheduleResponse {
  final int id;
  final DateTime date;
  final TimeSlotResponse time;

  AppointmentScheduleResponse({
    required this.id,
    required this.date,
    required this.time,
  });

  factory AppointmentScheduleResponse.fromJson(Map<String, dynamic> json) {
    return AppointmentScheduleResponse(
      id: json['id'],
      date: DateTime.parse(json['date']),
      time: TimeSlotResponse.fromJson(json['time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String().split('T')[0],
      'time': time.toJson(),
    };
  }

  String get formattedDate {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  String get formattedDateTime {
    return '$formattedDate ${time.formattedTimeRange}';
  }
}
