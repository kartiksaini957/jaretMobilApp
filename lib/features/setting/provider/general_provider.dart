import 'package:flutter_riverpod/flutter_riverpod.dart';

class GeneralSettingsState {
  const GeneralSettingsState({
    this.companyName = 'LightSignal Demo Co.',
    this.timezone = 'America/New_York',
    this.baseCurrency = 'USD',
    this.reportingPeriod = 'Monthly',
    this.demoMode = true,
    this.reduceMotion = false,
  });

  final String companyName;
  final String timezone;
  final String baseCurrency;
  final String reportingPeriod;
  final bool demoMode;
  final bool reduceMotion;

  static const timezones = [
    'America/New_York',
    'America/Chicago',
    'America/Denver',
    'America/Los_Angeles',
  ];
  static const currencies = ['USD', 'CAD', 'EUR', 'GBP'];
  static const reportingPeriods = ['Monthly', 'Quarterly', 'Annually'];

  GeneralSettingsState copyWith({
    String? timezone,
    String? baseCurrency,
    String? reportingPeriod,
    bool? demoMode,
    bool? reduceMotion,
  }) {
    return GeneralSettingsState(
      companyName: companyName,
      timezone: timezone ?? this.timezone,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      reportingPeriod: reportingPeriod ?? this.reportingPeriod,
      demoMode: demoMode ?? this.demoMode,
      reduceMotion: reduceMotion ?? this.reduceMotion,
    );
  }
}

/// General tab: locale/reporting defaults plus demo-mode and motion toggles.
/// Changes apply immediately — mirrors the "Changes save automatically" copy.
class GeneralSettingsController extends Notifier<GeneralSettingsState> {
  @override
  GeneralSettingsState build() => const GeneralSettingsState();

  void setTimezone(String value) => state = state.copyWith(timezone: value);

  void setBaseCurrency(String value) =>
      state = state.copyWith(baseCurrency: value);

  void setReportingPeriod(String value) =>
      state = state.copyWith(reportingPeriod: value);

  void setDemoMode(bool value) => state = state.copyWith(demoMode: value);

  void setReduceMotion(bool value) =>
      state = state.copyWith(reduceMotion: value);
}

final generalSettingsProvider =
    NotifierProvider<GeneralSettingsController, GeneralSettingsState>(
      GeneralSettingsController.new,
    );
