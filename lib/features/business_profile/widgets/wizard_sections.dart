import 'package:flutter/material.dart';

import 'wizard_controls.dart';

const _gap = SizedBox(height: 16);

class BusinessBasicsSection extends StatelessWidget {
  const BusinessBasicsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WizardTextField(
          label: "What's your business name?",
          hint: 'Enter business name',
        ),
        _gap,
        const WizardTextField(
          label: 'Where is your main location or headquarters? (City, State)',
          hint: 'City, State',
        ),
        _gap,
        const WizardDropdown(
          label: 'How long has your business been open?',
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
        _gap,
        const WizardTextField(
          label: 'What time zone do you operate in?',
          hint: 'e.g. EST',
        ),
        _gap,
        const WizardTextField(
          label: 'What currency do you primarily use?',
          hint: 'e.g. USD',
        ),
        _gap,
        const WizardDropdown(
          label: 'What type of business entity are you?',
          options: [
            'LLC',
            'S-Corp',
            'Sole Prop',
            'C-Corp',
            'Partnership',
            'Other',
          ],
        ),
        _gap,
        const WizardTextField(
          label: 'What is your business registration number or EIN? (Optional)',
          hint: 'Enter EIN',
        ),
      ],
    );
  }
}

class OwnershipKeyPeopleSection extends StatelessWidget {
  const OwnershipKeyPeopleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WizardTextArea(
          label: 'Who owns the business and what percent does each person own?',
          hint: 'e.g., John Doe (60%), Jane Smith (40%)',
          minLines: 2,
        ),
        _gap,
        const WizardTextField(
          label: 'Who makes the main day-to-day business decisions?',
          hint: 'Name or role',
        ),
        _gap,
        const WizardTextField(
          label: 'Who handles finances or bookkeeping for the business?',
          hint: 'Name, role, or external service',
        ),
        _gap,
        const WizardDropdown(
          label:
              'If you were unavailable, is there someone who could step in '
              'to run the business?',
          options: ['Yes', 'No'],
        ),
      ],
    );
  }
}

class BusinessDescriptionSection extends StatelessWidget {
  const BusinessDescriptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WizardTextArea(
          label: 'How would you describe your business and what you do?',
          hint: 'Brief description',
          minLines: 2,
        ),
        _gap,
        const WizardTextArea(
          label:
              'How does your business make money? Describe it in your own '
              "words — even a sentence is fine.",
          hint: 'List main products/services',
          minLines: 2,
        ),
        _gap,
        const WizardDropdown(
          label: 'Do you mainly sell to consumers, businesses, or both?',
          options: ['Consumers', 'Businesses', 'Both'],
        ),
        _gap,
        const WizardDropdown(
          label:
              'Which of these best describes where your business is right now?',
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
  }
}

class ServiceAreaPreferencesSection extends StatelessWidget {
  const ServiceAreaPreferencesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WizardTextField(
          label:
              'How far from your main location should we usually look for '
              'opportunities? (miles)',
          hint: 'e.g. 25',
          keyboardType: TextInputType.number,
        ),
        _gap,
        const WizardTextField(
          label:
              "What's the furthest distance you'd realistically travel for "
              'a really good opportunity? (miles)',
          hint: 'e.g. 100',
          keyboardType: TextInputType.number,
        ),
        _gap,
        const WizardDropdown(
          label:
              'Do you want us to focus only on very local opportunities '
              'unless you say otherwise?',
          options: ['Yes', 'No'],
        ),
        _gap,
        const WizardTextArea(
          label: 'What geographic areas or regions do you currently serve?',
          hint: 'List areas you serve',
          minLines: 2,
        ),
        _gap,
        const WizardDropdown(
          label: 'Does weather impact your business?',
          options: ['None', 'Some', 'High'],
        ),
      ],
    );
  }
}

