/// How confident LightSignal's read of a classification item is.
enum ConfidenceLevel { high, moderate, low }

/// One "How LightSignal sees your business" classification item.
class ClassificationItem {
  const ClassificationItem({
    required this.label,
    required this.confidence,
    required this.body,
  });

  final String label;
  final ConfidenceLevel confidence;
  final String body;
}

const classificationTotalCount = 12;

const classificationItems = [
  ClassificationItem(
    label: 'Operational format',
    confidence: ConfidenceLevel.high,
    body:
        'Counter-service slice shop — one 5th Avenue storefront in Bay '
        'Ridge, 22 seats, counter plus whole-pie pickup',
  ),
  ClassificationItem(
    label: 'What you sell',
    confidence: ConfidenceLevel.high,
    body:
        'NY slices and whole pies — the \$3.00 plain slice is the volume '
        'driver at about 1,900 slices a week; squares and sheet-pan '
        'catering alongside',
  ),
  ClassificationItem(
    label: 'Price position',
    confidence: ConfidenceLevel.moderate,
    body:
        'Value side of the block — \$3.00 plain slice vs the \$3.50 norm '
        'on 5th Avenue',
  ),
  ClassificationItem(
    label: 'How customers buy',
    confidence: ConfidenceLevel.high,
    body:
        'Walk-in counter trade, delivery apps at 14% of orders, catering '
        'booked by phone',
  ),
  ClassificationItem(
    label: 'Who you serve',
    confidence: ConfidenceLevel.high,
    body:
        'Local B2C — school-lunch slice trade on weekdays, family dinner '
        'crowd Friday–Saturday',
  ),
  ClassificationItem(
    label: 'Operating model',
    confidence: ConfidenceLevel.high,
    body:
        'Owner-operated by Salvatore "Sal" Rosetti with 9 staff '
        '(4 full-time, 5 part-time), single location since 2009',
  ),
  ClassificationItem(
    label: 'Supply chain',
    confidence: ConfidenceLevel.low,
    body:
        'Cheese and flour through distributors, produce weekly — reads '
        'as dependent on one cheese distributor at \$4.85/lb',
  ),
];
