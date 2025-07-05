import 'package:flutter/material.dart';
import '../models/models.dart';
import '../constants/app_constants.dart';
import '../services/services.dart';
import '../utils/app_utils.dart';

class AppointmentFilterBottomSheet extends StatefulWidget {
  final DateTime? initialDate;
  final TimeOfDay? initialTimeFrom;
  final TimeOfDay? initialTimeTo;
  final RoomResponse? initialRoom;
  final AppointmentTypeResponse? initialAppointmentType;
  final Function(
    DateTime?,
    TimeOfDay?,
    TimeOfDay?,
    RoomResponse?,
    AppointmentTypeResponse?,
  )
  onApplyFilters;

  const AppointmentFilterBottomSheet({
    super.key,
    this.initialDate,
    this.initialTimeFrom,
    this.initialTimeTo,
    this.initialRoom,
    this.initialAppointmentType,
    required this.onApplyFilters,
  });

  @override
  State<AppointmentFilterBottomSheet> createState() =>
      _AppointmentFilterBottomSheetState();
}

class _AppointmentFilterBottomSheetState
    extends State<AppointmentFilterBottomSheet> {
  static const Color _primaryColor = AppConstants.primaryBlue;
  static const Color _errorColor = AppConstants.errorColor;

  final RoomService _roomService = RoomService();
  final AppointmentTypeService _appointmentTypeService =
      AppointmentTypeService();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTimeFrom;
  TimeOfDay? _selectedTimeTo;
  RoomResponse? _selectedRoom;
  AppointmentTypeResponse? _selectedAppointmentType;
  bool _isLoading = true;

  String? _timeFromError;
  String? _timeToError;

  List<RoomResponse> _rooms = [];
  List<AppointmentTypeResponse> _appointmentTypes = [];

  bool _showRoomDropdown = false;
  bool _showAppointmentTypeDropdown = false;
  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _selectedTimeFrom = widget.initialTimeFrom;
    _selectedTimeTo = widget.initialTimeTo;
    _selectedRoom = widget.initialRoom;
    _selectedAppointmentType = widget.initialAppointmentType;
    _loadData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedTimeFrom != null || _selectedTimeTo != null) {
        _validateTimes();
      }
    });
  }

  Future<void> _loadData() async {
    await Future.wait([_loadRooms(), _loadAppointmentTypes()]);
  }

  Future<void> _loadRooms() async {
    try {
      final rooms = await _roomService.getRooms();
      if (mounted) {
        setState(() {
          _rooms = rooms.where((room) => room.isActive).toList();
        });
      }
    } catch (e) {
      if (mounted) {
        AppUtils.showNetworkErrorSnackbar(
          context,
          'Greška pri učitavanju prostorija. Server ne odgovara',
        );
      }
    }
  }

  Future<void> _loadAppointmentTypes() async {
    try {
      final appointmentTypes = await _appointmentTypeService
          .getAppointmentTypes();
      if (mounted) {
        setState(() {
          _appointmentTypes = appointmentTypes;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        AppUtils.showNetworkErrorSnackbar(
          context,
          'Greška pri učitavanju tipova termina. Server ne odgovara',
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
          _showAppointmentTypeDropdown = false;
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
                                _buildDateFilter(),
                                const SizedBox(height: 16),
                                _buildTimeFilters(),
                                const SizedBox(height: 16),
                                _buildRoomFilter(),
                                const SizedBox(height: 16),
                                _buildAppointmentTypeFilter(),
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
                  bottomInset > 0
                      ? bottomInset + 28
                      : 40,
                ),
                child: _buildActionButtons(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateFilter() {
    final isSelected = _selectedDate != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Datum',
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
                    _selectedDate = null;
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
          onTap: _selectDate,
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
                  Icons.calendar_today,
                  color: isSelected ? _primaryColor : Colors.grey.shade600,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _selectedDate != null
                      ? '${_selectedDate!.day.toString().padLeft(2, '0')}.${_selectedDate!.month.toString().padLeft(2, '0')}.${_selectedDate!.year}'
                      : 'Odaberite datum',
                  style: TextStyle(
                    fontSize: 16,
                    color: isSelected ? _primaryColor : Colors.grey.shade600,
                    fontWeight: isSelected
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

  Widget _buildTimeFilters() {
    return Row(
      children: [
        Expanded(child: _buildTimeFromFilter()),
        const SizedBox(width: 16),
        Expanded(child: _buildTimeToFilter()),
      ],
    );
  }

  Widget _buildTimeFromFilter() {
    final isSelected = _selectedTimeFrom != null;
    final hasError = _timeFromError != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Vrijeme od',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: hasError
                    ? _errorColor
                    : (isSelected ? _primaryColor : Colors.grey.shade600),
              ),
            ),
            const Spacer(),
            if (isSelected)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTimeFrom = null;
                    _timeFromError = null;
                    _timeToError = null;
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
          onTap: () => _selectTimeFrom(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: hasError
                    ? _errorColor
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
                  Icons.access_time,
                  color: hasError
                      ? _errorColor
                      : (isSelected ? _primaryColor : Colors.grey.shade600),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _selectedTimeFrom != null
                      ? '${_selectedTimeFrom!.hour.toString().padLeft(2, '0')}:${_selectedTimeFrom!.minute.toString().padLeft(2, '0')}'
                      : 'Od',
                  style: TextStyle(
                    fontSize: 16,
                    color: hasError
                        ? _errorColor
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

  Widget _buildTimeToFilter() {
    final isSelected = _selectedTimeTo != null;
    final hasError = _timeToError != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Vrijeme do',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: hasError
                    ? _errorColor
                    : (isSelected ? _primaryColor : Colors.grey.shade600),
              ),
            ),
            const Spacer(),
            if (isSelected)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTimeTo = null;
                    _timeFromError = null;
                    _timeToError = null;
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
          onTap: () => _selectTimeTo(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: hasError
                    ? _errorColor
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
                  Icons.access_time,
                  color: hasError
                      ? _errorColor
                      : (isSelected ? _primaryColor : Colors.grey.shade600),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _selectedTimeTo != null
                      ? '${_selectedTimeTo!.hour.toString().padLeft(2, '0')}:${_selectedTimeTo!.minute.toString().padLeft(2, '0')}'
                      : 'Do',
                  style: TextStyle(
                    fontSize: 16,
                    color: hasError
                        ? _errorColor
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

  Widget _buildAppointmentTypeFilter() {
    final isSelected = _selectedAppointmentType != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Tip termina',
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
                    _selectedAppointmentType = null;
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
              _showAppointmentTypeDropdown = !_showAppointmentTypeDropdown;
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
                  Icons.event_note,
                  color: isSelected ? _primaryColor : Colors.grey.shade600,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _selectedAppointmentType?.name ?? 'Odaberite tip termina',
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
                  _showAppointmentTypeDropdown
                      ? Icons.expand_less
                      : Icons.expand_more,
                  color: isSelected ? _primaryColor : Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),
        if (_showAppointmentTypeDropdown) _buildAppointmentTypeDropdown(),
      ],
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

  Widget _buildAppointmentTypeDropdown() {
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
        itemCount: _appointmentTypes.length,
        itemBuilder: (context, index) {
          final appointmentType = _appointmentTypes[index];
          final isSelected = _selectedAppointmentType?.id == appointmentType.id;

          return InkWell(
            onTap: () {
              setState(() {
                _selectedAppointmentType = appointmentType;
                _showAppointmentTypeDropdown = false;
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
                  Icon(
                    Icons.event_note,
                    color: isSelected ? _primaryColor : Colors.grey.shade600,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      appointmentType.name,
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
                _selectedDate = null;
                _selectedTimeFrom = null;
                _selectedTimeTo = null;
                _selectedRoom = null;
                _selectedAppointmentType = null;
                _timeFromError = null;
                _timeToError = null;
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
              if (_selectedTimeFrom != null && _selectedTimeTo != null) {
                _validateTimes();
                if (_timeFromError != null || _timeToError != null) {
                  return; 
                }
              }
              widget.onApplyFilters(
                _selectedDate, 
                _selectedTimeFrom,
                _selectedTimeTo,
                _selectedRoom,
                _selectedAppointmentType,
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

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
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
        _selectedDate = date;
      });
    }
  }

  Future<void> _selectTimeFrom() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTimeFrom ?? TimeOfDay.now(),
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

    if (time != null) {
      setState(() {
        _selectedTimeFrom = time;
        _timeFromError = null;
        _timeToError = null; 
      });
      _validateTimes();
    }
  }

  Future<void> _selectTimeTo() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTimeTo ?? TimeOfDay.now(),
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

    if (time != null) {
      setState(() {
        _selectedTimeTo = time;
        _timeFromError = null; 
        _timeToError = null;
      });
      _validateTimes();
    }
  }

  void _validateTimes() {
    setState(() {
      _timeFromError = null;
      _timeToError = null;
    });

    if (_selectedTimeFrom != null) {
      final fromMinutes =
          _selectedTimeFrom!.hour * 60 + _selectedTimeFrom!.minute;
      if (fromMinutes < 8 * 60 || fromMinutes >= 24 * 60) {
        setState(() {
          _timeFromError = 'Radno vrijeme je od 08:00 do 00:00h';
        });
        _showErrorDialog('Radno vrijeme je od 08:00 do 00:00h.');
        return;
      }
    }

    if (_selectedTimeTo != null) {
      final toMinutes = _selectedTimeTo!.hour * 60 + _selectedTimeTo!.minute;
      if (toMinutes < 8 * 60 || toMinutes > 24 * 60) {
        setState(() {
          _timeToError = 'Radno vrijeme je od 08:00 do 00:00h';
        });
        _showErrorDialog('Radno vrijeme je od 08:00 do 00:00h.');
        return;
      }
    }

    if (_selectedTimeFrom != null && _selectedTimeTo != null) {
      final fromMinutes =
          _selectedTimeFrom!.hour * 60 + _selectedTimeFrom!.minute;
      final toMinutes = _selectedTimeTo!.hour * 60 + _selectedTimeTo!.minute;

      if (fromMinutes == toMinutes) {
        setState(() {
          _timeFromError = 'Vremena ne mogu biti ista';
          _timeToError = 'Vremena ne mogu biti ista';
        });
        _showErrorDialog('Vremena ne mogu biti ista.');
        return;
      }

      if (fromMinutes > toMinutes) {
        setState(() {
          _timeToError = 'Vrijeme do mora biti nakon vremena od';
        });
        _showErrorDialog('Vrijeme do mora biti nakon vremena od.');
        return;
      }

      if (toMinutes - fromMinutes < 30) {
        setState(() {
          _timeFromError = 'Minimalno vrijeme trajanja je 30 minuta';
          _timeToError = 'Minimalno vrijeme trajanja je 30 minuta';
        });
        _showErrorDialog('Minimalno vrijeme trajanja termina je 30 minuta.');
        return;
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          child: Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors
                        .black87,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.priority_high,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadius,
                        ),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'U redu',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
