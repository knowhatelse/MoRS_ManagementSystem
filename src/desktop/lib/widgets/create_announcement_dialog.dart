import 'package:flutter/material.dart';
import '../models/models.dart';
import '../constants/app_constants.dart';
import '../constants/announcement_constants.dart';

class CreateAnnouncementDialog extends StatefulWidget {
  final UserResponse currentUser;
  final Future<bool> Function(CreateAnnouncementRequest) onCreateAnnouncement;

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
  final Map<String, bool> _touched = {'title': false, 'content': false};

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

      final result = await widget.onCreateAnnouncement(request);
      if (result) {
        Navigator.of(context).pop(true);
      } else {
        Navigator.of(context).pop(false);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleError = _touched['title']!
        ? _validateTitle(_titleController.text)
        : null;
    final contentError = _touched['content']!
        ? _validateContent(_contentController.text)
        : null;
    return AlertDialog(
      backgroundColor: Colors.white,
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.all(24),
      title: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppConstants.primaryBlue,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
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
              Focus(
                onFocusChange: (hasFocus) {
                  if (!hasFocus) setState(() => _touched['title'] = true);
                },
                child: TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: AnnouncementConstants.titleFieldLabel,
                    hintText: AnnouncementConstants.titleFieldHint,
                    border: const OutlineInputBorder(),
                    errorText: titleError,
                  ),
                  onChanged: (_) => setState(() {}),
                  enabled: !_isSubmitting,
                  autovalidateMode: AutovalidateMode.disabled,
                  onTap: () => setState(() => _touched['title'] = true),
                  maxLength: 100,
                ),
              ),
              const SizedBox(height: 16),
              Focus(
                onFocusChange: (hasFocus) {
                  if (!hasFocus) setState(() => _touched['content'] = true);
                },
                child: TextFormField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    labelText: AnnouncementConstants.contentFieldLabel,
                    hintText: AnnouncementConstants.contentFieldHint,
                    border: const OutlineInputBorder(),
                    alignLabelWithHint: true,
                    errorText: contentError,
                  ),
                  onChanged: (_) => setState(() {}),
                  enabled: !_isSubmitting,
                  autovalidateMode: AutovalidateMode.disabled,
                  onTap: () => setState(() => _touched['content'] = true),
                  maxLines: 8,
                  maxLength: 2000,
                ),
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
