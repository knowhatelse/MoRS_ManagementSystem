import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class FilterDropdown<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T?>> items;
  final ValueChanged<T?> onChanged;
  final Color borderColor;
  final Color iconColor;

  const FilterDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.borderColor = Colors.grey,
    this.iconColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? AppConstants.primaryBlue : borderColor,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T?>(
              isExpanded: true,
              value: value,
              hint: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Text(hint, style: const TextStyle(color: Colors.grey)),
              ),
              onChanged: onChanged,
              items: items,
              dropdownColor: Colors.white,
              icon: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(
                  Icons.arrow_drop_down,
                  color: isSelected ? AppConstants.primaryBlue : iconColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
