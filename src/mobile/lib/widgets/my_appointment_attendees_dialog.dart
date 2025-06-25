import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import '../models/models.dart';
import '../constants/app_constants.dart';
import '../providers/my_appointments_provider.dart';
import 'package:provider/provider.dart';

class MyAppointmentAttendeesDialog extends StatelessWidget {
  final AppointmentResponse appointment;
  final int currentUserId;
  final int? currentUserRoleId;
  final VoidCallback onAppointmentUpdated;

  const MyAppointmentAttendeesDialog({
    super.key,
    required this.appointment,
    required this.currentUserId,
    required this.currentUserRoleId,
    required this.onAppointmentUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final bookedByUser = appointment.bookedByUser;
    final attendees = appointment.attendees.where((attendee) {
      return bookedByUser == null || attendee.id != bookedByUser.id;
    }).toList();

    final isBookedByCurrentUser = appointment.bookedByUser?.id == currentUserId;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Icon(Icons.people, color: AppConstants.primaryBlue, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    AppStrings.users,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.primaryBlue,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close,
                      color: AppConstants.primaryBlue,
                      size: 24,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            Flexible(
              child: (bookedByUser == null && attendees.isEmpty)
                  ? Container(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person_off,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Nema korisnika za ovaj termin',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (bookedByUser != null) ...[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Row(
                                children: [
                                  _buildUserAvatar(bookedByUser),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      '${bookedByUser.name} ${bookedByUser.surname}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppConstants.primaryBlue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          if (attendees.isNotEmpty) ...[
                            Column(
                              children: attendees.map((user) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: Row(
                                    children: [
                                      _buildUserAvatar(user),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          '${user.name} ${user.surname}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppConstants.primaryBlue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
            ),
            if (isBookedByCurrentUser && !appointment.isCancelled) ...[
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    if (currentUserRoleId == 2) ...[
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () =>
                              _showDeleteConfirmationDialog(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFe15252),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Obriši',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _showCancelConfirmationDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFe1c952),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Otkaži',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Potvrda brisanja'),
          content: const Text(
            'Da li ste sigurni da želite obrisati ovaj termin? Ova akcija se ne može poništiti.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Otkaži'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                if (!context.mounted) return;
                final provider = context.read<MyAppointmentsProvider>();
                final success = await provider.deleteAppointment(
                  appointment.id,
                );

                if (!context.mounted) return;
                if (success) {
                  Navigator.of(context).pop();
                  onAppointmentUpdated();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Termin je uspješno obrisan'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Greška pri brisanju termina'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFe15252),
                foregroundColor: Colors.white,
              ),
              child: const Text('Obriši'),
            ),
          ],
        );
      },
    );
  }

  void _showCancelConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Potvrda otkazivanja'),
          content: const Text(
            'Da li ste sigurni da želite otkazati ovaj termin?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Ne'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                if (!context.mounted) return;
                final provider = context.read<MyAppointmentsProvider>();
                final success = await provider.cancelAppointment(
                  appointment.id,
                );

                if (!context.mounted) return;
                if (success) {
                  Navigator.of(context).pop();
                  onAppointmentUpdated();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Termin je uspješno otkazan'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Greška pri otkazivanju termina'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFe1c952),
                foregroundColor: Colors.white,
              ),
              child: const Text('Otkaži termin'),
            ),
          ],
        );
      },
    );
  }

  Uint8List _base64ToBytes(String base64String) {
    try {
      String cleanBase64 = base64String.trim();

      if (cleanBase64.startsWith('data:')) {
        final commaIndex = cleanBase64.indexOf(',');
        if (commaIndex != -1) {
          cleanBase64 = cleanBase64.substring(commaIndex + 1);
        }
      }

      cleanBase64 = cleanBase64.replaceAll(RegExp(r'\s+'), '');

      while (cleanBase64.length % 4 != 0) {
        cleanBase64 += '=';
      }

      final bytes = base64Decode(cleanBase64);

      return bytes;
    } catch (e) {
      rethrow;
    }
  }

  Widget _buildUserAvatar(UserResponse user) {
    if (user.profilePicture?.base64Data != null &&
        user.profilePicture!.base64Data.isNotEmpty) {
      try {
        final imageBytes = _base64ToBytes(user.profilePicture!.base64Data);
        if (imageBytes.isNotEmpty && imageBytes.length > 500) {
          if (imageBytes[0] == 0xFF && imageBytes[1] == 0xD8) {
            bool hasEndMarker = false;
            for (int i = 0; i < imageBytes.length - 1; i++) {
              if (imageBytes[i] == 0xFF && imageBytes[i + 1] == 0xD9) {
                hasEndMarker = true;
                break;
              }
            }
            if (!hasEndMarker) {
              throw FormatException('Incomplete JPEG image data');
            }
          }

          return Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: ClipOval(
              child: Image.memory(
                imageBytes,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildDefaultAvatarContent();
                },
              ),
            ),
          );
        }
      } catch (e) {
        //
      }
    }

    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    return CircleAvatar(
      radius: 24,
      backgroundColor: AppConstants.primaryBlue,
      child: const Icon(Icons.person, size: 24, color: Colors.white),
    );
  }

  Widget _buildDefaultAvatarContent() {
    return Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppConstants.primaryBlue,
      ),
      child: const Icon(Icons.person, size: 24, color: Colors.white),
    );
  }
}
