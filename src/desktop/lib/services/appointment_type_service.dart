import '../models/models.dart';
import 'api_config.dart';
import 'base_api_service.dart';

class AppointmentTypeService extends BaseApiService {
  Future<List<AppointmentTypeResponse>> getAppointmentTypes() async {
    try {
      final response = await get(ApiConfig.appointmentTypes);

      if (response is List) {
        return response
            .map(
              (json) => AppointmentTypeResponse.fromJson(
                json as Map<String, dynamic>,
              ),
            )
            .toList();
      } else {
        throw ApiException(
          statusCode: 0,
          message:
              'Invalid response format: expected list of appointment types',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<AppointmentTypeResponse?> getAppointmentTypeById(int id) async {
    try {
      final response = await get('${ApiConfig.appointmentTypes}/$id');
      return AppointmentTypeResponse.fromJson(response);
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        return null;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<AppointmentTypeResponse> createAppointmentType(String name) async {
    try {
      if (!_isValidName(name)) {
        throw ApiException(
          statusCode: 400,
          message:
              'Invalid appointment type name: must be between 1-100 characters',
        );
      }

      final response = await post(
        ApiConfig.appointmentTypes,
        body: {'name': name},
      );

      return AppointmentTypeResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<AppointmentTypeResponse?> updateAppointmentType(
    int id,
    String name,
  ) async {
    try {
      if (!_isValidName(name)) {
        throw ApiException(
          statusCode: 400,
          message:
              'Invalid appointment type name: must be between 1-100 characters',
        );
      }

      final response = await put(
        '${ApiConfig.appointmentTypes}/$id',
        body: {'name': name},
      );
      return AppointmentTypeResponse.fromJson(response);
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        return null;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteAppointmentType(int id) async {
    try {
      await delete('${ApiConfig.appointmentTypes}/$id');
      return true;
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        return false;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  bool _isValidName(String name) {
    return name.isNotEmpty && name.length <= 100;
  }
}
