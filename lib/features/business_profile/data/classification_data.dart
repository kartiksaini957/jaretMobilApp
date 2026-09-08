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
        'Mobile Food Truck — Dauphin Street Flagship in Mobile, AL with commercial kitchen prep hub and catering pop-ups',
  ),
  ClassificationItem(
    label: 'What you sell',
    confidence: ConfidenceLevel.high,
    body:
        'Artisanal coastal cuisine & seafood — fresh gulf seafood, catering packages, and festival pop-up menus (\$18.50 avg ticket)',
  ),
  ClassificationItem(
    label: 'Industry & NAICS',
    confidence: ConfidenceLevel.high,
    body:
        'Food & Beverage (NAICS 722330: Mobile Food Services) · Growth Stage: Scaling',
  ),
  ClassificationItem(
    label: 'Point of Sale & Tech',
    confidence: ConfidenceLevel.high,
    body:
        'Toast POS integrated with QuickBooks Online & Instagram marketing channels',
  ),
  ClassificationItem(
    label: 'Who you serve',
    confidence: ConfidenceLevel.high,
    body:
        'B2C retail diners (lunch peak 11:30–1:30) & corporate catering clients across Mobile and Baldwin counties (35-mile radius)',
  ),
  ClassificationItem(
    label: 'Operating model',
    confidence: ConfidenceLevel.high,
    body:
        'Sole Member LLC owned & operated by Jane Doe with 3 staff (Lead Prep Cook, 2 Part-time Servers)',
  ),
  ClassificationItem(
    label: 'Risk & Insurance',
    confidence: ConfidenceLevel.moderate,
    body:
        '\$1,000,000 General Liability policy via Hartford, Commercial Auto, and Workers Comp; seasonal weather risk mitigation in place',
  ),
];
