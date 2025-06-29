import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class DesktopHeader extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onNavigationTapped;
  final VoidCallback onLogoutPressed;

  const DesktopHeader({
    super.key,
    required this.selectedIndex,
    required this.onNavigationTapped,
    required this.onLogoutPressed,
  });

  static const List<String> _navigationItems = [
    'Obavijesti',
    'Planer',
    'Prostorije',
    'Prijave',
    'Email',
    'Korisnici',
  ];

  static const List<IconData> _navigationIcons = [
    Icons.campaign_outlined,
    Icons.calendar_today_outlined,
    Icons.meeting_room_outlined,
    Icons.report_problem_outlined,
    Icons.email_outlined,
    Icons.people_outline,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.primaryBlue,
        boxShadow: [AppConstants.topBarShadow],
      ),
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: [
              const Text(
                'MoRS Management System',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  _navigationItems.length,
                  (index) => _NavigationItem(
                    icon: _navigationIcons[index],
                    label: _navigationItems[index],
                    isSelected: selectedIndex == index,
                    onTap: () => onNavigationTapped(index),
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: onLogoutPressed,
                icon: const Icon(Icons.logout, color: Colors.white, size: 24),
                tooltip: 'Odjavi se',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavigationItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_NavigationItem> createState() => _NavigationItemState();
}

class _NavigationItemState extends State<_NavigationItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? Colors.white.withValues(alpha: 0.2)
                : _isHovered
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                color: widget.isSelected
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.8),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  color: widget.isSelected
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                  fontWeight: widget.isSelected
                      ? FontWeight.w600
                      : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
