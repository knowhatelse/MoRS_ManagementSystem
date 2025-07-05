class UpdateAppointmentRequest {
  final bool isCancelled;

  UpdateAppointmentRequest({required this.isCancelled});

  factory UpdateAppointmentRequest.fromJson(Map<String, dynamic> json) {
    return UpdateAppointmentRequest(isCancelled: json['isCancelled']);
  }

  Map<String, dynamic> toJson() {
    return {'isCancelled': isCancelled};
  }
}
