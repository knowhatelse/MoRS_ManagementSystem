import 'package:flutter/material.dart';
import '../models/models.dart';
import '../constants/app_constants.dart';
import '../services/services.dart';
import '../utils/app_utils.dart';

class MyAppointmentFilterBottomSheet extends StatefulWidget {
  final DateTime? initialDateFrom;
  final DateTime? initialDateTo;
  final RoomResponse? initialRoom;
  final bool initialShowMyAppointments;
  final bool initialShowOtherAppointments;
  final bool initialShowCancelledAppointments;
  final Function(DateTime?, DateTime?, RoomResponse?, bool, bool, bool)
  onApplyFilters;

  const MyAppointmentFilterBottomSheet({
    super.key,
    this.initialDateFrom,
    this.initialDateTo,
    this.initialRoom,
    required this.initialShowMyAppointments,
    required this.initialShowOtherAppointments,
    required this.initialShowCancelledAppointments,
    required this.onApplyFilters,
  });

  @override
  State<MyAppointmentFilterBottomSheet> createState() =>
      _MyAppointmentFilterBottomSheetState();
}

class _MyAppointmentFilterBottomSheetState
    extends State<MyAppointmentFilterBottomSheet> {
  static const Color _primaryColor = AppConstants.primaryBlue;

  final RoomService _roomService = RoomService();
  DateTime? _selectedDateFrom;
  DateTime? _selectedDateTo;
  RoomResponse? _selectedRoom;
  bool _showMyAppointments = false;
  bool _showOtherAppointments = false;
  bool _showCancelledAppointments = false;
  bool _isLoading = true;

  String? _dateError;

  List<RoomResponse> _rooms = [];
  bool _showRoomDropdown = false;

  @override
  void initState() {
    super.initState();
    _selectedDateFrom = widget.initialDateFrom;
    _selectedDateTo = widget.initialDateTo;
    _selectedRoom = widget.initialRoom;
    _showMyAppointments = widget.initialShowMyAppointments;
    _showOtherAppointments = widget.initialShowOtherAppointments;
    _showCancelledAppointments = widget.initialShowCancelledAppointments;
    _loadRooms();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedDateFrom != null || _selectedDateTo != null) {
        _validateDates();
      }
    });
  }

  Future<void> _loadRooms() async {
    try {
      final rooms = await _roomService.getRooms();
      if (mounted) {
        setState(() {
          _rooms = rooms.where((room) => room.isActive).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        AppUtils.showNetworkErrorSnackbar(
          context,
          'Greška pri učitavanju prostorija. Server ne odgovara',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () {
        setState(() {
          _showRoomDropdown = false;
        });
      },
      child: Container(
        constraints: BoxConstraints(maxHeight: screenSize.height * 0.85),
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
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 16.0),
                child: Row(
                  children: [
                    Icon(Icons.filter_list, color: _primaryColor, size: 24),
                    const SizedBox(width: 8),
                    const Text(
                      'Filteri',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _primaryColor,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: _primaryColor),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: _primaryColor),
                      )
                    : CustomScrollView(
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            sliver: SliverList(
                              delegate: SliverChildListDelegate([
                                _buildDateFilters(),
                                const SizedBox(height: 16),
                                _buildRoomFilter(),
                                const SizedBox(height: 16),
                                _buildAppointmentTypeFilters(),
                                const SizedBox(height: 24),
                              ]),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: SizedBox(height: bottomInset > 0 ? 80 : 24),
                          ),
                        ],
                      ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  0,
                  20,
                  bottomInset > 0 ? bottomInset + 28 : 40,
                ),
                child: _buildActionButtons(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _buildDateFromFilter()),
            const SizedBox(width: 16),
            Expanded(child: _buildDateToFilter()),
          ],
        ),
        if (_dateError != null) ...[
          const SizedBox(height: 8),
          Text(
            _dateError!,
            style: const TextStyle(
              color: AppConstants.errorColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDateFromFilter() {
    final isSelected = _selectedDateFrom != null;
    final hasError = _dateError != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Datum od',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: hasError
                    ? AppConstants.errorColor
                    : (isSelected ? _primaryColor : Colors.grey.shade600),
              ),
            ),
            const Spacer(),
            if (isSelected)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDateFrom = null;
                    _dateError = null;
                  });
                },
                child: Text(
                  'Resetuj',
                  style: TextStyle(
                    color: _primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: _selectDateFrom,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: hasError
                    ? AppConstants.errorColor
                    : (isSelected ? _primaryColor : Colors.grey.shade400),
                width: isSelected || hasError ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              color: isSelected
                  ? _primaryColor.withValues(alpha: 0.05)
                  : Colors.white,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: hasError
                      ? AppConstants.errorColor
                      : (isSelected ? _primaryColor : Colors.grey.shade600),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  _selectedDateFrom != null
                      ? '${_selectedDateFrom!.day.toString().padLeft(2, '0')}.${_selectedDateFrom!.month.toString().padLeft(2, '0')}.${_selectedDateFrom!.year}'
                      : 'Od',
                  style: TextStyle(
                    fontSize: 14,
                    color: hasError
                        ? AppConstants.errorColor
                        : (isSelected ? _primaryColor : Colors.grey.shade600),
                    fontWeight: isSelected || hasError
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateToFilter() {
    final isSelected = _selectedDateTo != null;
    final hasError = _dateError != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Datum do',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: hasError
                    ? AppConstants.errorColor
                    : (isSelected ? _primaryColor : Colors.grey.shade600),
              ),
            ),
            const Spacer(),
            if (isSelected)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDateTo = null;
                    _dateError = null;
                  });
                },
                child: Text(
                  'Resetuj',
                  style: TextStyle(
                    color: _primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: _selectDateTo,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: hasError
                    ? AppConstants.errorColor
                    : (isSelected ? _primaryColor : Colors.grey.shade400),
                width: isSelected || hasError ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              color: isSelected
                  ? _primaryColor.withValues(alpha: 0.05)
                  : Colors.white,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: hasError
                      ? AppConstants.errorColor
                      : (isSelected ? _primaryColor : Colors.grey.shade600),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  _selectedDateTo != null
                      ? '${_selectedDateTo!.day.toString().padLeft(2, '0')}.${_selectedDateTo!.month.toString().padLeft(2, '0')}.${_selectedDateTo!.year}'
                      : 'Do',
                  style: TextStyle(
                    fontSize: 14,
                    color: hasError
                        ? AppConstants.errorColor
                        : (isSelected ? _primaryColor : Colors.grey.shade600),
                    fontWeight: isSelected || hasError
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoomFilter() {
    final isSelected = _selectedRoom != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Prostorija',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? _primaryColor : Colors.grey.shade600,
              ),
            ),
            const Spacer(),
            if (isSelected)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedRoom = null;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Resetuj',
                    style: TextStyle(
                      color: _primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () {
            setState(() {
              _showRoomDropdown = !_showRoomDropdown;
            });
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? _primaryColor : Colors.grey.shade400,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              color: isSelected
                  ? _primaryColor.withValues(alpha: 0.05)
                  : Colors.white,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.meeting_room,
                  color: isSelected ? _primaryColor : Colors.grey.shade600,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _selectedRoom?.name ?? 'Odaberite prostoriju',
                    style: TextStyle(
                      fontSize: 16,
                      color: isSelected ? _primaryColor : Colors.grey.shade600,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
                Icon(
                  _showRoomDropdown ? Icons.expand_less : Icons.expand_more,
                  color: isSelected ? _primaryColor : Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),
        if (_showRoomDropdown) _buildRoomDropdown(),
      ],
    );
  }

  Widget _buildAppointmentTypeFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipovi termina',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Column(
          children: [
            _buildCheckboxFilter(
              'Moji termini',
              'Termini koje ste vi rezervirali',
              _showMyAppointments,
              (value) => setState(() => _showMyAppointments = value ?? true),
            ),
            _buildCheckboxFilter(
              'Ostali termini',
              'Termini gdje ste dodani kao polaznik',
              _showOtherAppointments,
              (value) => setState(() => _showOtherAppointments = value ?? true),
            ),
            _buildCheckboxFilter(
              'Otkazani termini',
              'Termini koji su otkazani',
              _showCancelledAppointments,
              (value) =>
                  setState(() => _showCancelledAppointments = value ?? true),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCheckboxFilter(
    String title,
    String subtitle,
    bool value,
    Function(bool?) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: _primaryColor,
            checkColor: Colors.white,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: value ? _primaryColor : Colors.grey.shade700,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomDropdown() {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      constraints: const BoxConstraints(maxHeight: 200),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _rooms.length,
        itemBuilder: (context, index) {
          final room = _rooms[index];
          final isSelected = _selectedRoom?.id == room.id;

          return InkWell(
            onTap: () {
              setState(() {
                _selectedRoom = room;
                _showRoomDropdown = false;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                border: index > 0
                    ? Border(top: BorderSide(color: Colors.grey.shade200))
                    : null,
                color: isSelected ? _primaryColor.withValues(alpha: 0.1) : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Color(
                        int.parse('0xFF${room.color.replaceAll('#', '')}'),
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      room.name,
                      style: TextStyle(
                        fontSize: 16,
                        color: isSelected ? _primaryColor : Colors.black87,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(Icons.check, color: _primaryColor, size: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                _selectedDateFrom = null;
                _selectedDateTo = null;
                _selectedRoom = null;
                _showMyAppointments = false;
                _showOtherAppointments = false;
                _showCancelledAppointments = false;
                _dateError = null;
              });
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: _primaryColor),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Resetuj sve',
              style: TextStyle(
                color: _primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              if (_selectedDateFrom != null && _selectedDateTo != null) {
                _validateDates();
                if (_dateError != null) {
                  return;
                }
              }

              widget.onApplyFilters(
                _selectedDateFrom,
                _selectedDateTo,
                _selectedRoom,
                _showMyAppointments,
                _showOtherAppointments,
                _showCancelledAppointments,
              );
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Primijeni',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDateFrom() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateFrom ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        _selectedDateFrom = date;
        _dateError = null;
      });
      _validateDates();
    }
  }

  Future<void> _selectDateTo() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTo ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        _selectedDateTo = date;
        _dateError = null;
      });
      _validateDates();
    }
  }

  void _validateDates() {
    setState(() {
      _dateError = null;
    });

    if (_selectedDateFrom != null && _selectedDateTo != null) {
      if (_selectedDateFrom!.isAfter(_selectedDateTo!)) {
        setState(() {
          _dateError = 'Datum "Od" mora biti prije datuma "Do"';
        });
      }
    }
  }
}
