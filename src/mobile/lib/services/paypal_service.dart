import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/paypal_config.dart';

class PayPalService {
  Future<String> getAccessToken() async {
    final response = await http.post(
      Uri.parse('${PayPalConfig.baseUrl}/v1/oauth2/token'),
      headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('${PayPalConfig.clientId}:${PayPalConfig.clientSecret}'))}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'grant_type=client_credentials',
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['access_token'];
    } else {
      throw Exception('Failed to obtain PayPal access token');
    }
  }

  Future<String> createOrder(String accessToken, double total) async {
    final response = await http.post(
      Uri.parse('${PayPalConfig.baseUrl}/v2/checkout/orders'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'intent': 'CAPTURE',
        'purchase_units': [
          {
            'amount': {
              'currency_code': 'USD',
              'value': total.toStringAsFixed(2),
            },
            'description': 'Članarina - MoRS Management System',
          },
        ],
        'application_context': {
          'return_url': PayPalConfig.successUrl,
          'cancel_url': PayPalConfig.cancelUrl,
        },
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final approvalUrl = data['links'].firstWhere(
        (link) => link['rel'] == 'approve',
      )['href'];
      return approvalUrl;
    } else {
      throw Exception('Failed to create PayPal order');
    }
  }

  String? extractPaymentIdFromUrl(String url) {
    final uri = Uri.parse(url);
    return uri.queryParameters['paymentId'] ?? uri.queryParameters['token'];
  }
}
