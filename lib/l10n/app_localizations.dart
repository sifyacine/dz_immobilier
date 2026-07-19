import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('fr'),
    Locale('ar'),
    Locale('en'),
  ];

  /// Nom de l'application affiché dans la barre de titre
  ///
  /// In fr, this message translates to:
  /// **'DZ Immobilier'**
  String get appName;

  /// Sous-titre court affiché sur l'écran d'accueil
  ///
  /// In fr, this message translates to:
  /// **'Le marché immobilier algérien'**
  String get appTagline;

  /// Bouton action principale — passer à l'étape suivante
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get commonContinue;

  /// Bouton retour
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get commonBack;

  /// Bouton étape suivante d'un assistant
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get commonNext;

  /// No description provided for @commonSave.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get commonSave;

  /// No description provided for @commonCancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get commonCancel;

  /// No description provided for @commonClose.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get commonClose;

  /// No description provided for @commonRetry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get commonRetry;

  /// No description provided for @commonSearch.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher'**
  String get commonSearch;

  /// Indicateur de chargement générique
  ///
  /// In fr, this message translates to:
  /// **'Chargement…'**
  String get commonLoading;

  /// Message d'erreur générique affiché lorsqu'une opération échoue
  ///
  /// In fr, this message translates to:
  /// **'Une erreur s\'est produite'**
  String get commonError;

  /// No description provided for @commonSeeAll.
  ///
  /// In fr, this message translates to:
  /// **'Voir tout'**
  String get commonSeeAll;

  /// No description provided for @commonRestart.
  ///
  /// In fr, this message translates to:
  /// **'Recommencer'**
  String get commonRestart;

  /// No description provided for @commonSubmit.
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get commonSubmit;

  /// No description provided for @commonConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get commonConfirm;

  /// No description provided for @commonDelete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get commonEdit;

  /// No description provided for @commonShare.
  ///
  /// In fr, this message translates to:
  /// **'Partager'**
  String get commonShare;

  /// No description provided for @commonPublish.
  ///
  /// In fr, this message translates to:
  /// **'Publier'**
  String get commonPublish;

  /// No description provided for @commonFilters.
  ///
  /// In fr, this message translates to:
  /// **'Filtres'**
  String get commonFilters;

  /// No description provided for @commonSort.
  ///
  /// In fr, this message translates to:
  /// **'Trier'**
  String get commonSort;

  /// Message de validation pour un champ obligatoire vide
  ///
  /// In fr, this message translates to:
  /// **'Champ requis'**
  String get commonRequired;

  /// No description provided for @commonFieldInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Valeur incorrecte'**
  String get commonFieldInvalid;

  /// Erreur réseau générique
  ///
  /// In fr, this message translates to:
  /// **'Vérifiez votre connexion internet'**
  String get commonNetworkError;

  /// No description provided for @commonOffline.
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes hors ligne'**
  String get commonOffline;

  /// No description provided for @commonSoonAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Bientôt disponible'**
  String get commonSoonAvailable;

  /// Nombre de biens immobiliers
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucun bien} =1{1 bien} other{{count} biens}}'**
  String commonItemCount(num count);

  /// Message de bienvenue personnalisé
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue, {name} !'**
  String commonWelcome(String name);

  /// Onglet navigation — liste des biens
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get navHome;

  /// Onglet navigation — recherche
  ///
  /// In fr, this message translates to:
  /// **'Recherche'**
  String get navSearch;

  /// FAB — publier un bien
  ///
  /// In fr, this message translates to:
  /// **'Publier'**
  String get navPublish;

  /// Onglet navigation — biens favoris
  ///
  /// In fr, this message translates to:
  /// **'Favoris'**
  String get navFavorites;

  /// Onglet navigation — profil utilisateur
  ///
  /// In fr, this message translates to:
  /// **'Compte'**
  String get navAccount;

  /// No description provided for @authLoginTitle.
  ///
  /// In fr, this message translates to:
  /// **'Bon retour !'**
  String get authLoginTitle;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous pour accéder à votre espace'**
  String get authLoginSubtitle;

  /// No description provided for @authRegisterTitle.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get authRegisterTitle;

  /// No description provided for @authForgotPasswordTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié'**
  String get authForgotPasswordTitle;

  /// No description provided for @authEmailLabel.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get authEmailLabel;

  /// No description provided for @authPasswordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get authPasswordLabel;

  /// No description provided for @authNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom complet'**
  String get authNameLabel;

  /// No description provided for @authPhoneLabel.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone'**
  String get authPhoneLabel;

  /// No description provided for @authLoginBtn.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get authLoginBtn;

  /// No description provided for @authRegisterBtn.
  ///
  /// In fr, this message translates to:
  /// **'Créer mon compte'**
  String get authRegisterBtn;

  /// No description provided for @authForgotPasswordLink.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié ?'**
  String get authForgotPasswordLink;

  /// No description provided for @authNoAccount.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de compte ?'**
  String get authNoAccount;

  /// No description provided for @authAlreadyAccount.
  ///
  /// In fr, this message translates to:
  /// **'Déjà un compte ?'**
  String get authAlreadyAccount;

  /// No description provided for @authSignIn.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get authSignIn;

  /// No description provided for @authSignUp.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get authSignUp;

  /// No description provided for @authLogout.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get authLogout;

  /// No description provided for @authGuestCta.
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous pour profiter de toutes les fonctionnalités'**
  String get authGuestCta;

  /// Titre de l'écran liste des biens
  ///
  /// In fr, this message translates to:
  /// **'Annonces immobilières'**
  String get propertiesTitle;

  /// No description provided for @propertiesEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune annonce disponible pour le moment'**
  String get propertiesEmpty;

  /// No description provided for @propertiesRefresh.
  ///
  /// In fr, this message translates to:
  /// **'Actualiser'**
  String get propertiesRefresh;

  /// No description provided for @propertiesForSale.
  ///
  /// In fr, this message translates to:
  /// **'Vente'**
  String get propertiesForSale;

  /// No description provided for @propertiesForRent.
  ///
  /// In fr, this message translates to:
  /// **'Location'**
  String get propertiesForRent;

  /// No description provided for @propertiesForHoliday.
  ///
  /// In fr, this message translates to:
  /// **'Saisonnier'**
  String get propertiesForHoliday;

  /// No description provided for @propertyDetailTitle.
  ///
  /// In fr, this message translates to:
  /// **'Détails du bien'**
  String get propertyDetailTitle;

  /// No description provided for @propertyDetailAddToFavorites.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter aux favoris'**
  String get propertyDetailAddToFavorites;

  /// No description provided for @propertyDetailRemoveFromFavorites.
  ///
  /// In fr, this message translates to:
  /// **'Retirer des favoris'**
  String get propertyDetailRemoveFromFavorites;

  /// No description provided for @propertyDetailContact.
  ///
  /// In fr, this message translates to:
  /// **'Contacter l\'annonceur'**
  String get propertyDetailContact;

  /// No description provided for @propertyDetailShare.
  ///
  /// In fr, this message translates to:
  /// **'Partager ce bien'**
  String get propertyDetailShare;

  /// No description provided for @propertyDetailSurface.
  ///
  /// In fr, this message translates to:
  /// **'Surface'**
  String get propertyDetailSurface;

  /// No description provided for @propertyDetailRooms.
  ///
  /// In fr, this message translates to:
  /// **'Pièces'**
  String get propertyDetailRooms;

  /// No description provided for @propertyDetailBedrooms.
  ///
  /// In fr, this message translates to:
  /// **'Chambres'**
  String get propertyDetailBedrooms;

  /// No description provided for @propertyDetailFloor.
  ///
  /// In fr, this message translates to:
  /// **'Étage'**
  String get propertyDetailFloor;

  /// No description provided for @propertyDetailPublishedOn.
  ///
  /// In fr, this message translates to:
  /// **'Publié le {date}'**
  String propertyDetailPublishedOn(String date);

  /// No description provided for @searchTitle.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un bien'**
  String get searchTitle;

  /// No description provided for @searchHint.
  ///
  /// In fr, this message translates to:
  /// **'Localisation, type de bien…'**
  String get searchHint;

  /// No description provided for @searchNoResults.
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat pour cette recherche'**
  String get searchNoResults;

  /// No description provided for @searchFiltersTitle.
  ///
  /// In fr, this message translates to:
  /// **'Filtres de recherche'**
  String get searchFiltersTitle;

  /// No description provided for @searchApplyFilters.
  ///
  /// In fr, this message translates to:
  /// **'Appliquer les filtres'**
  String get searchApplyFilters;

  /// No description provided for @searchResetFilters.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser'**
  String get searchResetFilters;

  /// No description provided for @favoritesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes favoris'**
  String get favoritesTitle;

  /// No description provided for @favoritesEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Vous n\'avez pas encore de favoris'**
  String get favoritesEmpty;

  /// No description provided for @favoritesEmptyCta.
  ///
  /// In fr, this message translates to:
  /// **'Explorez les annonces et sauvegardez vos préférées'**
  String get favoritesEmptyCta;

  /// No description provided for @profileTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mon compte'**
  String get profileTitle;

  /// No description provided for @profileMyListings.
  ///
  /// In fr, this message translates to:
  /// **'Mes annonces'**
  String get profileMyListings;

  /// No description provided for @profileMyBookings.
  ///
  /// In fr, this message translates to:
  /// **'Mes réservations'**
  String get profileMyBookings;

  /// No description provided for @profileMyAlerts.
  ///
  /// In fr, this message translates to:
  /// **'Mes alertes'**
  String get profileMyAlerts;

  /// No description provided for @profileSettings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get profileSettings;

  /// No description provided for @profileLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get profileLanguage;

  /// No description provided for @profileHelp.
  ///
  /// In fr, this message translates to:
  /// **'Aide et support'**
  String get profileHelp;

  /// No description provided for @profileAbout.
  ///
  /// In fr, this message translates to:
  /// **'À propos de DZ Immobilier'**
  String get profileAbout;

  /// No description provided for @estimationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Estimer en 30 secondes'**
  String get estimationTitle;

  /// No description provided for @estimationSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Réponse instantanée en 4 questions'**
  String get estimationSubtitle;

  /// No description provided for @estimationRestart.
  ///
  /// In fr, this message translates to:
  /// **'Recommencer'**
  String get estimationRestart;

  /// No description provided for @estimationStepLocation.
  ///
  /// In fr, this message translates to:
  /// **'ÉTAPE 1 · LOCALISATION'**
  String get estimationStepLocation;

  /// No description provided for @estimationStepType.
  ///
  /// In fr, this message translates to:
  /// **'ÉTAPE 2 · TYPE DE BIEN'**
  String get estimationStepType;

  /// No description provided for @estimationStepSurface.
  ///
  /// In fr, this message translates to:
  /// **'ÉTAPE 3 · SURFACE'**
  String get estimationStepSurface;

  /// No description provided for @estimationStepHighlights.
  ///
  /// In fr, this message translates to:
  /// **'ÉTAPE 4 · POINTS FORTS'**
  String get estimationStepHighlights;

  /// No description provided for @estimationStepContact.
  ///
  /// In fr, this message translates to:
  /// **'DERNIÈRE ÉTAPE · CONTACT'**
  String get estimationStepContact;

  /// No description provided for @estimationSeeResult.
  ///
  /// In fr, this message translates to:
  /// **'Voir mon estimation'**
  String get estimationSeeResult;

  /// No description provided for @simulationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Simulez votre financement'**
  String get simulationTitle;

  /// No description provided for @simulationSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Trouvez le crédit adapté à votre profil'**
  String get simulationSubtitle;

  /// No description provided for @simulationStepType.
  ///
  /// In fr, this message translates to:
  /// **'ÉTAPE 1 · TYPE DE BIEN'**
  String get simulationStepType;

  /// No description provided for @simulationStepBudget.
  ///
  /// In fr, this message translates to:
  /// **'ÉTAPE 2 · BUDGET'**
  String get simulationStepBudget;

  /// No description provided for @simulationStepIncome.
  ///
  /// In fr, this message translates to:
  /// **'ÉTAPE 3 · REVENUS'**
  String get simulationStepIncome;

  /// No description provided for @simulationStepContact.
  ///
  /// In fr, this message translates to:
  /// **'DERNIÈRE ÉTAPE · CONTACT'**
  String get simulationStepContact;

  /// No description provided for @simulationSeeOffers.
  ///
  /// In fr, this message translates to:
  /// **'Voir les offres'**
  String get simulationSeeOffers;

  /// No description provided for @simulationCalculate.
  ///
  /// In fr, this message translates to:
  /// **'Calculer mes offres'**
  String get simulationCalculate;

  /// No description provided for @simulationResultTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vos offres de financement'**
  String get simulationResultTitle;

  /// No description provided for @simulationNewSimulation.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle simulation'**
  String get simulationNewSimulation;

  /// No description provided for @simulationConfirmation.
  ///
  /// In fr, this message translates to:
  /// **'Demande envoyée — un conseiller DZ-Immobilier vous contactera dans les 24 heures.'**
  String get simulationConfirmation;

  /// No description provided for @settingsLanguageTitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisir la langue'**
  String get settingsLanguageTitle;

  /// No description provided for @settingsLanguageFr.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get settingsLanguageFr;

  /// No description provided for @settingsLanguageAr.
  ///
  /// In fr, this message translates to:
  /// **'عربي'**
  String get settingsLanguageAr;

  /// No description provided for @settingsLanguageEn.
  ///
  /// In fr, this message translates to:
  /// **'English'**
  String get settingsLanguageEn;

  /// No description provided for @commonOr.
  ///
  /// In fr, this message translates to:
  /// **'ou'**
  String get commonOr;

  /// No description provided for @commonClear.
  ///
  /// In fr, this message translates to:
  /// **'Effacer'**
  String get commonClear;

  /// No description provided for @commonAll.
  ///
  /// In fr, this message translates to:
  /// **'Tous'**
  String get commonAll;

  /// « Tous » au féminin (ex. toutes les wilayas)
  ///
  /// In fr, this message translates to:
  /// **'Toutes'**
  String get commonAllF;

  /// No description provided for @commonApply.
  ///
  /// In fr, this message translates to:
  /// **'Appliquer'**
  String get commonApply;

  /// Titre court d'une notification d'erreur
  ///
  /// In fr, this message translates to:
  /// **'Erreur'**
  String get commonErrorTitle;

  /// Suffixe de prix pour une location mensuelle
  ///
  /// In fr, this message translates to:
  /// **'/mois'**
  String get commonPerMonth;

  /// No description provided for @authRegisterSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Rejoignez DZ Immobilier en quelques secondes.'**
  String get authRegisterSubtitle;

  /// No description provided for @authForgotPasswordSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Entrez votre e-mail pour recevoir un lien de réinitialisation.'**
  String get authForgotPasswordSubtitle;

  /// No description provided for @authEmailHint.
  ///
  /// In fr, this message translates to:
  /// **'exemple@email.com'**
  String get authEmailHint;

  /// No description provided for @authNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Votre prénom et nom'**
  String get authNameHint;

  /// No description provided for @authPhoneHint.
  ///
  /// In fr, this message translates to:
  /// **'06 XX XX XX XX'**
  String get authPhoneHint;

  /// No description provided for @authConfirmPasswordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le mot de passe'**
  String get authConfirmPasswordLabel;

  /// No description provided for @authSendResetLink.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer le lien'**
  String get authSendResetLink;

  /// No description provided for @authBackToLogin.
  ///
  /// In fr, this message translates to:
  /// **'Retour à la connexion'**
  String get authBackToLogin;

  /// No description provided for @authResetSentTitle.
  ///
  /// In fr, this message translates to:
  /// **'E-mail envoyé !'**
  String get authResetSentTitle;

  /// No description provided for @authResetSentBody.
  ///
  /// In fr, this message translates to:
  /// **'Un lien de réinitialisation a été envoyé à {email}. Vérifiez votre boîte de réception.'**
  String authResetSentBody(String email);

  /// No description provided for @valEmailRequired.
  ///
  /// In fr, this message translates to:
  /// **'Email requis'**
  String get valEmailRequired;

  /// No description provided for @valEmailInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Email invalide'**
  String get valEmailInvalid;

  /// No description provided for @valPasswordRequired.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe requis'**
  String get valPasswordRequired;

  /// No description provided for @valPasswordMin.
  ///
  /// In fr, this message translates to:
  /// **'Au moins 8 caractères'**
  String get valPasswordMin;

  /// No description provided for @valPhoneRequired.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone requis'**
  String get valPhoneRequired;

  /// No description provided for @valPhoneInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Numéro invalide'**
  String get valPhoneInvalid;

  /// No description provided for @valNameRequired.
  ///
  /// In fr, this message translates to:
  /// **'Le nom est requis'**
  String get valNameRequired;

  /// No description provided for @valConfirmRequired.
  ///
  /// In fr, this message translates to:
  /// **'Confirmation requise'**
  String get valConfirmRequired;

  /// No description provided for @valPasswordMismatch.
  ///
  /// In fr, this message translates to:
  /// **'Les mots de passe ne correspondent pas'**
  String get valPasswordMismatch;

  /// No description provided for @homeEstimationAction.
  ///
  /// In fr, this message translates to:
  /// **'Estimation'**
  String get homeEstimationAction;

  /// No description provided for @homeEstimationSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Valeur de votre bien'**
  String get homeEstimationSubtitle;

  /// No description provided for @homeSimulationAction.
  ///
  /// In fr, this message translates to:
  /// **'Simulation'**
  String get homeSimulationAction;

  /// No description provided for @homeSimulationSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Crédit immobilier'**
  String get homeSimulationSubtitle;

  /// No description provided for @propertiesLoadMore.
  ///
  /// In fr, this message translates to:
  /// **'Voir plus ({count} restants)'**
  String propertiesLoadMore(int count);

  /// No description provided for @propertyBadgeSale.
  ///
  /// In fr, this message translates to:
  /// **'À vendre'**
  String get propertyBadgeSale;

  /// No description provided for @propertyBadgeRent.
  ///
  /// In fr, this message translates to:
  /// **'À louer'**
  String get propertyBadgeRent;

  /// No description provided for @propertyCardSpecs.
  ///
  /// In fr, this message translates to:
  /// **'{rooms} Ch · {area} m²'**
  String propertyCardSpecs(int rooms, int area);

  /// No description provided for @searchBarHint.
  ///
  /// In fr, this message translates to:
  /// **'Wilaya, quartier, mot-clé…'**
  String get searchBarHint;

  /// No description provided for @searchRecent.
  ///
  /// In fr, this message translates to:
  /// **'Recherches récentes'**
  String get searchRecent;

  /// No description provided for @searchPopularCities.
  ///
  /// In fr, this message translates to:
  /// **'Villes populaires'**
  String get searchPopularCities;

  /// No description provided for @searchAllListings.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les annonces'**
  String get searchAllListings;

  /// No description provided for @searchResultsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucun bien trouvé} =1{1 bien trouvé} other{{count} biens trouvés}}'**
  String searchResultsCount(num count);

  /// No description provided for @searchNoResultsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat'**
  String get searchNoResultsTitle;

  /// No description provided for @searchNoResultsBody.
  ///
  /// In fr, this message translates to:
  /// **'Nous n\'avons trouvé aucun bien correspondant à vos critères de recherche.'**
  String get searchNoResultsBody;

  /// No description provided for @searchResetFiltersBtn.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser les filtres'**
  String get searchResetFiltersBtn;

  /// No description provided for @searchDetailSoon.
  ///
  /// In fr, this message translates to:
  /// **'Détails du bien bientôt disponibles.'**
  String get searchDetailSoon;

  /// No description provided for @filterTransactionType.
  ///
  /// In fr, this message translates to:
  /// **'Type de transaction'**
  String get filterTransactionType;

  /// No description provided for @filterCategory.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie'**
  String get filterCategory;

  /// No description provided for @filterWilaya.
  ///
  /// In fr, this message translates to:
  /// **'Wilaya'**
  String get filterWilaya;

  /// No description provided for @filterBudget.
  ///
  /// In fr, this message translates to:
  /// **'Budget (DA)'**
  String get filterBudget;

  /// No description provided for @filterPriceMin.
  ///
  /// In fr, this message translates to:
  /// **'Prix Min'**
  String get filterPriceMin;

  /// No description provided for @filterPriceMax.
  ///
  /// In fr, this message translates to:
  /// **'Prix Max'**
  String get filterPriceMax;

  /// No description provided for @filterPriceMinHint.
  ///
  /// In fr, this message translates to:
  /// **'ex : 10 000 000'**
  String get filterPriceMinHint;

  /// No description provided for @filterPriceMaxHint.
  ///
  /// In fr, this message translates to:
  /// **'ex : 80 000 000'**
  String get filterPriceMaxHint;

  /// No description provided for @filterBedroomsMin.
  ///
  /// In fr, this message translates to:
  /// **'Chambres min'**
  String get filterBedroomsMin;

  /// No description provided for @filterAreaMin.
  ///
  /// In fr, this message translates to:
  /// **'Superficie min (m²)'**
  String get filterAreaMin;

  /// No description provided for @filterAreaHint.
  ///
  /// In fr, this message translates to:
  /// **'ex : 80'**
  String get filterAreaHint;

  /// No description provided for @propertyTypeApartment.
  ///
  /// In fr, this message translates to:
  /// **'Appartement'**
  String get propertyTypeApartment;

  /// No description provided for @propertyTypeVilla.
  ///
  /// In fr, this message translates to:
  /// **'Villa'**
  String get propertyTypeVilla;

  /// No description provided for @propertyTypeLand.
  ///
  /// In fr, this message translates to:
  /// **'Terrain'**
  String get propertyTypeLand;

  /// No description provided for @propertyTypeStudio.
  ///
  /// In fr, this message translates to:
  /// **'Studio'**
  String get propertyTypeStudio;

  /// No description provided for @commonStepProgress.
  ///
  /// In fr, this message translates to:
  /// **'Étape {current} / {total}'**
  String commonStepProgress(int current, int total);

  /// No description provided for @commonSelect.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner'**
  String get commonSelect;

  /// No description provided for @commonYears.
  ///
  /// In fr, this message translates to:
  /// **'{count} ans'**
  String commonYears(int count);

  /// No description provided for @simStep1Prefix.
  ///
  /// In fr, this message translates to:
  /// **'Simulez votre'**
  String get simStep1Prefix;

  /// No description provided for @simStep1Accent.
  ///
  /// In fr, this message translates to:
  /// **'financement.'**
  String get simStep1Accent;

  /// No description provided for @simStep2Prefix.
  ///
  /// In fr, this message translates to:
  /// **'Quel est votre'**
  String get simStep2Prefix;

  /// No description provided for @simStep2Accent.
  ///
  /// In fr, this message translates to:
  /// **'budget ?'**
  String get simStep2Accent;

  /// No description provided for @simStep3Prefix.
  ///
  /// In fr, this message translates to:
  /// **'Parlez-nous'**
  String get simStep3Prefix;

  /// No description provided for @simStep3Accent.
  ///
  /// In fr, this message translates to:
  /// **'de vous.'**
  String get simStep3Accent;

  /// No description provided for @simStep4Prefix.
  ///
  /// In fr, this message translates to:
  /// **'Un conseiller'**
  String get simStep4Prefix;

  /// No description provided for @simStep4Accent.
  ///
  /// In fr, this message translates to:
  /// **'vous rappelle.'**
  String get simStep4Accent;

  /// No description provided for @simSelectPropertyType.
  ///
  /// In fr, this message translates to:
  /// **'SÉLECTIONNER LE TYPE DE BIEN'**
  String get simSelectPropertyType;

  /// No description provided for @simInfoAnalysisBody.
  ///
  /// In fr, this message translates to:
  /// **'analyse les données du marché local avant chaque recommandation — taux, durées et conditions d\'éligibilité ajustés en temps réel selon votre profil.'**
  String get simInfoAnalysisBody;

  /// No description provided for @simStateProgramQuestion.
  ///
  /// In fr, this message translates to:
  /// **'Est-ce un programme de l\'État ?'**
  String get simStateProgramQuestion;

  /// No description provided for @simStateYes.
  ///
  /// In fr, this message translates to:
  /// **'Oui (LPP, LPA, LSP)'**
  String get simStateYes;

  /// No description provided for @simStateNo.
  ///
  /// In fr, this message translates to:
  /// **'Non (Libre)'**
  String get simStateNo;

  /// No description provided for @simStateNote.
  ///
  /// In fr, this message translates to:
  /// **'*Le taux à 1% ou 3% ne s\'applique qu\'aux programmes agréés.'**
  String get simStateNote;

  /// No description provided for @simPropertyPriceLabel.
  ///
  /// In fr, this message translates to:
  /// **'PRIX DU BIEN (DZD)'**
  String get simPropertyPriceLabel;

  /// No description provided for @simPropertyPriceHint.
  ///
  /// In fr, this message translates to:
  /// **'15 000 000'**
  String get simPropertyPriceHint;

  /// No description provided for @simDownPaymentLabel.
  ///
  /// In fr, this message translates to:
  /// **'VOTRE APPORT (DZD)'**
  String get simDownPaymentLabel;

  /// No description provided for @simDownPaymentHint.
  ///
  /// In fr, this message translates to:
  /// **'3 000 000'**
  String get simDownPaymentHint;

  /// No description provided for @simLeverageTitle.
  ///
  /// In fr, this message translates to:
  /// **'Effet de levier de l\'apport :'**
  String get simLeverageTitle;

  /// No description provided for @simLeverageMin.
  ///
  /// In fr, this message translates to:
  /// **'Apport légal minimum : 10% du prix du bien (réglementation Banque d\'Algérie).'**
  String get simLeverageMin;

  /// No description provided for @simLeverageRec.
  ///
  /// In fr, this message translates to:
  /// **'Apport recommandé : 20% à 30% pour des conditions optimales.'**
  String get simLeverageRec;

  /// No description provided for @simLeverageEff.
  ///
  /// In fr, this message translates to:
  /// **'Effet quantifié : sur un bien à 10M DZD, passer de 10% à 30% d\'apport économise ~2,5M DZD au coût total sur 20 ans.'**
  String get simLeverageEff;

  /// No description provided for @simMonthlyIncomeLabel.
  ///
  /// In fr, this message translates to:
  /// **'REVENU MENSUEL NET (DZD)'**
  String get simMonthlyIncomeLabel;

  /// No description provided for @simIncomeHint.
  ///
  /// In fr, this message translates to:
  /// **'120 000'**
  String get simIncomeHint;

  /// No description provided for @simAgeLabel.
  ///
  /// In fr, this message translates to:
  /// **'ÂGE'**
  String get simAgeLabel;

  /// No description provided for @simAgeHint.
  ///
  /// In fr, this message translates to:
  /// **'35'**
  String get simAgeHint;

  /// No description provided for @simEmploymentTypeLabel.
  ///
  /// In fr, this message translates to:
  /// **'TYPE D\'EMPLOI'**
  String get simEmploymentTypeLabel;

  /// No description provided for @simEmpSalaried.
  ///
  /// In fr, this message translates to:
  /// **'Salarié'**
  String get simEmpSalaried;

  /// No description provided for @simEmpCivilServant.
  ///
  /// In fr, this message translates to:
  /// **'Fonctionnaire'**
  String get simEmpCivilServant;

  /// No description provided for @simEmpSelfEmployed.
  ///
  /// In fr, this message translates to:
  /// **'Auto-entrepreneur'**
  String get simEmpSelfEmployed;

  /// No description provided for @simEmpBusinessOwner.
  ///
  /// In fr, this message translates to:
  /// **'Chef d\'entreprise'**
  String get simEmpBusinessOwner;

  /// No description provided for @simStateTiersTitle.
  ///
  /// In fr, this message translates to:
  /// **'Paliers de l\'aide de l\'État :'**
  String get simStateTiersTitle;

  /// No description provided for @simIncomeTier1.
  ///
  /// In fr, this message translates to:
  /// **'Revenu ≤ 108 000 DZD → taux à 1%'**
  String get simIncomeTier1;

  /// No description provided for @simIncomeTier2.
  ///
  /// In fr, this message translates to:
  /// **'Revenu ≤ 216 000 DZD → taux à 3%'**
  String get simIncomeTier2;

  /// No description provided for @simIncomeAboveMarket.
  ///
  /// In fr, this message translates to:
  /// **'Au-dessus → financement marché libre (~6,25%)'**
  String get simIncomeAboveMarket;

  /// No description provided for @simAgeLimitTitle.
  ///
  /// In fr, this message translates to:
  /// **'Limite réglementaire d\'âge :'**
  String get simAgeLimitTitle;

  /// No description provided for @simAgeLimitBody.
  ///
  /// In fr, this message translates to:
  /// **'L\'âge en fin de prêt ne peut dépasser 75 ans (Banque d\'Algérie). À votre âge, la durée maximale du prêt est de {term} ans.'**
  String simAgeLimitBody(int term);

  /// No description provided for @simFullNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'NOM COMPLET'**
  String get simFullNameLabel;

  /// No description provided for @simFullNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Mohamed Amine'**
  String get simFullNameHint;

  /// No description provided for @simPhoneLabel.
  ///
  /// In fr, this message translates to:
  /// **'TÉLÉPHONE'**
  String get simPhoneLabel;

  /// No description provided for @simPhoneHint.
  ///
  /// In fr, this message translates to:
  /// **'+213 5XX XX XX XX · +33 6 XX XX XX XX'**
  String get simPhoneHint;

  /// No description provided for @simEmailLabel.
  ///
  /// In fr, this message translates to:
  /// **'EMAIL (OPTIONNEL)'**
  String get simEmailLabel;

  /// No description provided for @simEmailHint.
  ///
  /// In fr, this message translates to:
  /// **'contact@email.dz'**
  String get simEmailHint;

  /// No description provided for @simPrivacyNotice.
  ///
  /// In fr, this message translates to:
  /// **'Vos données sont confidentielles et utilisées uniquement pour vous envoyer votre simulation personnalisée. Aucune communication commerciale sans votre consentement.'**
  String get simPrivacyNotice;

  /// No description provided for @simResultSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Simulation personnalisée basée sur votre profil'**
  String get simResultSubtitle;

  /// No description provided for @simResultLoading.
  ///
  /// In fr, this message translates to:
  /// **'Calcul de vos offres en cours…'**
  String get simResultLoading;

  /// No description provided for @simResultBadge.
  ///
  /// In fr, this message translates to:
  /// **'RÉSULTATS · COMPARAISON ÉDUCATIVE'**
  String get simResultBadge;

  /// No description provided for @simDuelPrefix.
  ///
  /// In fr, this message translates to:
  /// **'Le Duel :'**
  String get simDuelPrefix;

  /// No description provided for @simDuelAccent.
  ///
  /// In fr, this message translates to:
  /// **'Conventionnel\nvs Mourabaha.'**
  String get simDuelAccent;

  /// No description provided for @simLoanConventional.
  ///
  /// In fr, this message translates to:
  /// **'PRÊT CONVENTIONNEL'**
  String get simLoanConventional;

  /// No description provided for @simLoanMourabaha.
  ///
  /// In fr, this message translates to:
  /// **'MOURABAHA ISLAMIQUE'**
  String get simLoanMourabaha;

  /// No description provided for @simDaPerMonth.
  ///
  /// In fr, this message translates to:
  /// **'DA/mois'**
  String get simDaPerMonth;

  /// No description provided for @simRateLabel.
  ///
  /// In fr, this message translates to:
  /// **'Taux :'**
  String get simRateLabel;

  /// No description provided for @simDurationLabel.
  ///
  /// In fr, this message translates to:
  /// **'Durée :'**
  String get simDurationLabel;

  /// No description provided for @simDurationValue.
  ///
  /// In fr, this message translates to:
  /// **'{years} ans ({months} mensualités)'**
  String simDurationValue(int years, int months);

  /// No description provided for @simTotalInterest.
  ///
  /// In fr, this message translates to:
  /// **'Intérêts totaux'**
  String get simTotalInterest;

  /// No description provided for @simTotalMargin.
  ///
  /// In fr, this message translates to:
  /// **'Marge totale'**
  String get simTotalMargin;

  /// No description provided for @simHowItWorks.
  ///
  /// In fr, this message translates to:
  /// **'ℹ️ Comment ça marche ?'**
  String get simHowItWorks;

  /// No description provided for @simHowConventional.
  ///
  /// In fr, this message translates to:
  /// **'La banque vous prête de l\'argent. Vous remboursez le capital + intérêts calculés sur le solde restant chaque mois (méthode des intérêts composés).'**
  String get simHowConventional;

  /// No description provided for @simHowMourabaha.
  ///
  /// In fr, this message translates to:
  /// **'La banque achète le bien pour vous, puis vous le revend avec une marge connue à l\'avance. Pas de Riba variable. Structure juridique : contrat achat-revente.'**
  String get simHowMourabaha;

  /// No description provided for @simExpertAnalysis.
  ///
  /// In fr, this message translates to:
  /// **'Analyse DZ-Immobilier Expert'**
  String get simExpertAnalysis;

  /// No description provided for @simExpertBody.
  ///
  /// In fr, this message translates to:
  /// **'L\'écart entre les deux modèles est de {gap} pour la Mourabaha par rapport au prêt conventionnel.\nConclusion : Si le coût final est souvent proche, la structure juridique est fondamentalement différente : le prêt conventionnel est un contrat de prêt d\'argent (Qard), tandis que la Mourabaha est un contrat achat-revente (Bay\'). Ce choix dépend autant de vos convictions personnelles que de votre calcul financier.'**
  String simExpertBody(String gap);

  /// No description provided for @simDebtRatioLabel.
  ///
  /// In fr, this message translates to:
  /// **'Taux d\'endettement'**
  String get simDebtRatioLabel;

  /// No description provided for @simDebtExceeded.
  ///
  /// In fr, this message translates to:
  /// **'Capacité d\'endettement dépassée. Solutions : augmenter l\'apport, prolonger la durée, ou ajouter un co-emprunteur.'**
  String get simDebtExceeded;

  /// No description provided for @simBankOffersTitle.
  ///
  /// In fr, this message translates to:
  /// **'Offres par banque partenaire'**
  String get simBankOffersTitle;

  /// No description provided for @simBankColumn.
  ///
  /// In fr, this message translates to:
  /// **'Banque'**
  String get simBankColumn;

  /// No description provided for @simRateColumn.
  ///
  /// In fr, this message translates to:
  /// **'Taux'**
  String get simRateColumn;

  /// No description provided for @simMonthlyColumn.
  ///
  /// In fr, this message translates to:
  /// **'Mensualité'**
  String get simMonthlyColumn;

  /// No description provided for @simRateAnnual.
  ///
  /// In fr, this message translates to:
  /// **'{rate} % annuel'**
  String simRateAnnual(int rate);

  /// No description provided for @mapResultsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 annonce} other{{count} annonces}}'**
  String mapResultsCount(int count);

  /// No description provided for @mapOffMap.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 annonce sans localisation} other{{count} annonces sans localisation}}'**
  String mapOffMap(int count);

  /// No description provided for @homeRecentListings.
  ///
  /// In fr, this message translates to:
  /// **'Annonces récentes'**
  String get homeRecentListings;

  /// No description provided for @homeViewMap.
  ///
  /// In fr, this message translates to:
  /// **'Carte'**
  String get homeViewMap;

  /// No description provided for @homeSearchShortcut.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un bien…'**
  String get homeSearchShortcut;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
