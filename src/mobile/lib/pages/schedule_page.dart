import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/appointment_card.dart';
import '../widgets/widgets.dart';
import '../providers/providers.dart';
import '../constants/app_constants.dart';
import '../utils/app_utils.dart';
import '../models/models.dart';

class SchedulePage extends StatefulWidget {
  final UserResponse? currentUser;

  const SchedulePage({super.key, this.currentUser});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppointmentProvider>().loadAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppointmentProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppConstants.primaryBlue),
            );
          }

          if (provider.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    provider.errorMessage ?? AppStrings.unexpectedError,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => provider.refreshAppointments(),
                    icon: const Icon(Icons.refresh),
                    label: const Text(AppStrings.tryAgain),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryBlue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await provider.refreshAppointments();
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
                    child: _buildFilterSection(provider),
                  ),
                ),
                
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                
                if (provider.hasAppointments)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final appointment = provider.appointments[index];
                        return AppointmentCard(
                          appointment: appointment,
                          onTap: () => _onAppointmentTap(appointment),
                        );
                      }, childCount: provider.appointments.length),
                    ),
                  )
                else
                  SliverFillRemaining(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          provider.isToday
                              ? AppStrings.noAppointmentsToday
                              : AppStrings.noAppointmentsForDate,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Pokušajte odabrati drugi datum',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: widget.currentUser != null
          ? FloatingActionButton(
              onPressed: _showCreateAppointmentBottomSheet,
              backgroundColor: const Color(0xFF525FE1),
              foregroundColor: Colors.white,
              shape: const CircleBorder(),
              elevation: 8,
              child: const Icon(Icons.add, size: 28),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _onAppointmentTap(AppointmentResponse appointment) {
    showDialog(
      context: context,
      builder: (context) =>
          AppointmentAttendeesDialog(appointment: appointment),
    );
  }

  Widget _buildFilterSection(AppointmentProvider provider) {
    final hasActiveFilters = provider.hasActiveFilters;

    return GestureDetector(
      onTap: _showFilterBottomSheet,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: hasActiveFilters
              ? const Color(0xFF525FE1).withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: hasActiveFilters
              ? Border.all(color: const Color(0xFF525FE1), width: 1)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.filter_list, color: const Color(0xFF525FE1), size: 20),
            const SizedBox(width: 8),
            Text(
              'Filteri',
              style: const TextStyle(
                color: Color(0xFF525FE1),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (hasActiveFilters) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF525FE1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _getActiveFiltersCount(provider).toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  int _getActiveFiltersCount(AppointmentProvider provider) {
    int count = 0;
    if (provider.filterDate != null) count++;
    if (provider.filterTimeFrom != null) count++;
    if (provider.filterTimeTo != null) count++;
    if (provider.filterRoom != null) count++;
    if (provider.filterAppointmentType != null) count++;
    return count;
  }

  void _showFilterBottomSheet() {
    final provider = context.read<AppointmentProvider>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AppointmentFilterBottomSheet(
        initialDate: provider.filterDate,
        initialTimeFrom: provider.filterTimeFrom,
        initialTimeTo: provider.filterTimeTo,
        initialRoom: provider.filterRoom,
        initialAppointmentType: provider.filterAppointmentType,
        onApplyFilters: (date, timeFrom, timeTo, room, appointmentType) {
          provider.applyFilters(date, timeFrom, timeTo, room, appointmentType);
        },
      ),
    );
  }

  void _showCreateAppointmentBottomSheet() {
    if (widget.currentUser == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          CreateAppointmentBottomSheet(currentUser: widget.currentUser!),
    ).then((result) {
      if (result == true && mounted) {
        context.read<AppointmentProvider>().refreshAppointments();
      }
    });
  }
}
