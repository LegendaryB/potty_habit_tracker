import 'dart:io';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/event.dart';

class PottyEventExportService {
  final List<PottyEvent> events;

  PottyEventExportService(this.events);

  Future<void> exportAndShareEvents() async {
    final jsonList = events.map((e) => e.toMap()).toList();
    final jsonString = jsonEncode(jsonList);

    final tempDir = await getTemporaryDirectory();
    final formatter = DateFormat('yyyyMMdd_HHmmss');
    final timestamp = formatter.format(DateTime.now());

    final filePath =
        '${tempDir.path}/potty_habit_tracker_export_$timestamp.json';

    final file = File(filePath);

    await file.writeAsString(jsonString);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(filePath)],
        text: 'Here is my potty habit tracker export file.',
      ),
    );
  }
}
