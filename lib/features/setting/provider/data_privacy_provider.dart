import 'package:flutter_riverpod/flutter_riverpod.dart';

class DataPrivacyState {
  const DataPrivacyState({
    this.peerBenchmarking = true,
    this.aiImprovement = true,
    this.photoPermissions = true,
    this.googleBusinessProfile = true,
    this.website = true,
    this.facebookPage = true,
    this.retentionDays = 365,
  });

  final bool peerBenchmarking;
  final bool aiImprovement;
  final bool photoPermissions;
  final bool googleBusinessProfile;
  final bool website;
  final bool facebookPage;
  final int retentionDays;

  static const retentionOptions = [90, 180, 365];

  DataPrivacyState copyWith({
    bool? peerBenchmarking,
    bool? aiImprovement,
    bool? photoPermissions,
    bool? googleBusinessProfile,
    bool? website,
    bool? facebookPage,
    int? retentionDays,
  }) {
    return DataPrivacyState(
      peerBenchmarking: peerBenchmarking ?? this.peerBenchmarking,
      aiImprovement: aiImprovement ?? this.aiImprovement,
      photoPermissions: photoPermissions ?? this.photoPermissions,
      googleBusinessProfile: googleBusinessProfile ?? this.googleBusinessProfile,
      website: website ?? this.website,
      facebookPage: facebookPage ?? this.facebookPage,
      retentionDays: retentionDays ?? this.retentionDays,
    );
  }
}

/// Data & Privacy tab: what LightSignal may use, and for how long.
class DataPrivacyController extends Notifier<DataPrivacyState> {
  @override
  DataPrivacyState build() => const DataPrivacyState();

  void setPeerBenchmarking(bool value) =>
      state = state.copyWith(peerBenchmarking: value);

  void setAiImprovement(bool value) =>
      state = state.copyWith(aiImprovement: value);

  void setPhotoPermissions(bool value) =>
      state = state.copyWith(photoPermissions: value);

  void setGoogleBusinessProfile(bool value) =>
      state = state.copyWith(googleBusinessProfile: value);

  void setWebsite(bool value) => state = state.copyWith(website: value);

  void setFacebookPage(bool value) =>
      state = state.copyWith(facebookPage: value);

  void setRetentionDays(int value) =>
      state = state.copyWith(retentionDays: value);
}

final dataPrivacyProvider =
    NotifierProvider<DataPrivacyController, DataPrivacyState>(
      DataPrivacyController.new,
    );
