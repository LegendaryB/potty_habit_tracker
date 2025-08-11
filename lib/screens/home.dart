import 'package:flutter/material.dart';
import 'package:potty_habit_tracker/colors.dart';
import 'package:potty_habit_tracker/screens/dashboard_tab.dart';
import 'package:potty_habit_tracker/screens/event_log_tab.dart';
import 'package:potty_habit_tracker/services/event_export_service.dart';
import 'package:potty_habit_tracker/services/event_import_service.dart';
import 'package:potty_habit_tracker/services/event_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [DashboardTab(), EventLogTab()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final exportService = context.read<PottyEventExportService>();
    final importService = context.read<PottyEventImportService>();
    final pottyEventService = context.read<PottyEventService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Potty Habit Tracker'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              switch (value) {
                case 'export':
                  await exportService.exportAndShareEvents();
                  break;
                case 'import':
                  await importService.importEvents();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(
                      Icons.outbox,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(width: 8),
                    Text('Export'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'import',
                child: Row(
                  children: [
                    Icon(
                      Icons.inbox,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(width: 8),
                    Text('Import'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Event log'),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min, // shrink to fit children
                mainAxisAlignment:
                    MainAxisAlignment.center, // center horizontally
                children: [
                  SizedBox(
                    child: FloatingActionButton.extended(
                      heroTag: 'addPee',
                      icon: const Icon(Icons.opacity, color: PeeColor),
                      label: const Text('Add Pee'),
                      onPressed: () => pottyEventService.addPee(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    child: FloatingActionButton.extended(
                      heroTag: 'addPoop',
                      icon: const Icon(Icons.grass, color: PoopColor),
                      label: const Text('Add Poop'),
                      onPressed: () => pottyEventService.addPoop(),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
