import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import '../models/models.dart';
import '../constants/app_constants.dart';

class AppointmentAttendeesDialog extends StatelessWidget {
  final AppointmentResponse appointment;

  const AppointmentAttendeesDialog({super.key, required this.appointment});
  @override
  Widget build(BuildContext context) {
    final bookedByUser = appointment.bookedByUser;
    final attendees = appointment.attendees.where((attendee) {
      return bookedByUser == null || attendee.id != bookedByUser.id;
    }).toList();

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
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
                      padding: const EdgeInsets.all(16.0),
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
          ],
        ),
      ),
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
