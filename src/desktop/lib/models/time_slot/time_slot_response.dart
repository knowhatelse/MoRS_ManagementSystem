class TimeSlotResponse {
  final int id;
  final Duration timeFrom;
  final Duration timeTo;

  TimeSlotResponse({
    required this.id,
    required this.timeFrom,
    required this.timeTo,
  });

  factory TimeSlotResponse.fromJson(Map<String, dynamic> json) {
    return TimeSlotResponse(
      id: json['id'],
      timeFrom: _parseDuration(json['timeFrom']),
      timeTo: _parseDuration(json['timeTo']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timeFrom': _formatDuration(timeFrom),
      'timeTo': _formatDuration(timeTo),
    };
  }

  static Duration _parseDuration(String duration) {
    final parts = duration.split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    final seconds = int.parse(parts[2]);
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  static String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get formattedTimeFrom {
    final hours = timeFrom.inHours;
    final minutes = timeFrom.inMinutes.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  String get formattedTimeTo {
    final hours = timeTo.inHours;
    final minutes = timeTo.inMinutes.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  String get formattedTimeRange {
    return '$formattedTimeFrom - $formattedTimeTo';
  }
}
