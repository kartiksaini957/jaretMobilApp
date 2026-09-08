import 'package:flutter_application_1/core/api_services.dart';
import 'package:flutter_application_1/features/opportunity/model/oportunityModel.dart';
import 'package:flutter_application_1/utils/pref_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class OpportunitiesViewState {
  OpportunitiesViewState({
    required this.kpis,
    required this.portfolioSummary,
    required this.allOpportunities,
    required this.selectedTypes,
    required this.maxDriveTimeMinutes,
    required this.selectedRiskLevels,
    required this.searchQuery,
    this.trackedIds = const {}, // NEW — opportunity ids already tracked
    this.trackingIds = const {}, // NEW — ids with a Track API call in flight
  });

  final OpportunityKpis kpis;
  final PortfolioSummary portfolioSummary;

  /// Master ordered list — allOpportunities[0] is the "hero" when nothing
  /// is filtered out. promoteToHero() reorders this list.
  final List<OpportunityCard> allOpportunities;

  final Set<String> selectedTypes;
  final int? maxDriveTimeMinutes; // null = "Any distance"
  final Set<String> selectedRiskLevels;
  final String searchQuery;

  // NEW — track-button state
  final Set<String> trackedIds;
  final Set<String> trackingIds;

  /// List after applying type / distance / risk / search filters.
  List<OpportunityCard> get filtered {
    final q = searchQuery.trim().toLowerCase();
    return allOpportunities.where((o) {
      if (selectedTypes.isNotEmpty && !selectedTypes.contains(o.type)) {
        return false;
      }
      if (maxDriveTimeMinutes != null &&
          o.driveTimeMinutes > maxDriveTimeMinutes!) {
        return false;
      }
      if (selectedRiskLevels.isNotEmpty &&
          !selectedRiskLevels.contains(o.riskLevel)) {
        return false;
      }
      if (q.isNotEmpty) {
        final hay = '${o.title} ${o.source}'.toLowerCase();
        if (!hay.contains(q)) return false;
      }
      return true;
    }).toList();
  }

  OpportunityCard? get hero => filtered.isNotEmpty ? filtered.first : null;

  List<OpportunityCard> get moreMatches =>
      filtered.length > 1 ? filtered.sublist(1) : const [];

  List<String> get availableTypes =>
      (allOpportunities.map((o) => o.type).toSet().toList()..sort());

  List<String> get availableRiskLevels =>
      (allOpportunities
          .map((o) => o.riskLevel)
          .where((r) => r.isNotEmpty)
          .toSet()
          .toList()
        ..sort());

  int get activeFilterCount =>
      selectedTypes.length +
      selectedRiskLevels.length +
      (maxDriveTimeMinutes != null ? 1 : 0);

  // NEW — small helpers so the UI doesn't need to touch the sets directly
  bool isTracked(String opportunityId) => trackedIds.contains(opportunityId);
  bool isTracking(String opportunityId) => trackingIds.contains(opportunityId);

  OpportunitiesViewState copyWith({
    List<OpportunityCard>? allOpportunities,
    Set<String>? selectedTypes,
    int? maxDriveTimeMinutes,
    bool clearMaxDriveTime = false,
    Set<String>? selectedRiskLevels,
    String? searchQuery,
    Set<String>? trackedIds, // NEW
    Set<String>? trackingIds, // NEW
  }) {
    return OpportunitiesViewState(
      kpis: kpis,
      portfolioSummary: portfolioSummary,
      allOpportunities: allOpportunities ?? this.allOpportunities,
      selectedTypes: selectedTypes ?? this.selectedTypes,
      maxDriveTimeMinutes: clearMaxDriveTime
          ? null
          : (maxDriveTimeMinutes ?? this.maxDriveTimeMinutes),
      selectedRiskLevels: selectedRiskLevels ?? this.selectedRiskLevels,
      searchQuery: searchQuery ?? this.searchQuery,
      trackedIds: trackedIds ?? this.trackedIds, // NEW
      trackingIds: trackingIds ?? this.trackingIds, // NEW
    );
  }
}

