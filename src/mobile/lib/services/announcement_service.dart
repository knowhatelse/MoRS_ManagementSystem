import '../models/models.dart';
import 'api_config.dart';
import 'base_api_service.dart';

class AnnouncementService extends BaseApiService {
  /// Get all announcements with optional filtering
  /// [isDeleted] - Filter by deleted status (null = all, true = only deleted, false = only active)
  /// [isUserIncluded] - Whether to include user information in the response
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

      // The API returns a list of announcements
      if (response is List) {
        return response
            .map(
              (json) =>
                  AnnouncementResponse.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      } else {
        // If response is not a list, throw an error
        throw ApiException(
          statusCode: 0,
          message: 'Invalid response format: expected list of announcements',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get a specific announcement by ID
  /// [id] - The announcement ID
  /// [isUserIncluded] - Whether to include user information in the response
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
      // If 404, return null instead of throwing
      if (e.statusCode == 404) {
        return null;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  /// Create a new announcement
  /// [request] - The announcement creation data
  Future<AnnouncementResponse> createAnnouncement(
    CreateAnnouncementRequest request,
  ) async {
    try {
      // Validate the request before sending
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

  /// Update an announcement (currently only supports soft delete)
  /// [id] - The announcement ID to update
  /// [request] - The update data (currently only isDeleted flag)
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
      // If 404, return null instead of throwing
      if (e.statusCode == 404) {
        return null;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  /// Soft delete an announcement (mark as deleted)
  /// [id] - The announcement ID to delete
  Future<AnnouncementResponse?> deleteAnnouncement(int id) async {
    // Get the current announcement to preserve title and content
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

  /// Restore a soft-deleted announcement
  /// [id] - The announcement ID to restore
  Future<AnnouncementResponse?> restoreAnnouncement(int id) async {
    // Get the current announcement to preserve title and content
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

  /// Get only active (non-deleted) announcements with user information
  /// This is a convenience method for the most common use case
  Future<List<AnnouncementResponse>> getActiveAnnouncements() async {
    return getAnnouncements(isDeleted: false, isUserIncluded: true);
  }

  /// Get announcements for a specific user
  /// Note: This would require the API to support user filtering
  /// Currently commented out as the API doesn't have this endpoint
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
