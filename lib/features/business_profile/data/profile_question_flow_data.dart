enum QuestionInputType { text, select, multiSelect, slider }

class ProfileQuestion {
  final String title;
  final String subtitle;
  final QuestionInputType type;
  final String placeholder;
  final String? initialValue;
  final List<String> options;
  final int minLines;
  final int maxLines;
  final String? apiKey;

  const ProfileQuestion({
    required this.title,
    this.subtitle = '',
    required this.type,
    this.placeholder = '',
    this.initialValue,
    this.options = const [],
    this.minLines = 1,
    this.maxLines = 1,
    this.apiKey,
  });
}

class ProfileSectionFlow {
  final int sectionNumber;
  final String sectionTitle;
  final String sectionDescription;
  final int totalQuestions;
  final int answeredBefore;
  final List<ProfileQuestion> questions;

  const ProfileSectionFlow({
    required this.sectionNumber,
    required this.sectionTitle,
    required this.sectionDescription,
    required this.totalQuestions,
    required this.answeredBefore,
    required this.questions,
  });
}

// -------------------------------------------------------------
// 15 Complete Section Question Flows with exact API Keys (95 Questions)
// -------------------------------------------------------------

const businessBasicsFlow = ProfileSectionFlow(
  sectionNumber: 1,
  sectionTitle: 'Business Basics',
  sectionDescription:
      'The core facts about your business. Seven quick questions to help '
      'LightSignal personalize every signal and recommendation.',
  totalQuestions: 7,
  answeredBefore: 0,
  questions: [
    ProfileQuestion(
      apiKey: 'business_name',
      title: "What's your business name?",
      type: QuestionInputType.text,
      placeholder: "Tony's Brooklyn Pizza",
      initialValue: "Tony's Brooklyn Pizza",
    ),
    ProfileQuestion(
      apiKey: 'headquarters',
      title: "Where is your main location or headquarters?\n(City, State)",
      type: QuestionInputType.text,
      placeholder: "Park Slope, Brooklyn, NY",
      initialValue: "Park Slope, Brooklyn, NY",
    ),
    ProfileQuestion(
      apiKey: 'years_in_business',
      title: "How long has your business been open?",
      type: QuestionInputType.select,
      options: [
        'Less than 6 months',
        '6 months to 1 year',
        '1 to 2 years',
        '2 to 3 years',
        '3 to 5 years',
        '5 to 10 years',
        'More than 10 years',
      ],
    ),
    ProfileQuestion(
      apiKey: 'timezone',
      title: "What time zone do you operate in?",
      type: QuestionInputType.text,
      placeholder: "e.g. America/Chicago",
    ),
    ProfileQuestion(
      apiKey: 'currency',
      title: "What currency do you primarily use?",
      type: QuestionInputType.text,
      placeholder: "e.g. USD",
    ),
    ProfileQuestion(
      apiKey: 'legal_entity_type',
      title: "What type of business entity are you?",
      type: QuestionInputType.select,
      initialValue: "Sole Prop",
      options: [
        'LLC',
        'S-Corp',
        'Sole Prop',
        'C-Corp',
        'Partnership',
        'Other',
      ],
    ),
    ProfileQuestion(
      apiKey: 'ein',
      title: "What is your business registration number or EIN?",
      subtitle: "Optional.",
      type: QuestionInputType.text,
      placeholder: "Enter EIN",
    ),
  ],
);

const ownershipKeyPeopleFlow = ProfileSectionFlow(
  sectionNumber: 2,
  sectionTitle: 'Ownership & Key People',
  sectionDescription:
      'Details on who owns and runs the business. Four quick questions to help '
      'LightSignal understand key decision makers and business continuity.',
  totalQuestions: 4,
  answeredBefore: 0,
  questions: [
    ProfileQuestion(
      apiKey: 'ownership_breakdown',
      title: "Who owns the business and what percent does each person own?",
      type: QuestionInputType.text,
      placeholder: "e.g., John Doe (60%), Jane Smith (40%)",
      minLines: 3,
      maxLines: 5,
    ),
    ProfileQuestion(
      apiKey: 'decision_maker',
      title: "Who makes the main day-to-day business decisions?",
      type: QuestionInputType.text,
      placeholder: "Name or role",
    ),
    ProfileQuestion(
      apiKey: 'bookkeeper_financial_handler',
      title: "Who handles finances or bookkeeping for the business?",
      type: QuestionInputType.text,
      placeholder: "Name, role, or external service",
    ),
    ProfileQuestion(
      apiKey: 'has_backup_operator',
      title: "If you were unavailable, is there someone who could step in to run the business?",
      type: QuestionInputType.select,
      options: [
        'Yes',
        'No',
      ],
    ),
  ],
);