class OperationsTeamSection extends StatelessWidget {
  const OperationsTeamSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WizardDropdown(
          label: 'Do you operate in more than one location?',
          options: ['Yes', 'No'],
        ),
        _gap,
        const WizardDropdown(
          label: 'Who works in your business day to day?',
          placeholder: 'Select option',
          options: [
            'Just me — I do everything',
            'Me plus 1 to 3 people',
            'Small team of 4 to 10',
            'Team of 11 to 25',
            'More than 25 people',
          ],
        ),
        _gap,
        const WizardDropdown(
          label: 'How are most of your workers paid?',
          placeholder: 'Select option',
          options: ['Hourly', 'Salary', 'Commission', 'Mixed'],
        ),
        _gap,
        const WizardTextField(
          label: 'What are your typical hours of operation?',
          hint: 'e.g. Mon-Fri, 9am-5pm',
        ),
        _gap,
        const PillChoiceGroup(
          label: 'What usually limits your growth the most right now?',
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
        _gap,
        const WizardDropdown(
          label:
              'Do you rely heavily on any single supplier or vendor to operate?',
          placeholder: 'Select option',
          options: [
            'Yes, heavily — losing them would seriously disrupt us',
            'We have key suppliers but alternatives exist',
            'No significant dependencies',
          ],
        ),
        _gap,
        const WizardDropdown(
          label: 'Do you use a point of sale system?',
          options: ['Yes', 'No'],
        ),
        _gap,
        const WizardDropdown(
          label: 'Do you own or lease your main business space?',
          options: [
            'Own it',
            'Lease it',
            'Work from home or from a vehicle',
            'Multiple locations — varies',
          ],
        ),
        _gap,
        const PillChoiceGroup(
          label:
              'Which of these do you currently use to run your business? '
              '(Select all that apply)',
          multiSelect: true,
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
      ],
    );
  }
}

class CapacityConstraintsSection extends StatelessWidget {
  const CapacityConstraintsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WizardTextField(
          label: 'Roughly how many customers or jobs do you handle per month?',
          hint: 'Enter estimate',
          keyboardType: TextInputType.number,
        ),
        _gap,
        const WizardDropdown(
          label:
              'Looking back, do you feel like you could have handled more if needed?',
          placeholder: 'Select option',
          options: [
            'Yes, we had plenty of room',
            'Maybe a little more but not much',
            'No, we were at our limit',
            'Hard to say',
          ],
        ),
        _gap,
        const PillChoiceGroup(
          label: 'How busy are you on average right now?',
          options: [
            'Often below capacity',
            'Around capacity',
            'Frequently stretched',
            'Regularly turning work away',
          ],
        ),
        _gap,
        const PillChoiceGroup(
          label: 'What usually slows you down the most?',
          options: [
            'Labor',
            'Equipment',
            'Materials',
            'Permits',
            'Demand',
            'Other',
          ],
        ),
        _gap,
        const WizardDropdown(
          label:
              'Do you currently have any business loans, equipment '
              'financing, or lines of credit?',
          placeholder: 'Select option',
          options: ['Yes', 'No', 'Not sure'],
        ),
      ],
    );
  }
}

class SalesMarketingSection extends StatelessWidget {
  const SalesMarketingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PillChoiceGroup(
          label: 'How do customers usually find you? (Select all that apply)',
          multiSelect: true,
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
        _gap,
        const PillChoiceGroup(
          label: 'How do you usually sell or deliver your product or service?',
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
        _gap,
        const WizardDropdown(
          label: 'Do you track leads or customers anywhere?',
          options: ['No', 'Spreadsheet', 'CRM'],
        ),
        _gap,
        const WizardTextField(
          label:
              'Roughly what percentage of leads turn into paying customers? (Estimate)',
          hint: 'e.g. 20%',
        ),
        _gap,
        const WizardTextField(
          label: 'Do you have a rough monthly marketing budget? (Optional)',
          hint: 'e.g. 5000',
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}

class HiringTeamStructureSection extends StatelessWidget {
  const HiringTeamStructureSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WizardTextArea(
          label: 'What are the main job roles on your team?',
          hint: 'List the main roles',
          minLines: 2,
        ),
        _gap,
        const WizardDropdown(
          label: 'Are you planning to hire in the next 12 months?',
          options: ['Yes', 'No'],
        ),
        _gap,
        const PillChoiceGroup(
          label: 'How do you usually find new employees?',
          options: [
            'Job boards',
            'Referrals',
            'Recruiters',
            'Social media',
            'Walk-ins',
            'Other',
          ],
        ),
        _gap,
        const WizardDropdown(
          label: 'Do you regularly use contractors or freelance help?',
          options: ['Yes', 'No', 'Sometimes'],
        ),
      ],
    );
  }
}

