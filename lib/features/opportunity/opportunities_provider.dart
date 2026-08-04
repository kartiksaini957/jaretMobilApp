import 'package:flutter_riverpod/flutter_riverpod.dart';

class OpportunityState {
  final int active;
  final int newThisWeek;
  final String totalValue;
  final int fitScore;
  final int readiness;

  OpportunityState({
    required this.active,
    required this.newThisWeek,
    required this.totalValue,
    required this.fitScore,
    required this.readiness,
  });
}


final opportunitiesProvider =
Provider<OpportunityState>((ref) {

  return OpportunityState(
    active: 14,
    newThisWeek: 3,
    totalValue: "\$32K",
    fitScore: 76,
    readiness: 75,
  );
});