const industryModelFlow = ProfileSectionFlow(
  sectionNumber: 3,
  sectionTitle: 'Industry & Model',
  sectionDescription:
      'How your business operates and generates revenue. Four quick questions '
      'to help LightSignal contextualize your market dynamics.',
  totalQuestions: 4,
  answeredBefore: 0,
  questions: [
    ProfileQuestion(
      apiKey: 'business_description',
      title: "How would you describe your business and what you do?",
      type: QuestionInputType.text,
      placeholder: "Brief description",
      minLines: 3,
      maxLines: 5,
    ),
    ProfileQuestion(
      apiKey: 'revenue_model_description',
      title:
          "How does your business make money? Describe it in your own words — even a sentence is fine.",
      type: QuestionInputType.text,
      placeholder: "List main products/services",
      minLines: 3,
      maxLines: 5,
    ),
    ProfileQuestion(
      apiKey: 'target_market_type',
      title: "Do you mainly sell to consumers, businesses, or both?",
      type: QuestionInputType.select,
      options: [
        'Consumers',
        'Businesses',
        'Both',
      ],
    ),
    ProfileQuestion(
      apiKey: 'business_stage',
      title: "Which of these best describes where your business is right now?",
      type: QuestionInputType.select,
      options: [
        'Still getting established',
        'Stable and steady',
        'Growing and adding capacity',
        'Hitting a plateau',
        'Going through a tough stretch',
        'Scaling fast',
      ],
    ),
  ],
);

const operationsFlow = ProfileSectionFlow(
  sectionNumber: 4,
  sectionTitle: 'Operations',
  sectionDescription:
      'How work gets done daily, team structure, and supplier dependencies. '
      'Ten quick questions to map your operational footprint.',
  totalQuestions: 10,
  answeredBefore: 0,
  questions: [
    ProfileQuestion(
      apiKey: 'team_size',
      title: "Who works in your business day to day?",
      type: QuestionInputType.select,
      initialValue: "Just me — I do everything",
      options: [
        'Just me — I do everything',
        'Me plus 1 to 3 people',
        'Small team of 4 to 10',
        'Team of 11 to 25',
        'More than 25 people',
      ],
    ),
    ProfileQuestion(
      apiKey: 'payroll_type',
      title: "How are most of your workers paid?",
      type: QuestionInputType.select,
      initialValue: "All salaried or hourly employees",
      options: [
        'All salaried or hourly employees',
        'Mostly employees with some contractors',
        'About half and half',
        'Mostly contractors as needed',
        'All contractors or freelancers',
      ],
    ),
    ProfileQuestion(
      apiKey: 'operating_hours',
      title: "What are your typical hours of operation?",
      type: QuestionInputType.text,
      placeholder: "e.g. Mon–Fri, 9am–5pm",
    ),
    ProfileQuestion(
      apiKey: 'growth_limiters',
      title: "What usually limits your growth the most right now?",
      type: QuestionInputType.multiSelect,
      options: [
        'Staff',
        'Inventory',
        'Equipment',
        'Cash',
        'Leads',
        'Time',
        'Other',
      ],
    ),
    ProfileQuestion(
      apiKey: 'single_supplier_dependency',
      title: "Do you rely heavily on any single supplier or vendor to operate?",
      type: QuestionInputType.select,
      placeholder: "Select option",
      options: [
        'Yes, heavily — losing them would seriously disrupt us',
        'We have key suppliers but alternatives exist',
        'No significant dependencies',
      ],
    ),
    ProfileQuestion(
      apiKey: 'uses_pos_system',
      title: "Do you use a point of sale system?",
      type: QuestionInputType.select,
      options: [
        'Yes',
        'No',
      ],
    ),
    ProfileQuestion(
      apiKey: 'space_ownership_status',
      title: "Do you own or lease your main business space?",
      type: QuestionInputType.select,
      options: [
        'Own it',
        'Lease it',
        'Work from home or from a vehicle',
        'Multiple locations — varies',
      ],
    ),
    ProfileQuestion(
      apiKey: 'operational_software',
      title: "Which of these do you currently use to run your business?",
      subtitle: "Select all that apply.",
      type: QuestionInputType.multiSelect,
      options: [
        'Scheduling software',
        'Inventory management',
        'Project management',
        'Email marketing',
        'Payroll software',
        'E-commerce platform',
        'Booking or reservation system',
        'None of these',
      ],
    ),
    ProfileQuestion(
      apiKey: 'recent_supplier_issues',
      title: "Have you had any supplier or input cost issues recently?",
      type: QuestionInputType.select,
      options: [
        'Yes',
        'No',
      ],
    ),
    ProfileQuestion(
      apiKey: 'critical_materials_inputs',
      title: "Are there any materials or inputs your business critically depends on?",
      type: QuestionInputType.text,
      placeholder: "What does your business depend on?",
      minLines: 3,
      maxLines: 5,
    ),
  ],
);