class FinancialSystemsSection extends StatelessWidget {
  const FinancialSystemsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WizardDropdown(
          label: 'Which accounting system do you use?',
          options: ['QuickBooks', 'Xero', 'Sage', 'Other', 'None'],
        ),
        _gap,
        const WizardDropdown(
          label: 'Would you like to connect your accounting system now?',
          options: ['Yes', 'No', 'Later'],
        ),
        _gap,
        const WizardDropdown(
          label: 'When does your fiscal year start?',
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
        _gap,
        const WizardTextField(
          label: 'Do you work with any banks or lenders? (Optional)',
          hint: 'List any banks or lenders',
        ),
        _gap,
        const WizardDropdown(
          label:
              'Have you ever taken out a business loan, SBA loan, or line of credit?',
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
  }
}

class PricingRevenueModelSection extends StatelessWidget {
  const PricingRevenueModelSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PillChoiceGroup(
          label: 'How do you usually set your prices?',
          options: [
            'Hourly',
            'Per job',
            'Per unit',
            'Subscription',
            'Retainer',
            'Mixed',
          ],
        ),
        _gap,
        const WizardTextField(
          label: "What's a typical invoice or order size? (Estimate)",
          hint: 'e.g. \$500',
        ),
        _gap,
        const WizardTextArea(
          label: 'Do you offer discounts or promotions? If so, when and how?',
          hint: 'When and how?',
          minLines: 2,
        ),
        _gap,
        const PillChoiceGroup(
          label: 'How do customers usually pay you?',
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
  }
}

class CustomersMarketSection extends StatelessWidget {
  const CustomersMarketSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WizardTextArea(
          label: 'Who are your typical customers?',
          hint: 'Describe your typical customers',
          minLines: 2,
        ),
        _gap,
        const WizardTextField(
          label: 'Roughly how many customers or jobs do you handle per month?',
          hint: 'Enter estimate',
          keyboardType: TextInputType.number,
        ),
        _gap,
        const WizardDropdown(
          label: 'Do you get repeat business?',
          options: ['Low', 'Medium', 'High'],
        ),
        _gap,
        const WizardTextArea(
          label: 'Are there specific types of customers you want more of?',
          hint: 'Describe ideal customers',
          minLines: 2,
        ),
        _gap,
        const WizardDropdown(
          label:
              'Does any single customer make up a large portion of your revenue?',
          options: [
            'Yes, one customer is a very large portion',
            'Yes, a few together are most of revenue',
            'No, spread across many',
          ],
        ),
        _gap,
        const WizardDropdown(
          label:
              'Does your business have busy seasons or is it pretty consistent year-round?',
          options: [
            'Yes, seasonal',
            'No, consistent year-round',
            'Somewhat seasonal',
          ],
        ),
        _gap,
        const WizardDropdown(
          label: 'Where do most of your customers come from?',
          options: [
            'Within a few miles of my location',
            'My city or metro area',
            'My state or broader region',
            'Across the country',
            'Internationally',
            'Both local in-person and online',
          ],
        ),
      ],
    );
  }
}

