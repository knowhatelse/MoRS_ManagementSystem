import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/room_service.dart';
import '../constants/app_constants.dart';
import '../constants/room_constants.dart';
import '../utils/app_utils.dart';
import '../widgets/room_create_dialog.dart';
import '../widgets/room_edit_dialog.dart';

class RoomPage extends StatefulWidget {
  final UserResponse user;

  const RoomPage({super.key, required this.user});

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  final RoomService _roomService = RoomService();
  List<RoomResponse> _rooms = [];
  List<RoomResponse> _filteredRooms = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final rooms = await _roomService.getRooms();
      
      rooms.sort((a, b) {
        if (a.isActive != b.isActive) {
          return a.isActive ? -1 : 1; 
        }
        return a.name.compareTo(b.name);
      });

      setState(() {
        _rooms = rooms;
        _filteredRooms = rooms;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        AppUtils.showErrorSnackBar(context, RoomConstants.loadingErrorMessage);
      }
    }
  }

  Future<void> _deleteRoom(RoomResponse room) async {
    final confirmed = await _showDeleteConfirmationDialog(room);
    if (confirmed == true) {
      try {
        await _roomService.deleteRoom(room.id);
        setState(() {
          _rooms.removeWhere((r) => r.id == room.id);
          _filteredRooms = _rooms;
        });
        if (mounted) {
          AppUtils.showSuccessSnackbar(
            context,
            RoomConstants.deleteSuccessMessage,
          );
        }
      } catch (e) {
        if (mounted) {
          AppUtils.showErrorSnackBar(context, RoomConstants.deleteErrorMessage);
        }
      }
    }
  }

  Future<void> _toggleRoomStatus(RoomResponse room) async {
    final confirmed = await _showToggleConfirmationDialog(room);
    if (confirmed == true) {
      try {
        await _roomService.toggleRoomStatus(room);
        await _loadRooms();

        if (mounted) {
          AppUtils.showSuccessSnackbar(
            context,
            room.isActive
                ? RoomConstants.deactivateSuccessMessage
                : RoomConstants.activateSuccessMessage,
          );
        }
      } catch (e) {
        if (mounted) {
          AppUtils.showErrorSnackBar(
            context,
            room.isActive
                ? RoomConstants.deactivateErrorMessage
                : RoomConstants.activateErrorMessage,
          );
        }
      }
    }
  }

  Future<bool?> _showDeleteConfirmationDialog(RoomResponse room) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(RoomConstants.deleteConfirmationTitle),
          content: Text(RoomConstants.deleteConfirmationMessage(room.name)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(RoomConstants.cancelButton),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text(RoomConstants.deleteButton),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showToggleConfirmationDialog(RoomResponse room) {
    final isActivating = !room.isActive;
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            isActivating
                ? RoomConstants.activateConfirmationTitle
                : RoomConstants.deactivateConfirmationTitle,
          ),
          content: Text(
            isActivating
                ? RoomConstants.activateConfirmationMessage(room.name)
                : RoomConstants.deactivateConfirmationMessage(room.name),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(RoomConstants.cancelButton),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: isActivating ? Colors.green : Colors.orange,
              ),
              child: Text(
                isActivating
                    ? RoomConstants.activateButton
                    : RoomConstants.deactivateButton,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEditRoomDialog(RoomResponse room) {
    showDialog(
      context: context,
      builder: (context) =>
          RoomEditDialog(room: room, onRoomUpdated: () => _loadRooms()),
    );
  }

  void _showCreateRoomDialog() {
    showDialog(
      context: context,
      builder: (context) => RoomCreateDialog(onRoomCreated: () => _loadRooms()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(RoomConstants.pageHorizontalPadding),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: RoomConstants.tableSidePadding,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        RoomConstants.pageTitle,
                        style: TextStyle(
                          fontSize: RoomConstants.titleFontSize,
                          fontWeight: FontWeight.w600,
                          color: AppConstants.primaryBlue,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _loadRooms,
                            icon: Icon(
                              Icons.refresh,
                              color: AppConstants.primaryBlue,
                            ),
                            tooltip: RoomConstants.refreshTooltip,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: RoomConstants.tableSidePadding,
                    ),
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppConstants.primaryBlue,
                            ),
                          )
                        : _filteredRooms.isEmpty
                        ? const Center(
                            child: Text(
                              RoomConstants.noDataMessage,
                              style: TextStyle(
                                fontSize: RoomConstants.noDataFontSize,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : _buildRoomsTable(),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton(
              onPressed: _showCreateRoomDialog,
              backgroundColor: AppConstants.primaryBlue,
              foregroundColor: Colors.white,
              shape: const CircleBorder(),
              elevation: 8,
              tooltip: RoomConstants.addRoomTooltip,
              child: const Icon(Icons.add, size: RoomConstants.fabIconSize),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomsTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTableHeader(),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredRooms.length,
              itemBuilder: (context, index) {
                return _buildRoomRow(_filteredRooms[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppConstants.primaryBlue,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppConstants.borderRadius),
          topRight: Radius.circular(AppConstants.borderRadius),
        ),
      ),
      child: const Row(
        children: [
          Expanded(
            flex: RoomConstants.nameColumnFlex,
            child: Text(
              RoomConstants.nameHeader,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: RoomConstants.tableHeaderFontSize,
              ),
            ),
          ),
          Expanded(
            flex: RoomConstants.typeColumnFlex,
            child: Text(
              RoomConstants.typeHeader,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: RoomConstants.tableHeaderFontSize,
              ),
            ),
          ),
          Expanded(
            flex: RoomConstants.colorColumnFlex,
            child: Text(
              RoomConstants.colorHeader,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: RoomConstants.tableHeaderFontSize,
              ),
            ),
          ),
          Expanded(
            flex: RoomConstants.statusColumnFlex,
            child: Text(
              RoomConstants.statusHeader,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: RoomConstants.tableHeaderFontSize,
              ),
            ),
          ),
          SizedBox(
            width: RoomConstants.toggleColumnWidth,
            child: Text(
              RoomConstants.toggleHeader,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: RoomConstants.tableHeaderFontSize,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: RoomConstants.deleteColumnWidth,
            child: Text(
              RoomConstants.deleteHeader,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: RoomConstants.tableHeaderFontSize,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomRow(RoomResponse room, int index) {
    Color roomColor = Colors.white;
    try {
      roomColor = Color(int.parse(room.color.replaceFirst('#', '0xFF')));
    } catch (e) {
      roomColor = Colors.white;
    }

    final backgroundColor = room.isActive
        ? roomColor.withValues(alpha: 0.1)
        : Colors.grey.withValues(alpha: 0.1);

    final borderColor = room.isActive
        ? roomColor.withValues(alpha: 0.3)
        : Colors.grey.withValues(alpha: 0.3);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 3,
            spreadRadius: 0,
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showEditRoomDialog(room),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                flex: RoomConstants.nameColumnFlex,
                child: Text(
                  room.name,
                  style: TextStyle(
                    fontSize: RoomConstants.tableRowFontSize,
                    fontWeight: FontWeight.w500,
                    color: room.isActive
                        ? Colors.black87
                        : Colors.grey.shade600,
                  ),
                ),
              ),
              Expanded(
                flex: RoomConstants.typeColumnFlex,
                child: Text(
                  room.type,
                  style: TextStyle(
                    fontSize: RoomConstants.tableRowFontSize,
                    color: room.isActive
                        ? Colors.black87
                        : Colors.grey.shade600,
                  ),
                ),
              ),
              Expanded(
                flex: RoomConstants.colorColumnFlex,
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: roomColor,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        room.color,
                        style: TextStyle(
                          fontSize: RoomConstants.tableRowFontSize,
                          color: room.isActive
                              ? Colors.black87
                              : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: RoomConstants.statusColumnFlex,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: room.isActive
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: room.isActive ? Colors.green : Colors.red,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    room.isActive
                        ? RoomConstants.activeStatus
                        : RoomConstants.inactiveStatus,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: room.isActive
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                width: RoomConstants.toggleColumnWidth,
                child: IconButton(
                  onPressed: () => _toggleRoomStatus(room),
                  icon: Icon(
                    room.isActive ? Icons.toggle_on : Icons.toggle_off,
                    size: 32,
                    color: room.isActive ? Colors.orange : Colors.green,
                  ),
                  tooltip: room.isActive
                      ? RoomConstants.deactivateTooltip
                      : RoomConstants.activateTooltip,
                ),
              ),
              SizedBox(
                width: RoomConstants.deleteColumnWidth,
                child: IconButton(
                  onPressed: () => _deleteRoom(room),
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: RoomConstants.deleteIconSize,
                  ),
                  tooltip: RoomConstants.deleteTooltip,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
