/// Complete model for the Business Profile Onboarding API response
/// from GET https://api.lightsignal.app/business-profile/onboarding
class BusinessProfileOnboardingResponse {
  final bool success;
  final bool hasExistingData;
  final BusinessProfileOnboardingData data;

  const BusinessProfileOnboardingResponse({
    required this.success,
    required this.hasExistingData,
    required this.data,
  });

  factory BusinessProfileOnboardingResponse.fromJson(Map<String, dynamic> json) {
    return BusinessProfileOnboardingResponse(
      success: json['success'] as bool? ?? true,
      hasExistingData: json['has_existing_data'] as bool? ?? false,
      data: BusinessProfileOnboardingData.fromJson(
        (json['data'] as Map<String, dynamic>?) ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'has_existing_data': hasExistingData,
        'data': data.toJson(),
      };
}

class BusinessProfileOnboardingData {
  final String userId;
  final String businessName;
  final String legalEntityType;
  final int yearsInBusiness;
  final String timezone;
  final String currency;
  final List<OnboardingLocation> locations;
  final List<String> ownerNames;
  final String ownershipStructure;
  final bool isWomanOwned;
  final bool isVeteranOwned;
  final bool isMinorityOwned;
  final String ownerBackground;
  final String businessDescriptionRaw;
  final String industryType;
  final String naicsCode;
  final List<String> businessKeywords;
  final List<String> subIndustryTags;
  final String growthStage;
  final String posSystem;
  final List<String> techStack;
  final String leaseEndDate;
  final List<OwnerObservation> ownerObservations;
  final List<String> businessClassifications;
  final Map<String, dynamic> rawOnboardingData;

  // Typed sections for all 15 sections
  final Section01BusinessBasics section01;
  final Section02OwnershipAndKeyPeople section02;
  final Section03IndustryAndModel section03;
  final Section04Operations section04;
  final Section05FinancialOverview section05;
  final Section06AssetsAndEquipment section06;
  final Section07CustomersAndMarket section07;
  final Section08RiskAndExposure section08;
  final Section09CapacityAndConstraints section09;
  final Section10OpportunityReadiness section10;
  final Section11StrategicGoals section11;
  final Section12PricingAndRevenue section12;
  final Section13HiringAndTeamStructure section13;
  final Section14SalesAndMarketing section14;
  final Section15OwnerGoalsAndPreferences section15;

  const BusinessProfileOnboardingData({
    required this.userId,
    required this.businessName,
    required this.legalEntityType,
    required this.yearsInBusiness,
    required this.timezone,
    required this.currency,
    required this.locations,
    required this.ownerNames,
    required this.ownershipStructure,
    required this.isWomanOwned,
    required this.isVeteranOwned,
    required this.isMinorityOwned,
    required this.ownerBackground,
    required this.businessDescriptionRaw,
    required this.industryType,
    required this.naicsCode,
    required this.businessKeywords,
    required this.subIndustryTags,
    required this.growthStage,
    required this.posSystem,
    required this.techStack,
    required this.leaseEndDate,
    required this.ownerObservations,
    required this.businessClassifications,
    required this.rawOnboardingData,
    this.section01 = const Section01BusinessBasics(),
    this.section02 = const Section02OwnershipAndKeyPeople(),
    this.section03 = const Section03IndustryAndModel(),
    this.section04 = const Section04Operations(),
    this.section05 = const Section05FinancialOverview(),
    this.section06 = const Section06AssetsAndEquipment(),
    this.section07 = const Section07CustomersAndMarket(),
    this.section08 = const Section08RiskAndExposure(),
    this.section09 = const Section09CapacityAndConstraints(),
    this.section10 = const Section10OpportunityReadiness(),
    this.section11 = const Section11StrategicGoals(),
    this.section12 = const Section12PricingAndRevenue(),
    this.section13 = const Section13HiringAndTeamStructure(),
    this.section14 = const Section14SalesAndMarketing(),
    this.section15 = const Section15OwnerGoalsAndPreferences(),
  });

  factory BusinessProfileOnboardingData.fromJson(Map<String, dynamic> json) {
    final onboardingMap =
        (json['onboarding_data'] as Map<String, dynamic>?) ?? {};

    final s1Map = (onboardingMap['section_01_business_basics'] as Map<String, dynamic>?) ?? {};
    final s2Map = (onboardingMap['section_02_ownership_and_key_people'] as Map<String, dynamic>?) ?? {};
    final s3Map = (onboardingMap['section_03_industry_and_model'] as Map<String, dynamic>?) ?? {};
    final s4Map = (onboardingMap['section_04_operations'] as Map<String, dynamic>?) ?? {};
    final s5Map = (onboardingMap['section_05_financial_overview'] as Map<String, dynamic>?) ?? {};
    final s6Map = (onboardingMap['section_06_assets_and_equipment'] as Map<String, dynamic>?) ?? {};
    final s7Map = (onboardingMap['section_07_customers_and_market'] as Map<String, dynamic>?) ?? {};
    final s8Map = (onboardingMap['section_08_risk_and_exposure'] as Map<String, dynamic>?) ?? {};
    final s9Map = (onboardingMap['section_09_capacity_and_constraints'] as Map<String, dynamic>?) ?? {};
    final s10Map = (onboardingMap['section_10_opportunity_readiness'] as Map<String, dynamic>?) ?? {};
    final s11Map = (onboardingMap['section_11_strategic_goals'] as Map<String, dynamic>?) ?? {};
    final s12Map = (onboardingMap['section_12_pricing_and_revenue'] as Map<String, dynamic>?) ?? {};
    final s13Map = (onboardingMap['section_13_hiring_and_team_structure'] as Map<String, dynamic>?) ?? {};
    final s14Map = (onboardingMap['section_14_sales_and_marketing'] as Map<String, dynamic>?) ?? {};
    final s15Map = (onboardingMap['section_15_owner_goals_and_preferences'] as Map<String, dynamic>?) ?? {};

    final s1 = Section01BusinessBasics.fromJson(s1Map);
    final s2 = Section02OwnershipAndKeyPeople.fromJson(s2Map);
    final s3 = Section03IndustryAndModel.fromJson(s3Map);
    final s4 = Section04Operations.fromJson(s4Map);
    final s5 = Section05FinancialOverview.fromJson(s5Map);
    final s6 = Section06AssetsAndEquipment.fromJson(s6Map);
    final s7 = Section07CustomersAndMarket.fromJson(s7Map);
    final s8 = Section08RiskAndExposure.fromJson(s8Map);
    final s9 = Section09CapacityAndConstraints.fromJson(s9Map);
    final s10 = Section10OpportunityReadiness.fromJson(s10Map);
    final s11 = Section11StrategicGoals.fromJson(s11Map);
    final s12 = Section12PricingAndRevenue.fromJson(s12Map);
    final s13 = Section13HiringAndTeamStructure.fromJson(s13Map);
    final s14 = Section14SalesAndMarketing.fromJson(s14Map);
    final s15 = Section15OwnerGoalsAndPreferences.fromJson(s15Map);

    // Helper to safely parse string list
    List<String> parseStringList(dynamic list) {
      if (list is List) {
        return list.map((e) => e.toString()).toList();
      }
      return [];
    }

    // Locations parsing: check section_01 first, then root json, then headquarters string
    final locList = <OnboardingLocation>[];
    final rawLocations = s1Map['locations'] ?? json['locations'];
    if (rawLocations is List) {
      for (final item in rawLocations) {
        if (item is Map<String, dynamic>) {
          locList.add(OnboardingLocation.fromJson(item));
        }
      }
    } else if (s1.headquarters.isNotEmpty) {
      locList.add(
        OnboardingLocation.fromJson({
          'name': s1.businessName.isNotEmpty ? s1.businessName : 'Headquarters',
          'address': s1.headquarters,
          'role': 'headquarters',
        }),
      );
    }

    // Owner observations parsing: check section_01 first, then root json
    final obsList = <OwnerObservation>[];
    final rawObservations = s1Map['owner_observations'] ?? json['owner_observations'];
    if (rawObservations is List) {
      for (final item in rawObservations) {
        if (item is Map<String, dynamic>) {
          obsList.add(OwnerObservation.fromJson(item));
        }
      }
    }

    final rawYears = s1Map['years_in_business'] ?? json['years_in_business'];
    final parsedYears = (rawYears is num)
        ? rawYears.toInt()
        : (int.tryParse(rawYears?.toString() ?? '') ?? 4);

    final ownerBreakdown = s2.ownershipBreakdown;
    final parsedOwnerNames = parseStringList(s2Map['owner_names'] ?? json['owner_names']);

    return BusinessProfileOnboardingData(
      userId: json['user_id'] as String? ?? '',
      businessName: s1.businessName.isNotEmpty
          ? s1.businessName
          : json['business_name'] as String? ??
              json['company_name'] as String? ??
              'Coastal Bites Food Truck',
      legalEntityType: s1.legalEntityType.isNotEmpty
          ? s1.legalEntityType
          : json['legal_entity_type'] as String? ?? 'LLC',
      yearsInBusiness: parsedYears,
      timezone: s1.timezone.isNotEmpty
          ? s1.timezone
          : json['timezone'] as String? ?? 'America/Chicago',
      currency: s1.currency.isNotEmpty
          ? s1.currency
          : json['currency'] as String? ?? 'USD',
      locations: locList.isNotEmpty ? locList : [OnboardingLocation.defaultLocation],
      ownerNames: parsedOwnerNames.isNotEmpty
          ? parsedOwnerNames
          : (ownerBreakdown.isNotEmpty
              ? [ownerBreakdown.split('(').first.trim()]
              : ['Jane Doe']),
      ownershipStructure: s2.ownershipBreakdown.isNotEmpty
          ? s2.ownershipBreakdown
          : json['ownership_structure'] as String? ?? 'Sole Member LLC',
      isWomanOwned: s2Map['is_woman_owned'] as bool? ??
          json['is_woman_owned'] as bool? ??
          true,
      isVeteranOwned: s2Map['is_veteran_owned'] as bool? ??
          json['is_veteran_owned'] as bool? ??
          false,
      isMinorityOwned: s2Map['is_minority_owned'] as bool? ??
          json['is_minority_owned'] as bool? ??
          false,
      ownerBackground: s2.decisionMaker.isNotEmpty
          ? s2.decisionMaker
          : json['owner_background'] as String? ??
              '10 years in culinary & food service operations',
      businessDescriptionRaw: s3.businessDescription.isNotEmpty
          ? s3.businessDescription
          : json['business_description_raw'] as String? ??
              'Mobile food truck offering artisanal seafood and coastal cuisine.',
      industryType: s3Map['industry_type'] as String? ??
          json['industry_type'] as String? ??
          'Food & Beverage',
      naicsCode: s3Map['naics_code'] as String? ??
          json['naics_code'] as String? ??
          '722330',
      businessKeywords: parseStringList(s3Map['business_keywords'] ?? json['business_keywords']).isNotEmpty
          ? parseStringList(s3Map['business_keywords'] ?? json['business_keywords'])
          : ['food truck', 'seafood', 'catering'],
      subIndustryTags: parseStringList(s3Map['sub_industry_tags'] ?? json['sub_industry_tags']).isNotEmpty
          ? parseStringList(s3Map['sub_industry_tags'] ?? json['sub_industry_tags'])
          : ['Mobile Catering', 'Seafood Grill'],
      growthStage: s3.businessStage.isNotEmpty
          ? s3.businessStage
          : json['growth_stage'] as String? ?? 'scaling',
      posSystem: s4.usesPosSystem.isNotEmpty
          ? s4.usesPosSystem
          : json['pos_system'] as String? ?? 'Toast',
      techStack: parseStringList(s4.operationalSoftware.isNotEmpty ? s4.operationalSoftware : json['tech_stack']).isNotEmpty
          ? parseStringList(s4.operationalSoftware.isNotEmpty ? s4.operationalSoftware : json['tech_stack'])
          : ['Toast POS', 'QuickBooks Online', 'Instagram'],
      leaseEndDate: s4Map['lease_end_date'] as String? ??
          json['lease_end_date'] as String? ??
          '2027-12-31',
      ownerObservations: obsList.isNotEmpty
          ? obsList
          : [const OwnerObservation(text: 'Slow weeks blindside me')],
      businessClassifications:
          parseStringList(json['business_classifications']).isNotEmpty
              ? parseStringList(json['business_classifications'])
              : ['service_business'],
      rawOnboardingData: onboardingMap,
      section01: s1,
      section02: s2,
      section03: s3,
      section04: s4,
      section05: s5,
      section06: s6,
      section07: s7,
      section08: s8,
      section09: s9,
      section10: s10,
      section11: s11,
      section12: s12,
      section13: s13,
      section14: s14,
      section15: s15,
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'business_name': businessName,
        'legal_entity_type': legalEntityType,
        'years_in_business': yearsInBusiness,
        'timezone': timezone,
        'currency': currency,
        'locations': locations.map((e) => e.toJson()).toList(),
        'owner_names': ownerNames,
        'ownership_structure': ownershipStructure,
        'is_woman_owned': isWomanOwned,
        'is_veteran_owned': isVeteranOwned,
        'is_minority_owned': isMinorityOwned,
        'owner_background': ownerBackground,
        'business_description_raw': businessDescriptionRaw,
        'industry_type': industryType,
        'naics_code': naicsCode,
        'business_keywords': businessKeywords,
        'sub_industry_tags': subIndustryTags,
        'growth_stage': growthStage,
        'pos_system': posSystem,
        'tech_stack': techStack,
        'lease_end_date': leaseEndDate,
        'owner_observations':
            ownerObservations.map((e) => e.toJson()).toList(),
        'business_classifications': businessClassifications,
        'onboarding_data': rawOnboardingData,
      };

  static const BusinessProfileOnboardingData fallbackData =
      BusinessProfileOnboardingData(
    userId: '0efa55c2-0c81-442c-8e14-706bedc28a46',
    businessName: 'Coastal Bites Food Truck',
    legalEntityType: 'LLC',
    yearsInBusiness: 4,
    timezone: 'America/Chicago',
    currency: 'USD',
    locations: [OnboardingLocation.defaultLocation],
    ownerNames: ['Jane Doe'],
    ownershipStructure: 'Sole Member LLC',
    isWomanOwned: true,
    isVeteranOwned: false,
    isMinorityOwned: false,
    ownerBackground: '10 years in culinary & food service operations',
    businessDescriptionRaw:
        'Mobile food truck offering artisanal seafood and coastal cuisine.',
    industryType: 'Food & Beverage',
    naicsCode: '722330',
    businessKeywords: ['food truck', 'seafood', 'catering'],
    subIndustryTags: ['Mobile Catering', 'Seafood Grill'],
    growthStage: 'scaling',
    posSystem: 'Toast',
    techStack: ['Toast POS', 'QuickBooks Online', 'Instagram'],
    leaseEndDate: '2027-12-31',
    ownerObservations: [
      OwnerObservation(text: 'Slow weeks blindside me'),
    ],
    businessClassifications: ['service_business'],
    rawOnboardingData: {},
  );
}

// -------------------------------------------------------------
// 15 Structured Section Models
// -------------------------------------------------------------

class Section01BusinessBasics {
  final String businessName;
  final String headquarters;
  final String yearsInBusiness;
  final String timezone;
  final String currency;
  final String legalEntityType;
  final String ein;
  final List<OnboardingLocation> locations;

  const Section01BusinessBasics({
    this.businessName = '',
    this.headquarters = '',
    this.yearsInBusiness = '',
    this.timezone = '',
    this.currency = '',
    this.legalEntityType = '',
    this.ein = '',
    this.locations = const [],
  });

  factory Section01BusinessBasics.fromJson(Map<String, dynamic> json) {
    final locList = <OnboardingLocation>[];
    if (json['locations'] is List) {
      for (final item in json['locations']) {
        if (item is Map<String, dynamic>) {
          locList.add(OnboardingLocation.fromJson(item));
        }
      }
    }
    return Section01BusinessBasics(
      businessName: json['business_name']?.toString() ?? '',
      headquarters: json['headquarters']?.toString() ?? '',
      yearsInBusiness: json['years_in_business']?.toString() ?? '',
      timezone: json['timezone']?.toString() ?? '',
      currency: json['currency']?.toString() ?? '',
      legalEntityType: json['legal_entity_type']?.toString() ?? '',
      ein: json['ein']?.toString() ?? '',
      locations: locList,
    );
  }

  Map<String, dynamic> toJson() => {
    'business_name': businessName,
    'headquarters': headquarters,
    'years_in_business': yearsInBusiness,
    'timezone': timezone,
    'currency': currency,
    'legal_entity_type': legalEntityType,
    'ein': ein,
    'locations': locations.map((e) => e.toJson()).toList(),
  };
}

class Section02OwnershipAndKeyPeople {
  final String ownershipBreakdown;
  final String decisionMaker;
  final String bookkeeperFinancialHandler;
  final String hasBackupOperator;

  const Section02OwnershipAndKeyPeople({
    this.ownershipBreakdown = '',
    this.decisionMaker = '',
    this.bookkeeperFinancialHandler = '',
    this.hasBackupOperator = '',
  });

  factory Section02OwnershipAndKeyPeople.fromJson(Map<String, dynamic> json) {
    return Section02OwnershipAndKeyPeople(
      ownershipBreakdown: json['ownership_breakdown']?.toString() ?? '',
      decisionMaker: json['decision_maker']?.toString() ?? '',
      bookkeeperFinancialHandler: json['bookkeeper_financial_handler']?.toString() ?? '',
      hasBackupOperator: json['has_backup_operator']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'ownership_breakdown': ownershipBreakdown,
    'decision_maker': decisionMaker,
    'bookkeeper_financial_handler': bookkeeperFinancialHandler,
    'has_backup_operator': hasBackupOperator,
  };
}

class Section03IndustryAndModel {
  final String businessDescription;
  final String revenueModelDescription;
  final String targetMarketType;
  final String businessStage;

  const Section03IndustryAndModel({
    this.businessDescription = '',
    this.revenueModelDescription = '',
    this.targetMarketType = '',
    this.businessStage = '',
  });

  factory Section03IndustryAndModel.fromJson(Map<String, dynamic> json) {
    return Section03IndustryAndModel(
      businessDescription: json['business_description']?.toString() ?? '',
      revenueModelDescription: json['revenue_model_description']?.toString() ?? '',
      targetMarketType: json['target_market_type']?.toString() ?? '',
      businessStage: json['business_stage']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'business_description': businessDescription,
    'revenue_model_description': revenueModelDescription,
    'target_market_type': targetMarketType,
    'business_stage': businessStage,
  };
}

class Section04Operations {
  final String teamSize;
  final String payrollType;
  final String operatingHours;
  final dynamic growthLimiters;
  final String singleSupplierDependency;
  final String usesPosSystem;
  final String spaceOwnershipStatus;
  final dynamic operationalSoftware;
  final String recentSupplierIssues;
  final String criticalMaterialsInputs;

  const Section04Operations({
    this.teamSize = '',
    this.payrollType = '',
    this.operatingHours = '',
    this.growthLimiters = '',
    this.singleSupplierDependency = '',
    this.usesPosSystem = '',
    this.spaceOwnershipStatus = '',
    this.operationalSoftware = '',
    this.recentSupplierIssues = '',
    this.criticalMaterialsInputs = '',
  });

  factory Section04Operations.fromJson(Map<String, dynamic> json) {
    return Section04Operations(
      teamSize: json['team_size']?.toString() ?? '',
      payrollType: json['payroll_type']?.toString() ?? '',
      operatingHours: json['operating_hours']?.toString() ?? '',
      growthLimiters: json['growth_limiters'],
      singleSupplierDependency: json['single_supplier_dependency']?.toString() ?? '',
      usesPosSystem: json['uses_pos_system']?.toString() ?? '',
      spaceOwnershipStatus: json['space_ownership_status']?.toString() ?? '',
      operationalSoftware: json['operational_software'],
      recentSupplierIssues: json['recent_supplier_issues']?.toString() ?? '',
      criticalMaterialsInputs: json['critical_materials_inputs']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'team_size': teamSize,
    'payroll_type': payrollType,
    'operating_hours': operatingHours,
    'growth_limiters': growthLimiters,
    'single_supplier_dependency': singleSupplierDependency,
    'uses_pos_system': usesPosSystem,
    'space_ownership_status': spaceOwnershipStatus,
    'operational_software': operationalSoftware,
    'recent_supplier_issues': recentSupplierIssues,
    'critical_materials_inputs': criticalMaterialsInputs,
  };
}

class Section05FinancialOverview {
  final String accountingSystem;
  final String connectAccountingNow;
  final String fiscalYearStart;
  final String banksAndLenders;
  final String businessLoanHistory;

  const Section05FinancialOverview({
    this.accountingSystem = '',
    this.connectAccountingNow = '',
    this.fiscalYearStart = '',
    this.banksAndLenders = '',
    this.businessLoanHistory = '',
  });

  factory Section05FinancialOverview.fromJson(Map<String, dynamic> json) {
    return Section05FinancialOverview(
      accountingSystem: json['accounting_system']?.toString() ?? '',
      connectAccountingNow: json['connect_accounting_now']?.toString() ?? '',
      fiscalYearStart: json['fiscal_year_start']?.toString() ?? '',
      banksAndLenders: json['banks_and_lenders']?.toString() ?? '',
      businessLoanHistory: json['business_loan_history']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'accounting_system': accountingSystem,
    'connect_accounting_now': connectAccountingNow,
    'fiscal_year_start': fiscalYearStart,
    'banks_and_lenders': banksAndLenders,
    'business_loan_history': businessLoanHistory,
  };
}

class Section06AssetsAndEquipment {
  final String majorAssets;
  final String assetOwnershipStatus;
  final String assetPurchaseDates;
  final String assetCondition;
  final String leasedMonthlyPayment;

  const Section06AssetsAndEquipment({
    this.majorAssets = '',
    this.assetOwnershipStatus = '',
    this.assetPurchaseDates = '',
    this.assetCondition = '',
    this.leasedMonthlyPayment = '',
  });

  factory Section06AssetsAndEquipment.fromJson(Map<String, dynamic> json) {
    return Section06AssetsAndEquipment(
      majorAssets: json['major_assets']?.toString() ?? '',
      assetOwnershipStatus: json['asset_ownership_status']?.toString() ?? '',
      assetPurchaseDates: json['asset_purchase_dates']?.toString() ?? '',
      assetCondition: json['asset_condition']?.toString() ?? '',
      leasedMonthlyPayment: json['leased_monthly_payment']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'major_assets': majorAssets,
    'asset_ownership_status': assetOwnershipStatus,
    'asset_purchase_dates': assetPurchaseDates,
    'asset_condition': assetCondition,
    'leased_monthly_payment': leasedMonthlyPayment,
  };
}

class Section07CustomersAndMarket {
  final String customerDistance;
  final dynamic strongestSeasons;
  final String customerAcquisitionChannels;
  final String typicalCustomersDescription;
  final String monthlyCustomerVolume;
  final String repeatBusinessRate;
  final String targetCustomerTypes;
  final String customerConcentration;
  final String seasonalityLevel;
  final String customerGeographicSource;
  final String opportunityRadiusMiles;
  final String maxTravelDistanceMiles;
  final String localOpportunityPreference;
  final String geographicServiceAreas;
  final String weatherImpact;

  const Section07CustomersAndMarket({
    this.customerDistance = '',
    this.strongestSeasons = '',
    this.customerAcquisitionChannels = '',
    this.typicalCustomersDescription = '',
    this.monthlyCustomerVolume = '',
    this.repeatBusinessRate = '',
    this.targetCustomerTypes = '',
    this.customerConcentration = '',
    this.seasonalityLevel = '',
    this.customerGeographicSource = '',
    this.opportunityRadiusMiles = '',
    this.maxTravelDistanceMiles = '',
    this.localOpportunityPreference = '',
    this.geographicServiceAreas = '',
    this.weatherImpact = '',
  });

  factory Section07CustomersAndMarket.fromJson(Map<String, dynamic> json) {
    return Section07CustomersAndMarket(
      customerDistance: json['customer_distance']?.toString() ?? '',
      strongestSeasons: json['strongest_seasons'],
      customerAcquisitionChannels: json['customer_acquisition_channels']?.toString() ?? '',
      typicalCustomersDescription: json['typical_customers_description']?.toString() ?? '',
      monthlyCustomerVolume: json['monthly_customer_volume']?.toString() ?? '',
      repeatBusinessRate: json['repeat_business_rate']?.toString() ?? '',
      targetCustomerTypes: json['target_customer_types']?.toString() ?? '',
      customerConcentration: json['customer_concentration']?.toString() ?? '',
      seasonalityLevel: json['seasonality_level']?.toString() ?? '',
      customerGeographicSource: json['customer_geographic_source']?.toString() ?? '',
      opportunityRadiusMiles: json['opportunity_radius_miles']?.toString() ?? '',
      maxTravelDistanceMiles: json['max_travel_distance_miles']?.toString() ?? '',
      localOpportunityPreference: json['local_opportunity_preference']?.toString() ?? '',
      geographicServiceAreas: json['geographic_service_areas']?.toString() ?? '',
      weatherImpact: json['weather_impact']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'customer_distance': customerDistance,
    'strongest_seasons': strongestSeasons,
    'customer_acquisition_channels': customerAcquisitionChannels,
    'typical_customers_description': typicalCustomersDescription,
    'monthly_customer_volume': monthlyCustomerVolume,
    'repeat_business_rate': repeatBusinessRate,
    'target_customer_types': targetCustomerTypes,
    'customer_concentration': customerConcentration,
    'seasonality_level': seasonalityLevel,
    'customer_geographic_source': customerGeographicSource,
    'opportunity_radius_miles': opportunityRadiusMiles,
    'max_travel_distance_miles': maxTravelDistanceMiles,
    'local_opportunity_preference': localOpportunityPreference,
    'geographic_service_areas': geographicServiceAreas,
    'weather_impact': weatherImpact,
  };
}

class Section08RiskAndExposure {
  final String carriesBusinessInsurance;
  final String criticalDependencies;
  final String revenueConcentration;
  final String activePermitsLicenses;
  final String inProgressPermitsLicenses;
  final String localOperatingRestrictions;

  const Section08RiskAndExposure({
    this.carriesBusinessInsurance = '',
    this.criticalDependencies = '',
    this.revenueConcentration = '',
    this.activePermitsLicenses = '',
    this.inProgressPermitsLicenses = '',
    this.localOperatingRestrictions = '',
  });

  factory Section08RiskAndExposure.fromJson(Map<String, dynamic> json) {
    return Section08RiskAndExposure(
      carriesBusinessInsurance: json['carries_business_insurance']?.toString() ?? '',
      criticalDependencies: json['critical_dependencies']?.toString() ?? '',
      revenueConcentration: json['revenue_concentration']?.toString() ?? '',
      activePermitsLicenses: json['active_permits_licenses']?.toString() ?? '',
      inProgressPermitsLicenses: json['in_progress_permits_licenses']?.toString() ?? '',
      localOperatingRestrictions: json['local_operating_restrictions']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'carries_business_insurance': carriesBusinessInsurance,
    'critical_dependencies': criticalDependencies,
    'revenue_concentration': revenueConcentration,
    'active_permits_licenses': activePermitsLicenses,
    'in_progress_permits_licenses': inProgressPermitsLicenses,
    'local_operating_restrictions': localOperatingRestrictions,
  };
}

class Section09CapacityAndConstraints {
  final String monthlyCustomerCapacity;
  final String couldHandleMoreCapacity;
  final String currentBusyLevel;
  final dynamic operationalSlowdownFactors;
  final String hasActiveBusinessFinancing;

  const Section09CapacityAndConstraints({
    this.monthlyCustomerCapacity = '',
    this.couldHandleMoreCapacity = '',
    this.currentBusyLevel = '',
    this.operationalSlowdownFactors = '',
    this.hasActiveBusinessFinancing = '',
  });

  factory Section09CapacityAndConstraints.fromJson(Map<String, dynamic> json) {
    return Section09CapacityAndConstraints(
      monthlyCustomerCapacity: json['monthly_customer_capacity']?.toString() ?? '',
      couldHandleMoreCapacity: json['could_handle_more_capacity']?.toString() ?? '',
      currentBusyLevel: json['current_busy_level']?.toString() ?? '',
      operationalSlowdownFactors: json['operational_slowdown_factors'],
      hasActiveBusinessFinancing: json['has_active_business_financing']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'monthly_customer_capacity': monthlyCustomerCapacity,
    'could_handle_more_capacity': couldHandleMoreCapacity,
    'current_busy_level': currentBusyLevel,
    'operational_slowdown_factors': operationalSlowdownFactors,
    'has_active_business_financing': hasActiveBusinessFinancing,
  };
}

class Section10OpportunityReadiness {
  final String externalSellingExperience;
  final String commitmentTypePreference;
  final String flexProductionCapacity;
  final String brandPartnershipWillingness;
  final String publicVisibilityComfort;
  final String availableWeeklyTime;
  final String upfrontSpendingTolerance;
  final String riskTolerance;
  final String opportunityNogoFilters;
  final String idealPartnerTypes;
  final String winDefinition90Days;
  final String growthFocusStage;
  final String stretchOpportunityPermission;
  final String opportunitySurfacingFrequency;

  const Section10OpportunityReadiness({
    this.externalSellingExperience = '',
    this.commitmentTypePreference = '',
    this.flexProductionCapacity = '',
    this.brandPartnershipWillingness = '',
    this.publicVisibilityComfort = '',
    this.availableWeeklyTime = '',
    this.upfrontSpendingTolerance = '',
    this.riskTolerance = '',
    this.opportunityNogoFilters = '',
    this.idealPartnerTypes = '',
    this.winDefinition90Days = '',
    this.growthFocusStage = '',
    this.stretchOpportunityPermission = '',
    this.opportunitySurfacingFrequency = '',
  });

  factory Section10OpportunityReadiness.fromJson(Map<String, dynamic> json) {
    return Section10OpportunityReadiness(
      externalSellingExperience: json['external_selling_experience']?.toString() ?? '',
      commitmentTypePreference: json['commitment_type_preference']?.toString() ?? '',
      flexProductionCapacity: json['flex_production_capacity']?.toString() ?? '',
      brandPartnershipWillingness: json['brand_partnership_willingness']?.toString() ?? '',
      publicVisibilityComfort: json['public_visibility_comfort']?.toString() ?? '',
      availableWeeklyTime: json['available_weekly_time']?.toString() ?? '',
      upfrontSpendingTolerance: json['upfront_spending_tolerance']?.toString() ?? '',
      riskTolerance: json['risk_tolerance']?.toString() ?? '',
      opportunityNogoFilters: json['opportunity_nogo_filters']?.toString() ?? '',
      idealPartnerTypes: json['ideal_partner_types']?.toString() ?? '',
      winDefinition90Days: json['win_definition_90_days']?.toString() ?? '',
      growthFocusStage: json['growth_focus_stage']?.toString() ?? '',
      stretchOpportunityPermission: json['stretch_opportunity_permission']?.toString() ?? '',
      opportunitySurfacingFrequency: json['opportunity_surfacing_frequency']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'external_selling_experience': externalSellingExperience,
    'commitment_type_preference': commitmentTypePreference,
    'flex_production_capacity': flexProductionCapacity,
    'brand_partnership_willingness': brandPartnershipWillingness,
    'public_visibility_comfort': publicVisibilityComfort,
    'available_weekly_time': availableWeeklyTime,
    'upfront_spending_tolerance': upfrontSpendingTolerance,
    'risk_tolerance': riskTolerance,
    'opportunity_nogo_filters': opportunityNogoFilters,
    'ideal_partner_types': idealPartnerTypes,
    'win_definition_90_days': winDefinition90Days,
    'growth_focus_stage': growthFocusStage,
    'stretch_opportunity_permission': stretchOpportunityPermission,
    'opportunity_surfacing_frequency': opportunitySurfacingFrequency,
  };
}

class Section11StrategicGoals {
  final String goals12Month;
  final String goals3Year;
  final String longTermVision;
  final String exitStrategy;

  const Section11StrategicGoals({
    this.goals12Month = '',
    this.goals3Year = '',
    this.longTermVision = '',
    this.exitStrategy = '',
  });

  factory Section11StrategicGoals.fromJson(Map<String, dynamic> json) {
    return Section11StrategicGoals(
      goals12Month: json['goals_12_month']?.toString() ?? '',
      goals3Year: json['goals_3_year']?.toString() ?? '',
      longTermVision: json['long_term_vision']?.toString() ?? '',
      exitStrategy: json['exit_strategy']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'goals_12_month': goals12Month,
    'goals_3_year': goals3Year,
    'long_term_vision': longTermVision,
    'exit_strategy': exitStrategy,
  };
}

class Section12PricingAndRevenue {
  final String pricingMethod;
  final String typicalOrderSize;
  final String discountsAndPromotions;
  final String customerPaymentMethods;

  const Section12PricingAndRevenue({
    this.pricingMethod = '',
    this.typicalOrderSize = '',
    this.discountsAndPromotions = '',
    this.customerPaymentMethods = '',
  });

  factory Section12PricingAndRevenue.fromJson(Map<String, dynamic> json) {
    return Section12PricingAndRevenue(
      pricingMethod: json['pricing_method']?.toString() ?? '',
      typicalOrderSize: json['typical_order_size']?.toString() ?? '',
      discountsAndPromotions: json['discounts_and_promotions']?.toString() ?? '',
      customerPaymentMethods: json['customer_payment_methods']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'pricing_method': pricingMethod,
    'typical_order_size': typicalOrderSize,
    'discounts_and_promotions': discountsAndPromotions,
    'customer_payment_methods': customerPaymentMethods,
  };
}

class Section13HiringAndTeamStructure {
  final String teamRoles;
  final String planningToHire12Months;
  final String recruitmentChannels;
  final String usesContractorsFreelancers;

  const Section13HiringAndTeamStructure({
    this.teamRoles = '',
    this.planningToHire12Months = '',
    this.recruitmentChannels = '',
    this.usesContractorsFreelancers = '',
  });

  factory Section13HiringAndTeamStructure.fromJson(Map<String, dynamic> json) {
    return Section13HiringAndTeamStructure(
      teamRoles: json['team_roles']?.toString() ?? '',
      planningToHire12Months: json['planning_to_hire_12_months']?.toString() ?? '',
      recruitmentChannels: json['recruitment_channels']?.toString() ?? '',
      usesContractorsFreelancers: json['uses_contractors_freelancers']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'team_roles': teamRoles,
    'planning_to_hire_12_months': planningToHire12Months,
    'recruitment_channels': recruitmentChannels,
    'uses_contractors_freelancers': usesContractorsFreelancers,
  };
}

class Section14SalesAndMarketing {
  final String salesChannels;
  final String deliveryMethods;
  final String tracksLeadsCrm;
  final String leadConversionRate;
  final String monthlyMarketingBudget;

  const Section14SalesAndMarketing({
    this.salesChannels = '',
    this.deliveryMethods = '',
    this.tracksLeadsCrm = '',
    this.leadConversionRate = '',
    this.monthlyMarketingBudget = '',
  });

  factory Section14SalesAndMarketing.fromJson(Map<String, dynamic> json) {
    return Section14SalesAndMarketing(
      salesChannels: json['sales_channels']?.toString() ?? '',
      deliveryMethods: json['delivery_methods']?.toString() ?? '',
      tracksLeadsCrm: json['tracks_leads_crm']?.toString() ?? '',
      leadConversionRate: json['lead_conversion_rate']?.toString() ?? '',
      monthlyMarketingBudget: json['monthly_marketing_budget']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'sales_channels': salesChannels,
    'delivery_methods': deliveryMethods,
    'tracks_leads_crm': tracksLeadsCrm,
    'lead_conversion_rate': leadConversionRate,
    'monthly_marketing_budget': monthlyMarketingBudget,
  };
}

class Section15OwnerGoalsAndPreferences {
  final String currentPrimaryFocus;
  final String dayToDayInvolvement;
  final String financialRiskTolerance;

  const Section15OwnerGoalsAndPreferences({
    this.currentPrimaryFocus = '',
    this.dayToDayInvolvement = '',
    this.financialRiskTolerance = '',
  });

  factory Section15OwnerGoalsAndPreferences.fromJson(Map<String, dynamic> json) {
    return Section15OwnerGoalsAndPreferences(
      currentPrimaryFocus: json['current_primary_focus']?.toString() ?? '',
      dayToDayInvolvement: json['day_to_day_involvement']?.toString() ?? '',
      financialRiskTolerance: json['financial_risk_tolerance']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'current_primary_focus': currentPrimaryFocus,
    'day_to_day_involvement': dayToDayInvolvement,
    'financial_risk_tolerance': financialRiskTolerance,
  };
}

class OnboardingLocation {
  final String name;
  final String address;
  final String city;
  final String state;
  final String postalCode;
  final String spaceType;
  final String role;
  final String status;

  const OnboardingLocation({
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.spaceType,
    required this.role,
    required this.status,
  });

  factory OnboardingLocation.fromJson(Map<String, dynamic> json) {
    final rawAddress = json['address'] as String? ?? '450 Dauphin St, Mobile, AL 36602';
    final name = json['name'] as String? ?? 'Saturday farmers market';
    final role = json['role'] as String? ?? 'Seasonal / event';
    final status = json['status'] as String? ?? 'active';
    final spaceType = json['space_type'] as String? ?? 'mobile';

    String city = json['city'] as String? ?? '';
    String state = json['state'] as String? ?? '';
    String postalCode = json['postal_code'] as String? ?? '';

    if (city.isEmpty && state.isEmpty && rawAddress.contains(',')) {
      final parts = rawAddress.split(',');
      if (parts.length >= 2) city = parts[1].trim();
      if (parts.length >= 3) {
        final stateZip = parts[2].trim().split(' ');
        state = stateZip.first;
        if (stateZip.length > 1) postalCode = stateZip.last;
      }
    }

    return OnboardingLocation(
      name: name,
      address: rawAddress,
      city: city.isNotEmpty ? city : 'Mobile',
      state: state.isNotEmpty ? state : 'AL',
      postalCode: postalCode.isNotEmpty ? postalCode : '36602',
      spaceType: spaceType,
      role: role,
      status: status,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'address': address.isNotEmpty ? address : fullAddress,
        'role': role.isNotEmpty ? role : 'Seasonal / event',
        'status': status.isNotEmpty ? status : 'active',
      };

  String get fullAddress {
    if (address.contains(city) && city.isNotEmpty) {
      return address;
    }
    final cityState = [city, state].where((s) => s.isNotEmpty).join(', ');
    final zip = postalCode.isNotEmpty ? ' $postalCode' : '';
    if (cityState.isNotEmpty) {
      return '$address, $cityState$zip';
    }
    return address;
  }

  static const OnboardingLocation defaultLocation = OnboardingLocation(
    name: 'Dauphin Street Flagship',
    address: '450 Dauphin St',
    city: 'Mobile',
    state: 'AL',
    postalCode: '36602',
    spaceType: 'mobile',
    role: 'headquarters',
    status: 'active',
  );
}

class OwnerObservation {
  final String text;

  const OwnerObservation({required this.text});

  factory OwnerObservation.fromJson(Map<String, dynamic> json) {
    return OwnerObservation(
      text: json['text'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'text': text};
}
