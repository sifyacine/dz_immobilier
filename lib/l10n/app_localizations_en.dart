// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'DZ Immobilier';

  @override
  String get appTagline => 'The Algerian real-estate market';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonBack => 'Back';

  @override
  String get commonNext => 'Next';

  @override
  String get commonSave => 'Save';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonClose => 'Close';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonLoading => 'Loading…';

  @override
  String get commonError => 'Something went wrong';

  @override
  String get commonSeeAll => 'See all';

  @override
  String get commonRestart => 'Start over';

  @override
  String get commonSubmit => 'Submit';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonShare => 'Share';

  @override
  String get commonPublish => 'Publish';

  @override
  String get commonFilters => 'Filters';

  @override
  String get commonSort => 'Sort';

  @override
  String get commonRequired => 'This field is required';

  @override
  String get commonFieldInvalid => 'Invalid value';

  @override
  String get commonNetworkError => 'Check your internet connection';

  @override
  String get commonOffline => 'You are offline';

  @override
  String get commonSoonAvailable => 'Coming soon';

  @override
  String commonItemCount(num count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString properties',
      one: '1 property',
      zero: 'No properties',
    );
    return '$_temp0';
  }

  @override
  String commonWelcome(String name) {
    return 'Welcome, $name!';
  }

  @override
  String get navHome => 'Home';

  @override
  String get navSearch => 'Search';

  @override
  String get navPublish => 'Publish';

  @override
  String get navFavorites => 'Favorites';

  @override
  String get navAccount => 'Account';

  @override
  String get authLoginTitle => 'Welcome back!';

  @override
  String get authLoginSubtitle => 'Sign in to access your account';

  @override
  String get authRegisterTitle => 'Create an account';

  @override
  String get authForgotPasswordTitle => 'Forgot password';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authNameLabel => 'Full name';

  @override
  String get authPhoneLabel => 'Phone';

  @override
  String get authLoginBtn => 'Sign in';

  @override
  String get authRegisterBtn => 'Create my account';

  @override
  String get authForgotPasswordLink => 'Forgot your password?';

  @override
  String get authNoAccount => 'Don\'t have an account?';

  @override
  String get authAlreadyAccount => 'Already have an account?';

  @override
  String get authSignIn => 'Sign in';

  @override
  String get authSignUp => 'Sign up';

  @override
  String get authLogout => 'Sign out';

  @override
  String get authGuestCta => 'Sign in to access all features';

  @override
  String get propertiesTitle => 'Property listings';

  @override
  String get propertiesEmpty => 'No listings available at the moment';

  @override
  String get propertiesRefresh => 'Refresh';

  @override
  String get propertiesForSale => 'For sale';

  @override
  String get propertiesForRent => 'For rent';

  @override
  String get propertiesForHoliday => 'Holiday';

  @override
  String get propertyDetailTitle => 'Property details';

  @override
  String get propertyDetailAddToFavorites => 'Add to favorites';

  @override
  String get propertyDetailRemoveFromFavorites => 'Remove from favorites';

  @override
  String get propertyDetailContact => 'Contact advertiser';

  @override
  String get propertyDetailShare => 'Share this property';

  @override
  String get propertyDetailSurface => 'Surface';

  @override
  String get propertyDetailRooms => 'Rooms';

  @override
  String get propertyDetailBedrooms => 'Bedrooms';

  @override
  String get propertyDetailFloor => 'Floor';

  @override
  String propertyDetailPublishedOn(String date) {
    return 'Published on $date';
  }

  @override
  String get searchTitle => 'Search for a property';

  @override
  String get searchHint => 'Location, property type…';

  @override
  String get searchNoResults => 'No results for this search';

  @override
  String get searchFiltersTitle => 'Search filters';

  @override
  String get searchApplyFilters => 'Apply filters';

  @override
  String get searchResetFilters => 'Reset';

  @override
  String get favoritesTitle => 'My favorites';

  @override
  String get favoritesEmpty => 'No favorites yet';

  @override
  String get favoritesEmptyCta => 'Browse listings and save your favorites';

  @override
  String get profileTitle => 'My account';

  @override
  String get profileMyListings => 'My listings';

  @override
  String get profileMyBookings => 'My bookings';

  @override
  String get profileMyAlerts => 'My alerts';

  @override
  String get profileSettings => 'Settings';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileHelp => 'Help & support';

  @override
  String get profileAbout => 'About DZ Immobilier';

  @override
  String get estimationTitle => 'Estimate in 30 seconds';

  @override
  String get estimationSubtitle => 'Instant answer in 4 questions';

  @override
  String get estimationRestart => 'Start over';

  @override
  String get estimationStepLocation => 'STEP 1 · LOCATION';

  @override
  String get estimationStepType => 'STEP 2 · PROPERTY TYPE';

  @override
  String get estimationStepSurface => 'STEP 3 · SURFACE';

  @override
  String get estimationStepHighlights => 'STEP 4 · HIGHLIGHTS';

  @override
  String get estimationStepContact => 'LAST STEP · CONTACT';

  @override
  String get estimationSeeResult => 'See my estimate';

  @override
  String get simulationTitle => 'Simulate your financing';

  @override
  String get simulationSubtitle => 'Find the loan that fits your profile';

  @override
  String get simulationStepType => 'STEP 1 · PROPERTY TYPE';

  @override
  String get simulationStepBudget => 'STEP 2 · BUDGET';

  @override
  String get simulationStepIncome => 'STEP 3 · INCOME';

  @override
  String get simulationStepContact => 'LAST STEP · CONTACT';

  @override
  String get simulationSeeOffers => 'View offers';

  @override
  String get simulationCalculate => 'Calculate my offers';

  @override
  String get simulationResultTitle => 'Your financing offers';

  @override
  String get simulationNewSimulation => 'New simulation';

  @override
  String get simulationConfirmation =>
      'Request sent — a DZ-Immobilier advisor will contact you within 24 hours.';

  @override
  String get settingsLanguageTitle => 'Choose language';

  @override
  String get settingsLanguageFr => 'Français';

  @override
  String get settingsLanguageAr => 'عربي';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get commonOr => 'or';

  @override
  String get commonClear => 'Clear';

  @override
  String get commonAll => 'All';

  @override
  String get commonAllF => 'All';

  @override
  String get commonApply => 'Apply';

  @override
  String get commonErrorTitle => 'Error';

  @override
  String get commonPerMonth => '/mo';

  @override
  String get authRegisterSubtitle => 'Join DZ Immobilier in seconds.';

  @override
  String get authForgotPasswordSubtitle =>
      'Enter your email to receive a reset link.';

  @override
  String get authEmailHint => 'example@email.com';

  @override
  String get authNameHint => 'Your first and last name';

  @override
  String get authPhoneHint => '06 XX XX XX XX';

  @override
  String get authConfirmPasswordLabel => 'Confirm password';

  @override
  String get authSendResetLink => 'Send link';

  @override
  String get authBackToLogin => 'Back to sign in';

  @override
  String get authResetSentTitle => 'Email sent!';

  @override
  String authResetSentBody(String email) {
    return 'A reset link has been sent to $email. Check your inbox.';
  }

  @override
  String get valEmailRequired => 'Email required';

  @override
  String get valEmailInvalid => 'Invalid email';

  @override
  String get valPasswordRequired => 'Password required';

  @override
  String get valPasswordMin => 'At least 8 characters';

  @override
  String get valPhoneRequired => 'Phone required';

  @override
  String get valPhoneInvalid => 'Invalid number';

  @override
  String get valNameRequired => 'Name is required';

  @override
  String get valConfirmRequired => 'Confirmation required';

  @override
  String get valPasswordMismatch => 'Passwords do not match';

  @override
  String get homeEstimationAction => 'Estimate';

  @override
  String get homeEstimationSubtitle => 'Value of your property';

  @override
  String get homeSimulationAction => 'Simulation';

  @override
  String get homeSimulationSubtitle => 'Home loan';

  @override
  String propertiesLoadMore(int count) {
    return 'Show more ($count left)';
  }

  @override
  String get propertyBadgeSale => 'For sale';

  @override
  String get propertyBadgeRent => 'For rent';

  @override
  String propertyCardSpecs(int rooms, int area) {
    return '$rooms rms · $area m²';
  }

  @override
  String get searchBarHint => 'Wilaya, neighborhood, keyword…';

  @override
  String get searchRecent => 'Recent searches';

  @override
  String get searchPopularCities => 'Popular cities';

  @override
  String get searchAllListings => 'All listings';

  @override
  String searchResultsCount(num count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString properties found',
      one: '1 property found',
      zero: 'No properties found',
    );
    return '$_temp0';
  }

  @override
  String get searchNoResultsTitle => 'No results';

  @override
  String get searchNoResultsBody =>
      'We couldn\'t find any property matching your search criteria.';

  @override
  String get searchResetFiltersBtn => 'Reset filters';

  @override
  String get searchDetailSoon => 'Property details coming soon.';

  @override
  String get filterTransactionType => 'Transaction type';

  @override
  String get filterCategory => 'Category';

  @override
  String get filterWilaya => 'Wilaya';

  @override
  String get filterBudget => 'Budget (DA)';

  @override
  String get filterPriceMin => 'Min price';

  @override
  String get filterPriceMax => 'Max price';

  @override
  String get filterPriceMinHint => 'e.g. 10,000,000';

  @override
  String get filterPriceMaxHint => 'e.g. 80,000,000';

  @override
  String get filterBedroomsMin => 'Min bedrooms';

  @override
  String get filterAreaMin => 'Min area (m²)';

  @override
  String get filterAreaHint => 'e.g. 80';

  @override
  String get propertyTypeApartment => 'Apartment';

  @override
  String get propertyTypeVilla => 'Villa';

  @override
  String get propertyTypeLand => 'Land';

  @override
  String get propertyTypeStudio => 'Studio';

  @override
  String commonStepProgress(int current, int total) {
    return 'Step $current / $total';
  }

  @override
  String get commonSelect => 'Select';

  @override
  String commonYears(int count) {
    return '$count yrs';
  }

  @override
  String get simStep1Prefix => 'Simulate your';

  @override
  String get simStep1Accent => 'financing.';

  @override
  String get simStep2Prefix => 'What is your';

  @override
  String get simStep2Accent => 'budget?';

  @override
  String get simStep3Prefix => 'Tell us';

  @override
  String get simStep3Accent => 'about you.';

  @override
  String get simStep4Prefix => 'An advisor';

  @override
  String get simStep4Accent => 'calls you back.';

  @override
  String get simSelectPropertyType => 'SELECT THE PROPERTY TYPE';

  @override
  String get simInfoAnalysisBody =>
      'analyzes local market data before every recommendation — rates, terms and eligibility conditions adjusted in real time to your profile.';

  @override
  String get simStateProgramQuestion => 'Is this a State program?';

  @override
  String get simStateYes => 'Yes (LPP, LPA, LSP)';

  @override
  String get simStateNo => 'No (Open market)';

  @override
  String get simStateNote =>
      '*The 1% or 3% rate only applies to approved programs.';

  @override
  String get simPropertyPriceLabel => 'PROPERTY PRICE (DZD)';

  @override
  String get simPropertyPriceHint => '15,000,000';

  @override
  String get simDownPaymentLabel => 'YOUR DOWN PAYMENT (DZD)';

  @override
  String get simDownPaymentHint => '3,000,000';

  @override
  String get simLeverageTitle => 'Down-payment leverage:';

  @override
  String get simLeverageMin =>
      'Minimum legal down payment: 10% of the property price (Bank of Algeria regulation).';

  @override
  String get simLeverageRec =>
      'Recommended down payment: 20% to 30% for optimal terms.';

  @override
  String get simLeverageEff =>
      'Quantified effect: on a 10M DZD property, going from 10% to 30% down saves ~2.5M DZD in total cost over 20 years.';

  @override
  String get simMonthlyIncomeLabel => 'NET MONTHLY INCOME (DZD)';

  @override
  String get simIncomeHint => '120,000';

  @override
  String get simAgeLabel => 'AGE';

  @override
  String get simAgeHint => '35';

  @override
  String get simEmploymentTypeLabel => 'EMPLOYMENT TYPE';

  @override
  String get simEmpSalaried => 'Employee';

  @override
  String get simEmpCivilServant => 'Civil servant';

  @override
  String get simEmpSelfEmployed => 'Self-employed';

  @override
  String get simEmpBusinessOwner => 'Business owner';

  @override
  String get simStateTiersTitle => 'State aid tiers:';

  @override
  String get simIncomeTier1 => 'Income ≤ 108,000 DZD → 1% rate';

  @override
  String get simIncomeTier2 => 'Income ≤ 216,000 DZD → 3% rate';

  @override
  String get simIncomeAboveMarket => 'Above → open-market financing (~6.25%)';

  @override
  String get simAgeLimitTitle => 'Regulatory age limit:';

  @override
  String simAgeLimitBody(int term) {
    return 'Age at loan end cannot exceed 75 (Bank of Algeria). At your age, the maximum loan term is $term years.';
  }

  @override
  String get simFullNameLabel => 'FULL NAME';

  @override
  String get simFullNameHint => 'Mohamed Amine';

  @override
  String get simPhoneLabel => 'PHONE';

  @override
  String get simPhoneHint => '+213 5XX XX XX XX · +33 6 XX XX XX XX';

  @override
  String get simEmailLabel => 'EMAIL (OPTIONAL)';

  @override
  String get simEmailHint => 'contact@email.dz';

  @override
  String get simPrivacyNotice =>
      'Your data is confidential and used only to send you your personalized simulation. No marketing communication without your consent.';

  @override
  String get simResultSubtitle =>
      'Personalized simulation based on your profile';

  @override
  String get simResultLoading => 'Calculating your offers…';

  @override
  String get simResultBadge => 'RESULTS · EDUCATIONAL COMPARISON';

  @override
  String get simDuelPrefix => 'The Duel:';

  @override
  String get simDuelAccent => 'Conventional\nvs Mourabaha.';

  @override
  String get simLoanConventional => 'CONVENTIONAL LOAN';

  @override
  String get simLoanMourabaha => 'ISLAMIC MOURABAHA';

  @override
  String get simDaPerMonth => 'DA/mo';

  @override
  String get simRateLabel => 'Rate:';

  @override
  String get simDurationLabel => 'Term:';

  @override
  String simDurationValue(int years, int months) {
    return '$years yrs ($months payments)';
  }

  @override
  String get simTotalInterest => 'Total interest';

  @override
  String get simTotalMargin => 'Total margin';

  @override
  String get simHowItWorks => 'ℹ️ How does it work?';

  @override
  String get simHowConventional =>
      'The bank lends you money. You repay the principal + interest calculated on the remaining balance each month (compound interest method).';

  @override
  String get simHowMourabaha =>
      'The bank buys the property for you, then resells it to you with a margin known in advance. No variable Riba. Legal structure: purchase-resale contract.';

  @override
  String get simExpertAnalysis => 'DZ-Immobilier Expert Analysis';

  @override
  String simExpertBody(String gap) {
    return 'The gap between the two models is $gap for the Mourabaha compared to the conventional loan.\nConclusion: While the final cost is often close, the legal structure is fundamentally different: the conventional loan is a money-lending contract (Qard), while the Mourabaha is a purchase-resale contract (Bay\'). This choice depends as much on your personal convictions as on your financial calculation.';
  }

  @override
  String get simDebtRatioLabel => 'Debt ratio';

  @override
  String get simDebtExceeded =>
      'Debt capacity exceeded. Solutions: increase the down payment, extend the term, or add a co-borrower.';

  @override
  String get simBankOffersTitle => 'Offers by partner bank';

  @override
  String get simBankColumn => 'Bank';

  @override
  String get simRateColumn => 'Rate';

  @override
  String get simMonthlyColumn => 'Monthly';

  @override
  String simRateAnnual(int rate) {
    return '$rate% annual';
  }

  @override
  String mapResultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count listings',
      one: '1 listing',
    );
    return '$_temp0';
  }

  @override
  String mapOffMap(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count listings without location',
      one: '1 listing without location',
    );
    return '$_temp0';
  }

  @override
  String get homeRecentListings => 'Recent listings';

  @override
  String get homeViewMap => 'Map';

  @override
  String get homeSearchShortcut => 'Search for a property…';
}
