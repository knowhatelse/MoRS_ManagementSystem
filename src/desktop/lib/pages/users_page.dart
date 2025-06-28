import 'package:flutter/material.dart';
import '../models/user/user_response.dart';
import '../services/user_service.dart';
import '../constants/app_constants.dart';
import '../constants/room_constants.dart';
import '../utils/app_utils.dart';
import '../utils/avatar_utils.dart';
import '../widgets/create_user_dialog.dart';
import '../widgets/edit_user_dialog.dart';
import '../widgets/search_user_dialog.dart';
import '../constants/users_page_constants.dart';

class UsersPage extends StatefulWidget {
  final UserResponse user;
  const UsersPage({super.key, required this.user});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final UserService _userService = UserService();
  List<UserResponse> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final users = await _userService.getUsers();
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Greška pri učitavanju korisnika.')),
        );
      }
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => SearchUserDialog(
        onUserSelected: (user) {
          setState(() {
            _users = user != null ? [user] : [];
          });
        },
      ),
    );
  }

  void _showCreateUserDialog() {
    showDialog(
      context: context,
      builder: (context) => CreateUserDialog(
        onUserCreated: (user) async {
          Navigator.of(context).pop();
          await _loadUsers();
        },
      ),
    );
  }

  void _showEditUserDialog(UserResponse user) {
    showDialog(
      context: context,
      builder: (context) => EditUserDialog(
        user: user,
        onUserUpdated: (updatedUser) async {
          Navigator.of(context).pop();
          await _loadUsers();
        },
        onUserDeleted: () async {
          Navigator.of(context).pop();
          await _loadUsers();
        },
      ),
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
                        'Korisnici',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: AppConstants.primaryBlue,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _loadUsers,
                            icon: Icon(
                              Icons.refresh,
                              color: AppConstants.primaryBlue,
                            ),
                            tooltip: 'Osvježi',
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
                        : _users.isEmpty
                        ? const Center(
                            child: Text(
                              'Nema korisnika.',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : _buildUsersTable(),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Material(
                  color: Colors.transparent,
                  elevation: 8,
                  shape: const CircleBorder(),
                  child: Tooltip(
                    message: 'Pretraži korisnike',
                    child: InkWell(
                      onTap: _showSearchDialog,
                      customBorder: const CircleBorder(),
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppConstants.primaryBlue,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              offset: const Offset(0, 2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Material(
                  color: Colors.transparent,
                  elevation: 8,
                  shape: const CircleBorder(),
                  child: Tooltip(
                    message: 'Kreiraj korisnika',
                    child: InkWell(
                      onTap: _showCreateUserDialog,
                      customBorder: const CircleBorder(),
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppConstants.primaryBlue,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              offset: const Offset(0, 2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersTable() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
              itemCount: _users.length,
              itemBuilder: (context, index) {
                return _buildUserRow(_users[index], index);
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
          SizedBox(
            width: 110,
            child: Text(
              'Profilna slika',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              'Ime',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Prezime',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Email',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Broj telefona',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Tip korisnika',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserRow(UserResponse user, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade100, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 1),
            blurRadius: 3,
            spreadRadius: 0,
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showEditUserDialog(user),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              SizedBox(
                width: 102,
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AvatarUtils.buildUserAvatar(user),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(flex: 2, child: Text(user.name)),
              Expanded(flex: 2, child: Text(user.surname)),
              Expanded(flex: 3, child: Text(user.email)),
              Expanded(flex: 2, child: Text(user.phoneNumber)),
              Expanded(
                flex: 2,
                child: Text(user.role?.name ?? ''),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
