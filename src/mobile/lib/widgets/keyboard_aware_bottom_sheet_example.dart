import 'package:flutter/material.dart';
import 'create_appointment_bottom_sheet.dart';
import '../models/models.dart';

class KeyboardAwareBottomSheetExample extends StatelessWidget {
  const KeyboardAwareBottomSheetExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Keyboard-Aware Bottom Sheet Demo')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showCreateAppointmentBottomSheet(context),
          child: const Text('Show Bottom Sheet'),
        ),
      ),
    );
  }

  void _showCreateAppointmentBottomSheet(BuildContext context) {
    final currentUser = UserResponse(
      id: 1,
      name: 'Demo',
      surname: 'User',
      email: 'demo@example.com',
      phoneNumber: '+123456789',
      isRestricted: false,
      role: null,
      profilePicture: null,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          CreateAppointmentBottomSheet(currentUser: currentUser),
    );
  }
}
