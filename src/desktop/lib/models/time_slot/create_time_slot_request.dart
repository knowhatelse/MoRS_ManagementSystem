class CreateTimeSlotRequest {
  final Duration timeFrom;
  final Duration timeTo;

  CreateTimeSlotRequest({required this.timeFrom, required this.timeTo});

  factory CreateTimeSlotRequest.fromJson(Map<String, dynamic> json) {
    return CreateTimeSlotRequest(
      timeFrom: _parseDuration(json['timeFrom']),
      timeTo: _parseDuration(json['timeTo']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
}
