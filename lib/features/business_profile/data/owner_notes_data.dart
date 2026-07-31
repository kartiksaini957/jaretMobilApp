/// One "Tell LightSignal something" owner note.
class OwnerNote {
  const OwnerNote({required this.dateLabel, required this.body});

  final String dateLabel;
  final String body;
}

/// Seed notes, newest first.
final ownerNotesSeed = [
  const OwnerNote(
    dateLabel: 'FEB 7',
    body:
        'Sold out of dough again Friday around 8pm — second time this '
        'month. Turned away a solid line, maybe 15–20 orders.',
  ),
  const OwnerNote(
    dateLabel: 'JAN 29',
    body:
        'Cheese is up again — paying \$4.85 a pound now, was about '
        '\$4.50 in December. Third bump since summer.',
  ),
  const OwnerNote(
    dateLabel: 'JAN 16',
    body:
        'Catering asks keep coming since the holidays — turned away a '
        'school pizza-party order this week because we have no set menu.',
  ),
];
