import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class DateHeader extends StatelessWidget {
  final DateTime selectedDate;
  final String formattedSelectedDate;
  final Function(DateTime) onDateChanged;

  const DateHeader({
    super.key,
    required this.selectedDate,
    required this.formattedSelectedDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              final previousDay = selectedDate.subtract(
                const Duration(days: 1),
              );
              onDateChanged(previousDay);
            },
            icon: const Icon(Icons.chevron_left),
            color: AppConstants.primaryBlue,
            iconSize: 32,
          ),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: AppConstants.primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                border: Border.all(color: AppConstants.primaryBlue, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: AppConstants.primaryBlue,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    formattedSelectedDate,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              final nextDay = selectedDate.add(const Duration(days: 1));
              onDateChanged(nextDay);
            },
            icon: const Icon(Icons.chevron_right),
            color: AppConstants.primaryBlue,
            iconSize: 32,
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(selectedDate.year - 1),
      lastDate: DateTime(selectedDate.year + 2),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppConstants.primaryBlue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      onDateChanged(date);
    }
  }
}
