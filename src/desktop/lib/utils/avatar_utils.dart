import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import '../models/models.dart';
import '../constants/app_constants.dart';

class AvatarUtils {
  static const Color _primaryColor = AppConstants.primaryBlue;

  static Uint8List _base64ToBytes(String base64String) {
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

  static Widget buildUserAvatar(UserResponse user, {bool isSelected = false}) {
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
            width: 40,
            height: 40,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: ClipOval(
              child: Image.memory(
                imageBytes,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return buildDefaultAvatar(isSelected: isSelected);
                },
              ),
            ),
          );
        }
      } catch (e) {
        // 
      }
    }

    return buildDefaultAvatar(isSelected: isSelected);
  }

  static Widget buildDefaultAvatar({bool isSelected = false}) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: isSelected ? _primaryColor : Colors.grey.shade600,
      child: const Icon(Icons.person, size: 20, color: Colors.white),
    );
  }
}
