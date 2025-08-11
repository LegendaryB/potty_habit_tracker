import 'package:flutter/foundation.dart';
import 'package:potty_habit_tracker/models/event.dart';
import 'package:potty_habit_tracker/services/db.dart';

class EventProvider extends ChangeNotifier {
  final List<PottyEvent> _events = [];

  List<PottyEvent> get events => List.unmodifiable(_events);

  Future<void> init() async {
    final db = await DB.database;
    final rows = await db.query('events', orderBy: 'timestamp DESC');
    _events.clear();
    _events.addAll(rows.map((r) => PottyEvent.fromMap(r)));
    notifyListeners();
  }

  Future<void> addEvent(PottyEvent e) async {
    final db = await DB.database;
    final id = await db.insert('events', e.toMap());
    _events.insert(0, PottyEvent(id: id, timestamp: e.timestamp, type: e.type));
    notifyListeners();
  }

  Future<void> deleteEvent(int id) async {
    final db = await DB.database;
    await db.delete('events', where: 'id = ?', whereArgs: [id]);
    _events.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  Map<DateTime, int> getCountsPerDay() {
    final Map<String, int> tmp = {};
    for (final e in _events) {
      final day = DateTime(
        e.timestamp.year,
        e.timestamp.month,
        e.timestamp.day,
      );
      final key = day.toIso8601String();
      tmp[key] = (tmp[key] ?? 0) + 1;
    }
    final res = <DateTime, int>{};
    tmp.forEach((k, v) => res[DateTime.parse(k)] = v);
    return res;
  }
}
