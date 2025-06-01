import 'package:flutter/material.dart';
import '../models/models.dart';

class MainScreen extends StatefulWidget {
  final UserResponse user;

  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Custom color #525fe1
  static const Color customBlue = Color(0xFF525FE1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: customBlue,
        foregroundColor: Colors.white,
        title: const Text(
          'MoRS Management System',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                widget.user.fullName.isNotEmpty
                    ? widget.user.fullName[0].toUpperCase()
                    : 'U',
                style: const TextStyle(
                  color: customBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onSelected: (value) {
              if (value == 'profile') {
                _navigateToProfile();
              } else if (value == 'logout') {
                _handleLogout();
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    const Icon(Icons.person, color: customBlue),
                    const SizedBox(width: 8),
                    Text(widget.user.fullName),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Odjavi se'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: customBlue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Početna',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Obavještenja',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Termini',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'Više'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return _buildAnnouncements();
      case 2:
        return _buildAppointments();
      case 3:
        return _buildMore();
      default:
        return _buildDashboard();
    }
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [customBlue, customBlue.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dobrodošli, ${widget.user.fullName}!',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Email: ${widget.user.email}',
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Quick actions section
          const Text(
            'Brze akcije',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // Quick action grid
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildQuickActionCard(
                'Sobe',
                Icons.meeting_room,
                Colors.blue,
                () => _navigateToRooms(),
              ),
              _buildQuickActionCard(
                'Plaćanja',
                Icons.payment,
                Colors.green,
                () => _navigateToPayments(),
              ),
              _buildQuickActionCard(
                'Kvarovi',
                Icons.report_problem,
                Colors.orange,
                () => _navigateToMalfunctions(),
              ),
              _buildQuickActionCard(
                'Članarina',
                Icons.card_membership,
                Colors.purple,
                () => _navigateToMembershipFees(),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Recent activity section
          const Text(
            'Nedavna aktivnost',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.grey.shade600),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Nema nedavnih aktivnosti za prikaz.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnnouncements() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.announcement, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Obavještenja',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Ova funkcionalnost će biti implementirana uskoro.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointments() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Termini',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Ova funkcionalnost će biti implementirana uskoro.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildMore() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Dodatne opcije',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        _buildMoreOption(
          'Notifikacije',
          Icons.notifications,
          () => _navigateToNotifications(),
        ),
        _buildMoreOption('Email', Icons.email, () => _navigateToEmail()),
        _buildMoreOption('Profil', Icons.person, () => _navigateToProfile()),
        _buildMoreOption(
          'Postavke',
          Icons.settings,
          () => _navigateToSettings(),
        ),
        const Divider(),
        _buildMoreOption('O aplikaciji', Icons.info, () => _showAboutDialog()),
        _buildMoreOption(
          'Odjavi se',
          Icons.logout,
          () => _handleLogout(),
          textColor: Colors.red,
          iconColor: Colors.red,
        ),
      ],
    );
  }

  Widget _buildMoreOption(
    String title,
    IconData icon,
    VoidCallback onTap, {
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.grey.shade700),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  // Navigation methods
  void _navigateToRooms() {
    _showComingSoon('Sobe');
  }

  void _navigateToPayments() {
    _showComingSoon('Plaćanja');
  }

  void _navigateToMalfunctions() {
    _showComingSoon('Prijave kvarova');
  }

  void _navigateToMembershipFees() {
    _showComingSoon('Članarina');
  }

  void _navigateToNotifications() {
    _showComingSoon('Notifikacije');
  }

  void _navigateToEmail() {
    _showComingSoon('Email');
  }

  void _navigateToProfile() {
    _showComingSoon('Profil');
  }

  void _navigateToSettings() {
    _showComingSoon('Postavke');
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('O aplikaciji'),
        content: const Text(
          'MoRS Management System\n'
          'Verzija 1.0.0\n\n'
          'Sistem za upravljanje objektom.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Zatvori'),
          ),
        ],
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Odjava'),
        content: const Text('Da li ste sigurni da se želite odjaviti?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Otkaži'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate back to login screen
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/login', (route) => false);
            },
            child: const Text('Odjavi se', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature funkcionalnost će biti implementirana uskoro.'),
        backgroundColor: customBlue,
      ),
    );
  }
}