const financialOverviewFlow = ProfileSectionFlow(
  sectionNumber: 5,
  sectionTitle: 'Financial Overview',
  sectionDescription:
      'Your accounting systems, fiscal calendar, and banking relationships. '
      'Five quick questions to help LightSignal track margins and cash flow.',
  totalQuestions: 5,
  answeredBefore: 0,
  questions: [
    ProfileQuestion(
      apiKey: 'accounting_system',
      title: "Which accounting system do you use?",
      type: QuestionInputType.select,
      options: [
        'QuickBooks',
        'Xero',
        'Sage',
        'Other',
        'None',
      ],
    ),
    ProfileQuestion(
      apiKey: 'connect_accounting_now',
      title: "Would you like to connect your accounting system now?",
      type: QuestionInputType.select,
      options: [
        'Yes',
        'No',
        'Later',
      ],
    ),
    ProfileQuestion(
      apiKey: 'fiscal_year_start',
      title: "When does your fiscal year start?",
      type: QuestionInputType.select,
      options: [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ],
    ),
    ProfileQuestion(
      apiKey: 'banks_and_lenders',
      title: "Do you work with any banks or lenders?",
      subtitle: "Optional.",
      type: QuestionInputType.text,
      placeholder: "List any banks or lenders",
    ),
    ProfileQuestion(
      apiKey: 'business_loan_history',
      title:
          "Have you ever taken out a business loan, SBA loan, or line of credit?",
      type: QuestionInputType.select,
      options: [
        'Yes and paid it off',
        'Yes and currently paying it',
        'Applied but was not approved',
        'Never tried',
        'Not sure',
      ],
    ),
  ],
);

const assetsEquipmentFlow = ProfileSectionFlow(
  sectionNumber: 6,
  sectionTitle: 'Assets & Equipment',
  sectionDescription:
      'Machinery, vehicles, hardware, and key property your business relies on. '
      'Five quick questions to evaluate equipment health and financing.',
  totalQuestions: 5,
  answeredBefore: 0,
  questions: [
    ProfileQuestion(
      apiKey: 'major_assets',
      title: "What major assets or equipment does your business rely on?",
      type: QuestionInputType.text,
      placeholder: "List major assets",
      minLines: 3,
      maxLines: 5,
    ),
    ProfileQuestion(
      apiKey: 'asset_ownership_status',
      title: "For each asset: is it owned or leased?",
      type: QuestionInputType.text,
      placeholder: "For each: owned or leased",
      minLines: 3,
      maxLines: 5,
    ),
    ProfileQuestion(
      apiKey: 'asset_purchase_dates',
      title: "When was it purchased or leased?",
      type: QuestionInputType.text,
      placeholder: "Purchase/lease dates",
      minLines: 3,
      maxLines: 5,
    ),
    ProfileQuestion(
      apiKey: 'asset_condition',
      title: "What condition is it in?",
      type: QuestionInputType.text,
      placeholder: "Describe condition of each asset",
      minLines: 3,
      maxLines: 5,
    ),
    ProfileQuestion(
      apiKey: 'leased_monthly_payment',
      title: "If leased — what is your monthly payment?",
      type: QuestionInputType.select,
      options: [
        'Under \$500',
        '\$500 to \$2K',
        '\$2K to \$5K',
        'Over \$5K',
      ],
    ),
  ],
);

