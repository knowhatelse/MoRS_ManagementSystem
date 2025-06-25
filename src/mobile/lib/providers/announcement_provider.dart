import 'package:flutter/foundation.dart';
import 'dart:async';
import '../models/models.dart';
import '../services/services.dart';
import '../constants/app_constants.dart';

class AnnouncementProvider extends ChangeNotifier {
  final AnnouncementService _announcementService = AnnouncementService();
  List<AnnouncementResponse> _announcements = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<AnnouncementResponse> get announcements => _announcements;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get hasAnnouncements => _announcements.isNotEmpty;

  Future<void> loadAnnouncements() async {
    _setLoading(true);
    _clearError();
    try {
      _announcements = await _announcementService.getActiveAnnouncements();
      notifyListeners();
    } on TimeoutException {
      _setError(AppStrings.connectionTimeout);
    } on ApiException catch (e) {
      if (e.message.toLowerCase().contains('timeout') ||
          e.message.toLowerCase().contains('not responding')) {
        _setError(AppStrings.serverNotResponding);
      } else if (e.message.toLowerCase().contains('connection') ||
          e.message.toLowerCase().contains('unreachable')) {
        _setError(AppStrings.noInternetConnection);
      } else if (e.statusCode >= 500) {
        _setError(AppStrings.serverMaintenance);
      } else {
        _setError(AppStrings.loadingAnnouncementsFailed);
      }
    } catch (e) {
      _setError('${AppStrings.loadingAnnouncementsFailed}: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshAnnouncements() async {
    await loadAnnouncements();
  }

  AnnouncementResponse? getAnnouncementById(int id) {
    try {
      return _announcements.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
