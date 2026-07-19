// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'DZ Immobilier';

  @override
  String get appTagline => 'Le marché immobilier algérien';

  @override
  String get commonContinue => 'Continuer';

  @override
  String get commonBack => 'Retour';

  @override
  String get commonNext => 'Suivant';

  @override
  String get commonSave => 'Enregistrer';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonClose => 'Fermer';

  @override
  String get commonRetry => 'Réessayer';

  @override
  String get commonSearch => 'Rechercher';

  @override
  String get commonLoading => 'Chargement…';

  @override
  String get commonError => 'Une erreur s\'est produite';

  @override
  String get commonSeeAll => 'Voir tout';

  @override
  String get commonRestart => 'Recommencer';

  @override
  String get commonSubmit => 'Valider';

  @override
  String get commonConfirm => 'Confirmer';

  @override
  String get commonDelete => 'Supprimer';

  @override
  String get commonEdit => 'Modifier';

  @override
  String get commonShare => 'Partager';

  @override
  String get commonPublish => 'Publier';

  @override
  String get commonFilters => 'Filtres';

  @override
  String get commonSort => 'Trier';

  @override
  String get commonRequired => 'Champ requis';

  @override
  String get commonFieldInvalid => 'Valeur incorrecte';

  @override
  String get commonNetworkError => 'Vérifiez votre connexion internet';

  @override
  String get commonOffline => 'Vous êtes hors ligne';

  @override
  String get commonSoonAvailable => 'Bientôt disponible';

  @override
  String commonItemCount(num count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString biens',
      one: '1 bien',
      zero: 'Aucun bien',
    );
    return '$_temp0';
  }

  @override
  String commonWelcome(String name) {
    return 'Bienvenue, $name !';
  }

  @override
  String get navHome => 'Accueil';

  @override
  String get navSearch => 'Recherche';

  @override
  String get navPublish => 'Publier';

  @override
  String get navFavorites => 'Favoris';

  @override
  String get navAccount => 'Compte';

  @override
  String get authLoginTitle => 'Bon retour !';

  @override
  String get authLoginSubtitle => 'Connectez-vous pour accéder à votre espace';

  @override
  String get authRegisterTitle => 'Créer un compte';

  @override
  String get authForgotPasswordTitle => 'Mot de passe oublié';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPasswordLabel => 'Mot de passe';

  @override
  String get authNameLabel => 'Nom complet';

  @override
  String get authPhoneLabel => 'Téléphone';

  @override
  String get authLoginBtn => 'Se connecter';

  @override
  String get authRegisterBtn => 'Créer mon compte';

  @override
  String get authForgotPasswordLink => 'Mot de passe oublié ?';

  @override
  String get authNoAccount => 'Pas encore de compte ?';

  @override
  String get authAlreadyAccount => 'Déjà un compte ?';

  @override
  String get authSignIn => 'Se connecter';

  @override
  String get authSignUp => 'Créer un compte';

  @override
  String get authLogout => 'Se déconnecter';

  @override
  String get authGuestCta =>
      'Connectez-vous pour profiter de toutes les fonctionnalités';

  @override
  String get propertiesTitle => 'Annonces immobilières';

  @override
  String get propertiesEmpty => 'Aucune annonce disponible pour le moment';

  @override
  String get propertiesRefresh => 'Actualiser';

  @override
  String get propertiesForSale => 'Vente';

  @override
  String get propertiesForRent => 'Location';

  @override
  String get propertiesForHoliday => 'Saisonnier';

  @override
  String get propertyDetailTitle => 'Détails du bien';

  @override
  String get propertyDetailAddToFavorites => 'Ajouter aux favoris';

  @override
  String get propertyDetailRemoveFromFavorites => 'Retirer des favoris';

  @override
  String get propertyDetailContact => 'Contacter l\'annonceur';

  @override
  String get propertyDetailShare => 'Partager ce bien';

  @override
  String get propertyDetailSurface => 'Surface';

  @override
  String get propertyDetailRooms => 'Pièces';

  @override
  String get propertyDetailBedrooms => 'Chambres';

  @override
  String get propertyDetailFloor => 'Étage';

  @override
  String propertyDetailPublishedOn(String date) {
    return 'Publié le $date';
  }

  @override
  String get searchTitle => 'Rechercher un bien';

  @override
  String get searchHint => 'Localisation, type de bien…';

  @override
  String get searchNoResults => 'Aucun résultat pour cette recherche';

  @override
  String get searchFiltersTitle => 'Filtres de recherche';

  @override
  String get searchApplyFilters => 'Appliquer les filtres';

  @override
  String get searchResetFilters => 'Réinitialiser';

  @override
  String get favoritesTitle => 'Mes favoris';

  @override
  String get favoritesEmpty => 'Vous n\'avez pas encore de favoris';

  @override
  String get favoritesEmptyCta =>
      'Explorez les annonces et sauvegardez vos préférées';

  @override
  String get profileTitle => 'Mon compte';

  @override
  String get profileMyListings => 'Mes annonces';

  @override
  String get profileMyBookings => 'Mes réservations';

  @override
  String get profileMyAlerts => 'Mes alertes';

  @override
  String get profileSettings => 'Paramètres';

  @override
  String get profileLanguage => 'Langue';

  @override
  String get profileHelp => 'Aide et support';

  @override
  String get profileAbout => 'À propos de DZ Immobilier';

  @override
  String get estimationTitle => 'Estimer en 30 secondes';

  @override
  String get estimationSubtitle => 'Réponse instantanée en 4 questions';

  @override
  String get estimationRestart => 'Recommencer';

  @override
  String get estimationStepLocation => 'ÉTAPE 1 · LOCALISATION';

  @override
  String get estimationStepType => 'ÉTAPE 2 · TYPE DE BIEN';

  @override
  String get estimationStepSurface => 'ÉTAPE 3 · SURFACE';

  @override
  String get estimationStepHighlights => 'ÉTAPE 4 · POINTS FORTS';

  @override
  String get estimationStepContact => 'DERNIÈRE ÉTAPE · CONTACT';

  @override
  String get estimationSeeResult => 'Voir mon estimation';

  @override
  String get simulationTitle => 'Simulez votre financement';

  @override
  String get simulationSubtitle => 'Trouvez le crédit adapté à votre profil';

  @override
  String get simulationStepType => 'ÉTAPE 1 · TYPE DE BIEN';

  @override
  String get simulationStepBudget => 'ÉTAPE 2 · BUDGET';

  @override
  String get simulationStepIncome => 'ÉTAPE 3 · REVENUS';

  @override
  String get simulationStepContact => 'DERNIÈRE ÉTAPE · CONTACT';

  @override
  String get simulationSeeOffers => 'Voir les offres';

  @override
  String get simulationCalculate => 'Calculer mes offres';

  @override
  String get simulationResultTitle => 'Vos offres de financement';

  @override
  String get simulationNewSimulation => 'Nouvelle simulation';

  @override
  String get simulationConfirmation =>
      'Demande envoyée — un conseiller DZ-Immobilier vous contactera dans les 24 heures.';

  @override
  String get settingsLanguageTitle => 'Choisir la langue';

  @override
  String get settingsLanguageFr => 'Français';

  @override
  String get settingsLanguageAr => 'عربي';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get commonOr => 'ou';

  @override
  String get commonClear => 'Effacer';

  @override
  String get commonAll => 'Tous';

  @override
  String get commonAllF => 'Toutes';

  @override
  String get commonApply => 'Appliquer';

  @override
  String get commonErrorTitle => 'Erreur';

  @override
  String get commonPerMonth => '/mois';

  @override
  String get authRegisterSubtitle =>
      'Rejoignez DZ Immobilier en quelques secondes.';

  @override
  String get authForgotPasswordSubtitle =>
      'Entrez votre e-mail pour recevoir un lien de réinitialisation.';

  @override
  String get authEmailHint => 'exemple@email.com';

  @override
  String get authNameHint => 'Votre prénom et nom';

  @override
  String get authPhoneHint => '06 XX XX XX XX';

  @override
  String get authConfirmPasswordLabel => 'Confirmer le mot de passe';

  @override
  String get authSendResetLink => 'Envoyer le lien';

  @override
  String get authBackToLogin => 'Retour à la connexion';

  @override
  String get authResetSentTitle => 'E-mail envoyé !';

  @override
  String authResetSentBody(String email) {
    return 'Un lien de réinitialisation a été envoyé à $email. Vérifiez votre boîte de réception.';
  }

  @override
  String get valEmailRequired => 'Email requis';

  @override
  String get valEmailInvalid => 'Email invalide';

  @override
  String get valPasswordRequired => 'Mot de passe requis';

  @override
  String get valPasswordMin => 'Au moins 8 caractères';

  @override
  String get valPhoneRequired => 'Téléphone requis';

  @override
  String get valPhoneInvalid => 'Numéro invalide';

  @override
  String get valNameRequired => 'Le nom est requis';

  @override
  String get valConfirmRequired => 'Confirmation requise';

  @override
  String get valPasswordMismatch => 'Les mots de passe ne correspondent pas';

  @override
  String get homeEstimationAction => 'Estimation';

  @override
  String get homeEstimationSubtitle => 'Valeur de votre bien';

  @override
  String get homeSimulationAction => 'Simulation';

  @override
  String get homeSimulationSubtitle => 'Crédit immobilier';

  @override
  String propertiesLoadMore(int count) {
    return 'Voir plus ($count restants)';
  }

  @override
  String get propertyBadgeSale => 'À vendre';

  @override
  String get propertyBadgeRent => 'À louer';

  @override
  String propertyCardSpecs(int rooms, int area) {
    return '$rooms Ch · $area m²';
  }

  @override
  String get searchBarHint => 'Wilaya, quartier, mot-clé…';

  @override
  String get searchRecent => 'Recherches récentes';

  @override
  String get searchPopularCities => 'Villes populaires';

  @override
  String get searchAllListings => 'Toutes les annonces';

  @override
  String searchResultsCount(num count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString biens trouvés',
      one: '1 bien trouvé',
      zero: 'Aucun bien trouvé',
    );
    return '$_temp0';
  }

  @override
  String get searchNoResultsTitle => 'Aucun résultat';

  @override
  String get searchNoResultsBody =>
      'Nous n\'avons trouvé aucun bien correspondant à vos critères de recherche.';

  @override
  String get searchResetFiltersBtn => 'Réinitialiser les filtres';

  @override
  String get searchDetailSoon => 'Détails du bien bientôt disponibles.';

  @override
  String get filterTransactionType => 'Type de transaction';

  @override
  String get filterCategory => 'Catégorie';

  @override
  String get filterWilaya => 'Wilaya';

  @override
  String get filterBudget => 'Budget (DA)';

  @override
  String get filterPriceMin => 'Prix Min';

  @override
  String get filterPriceMax => 'Prix Max';

  @override
  String get filterPriceMinHint => 'ex : 10 000 000';

  @override
  String get filterPriceMaxHint => 'ex : 80 000 000';

  @override
  String get filterBedroomsMin => 'Chambres min';

  @override
  String get filterAreaMin => 'Superficie min (m²)';

  @override
  String get filterAreaHint => 'ex : 80';

  @override
  String get propertyTypeApartment => 'Appartement';

  @override
  String get propertyTypeVilla => 'Villa';

  @override
  String get propertyTypeLand => 'Terrain';

  @override
  String get propertyTypeStudio => 'Studio';

  @override
  String commonStepProgress(int current, int total) {
    return 'Étape $current / $total';
  }

  @override
  String get commonSelect => 'Sélectionner';

  @override
  String commonYears(int count) {
    return '$count ans';
  }

  @override
  String get simStep1Prefix => 'Simulez votre';

  @override
  String get simStep1Accent => 'financement.';

  @override
  String get simStep2Prefix => 'Quel est votre';

  @override
  String get simStep2Accent => 'budget ?';

  @override
  String get simStep3Prefix => 'Parlez-nous';

  @override
  String get simStep3Accent => 'de vous.';

  @override
  String get simStep4Prefix => 'Un conseiller';

  @override
  String get simStep4Accent => 'vous rappelle.';

  @override
  String get simSelectPropertyType => 'SÉLECTIONNER LE TYPE DE BIEN';

  @override
  String get simInfoAnalysisBody =>
      'analyse les données du marché local avant chaque recommandation — taux, durées et conditions d\'éligibilité ajustés en temps réel selon votre profil.';

  @override
  String get simStateProgramQuestion => 'Est-ce un programme de l\'État ?';

  @override
  String get simStateYes => 'Oui (LPP, LPA, LSP)';

  @override
  String get simStateNo => 'Non (Libre)';

  @override
  String get simStateNote =>
      '*Le taux à 1% ou 3% ne s\'applique qu\'aux programmes agréés.';

  @override
  String get simPropertyPriceLabel => 'PRIX DU BIEN (DZD)';

  @override
  String get simPropertyPriceHint => '15 000 000';

  @override
  String get simDownPaymentLabel => 'VOTRE APPORT (DZD)';

  @override
  String get simDownPaymentHint => '3 000 000';

  @override
  String get simLeverageTitle => 'Effet de levier de l\'apport :';

  @override
  String get simLeverageMin =>
      'Apport légal minimum : 10% du prix du bien (réglementation Banque d\'Algérie).';

  @override
  String get simLeverageRec =>
      'Apport recommandé : 20% à 30% pour des conditions optimales.';

  @override
  String get simLeverageEff =>
      'Effet quantifié : sur un bien à 10M DZD, passer de 10% à 30% d\'apport économise ~2,5M DZD au coût total sur 20 ans.';

  @override
  String get simMonthlyIncomeLabel => 'REVENU MENSUEL NET (DZD)';

  @override
  String get simIncomeHint => '120 000';

  @override
  String get simAgeLabel => 'ÂGE';

  @override
  String get simAgeHint => '35';

  @override
  String get simEmploymentTypeLabel => 'TYPE D\'EMPLOI';

  @override
  String get simEmpSalaried => 'Salarié';

  @override
  String get simEmpCivilServant => 'Fonctionnaire';

  @override
  String get simEmpSelfEmployed => 'Auto-entrepreneur';

  @override
  String get simEmpBusinessOwner => 'Chef d\'entreprise';

  @override
  String get simStateTiersTitle => 'Paliers de l\'aide de l\'État :';

  @override
  String get simIncomeTier1 => 'Revenu ≤ 108 000 DZD → taux à 1%';

  @override
  String get simIncomeTier2 => 'Revenu ≤ 216 000 DZD → taux à 3%';

  @override
  String get simIncomeAboveMarket =>
      'Au-dessus → financement marché libre (~6,25%)';

  @override
  String get simAgeLimitTitle => 'Limite réglementaire d\'âge :';

  @override
  String simAgeLimitBody(int term) {
    return 'L\'âge en fin de prêt ne peut dépasser 75 ans (Banque d\'Algérie). À votre âge, la durée maximale du prêt est de $term ans.';
  }

  @override
  String get simFullNameLabel => 'NOM COMPLET';

  @override
  String get simFullNameHint => 'Mohamed Amine';

  @override
  String get simPhoneLabel => 'TÉLÉPHONE';

  @override
  String get simPhoneHint => '+213 5XX XX XX XX · +33 6 XX XX XX XX';

  @override
  String get simEmailLabel => 'EMAIL (OPTIONNEL)';

  @override
  String get simEmailHint => 'contact@email.dz';

  @override
  String get simPrivacyNotice =>
      'Vos données sont confidentielles et utilisées uniquement pour vous envoyer votre simulation personnalisée. Aucune communication commerciale sans votre consentement.';

  @override
  String get simResultSubtitle =>
      'Simulation personnalisée basée sur votre profil';

  @override
  String get simResultLoading => 'Calcul de vos offres en cours…';

  @override
  String get simResultBadge => 'RÉSULTATS · COMPARAISON ÉDUCATIVE';

  @override
  String get simDuelPrefix => 'Le Duel :';

  @override
  String get simDuelAccent => 'Conventionnel\nvs Mourabaha.';

  @override
  String get simLoanConventional => 'PRÊT CONVENTIONNEL';

  @override
  String get simLoanMourabaha => 'MOURABAHA ISLAMIQUE';

  @override
  String get simDaPerMonth => 'DA/mois';

  @override
  String get simRateLabel => 'Taux :';

  @override
  String get simDurationLabel => 'Durée :';

  @override
  String simDurationValue(int years, int months) {
    return '$years ans ($months mensualités)';
  }

  @override
  String get simTotalInterest => 'Intérêts totaux';

  @override
  String get simTotalMargin => 'Marge totale';

  @override
  String get simHowItWorks => 'ℹ️ Comment ça marche ?';

  @override
  String get simHowConventional =>
      'La banque vous prête de l\'argent. Vous remboursez le capital + intérêts calculés sur le solde restant chaque mois (méthode des intérêts composés).';

  @override
  String get simHowMourabaha =>
      'La banque achète le bien pour vous, puis vous le revend avec une marge connue à l\'avance. Pas de Riba variable. Structure juridique : contrat achat-revente.';

  @override
  String get simExpertAnalysis => 'Analyse DZ-Immobilier Expert';

  @override
  String simExpertBody(String gap) {
    return 'L\'écart entre les deux modèles est de $gap pour la Mourabaha par rapport au prêt conventionnel.\nConclusion : Si le coût final est souvent proche, la structure juridique est fondamentalement différente : le prêt conventionnel est un contrat de prêt d\'argent (Qard), tandis que la Mourabaha est un contrat achat-revente (Bay\'). Ce choix dépend autant de vos convictions personnelles que de votre calcul financier.';
  }

  @override
  String get simDebtRatioLabel => 'Taux d\'endettement';

  @override
  String get simDebtExceeded =>
      'Capacité d\'endettement dépassée. Solutions : augmenter l\'apport, prolonger la durée, ou ajouter un co-emprunteur.';

  @override
  String get simBankOffersTitle => 'Offres par banque partenaire';

  @override
  String get simBankColumn => 'Banque';

  @override
  String get simRateColumn => 'Taux';

  @override
  String get simMonthlyColumn => 'Mensualité';

  @override
  String simRateAnnual(int rate) {
    return '$rate % annuel';
  }

  @override
  String mapResultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count annonces',
      one: '1 annonce',
    );
    return '$_temp0';
  }

  @override
  String mapOffMap(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count annonces sans localisation',
      one: '1 annonce sans localisation',
    );
    return '$_temp0';
  }

  @override
  String get homeRecentListings => 'Annonces récentes';

  @override
  String get homeViewMap => 'Carte';

  @override
  String get homeSearchShortcut => 'Rechercher un bien…';
}
