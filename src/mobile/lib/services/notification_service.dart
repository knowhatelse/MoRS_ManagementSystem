import '../models/models.dart';
import 'api_config.dart';
import 'base_api_service.dart';

class NotificationService extends BaseApiService {
  Future<List<NotificationResponse>> getNotifications({
    NotificationQuery? query,
  }) async {
    final response = await get(
      ApiConfig.notifications,
      queryParameters: query?.toQueryParameters(),
    );

    if (response is List) {
      return response
          .map(
            (json) =>
                NotificationResponse.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } else {
      throw ApiException(
        statusCode: 0,
        message: 'Invalid response format: expected list of notifications',
      );
    }
  }

  Future<NotificationResponse> updateNotification(
    UpdateNotificationRequest request,
  ) async {
    final response = await put(
      '${ApiConfig.notifications}/${request.id}',
      body: request.toJson(),
    );

    return NotificationResponse.fromJson(response);
  }

  Future<void> deleteNotification(int id) async {
    await delete('${ApiConfig.notifications}/$id');
  }
}
