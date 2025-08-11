import 'package:flutter/material.dart';
import 'package:potty_habit_tracker/providers/event_provider.dart';
import 'package:potty_habit_tracker/screens/home.dart';
import 'package:potty_habit_tracker/services/event_export_service.dart';
import 'package:potty_habit_tracker/services/event_import_service.dart';
import 'package:potty_habit_tracker/services/event_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final provider = EventProvider();
  await provider.init();

  runApp(MyApp(provider: provider));
}

class MyApp extends StatelessWidget {
  final EventProvider provider;
  const MyApp({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<EventProvider>.value(value: provider),
        ProxyProvider<EventProvider, PottyEventService>(
          update: (_, eventProvider, _) => PottyEventService(eventProvider),
        ),
        ProxyProvider<EventProvider, PottyEventExportService>(
          update: (_, eventProvider, _) =>
              PottyEventExportService(eventProvider.events),
        ),
        ProxyProvider<EventProvider, PottyEventImportService>(
          update: (_, eventProvider, _) =>
              PottyEventImportService(eventProvider),
        ),
      ],
      child: MaterialApp(
        title: 'Potty Habit Tracker',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white, // text/icons
          ),
        ),
        home: HomeScreen(),
      ),
    );
  }
}
