import '../models/models.dart';
import 'api_config.dart';
import 'base_api_service.dart';

class ProfilePictureService extends BaseApiService {
  Future<ProfilePictureResponse> createProfilePicture(
    CreateProfilePictureRequest request,
  ) async {
    try {
      final response = await post(
        ApiConfig.profilePicture,
        body: request.toJson(),
      );
      return ProfilePictureResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteProfilePicture(int profilePictureId) async {
    try {
      await delete('${ApiConfig.profilePicture}/$profilePictureId');
    } catch (e) {
      rethrow;
    }
  }
}
