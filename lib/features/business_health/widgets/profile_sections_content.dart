import 'package:flutter/material.dart';

import 'form_controls.dart';

/// Spacing helper used between question blocks within a section.
const _gap = SizedBox(height: 16);

class ProvenCapabilitiesContent extends StatelessWidget {
  const ProvenCapabilitiesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const QuestionLabel(
          text: 'Which of the following does your business already do today?',
          note: '(Select only activities that are currently operational)',
        ),
        const SizedBox(height: 8),
        const CheckboxRow(label: 'In-person / on-site sales'),
        const CheckboxRow(label: 'Online direct-to-consumer sales'),
        const CheckboxRow(label: 'Catering or bulk orders'),
        const CheckboxRow(label: 'Delivery (owned or third-party)'),
        const CheckboxRow(label: 'On-site events or pop-ups'),
        const CheckboxRow(label: 'Wholesale / B2B sales'),
        const CheckboxRow(label: 'Custom orders or projects'),
        const CheckboxRow(
          label: 'Subscription / retainer / recurring programs',
        ),
        _gap,
        const Text(
          'For each selected capability:',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
          ),
        ),
        _gap,
        const QuestionLabel(text: '1. How often do you do this?'),
        const SizedBox(height: 4),
        const RadioOptionGroup(
          options: ['Regularly', 'Occasionally', 'Rarely'],
        ),
        _gap,
        const QuestionLabel(text: '2. How long have you been doing this?'),
        const SizedBox(height: 4),
        const RadioOptionGroup(
          options: ['<6 months', '6-12 months', '1-2 years', '2+ years'],
        ),
        _gap,
        const QuestionLabel(text: '3. When was the last time you did this?'),
        const SizedBox(height: 4),
        const RadioOptionGroup(
          options: ['<1 month', '1-3 months', '3-6 months', '6+ months'],
        ),
        _gap,
        const QuestionLabel(text: '4. Is this profitable today?'),
        const SizedBox(height: 4),
        const RadioOptionGroup(options: ['Yes', 'Mixed', 'Unsure']),
      ],
    );
  }
}

class PermitsCertificationsContent extends StatelessWidget {
  const PermitsCertificationsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const QuestionLabel(
          text:
              'Which permits, licenses, or certifications does your '
              'business currently hold?',
          note: '(Select only those that are active and valid today)',
        ),
        const SizedBox(height: 8),
        const CheckboxRow(label: 'Food service / health permit'),
        const CheckboxRow(label: 'Alcohol license – On-premise'),
        const CheckboxRow(label: 'Alcohol license – Off-premise'),
        const CheckboxRow(label: 'Alcohol license – Both'),
        const CheckboxRow(label: 'Mobile vending permit'),
        const CheckboxRow(label: 'Event insurance coverage'),
        const CheckboxRow(label: 'Product liability insurance'),
        const CheckboxRow(label: 'General contractor / trades license'),
        const CheckboxRow(label: 'Professional certification (CPA, etc.)'),
        const CheckboxRow(label: 'Industry-specific certification'),
        _gap,
        const QuestionLabel(
          text: 'For the permits/licenses selected, are they:',
        ),
        const SizedBox(height: 4),
        const RadioOptionGroup(
          options: [
            'Location-specific only',
            'Transferable to other locations/events',
            'Mixed',
          ],
        ),
      ],
    );
  }
}

