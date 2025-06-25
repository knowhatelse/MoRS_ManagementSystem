import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/room_service.dart';
import '../constants/room_constants.dart';
import '../constants/app_constants.dart';
import '../utils/app_utils.dart';
import '../utils/color_utils.dart';
import 'color_picker_widget.dart';

class RoomCreateDialog extends StatefulWidget {
  final VoidCallback onRoomCreated;

  const RoomCreateDialog({super.key, required this.onRoomCreated});

  @override
  State<RoomCreateDialog> createState() => _RoomCreateDialogState();
}

class _RoomCreateDialogState extends State<RoomCreateDialog> {
  final RoomService _roomService = RoomService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedType = RoomConstants.roomTypes.first;
  Color _selectedColor = Colors.blue;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _showColorPicker() async {
    final Color? selectedColor = await ColorPickerWidget.showColorPicker(
      context,
      _selectedColor,
    );

    if (selectedColor != null) {
      setState(() {
        _selectedColor = selectedColor;
      });
    }
  }

  Future<void> _createRoom() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final request = CreateRoomRequest(
        name: _nameController.text.trim(),
        type: _selectedType,
        color: ColorUtils.colorToHex(_selectedColor),
      );

      await _roomService.createRoom(request);

      if (mounted) {
        AppUtils.showSuccessSnackbar(
          context,
          RoomConstants.createSuccessMessage,
        );
        Navigator.of(context).pop();
        widget.onRoomCreated();
      }
    } catch (e) {
      if (mounted) {
        AppUtils.showErrorSnackBar(context, RoomConstants.createErrorMessage);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.all(24),
      title: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppConstants.primaryBlue,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.add, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                RoomConstants.createRoomTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close, color: Colors.white, size: 20),
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: RoomConstants.nameLabel,
                  hintText: RoomConstants.nameHint,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return RoomConstants.nameRequiredMessage;
                  }
                  if (value.trim().length < 2) {
                    return RoomConstants.nameMinLengthMessage;
                  }
                  if (value.trim().length > 50) {
                    return RoomConstants.nameMaxLengthMessage;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: RoomConstants.typeLabel,
                  border: OutlineInputBorder(),
                ),
                items: RoomConstants.roomTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedType = newValue;
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return RoomConstants.typeRequiredMessage;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    RoomConstants.colorLabel,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: _showColorPicker,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _selectedColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    ColorUtils.colorToHex(_selectedColor),
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text(RoomConstants.cancelButton),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _createRoom,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.primaryBlue,
            foregroundColor: Colors.white,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(RoomConstants.createButton),
        ),
      ],
    );
  }
}
