import '../models/models.dart';
import 'api_config.dart';
import 'base_api_service.dart';

class AnnouncementService extends BaseApiService {
  Future<List<AnnouncementResponse>> getAnnouncements({
    bool? isDeleted,
    bool? isUserIncluded,
  }) async {
    try {
      final queryParameters = <String, String>{};

      if (isDeleted != null) {
        queryParameters['isDeleted'] = isDeleted.toString();
      }

      if (isUserIncluded != null) {
        queryParameters['isUserIncluded'] = isUserIncluded.toString();
      }

      final response = await get(
        ApiConfig.announcements,
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
      );

      if (response is List) {
        return response
            .map(
              (json) =>
                  AnnouncementResponse.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw ApiException(
          statusCode: 0,
          message: 'Invalid response format: expected list of announcements',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<AnnouncementResponse?> getAnnouncementById(
    int id, {
    bool? isUserIncluded,
  }) async {
    try {
      final queryParameters = <String, String>{};

      if (isUserIncluded != null) {
        queryParameters['isUserIncluded'] = isUserIncluded.toString();
      }
      final response = await get(
        '${ApiConfig.announcements}/$id',
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
      );

      return AnnouncementResponse.fromJson(response);
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        return null;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<AnnouncementResponse> createAnnouncement(
    CreateAnnouncementRequest request,
  ) async {
    try {
      if (!request.isValid()) {
        final errors = <String>[];
        if (!request.isValidTitle()) {
          errors.add('Title must be between 5-100 characters');
        }
        if (!request.isValidContent()) {
          errors.add('Content must be between 10-2000 characters');
        }
        if (!request.isValidUserId()) {
          errors.add('User ID must be greater than 0');
        }

        throw ApiException(
          statusCode: 400,
          message: 'Validation failed: ${errors.join(', ')}',
        );
      }

      final response = await post(
        ApiConfig.announcements,
        body: request.toJson(),
      );

      return AnnouncementResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<AnnouncementResponse?> updateAnnouncement(
    int id,
    UpdateAnnouncementRequest request,
  ) async {
    try {
      final response = await put(
        '${ApiConfig.announcements}/$id',
        body: request.toJson(),
      );
      return AnnouncementResponse.fromJson(response);
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        return null;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<AnnouncementResponse?> deleteAnnouncement(int id) async {
    final currentAnnouncement = await getAnnouncementById(id);
    if (currentAnnouncement == null) return null;

    return updateAnnouncement(
      id,
      UpdateAnnouncementRequest(
        title: currentAnnouncement.title,
        content: currentAnnouncement.content,
        isDeleted: true,
      ),
    );
  }

  Future<AnnouncementResponse?> restoreAnnouncement(int id) async {
    final currentAnnouncement = await getAnnouncementById(id);
    if (currentAnnouncement == null) return null;

    return updateAnnouncement(
      id,
      UpdateAnnouncementRequest(
        title: currentAnnouncement.title,
        content: currentAnnouncement.content,
        isDeleted: false,
      ),
    );
  }

  Future<List<AnnouncementResponse>> getActiveAnnouncements() async {
    return getAnnouncements(isDeleted: false, isUserIncluded: true);
  }

  /*
  Future<List<AnnouncementResponse>> getAnnouncementsByUser(int userId) async {
    try {
      final response = await get(
        '${ApiConfig.announcements}/user/$userId',
        queryParameters: {'isUserIncluded': 'true'},
      );

      if (response is List) {
        return response
            .map((json) => AnnouncementResponse.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ApiException(
          statusCode: 0,
          message: 'Invalid response format: expected list of announcements',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
  */
}
