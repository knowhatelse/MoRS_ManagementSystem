import 'package:flutter/material.dart';
import '../models/models.dart';
import '../constants/app_constants.dart';
import '../services/services.dart';
import '../utils/app_utils.dart';
import '../utils/avatar_utils.dart';
import 'filter_dropdown.dart';
import 'filter_date_time_field.dart';

class AppointmentFilterDialog extends StatefulWidget {
  final DateTime? initialDateFrom;
  final DateTime? initialDateTo;
  final TimeOfDay? initialTimeFrom;
  final TimeOfDay? initialTimeTo;
  final RoomResponse? initialRoom;
  final AppointmentTypeResponse? initialAppointmentType;
  final bool? initialIsRepeating;
  final UserResponse? initialUser;
  final Function(
    DateTime?,
    DateTime?,
    TimeOfDay?,
    TimeOfDay?,
    RoomResponse?,
    AppointmentTypeResponse?,
    bool?,
    UserResponse?,
  )
  onApplyFilters;

  const AppointmentFilterDialog({
    super.key,
    this.initialDateFrom,
    this.initialDateTo,
    this.initialTimeFrom,
    this.initialTimeTo,
    this.initialRoom,
    this.initialAppointmentType,
    this.initialIsRepeating,
    this.initialUser,
    required this.onApplyFilters,
  });

  @override
  State<AppointmentFilterDialog> createState() =>
      _AppointmentFilterDialogState();
}

class _AppointmentFilterDialogState extends State<AppointmentFilterDialog> {
  final RoomService _roomService = RoomService();
  final AppointmentTypeService _appointmentTypeService =
      AppointmentTypeService();
  final UserService _userService = UserService();

  DateTime? _selectedDateFrom;
  DateTime? _selectedDateTo;
  TimeOfDay? _selectedTimeFrom;
  TimeOfDay? _selectedTimeTo;
  RoomResponse? _selectedRoom;
  AppointmentTypeResponse? _selectedAppointmentType;
  bool? _selectedIsRepeating;
  UserResponse? _selectedUser;
  bool _isLoading = true;

  String? _timeFromError;
  String? _timeToError;
  String? _dateFromError;
  String? _dateToError;

  List<RoomResponse> _rooms = [];
  List<AppointmentTypeResponse> _appointmentTypes = [];
  List<UserResponse> _users = [];

  final TextEditingController _userSearchController = TextEditingController();
  final FocusNode _userSearchFocusNode = FocusNode();
  bool _isUserSearching = false;

  @override
  void initState() {
    super.initState();
    _selectedDateFrom = widget.initialDateFrom;
    _selectedDateTo = widget.initialDateTo;
    _selectedTimeFrom = widget.initialTimeFrom;
    _selectedTimeTo = widget.initialTimeTo;
    _selectedRoom = widget.initialRoom;
    _selectedAppointmentType = widget.initialAppointmentType;
    _selectedIsRepeating = widget.initialIsRepeating;
    _selectedUser = widget.initialUser;
    _loadData();
  }

  @override
  void dispose() {
    _userSearchController.dispose();
    _userSearchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await Future.wait([_loadRooms(), _loadAppointmentTypes(), _loadUsers()]);
  }

