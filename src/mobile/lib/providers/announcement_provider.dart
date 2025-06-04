import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/services.dart';

/// Provider for managing announcement state across the app
class AnnouncementProvider extends ChangeNotifier {
  final AnnouncementService _announcementService = AnnouncementService();
  // State variables
  List<AnnouncementResponse> _announcements = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<AnnouncementResponse> get announcements => _announcements;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get hasAnnouncements => _announcements.isNotEmpty;

  /// Load announcements from API
  Future<void> loadAnnouncements() async {
    _setLoading(true);
    _clearError();

    try {
      // Load active announcements with user information
      _announcements = await _announcementService.getActiveAnnouncements();
      notifyListeners();
    } on ApiException catch (e) {
      _setError('API Error: ${e.message}');
    } catch (e) {
      _setError('Failed to load announcements: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Refresh announcements (pull-to-refresh)
  Future<void> refreshAnnouncements() async {
    await loadAnnouncements();
  }

  /// Create a new announcement
  Future<bool> createAnnouncement(CreateAnnouncementRequest request) async {
    try {
      _setLoading(true);
      _clearError();

      final newAnnouncement = await _announcementService.createAnnouncement(
        request,
      );

      // Add to the beginning of the list
      _announcements.insert(0, newAnnouncement);
      notifyListeners();

      return true;
    } catch (e) {
      _setError('Failed to create announcement: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Update an existing announcement
  Future<bool> updateAnnouncement(
    int id,
    UpdateAnnouncementRequest request,
  ) async {
    try {
      _setLoading(true);
      _clearError();

      final updatedAnnouncement = await _announcementService.updateAnnouncement(
        id,
        request,
      );

      // Find and replace the announcement in the list
      final index = _announcements.indexWhere((a) => a.id == id);
      if (index != -1) {
        if (updatedAnnouncement != null) {
          _announcements[index] = updatedAnnouncement;
        }
        notifyListeners();
      }

      return true;
    } catch (e) {
      _setError('Failed to update announcement: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Get a specific announcement by ID
  AnnouncementResponse? getAnnouncementById(int id) {
    try {
      return _announcements.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  // Private methods for state management
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
