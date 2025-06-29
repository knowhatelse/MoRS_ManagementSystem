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
        width: 500,
        constraints: const BoxConstraints(maxHeight: 600, minHeight: 300),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: AppConstants.primaryBlue,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppConstants.borderRadius),
                  topRight: Radius.circular(AppConstants.borderRadius),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.people, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Korisnici na terminu',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
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
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person_off,
                            size: 64,
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
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (bookedByUser != null) ...[
                            const Text(
                              'Rezervisao:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppConstants.primaryBlue,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildUserRow(bookedByUser, true),
                            const SizedBox(height: 24),
                          ],
                          if (attendees.isNotEmpty) ...[
                            Text(
                              'Učesnici (${attendees.length}):',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppConstants.primaryBlue,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...attendees.map(
                              (user) => Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: _buildUserRow(user, false),
                              ),
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

  Widget _buildUserRow(UserResponse user, bool isBooker) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: isBooker
            ? AppConstants.primaryBlue.withValues(alpha: 0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isBooker
              ? AppConstants.primaryBlue.withValues(alpha: 0.3)
              : Colors.grey.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          _buildUserAvatar(user),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.name} ${user.surname}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isBooker ? AppConstants.primaryBlue : Colors.black87,
                  ),
                ),
                if (user.email.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ],
            ),
          ),
          if (isBooker)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppConstants.primaryBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Organizator',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
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
              throw const FormatException('Incomplete JPEG image data');
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
