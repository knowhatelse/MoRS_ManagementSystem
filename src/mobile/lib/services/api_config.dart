class ApiConfig {
  static const String _baseUrl = 'http://192.168.116.53:5000/api';
  static String get baseUrl => _baseUrl;

  static const Duration connectionTimeout = Duration(seconds: 10);
  static const Duration requestTimeout = Duration(seconds: 5);
  static const String authentication = '/Authentication';
  static const String announcements = '/Announcement';
  static const String appointments = '/Appointment';
  static const String rooms = '/Room';
  static const String appointmentTypes = '/AppointmentType';
  static const String timeSlots = '/TimeSlot';
  static const String users = '/User';
  static const String profilePicture = '/ProfilePicture';
  static const String malfunctionReports = '/MalfunctionReport';
  static const String notifications = '/Notification';

  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> getAuthHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };
}
