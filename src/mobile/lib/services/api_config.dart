import '../config/app_config.dart';

class ApiConfig {
  static String get baseUrl => AppConfig.apiBaseUrl;

  static Duration get connectionTimeout => AppConfig.connectionTimeout;
  static Duration get requestTimeout => AppConfig.requestTimeout;
  static const String authentication = '/Authentication';
  static const String announcements = '/Announcement';
  static const String appointments = '/Appointment';
  static const String rooms = '/Room';
  static const String appointmentTypes = '/AppointmentType';
  static const String timeSlots = '/TimeSlot';
  static const String users = '/user';
  static const String profilePicture = '/ProfilePicture';
  static const String malfunctionReports = '/MalfunctionReport';
  static const String notifications = '/Notification';
  static const String payments = '/Payment';

  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> getAuthHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };
}
