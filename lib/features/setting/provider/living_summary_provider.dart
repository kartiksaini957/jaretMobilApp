import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api_services.dart';
import '../../../utils/pref_utils.dart';
import '../model/living_summary_model.dart';

final livingSummaryProvider =
    FutureProvider.autoDispose<LivingSummaryData>((ref) async {
  final token = await PrefUtils.getAccessToken();
  if (token == null || token.isEmpty) {
    throw ApiException('Not signed in.');
  }
  return ApiService().getLivingSummary(accessToken: token);
});
