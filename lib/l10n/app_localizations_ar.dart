// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'DZ Immobilier';

  @override
  String get appTagline => 'سوق العقارات الجزائري';

  @override
  String get commonContinue => 'متابعة';

  @override
  String get commonBack => 'رجوع';

  @override
  String get commonNext => 'التالي';

  @override
  String get commonSave => 'حفظ';

  @override
  String get commonCancel => 'إلغاء';

  @override
  String get commonClose => 'إغلاق';

  @override
  String get commonRetry => 'إعادة المحاولة';

  @override
  String get commonSearch => 'بحث';

  @override
  String get commonLoading => 'جارٍ التحميل…';

  @override
  String get commonError => 'حدث خطأ ما';

  @override
  String get commonSeeAll => 'عرض الكل';

  @override
  String get commonRestart => 'إعادة البدء';

  @override
  String get commonSubmit => 'تأكيد';

  @override
  String get commonConfirm => 'تأكيد';

  @override
  String get commonDelete => 'حذف';

  @override
  String get commonEdit => 'تعديل';

  @override
  String get commonShare => 'مشاركة';

  @override
  String get commonPublish => 'نشر';

  @override
  String get commonFilters => 'تصفية';

  @override
  String get commonSort => 'ترتيب';

  @override
  String get commonRequired => 'هذا الحقل مطلوب';

  @override
  String get commonFieldInvalid => 'قيمة غير صحيحة';

  @override
  String get commonNetworkError => 'تحقق من اتصالك بالإنترنت';

  @override
  String get commonOffline => 'أنت غير متصل';

  @override
  String get commonSoonAvailable => 'قريباً';

  @override
  String commonItemCount(num count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString عقار',
      many: '$countString عقاراً',
      few: '$countString عقارات',
      two: 'عقاران',
      one: 'عقار واحد',
      zero: 'لا توجد عقارات',
    );
    return '$_temp0';
  }

  @override
  String commonWelcome(String name) {
    return 'مرحباً، $name!';
  }

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navSearch => 'بحث';

  @override
  String get navPublish => 'نشر';

  @override
  String get navFavorites => 'المفضلة';

  @override
  String get navAccount => 'حسابي';

  @override
  String get authLoginTitle => 'مرحباً بعودتك!';

  @override
  String get authLoginSubtitle => 'سجّل دخولك للوصول إلى حسابك';

  @override
  String get authRegisterTitle => 'إنشاء حساب';

  @override
  String get authForgotPasswordTitle => 'نسيت كلمة المرور';

  @override
  String get authEmailLabel => 'البريد الإلكتروني';

  @override
  String get authPasswordLabel => 'كلمة المرور';

  @override
  String get authNameLabel => 'الاسم الكامل';

  @override
  String get authPhoneLabel => 'الهاتف';

  @override
  String get authLoginBtn => 'تسجيل الدخول';

  @override
  String get authRegisterBtn => 'إنشاء حسابي';

  @override
  String get authForgotPasswordLink => 'نسيت كلمة المرور؟';

  @override
  String get authNoAccount => 'ليس لديك حساب؟';

  @override
  String get authAlreadyAccount => 'لديك حساب بالفعل؟';

  @override
  String get authSignIn => 'تسجيل الدخول';

  @override
  String get authSignUp => 'إنشاء حساب';

  @override
  String get authLogout => 'تسجيل الخروج';

  @override
  String get authGuestCta => 'سجّل دخولك للاستفادة من جميع الميزات';

  @override
  String get propertiesTitle => 'الإعلانات العقارية';

  @override
  String get propertiesEmpty => 'لا توجد إعلانات متاحة حالياً';

  @override
  String get propertiesRefresh => 'تحديث';

  @override
  String get propertiesForSale => 'بيع';

  @override
  String get propertiesForRent => 'إيجار';

  @override
  String get propertiesForHoliday => 'موسمي';

  @override
  String get propertyDetailTitle => 'تفاصيل العقار';

  @override
  String get propertyDetailAddToFavorites => 'إضافة إلى المفضلة';

  @override
  String get propertyDetailRemoveFromFavorites => 'إزالة من المفضلة';

  @override
  String get propertyDetailContact => 'التواصل مع المعلن';

  @override
  String get propertyDetailShare => 'مشاركة هذا العقار';

  @override
  String get propertyDetailSurface => 'المساحة';

  @override
  String get propertyDetailRooms => 'الغرف';

  @override
  String get propertyDetailBedrooms => 'غرف النوم';

  @override
  String get propertyDetailFloor => 'الطابق';

  @override
  String propertyDetailPublishedOn(String date) {
    return 'نُشر في $date';
  }

  @override
  String get searchTitle => 'البحث عن عقار';

  @override
  String get searchHint => 'الموقع، نوع العقار…';

  @override
  String get searchNoResults => 'لا توجد نتائج لهذا البحث';

  @override
  String get searchFiltersTitle => 'فلاتر البحث';

  @override
  String get searchApplyFilters => 'تطبيق الفلاتر';

  @override
  String get searchResetFilters => 'إعادة تعيين';

  @override
  String get favoritesTitle => 'المفضلة';

  @override
  String get favoritesEmpty => 'لا توجد عناصر في المفضلة بعد';

  @override
  String get favoritesEmptyCta => 'تصفّح الإعلانات واحفظ المفضّلة لديك';

  @override
  String get profileTitle => 'حسابي';

  @override
  String get profileMyListings => 'إعلاناتي';

  @override
  String get profileMyBookings => 'حجوزاتي';

  @override
  String get profileMyAlerts => 'تنبيهاتي';

  @override
  String get profileSettings => 'الإعدادات';

  @override
  String get profileLanguage => 'اللغة';

  @override
  String get profileHelp => 'المساعدة والدعم';

  @override
  String get profileAbout => 'حول DZ Immobilier';

  @override
  String get estimationTitle => 'تقييم في 30 ثانية';

  @override
  String get estimationSubtitle => 'إجابة فورية في 4 أسئلة';

  @override
  String get estimationRestart => 'البدء من جديد';

  @override
  String get estimationStepLocation => 'الخطوة 1 · الموقع';

  @override
  String get estimationStepType => 'الخطوة 2 · نوع العقار';

  @override
  String get estimationStepSurface => 'الخطوة 3 · المساحة';

  @override
  String get estimationStepHighlights => 'الخطوة 4 · المميزات';

  @override
  String get estimationStepContact => 'الخطوة الأخيرة · التواصل';

  @override
  String get estimationSeeResult => 'عرض تقييمي';

  @override
  String get simulationTitle => 'احسب تمويلك';

  @override
  String get simulationSubtitle => 'اعثر على القرض المناسب لملفك';

  @override
  String get simulationStepType => 'الخطوة 1 · نوع العقار';

  @override
  String get simulationStepBudget => 'الخطوة 2 · الميزانية';

  @override
  String get simulationStepIncome => 'الخطوة 3 · الدخل';

  @override
  String get simulationStepContact => 'الخطوة الأخيرة · التواصل';

  @override
  String get simulationSeeOffers => 'عرض العروض';

  @override
  String get simulationCalculate => 'احسب عروضي';

  @override
  String get simulationResultTitle => 'عروض التمويل الخاصة بك';

  @override
  String get simulationNewSimulation => 'محاكاة جديدة';

  @override
  String get simulationConfirmation =>
      'تم إرسال الطلب — سيتصل بك مستشار DZ-Immobilier خلال 24 ساعة.';

  @override
  String get settingsLanguageTitle => 'اختيار اللغة';

  @override
  String get settingsLanguageFr => 'Français';

  @override
  String get settingsLanguageAr => 'عربي';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get commonOr => 'أو';

  @override
  String get commonClear => 'مسح';

  @override
  String get commonAll => 'الكل';

  @override
  String get commonAllF => 'الكل';

  @override
  String get commonApply => 'تطبيق';

  @override
  String get commonErrorTitle => 'خطأ';

  @override
  String get commonPerMonth => '/شهرياً';

  @override
  String get authRegisterSubtitle => 'انضم إلى DZ Immobilier في ثوانٍ.';

  @override
  String get authForgotPasswordSubtitle =>
      'أدخل بريدك الإلكتروني لتلقّي رابط إعادة التعيين.';

  @override
  String get authEmailHint => 'example@email.com';

  @override
  String get authNameHint => 'اسمك الأول واسم العائلة';

  @override
  String get authPhoneHint => '06 XX XX XX XX';

  @override
  String get authConfirmPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get authSendResetLink => 'إرسال الرابط';

  @override
  String get authBackToLogin => 'العودة إلى تسجيل الدخول';

  @override
  String get authResetSentTitle => 'تم إرسال البريد الإلكتروني!';

  @override
  String authResetSentBody(String email) {
    return 'تم إرسال رابط إعادة التعيين إلى $email. تحقق من صندوق الوارد.';
  }

  @override
  String get valEmailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get valEmailInvalid => 'بريد إلكتروني غير صالح';

  @override
  String get valPasswordRequired => 'كلمة المرور مطلوبة';

  @override
  String get valPasswordMin => '8 أحرف على الأقل';

  @override
  String get valPhoneRequired => 'رقم الهاتف مطلوب';

  @override
  String get valPhoneInvalid => 'رقم غير صالح';

  @override
  String get valNameRequired => 'الاسم مطلوب';

  @override
  String get valConfirmRequired => 'التأكيد مطلوب';

  @override
  String get valPasswordMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get homeEstimationAction => 'تقييم';

  @override
  String get homeEstimationSubtitle => 'قيمة عقارك';

  @override
  String get homeSimulationAction => 'محاكاة';

  @override
  String get homeSimulationSubtitle => 'قرض عقاري';

  @override
  String propertiesLoadMore(int count) {
    return 'عرض المزيد (متبقّي $count)';
  }

  @override
  String get propertyBadgeSale => 'للبيع';

  @override
  String get propertyBadgeRent => 'للإيجار';

  @override
  String propertyCardSpecs(int rooms, int area) {
    return '$rooms غرف · $area م²';
  }

  @override
  String get searchBarHint => 'ولاية، حي، كلمة مفتاحية…';

  @override
  String get searchRecent => 'عمليات البحث الأخيرة';

  @override
  String get searchPopularCities => 'مدن شائعة';

  @override
  String get searchAllListings => 'جميع الإعلانات';

  @override
  String searchResultsCount(num count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString عقار',
      many: '$countString عقاراً',
      few: '$countString عقارات',
      two: 'عقاران',
      one: 'عقار واحد',
      zero: 'لا توجد عقارات',
    );
    return '$_temp0';
  }

  @override
  String get searchNoResultsTitle => 'لا توجد نتائج';

  @override
  String get searchNoResultsBody => 'لم نعثر على أي عقار يطابق معايير بحثك.';

  @override
  String get searchResetFiltersBtn => 'إعادة تعيين الفلاتر';

  @override
  String get searchDetailSoon => 'تفاصيل العقار ستتوفر قريباً.';

  @override
  String get filterTransactionType => 'نوع المعاملة';

  @override
  String get filterCategory => 'الفئة';

  @override
  String get filterWilaya => 'الولاية';

  @override
  String get filterBudget => 'الميزانية (دج)';

  @override
  String get filterPriceMin => 'السعر الأدنى';

  @override
  String get filterPriceMax => 'السعر الأقصى';

  @override
  String get filterPriceMinHint => 'مثال: 10٬000٬000';

  @override
  String get filterPriceMaxHint => 'مثال: 80٬000٬000';

  @override
  String get filterBedroomsMin => 'غرف النوم (حد أدنى)';

  @override
  String get filterAreaMin => 'المساحة الدنيا (م²)';

  @override
  String get filterAreaHint => 'مثال: 80';

  @override
  String get propertyTypeApartment => 'شقة';

  @override
  String get propertyTypeVilla => 'فيلا';

  @override
  String get propertyTypeLand => 'أرض';

  @override
  String get propertyTypeStudio => 'استوديو';

  @override
  String commonStepProgress(int current, int total) {
    return 'الخطوة $current / $total';
  }

  @override
  String get commonSelect => 'اختيار';

  @override
  String commonYears(int count) {
    return '$count سنة';
  }

  @override
  String get simStep1Prefix => 'احسب';

  @override
  String get simStep1Accent => 'تمويلك.';

  @override
  String get simStep2Prefix => 'ما هي';

  @override
  String get simStep2Accent => 'ميزانيتك؟';

  @override
  String get simStep3Prefix => 'أخبرنا';

  @override
  String get simStep3Accent => 'عن نفسك.';

  @override
  String get simStep4Prefix => 'مستشار';

  @override
  String get simStep4Accent => 'يعاود الاتصال بك.';

  @override
  String get simSelectPropertyType => 'اختر نوع العقار';

  @override
  String get simInfoAnalysisBody =>
      'يحلّل بيانات السوق المحلي قبل كل توصية — أسعار ومُدد وشروط أهلية مُعدّلة في الوقت الفعلي حسب ملفك.';

  @override
  String get simStateProgramQuestion => 'هل هذا برنامج حكومي؟';

  @override
  String get simStateYes => 'نعم (LPP, LPA, LSP)';

  @override
  String get simStateNo => 'لا (سوق حر)';

  @override
  String get simStateNote => '*نسبة 1% أو 3% تنطبق فقط على البرامج المعتمدة.';

  @override
  String get simPropertyPriceLabel => 'سعر العقار (دج)';

  @override
  String get simPropertyPriceHint => '15 000 000';

  @override
  String get simDownPaymentLabel => 'دفعتك الأولى (دج)';

  @override
  String get simDownPaymentHint => '3 000 000';

  @override
  String get simLeverageTitle => 'أثر الرافعة للدفعة الأولى:';

  @override
  String get simLeverageMin =>
      'الحد الأدنى القانوني للدفعة الأولى: 10% من سعر العقار (تنظيم بنك الجزائر).';

  @override
  String get simLeverageRec =>
      'الدفعة الأولى الموصى بها: من 20% إلى 30% لشروط مثالية.';

  @override
  String get simLeverageEff =>
      'الأثر الكمّي: على عقار بقيمة 10 ملايين دج، الانتقال من 10% إلى 30% كدفعة أولى يوفّر حوالي 2.5 مليون دج من التكلفة الإجمالية على 20 سنة.';

  @override
  String get simMonthlyIncomeLabel => 'الدخل الشهري الصافي (دج)';

  @override
  String get simIncomeHint => '120 000';

  @override
  String get simAgeLabel => 'العمر';

  @override
  String get simAgeHint => '35';

  @override
  String get simEmploymentTypeLabel => 'نوع العمل';

  @override
  String get simEmpSalaried => 'أجير';

  @override
  String get simEmpCivilServant => 'موظف';

  @override
  String get simEmpSelfEmployed => 'مقاول ذاتي';

  @override
  String get simEmpBusinessOwner => 'صاحب عمل';

  @override
  String get simStateTiersTitle => 'شرائح الدعم الحكومي:';

  @override
  String get simIncomeTier1 => 'الدخل ≤ 108 000 دج → نسبة 1%';

  @override
  String get simIncomeTier2 => 'الدخل ≤ 216 000 دج → نسبة 3%';

  @override
  String get simIncomeAboveMarket => 'فوق ذلك → تمويل بالسوق الحر (~6.25%)';

  @override
  String get simAgeLimitTitle => 'الحد التنظيمي للعمر:';

  @override
  String simAgeLimitBody(int term) {
    return 'لا يمكن أن يتجاوز العمر عند نهاية القرض 75 سنة (بنك الجزائر). في عمرك، المدة القصوى للقرض هي $term سنة.';
  }

  @override
  String get simFullNameLabel => 'الاسم الكامل';

  @override
  String get simFullNameHint => 'محمد أمين';

  @override
  String get simPhoneLabel => 'الهاتف';

  @override
  String get simPhoneHint => '+213 5XX XX XX XX · +33 6 XX XX XX XX';

  @override
  String get simEmailLabel => 'البريد الإلكتروني (اختياري)';

  @override
  String get simEmailHint => 'contact@email.dz';

  @override
  String get simPrivacyNotice =>
      'بياناتك سرّية وتُستخدم فقط لإرسال محاكاتك الشخصية إليك. لا يوجد تواصل تجاري دون موافقتك.';

  @override
  String get simResultSubtitle => 'محاكاة شخصية بناءً على ملفك';

  @override
  String get simResultLoading => 'جارٍ حساب عروضك…';

  @override
  String get simResultBadge => 'النتائج · مقارنة تعليمية';

  @override
  String get simDuelPrefix => 'المبارزة:';

  @override
  String get simDuelAccent => 'تقليدي\nمقابل مرابحة.';

  @override
  String get simLoanConventional => 'قرض تقليدي';

  @override
  String get simLoanMourabaha => 'مرابحة إسلامية';

  @override
  String get simDaPerMonth => 'دج/شهرياً';

  @override
  String get simRateLabel => 'النسبة:';

  @override
  String get simDurationLabel => 'المدة:';

  @override
  String simDurationValue(int years, int months) {
    return '$years سنة ($months قسطاً)';
  }

  @override
  String get simTotalInterest => 'إجمالي الفوائد';

  @override
  String get simTotalMargin => 'إجمالي الهامش';

  @override
  String get simHowItWorks => 'ℹ️ كيف يعمل؟';

  @override
  String get simHowConventional =>
      'يُقرضك البنك المال. تسدّد رأس المال + الفوائد المحسوبة على الرصيد المتبقّي كل شهر (طريقة الفائدة المركّبة).';

  @override
  String get simHowMourabaha =>
      'يشتري البنك العقار نيابةً عنك، ثم يعيد بيعه لك بهامش معروف مسبقاً. لا ربا متغيّر. الهيكل القانوني: عقد شراء وإعادة بيع.';

  @override
  String get simExpertAnalysis => 'تحليل خبراء DZ-Immobilier';

  @override
  String simExpertBody(String gap) {
    return 'الفارق بين النموذجين هو $gap للمرابحة مقارنةً بالقرض التقليدي.\nالخلاصة: رغم أن التكلفة النهائية غالباً ما تكون متقاربة، فإن الهيكل القانوني مختلف جوهرياً: القرض التقليدي عقد إقراض مال (قرض)، بينما المرابحة عقد شراء وإعادة بيع (بيع). يعتمد هذا الاختيار على قناعاتك الشخصية بقدر اعتماده على حسابك المالي.';
  }

  @override
  String get simDebtRatioLabel => 'نسبة المديونية';

  @override
  String get simDebtExceeded =>
      'تم تجاوز القدرة على الاستدانة. الحلول: زيادة الدفعة الأولى، تمديد المدة، أو إضافة مقترض مشارك.';

  @override
  String get simBankOffersTitle => 'العروض حسب البنك الشريك';

  @override
  String get simBankColumn => 'البنك';

  @override
  String get simRateColumn => 'النسبة';

  @override
  String get simMonthlyColumn => 'الشهري';

  @override
  String simRateAnnual(int rate) {
    return '$rate% سنوياً';
  }

  @override
  String mapResultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count إعلان',
      many: '$count إعلاناً',
      few: '$count إعلانات',
      two: 'إعلانان',
      one: 'إعلان واحد',
      zero: 'لا توجد إعلانات',
    );
    return '$_temp0';
  }

  @override
  String mapOffMap(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count إعلان بدون موقع',
      many: '$count إعلاناً بدون موقع',
      few: '$count إعلانات بدون موقع',
      two: 'إعلانان بدون موقع',
      one: 'إعلان واحد بدون موقع',
    );
    return '$_temp0';
  }

  @override
  String get homeRecentListings => 'أحدث الإعلانات';

  @override
  String get homeViewMap => 'الخريطة';

  @override
  String get homeSearchShortcut => 'ابحث عن عقار…';
}