  Future<void> _loadRooms() async {
    try {
      final rooms = await _roomService.getRooms();
      if (mounted) {
        setState(() {
          _rooms = rooms.where((room) => room.isActive).toList();

          if (_selectedRoom != null) {
            final matchingRoom = _rooms.firstWhere(
              (room) => room.id == _selectedRoom!.id,
              orElse: () => _selectedRoom!,
            );

            if (_rooms.any((room) => room.id == _selectedRoom!.id)) {
              _selectedRoom = matchingRoom;
            } else {
              _selectedRoom = null;
            }
          }
        });
      }
    } catch (e) {
      if (mounted) {
        AppUtils.showErrorSnackBar(context, 'Greška pri učitavanju prostorija. Server ne odgovara');
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

          if (_selectedAppointmentType != null) {
            final matchingType = _appointmentTypes.firstWhere(
              (type) => type.id == _selectedAppointmentType!.id,
              orElse: () => _selectedAppointmentType!,
            );

            if (_appointmentTypes.any(
              (type) => type.id == _selectedAppointmentType!.id,
            )) {
              _selectedAppointmentType = matchingType;
            } else {
              _selectedAppointmentType = null;
            }
          }
        });
      }
    } catch (e) {
      if (mounted) {
        AppUtils.showErrorSnackBar(
          context,
          'Greška pri učitavanju tipova termina. Server ne odgovara',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadUsers() async {
    try {
      final users = await _userService.getUsers();
      if (mounted) {
        setState(() {
          _users = users;

          if (_selectedUser != null) {
            final matchingUser = _users.firstWhere(
              (user) => user.id == _selectedUser!.id,
              orElse: () => _selectedUser!,
            );

            if (_users.any((user) => user.id == _selectedUser!.id)) {
              _selectedUser = matchingUser;
            } else {
              _selectedUser = null;
            }
          }
        });
      }
    } catch (e) {
      if (mounted) {
        AppUtils.showErrorSnackBar(context, 'Greška pri učitavanju korisnika. Server ne odgovara');
      }
    }
  }

  Future<List<UserResponse>> _searchUsers(String query) async {
    if (query.trim().isEmpty || query.length < 2) {
      return [];
    }
    setState(() => _isUserSearching = true);
    try {
      final users = await _userService.searchUsers(query);
      setState(() {
        _isUserSearching = false;
      });
      return users;
    } catch (e) {
      setState(() => _isUserSearching = false);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Container(
        width: 1100,
        constraints: const BoxConstraints(maxHeight: 1000),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: AppConstants.primaryBlue,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppConstants.borderRadius),
                  topRight: Radius.circular(AppConstants.borderRadius),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.filter_list, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  const Text(
                    'Filtriraj termine',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppConstants.primaryBlue,
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDateFromFilter(),
                          const SizedBox(height: 16),
                          _buildDateToFilter(),
                          const SizedBox(height: 16),
                          _buildTimeFilters(),
                          const SizedBox(height: 16),
                          _buildRoomFilter(),
                          const SizedBox(height: 16),
                          _buildAppointmentTypeFilter(),
                          const SizedBox(height: 16),
                          _buildRepeatingFilter(),
                          const SizedBox(height: 16),
                          _buildUserFilter(),
                        ],
                      ),
                    ),
            ),

            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(AppConstants.borderRadius),
                  bottomRight: Radius.circular(AppConstants.borderRadius),
                ),
              ),
              child: Row(
                children: [
                  TextButton(
                    onPressed: _clearFilters,
                    child: const Text(
                      'Ukloni sve',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Otkaži'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Primijeni'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateFromFilter() {
    return FilterDateTimeField(
      label: 'Datum od',
      hint: 'Odaberite datum od',
      value: _selectedDateFrom != null ? _formatDate(_selectedDateFrom!) : null,
      onTap: _selectDateFrom,
      onClear: () => setState(() {
        _selectedDateFrom = null;
        _dateFromError = null;
        _validateDates();
      }),
      icon: Icons.calendar_today,
      hasError: _dateFromError != null,
      errorText: _dateFromError,
    );
  }

  Widget _buildDateToFilter() {
    return FilterDateTimeField(
      label: 'Datum do',
      hint: 'Odaberite datum do',
      value: _selectedDateTo != null ? _formatDate(_selectedDateTo!) : null,
      onTap: _selectDateTo,
      onClear: () => setState(() {
        _selectedDateTo = null;
        _dateToError = null;
        _validateDates();
      }),
      icon: Icons.calendar_today,
      hasError: _dateToError != null,
      errorText: _dateToError,
    );
  }

  Widget _buildTimeFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vrijeme',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildTimeFromFilter()),
            const SizedBox(width: 16),
            Expanded(child: _buildTimeToFilter()),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeFromFilter() {
    final isSelected = _selectedTimeFrom != null;
    final hasError = _timeFromError != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Od', style: TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: hasError
                  ? Colors.red
                  : isSelected
                  ? AppConstants.primaryBlue
                  : Colors.grey.shade300,
              width: hasError ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: _selectTimeFrom,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: isSelected ? AppConstants.primaryBlue : Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _selectedTimeFrom != null
                          ? _formatTime(_selectedTimeFrom!)
                          : 'Vrijeme od',
                      style: TextStyle(
                        color: isSelected
                            ? Colors.black87
                            : Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  if (isSelected)
                    GestureDetector(
                      onTap: () => setState(() {
                        _selectedTimeFrom = null;
                        _timeFromError = null;
                        _validateTimes();
                      }),
                      child: Icon(
                        Icons.clear,
                        color: Colors.grey.shade600,
                        size: 16,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _timeFromError!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
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
        const Text('Do', style: TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: hasError
                  ? Colors.red
                  : isSelected
                  ? AppConstants.primaryBlue
                  : Colors.grey.shade300,
              width: hasError ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: _selectTimeTo,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: isSelected ? AppConstants.primaryBlue : Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _selectedTimeTo != null
                          ? _formatTime(_selectedTimeTo!)
                          : 'Vrijeme do',
                      style: TextStyle(
                        color: isSelected
                            ? Colors.black87
                            : Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  if (isSelected)
                    GestureDetector(
                      onTap: () => setState(() {
                        _selectedTimeTo = null;
                        _timeToError = null;
                        _validateTimes();
                      }),
                      child: Icon(
                        Icons.clear,
                        color: Colors.grey.shade600,
                        size: 16,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _timeToError!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildRoomFilter() {
    return FilterDropdown<RoomResponse>(
      label: 'Prostorija',
      hint: 'Odaberite prostoriju',
      value: _selectedRoom,
      onChanged: (room) => setState(() => _selectedRoom = room),
      items: [
        const DropdownMenuItem<RoomResponse?>(
          value: null,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Sve prostorije'),
          ),
        ),
        ..._rooms.map(
          (room) => DropdownMenuItem<RoomResponse?>(
            value: room,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(room.name),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentTypeFilter() {
    return FilterDropdown<AppointmentTypeResponse>(
      label: 'Tip termina',
      hint: 'Odaberite tip termina',
      value: _selectedAppointmentType,
      onChanged: (type) => setState(() => _selectedAppointmentType = type),
      items: [
        const DropdownMenuItem<AppointmentTypeResponse?>(
          value: null,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Svi tipovi'),
          ),
        ),
        ..._appointmentTypes.map(
          (type) => DropdownMenuItem<AppointmentTypeResponse?>(
            value: type,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(type.name),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRepeatingFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Stalni termin',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: _selectedIsRepeating != null
                  ? AppConstants.primaryBlue
                  : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<bool?>(
              isExpanded: true,
              value: _selectedIsRepeating,
              hint: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(
                  'Svi termini',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              onChanged: (value) =>
                  setState(() => _selectedIsRepeating = value),
              items: const [
                DropdownMenuItem<bool?>(
                  value: null,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Svi termini'),
                  ),
                ),
                DropdownMenuItem<bool?>(
                  value: true,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Samo stalni termini'),
                  ),
                ),
                DropdownMenuItem<bool?>(
                  value: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Samo jednokratni termini'),
                  ),
                ),
              ],
              dropdownColor: Colors.white,
              icon: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(
                  Icons.arrow_drop_down,
                  color: _selectedIsRepeating != null
                      ? AppConstants.primaryBlue
                      : Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Korisnik',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        RawAutocomplete<UserResponse>(
          textEditingController: _userSearchController,
          focusNode: _userSearchFocusNode,
          displayStringForOption: (u) => u.fullName,
          optionsBuilder: (TextEditingValue textEditingValue) async {
            if (textEditingValue.text.length < 2) {
              return const [];
            }
            return await _searchUsers(textEditingValue.text);
          },
          onSelected: (UserResponse user) {
            setState(() {
              _selectedUser = user;
            });
            _userSearchController.clear();
          },
          fieldViewBuilder:
              (context, controller, focusNode, onFieldSubmitted) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: 'Pretraži korisnike',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: _isUserSearching
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          )
                        : (controller.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    controller.clear();
                                    setState(() {
                                      _selectedUser = null;
                                    });
                                  },
                                )
                              : null),
                  ),
                  onChanged: (value) {},
                );
              },
          optionsViewBuilder: (context, onSelected, options) {
            return Material(
              elevation: 4,
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final user = options.elementAt(index);
                  return ListTile(
                    onTap: () => onSelected(user),
                    leading: AvatarUtils.buildUserAvatar(user),
                    title: Text(
                      user.fullName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    minVerticalPadding: 0,
                    dense: true,
                  );
                },
              ),
            );
          },
        ),
        if (_selectedUser != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Chip(
              label: Text(_selectedUser!.fullName),
              onDeleted: () => setState(() => _selectedUser = null),
              deleteIcon: const Icon(Icons.close, size: 18),
              backgroundColor: Color.fromRGBO(
                (AppConstants.primaryBlue.r * 255.0).round() & 0xff,
                (AppConstants.primaryBlue.g * 255.0).round() & 0xff,
                (AppConstants.primaryBlue.b * 255.0).round() & 0xff,
                0.08,
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
              primary: AppConstants.primaryBlue,
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
        _dateFromError = null;
      });
      _validateDates();
    }
  }

  Future<void> _selectDateTo() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTo ?? _selectedDateFrom ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppConstants.primaryBlue,
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
        _dateToError = null;
      });
      _validateDates();
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
              primary: AppConstants.primaryBlue,
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
      });
      _validateTimes();
    }
  }

  Future<void> _selectTimeTo() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTimeTo ?? _selectedTimeFrom ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppConstants.primaryBlue,
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
        _timeToError = null;
      });
      _validateTimes();
    }
  }

  void _validateDates() {
    setState(() {
      _dateFromError = null;
      _dateToError = null;
    });

    if (_selectedDateFrom != null && _selectedDateTo != null) {
      if (_selectedDateFrom!.isAfter(_selectedDateTo!)) {
        setState(() {
          _dateToError = 'Datum "Do" mora biti nakon datuma "Od"';
        });
      } else if (_selectedDateFrom!.isAtSameMomentAs(_selectedDateTo!)) {
        setState(() {
          _dateToError = 'Datum "Do" ne može biti isti kao datum "Od"';
        });
      }
    }
  }

  void _validateTimes() {
    setState(() {
      _timeFromError = null;
      _timeToError = null;
    });

    if (_selectedTimeFrom != null && _selectedTimeTo != null) {
      final fromMinutes =
          _selectedTimeFrom!.hour * 60 + _selectedTimeFrom!.minute;
      final toMinutes = _selectedTimeTo!.hour * 60 + _selectedTimeTo!.minute;

      if (fromMinutes >= toMinutes) {
        setState(() {
          _timeToError = 'Vrijeme "Do" mora biti nakon vremena "Od"';
        });
      }
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedDateFrom = null;
      _selectedDateTo = null;
      _selectedTimeFrom = null;
      _selectedTimeTo = null;
      _selectedRoom = null;
      _selectedAppointmentType = null;
      _selectedIsRepeating = null;
      _selectedUser = null;
      _timeFromError = null;
      _timeToError = null;
      _dateFromError = null;
      _dateToError = null;
    });
  }

  void _applyFilters() {
    if (_timeFromError != null ||
        _timeToError != null ||
        _dateFromError != null ||
        _dateToError != null) {
      return;
    }

    widget.onApplyFilters(
      _selectedDateFrom,
      _selectedDateTo,
      _selectedTimeFrom,
      _selectedTimeTo,
      _selectedRoom,
      _selectedAppointmentType,
      _selectedIsRepeating,
      _selectedUser,
    );
    Navigator.of(context).pop();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