const customersMarketFlow = ProfileSectionFlow(
  sectionNumber: 7,
  sectionTitle: 'Customers & Market',
  sectionDescription:
      'Who buys from you, where they come from, and how demand moves. '
      'Fifteen quick questions — skip anything; you can come back anytime.',
  totalQuestions: 15,
  answeredBefore: 0,
  questions: [
    ProfileQuestion(
      apiKey: 'customer_distance',
      title: 'How far do your customers come from?',
      subtitle:
          'Roughly — this shapes which competitors, events, and '
          'opportunities matter for you.',
      type: QuestionInputType.slider,
      options: ['My neighborhood', 'Across the metro', 'Regional / beyond'],
    ),
    ProfileQuestion(
      apiKey: 'strongest_seasons',
      title: 'When is business strongest?',
      subtitle:
          'Pick the seasons that spike — or tell us it holds steady '
          'year-round.',
      type: QuestionInputType.multiSelect,
      options: [
        'Spring',
        'Summer',
        'Fall',
        'Winter',
        'Fairly consistent year-round',
      ],
    ),
    ProfileQuestion(
      apiKey: 'customer_acquisition_channels',
      title: 'Where do most of your customers come from?',
      subtitle:
          'Your best guess is fine — walk-by, word of mouth, social, '
          'search, repeat regulars.',
      type: QuestionInputType.multiSelect,
      options: [
        'Walk-by / drive-by',
        'Word of mouth',
        'Social media',
        'Search / maps',
        'Repeat regulars',
      ],
    ),
    ProfileQuestion(
      apiKey: 'typical_customers_description',
      title: 'Who are your typical customers?',
      type: QuestionInputType.text,
      placeholder: 'Describe your typical customers',
      minLines: 3,
      maxLines: 5,
    ),
    ProfileQuestion(
      apiKey: 'monthly_customer_volume',
      title: 'Roughly how many customers or jobs do you handle per month?',
      type: QuestionInputType.text,
      placeholder: 'Enter estimate',
    ),
    ProfileQuestion(
      apiKey: 'repeat_business_rate',
      title: 'Do you get repeat business?',
      type: QuestionInputType.select,
      options: [
        'Low',
        'Medium',
        'High',
      ],
    ),
    ProfileQuestion(
      apiKey: 'target_customer_types',
      title: 'Are there specific types of customers you want more of?',
      type: QuestionInputType.text,
      placeholder: 'Describe ideal customers',
      minLines: 3,
      maxLines: 5,
    ),
    ProfileQuestion(
      apiKey: 'customer_concentration',
      title: 'Does any single customer make up a large portion of your revenue?',
      type: QuestionInputType.select,
      options: [
        'Yes, one customer is a very large portion',
        'Yes, a few together are most of revenue',
        'No, spread across many',
      ],
    ),
    ProfileQuestion(
      apiKey: 'seasonality_level',
      title: 'Does your business have busy seasons or is it pretty consistent year-round?',
      type: QuestionInputType.select,
      options: [
        'Very consistent year-round',
        'A little seasonal',
        'Pretty seasonal',
        'Extremely seasonal — huge swings',
      ],
    ),
    ProfileQuestion(
      apiKey: 'customer_geographic_source',
      title: 'Where do most of your customers come from?',
      subtitle: 'Geographically — how far your customer base spreads.',
      type: QuestionInputType.select,
      options: [
        'Hyper-local / Walking distance',
        'Within 10–15 miles',
        'Across the metro area',
        'Statewide / regional',
        'Nationwide / Global',
      ],
    ),
    ProfileQuestion(
      apiKey: 'opportunity_radius_miles',
      title:
          'How far from your main location should we usually look for opportunities?',
      subtitle: 'In miles.',
      type: QuestionInputType.text,
      placeholder: 'e.g. 25',
    ),
    ProfileQuestion(
      apiKey: 'max_travel_distance_miles',
      title:
          'What\'s the furthest distance you\'d realistically travel for a really good opportunity?',
      subtitle: 'In miles.',
      type: QuestionInputType.text,
      placeholder: 'e.g. 100',
    ),
    ProfileQuestion(
      apiKey: 'local_opportunity_preference',
      title:
          'Do you want us to focus only on very local opportunities unless you say otherwise?',
      type: QuestionInputType.select,
      options: [
        'Yes, stay strictly local',
        'Open to nearby areas if high-value',
        'No restriction — open anywhere',
      ],
    ),
    ProfileQuestion(
      apiKey: 'geographic_service_areas',
      title: 'What geographic areas or regions do you currently serve?',
      type: QuestionInputType.text,
      placeholder: 'List areas you serve',
      minLines: 3,
      maxLines: 5,
    ),
    ProfileQuestion(
      apiKey: 'weather_impact',
      title: 'Does weather impact your business?',
      type: QuestionInputType.select,
      options: [
        'None',
        'Some',
        'High',
      ],
    ),
  ],
);

