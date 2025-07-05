import '../models/models.dart';
import '../config/app_config.dart';
import 'api_config.dart';
import 'base_api_service.dart';

class TimeSlotService extends BaseApiService {
  Future<List<TimeSlotResponse>> getTimeSlots() async {
    try {
      final response = await get(ApiConfig.timeSlots);

      if (response is List) {
        return response
            .map(
              (json) => TimeSlotResponse.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw ApiException(
          statusCode: 0,
          message: 'Invalid response format: expected list of time slots',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<TimeSlotResponse?> getTimeSlotById(int id) async {
    try {
      final response = await get('${ApiConfig.timeSlots}/$id');
      return TimeSlotResponse.fromJson(response);
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        return null;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<TimeSlotResponse> createTimeSlot(CreateTimeSlotRequest request) async {
    try {
      if (!_isValidTimeSlot(request)) {
        throw ApiException(
          statusCode: 400,
          message: 'Invalid time slot: timeFrom must be before timeTo',
        );
      }

      final response = await post(ApiConfig.timeSlots, body: request.toJson());

      return TimeSlotResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<TimeSlotResponse?> updateTimeSlot(
    int id,
    CreateTimeSlotRequest request,
  ) async {
    try {
      if (!_isValidTimeSlot(request)) {
        throw ApiException(
          statusCode: 400,
          message: 'Invalid time slot: timeFrom must be before timeTo',
        );
      }

      final response = await put(
        '${ApiConfig.timeSlots}/$id',
        body: request.toJson(),
      );
      return TimeSlotResponse.fromJson(response);
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        return null;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteTimeSlot(int id) async {
    try {
      await delete('${ApiConfig.timeSlots}/$id');
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

  List<CreateTimeSlotRequest> getCommonTimeSlots() {
    List<CreateTimeSlotRequest> timeSlots = [];

    for (
      int hour = AppConfig.businessHoursStart;
      hour < AppConfig.businessHoursEnd;
      hour++
    ) {
      timeSlots.add(
        CreateTimeSlotRequest(
          timeFrom: Duration(hours: hour),
          timeTo: Duration(hours: hour + AppConfig.timeSlotDurationHours),
        ),
      );
    }

    return timeSlots;
  }

  bool timeSlotsOverlap(TimeSlotResponse slot1, TimeSlotResponse slot2) {
    return slot1.timeFrom < slot2.timeTo && slot2.timeFrom < slot1.timeTo;
  }

  bool _isValidTimeSlot(CreateTimeSlotRequest request) {
    return request.timeFrom < request.timeTo;
  }
}
