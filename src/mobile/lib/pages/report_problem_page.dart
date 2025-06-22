import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../constants/app_constants.dart';
import '../utils/app_utils.dart';

class ReportProblemPage extends StatefulWidget {
  final UserResponse? currentUser;

  const ReportProblemPage({super.key, this.currentUser});

  @override
  State<ReportProblemPage> createState() => _ReportProblemPageState();
}

class _ReportProblemPageState extends State<ReportProblemPage> {
  static const int _minDescriptionLength = 10;
  static const int _maxDescriptionLength = 1000;
  static const double _bottomSheetMaxHeight = 0.85;
  static const double _handleBarWidth = 40;
  static const double _handleBarHeight = 4;
  static const double _roomColorIndicatorSize = 12;

  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _roomService = RoomService();
  final _malfunctionReportService = MalfunctionReportService();

  List<RoomResponse> _rooms = [];
  RoomResponse? _selectedRoom;
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _roomError;
  String? _descriptionError;

  @override
  void initState() {
    super.initState();
    _loadRooms();
    _descriptionController.addListener(_onDescriptionChanged);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _onDescriptionChanged() {
    setState(() {
      _descriptionError = null;
    });
  }

  Future<void> _loadRooms() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      final rooms = await _roomService.getActiveRooms();

      if (mounted) {
        setState(() {
          _rooms = rooms;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        AppUtils.showErrorSnackBar(
          context,
          'Učitavanje prostorija nije uspjelo: ${e.toString()}',
        );
      }
    }
  }

  bool _validateForm() {
    bool isValid = true;

    setState(() {
      _roomError = null;
      _descriptionError = null;
    });

    if (_selectedRoom == null) {
      setState(() => _roomError = AppStrings.pleaseSelectRoom);
      isValid = false;
    }

    final description = _descriptionController.text.trim();
    if (description.isEmpty) {
      setState(() => _descriptionError = AppStrings.pleaseEnterDescription);
      isValid = false;
    } else if (description.length < _minDescriptionLength) {
      setState(() => _descriptionError = AppStrings.descriptionTooShort);
      isValid = false;
    } else if (description.length > _maxDescriptionLength) {
      setState(() => _descriptionError = AppStrings.descriptionTooLong);
      isValid = false;
    }

    return isValid;
  }

  Future<void> _submitReport() async {
    if (!_validateForm() || widget.currentUser == null) return;

    setState(() => _isSubmitting = true);
    try {
      final request = CreateMalfunctionReportRequest(
        description: _descriptionController.text.trim(),
        roomId: _selectedRoom!.id,
        reportedByUserId: widget.currentUser!.id,
      );

      await _malfunctionReportService.createMalfunctionReport(request);

      if (mounted) {
        AppUtils.showSuccessSnackbar(context, AppStrings.reportSubmitted);
        _resetForm();
      }
    } catch (e) {
      if (mounted) {
        final errorMessage = _getErrorMessage(e);
        AppUtils.showErrorSnackBar(context, errorMessage);
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  String _getErrorMessage(dynamic error) {
    final errorString = error.toString();

    if (errorString.contains('404')) {
      return 'Servis za prijavu kvara nije dostupan.';
    } else if (errorString.contains('500')) {
      return 'Greška na serveru. Molimo pokušajte ponovo.';
    } else if (errorString.contains('Connection') ||
        errorString.contains('timeout')) {
      return 'Problema s mrežom. Provjerite internetsku vezu.';
    } else if (errorString.contains('400')) {
      return 'Neispravni podaci. Provjerite unos i pokušajte ponovo.';
    } else if (errorString.contains('401')) {
      return 'API greška - neautorizirani pristup. Kontaktirajte administratora.';
    }

    return AppStrings.reportSubmissionFailed;
  }

  void _resetForm() {
    _descriptionController.clear();
    setState(() {
      _selectedRoom = null;
      _roomError = null;
      _descriptionError = null;
    });
  }

  void _showRoomSelectionBottomSheet() {
    final screenSize = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: screenSize.height * _bottomSheetMaxHeight,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8.0),
                width: _handleBarWidth,
                height: _handleBarHeight,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Container(
                padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 16.0),
                child: Row(
                  children: [
                    Icon(Icons.room, color: AppConstants.primaryBlue, size: 24),
                    const SizedBox(width: 8),
                    const Text(
                      AppStrings.selectRoomForReport,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.primaryBlue,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close,
                        color: AppConstants.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _rooms.length,
                  itemBuilder: (context, index) {
                    final room = _rooms[index];
                    final isSelected = _selectedRoom?.id == room.id;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? AppConstants.primaryBlue
                              : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadius,
                        ),
                        color: isSelected
                            ? AppConstants.primaryBlue.withValues(alpha: 0.05)
                            : Colors.white,
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Color(
                              int.parse('0xFF${room.color.substring(1)}'),
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                        title: Text(
                          room.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: isSelected
                                ? AppConstants.primaryBlue
                                : Colors.black87,
                          ),
                        ),
                        subtitle: Text(
                          room.type,
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected
                                ? AppConstants.primaryBlue.withValues(
                                    alpha: 0.7,
                                  )
                                : Colors.grey.shade600,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(
                                Icons.check_circle,
                                color: AppConstants.primaryBlue,
                              )
                            : null,
                        onTap: () {
                          setState(() {
                            _selectedRoom = room;
                            _roomError = null;
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoomSelection() {
    return GestureDetector(
      onTap: _showRoomSelectionBottomSheet,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: _roomError != null
                ? AppConstants.errorColor
                : Colors.grey.shade400,
          ),
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          color: Colors.white,
        ),
        child: Row(
          children: [
            if (_selectedRoom != null) ...[
              Container(
                width: _roomColorIndicatorSize,
                height: _roomColorIndicatorSize,
                decoration: BoxDecoration(
                  color: Color(
                    int.parse('0xFF${_selectedRoom!.color.substring(1)}'),
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${_selectedRoom!.name} (${_selectedRoom!.type})',
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
            ] else ...[
              Expanded(
                child: Text(
                  AppStrings.selectRoomForReport,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
              ),
            ],
            Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    final description = _descriptionController.text;
    final length = description.length;
    final remaining = _maxDescriptionLength - length;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: _descriptionError != null
                      ? AppConstants.errorColor
                      : Colors.grey.shade400,
                ),
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
              child: TextField(
                controller: _descriptionController,
                maxLines: null,
                expands: true,
                maxLength: _maxDescriptionLength,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: AppStrings.describeTheProblem,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                  counterText: '',
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_descriptionError != null)
                Expanded(
                  child: Text(
                    _descriptionError!,
                    style: const TextStyle(
                      color: AppConstants.errorColor,
                      fontSize: 12,
                    ),
                  ),
                )
              else
                const Spacer(),
              Text(
                remaining >= 0
                    ? '$remaining ${AppStrings.charactersRemaining}'
                    : '${remaining.abs()} ${AppStrings.charactersExceeded}',
                style: TextStyle(
                  color: remaining >= 0
                      ? Colors.grey.shade600
                      : AppConstants.errorColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _isSubmitButtonEnabled() {
    final description = _descriptionController.text.trim();
    return !_isSubmitting &&
        _selectedRoom != null &&
        description.isNotEmpty &&
        description.length >= _minDescriptionLength &&
        description.length <= _maxDescriptionLength;
  }

  Widget _buildSubmitButton() {
    final isEnabled = _isSubmitButtonEnabled();

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: isEnabled ? _submitReport : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          disabledBackgroundColor: Colors.grey.shade300,
          disabledForegroundColor: Colors.grey.shade600,
        ),
        child: _isSubmitting
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                AppStrings.submitReport,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppConstants.primaryBlue),
      );
    }

    return Padding(
      padding: AppConstants.screenPadding,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            const Text(
              AppStrings.room,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            _buildRoomSelection(),
            if (_roomError != null) ...[
              const SizedBox(height: 8),
              Text(
                _roomError!,
                style: const TextStyle(
                  color: AppConstants.errorColor,
                  fontSize: 12,
                ),
              ),
            ],

            const SizedBox(height: 24),

            const Text(
              AppStrings.description,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            _buildDescriptionField(),

            const SizedBox(height: 16),

            _buildSubmitButton(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
