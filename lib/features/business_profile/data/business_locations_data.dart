enum LocationType {
  headquarters,
  regular,
  seasonal;

  String get label => switch (this) {
    LocationType.headquarters => 'Headquarters',
    LocationType.regular => 'Regular spot',
    LocationType.seasonal => 'Seasonal / event',
  };

  String get badgeLabel => switch (this) {
    LocationType.headquarters => 'HEADQUARTERS',
    LocationType.regular => 'REGULAR SPOT',
    LocationType.seasonal => 'SEASONAL / EVENT',
  };
}

/// One business location. [address]/[details] are null while geocoding is
/// still pending (every newly added location starts this way).
class BusinessLocation {
  const BusinessLocation({
    required this.name,
    required this.type,
    this.address,
    this.details,
  });

  final String name;
  final LocationType type;
  final String? address;
  final String? details;

  bool get isPending => address == null;
}

final businessLocationsSeed = [
  const BusinessLocation(
    name: '5th Avenue storefront',
    type: LocationType.headquarters,
    address: '7612 5th Ave, Brooklyn, NY 11209',
    details:
        'Geocoded ✓ · Bay Ridge · space type: leased storefront · 22 '
        'seats · open 11am–10pm, Fri–Sat to 11pm',
  ),
  const BusinessLocation(name: 'New spot', type: LocationType.regular),
];