class VendorsInputsSection extends StatelessWidget {
  const VendorsInputsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WizardDropdown(
          label: 'Have you had any supplier or input cost issues recently?',
          options: ['Yes', 'No'],
        ),
        _gap,
        const WizardTextArea(
          label:
              'Are there any materials or inputs your business critically depends on?',
          hint: 'What does your business depend on?',
          minLines: 2,
        ),
      ],
    );
  }
}

class AssetsEquipmentSection extends StatelessWidget {
  const AssetsEquipmentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WizardTextArea(
          label: 'What major assets or equipment does your business rely on?',
          hint: 'List major assets',
          minLines: 2,
        ),
        _gap,
        const WizardTextArea(
          label: 'For each asset: is it owned or leased?',
          hint: 'For each: owned or leased',
          minLines: 2,
        ),
        _gap,
        const WizardTextArea(
          label: 'When was it purchased or leased?',
          hint: 'Purchase/lease dates',
          minLines: 2,
        ),
        _gap,
        const WizardTextArea(
          label: 'What condition is it in?',
          hint: 'Describe condition of each asset',
          minLines: 2,
        ),
        _gap,
        const WizardDropdown(
          label: 'If leased — what is your monthly payment?',
          options: [
            'Under \$500',
            '\$500 to \$2K',
            '\$2K to \$5K',
            'Over \$5K',
          ],
        ),
      ],
    );
  }
}

class RiskInsuranceDebtSection extends StatelessWidget {
  const RiskInsuranceDebtSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WizardDropdown(
          label: 'Do you carry business insurance?',
          options: ['Yes', 'No', 'Not sure'],
        ),
        _gap,
        const WizardTextArea(
          label:
              'Are there any customers, suppliers, or partners your business heavily depends on?',
          hint: 'Who does your business depend on heavily?',
          minLines: 2,
        ),
        _gap,
        const WizardDropdown(
          label:
              'Does any single customer make up a large portion of your revenue?',
          options: [
            'Yes, one customer is a very large portion',
            'Yes, a few together',
            'No, spread across many',
          ],
        ),
      ],
    );
  }
}

class PermitsComplianceSection extends StatelessWidget {
  const PermitsComplianceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WizardTextArea(
          label:
              'What permits, licenses, or certifications does your business currently hold?',
          hint: 'List required permits',
          minLines: 2,
        ),
        _gap,
        const WizardTextArea(
          label:
              'Are there any permits or licenses you are in the process of getting or planning to get?',
          hint: 'Describe any in progress',
          minLines: 2,
        ),
        _gap,
        const WizardTextArea(
          label:
              'Are there any local rules that affect how or when you operate?',
          hint: 'Any local rules or restrictions?',
          minLines: 2,
        ),
      ],
    );
  }
}

class StrategicGoalsSection extends StatelessWidget {
  const StrategicGoalsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PillChoiceGroup(
          label: "What's most important to you right now?",
          options: [
            'Profit',
            'Growth',
            'Stability',
            'Reduce workload',
            'Prepare to exit',
            'Other',
          ],
        ),
        _gap,
        const WizardDropdown(
          label: 'How involved do you want to be in day-to-day?',
          options: [
            'Very involved',
            'Somewhat involved',
            'Minimal involvement',
          ],
        ),
        _gap,
        const WizardDropdown(
          label: 'How comfortable are you with taking financial risks?',
          options: ['Conservative', 'Moderate', 'Aggressive'],
        ),
        _gap,
        const WizardTextArea(
          label: 'What are your main goals for the next 12 months?',
          hint: 'Describe your goals',
          minLines: 2,
        ),
        _gap,
        const WizardTextArea(
          label: 'Where would you like the business to be in about 3 years?',
          hint: '3-year vision',
          minLines: 2,
        ),
        _gap,
        const WizardTextArea(
          label: "What's your long-term vision for the business?",
          hint: 'Long-term vision',
          minLines: 2,
        ),
        _gap,
        const WizardTextArea(
          label:
              'Do you have an eventual exit goal? If so, what does it look like?',
          hint: 'Describe your exit strategy if any',
          minLines: 2,
        ),
      ],
    );
  }
}
