import 'package:flutter/material.dart';
import '../models/models.dart';
import '../constants/app_constants.dart';
import '../services/services.dart';
import '../utils/app_utils.dart';
import '../utils/avatar_utils.dart';
import 'filter_dropdown.dart';
import 'filter_date_time_field.dart';

class ReportFilterDialog extends StatefulWidget {
  final RoomResponse? initialRoom;
  final UserResponse? initialUser;
  final DateTime? initialDate;
  final bool? initialIsArchived;
  final Function(RoomResponse?, UserResponse?, DateTime?, bool?) onApplyFilters;

  const ReportFilterDialog({
    super.key,
    this.initialRoom,
    this.initialUser,
    this.initialDate,
    this.initialIsArchived,
    required this.onApplyFilters,
  });

  @override
  State<ReportFilterDialog> createState() => _ReportFilterDialogState();
}

class _ReportFilterDialogState extends State<ReportFilterDialog> {
  final RoomService _roomService = RoomService();
  final UserService _userService = UserService();

  RoomResponse? _selectedRoom;
  UserResponse? _selectedUser;
  DateTime? _selectedDate;
  bool? _selectedIsArchived;
  bool _isLoading = true;

  List<RoomResponse> _rooms = [];
  List<UserResponse> _searchedUsers = [];
  final TextEditingController _userSearchController = TextEditingController();
  bool _isSearchingUsers = false;

  @override
  void initState() {
    super.initState();
    _selectedRoom = widget.initialRoom;
    _selectedUser = widget.initialUser;
    _selectedDate = widget.initialDate;
    _selectedIsArchived = widget.initialIsArchived;

    if (_selectedUser != null) {
      _userSearchController.text = _selectedUser!.fullName;
      _searchedUsers = [_selectedUser!];
    }

    _loadData();
  }

  @override
  void dispose() {
    _userSearchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await _loadRooms();
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

          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        AppUtils.showErrorSnackBar(context, 'Greška pri učitavanju prostorija. Server ne odgovara');
      }
    }
  }

  Future<void> _searchUsers(String searchTerm) async {
    if (searchTerm.trim().isEmpty) {
      setState(() {
        _searchedUsers = [];
        _isSearchingUsers = false;
      });
      return;
    }

    setState(() {
      _isSearchingUsers = true;
    });

    try {
      final users = await _userService.searchUsers(searchTerm);
      if (mounted) {
        setState(() {
          _searchedUsers = users;
          _isSearchingUsers = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSearchingUsers = false;
        });
        AppUtils.showErrorSnackBar(
          context,
          'Greška pri pretraživanju korisnika. Server ne odgovara',
        );
      }
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedRoom = null;
      _selectedUser = null;
      _selectedDate = null;
      _selectedIsArchived = null;
      _userSearchController.clear();
      _searchedUsers = [];
    });
  }

  void _applyFilters() {
    widget.onApplyFilters(
      _selectedRoom,
      _selectedUser,
      _selectedDate,
      _selectedIsArchived,
    );
    Navigator.of(context).pop();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('bs', 'BA'),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 700),
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
                    'Filtriraj prijave kvarova',
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
                          _buildRoomFilter(),
                          const SizedBox(height: 16),
                          _buildUserFilter(),
                          const SizedBox(height: 16),
                          _buildDateFilter(),
                          const SizedBox(height: 16),
                          _buildArchivedFilter(),
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
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(room.name),
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
          'Prijavio',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppConstants.primaryBlue,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _userSearchController,
          decoration: InputDecoration(
            hintText: 'Pretražite korisnika...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _userSearchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _userSearchController.clear();
                        _selectedUser = null;
                        _searchedUsers = [];
                      });
                    },
                  )
                : _isSearchingUsers
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : null,
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppConstants.primaryBlue),
            ),
          ),
          onChanged: (value) {
            _searchUsers(value);
            if (value.isEmpty) {
              setState(() {
                _selectedUser = null;
              });
            }
          },
        ),
        if (_searchedUsers.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: _searchedUsers.map((user) {
                final isSelected = _selectedUser?.id == user.id;
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppConstants.primaryBlue.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: AvatarUtils.buildUserAvatar(
                      user,
                      isSelected: isSelected,
                    ),
                    title: Text(
                      user.fullName,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: isSelected
                            ? AppConstants.primaryBlue
                            : Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      user.email,
                      style: TextStyle(
                        color: isSelected
                            ? AppConstants.primaryBlue.withValues(alpha: 0.7)
                            : Colors.grey.shade600,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedUser = user;
                        _userSearchController.text = user.fullName;
                        _searchedUsers = [];
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDateFilter() {
    return FilterDateTimeField(
      label: 'Datum',
      hint: 'Odaberite datum prijave',
      value: _selectedDate != null ? _formatDate(_selectedDate!) : null,
      onTap: _selectDate,
      onClear: () => setState(() => _selectedDate = null),
      icon: Icons.calendar_today,
    );
  }

  Widget _buildArchivedFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Arhivirano',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppConstants.primaryBlue,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ListTile(
                title: const Text('Sve prijave'),
                leading: Radio<bool?>(
                  value: null,
                  groupValue: _selectedIsArchived,
                  onChanged: (value) =>
                      setState(() => _selectedIsArchived = value),
                  activeColor: AppConstants.primaryBlue,
                ),
                contentPadding: EdgeInsets.zero,
                onTap: () => setState(() => _selectedIsArchived = null),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: ListTile(
                title: const Text('Samo aktivne'),
                leading: Radio<bool?>(
                  value: false,
                  groupValue: _selectedIsArchived,
                  onChanged: (value) =>
                      setState(() => _selectedIsArchived = value),
                  activeColor: AppConstants.primaryBlue,
                ),
                contentPadding: EdgeInsets.zero,
                onTap: () => setState(() => _selectedIsArchived = false),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: ListTile(
                title: const Text('Samo arhivirane'),
                leading: Radio<bool?>(
                  value: true,
                  groupValue: _selectedIsArchived,
                  onChanged: (value) =>
                      setState(() => _selectedIsArchived = value),
                  activeColor: AppConstants.primaryBlue,
                ),
                contentPadding: EdgeInsets.zero,
                onTap: () => setState(() => _selectedIsArchived = true),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
