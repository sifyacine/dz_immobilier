/// API base URL, timeouts and endpoint paths.
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://www.dz-immobilier.com';
  static const String db = 'dzimmobilier';

  // Shared read-only "browse" account used to view public listings.
  //
  // Odoo's ORM (`/web/dataset/call_kw`) requires an authenticated session —
  // the anonymous website session carries no `uid`, so listing queries fail
  // with SessionExpiredException. There is currently no public listings JSON
  // endpoint (the documented `/api/marketplace/v1/search` returns 404 in prod),
  // so guests browse via this shared account until the backend exposes one.
  // TODO: replace with a dedicated, least-privilege browse user (or a real
  // public endpoint) before release — credentials in the binary are a known
  // tradeoff.
  static const String browseLogin = 'yacineprom2003@gmail.com';
  static const String browsePassword = 'Qwerty!23456';

  // Web-only flows the app deep-links to (no native screen yet).
  static const String agencySignupUrl =
      'https://www.dz-immobilier.com/agence/signup';

  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Standard Odoo session auth
  static const String login = '/web/session/authenticate';
  static const String signup = '/web/signup';
  static const String logout = '/web/session/destroy';
  static const String resetPassword = '/web/reset_password';
  static const String sessionInfo = '/web/session/get_session_info';
  static const String changePassword = '/web/session/change_password';

  // Standard Odoo ORM
  static const String callKw = '/web/dataset/call_kw';

  // Picker (wilayas, communes, countries)
  static const String pickWilayas = '/api/picker/wilayas';
  static const String pickCommunes = '/api/picker/communes';
  static const String pickCountries = '/api/picker/countries';

  // Marketplace
  static const String marketplaceSearch = '/api/marketplace/v1/search';
  static const String marketplaceLead = '/api/marketplace/v1/lead';
  static const String wishlistToggle = '/api/wishlist/v1/toggle';
  static const String wishlistList = '/api/wishlist/v1/list';

  // Intelligence (dynamic form schema)
  static const String intelligenceFormSchema = '/api/intelligence/v1/form_schema';

  // Credit / Simulation
  static const String creditPropertyCategories = '/credit/property_categories';
  static const String creditCalculate = '/credit/calculate';
  static const String creditSubmitLead = '/credit/submit_lead';
  static const String creditCompareAll = '/credit/compare_all';

  // Valuation
  static const String valuationWilayas = '/api/valuation/v1/wilayas';
  static const String valuationCommunes = '/api/valuation/v1/communes';
  static const String valuationCategories = '/api/valuation/v1/categories';
  static const String valuationSpeed30Categories = '/api/valuation/v1/speed30_categories';
  static const String valuationQuickEstimate = '/api/valuation/v1/quick_estimate';
  static const String valuationSubmit = '/api/valuation/v1/submit';
  static const String valuationOwnerEstimateAfter = '/api/valuation/v1/owner_estimate_after';
}
