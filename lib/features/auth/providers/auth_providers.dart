import 'package:flutter_riverpod/legacy.dart';

final signUpPasswordVisibleProvider = StateProvider.autoDispose<bool>(
  (ref) => false,
);
final loginPasswordVisibleProvider = StateProvider.autoDispose<bool>(
  (ref) => false,
);
