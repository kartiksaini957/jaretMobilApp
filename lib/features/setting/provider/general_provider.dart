import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/api_services.dart';
import '../../../utils/pref_utils.dart';

@immutable
class GeneralSettingsState {
  const GeneralSettingsState({
    this.companyName = '',
    this.timezone = 'America/New_York',
    this.baseCurrency = 'USD',
    this.reportingPeriod = 'monthly',
    this.demoMode = false,
    this.reduceMotion = false,
    this.isLoading = true,
    this.isSaving = false,
    this.error,
  });

  final String companyName;
  final String timezone;
  final String baseCurrency;
  final String reportingPeriod;
  final bool demoMode;
  final bool reduceMotion;
  final bool isLoading;
  final bool isSaving;
  final String? error;

  static const timezones = [
    'America/New_York',
    'America/Chicago',
    'America/Denver',
    'America/Los_Angeles',
    'Europe/London',
    'Asia/Kolkata',
    'Asia/Dubai',
    'Asia/Singapore',
    'Australia/Sydney',
  ];

  static const currencies = ['USD', 'EUR', 'GBP', 'INR', 'AUD', 'CAD'];

  static const reportingPeriods = ['weekly', 'monthly', 'quarterly'];

  GeneralSettingsState copyWith({
    String? companyName,
    String? timezone,
    String? baseCurrency,
    String? reportingPeriod,
    bool? demoMode,
    bool? reduceMotion,
    bool? isLoading,
    bool? isSaving,
    String? error,
  }) {
    return GeneralSettingsState(
      companyName: companyName ?? this.companyName,
      timezone: timezone ?? this.timezone,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      reportingPeriod: reportingPeriod ?? this.reportingPeriod,
      demoMode: demoMode ?? this.demoMode,
      reduceMotion: reduceMotion ?? this.reduceMotion,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error,
    );
  }
}

class GeneralSettingsNotifier extends StateNotifier<GeneralSettingsState> {
  GeneralSettingsNotifier() : super(const GeneralSettingsState()) {
    _load();
  }

  Future<void> _load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final token = await PrefUtils.getAccessToken();
      if (token == null || token.isEmpty) {
        throw ApiException('Not signed in.');
      }
      final data = await ApiService().getGeneralSettings(accessToken: token);
      if (!mounted) return;
      state = GeneralSettingsState(
        companyName: data.companyName,
        timezone: data.timezone,
        baseCurrency: data.baseCurrency,
        reportingPeriod: data.reportingPeriod,
        demoMode: data.demoMode,
        reduceMotion: data.reduceMotion,
        isLoading: false,
      );
    } catch (e) {
       if (!mounted) return;
      final message = e is ApiException
          ? e.message
          : 'Could not load settings.';
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
      await ApiService().updateGeneralSettings(
        accessToken: token,
        changes: changes,
      );
        if (!mounted) return; 
      state = state.copyWith(isSaving: false);
    } catch (e) {
        if (!mounted) return; 
      final message = e is ApiException ? e.message : 'Could not save changes.';
      state = state.copyWith(isSaving: false, error: message);
    }
  }

  void setTimezone(String value) {
    final previous = state.timezone;
    state = state.copyWith(timezone: value);
    _patch({'timezone': value}).then((_) {
         if (!mounted) return;  
      if (state.error != null) state = state.copyWith(timezone: previous);
    });
  }

  void setBaseCurrency(String value) {
    final previous = state.baseCurrency;
    state = state.copyWith(baseCurrency: value);
    _patch({'base_currency': value}).then((_) {
       if (!mounted) return; 
      if (state.error != null) state = state.copyWith(baseCurrency: previous);
    });
  }

  void setReportingPeriod(String value) {
    final previous = state.reportingPeriod;
    state = state.copyWith(reportingPeriod: value);
    _patch({'reporting_period': value}).then((_) {
       if (!mounted) return; 
      if (state.error != null)
        state = state.copyWith(reportingPeriod: previous);
    });
  }

  void setDemoMode(bool value) {
    final previous = state.demoMode;
    state = state.copyWith(demoMode: value);
    _patch({'demo_mode': value}).then((_) {
       if (!mounted) return; 
      if (state.error != null) state = state.copyWith(demoMode: previous);
    });
  }

  void setReduceMotion(bool value) {
    final previous = state.reduceMotion;
    state = state.copyWith(reduceMotion: value);
    _patch({'reduce_motion': value}).then((_) {
       if (!mounted) return; 
      if (state.error != null) state = state.copyWith(reduceMotion: previous);
    });
  }
}

final generalSettingsProvider =
    StateNotifierProvider.autoDispose<
      GeneralSettingsNotifier,
      GeneralSettingsState
    >((ref) => GeneralSettingsNotifier());
