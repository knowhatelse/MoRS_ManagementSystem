import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import '../models/models.dart';
import '../constants/app_constants.dart';
import '../services/services.dart';
import '../utils/app_utils.dart';
import '../utils/avatar_utils.dart';

class CreateAppointmentBottomSheet extends StatefulWidget {
  final UserResponse currentUser;

  const CreateAppointmentBottomSheet({super.key, required this.currentUser});

  @override
  State<CreateAppointmentBottomSheet> createState() =>
      _CreateAppointmentBottomSheetState();
}

class _CreateAppointmentBottomSheetState
    extends State<CreateAppointmentBottomSheet>
    with TickerProviderStateMixin {
  static const Color _primaryColor = AppConstants.primaryBlue;
  static const Color _errorColor = AppConstants.errorColor;
  String? _focusedField;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  final RoomService _roomService = RoomService();
  final AppointmentTypeService _appointmentTypeService =
      AppointmentTypeService();
  final UserService _userService = UserService();
  final AppointmentService _appointmentService = AppointmentService();

  DateTime? _selectedDate;
  TimeOfDay? _timeFrom;
  TimeOfDay? _timeTo;
  RoomResponse? _selectedRoom;
  AppointmentTypeResponse? _selectedAppointmentType;
  final List<UserResponse> _selectedAttendees = [];
  bool _isRepeating = false;
  bool _isLoading = false;
  bool _isSearchingUsers = false;
  String? _dateError;
  String? _timeFromError;
  String? _timeToError;
  String? _roomError;
  String? _appointmentTypeError;
  bool _roomDropdownOpened = false;
  bool _appointmentTypeDropdownOpened = false;
  bool _showRoomDropdown = false;
  bool _showAppointmentTypeDropdown = false;

  List<RoomResponse> _rooms = [];
  List<AppointmentTypeResponse> _appointmentTypes = [];
  List<UserResponse> _searchResults = [];
  final FocusNode _userSearchFocusNode = FocusNode();
  final TextEditingController _userSearchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 24.0,
    ).chain(CurveTween(curve: Curves.elasticIn)).animate(_shakeController);
    _userSearchFocusNode.addListener(() {
      setState(() {
        if (_userSearchFocusNode.hasFocus) {
          _focusedField = 'userSearch';
          _scrollToSearchField();
        } else {
          if (_focusedField == 'userSearch') {
            _focusedField = null;
          }
        }
      });
    });
    _loadInitialData();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _userSearchFocusNode.dispose();
    _userSearchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);

    try {
      final rooms = await _roomService.getActiveRooms();
      setState(() {
        _rooms = rooms;
      });
    } catch (e) {
      if (mounted) {
        AppUtils.showNetworkErrorSnackbar(
          context,
          'Greška pri učitavanju prostorija. Server ne odgovara',
        );
      }
    }

    try {
      final appointmentTypes = await _appointmentTypeService
          .getAppointmentTypes();
      setState(() {
        _appointmentTypes = appointmentTypes;
      });
    } catch (e) {
      if (mounted) {
        AppUtils.showNetworkErrorSnackbar(
          context,
          'Greška pri učitavanju tipova termina. Server ne odgovara',
        );
      }
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        if (FocusScope.of(context).hasFocus) {
          FocusScope.of(context).unfocus();
          return;
        }
        setState(() {
          _focusedField = null;
          _showRoomDropdown = false;
          _showAppointmentTypeDropdown = false;
        });
        _checkDropdownSelection();
      },
      child: Container(
        constraints: BoxConstraints(maxHeight: screenSize.height * 0.85),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
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
                  Icon(Icons.access_time, color: _primaryColor, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    AppStrings.newAppointment,
                    style: const TextStyle(
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
                      controller: _scrollController,
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              _buildDateField(),
                              const SizedBox(height: 16),
                              _buildTimeFields(),
                              const SizedBox(height: 16),
                              _buildRoomField(),
                              const SizedBox(height: 16),
                              _buildAppointmentTypeField(),
                              const SizedBox(height: 24),
                            ]),
                          ),
                        ),

                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          sliver: SliverToBoxAdapter(
                            child: _buildUserSearchSection(),
                          ),
                        ),

                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          sliver: SliverToBoxAdapter(
                            child: Column(
                              children: [
                                const SizedBox(height: 16),
                                _buildRepeatingSwitch(),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(
                            20.0,
                            20.0,
                            20.0,
                            10.0,
                          ),
                          sliver: SliverToBoxAdapter(
                            child: _buildActionButton(),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(height: keyboardHeight > 0 ? 50 : 10),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserSearchSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dodajte korisnika',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _focusedField == 'userSearch'
                ? _primaryColor
                : Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 8),

        TextField(
          controller: _userSearchController,
          focusNode: _userSearchFocusNode,
          decoration: InputDecoration(
            hintText: AppStrings.searchUsers,
            hintStyle: TextStyle(color: Colors.grey.shade600),
            prefixIcon: Icon(
              Icons.search,
              color: _focusedField == 'userSearch'
                  ? _primaryColor
                  : Colors.grey.shade600,
            ),
            suffixIcon: _isSearchingUsers
                ? const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : (_userSearchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _userSearchController.clear();
                            setState(() {
                              _searchResults.clear();
                            });
                          },
                        )
                      : null),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: BorderSide(color: _primaryColor, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
          onChanged: _searchUsers,
          textInputAction: TextInputAction.search,
        ),
        if (_searchResults.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _primaryColor.withValues(alpha: 0.05),
              border: Border.all(color: _primaryColor.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final user = _searchResults[index];
                final isSelected = _selectedAttendees.any(
                  (u) => u.id == user.id,
                );

                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _primaryColor.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: AvatarUtils.buildUserAvatar(
                      user,
                      isSelected: isSelected,
                    ),
                    title: Text(
                      '${user.name} ${user.surname}',
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: isSelected ? _primaryColor : Colors.black87,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(
                            Icons.check_circle,
                            color: _primaryColor,
                            size: 24,
                          )
                        : Icon(
                            Icons.add_circle_outline,
                            color: Colors.grey.shade600,
                            size: 24,
                          ),
                    onTap: () => _toggleUserSelection(user),
                  ),
                );
              },
            ),
          ),
        ],

        if (_selectedAttendees.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildSelectedAttendees(),
        ],
      ],
    );
  }

  Widget _buildDateField() {
    final isActive = _focusedField == 'date' || _selectedDate != null;
    final hasError = _dateError != null;

    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: hasError ? Offset(_shakeAnimation.value, 0.0) : Offset.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Datum',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: hasError
                      ? _errorColor
                      : (isActive ? _primaryColor : Colors.grey.shade600),
                ),
              ),
              const SizedBox(height: 4),
              InkWell(
                onTap: () {
                  _clearDateError();
                  setState(() => _focusedField = 'date');
                  _selectDate();
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: hasError
                          ? _errorColor
                          : (isActive ? _primaryColor : Colors.grey.shade400),
                      width: isActive || hasError ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadius,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: hasError
                            ? _errorColor
                            : (isActive ? _primaryColor : Colors.grey.shade600),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _selectedDate == null
                            ? 'Odaberi datum'
                            : '${_selectedDate!.day.toString().padLeft(2, '0')}.${_selectedDate!.month.toString().padLeft(2, '0')}.${_selectedDate!.year}',
                        style: TextStyle(
                          color: hasError
                              ? _errorColor
                              : (isActive
                                    ? _primaryColor
                                    : (_selectedDate == null
                                          ? Colors.grey.shade600
                                          : Colors.black87)),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimeFields() {
    return Row(
      children: [
        Expanded(child: _buildTimeField(true)),
        const SizedBox(width: 16),
        Expanded(child: _buildTimeField(false)),
      ],
    );
  }

  Widget _buildTimeField(bool isFrom) {
    final fieldKey = isFrom ? 'timeFrom' : 'timeTo';
    final time = isFrom ? _timeFrom : _timeTo;
    final hasError = isFrom ? _timeFromError != null : _timeToError != null;
    final isActive = _focusedField == fieldKey || time != null;

    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: hasError ? Offset(_shakeAnimation.value, 0.0) : Offset.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isFrom ? 'Od' : 'Do',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: hasError
                      ? _errorColor
                      : (isActive ? _primaryColor : Colors.grey.shade600),
                ),
              ),
              const SizedBox(height: 4),
              InkWell(
                onTap: () {
                  if (isFrom) {
                    _clearTimeFromError();
                  } else {
                    _clearTimeToError();
                  }
                  setState(() => _focusedField = fieldKey);
                  _selectTime(isFrom);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: hasError
                          ? _errorColor
                          : (isActive ? _primaryColor : Colors.grey.shade400),
                      width: isActive || hasError ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadius,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: hasError
                            ? _errorColor
                            : (isActive ? _primaryColor : Colors.grey.shade600),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        time?.format(context) ?? 'Odaberi vrijeme',
                        style: TextStyle(
                          color: hasError
                              ? _errorColor
                              : (isActive
                                    ? _primaryColor
                                    : (time == null
                                          ? Colors.grey.shade600
                                          : Colors.black87)),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRoomField() {
    final isActive = _focusedField == 'room' || _selectedRoom != null;
    final hasError = _roomError != null;

    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: hasError ? Offset(_shakeAnimation.value, 0.0) : Offset.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Prostorija',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: hasError
                      ? _errorColor
                      : (isActive ? _primaryColor : Colors.grey.shade600),
                ),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _focusedField = 'room';
                    _roomDropdownOpened = true;
                    final wasOpen = _showRoomDropdown;
                    _showRoomDropdown = !_showRoomDropdown;
                    _showAppointmentTypeDropdown = false;
                    if (wasOpen &&
                        !_showRoomDropdown &&
                        _selectedRoom == null) {
                      _roomError = 'Ovo polje je obavezno';
                      _roomDropdownOpened = false;
                    }
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: hasError
                          ? _errorColor
                          : (isActive ? _primaryColor : Colors.grey.shade400),
                      width: isActive || hasError ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadius,
                    ),
                  ),
                  child: Row(
                    children: [
                      if (_selectedRoom != null) ...[
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: _parseHexColor(_selectedRoom!.color),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Text(
                          _selectedRoom?.name ??
                              (_rooms.isEmpty
                                  ? 'Nema dostupnih prostorija'
                                  : 'Odaberi prostoriju'),
                          style: TextStyle(
                            color: hasError
                                ? _errorColor
                                : (isActive
                                      ? _primaryColor
                                      : (_selectedRoom == null
                                            ? Colors.grey.shade600
                                            : Colors.black87)),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Icon(
                        _showRoomDropdown
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: hasError
                            ? _errorColor
                            : (isActive ? _primaryColor : Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ),
              if (_showRoomDropdown && _rooms.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadius,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    itemCount: _rooms.length,
                    itemBuilder: (context, index) {
                      final room = _rooms[index];
                      final isSelected = _selectedRoom?.id == room.id;
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _primaryColor.withValues(alpha: 0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: _parseHexColor(room.color),
                              shape: BoxShape.circle,
                            ),
                          ),
                          title: Text(
                            room.name,
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: isSelected
                                  ? _primaryColor
                                  : Colors.black87,
                            ),
                          ),
                          trailing: isSelected
                              ? Icon(
                                  Icons.check_circle,
                                  color: _primaryColor,
                                  size: 24,
                                )
                              : null,
                          onTap: () {
                            setState(() {
                              _selectedRoom = room;
                              _focusedField = 'room';
                              _clearRoomError();
                              _showRoomDropdown = false;
                              _roomDropdownOpened = false;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppointmentTypeField() {
    final isActive =
        _focusedField == 'appointmentType' || _selectedAppointmentType != null;
    final hasError = _appointmentTypeError != null;

    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: hasError ? Offset(_shakeAnimation.value, 0.0) : Offset.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tip termina',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: hasError
                      ? _errorColor
                      : (isActive ? _primaryColor : Colors.grey.shade600),
                ),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _focusedField = 'appointmentType';
                    _appointmentTypeDropdownOpened = true;
                    final wasOpen = _showAppointmentTypeDropdown;
                    _showAppointmentTypeDropdown =
                        !_showAppointmentTypeDropdown;
                    _showRoomDropdown = false;
                    if (wasOpen &&
                        !_showAppointmentTypeDropdown &&
                        _selectedAppointmentType == null) {
                      _appointmentTypeError = 'Ovo polje je obavezno';
                      _appointmentTypeDropdownOpened = false;
                    }
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: hasError
                          ? _errorColor
                          : (isActive ? _primaryColor : Colors.grey.shade400),
                      width: isActive || hasError ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadius,
                    ),
                  ),
                  child: Row(
                    children: [
                      if (_selectedAppointmentType != null) ...[
                        Icon(Icons.event, size: 16, color: _primaryColor),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Text(
                          _selectedAppointmentType?.name ??
                              (_appointmentTypes.isEmpty
                                  ? 'Nema dostupnih tipova termina'
                                  : 'Odaberi tip termina'),
                          style: TextStyle(
                            color: hasError
                                ? _errorColor
                                : (isActive
                                      ? _primaryColor
                                      : (_selectedAppointmentType == null
                                            ? Colors.grey.shade600
                                            : Colors.black87)),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Icon(
                        _showAppointmentTypeDropdown
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: hasError
                            ? _errorColor
                            : (isActive ? _primaryColor : Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ),
              if (_showAppointmentTypeDropdown &&
                  _appointmentTypes.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadius,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    itemCount: _appointmentTypes.length,
                    itemBuilder: (context, index) {
                      final type = _appointmentTypes[index];
                      final isSelected =
                          _selectedAppointmentType?.id == type.id;
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _primaryColor.withValues(alpha: 0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.event,
                            size: 20,
                            color: isSelected
                                ? _primaryColor
                                : Colors.grey.shade600,
                          ),
                          title: Text(
                            type.name,
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: isSelected
                                  ? _primaryColor
                                  : Colors.black87,
                            ),
                          ),
                          trailing: isSelected
                              ? Icon(
                                  Icons.check_circle,
                                  color: _primaryColor,
                                  size: 24,
                                )
                              : null,
                          onTap: () {
                            setState(() {
                              _selectedAppointmentType = type;
                              _focusedField = 'appointmentType';
                              _clearAppointmentTypeError();
                              _showAppointmentTypeDropdown = false;
                              _appointmentTypeDropdownOpened = false;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildSelectedAttendees() {
    if (_selectedAttendees.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Odabrani polaznici: (${_selectedAttendees.length})',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _primaryColor.withValues(alpha: 0.05),
            border: Border.all(color: _primaryColor.withValues(alpha: 0.2)),
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedAttendees.map((user) {
              return Chip(
                avatar: CircleAvatar(
                  backgroundColor: _primaryColor,
                  child: Text(
                    '${user.name[0]}${user.surname[0]}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                label: Text(
                  '${user.name} ${user.surname}',
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                ),
                deleteIcon: Icon(Icons.close, size: 18, color: _primaryColor),
                onDeleted: () => _removeUser(user),
                backgroundColor: Colors.white,
                side: BorderSide(color: _primaryColor.withValues(alpha: 0.3)),
                elevation: 1,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRepeatingSwitch() {
    final userRoleId = widget.currentUser.role?.id;
    if (userRoleId == null || (userRoleId != 1 && userRoleId != 2)) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        Text(
          'Ponavljajući termin',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _isRepeating ? _primaryColor : Colors.grey.shade600,
          ),
        ),
        const Spacer(),
        Switch(
          value: _isRepeating,
          onChanged: (value) {
            setState(() {
              _isRepeating = value;
            });
          },
          activeColor: _primaryColor,
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    final isFormValid = _isFormValid;

    return Center(
      child: IntrinsicWidth(
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 200),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : (isFormValid ? _createAppointment : null),
              style: ElevatedButton.styleFrom(
                backgroundColor: isFormValid
                    ? _primaryColor
                    : Colors.grey.shade400,
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
                elevation: isFormValid ? 2 : 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      AppStrings.createAppointment,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isFormValid
                            ? Colors.white
                            : Colors.grey.shade600,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('bs', 'BA'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: _primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: _primaryColor),
            ),
          ),
          child: child!,
        );
      },
      cancelText: 'Otkaži',
      confirmText: 'Odaberi',
      helpText: 'Odaberi datum',
    );

    setState(() {
      if (picked != null) {
        _selectedDate = picked;
        _clearDateError();
      } else {
        if (_selectedDate == null) {
          _dateError = 'Ovo polje je obavezno';
        }
        _focusedField = null;
      }
    });
  }

  Future<void> _selectTime(bool isFrom) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: (isFrom ? _timeFrom : _timeTo) ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: _primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: _primaryColor),
            ),
          ),
          child: child!,
        );
      },
      cancelText: 'Otkaži',
      confirmText: 'Odaberi',
      helpText: isFrom ? 'Odaberi početno vrijeme' : 'Odaberi krajnje vrijeme',
    );

    setState(() {
      if (picked != null) {
        if (isFrom) {
          _timeFrom = picked;
          _clearTimeFromError();
        } else {
          _timeTo = picked;
          _clearTimeToError();
        }
      } else {
        if (isFrom && _timeFrom == null) {
          _timeFromError = 'Ovo polje je obavezno';
        } else if (!isFrom && _timeTo == null) {
          _timeToError = 'Ovo polje je obavezno';
        }
        _focusedField = null;
      }
    });
  }

  Future<void> _searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearchingUsers = false;
      });
      return;
    }

    setState(() => _isSearchingUsers = true);

    try {
      final results = await _userService.searchUsers(query);
      setState(() {
        _searchResults = results
            .where((user) => user.id != widget.currentUser.id)
            .toList();
        _isSearchingUsers = false;
      });
    } catch (e) {
      setState(() {
        _searchResults = [];
        _isSearchingUsers = false;
      });
    }
  }

  void _toggleUserSelection(UserResponse user) {
    if (user.id == widget.currentUser.id) {
      return;
    }

    setState(() {
      if (_selectedAttendees.any((u) => u.id == user.id)) {
        _selectedAttendees.removeWhere((u) => u.id == user.id);
      } else {
        _selectedAttendees.add(user);
      }
    });
  }

  void _removeUser(UserResponse user) {
    setState(() => _selectedAttendees.removeWhere((u) => u.id == user.id));
  }

  void _clearDateError() {
    if (_dateError != null) {
      setState(() => _dateError = null);
    }
  }

  void _clearTimeFromError() {
    if (_timeFromError != null) {
      setState(() => _timeFromError = null);
    }
  }

  void _clearTimeToError() {
    if (_timeToError != null) {
      setState(() => _timeToError = null);
    }
  }

  void _clearRoomError() {
    if (_roomError != null) {
      setState(() => _roomError = null);
    }
  }

  void _clearAppointmentTypeError() {
    if (_appointmentTypeError != null) {
      setState(() => _appointmentTypeError = null);
    }
  }

  bool _validateForm() {
    bool isValid = true;

    _dateError = null;
    _timeFromError = null;
    _timeToError = null;
    _roomError = null;
    _appointmentTypeError = null;

    if (_selectedDate == null) {
      _dateError = 'Molimo odaberite datum';
      isValid = false;
    } else {
      final today = DateTime.now();
      final selectedDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
      );
      final todayDate = DateTime(today.year, today.month, today.day);

      if (selectedDateTime.isBefore(todayDate)) {
        _dateError = 'Ne možete zakazati termin u prošlosti';
        isValid = false;
      }
    }

    if (_timeFrom == null) {
      _timeFromError = 'Molimo odaberite početno vrijeme';
      isValid = false;
    }

    if (_timeTo == null) {
      _timeToError = 'Molimo odaberite završno vrijeme';
      isValid = false;
    } else if (_timeFrom != null && _timeTo != null) {
      final now = DateTime.now();
      final startDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        _timeFrom!.hour,
        _timeFrom!.minute,
      );
      final endDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        _timeTo!.hour,
        _timeTo!.minute,
      );

      if (!endDateTime.isAfter(startDateTime)) {
        _timeToError = 'Završno vrijeme mora biti nakon početnog vremena';
        isValid = false;
      } else {
        final String? businessRuleError = _validateBusinessRules();
        if (businessRuleError != null) {
          _timeToError = businessRuleError;
          isValid = false;
        }
      }
    }

    if (_selectedRoom == null) {
      _roomError = 'Molimo odaberite prostoriju';
      isValid = false;
    }

    if (_selectedAppointmentType == null) {
      _appointmentTypeError = 'Molimo odaberite tip termina';
      isValid = false;
    }
    setState(() {});

    if (!isValid) {
      _shakeController.forward().then((_) => _shakeController.reverse());
    }

    return isValid;
  }

  String? _validateBusinessRules() {
    if (_timeFrom == null || _timeTo == null) return null;

    const int allowedStartHour = 8;
    const int allowedEndHour = 23;

    if (_timeFrom!.hour < allowedStartHour) {
      return 'Termini se mogu zakazati samo od 08:00 sati';
    }

    if (_timeTo!.hour > allowedEndHour &&
        !(_timeTo!.hour == 0 && _timeTo!.minute == 0)) {
      return 'Termini se mogu zakazati samo do 00:00 sati';
    }

    final now = DateTime.now();
    final startDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _timeFrom!.hour,
      _timeFrom!.minute,
    );
    final endDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _timeTo!.hour,
      _timeTo!.minute,
    );

    final actualEndDateTime = _timeTo!.hour == 0 && _timeTo!.minute == 0
        ? endDateTime.add(const Duration(days: 1))
        : endDateTime;

    final duration = actualEndDateTime.difference(startDateTime);

    if (duration.inMinutes < 30) {
      return 'Termin mora trajati najmanje 30 minuta';
    }

    if (duration.inHours > 3) {
      return 'Termin ne može trajati duže od 3 sata';
    }

    return null;
  }

  bool get _isFormValid {
    return _selectedDate != null &&
        _timeFrom != null &&
        _timeTo != null &&
        _selectedRoom != null &&
        _selectedAppointmentType != null;
  }

  Future<void> _createAppointment() async {
    if (!_validateForm()) {
      _scrollToFirstError();
      return;
    }

    setState(() => _isLoading = true);
    try {
      final timeSlot = CreateTimeSlotRequest(
        timeFrom: Duration(hours: _timeFrom!.hour, minutes: _timeFrom!.minute),
        timeTo: Duration(hours: _timeTo!.hour, minutes: _timeTo!.minute),
      );

      final appointmentSchedule = CreateAppointmentScheduleRequest(
        date: _selectedDate!,
        time: timeSlot,
      );
      final request = CreateAppointmentRequest(
        isRepeating: _isRepeating,
        appointmentSchedule: appointmentSchedule,
        roomId: _selectedRoom!.id,
        appointmentTypeId: _selectedAppointmentType!.id,
        bookedByUserId: widget.currentUser.id,
        attendeesIds: _selectedAttendees.map((u) => u.id).toList(),
      );

      await _appointmentService.createAppointment(request);

      if (mounted) {
        setState(() => _isLoading = false);
        _showSuccessSnackbar();
        _clearFormData();
        Navigator.of(context).pop();
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);

        if (_isValidationError(e)) {
          _showApiErrorDialog(e);
        } else {
          _showErrorSnackbar(AppStrings.appointmentCreationFailed);
        }
      }
    } on SocketException {
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorSnackbar(
          'Problem s mrežom. Molimo provjerite internetsku vezu i pokušajte ponovo.',
        );
      }
    } on TimeoutException {
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorSnackbar('Zahtjev je prestari. Server možda nije dostupan.');
      }
    } on FormatException {
      if (mounted) {
        setState(() => _isLoading = false);
        _showSuccessSnackbar();
        _clearFormData();
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorSnackbar(
          'Dogodila se neočekivana greška pri kreiranju termina. Server ne odgovara',
        );
      }
    }
  }

  bool _isValidationError(ApiException error) {
    return error.message.contains(
          'Termini se mogu zakazati samo između 08:00 i 00:00 sati',
        ) ||
        error.message.contains('Termin mora trajati najmanje 30 minuta') ||
        error.message.contains('Termin ne može trajati duže od 3 sata') ||
        error.message.contains('Nepravilan vremenski raspon termina') ||
        error.message.contains(
          'Termin u ovoj prostoriji već postoji u odabranom vremenskom terminu',
        ) ||
        error.statusCode == 409;
  }

  void _showSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Termin je uspješno kreiran'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showApiErrorDialog(ApiException error) {
    String errorMessage;
    String errorTitle = 'Greška';

    if (error.message.contains(
      'Termini se mogu zakazati samo između 08:00 i 00:00 sati',
    )) {
      errorTitle = 'Nevažeće vrijeme';
      errorMessage =
          'Termini se mogu zakazivati samo između 08:00 i 00:00 sati.\n\nMolimo odaberite vrijeme u dozvoljenom vremenskom okviru.';
    } else if (error.message.contains(
      'Termin mora trajati najmanje 30 minuta',
    )) {
      errorTitle = 'Prekratak termin';
      errorMessage =
          'Termin mora trajati najmanje 30 minuta.\n\nMolimo povećajte trajanje termina.';
    } else if (error.message.contains(
      'Termin ne može trajati duže od 3 sata',
    )) {
      errorTitle = 'Predugačak termin';
      errorMessage =
          'Termin ne može trajati duže od 3 sata.\n\nMolimo skratite trajanje termina.';
    } else if (error.message.contains('Nepravilan vremenski raspon termina')) {
      errorTitle = 'Nevažeći vremenski raspon';
      errorMessage =
          'Vremenski raspon termina nije valjan.\n\nMolimo provjerite da je početno vrijeme prije završnog vremena.';
    } else if (error.message.contains(
      'Termin u ovoj prostoriji već postoji u odabranom vremenskom terminu',
    )) {
      errorTitle = 'Prostorija je zauzeta';
      errorMessage =
          'U odabranoj prostoriji već postoji termin u ovom vremenskom periodu.\n\nMolimo odaberite drugo vrijeme ili drugu prostoriju.';
    } else if (error.statusCode >= 500) {
      errorTitle = 'Greška servera';
      errorMessage =
          'Došlo je do greške na serveru. Molimo pokušajte ponovo kasnije.';
    } else if (error.statusCode == 400) {
      errorMessage =
          'Neispravni podaci za termin. Molimo provjerite unesene informacije.';
    } else if (error.statusCode == 401) {
      errorTitle = 'Nemate ovlasti';
      errorMessage =
          'Nemate ovlasti za kreiranje termina. Molimo prijavite se ponovo.';
    } else if (error.statusCode == 409) {
      errorTitle = 'Konflikt';
      errorMessage =
          'Termin se preklapa s postojećim terminima. Molimo odaberite drugo vrijeme.';
    } else {
      errorMessage =
          'Dogodila se greška pri komunikaciji sa serverom.\n\nMolimo pokušajte ponovo.';
    }

    _showErrorDialogWithMessage(errorTitle, errorMessage);
  }

  void _clearFormData() {
    setState(() {
      _selectedDate = null;
      _timeFrom = null;
      _timeTo = null;

      _selectedRoom = null;
      _selectedAppointmentType = null;
      _selectedAttendees.clear();

      _searchResults.clear();
      _userSearchController.clear();

      _isRepeating = false;
      _isSearchingUsers = false;

      _showRoomDropdown = false;
      _showAppointmentTypeDropdown = false;
      _roomDropdownOpened = false;
      _appointmentTypeDropdownOpened = false;

      _focusedField = null;

      _dateError = null;
      _timeFromError = null;
      _timeToError = null;
      _roomError = null;
      _appointmentTypeError = null;
    });

    if (_userSearchFocusNode.hasFocus) {
      _userSearchFocusNode.unfocus();
    }
  }

  void _showErrorDialogWithMessage(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title.isNotEmpty ? title : 'Greška'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: _primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.priority_high,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              const SizedBox(height: 16),
              Text(message),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('U redu'),
            ),
          ],
        );
      },
    );
  }

  void _scrollToFirstError() {
    if (_dateError != null) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (_timeFromError != null || _timeToError != null) {
      _scrollController.animateTo(
        100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (_roomError != null) {
      _scrollController.animateTo(
        200,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (_appointmentTypeError != null) {
      _scrollController.animateTo(
        300,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Color _parseHexColor(String hexColor) {
    try {
      String colorString = hexColor.replaceAll('#', '');
      if (colorString.length == 6) {
        colorString = 'FF$colorString';
      }

      return Color(int.parse(colorString, radix: 16));
    } catch (e) {
      return _primaryColor;
    }
  }

  void _checkDropdownSelection() {
    if (_roomDropdownOpened && _selectedRoom == null) {
      setState(() {
        _roomError = 'Ovo polje je obavezno';
        _roomDropdownOpened = false;
      });
    }

    if (_appointmentTypeDropdownOpened && _selectedAppointmentType == null) {
      setState(() {
        _appointmentTypeError = 'Ovo polje je obavezno';
        _appointmentTypeDropdownOpened = false;
      });
    }
  }

  void _scrollToSearchField() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          const double approximateSearchPosition = (56.0 * 4) + (16.0 * 4);

          _scrollController.animateTo(
            approximateSearchPosition,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    });
  }
}
