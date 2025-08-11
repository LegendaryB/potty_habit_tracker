import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
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
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: _selectedIndex == 0
          ? ExpandableFab(
              type: ExpandableFabType.up,
              distance: 60,
              openButtonBuilder: RotateFloatingActionButtonBuilder(
                child: const Icon(Icons.add),
                fabSize: ExpandableFabSize.regular,
                shape: const CircleBorder(),
              ),
              closeButtonBuilder: DefaultFloatingActionButtonBuilder(
                child: const Icon(Icons.close),
                fabSize: ExpandableFabSize.small,
                shape: const CircleBorder(),
              ),
              children: [
                FloatingActionButton.small(
                  heroTag: 'addPee',
                  onPressed: () => pottyEventService.addPee(),
                  shape: const CircleBorder(),
                  child: const Icon(Icons.opacity),
                ),
                FloatingActionButton.small(
                  heroTag: 'addPoop',
                  shape: const CircleBorder(),
                  onPressed: () => pottyEventService.addPoop(),
                  child: const Icon(Icons.grass),
                ),
              ],
            )
          : null,
    );
  }
}
