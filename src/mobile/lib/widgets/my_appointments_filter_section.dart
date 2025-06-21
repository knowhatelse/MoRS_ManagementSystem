import 'package:flutter/material.dart';
import '../providers/my_appointments_provider.dart';
import '../widgets/my_appointment_filter_bottom_sheet.dart';

class MyAppointmentsFilterSection extends StatelessWidget {
  final MyAppointmentsProvider provider;

  const MyAppointmentsFilterSection({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final hasActiveFilters = provider.hasActiveFilters;

    return GestureDetector(
      onTap: () => _showFilterBottomSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: hasActiveFilters
              ? const Color(0xFF525FE1).withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: hasActiveFilters
              ? Border.all(color: const Color(0xFF525FE1), width: 1)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.filter_list, color: const Color(0xFF525FE1), size: 20),
            const SizedBox(width: 8),
            Text(
              'Filteri',
              style: const TextStyle(
                color: Color(0xFF525FE1),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (hasActiveFilters) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF525FE1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _getActiveFiltersCount(provider).toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  int _getActiveFiltersCount(MyAppointmentsProvider provider) {
    int count = 0;
    if (provider.filterDateFrom != null) count++;
    if (provider.filterDateTo != null) count++;
    if (provider.filterRoom != null) count++;
    if (provider.showMyAppointments) count++;
    if (provider.showOtherAppointments) count++;
    if (provider.showCancelledAppointments) count++;
    return count;
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MyAppointmentFilterBottomSheet(
        initialDateFrom: provider.filterDateFrom,
        initialDateTo: provider.filterDateTo,
        initialRoom: provider.filterRoom,
        initialShowMyAppointments: provider.showMyAppointments,
        initialShowOtherAppointments: provider.showOtherAppointments,
        initialShowCancelledAppointments: provider.showCancelledAppointments,
        onApplyFilters:
            (dateFrom, dateTo, room, showMy, showOther, showCancelled) {
              provider.applyFilters(
                dateFrom,
                dateTo,
                room,
                showMy,
                showOther,
                showCancelled,
              );
            },
      ),
    );
  }
}
