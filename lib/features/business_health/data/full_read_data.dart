import 'package:flutter/material.dart';
import '../theme/business_health_colors.dart';
import '../model/businessHealthOverviewModel.dart';

class ReadItemData {
  const ReadItemData({
    required this.title,
    required this.body,
    this.possibleCauses,
    this.whyNowText,
    this.actionLabel = 'DO THIS',
    required this.actionBody,
  });

  final String title;
  final String body;
  final List<String>? possibleCauses;
  final String? whyNowText;
  final String actionLabel;
  final String actionBody;
}

class ReadCategoryData {
  const ReadCategoryData({
    required this.tabLabel,
    required this.badgeText,
    required this.badgeColor,
    required this.cardTitle,
    required this.countLabel,
    required this.items,
  });

  final String tabLabel;
  final String badgeText;
  final Color badgeColor;
  final String cardTitle;
  final String countLabel;
  final List<ReadItemData> items;

  int get count => items.length;
}

// mutable now — populated from the API response
List<ReadCategoryData> fullReadCategories = [];

void applyBusinessHealthToFullRead(BusinessHealthOverviewData data) {
  final positives = data.driversDisplay.positives
      .map(
        (d) => ReadItemData(
          title: d.headline,
          body: d.description,
          actionBody: d.recommendedAction,
        ),
      )
      .toList();

  final drags = data.driversDisplay.drags
      .map(
        (d) => ReadItemData(
          title: d.headline,
          body: d.description,
          actionBody: d.recommendedAction,
        ),
      )
      .toList();

  final watches = data.watchAreas
      .map(
        (w) => ReadItemData(
          title: w.title,
          body: w.description,
          possibleCauses: w.possibleCauses
              .map((c) => '${c.cause} — ${c.evidence}')
              .toList(),
          actionBody: w.recommendedAction,
        ),
      )
      .toList();

  final alerts = data.activeAlerts
      .map(
        (a) => ReadItemData(
          title: a.description,
          body: '',
          whyNowText: a.urgencyContext,
          actionBody: a.recommendedAction,
        ),
      )
      .toList();

  fullReadCategories = [
    ReadCategoryData(
      tabLabel: 'Working for you',
      badgeText: 'WORKING',
      badgeColor: BusinessHealthColors.dotGood,
      cardTitle: 'Working for you',
      countLabel: 'items',
      items: positives,
    ),
    ReadCategoryData(
      tabLabel: 'Dragging you down',
      badgeText: 'DRAGGING',
      badgeColor: BusinessHealthColors.warnColor,
      cardTitle: 'Dragging you down',
      countLabel: 'items',
      items: drags,
    ),
    ReadCategoryData(
      tabLabel: 'Watch areas',
      badgeText: 'WATCH',
      badgeColor: BusinessHealthColors.warnColor,
      cardTitle: 'Priority watch areas',
      countLabel: 'watches',
      items: watches,
    ),
    ReadCategoryData(
      tabLabel: 'Alerts',
      badgeText: 'ACT NOW',
      badgeColor: BusinessHealthColors.negativeText,
      cardTitle: 'Active health alerts',
      countLabel: 'active',
      items: alerts,
    ),
  ];
}