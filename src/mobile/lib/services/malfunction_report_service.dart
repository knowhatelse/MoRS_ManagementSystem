import '../models/models.dart';
import 'api_config.dart';
import 'base_api_service.dart';

class MalfunctionReportService extends BaseApiService {
  Future<MalfunctionReportResponse> createMalfunctionReport(
    CreateMalfunctionReportRequest request,
  ) async {
    final response = await post(
      ApiConfig.malfunctionReports,
      body: request.toJson(),
    );

    if (response == null) {
      throw Exception('Null response from server');
    }

    try {
      return MalfunctionReportResponse.fromJson(response);
    } catch (parseError) {
      throw Exception('Failed to parse server response: $parseError');
    }
  }

  Future<List<MalfunctionReportResponse>> getMalfunctionReports() async {
    final response = await get(ApiConfig.malfunctionReports);

    if (response is List) {
      return response
          .map(
            (json) => MalfunctionReportResponse.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();
    } else {
      throw ApiException(
        statusCode: 0,
        message:
            'Invalid response format: expected list of malfunction reports',
      );
    }
  }

  Future<MalfunctionReportResponse?> getMalfunctionReportById(int id) async {
    try {
      final response = await get('${ApiConfig.malfunctionReports}/$id');
      return MalfunctionReportResponse.fromJson(response);
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        return null;
      }
      rethrow;
    }
  }
}
