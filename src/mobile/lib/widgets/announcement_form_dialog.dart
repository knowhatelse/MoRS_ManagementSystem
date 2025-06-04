import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../widgets/custom_button.dart';
import '../constants/app_constants.dart';

class AnnouncementFormDialog extends StatefulWidget {
  final AnnouncementResponse?
  announcement; // null for create, populated for edit

  const AnnouncementFormDialog({super.key, this.announcement});

  @override
  State<AnnouncementFormDialog> createState() => _AnnouncementFormDialogState();
}

class _AnnouncementFormDialogState extends State<AnnouncementFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isLoading = false;

  bool get isEditing => widget.announcement != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _titleController.text = widget.announcement!.title;
      _contentController.text = widget.announcement!.content;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final provider = context.read<AnnouncementProvider>();
      bool success;

      if (isEditing) {
        // Update existing announcement
        final request = UpdateAnnouncementRequest(
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
        );
        success = await provider.updateAnnouncement(
          widget.announcement!.id,
          request,
        );
      } else {
        // Create new announcement
        final request = CreateAnnouncementRequest(
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          userId: 1, // TODO: Get actual user ID from authentication service
        );
        success = await provider.createAnnouncement(request);
      }

      if (success && mounted) {
        Navigator.of(context).pop(true); // Return true to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing
                  ? 'Announcement updated successfully!'
                  : 'Announcement created successfully!',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to ${isEditing ? 'update' : 'create'} announcement: $e',
            ),
            backgroundColor: Colors.red,
          ),
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditing ? 'Edit Announcement' : 'Create Announcement'),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter announcement title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadius,
                    ),
                  ),
                  prefixIcon: const Icon(Icons.title),
                ),
                maxLength: 200,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  if (value.trim().length < 3) {
                    return 'Title must be at least 3 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: 'Content',
                  hintText: 'Enter announcement content',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadius,
                    ),
                  ),
                  prefixIcon: const Icon(Icons.description),
                ),
                maxLines: 4,
                maxLength: 2000,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter content';
                  }
                  if (value.trim().length < 10) {
                    return 'Content must be at least 10 characters long';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        CustomButton(
          text: isEditing ? 'Update' : 'Create',
          onPressed: _isLoading ? null : _submitForm,
          isLoading: _isLoading,
          backgroundColor: AppConstants.primaryBlue,
        ),
      ],
    );
  }
}

/// Helper function to show the announcement form dialog
Future<bool?> showAnnouncementFormDialog(
  BuildContext context, {
  AnnouncementResponse? announcement,
}) async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AnnouncementFormDialog(announcement: announcement),
  );
}