const riskExposureFlow = ProfileSectionFlow(
  sectionNumber: 8,
  sectionTitle: 'Risk & Exposure',
  sectionDescription:
      'Insurance, dependencies, licenses, and legal compliance. '
      'Six quick questions to identify operational vulnerabilities.',
  totalQuestions: 6,
  answeredBefore: 0,
  questions: [
    ProfileQuestion(
      apiKey: 'carries_business_insurance',
      title: "Do you carry business insurance?",
      type: QuestionInputType.select,
      options: [
        'Yes',
        'No',
      ],
    ),
    ProfileQuestion(
      apiKey: 'critical_dependencies',
      title:
          "Are there any customers, suppliers, or partners your business heavily depends on?",
      type: QuestionInputType.text,
      placeholder: "Who does your business depend on heavily?",
      minLines: 3,
      maxLines: 5,
    ),
    ProfileQuestion(
      apiKey: 'revenue_concentration',
      title:
          "Does any single customer make up a large portion of your revenue?",
      type: QuestionInputType.select,
      options: [
        'Yes, one customer is a very large portion',
        'Yes, a few together',
        'No, spread across many',
      ],
    ),
    ProfileQuestion(
      apiKey: 'active_permits_licenses',
      title:
          "What permits, licenses, or certifications does your business currently hold?",
      type: QuestionInputType.text,
      placeholder: "List required permits",
      minLines: 3,
      maxLines: 5,
    ),
    ProfileQuestion(
      apiKey: 'in_progress_permits_licenses',
      title:
          "Are there any permits or licenses you are in the process of getting or planning to get?",
      type: QuestionInputType.text,
      placeholder: "Describe any in progress",
      minLines: 3,
      maxLines: 5,
    ),
    ProfileQuestion(
      apiKey: 'local_operating_restrictions',
      title:
          "Are there any local rules that affect how or when you operate?",
      type: QuestionInputType.text,
      placeholder: "Any local rules or restrictions?",
      minLines: 3,
      maxLines: 5,
    ),
  ],
);

const capacityConstraintsFlow = ProfileSectionFlow(
  sectionNumber: 9,
  sectionTitle: 'Capacity & Constraints',
  sectionDescription:
      'Current workload, growth bottlenecks, and headroom to scale. '
      'Five quick questions to evaluate operational limits.',
  totalQuestions: 5,
  answeredBefore: 0,
  questions: [
    ProfileQuestion(
      apiKey: 'monthly_customer_capacity',
      title: "Roughly how many customers or jobs do you handle per month?",
      type: QuestionInputType.text,
      placeholder: "Enter estimate",
    ),
    ProfileQuestion(
      apiKey: 'could_handle_more_capacity',
      title:
          "Looking back, do you feel like you could have handled more if needed?",
      type: QuestionInputType.select,
      placeholder: "Select option",
      options: [
        'Yes, we had plenty of room',
        'Maybe a little more but not much',
        'No, we were at our limit',
        'Hard to say',
      ],
    ),
    ProfileQuestion(
      apiKey: 'current_busy_level',
      title: "How busy are you on average right now?",
      type: QuestionInputType.multiSelect,
      options: [
        'Often below capacity',
        'Around capacity',
        'Frequently stretched',
        'Regularly turning work away',
      ],
    ),
    ProfileQuestion(
      apiKey: 'operational_slowdown_factors',
      title: "What usually slows you down the most?",
      type: QuestionInputType.multiSelect,
      options: [
        'Labor',
        'Equipment',
        'Materials',
        'Permits',
        'Demand',
        'Other',
      ],
    ),
    ProfileQuestion(
      apiKey: 'has_active_business_financing',
      title:
          "Do you currently have any business loans, equipment financing, or lines of credit?",
      type: QuestionInputType.select,
      placeholder: "Select option",
      options: [
        'Yes',
        'No',
        'Not sure',
      ],
    ),
  ],
);

