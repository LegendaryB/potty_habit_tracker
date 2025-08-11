import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:potty_habit_tracker/providers/event_provider.dart';
import '../models/event.dart';

class PottyEventImportService {
  final EventProvider provider;

  PottyEventImportService(this.provider);

  Future<void> importEvents() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null || result.files.isEmpty) {
      return;
    }

    final file = File(result.files.single.path!);
    final jsonString = await file.readAsString();
    final List<dynamic> jsonList = jsonDecode(jsonString);

    final importedEvents = jsonList.map((m) => PottyEvent.fromMap(m)).toList();

    for (final event in importedEvents) {
      await provider.addEvent(event);
    }
  }
}
