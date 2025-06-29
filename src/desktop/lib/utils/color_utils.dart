import 'package:flutter/material.dart';

class ColorUtils {
  static Color hexToColor(String hex) {
    if (hex.startsWith('#')) {
      hex = hex.substring(1);
    }
    return Color(int.parse('FF$hex', radix: 16));
  }

  static String colorToHex(Color color) {
    final int r = (color.r * 255.0).round() & 0xff;
    final int g = (color.g * 255.0).round() & 0xff;
    final int b = (color.b * 255.0).round() & 0xff;
    return '#${(0xFF000000 | (r << 16) | (g << 8) | b).toRadixString(16).substring(2).toUpperCase()}';
  }
}