const opportunityReadinessFlow = ProfileSectionFlow(
  sectionNumber: 10,
  sectionTitle: 'Opportunity Readiness',
  sectionDescription:
      'Flexibility, wholesale, pop-ups, brand partnerships, and media openness. '
      'Fourteen quick questions to match high-value business leads.',
  totalQuestions: 14,
  answeredBefore: 0,
  questions: [
    ProfileQuestion(
      apiKey: 'external_selling_experience',
      title:
          "Have you sold outside your usual setup before — pop-ups, events, wholesale?",
      type: QuestionInputType.select,
      options: [
        'Yes, regularly',
        'A few times',
        'Never',
      ],
    ),
    ProfileQuestion(
      apiKey: 'commitment_type_preference',
      title:
          "Do you prefer one-time opportunities, recurring ones, or longer commitments?",
      type: QuestionInputType.select,
      options: [
        'One-time',
        'Recurring',
        'Long-term',
        'Open to any',
      ],
    ),
    ProfileQuestion(
      apiKey: 'flex_production_capacity',
      title:
          "Could you flex your production or staffing up for a bigger order?",
      type: QuestionInputType.select,
      options: [
        'Yes, easily',
        'With some notice',
        'Not really',
      ],
    ),
    ProfileQuestion(
      apiKey: 'brand_partnership_willingness',
      title:
          "Are you open to a named partnership with another brand or business?",
      type: QuestionInputType.select,
      options: [
        'Yes',
        'Maybe, depends on fit',
        'No',
      ],
    ),
    ProfileQuestion(
      apiKey: 'public_visibility_comfort',
      title:
          "How comfortable are you with press, media, or public visibility?",
      type: QuestionInputType.select,
      options: [
        'Very comfortable',
        'Somewhat',
        'Prefer to stay low-key',
      ],
    ),
    ProfileQuestion(
      apiKey: 'available_weekly_time',
      title:
          "How much extra time could you realistically give a new opportunity right now?",
      type: QuestionInputType.select,
      options: [
        'A few hours a week',
        'A few hours a day',
        'Not much right now',
      ],
    ),
    ProfileQuestion(
      apiKey: 'upfront_spending_tolerance',
      title:
          "How much could you comfortably spend upfront before seeing it pay off?",
      type: QuestionInputType.select,
      options: [
        'Under \$500',
        '\$500 to \$2K',
        '\$2K to \$10K',
        'Over \$10K',
      ],
    ),
    ProfileQuestion(
      apiKey: 'risk_tolerance',
      title:
          "In general, how much risk are you willing to take on a new opportunity?",
      type: QuestionInputType.select,
      options: [
        'Low',
        'Moderate',
        'High',
      ],
    ),
    ProfileQuestion(
      apiKey: 'opportunity_nogo_filters',
      title: "Anything you want us to never suggest?",
      subtitle: "e.g. certain locations, hours, types of work.",
      type: QuestionInputType.text,
      placeholder: "List any hard no's",
      minLines: 3,
      maxLines: 5,
    ),
    ProfileQuestion(
      apiKey: 'ideal_partner_types',
      title:
          "Who do you most want to work with — types of partners, customers, or venues?",
      type: QuestionInputType.text,
      placeholder: "Describe who you'd want to work with",
      minLines: 3,
      maxLines: 5,
    ),
    ProfileQuestion(
      apiKey: 'win_definition_90_days',
      title: "What would make the next 90 days a win for you?",
      type: QuestionInputType.text,
      placeholder: "What matters most right now",
      minLines: 3,
      maxLines: 5,
    ),
    ProfileQuestion(
      apiKey: 'growth_focus_stage',
      title:
          "Where's your focus right now — holding steady or actively growing?",
      type: QuestionInputType.select,
      options: [
        'Stabilizing',
        'Steady state',
        'Actively growing',
      ],
    ),
    ProfileQuestion(
      apiKey: 'stretch_opportunity_permission',
      title:
          "Want us to occasionally show a stretch opportunity — bigger than your usual, but data-backed?",
      type: QuestionInputType.select,
      options: [
        'Yes, show me those',
        'No, keep it realistic',
      ],
    ),
    ProfileQuestion(
      apiKey: 'opportunity_surfacing_frequency',
      title: "How aggressively should we surface new opportunities to you?",
      type: QuestionInputType.select,
      options: [
        'Show me everything',
        'Only strong matches',
        'Only sure things',
      ],
    ),
  ],
);

