import 'package:flutter/material.dart';
import 'package:potty_habit_tracker/widgets/potty_histogram.dart';
import 'package:potty_habit_tracker/widgets/statistics_card.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/event.dart';
import '../providers/event_provider.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);

    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);

    // Filter today's events
    final todayEvents = provider.events.where(
      (e) => e.timestamp.isAfter(todayStart),
    );

    final peeEvents = todayEvents
        .where((e) => e.type == PottyType.pee)
        .toList();
    final poopEvents = todayEvents
        .where((e) => e.type == PottyType.poop)
        .toList();

    DateTime? lastPee = provider.events
        .where((e) => e.type == PottyType.pee)
        .fold<DateTime?>(
          null,
          (prev, e) =>
              prev == null || e.timestamp.isAfter(prev) ? e.timestamp : prev,
        );

    DateTime? lastPoop = provider.events
        .where((e) => e.type == PottyType.poop)
        .fold<DateTime?>(
          null,
          (prev, e) =>
              prev == null || e.timestamp.isAfter(prev) ? e.timestamp : prev,
        );

    // Prepare histogram data: count per hour for pee and poop separately
    List<int> peeCountByHour = List.filled(24, 0);
    List<int> poopCountByHour = List.filled(24, 0);

    for (var e in provider.events) {
      int hour = e.timestamp.hour;
      if (e.type == PottyType.pee) {
        peeCountByHour[hour]++;
      } else {
        poopCountByHour[hour]++;
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: StatisticCard(
                      title: 'Pees Today',
                      value: '${peeEvents.length}',
                      icon: Icons.opacity,
                      color: Colors.blue,
                    ),
                  ),
                  Expanded(
                    child: StatisticCard(
                      title: 'Poops Today',
                      value: '${poopEvents.length}',
                      icon: Icons.grass,
                      color: Colors.brown,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: StatisticCard(
                      title: 'Last Pee',
                      value: lastPee != null
                          ? DateFormat.Hm().format(lastPee)
                          : '-',
                      icon: Icons.access_time,
                      color: Colors.blue,
                    ),
                  ),
                  Expanded(
                    child: StatisticCard(
                      title: 'Last Poop',
                      value: lastPoop != null
                          ? DateFormat.Hm().format(lastPoop)
                          : '-',
                      icon: Icons.access_time,
                      color: Colors.brown,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'Potty Events by Hour',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 300),
            child: PottyHistogram(
              peeCountByHour: peeCountByHour,
              poopCountByHour: poopCountByHour,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
