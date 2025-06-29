import '../models/models.dart';
import 'api_config.dart';
import 'base_api_service.dart';

class EmailService extends BaseApiService {
  Future<bool> sendEmail(CreateEmailRequest request) async {
    try {
      await post(ApiConfig.emails, body: request.toJson());
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