const strategicGoalsFlow = ProfileSectionFlow(
  sectionNumber: 11,
  sectionTitle: 'Strategic Goals',
  sectionDescription:
      'Short-term objectives, 3-year vision, long-term roadmap, and exit goals. '
      'Four focused questions to steer recommendations towards your milestones.',
  totalQuestions: 4,
  answeredBefore: 0,
  questions: [
    ProfileQuestion(
      apiKey: 'goals_12_month',
      title: "What are your main goals for the next 12 months?",
      type: QuestionInputType.text,
      placeholder: "Describe your goals",
      minLines: 3,
      maxLines: 5,
    ),
    ProfileQuestion(
      apiKey: 'goals_3_year',
      title: "Where would you like the business to be in about 3 years?",
      type: QuestionInputType.text,
      placeholder: "3-year vision",
      minLines: 3,
      maxLines: 5,
    ),
    ProfileQuestion(
      apiKey: 'long_term_vision',
      title: "What's your long-term vision for the business?",
      type: QuestionInputType.text,
      placeholder: "Long-term vision",
      minLines: 3,
      maxLines: 5,
    ),
    ProfileQuestion(
      apiKey: 'exit_strategy',
      title:
          "Do you have an eventual exit goal? If so, what does it look like?",
      type: QuestionInputType.text,
      placeholder: "Describe your exit strategy if any",
      minLines: 3,
      maxLines: 5,
    ),
  ],
);

const pricingRevenueFlow = ProfileSectionFlow(
  sectionNumber: 12,
  sectionTitle: 'Pricing & Revenue',
  sectionDescription:
      'Pricing model, average deal size, discounting, and payment terms. '
      'Four quick questions to evaluate pricing power and cash flow structure.',
  totalQuestions: 4,
  answeredBefore: 0,
  questions: [
    ProfileQuestion(
      apiKey: 'pricing_method',
      title: "How do you usually set your prices?",
      type: QuestionInputType.multiSelect,
      options: [
        'Hourly',
        'Per job',
        'Per unit',
        'Subscription',
        'Retainer',
        'Mixed',
      ],
    ),
    ProfileQuestion(
      apiKey: 'typical_order_size',
      title: "What's a typical invoice or order size?",
      subtitle: "Estimate.",
      type: QuestionInputType.text,
      placeholder: "e.g. \$500",
    ),
    ProfileQuestion(
      apiKey: 'discounts_and_promotions',
      title: "Do you offer discounts or promotions? If so, when and how?",
      type: QuestionInputType.text,
      placeholder: "When and how?",
      minLines: 3,
      maxLines: 5,
    ),
    ProfileQuestion(
      apiKey: 'customer_payment_methods',
      title: "How do customers usually pay you?",
      type: QuestionInputType.multiSelect,
      options: [
        'Upfront',
        'Monthly',
        'Net-30',
        'Net-60',
        'On delivery',
        'Installments',
      ],
    ),
  ],
);

const hiringTeamStructureFlow = ProfileSectionFlow(
  sectionNumber: 13,
  sectionTitle: 'Hiring & Team Structure',
  sectionDescription:
      'Key roles, upcoming hiring plans, recruiting channels, and contractor usage. '
      'Four quick questions to understand workforce scalability and labor dependencies.',
  totalQuestions: 4,
  answeredBefore: 0,
  questions: [
    ProfileQuestion(
      apiKey: 'team_roles',
      title: "What are the main job roles on your team?",
      type: QuestionInputType.text,
      placeholder: "List the main roles",
      minLines: 3,
      maxLines: 5,
    ),
    ProfileQuestion(
      apiKey: 'planning_to_hire_12_months',
      title: "Are you planning to hire in the next 12 months?",
      type: QuestionInputType.select,
      options: [
        'Yes',
        'No',
      ],
    ),
    ProfileQuestion(
      apiKey: 'recruitment_channels',
      title: "How do you usually find new employees?",
      type: QuestionInputType.multiSelect,
      options: [
        'Job boards',
        'Referrals',
        'Recruiters',
        'Social media',
        'Walk-ins',
        'Other',
      ],
    ),
    ProfileQuestion(
      apiKey: 'uses_contractors_freelancers',
      title: "Do you regularly use contractors or freelance help?",
      type: QuestionInputType.select,
      options: [
        'Yes',
        'No',
        'Sometimes',
      ],
    ),
  ],
);

