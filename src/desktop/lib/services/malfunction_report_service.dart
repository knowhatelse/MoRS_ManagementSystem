import '../models/models.dart';
import 'api_config.dart';
import 'base_api_service.dart';

class MalfunctionReportService extends BaseApiService {
  Future<List<MalfunctionReportResponse>> getMalfunctionReports([
    MalfunctionReportQuery? query,
  ]) async {
    try {
      final queryParameters = query?.toQueryParameters() ?? <String, String>{};

      final response = await get(
        ApiConfig.malfunctionReports,
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
      );

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
    } catch (e) {
      rethrow;
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
    } catch (e) {
      rethrow;
    }
  }

  Future<MalfunctionReportResponse> createMalfunctionReport(
    CreateMalfunctionReportRequest request,
  ) async {
    try {
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
    } catch (e) {
      rethrow;
    }
  }

  Future<MalfunctionReportResponse?> updateMalfunctionReport(
    int id,
    UpdateMalfunctionReportRequest request,
  ) async {
    try {
      final response = await put(
        '${ApiConfig.malfunctionReports}/$id',
        body: request.toJson(),
      );
      return MalfunctionReportResponse.fromJson(response);
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        return null;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteMalfunctionReport(int id) async {
    try {
      await delete('${ApiConfig.malfunctionReports}/$id');
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

  Future<List<MalfunctionReportResponse>> getActiveMalfunctionReports() async {
    final query = MalfunctionReportQuery.activeOnly();
    return getMalfunctionReports(query);
  }

  Future<List<MalfunctionReportResponse>>
  getArchivedMalfunctionReports() async {
    final query = MalfunctionReportQuery.archivedOnly();
    return getMalfunctionReports(query);
  }

  Future<List<MalfunctionReportResponse>> getMalfunctionReportsByRoom(
    int roomId,
  ) async {
    final query = MalfunctionReportQuery.byRoom(roomId);
    return getMalfunctionReports(query);
  }
}
