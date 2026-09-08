import 'package:flutter/foundation.dart';
import '../../../core/api_services.dart';
import '../../../utils/pref_utils.dart';

/// Repository managing the 15 onboarding sections data and syncing with
/// POST https://api.lightsignal.app/business-profile/onboarding
class OnboardingSectionsRepository {
  static final OnboardingSectionsRepository _instance =
      OnboardingSectionsRepository._internal();
  factory OnboardingSectionsRepository() => _instance;
  OnboardingSectionsRepository._internal();

  /// In-memory storage for all 15 sections
  final Map<String, dynamic> _allSections = Map<String, dynamic>.from(defaultOnboardingPayload);

  Map<String, dynamic> get allSections => Map<String, dynamic>.unmodifiable(_allSections);

  /// Map section number (1..15) to section key string
  static String getSectionKey(int sectionNumber) {
    final numStr = sectionNumber.toString().padLeft(2, '0');
    switch (sectionNumber) {
      case 1:
        return 'section_01_business_basics';
      case 2:
        return 'section_02_ownership_and_key_people';
      case 3:
        return 'section_03_industry_and_model';
      case 4:
        return 'section_04_operations';
      case 5:
        return 'section_05_financial_overview';
      case 6:
        return 'section_06_assets_and_equipment';
      case 7:
        return 'section_07_customers_and_market';
      case 8:
        return 'section_08_risk_and_exposure';
      case 9:
        return 'section_09_capacity_and_constraints';
      case 10:
        return 'section_10_opportunity_readiness';
      case 11:
        return 'section_11_strategic_goals';
      case 12:
        return 'section_12_pricing_and_revenue';
      case 13:
        return 'section_13_hiring_and_team_structure';
      case 14:
        return 'section_14_sales_and_marketing';
      case 15:
        return 'section_15_owner_goals_and_preferences';
      default:
        return 'section_${numStr}_custom';
    }
  }

  /// Whitelist of valid keys for each section (exact 95 questions)
  static const Map<String, List<String>> sectionValidKeys = {
    'section_01_business_basics': [
      'business_name',
      'headquarters',
      'years_in_business',
      'timezone',
      'currency',
      'legal_entity_type',
      'ein',
      'locations',
    ],
    'section_02_ownership_and_key_people': [
      'ownership_breakdown',
      'decision_maker',
      'bookkeeper_financial_handler',
      'has_backup_operator',
    ],
    'section_03_industry_and_model': [
      'business_description',
      'revenue_model_description',
      'target_market_type',
      'business_stage',
    ],
    'section_04_operations': [
      'team_size',
      'payroll_type',
      'operating_hours',
      'growth_limiters',
      'single_supplier_dependency',
      'uses_pos_system',
      'space_ownership_status',
      'operational_software',
      'recent_supplier_issues',
      'critical_materials_inputs',
    ],
    'section_05_financial_overview': [
      'accounting_system',
      'connect_accounting_now',
      'fiscal_year_start',
      'banks_and_lenders',
      'business_loan_history',
    ],
    'section_06_assets_and_equipment': [
      'major_assets',
      'asset_ownership_status',
      'asset_purchase_dates',
      'asset_condition',
      'leased_monthly_payment',
    ],
    'section_07_customers_and_market': [
      'customer_distance',
      'strongest_seasons',
      'customer_acquisition_channels',
      'typical_customers_description',
      'monthly_customer_volume',
      'repeat_business_rate',
      'target_customer_types',
      'customer_concentration',
      'seasonality_level',
      'customer_geographic_source',
      'opportunity_radius_miles',
      'max_travel_distance_miles',
      'local_opportunity_preference',
      'geographic_service_areas',
      'weather_impact',
    ],
    'section_08_risk_and_exposure': [
      'carries_business_insurance',
      'critical_dependencies',
      'revenue_concentration',
      'active_permits_licenses',
      'in_progress_permits_licenses',
      'local_operating_restrictions',
    ],
    'section_09_capacity_and_constraints': [
      'monthly_customer_capacity',
      'could_handle_more_capacity',
      'current_busy_level',
      'operational_slowdown_factors',
      'has_active_business_financing',
    ],
    'section_10_opportunity_readiness': [
      'external_selling_experience',
      'commitment_type_preference',
      'flex_production_capacity',
      'brand_partnership_willingness',
      'public_visibility_comfort',
      'available_weekly_time',
      'upfront_spending_tolerance',
      'risk_tolerance',
      'opportunity_nogo_filters',
      'ideal_partner_types',
      'win_definition_90_days',
      'growth_focus_stage',
      'stretch_opportunity_permission',
      'opportunity_surfacing_frequency',
    ],
    'section_11_strategic_goals': [
      'goals_12_month',
      'goals_3_year',
      'long_term_vision',
      'exit_strategy',
    ],
    'section_12_pricing_and_revenue': [
      'pricing_method',
      'typical_order_size',
      'discounts_and_promotions',
      'customer_payment_methods',
    ],
    'section_13_hiring_and_team_structure': [
      'team_roles',
      'planning_to_hire_12_months',
      'recruitment_channels',
      'uses_contractors_freelancers',
    ],
    'section_14_sales_and_marketing': [
      'sales_channels',
      'delivery_methods',
      'tracks_leads_crm',
      'lead_conversion_rate',
      'monthly_marketing_budget',
    ],
    'section_15_owner_goals_and_preferences': [
      'current_primary_focus',
      'day_to_day_involvement',
      'financial_risk_tolerance',
    ],
  };

