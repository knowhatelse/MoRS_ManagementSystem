import 'package:flutter/material.dart';
import '../models/models.dart';
import '../constants/app_constants.dart';
import '../constants/announcement_constants.dart';

class CreateAnnouncementDialog extends StatefulWidget {
  final UserResponse currentUser;
  final Function(CreateAnnouncementRequest) onCreateAnnouncement;

  const CreateAnnouncementDialog({
    super.key,
    required this.currentUser,
    required this.onCreateAnnouncement,
  });

  @override
  State<CreateAnnouncementDialog> createState() =>
      _CreateAnnouncementDialogState();
}

class _CreateAnnouncementDialogState extends State<CreateAnnouncementDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  String? _validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AnnouncementConstants.titleRequiredMessage;
    }
    if (value.trim().length < 5 || value.trim().length > 100) {
      return AnnouncementConstants.titleLengthMessage;
    }
    return null;
  }

  String? _validateContent(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AnnouncementConstants.contentRequiredMessage;
    }
    if (value.trim().length < 10 || value.trim().length > 2000) {
      return AnnouncementConstants.contentLengthMessage;
    }
    return null;
  }

  void _createAnnouncement() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final request = CreateAnnouncementRequest(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        userId: widget.currentUser.id,
      );

      widget.onCreateAnnouncement(request);
      Navigator.of(context).pop();
    } finally {
      setState(() {
        _isSubmitting = false;
      });
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
                AnnouncementConstants.createAnnouncementTitle,
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
        width: 500,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: AnnouncementConstants.titleFieldLabel,
                  hintText: AnnouncementConstants.titleFieldHint,
                  border: OutlineInputBorder(),
                ),
                validator: _validateTitle,
                maxLength: 100,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: AnnouncementConstants.contentFieldLabel,
                  hintText: AnnouncementConstants.contentFieldHint,
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: _validateContent,
                maxLines: 8,
                maxLength: 2000,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text(AnnouncementConstants.cancelButton),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _createAnnouncement,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.primaryBlue,
            foregroundColor: Colors.white,
          ),
          child: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text(AnnouncementConstants.createButton),
        ),
      ],
    );
  }
}
