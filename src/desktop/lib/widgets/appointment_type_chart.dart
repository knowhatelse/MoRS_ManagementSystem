import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/appointment/appointment_response.dart';

class AppointmentTypeChart extends StatelessWidget {
  final List<AppointmentResponse> appointments;
  final DateTimeRange? dateRange;

  const AppointmentTypeChart({
    super.key,
    required this.appointments,
    this.dateRange,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, int> roomCounts = {};
    for (var appt in appointments) {
      final room = appt.room.name;
      roomCounts[room] = (roomCounts[room] ?? 0) + 1;
    }
    final allRooms = roomCounts.keys.toList()..sort();
    if (allRooms.isEmpty) {
      return const Center(child: Text('Nema podataka za prikaz grafa.'));
    }
    final barGroups = <BarChartGroupData>[];
    for (int i = 0; i < allRooms.length; i++) {
      final room = allRooms[i];
      final count = roomCounts[room] ?? 0;
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: count.toDouble(),
              color: Colors.blue,
              width: 32,
              borderRadius: BorderRadius.circular(6),
            ),
          ],
          showingTooltipIndicators: [0],
        ),
      );
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 480,
            child: BarChart(
              BarChartData(
                barGroups: barGroups,
                groupsSpace: 24,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final room = allRooms[group.x];
                      return BarTooltipItem(
                        '$room\nBroj termina: ${rod.toY.toInt()}',
                        const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= allRooms.length) {
                          return const SizedBox.shrink();
                        }
                        final room = allRooms[idx];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            room,
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: true),
                minY: 0,
                maxY:
                    (roomCounts.values.fold<int>(
                              0,
                              (prev, el) => el > prev ? el : prev,
                            ) *
                            1.2)
                        .ceilToDouble(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Iskorištenost prostorija (broj termina po prostoriji)',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
