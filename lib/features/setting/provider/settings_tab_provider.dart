import 'package:flutter_riverpod/legacy.dart';

/// Index of the selected settings tab pill (General, Integrations, ...).
final settingsTabIndexProvider = StateProvider<int>((ref) => 0);
