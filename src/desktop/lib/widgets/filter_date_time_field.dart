import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class FilterDateTimeField extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;
  final VoidCallback onTap;
  final VoidCallback? onClear;
  final IconData icon;
  final bool hasError;
  final String? errorText;

  const FilterDateTimeField({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.onTap,
    this.onClear,
    required this.icon,
    this.hasError = false,
    this.errorText,
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
              color: hasError
                  ? Colors.red
                  : isSelected
                  ? AppConstants.primaryBlue
                  : Colors.grey.shade300,
              width: hasError ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: isSelected ? AppConstants.primaryBlue : Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      value ?? hint,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.black87
                            : Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  if (isSelected && onClear != null)
                    GestureDetector(
                      onTap: onClear,
                      child: Icon(
                        Icons.clear,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (hasError && errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
