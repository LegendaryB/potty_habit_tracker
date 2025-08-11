enum PottyType { pee, poop }

class PottyEvent {
  final int? id;
  final DateTime timestamp;
  final PottyType type;

  PottyEvent({this.id, required this.timestamp, required this.type});

  Map<String, dynamic> toMap() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'type': type.name,
  };

  static PottyEvent fromMap(Map<String, dynamic> m) => PottyEvent(
    id: m['id'] as int?,
    timestamp: DateTime.parse(m['timestamp'] as String),
    type: m['type'] == 'pee' ? PottyType.pee : PottyType.poop,
  );
}