  /// Clean section map by keeping only authorized whitelisted question keys
  static Map<String, dynamic> sanitizeSectionData(
    String sectionKey,
    Map<String, dynamic> data,
  ) {
    final validKeys = sectionValidKeys[sectionKey];
    if (validKeys == null) return Map<String, dynamic>.from(data);
    final cleanMap = <String, dynamic>{};
    for (final key in validKeys) {
      if (data.containsKey(key)) {
        cleanMap[key] = data[key];
      }
    }
    return cleanMap;
  }

  /// Get data for a specific section (1..15)
  Map<String, dynamic>? getSectionData(int sectionNumber) {
    final key = getSectionKey(sectionNumber);
    return _allSections[key] as Map<String, dynamic>?;
  }

  /// Update all sections from API response and filter out any extra/legacy keys
  void loadFromApiResponse(Map<String, dynamic> onboardingData) {
    for (var i = 1; i <= 15; i++) {
      final key = getSectionKey(i);
      if (onboardingData.containsKey(key) &&
          onboardingData[key] is Map<String, dynamic>) {
        final rawMap = Map<String, dynamic>.from(onboardingData[key] as Map);
        _allSections[key] = sanitizeSectionData(key, rawMap);
      }
    }
  }

  /// Update a specific section in local memory and optionally sync to backend
  void updateSectionData(int sectionNumber, Map<String, dynamic> updatedData) {
    final key = getSectionKey(sectionNumber);
    final merged = {
      ...(_allSections[key] as Map<String, dynamic>? ?? {}),
      ...updatedData,
    };
    _allSections[key] = sanitizeSectionData(key, merged);
  }

  /// Sync all 15 sections to POST https://api.lightsignal.app/business-profile/onboarding
  Future<bool> syncAllToApi() async {
    try {
      final token = await PrefUtils.getAccessToken();
      if (token == null || token.isEmpty) {
        debugPrint('[OnboardingRepo] No token available, skipping remote sync');
        return false;
      }

      // Ensure every section is sanitized before posting
      final sanitizedPayload = <String, dynamic>{};
      _allSections.forEach((k, v) {
        if (v is Map<String, dynamic>) {
          sanitizedPayload[k] = sanitizeSectionData(k, v);
        } else {
          sanitizedPayload[k] = v;
        }
      });

      final success = await ApiService().saveBusinessProfileOnboarding(
        onboardingData: sanitizedPayload,
        accessToken: token,
      );
      return success;
    } catch (e) {
      debugPrint('[OnboardingRepo] Error syncing onboarding data to API: $e');
      return false;
    }
  }

