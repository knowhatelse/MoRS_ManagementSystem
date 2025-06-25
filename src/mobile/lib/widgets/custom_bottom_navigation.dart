import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  static const List<IconData> _navIcons = [
    Icons.campaign_outlined,
    Icons.calendar_today_outlined,
    Icons.schedule_outlined,
    Icons.report_problem_outlined,
    Icons.person_outline,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.primaryBlue,
        boxShadow: [AppConstants.bottomBarShadow],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: AppConstants.bottomBarHeight,
          padding: AppConstants.bottomNavPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              _navIcons.length,
              (index) => _BottomNavItem(
                icon: _navIcons[index],
                isSelected: selectedIndex == index,
                onTap: () => onItemTapped(index),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppConstants.navItemSize,
        height: AppConstants.navItemSize,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        child: Icon(
          icon,
          color: isSelected
              ? Colors.white
              : Colors.white.withValues(alpha: 0.6),
          size: AppConstants.iconSize,
        ),
      ),
    );
  }
}
