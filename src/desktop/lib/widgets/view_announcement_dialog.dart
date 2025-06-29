import 'package:flutter/material.dart';
import '../models/models.dart';
import '../constants/app_constants.dart';
import '../constants/announcement_constants.dart';
import '../utils/app_utils.dart';
import '../services/announcement_service.dart';

class ViewAnnouncementDialog extends StatefulWidget {
  final AnnouncementResponse announcement;
  final VoidCallback? onAnnouncementUpdated;

  const ViewAnnouncementDialog({
    super.key,
    required this.announcement,
    this.onAnnouncementUpdated,
  });

  @override
  State<ViewAnnouncementDialog> createState() => _ViewAnnouncementDialogState();
}

class _ViewAnnouncementDialogState extends State<ViewAnnouncementDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isLoading = false;
  final Map<String, bool> _touched = {'title': false, 'content': false};
  final AnnouncementService _announcementService = AnnouncementService();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.announcement.title;
    _contentController.text = widget.announcement.content;
    _titleController.addListener(_onFieldChanged);
    _contentController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    setState(() {});
  }

  String? _validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Naslov je obavezan';
    }
    if (value.trim().length < 5) {
      return 'Naslov mora imati najmanje 5 karaktera';
    }
    if (value.trim().length > 100) {
      return 'Naslov može imati najviše 100 karaktera';
    }
    return null;
  }

  String? _validateContent(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Sadržaj je obavezan';
    }
    if (value.trim().length < 10) {
      return 'Sadržaj mora imati najmanje 10 karaktera';
    }
    if (value.trim().length > 2000) {
      return 'Sadržaj može imati najviše 2000 karaktera';
    }
    return null;
  }

  bool _validateForm() {
    return _validateTitle(_titleController.text) == null &&
        _validateContent(_contentController.text) == null;
  }

  Future<void> _submit() async {
    if (!_validateForm()) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final request = UpdateAnnouncementRequest(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
      );
      final updated = await _announcementService.updateAnnouncement(
        widget.announcement.id,
        request,
      );
      if (updated != null && mounted) {
        Navigator.of(context).pop();
        if (widget.onAnnouncementUpdated != null) {
          widget.onAnnouncementUpdated!();
        }
        AppUtils.showSuccessSnackbar(
          context,
          'Obavijest je uspješno ažurirana.',
        );
      } else if (mounted) {
        AppUtils.showErrorSnackBar(
          context,
          'Greška pri ažuriranju obavijesti.',
        );
      }
    } catch (e) {
      if (mounted) {
        AppUtils.showErrorSnackBar(
          context,
          'Greška pri ažuriranju obavijesti.',
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
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
            const Icon(Icons.article, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                AnnouncementConstants.viewAnnouncementTitle,
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
        width: 600,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Naslov',
                        border: InputBorder.none,
                        errorText: titleError,
                      ),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppConstants.primaryBlue,
                      ),
                      enabled: !_isLoading,
                      onChanged: (_) =>
                          setState(() => _touched['title'] = true),
                      autovalidateMode: AutovalidateMode.disabled,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.announcement.user?.fullName ??
                              'Nepoznat korisnik',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(widget.announcement.createdAt),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxHeight: 400),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SingleChildScrollView(
                  child: TextFormField(
                    controller: _contentController,
                    maxLines: null,
                    minLines: 6,
                    decoration: InputDecoration(
                      labelText: 'Sadržaj',
                      border: InputBorder.none,
                      errorText: contentError,
                    ),
                    style: const TextStyle(fontSize: 16, height: 1.5),
                    enabled: !_isLoading,
                    onChanged: (_) =>
                        setState(() => _touched['content'] = true),
                    autovalidateMode: AutovalidateMode.disabled,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text('Zatvori'),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _isLoading || !_validateForm() ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
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
                  : const Text('Sačuvaj'),
            ),
          ],
        ),
      ],
    );
  }
}
