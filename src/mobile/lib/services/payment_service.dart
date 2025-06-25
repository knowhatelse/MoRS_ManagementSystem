import '../models/models.dart';
import 'base_api_service.dart';
import 'api_config.dart';

class PaymentService extends BaseApiService {
  Future<PaymentResponse> createPayment(CreatePaymentRequest request) async {
    try {
      final response = await post(ApiConfig.payments, body: request.toJson());
      return PaymentResponse.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create payment: $e');
    }
  }
}
