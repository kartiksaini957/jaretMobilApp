import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/api_services.dart';
import '../../../utils/pref_utils.dart';

@immutable
class DataPrivacyState {
  const DataPrivacyState({
    this.peerBenchmarking = false,
    this.aiImprovement = false,
    this.photoPermissions = false,
    this.googleBusinessProfile = false,
    this.website = false,
    this.facebookPage = false,
    this.retentionDays = 365,
    this.isLoading = true,
    this.isSaving = false,
    this.error,
  });

  final bool peerBenchmarking;
  final bool aiImprovement;
  final bool photoPermissions;
  final bool googleBusinessProfile;
  final bool website;
  final bool facebookPage;
  final int retentionDays;
  final bool isLoading;
  final bool isSaving;
  final String? error;

  static const retentionOptions = [30, 90, 180, 365, 730];

  DataPrivacyState copyWith({
    bool? peerBenchmarking,
    bool? aiImprovement,
    bool? photoPermissions,
    bool? googleBusinessProfile,
    bool? website,
    bool? facebookPage,
    int? retentionDays,
    bool? isLoading,
    bool? isSaving,
    String? error,
  }) {
    return DataPrivacyState(
      peerBenchmarking: peerBenchmarking ?? this.peerBenchmarking,
      aiImprovement: aiImprovement ?? this.aiImprovement,
      photoPermissions: photoPermissions ?? this.photoPermissions,
      googleBusinessProfile:
          googleBusinessProfile ?? this.googleBusinessProfile,
      website: website ?? this.website,
      facebookPage: facebookPage ?? this.facebookPage,
      retentionDays: retentionDays ?? this.retentionDays,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error,
    );
  }

  List<String> get _sourcesList => [
    if (googleBusinessProfile) 'google',
    if (website) 'website',
    if (facebookPage) 'facebook',
  ];

  Map<String, dynamic> get photoPermissionsJson => {
    'enabled': photoPermissions,
    'sources': _sourcesList,
  };
}

class DataPrivacyNotifier extends StateNotifier<DataPrivacyState> {
  DataPrivacyNotifier() : super(const DataPrivacyState()) {
    _load();
  }

  Future<void> _load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final token = await PrefUtils.getAccessToken();
      if (token == null || token.isEmpty) {
        throw ApiException('Not signed in.');
      }
      final data = await ApiService().getDataPrivacySettings(
        accessToken: token,
      );
      state = DataPrivacyState(
        peerBenchmarking: data.peerBenchmarking,
        aiImprovement: data.anonymizedAiUse,
        photoPermissions: data.photoPermissionsEnabled,
        googleBusinessProfile: data.photoSources.contains('google'),
        website: data.photoSources.contains('website'),
        facebookPage: data.photoSources.contains('facebook'),
        retentionDays: data.retentionDays,
        isLoading: false,
      );
    } catch (e) {
      final message = e is ApiException
          ? e.message
          : 'Could not load privacy settings.';
      state = state.copyWith(isLoading: false, error: message);
    }
  }

  void retry() => _load();

  Future<void> _patch(Map<String, dynamic> changes) async {
    state = state.copyWith(isSaving: true, error: null);
    try {
      final token = await PrefUtils.getAccessToken();
      if (token == null || token.isEmpty) {
        throw ApiException('Not signed in.');
      }
      await ApiService().updateDataPrivacySettings(
        accessToken: token,
        changes: changes,
      );
      state = state.copyWith(isSaving: false);
    } catch (e) {
      final message = e is ApiException ? e.message : 'Could not save changes.';
      state = state.copyWith(isSaving: false, error: message);
    }
  }

  void setPeerBenchmarking(bool value) {
    final previous = state.peerBenchmarking;
    state = state.copyWith(peerBenchmarking: value);
    _patch({'peer_benchmarking': value}).then((_) {
      if (state.error != null)
        state = state.copyWith(peerBenchmarking: previous);
    });
  }

  void setAiImprovement(bool value) {
    final previous = state.aiImprovement;
    state = state.copyWith(aiImprovement: value);
    _patch({'anonymized_ai_use': value}).then((_) {
      if (state.error != null) state = state.copyWith(aiImprovement: previous);
    });
  }

  void setPhotoPermissions(bool value) {
    final previous = state.photoPermissions;
    state = state.copyWith(photoPermissions: value);
    _patch({'photo_permissions': state.photoPermissionsJson}).then((_) {
      if (state.error != null)
        state = state.copyWith(photoPermissions: previous);
    });
  }

  void setGoogleBusinessProfile(bool value) {
    final previous = state.googleBusinessProfile;
    state = state.copyWith(googleBusinessProfile: value);
    _patch({'photo_permissions': state.photoPermissionsJson}).then((_) {
      if (state.error != null)
        state = state.copyWith(googleBusinessProfile: previous);
    });
  }

  void setWebsite(bool value) {
    final previous = state.website;
    state = state.copyWith(website: value);
    _patch({'photo_permissions': state.photoPermissionsJson}).then((_) {
      if (state.error != null) state = state.copyWith(website: previous);
    });
  }

  void setFacebookPage(bool value) {
    final previous = state.facebookPage;
    state = state.copyWith(facebookPage: value);
    _patch({'photo_permissions': state.photoPermissionsJson}).then((_) {
      if (state.error != null) state = state.copyWith(facebookPage: previous);
    });
  }

  void setRetentionDays(int value) {
    final previous = state.retentionDays;
    state = state.copyWith(retentionDays: value);
    _patch({'retention_days': value}).then((_) {
      if (state.error != null) state = state.copyWith(retentionDays: previous);
    });
  }
}

final dataPrivacyProvider =
    StateNotifierProvider.autoDispose<DataPrivacyNotifier, DataPrivacyState>(
      (ref) => DataPrivacyNotifier(),
    );
