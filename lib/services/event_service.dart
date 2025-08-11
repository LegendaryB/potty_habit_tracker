import 'package:potty_habit_tracker/models/event.dart';
import 'package:potty_habit_tracker/providers/event_provider.dart';

class PottyEventService {
  final EventProvider provider;

  PottyEventService(this.provider);

  void addPee() {
    provider.addEvent(
      PottyEvent(timestamp: DateTime.now(), type: PottyType.pee),
    );
  }

  void addPoop() {
    provider.addEvent(
      PottyEvent(timestamp: DateTime.now(), type: PottyType.poop),
    );
  }
}