const salesMarketingFlow = ProfileSectionFlow(
  sectionNumber: 14,
  sectionTitle: 'Sales & Marketing',
  sectionDescription:
      'Customer acquisition channels, delivery methods, lead tracking, conversion rate, and marketing budget. '
      'Five questions to analyze growth engine efficiency.',
  totalQuestions: 5,
  answeredBefore: 0,
  questions: [
    ProfileQuestion(
      apiKey: 'sales_channels',
      title: "How do customers usually find you?",
      subtitle: "Select all that apply.",
      type: QuestionInputType.multiSelect,
      options: [
        'Word of mouth',
        'Online search',
        'Social media',
        'Ads',
        'Referrals',
        'Events',
        'Cold outreach',
        'Other',
      ],
    ),
    ProfileQuestion(
      apiKey: 'delivery_methods',
      title: "How do you usually sell or deliver your product or service?",
      type: QuestionInputType.multiSelect,
      options: [
        'In-person',
        'Online',
        'Phone',
        'Retail store',
        'Delivery',
        'Subscription',
        'Other',
      ],
    ),
    ProfileQuestion(
      apiKey: 'tracks_leads_crm',
      title: "Do you track leads or customers anywhere?",
      type: QuestionInputType.select,
      options: [
        'No',
        'Spreadsheet',
        'CRM',
      ],
    ),
    ProfileQuestion(
      apiKey: 'lead_conversion_rate',
      title:
          "Roughly what percentage of leads turn into paying customers?",
      subtitle: "Estimate.",
      type: QuestionInputType.text,
      placeholder: "e.g. 20%",
    ),
    ProfileQuestion(
      apiKey: 'monthly_marketing_budget',
      title: "Do you have a rough monthly marketing budget?",
      subtitle: "Optional.",
      type: QuestionInputType.text,
      placeholder: "e.g. 5000",
    ),
  ],
);

const ownerGoalsPreferencesFlow = ProfileSectionFlow(
  sectionNumber: 15,
  sectionTitle: 'Owner Goals & Preferences',
  sectionDescription:
      'Core priorities, day-to-day involvement preference, and financial risk tolerance. '
      'Three questions to align recommendations with your personal work-life and financial ambitions.',
  totalQuestions: 3,
  answeredBefore: 0,
  questions: [
    ProfileQuestion(
      apiKey: 'current_primary_focus',
      title: "What's most important to you right now?",
      type: QuestionInputType.multiSelect,
      options: [
        'Profit',
        'Growth',
        'Stability',
        'Reduce workload',
        'Prepare to exit',
        'Other',
      ],
    ),
    ProfileQuestion(
      apiKey: 'day_to_day_involvement',
      title: "How involved do you want to be in day-to-day?",
      type: QuestionInputType.select,
      options: [
        'Very involved',
        'Somewhat involved',
        'Minimal',
        'Want to step back',
      ],
    ),
    ProfileQuestion(
      apiKey: 'financial_risk_tolerance',
      title: "How comfortable are you with taking financial risks?",
      type: QuestionInputType.select,
      options: [
        'Conservative',
        'Moderate',
        'Aggressive',
      ],
    ),
  ],
);

/// Map of all section numbers to their question flows
const Map<int, ProfileSectionFlow> allSectionFlows = {
  1: businessBasicsFlow,
  2: ownershipKeyPeopleFlow,
  3: industryModelFlow,
  4: operationsFlow,
  5: financialOverviewFlow,
  6: assetsEquipmentFlow,
  7: customersMarketFlow,
  8: riskExposureFlow,
  9: capacityConstraintsFlow,
  10: opportunityReadinessFlow,
  11: strategicGoalsFlow,
  12: pricingRevenueFlow,
  13: hiringTeamStructureFlow,
  14: salesMarketingFlow,
  15: ownerGoalsPreferencesFlow,
};
