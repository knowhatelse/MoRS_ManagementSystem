class AppointmentTypeResponse {
  final int id;
  final String name;

  AppointmentTypeResponse({required this.id, required this.name});

  factory AppointmentTypeResponse.fromJson(Map<String, dynamic> json) {
    return AppointmentTypeResponse(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
