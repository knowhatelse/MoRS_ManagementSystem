import 'package:flutter/material.dart';
import '../../constants/users_page_constants.dart';
import '../../models/user/user_response.dart';
import '../../services/user_service.dart';
import '../../utils/avatar_utils.dart';
import '../constants/app_constants.dart';

class SearchUserDialog extends StatefulWidget {
  final void Function(UserResponse?) onUserSelected;
  const SearchUserDialog({super.key, required this.onUserSelected});

  @override
  State<SearchUserDialog> createState() => _SearchUserDialogState();
}

class _SearchUserDialogState extends State<SearchUserDialog> {
  final UserService _userService = UserService();
  final TextEditingController _searchController = TextEditingController();
  List<UserResponse> _searchedUsers = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchUsers(String searchTerm) async {
    if (searchTerm.trim().isEmpty) {
      setState(() {
        _searchedUsers = [];
        _isSearching = false;
      });
      return;
    }
    setState(() {
      _isSearching = true;
    });
    try {
      final users = await _userService.searchUsers(searchTerm);
      if (!mounted) return;
      setState(() {
        _searchedUsers = users;
        _isSearching = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSearching = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Greška pri pretrazi korisnika.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 500,
        constraints: const BoxConstraints(maxHeight: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: AppConstants.primaryBlue,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  const Text(
                    UsersPageConstants.searchUserTitle,
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
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Unesite ime, prezime ili email...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                      _searchedUsers = [];
                                    });
                                  },
                                )
                              : _isSearching
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : null,
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppConstants.primaryBlue,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          _searchUsers(value);
                        },
                      ),
                      if (_searchedUsers.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _searchedUsers.length,
                            itemBuilder: (context, index) {
                              final user = _searchedUsers[index];
                              return ListTile(
                                leading: AvatarUtils.buildUserAvatar(user),
                                title: Text(user.fullName),
                                subtitle: Text(user.email),
                                onTap: () {
                                  widget.onUserSelected(user);
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Otkaži'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