class AssetsResourcesContent extends StatelessWidget {
  const AssetsResourcesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const QuestionLabel(
          text: 'Equipment already used off-site (not just own):',
        ),
        const SizedBox(height: 8),
        const CheckboxRow(label: 'Portable payment processing (Square, etc.)'),
        const CheckboxRow(label: 'Display / booth / setup equipment'),
        const CheckboxRow(label: 'Production or service equipment'),
        _gap,
        const QuestionLabel(
          text: 'Do you have reliable access to a vehicle for off-site work?',
        ),
        const SizedBox(height: 4),
        const RadioOptionGroup(
          options: [
            'Yes, owned',
            'Yes, regular access (borrowed/rented)',
            'No',
          ],
        ),
        _gap,
        const QuestionLabel(
          text:
              'How many staff have worked outside normal hours in the '
              'past 6 months?',
        ),
        const SizedBox(height: 4),
        const RadioOptionGroup(
          options: ['None', '1-2 people', '3-5 people', '6+ people'],
        ),
        _gap,
        const QuestionLabel(
          text: 'Approximate size of your customer list or database:',
        ),
        const SizedBox(height: 4),
        const RadioOptionGroup(
          columns: 2,
          options: [
            'None',
            '<100',
            '100-500',
            '500-2,000',
            '2,000-10,000',
            '10,000+',
          ],
        ),
      ],
    );
  }
}

class OperationalFlexibilityContent extends StatelessWidget {
  const OperationalFlexibilityContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const QuestionLabel(
          text:
              'Minimum notice you typically need to adjust schedule or '
              'staffing:',
        ),
        const SizedBox(height: 4),
        const RadioOptionGroup(
          options: ['Same day', '2-3 days', '1 week', '2+ weeks'],
        ),
        _gap,
        const QuestionLabel(
          text:
              'Are you currently under any agreements that limit new activities?',
          note:
              '(e.g., vendor exclusivity, non-compete, minimum volume '
              'commitments)',
        ),
        const SizedBox(height: 4),
        const RadioOptionGroup(options: ['Yes', 'No', 'Unsure']),
        _gap,
        const QuestionLabel(
          text:
              'Can you pause or exit new activities with less than 1 week notice?',
        ),
        const SizedBox(height: 4),
        const RadioOptionGroup(options: ['Yes', 'No', 'Depends']),
      ],
    );
  }
}

class BusinessStructureContent extends StatelessWidget {
  const BusinessStructureContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        QuestionLabel(text: 'Business structure:'),
        SizedBox(height: 4),
        RadioOptionGroup(
          options: [
            'Independent owner',
            'Franchise (corporate approval required for new channels)',
            'Licensed operator (restrictions may apply)',
            'Other',
          ],
        ),
      ],
    );
  }
}

class TransactionVolumeContent extends StatelessWidget {
  const TransactionVolumeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const QuestionLabel(text: 'Typical transactions per period:'),
        const SizedBox(height: 4),
        const RadioOptionGroup(
          columns: 2,
          options: ['<10', '10-50', '50-200', '200-500', '500+'],
        ),
        _gap,
        const QuestionLabel(text: 'Period:'),
        const SizedBox(height: 4),
        const RadioOptionGroup(columns: 3, options: ['Day', 'Week', 'Month']),
        _gap,
        const QuestionLabel(text: 'Primary fulfillment method:'),
        const SizedBox(height: 4),
        const RadioOptionGroup(
          options: [
            'In-person service/sales',
            'Shipped physical products',
            'Digital delivery',
            'Mixed',
          ],
        ),
      ],
    );
  }
}

class ProductionCapabilitiesContent extends StatelessWidget {
  const ProductionCapabilitiesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const QuestionLabel(
          text: 'For food businesses, production capabilities:',
        ),
        const SizedBox(height: 4),
        const RadioOptionGroup(
          options: [
            'Commercial kitchen (owned)',
            'Commercial kitchen (shared/rented)',
            'Commissary access',
            'Mobile kitchen (truck/trailer)',
            'Home kitchen only',
            'Not applicable',
          ],
        ),
        _gap,
        const QuestionLabel(
          text:
              'For other businesses, primary production/service '
              'environment:',
        ),
        const SizedBox(height: 4),
        const RadioOptionGroup(
          options: [
            'Owned facility',
            'Shared/rented workspace',
            'Client location only',
            'Remote/digital only',
            'Mixed',
          ],
        ),
      ],
    );
  }
}
