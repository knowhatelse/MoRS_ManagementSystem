import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/widgets.dart';
import '../providers/my_appointments_provider.dart';
import '../constants/app_constants.dart';
import '../utils/app_utils.dart';
import '../models/models.dart';

class MyAppointmentsPage extends StatefulWidget {
  final UserResponse? currentUser;

  const MyAppointmentsPage({super.key, this.currentUser});

  @override
  State<MyAppointmentsPage> createState() => _MyAppointmentsPageState();
}

class _MyAppointmentsPageState extends State<MyAppointmentsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.currentUser != null) {
        context.read<MyAppointmentsProvider>().loadMyAppointments(
          widget.currentUser!.id,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MyAppointmentsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppConstants.primaryBlue),
            );
          }
          if (provider.hasError) {
            return MyAppointmentsErrorState(
              errorMessage: provider.errorMessage ?? AppStrings.unexpectedError,
              onRetry: () => provider.refreshMyAppointments(),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await provider.refreshMyAppointments();
              if (provider.hasError && mounted) {
                if (context.mounted) {
                  AppUtils.showNetworkErrorSnackbar(
                    context,
                    provider.errorMessage ?? AppStrings.unexpectedError,
                  );
                }
              }
            },
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: MyAppointmentsFilterSection(provider: provider),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                if (provider.hasAppointments)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final appointment = provider.appointments[index];
                        return MyAppointmentCard(
                          appointment: appointment,
                          onTap: () => _onAppointmentTap(appointment),
                        );
                      }, childCount: provider.appointments.length),
                    ),
                  )
                else
                  const MyAppointmentsEmptyState(),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onAppointmentTap(AppointmentResponse appointment) {
    showDialog(
      context: context,
      builder: (context) => MyAppointmentAttendeesDialog(
        appointment: appointment,
        currentUserId: widget.currentUser?.id ?? 0,
        currentUserRoleId: widget.currentUser?.role?.id,
        onAppointmentUpdated: () {
          context.read<MyAppointmentsProvider>().refreshMyAppointments();
        },
      ),
    );
  }
}
