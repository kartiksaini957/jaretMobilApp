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

  static LocationType fromString(String? role) {
    if (role == null || role.isEmpty) return LocationType.regular;
    final r = role.toLowerCase();
    if (r.contains('headquarter')) return LocationType.headquarters;
    if (r.contains('seasonal') || r.contains('event')) return LocationType.seasonal;
    return LocationType.regular;
  }
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
    name: 'Dauphin Street Flagship',
    type: LocationType.headquarters,
    address: '450 Dauphin St, Mobile, AL 36602',
    details:
        'Geocoded ✓ · Mobile · space type: mobile · role: headquarters · status: active',
  ),
];
