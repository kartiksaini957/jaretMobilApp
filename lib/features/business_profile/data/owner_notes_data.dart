/// One "Tell LightSignal something" owner note.
class OwnerNote {
  const OwnerNote({
    this.id = '',
    this.timestamp = '',
    required this.dateLabel,
    required this.body,
  });

  final String id;
  final String timestamp;
  final String dateLabel;
  final String body;

  factory OwnerNote.fromJson(Map<String, dynamic> json) {
    final rawTimestamp = json['timestamp'] as String? ?? '';
    final text = json['text'] as String? ?? '';
    final id = json['id'] as String? ?? '';

    String dateLabel = '';
    if (rawTimestamp.isNotEmpty) {
      try {
        final dt = DateTime.parse(rawTimestamp).toLocal();
        const monthAbbrev = [
          'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
          'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
        ];
        dateLabel = '${monthAbbrev[dt.month - 1]} ${dt.day}';
      } catch (_) {
        dateLabel = rawTimestamp;
      }
    }

    return OwnerNote(
      id: id,
      timestamp: rawTimestamp,
      dateLabel: dateLabel.isNotEmpty ? dateLabel : 'RECENT',
      body: text,
    );
  }
}

/// Seed notes, newest first.
final ownerNotesSeed = [
  const OwnerNote(
    dateLabel: 'RECENT',
    body: 'Slow weeks blindside me',
  ),
  const OwnerNote(
    dateLabel: 'FEB 7',
    body:
        'Sold out of fresh gulf shrimp Friday evening around 7:30pm — turned away around 15 catering orders.',
  ),
  const OwnerNote(
    dateLabel: 'JAN 29',
    body:
        'Commissary kitchen rent adjusted to \$850/mo. Toast POS hardware functioning smoothly.',
  ),
];
