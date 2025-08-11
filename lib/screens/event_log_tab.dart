import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/event.dart';
import '../providers/event_provider.dart';

class EventLogTab extends StatelessWidget {
  const EventLogTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);

    if (provider.events.isEmpty) {
      return Center(
        child: Text(
          'No events yet.\nTap the buttons on the dashboard to add pee or poop events.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: provider.events.length,
      itemBuilder: (context, i) {
        final e = provider.events[i];
        return ListTile(
          leading: Icon(e.type == PottyType.pee ? Icons.opacity : Icons.grass),
          title: Text(e.type == PottyType.pee ? 'Pee' : 'Poop'),
          subtitle: Text(DateFormat('dd.MM.yyyy HH:mm').format(e.timestamp)),
          trailing: e.id != null
              ? IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await provider.deleteEvent(e.id!);
                  },
                )
              : null,
        );
      },
    );
  }
}
