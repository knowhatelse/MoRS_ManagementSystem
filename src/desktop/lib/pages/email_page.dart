import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/email_service.dart';
import '../services/user_service.dart';
import '../constants/app_constants.dart';
import '../constants/email_constants.dart';
import '../constants/announcement_constants.dart';
import '../constants/room_constants.dart';
import '../utils/app_utils.dart';
import '../utils/avatar_utils.dart';

class EmailPage extends StatefulWidget {
  final UserResponse user;
  const EmailPage({super.key, required this.user});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final EmailService _emailService = EmailService();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _userSearchController = TextEditingController();
  final FocusNode _userSearchFocusNode = FocusNode();
  List<UserResponse> _selectedUsers = [];
  bool _isLoading = false;
  bool _isSearching = false;

  String? _subjectError;
  String? _bodyError;
  String? _usersError;

  @override
  void dispose() {
    _subjectController.dispose();
    _bodyController.dispose();
    _userSearchController.dispose();
    _userSearchFocusNode.dispose();
    super.dispose();
  }

  Future<List<UserResponse>> _searchUsers(String query) async {
    if (query.trim().isEmpty || query.length < 2) {
      return [];
    }
    setState(() => _isSearching = true);
    try {
      final users = await UserService().searchUsers(query);
      setState(() {
        _isSearching = false;
      });
      return users;
    } catch (e) {
      setState(() => _isSearching = false);
      return [];
    }
  }

  void _removeUser(UserResponse user) {
    setState(() {
      _selectedUsers.removeWhere((u) => u.id == user.id);
    });
  }

  bool get _isFormValid {
    return _validateUsers(silent: true) == null &&
        _validateSubject(silent: true) == null &&
        _validateBody(silent: true) == null;
  }

  String? _validateUsers({bool silent = false}) {
    if (_selectedUsers.isEmpty) {
      if (!silent) {
        setState(() => _usersError = EmailConstants.usersRequired);
      }
      return EmailConstants.usersRequired;
    }
    if (!silent) {
      setState(() => _usersError = null);
    }
    return null;
  }

  String? _validateSubject({bool silent = false}) {
    final subject = _subjectController.text.trim();
    if (subject.isEmpty) {
      if (!silent) {
        setState(() => _subjectError = EmailConstants.subjectRequired);
      }
      return EmailConstants.subjectRequired;
    }
    if (subject.length < 5 || subject.length > 100) {
      if (!silent) {
        setState(() => _subjectError = EmailConstants.subjectLength);
      }
      return EmailConstants.subjectLength;
    }
    if (!silent) {
      setState(() => _subjectError = null);
    }
    return null;
  }

  String? _validateBody({bool silent = false}) {
    final body = _bodyController.text.trim();
    if (body.isEmpty) {
      if (!silent) {
        setState(() => _bodyError = EmailConstants.bodyRequired);
      }
      return EmailConstants.bodyRequired;
    }
    if (body.length < 10 || body.length > 2000) {
      if (!silent) {
        setState(() => _bodyError = EmailConstants.bodyLength);
      }
      return EmailConstants.bodyLength;
    }
    if (!silent) {
      setState(() => _bodyError = null);
    }
    return null;
  }

  Future<void> _sendEmail() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final request = CreateEmailRequest(
        subject: _subjectController.text.trim(),
        body: _bodyController.text.trim(),
        userIds: _selectedUsers.map((u) => u.id).toList(),
      );
      await _emailService.sendEmail(request);
      if (mounted) {
        AppUtils.showSuccessSnackbar(context, EmailConstants.emailSentSuccess);
        setState(() {
          _subjectController.clear();
          _bodyController.clear();
          _selectedUsers = [];
        });
      }
    } catch (e) {
      if (mounted) {
        AppUtils.showErrorSnackBar(context, EmailConstants.emailSentError);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(RoomConstants.pageHorizontalPadding),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: RoomConstants.tableSidePadding,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        EmailConstants.pageTitle,
                        style: TextStyle(
                          fontSize: AnnouncementConstants.titleFontSize,
                          fontWeight: FontWeight.w600,
                          color: AppConstants.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: RoomConstants.tableSidePadding,
                    ),
                    child: _buildEmailFormBox(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailFormBox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              EmailConstants.selectUsersTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
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
                if (!_selectedUsers.any((u) => u.id == user.id)) {
                  setState(() {
                    _selectedUsers.add(user);
                  });
                }
                _userSearchController.clear();
                _userSearchFocusNode.requestFocus();
              },
              fieldViewBuilder:
                  (context, controller, focusNode, onFieldSubmitted) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        labelText: EmailConstants.userSearchHint,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: _isSearching
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
            if (_usersError != null)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 4),
                child: Text(
                  _usersError!,
                  style: const TextStyle(
                    color: AppConstants.errorColor,
                    fontSize: 12,
                  ),
                ),
              ),
            if (_selectedUsers.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: _selectedUsers
                      .map(
                        (user) => Chip(
                          label: Text(user.fullName),
                          onDeleted: () => _removeUser(user),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          backgroundColor: AppConstants.primaryBlue.withValues(
                            alpha: 0.08,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            const SizedBox(height: 32),
            Text(
              EmailConstants.subjectLabel,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                hintText: EmailConstants.subjectHint,
                errorText: _subjectError,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (_) => _validateSubject(),
            ),
            const SizedBox(height: 24),
            Text(
              EmailConstants.bodyLabel,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TextFormField(
                controller: _bodyController,
                expands: true,
                maxLines: null,
                minLines: null,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: EmailConstants.bodyHint,
                  labelText: EmailConstants.bodyLabel,
                  errorText: _bodyError,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignLabelWithHint: true,
                ),
                onChanged: (_) => _validateBody(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 24.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: SizedBox(
                  width: 180,
                  child: ElevatedButton(
                    onPressed: _isFormValid && !_isLoading ? _sendEmail : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            EmailConstants.sendButton,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