class OpportunitiesController
    extends StateNotifier<AsyncValue<OpportunitiesViewState>> {
  OpportunitiesController() : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final token = await PrefUtils.getAccessToken();
      if (token == null || token.isEmpty) {
        throw Exception('Access token not found. Please login again.');
      }

      final response = await ApiService().getOpportunitiesOverview(
        accessToken: token,
      );

      final all = <OpportunityCard>[
        if (response.data.recommendedHero != null)
          response.data.recommendedHero!,
        ...response.data.moreMatches,
      ];

      state = AsyncValue.data(
        OpportunitiesViewState(
          kpis: response.data.kpis,
          portfolioSummary: response.data.portfolioSummary,
          allOpportunities: all,
          selectedTypes: const {},
          maxDriveTimeMinutes: null,
          selectedRiskLevels: const {},
          searchQuery: '',
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Tapped a "more matches" card (or a search result) — bring it to the
  /// hero slot by moving it to the front of the master list.
  void promoteToHero(String opportunityId) {
    final current = state.value;
    if (current == null) return;

    final list = List<OpportunityCard>.from(current.allOpportunities);
    final idx = list.indexWhere((o) => o.id == opportunityId);
    if (idx <= 0) return; // not found, or already hero

    final item = list.removeAt(idx);
    list.insert(0, item);

    state = AsyncValue.data(current.copyWith(allOpportunities: list));
  }

  void toggleType(String type) {
    final current = state.value;
    if (current == null) return;
    final updated = {...current.selectedTypes};
    if (!updated.remove(type)) updated.add(type);
    state = AsyncValue.data(current.copyWith(selectedTypes: updated));
  }

  void setMaxDriveTime(int? minutes) {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(
      current.copyWith(
        maxDriveTimeMinutes: minutes,
        clearMaxDriveTime: minutes == null,
      ),
    );
  }

  void toggleRiskLevel(String level) {
    final current = state.value;
    if (current == null) return;
    final updated = {...current.selectedRiskLevels};
    if (!updated.remove(level)) updated.add(level);
    state = AsyncValue.data(current.copyWith(selectedRiskLevels: updated));
  }

  void setSearchQuery(String query) {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(searchQuery: query));
  }

  void clearFilters() {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(
      current.copyWith(
        selectedTypes: const {},
        selectedRiskLevels: const {},
        maxDriveTimeMinutes: null,
        clearMaxDriveTime: true,
        searchQuery: '',
      ),
    );
  }

  // NEW — "+ Track" button calls this.
  // 1. immediately marks the id as "tracking" -> button shows a spinner
  // 2. calls PATCH /opportunities/{id}/status  {"status": "Tracked"}
  // 3. on success -> moves id from trackingIds into trackedIds, so the
  //    button switches to "In portfolio"
  // 4. on failure -> removes it from trackingIds and rethrows, so the
  //    screen can show a SnackBar with the error
  Future<void> trackOpportunity(String opportunityId) async {
    final current = state.value;
    if (current == null) return;

    // already tracked, or a request for this id is already in flight
    if (current.trackedIds.contains(opportunityId) ||
        current.trackingIds.contains(opportunityId)) {
      return;
    }

    state = AsyncValue.data(
      current.copyWith(trackingIds: {...current.trackingIds, opportunityId}),
    );

    try {
      final token = await PrefUtils.getAccessToken();
      if (token == null || token.isEmpty) {
        throw Exception('Access token not found. Please login again.');
      }

      await ApiService().updateOpportunityStatus(
        accessToken: token,
        opportunityId: opportunityId,
        status: 'Tracked',
      );

      final latest = state.value;
      if (latest == null) return;
      state = AsyncValue.data(
        latest.copyWith(
          trackedIds: {...latest.trackedIds, opportunityId},
          trackingIds: {...latest.trackingIds}..remove(opportunityId),
        ),
      );
    } catch (e) {
      final latest = state.value;
      if (latest != null) {
        state = AsyncValue.data(
          latest.copyWith(
            trackingIds: {...latest.trackingIds}..remove(opportunityId),
          ),
        );
      }
      rethrow; // let the UI show a SnackBar
    }
  }
    // NEW — "In portfolio" button tap se untrack karne ke liye.
  // 1. immediately marks the id as "tracking" -> button spinner dikhata hai
  // 2. calls PATCH /opportunities/{id}/status  {"status": "None"}
  // 3. on success -> id ko trackedIds se remove karta hai, button wapas "+ Track" ban jata hai
  // 4. on failure -> trackedIds me wapas rakhta hai aur rethrow karta hai, taaki UI SnackBar dikha sake
  Future<void> untrackOpportunity(String opportunityId) async {
    final current = state.value;
    if (current == null) return;

    // already untracked, or ek request already in flight hai
    if (!current.trackedIds.contains(opportunityId) ||
        current.trackingIds.contains(opportunityId)) {
      return;
    }

    state = AsyncValue.data(
      current.copyWith(trackingIds: {...current.trackingIds, opportunityId}),
    );

    try {
      final token = await PrefUtils.getAccessToken();
      if (token == null || token.isEmpty) {
        throw Exception('Access token not found. Please login again.');
      }

      await ApiService().updateOpportunityStatus(
        accessToken: token,
        opportunityId: opportunityId,
        status: 'None',
      );

      final latest = state.value;
      if (latest == null) return;
      state = AsyncValue.data(
        latest.copyWith(
          trackedIds: {...latest.trackedIds}..remove(opportunityId),
          trackingIds: {...latest.trackingIds}..remove(opportunityId),
        ),
      );
    } catch (e) {
      final latest = state.value;
      if (latest != null) {
        state = AsyncValue.data(
          latest.copyWith(
            trackingIds: {...latest.trackingIds}..remove(opportunityId),
          ),
        );
      }
      rethrow; // UI ko SnackBar dikhane do
    }
  }
}

final opportunitiesControllerProvider =
    StateNotifierProvider<
      OpportunitiesController,
      AsyncValue<OpportunitiesViewState>
    >((ref) {
      return OpportunitiesController();
    });
