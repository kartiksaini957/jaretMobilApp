class ApiConstants {
  static const String baseUrl = "https://api.lightsignal.app";

  static const String apiBaseUrl = "$baseUrl/api";

  static const String login = "$baseUrl/auth/login";

  static const String authMe = "$baseUrl/auth/me";

  static const String quickbooksLogin = "$baseUrl/quickbooks/login";

  static const String refreshToken = "$baseUrl/auth/refresh";

  static const String forgotPassword = "$baseUrl/auth/forgot-password";

  static const String signup = "$apiBaseUrl/signup/mobile";

  static const String dashboardReminders = "$apiBaseUrl/dashboard/reminders";

  static const String dashboard = "$apiBaseUrl/ai/dashboard-insights";

  static const String dashboardAlerts = "$apiBaseUrl/dashboard/alerts";

  static const String dashboardNumber = "$apiBaseUrl/dashboard/kpis";

  static const String dashboardNumberdetail =
      "$apiBaseUrl/dashboard/kpi-explain";

  static const String opportunities =
      "$apiBaseUrl/opportunities/research-scout";

  // static const String demandForecast = "$apiBaseUrl/demand-forecast";
  static const String dashboardAsk = "$apiBaseUrl/dashboard/ask";

  static const String dashboardChats = "$apiBaseUrl/dashboard/chats";
  static String dashboardChatDetail(String chatId) =>
      "$apiBaseUrl/dashboard/chats/$chatId";

  static const String settingsGeneral = "$apiBaseUrl/settings/general";

  static const String settingsPrivacy = "$apiBaseUrl/settings/privacy";

  static const String accountDelete = "$apiBaseUrl/account/delete";

  static const String diagnosticsExport = "$apiBaseUrl/diagnostics/export";

  static const String consents = "$apiBaseUrl/consents";

  static const String settingsNotifications =
      "$apiBaseUrl/settings/notifications";

  static const String notificationsTest = "$apiBaseUrl/notifications/test";

  static const String sessions = "$apiBaseUrl/sessions";

  static String sessionRevoke(String sessionId) =>
      "$apiBaseUrl/sessions/$sessionId";

  static const String sessionsRevokeAll = "$apiBaseUrl/sessions/revoke-all";

  static const String team = "$apiBaseUrl/team";
  static const String teamInvite = "$apiBaseUrl/team/invite";
  static String teamRemove(String memberId) => "$apiBaseUrl/team/$memberId";
  static const String shareLinks = "$apiBaseUrl/share-links";

  static const String classifierRun = "$apiBaseUrl/classifier/run";
  static String correctionUndo(String correctionId) =>
      "$apiBaseUrl/corrections/$correctionId/undo";
  static const String livingSummary = "$apiBaseUrl/living-summary";

  static const String demandForecast = "$apiBaseUrl/demand-forecast";
  static const String demandForecastActionsComplete =
      "$apiBaseUrl/demand-forecast/actions/complete";

  static const String financialOverview = "$apiBaseUrl/financial-overview";

  static const String businessHealthOverview =
      "$apiBaseUrl/ai/health/full"; // ⚠️ confirm exact path

      static const String healthRefresh = "$apiBaseUrl/ai/health/refresh";

      static const String opportunitiesOverview = "$apiBaseUrl/opportunities/overview";

      static String opportunityStatus(String opportunityId) =>
    "$apiBaseUrl/opportunities/$opportunityId/status";

  static String financialInsightSnooze(String insightId) =>
      "$apiBaseUrl/financial-overview/insights/$insightId/snooze";

  static String financialInsightAcknowledge(String insightId) =>
      "$apiBaseUrl/financial-overview/insights/$insightId/acknowledge";

  static const String businessProfileNotes = "$baseUrl/business-profile/notes";
  static String businessProfileNoteDelete(String noteId) =>
      "$baseUrl/business-profile/notes/$noteId";
  static const String businessProfileRichness =
      "$baseUrl/business-profile/richness";
  static const String businessProfileOnboarding =
      "$baseUrl/business-profile/onboarding";
  static const String documents = "$baseUrl/documents/";
  static String documentReview(String documentId) =>
      "$baseUrl/documents/$documentId/review";
  static String documentDownload(String documentId, {String version = 'original'}) =>
      "$baseUrl/documents/$documentId/download?version=$version";
  static String documentDelete(String documentId) =>
      "$baseUrl/documents/$documentId";
  static const String documentUpload = "$baseUrl/documents/upload";
  static const String integrationsStatus = "$apiBaseUrl/integrations/status";
  static const String integrationsConnect = "$apiBaseUrl/integrations/connect";
  static const String integrationsDisconnect =
      "$apiBaseUrl/integrations/disconnect";
  static const String scenario = "$apiBaseUrl/opportunities/scenario";
  static const String billingInvoices = "$apiBaseUrl/billing/invoices";
  static const String billingSummary = "$apiBaseUrl/billing/summary";
  static const String billingPortal = "$apiBaseUrl/billing/portal";
  static const String backupExport = "$apiBaseUrl/backup/export";
  static const String snapshotsUnified = "$apiBaseUrl/snapshots/unified";
}
