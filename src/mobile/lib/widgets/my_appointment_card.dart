import 'package:flutter/material.dart';
import '../models/models.dart';
import '../constants/app_constants.dart';

class MyAppointmentCard extends StatelessWidget {
  final AppointmentResponse appointment;
  final VoidCallback? onTap;

  const MyAppointmentCard({super.key, required this.appointment, this.onTap});

  @override
  Widget build(BuildContext context) {
    Color roomColor = _parseHexColor(appointment.room.color);

    if (appointment.isCancelled) {
      roomColor = Colors.grey.shade400;
    }

    String formattedDate = _formatDate(appointment.appointmentSchedule.date);

    String timeRange = appointment.appointmentSchedule.time.formattedTimeRange;

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(color: roomColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            appointment.appointmentType.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (appointment.isCancelled) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'OTKAZANO',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    appointment.room.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: appointment.isCancelled
                    ? Colors.grey.shade100
                    : Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: appointment.isCancelled
                            ? Colors.grey.shade500
                            : Colors.grey[700],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          color: appointment.isCancelled
                              ? Colors.grey.shade500
                              : Colors.grey[700],
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: appointment.isCancelled
                            ? Colors.grey.shade500
                            : Colors.grey[700],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        timeRange,
                        style: TextStyle(
                          color: appointment.isCancelled
                              ? Colors.grey.shade500
                              : Colors.grey[700],
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _parseHexColor(String hexColor) {
    try {
      String colorString = hexColor.replaceAll('#', '');

      if (colorString.length == 6) {
        colorString = 'FF$colorString';
      }

      return Color(int.parse(colorString, radix: 16));
    } catch (e) {
      return AppConstants.primaryBlue;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