  /// Save single section and sync to API
  Future<bool> saveSectionAndSync(
    int sectionNumber,
    Map<String, dynamic> sectionAnswers,
  ) async {
    updateSectionData(sectionNumber, sectionAnswers);
    return await syncAllToApi();
  }

  /// Update locations in section 1 and sync to API
  Future<bool> updateLocations(List<Map<String, dynamic>> locations) async {
    final s1 = Map<String, dynamic>.from(getSectionData(1) ?? {});
    s1['locations'] = locations;
    updateSectionData(1, s1);
    return await syncAllToApi();
  }

  /// Default full 15 sections dataset matching Coastal Bites Food Truck
  static const Map<String, dynamic> defaultOnboardingPayload = {
    "section_01_business_basics": {
      "business_name": "Coastal Bites Food Truck",
      "headquarters": "Mobile, AL",
      "years_in_business": "3 to 5 years",
      "timezone": "America/Chicago",
      "currency": "USD",
      "legal_entity_type": "LLC",
      "ein": "12-3456789",
      "locations": [
        {
          "name": "Saturday farmers market",
          "address": "450 Dauphin St, Mobile, AL 36602",
          "role": "Seasonal / event",
          "status": "active"
        }
      ],
    },
    "section_02_ownership_and_key_people": {
      "ownership_breakdown": "Jane Doe (100%)",
      "decision_maker": "Jane Doe, Founder",
      "bookkeeper_financial_handler": "Gulf Coast CPAs (External)",
      "has_backup_operator": "Yes",
    },
    "section_03_industry_and_model": {
      "business_description":
          "Mobile artisanal food truck serving coastal seafood dishes.",
      "revenue_model_description":
          "Direct food sales at events, catering orders, and festival popups.",
      "target_market_type": "Both",
      "business_stage": "Growing and adding capacity",
    },
    "section_04_operations": {
      "team_size": "Small team of 4 to 10",
      "payroll_type": "Mostly employees with some contractors",
      "operating_hours": "Tue-Sun, 11:30am-9pm",
      "growth_limiters": ["Staff", "Equipment", "Time"],
      "single_supplier_dependency":
          "We have key suppliers but alternatives exist",
      "uses_pos_system": "Yes",
      "space_ownership_status": "Work from home or from a vehicle",
      "operational_software": [
        "Payroll software",
        "Booking or reservation system",
      ],
      "recent_supplier_issues": "No",
      "critical_materials_inputs":
          "Fresh seafood daily from local gulf distributors, kitchen propane.",
    },
    "section_05_financial_overview": {
      "accounting_system": "QuickBooks",
      "connect_accounting_now": "Yes",
      "fiscal_year_start": "January to December (all 12 months)",
      "banks_and_lenders": "First Local Bank",
      "business_loan_history": "Yes and currently paying it",
    },
    "section_06_assets_and_equipment": {
      "major_assets":
          "24ft Custom Commercial Food Truck, Commercial Fryers, Flat-top Grill",
      "asset_ownership_status": "Truck is leased, internal equipment is owned",
      "asset_purchase_dates":
          "Truck leased Jan 2023, equipment bought Mar 2023",
      "asset_condition":
          "Good working condition, regular maintenance performed",
      "leased_monthly_payment": "\$500 to \$2K",
    },
    "section_07_customers_and_market": {
      "customer_distance": "Within 10–15 miles",
      "strongest_seasons": ["Spring", "Summer", "Fall"],
      "customer_acquisition_channels": [
        "Word of mouth",
        "Social media",
        "Repeat regulars",
      ],
      "typical_customers_description":
          "Local foodies, downtown lunch workers, and weekend festival attendees.",
      "monthly_customer_volume": "1800",
      "repeat_business_rate": "High",
      "target_customer_types":
          "Corporate offices looking for weekly lunch catering.",
      "customer_concentration": "No, spread across many",
      "seasonality_level": "A little seasonal",
      "customer_geographic_source": "Within 10–15 miles",
      "opportunity_radius_miles": "25",
      "max_travel_distance_miles": "75",
      "local_opportunity_preference": "Open to nearby areas if high-value",
      "geographic_service_areas": "Mobile County and Baldwin County",
      "weather_impact": "High",
    },
    "section_08_risk_and_exposure": {
      "carries_business_insurance": "Yes",
      "critical_dependencies":
          "Local commissary kitchen for morning prep.",
      "revenue_concentration": "No, spread across many",
      "active_permits_licenses":
          "Mobile County Health Dept Permit, City Business License, ServSafe",
      "in_progress_permits_licenses": "Baldwin County temporary event permit",
      "local_operating_restrictions":
          "Designated food truck zones, noise ordinances after 10 PM",
    },
    "section_09_capacity_and_constraints": {
      "monthly_customer_capacity": "2500",
      "could_handle_more_capacity": "Yes, we had plenty of room",
      "current_busy_level": ["Around capacity"],
      "operational_slowdown_factors": ["Labor", "Equipment"],
      "has_active_business_financing": "Yes",
    },
    "section_10_opportunity_readiness": {
      "external_selling_experience": "Yes, regularly",
      "commitment_type_preference": "Recurring",
      "flex_production_capacity": "With some notice",
      "brand_partnership_willingness": "Yes",
      "public_visibility_comfort": "Very comfortable",
      "available_weekly_time": "A few hours a week",
      "upfront_spending_tolerance": "\$500 to \$2K",
      "risk_tolerance": "Moderate",
      "opportunity_nogo_filters":
          "Events with less than 200 expected attendees or >100 miles distance",
      "ideal_partner_types":
          "Local breweries, festival organizers, corporate campus managers",
      "win_definition_90_days":
          "Secure 2 recurring weekly brewery popup slots and 3 corporate catering gigs.",
      "growth_focus_stage": "Actively growing",
      "stretch_opportunity_permission": "Yes, show me those",
      "opportunity_surfacing_frequency": "Only strong matches",
    },
    "section_11_strategic_goals": {
      "goals_12_month":
          "Increase net margins to 20% and launch online pre-ordering for lunch pickups.",
      "goals_3_year":
          "Add a second food truck and expand into neighboring counties.",
      "long_term_vision":
          "Build a recognized regional mobile catering brand with a brick-and-mortar hub.",
      "exit_strategy":
          "Pass on to key operator or sell brand to hospitality group in 8-10 years.",
    },
    "section_12_pricing_and_revenue": {
      "pricing_method": ["Per unit", "Per job"],
      "typical_order_size": "\$22 retail / \$750 catering",
      "discounts_and_promotions":
          "10% discount on recurring corporate weekly bookings.",
      "customer_payment_methods": ["Upfront", "On delivery"],
    },
    "section_13_hiring_and_team_structure": {
      "team_roles": "Head Cook, Prep Cook, Cashier/Server, Driver",
      "planning_to_hire_12_months": "Yes",
      "recruitment_channels": ["Referrals", "Social media"],
      "uses_contractors_freelancers": "Sometimes",
    },
    "section_14_sales_and_marketing": {
      "sales_channels": ["Word of mouth", "Social media", "Events"],
      "delivery_methods": ["In-person", "Online", "Delivery"],
      "tracks_leads_crm": "Spreadsheet",
      "lead_conversion_rate": "35%",
      "monthly_marketing_budget": "600",
    },
    "section_15_owner_goals_and_preferences": {
      "current_primary_focus": ["Profit", "Growth"],
      "day_to_day_involvement": "Very involved",
      "financial_risk_tolerance": "Moderate",
    },
  };
}
