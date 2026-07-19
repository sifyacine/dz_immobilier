import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/constants/api_constants.dart';
import '../../../app/constants/app_constants.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_gradients.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/storage_service.dart';
import '../../../shared/widgets/app_button.dart';
import '../controllers/profile_controller.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/profile_partner_banner.dart';
import '../widgets/profile_section_header.dart';
import '../widgets/profile_stat_card.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = Get.find<StorageService>();
    final controller = Get.find<ProfileController>();
    return storage.isLoggedIn
        ? _LoggedInProfile(controller: controller)
        : _GuestProfile(controller: controller);
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// LOGGED-IN PROFILE
// ══════════════════════════════════════════════════════════════════════════════

class _LoggedInProfile extends StatelessWidget {
  final ProfileController controller;
  const _LoggedInProfile({required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : AppColors.background;
    final cardBg = isDark ? AppColors.darkCard : AppColors.surface;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Top app bar ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppConstants.spacingMd, AppConstants.spacingMd,
                    AppConstants.spacingMd, 0),
                child: Text('Mon compte', style: AppTextStyles.h2),
              ),
            ),

            // ── User identity card ───────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                child: Container(
                  padding: const EdgeInsets.all(AppConstants.spacingMd),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusMd),
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0x0A0A0A41),
                          blurRadius: 12,
                          offset: Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Avatar circle with initial + verified tick
                      Stack(
                        children: [
                          Container(
                            width: 58,
                            height: 58,
                            decoration: const BoxDecoration(
                              gradient: AppGradients.purpleFade,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Obx(() => Text(controller.initial,
                                  style: AppTextStyles.h2
                                      .copyWith(color: Colors.white))),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: cardBg, width: 2),
                              ),
                              child: const Icon(Icons.check,
                                  size: 10, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: AppConstants.spacingMd),
                      // Name + tier + since
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() => Text(
                                  controller.name.value.isNotEmpty
                                      ? controller.name.value
                                      : 'Utilisateur',
                                  style: AppTextStyles.h3)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                // Tier badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFCD7F32)
                                        .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(
                                        AppConstants.radiusPill),
                                  ),
                                  child: Text('BRONZE',
                                      style: AppTextStyles.caption
                                          .copyWith(
                                        color: const Color(0xFFCD7F32),
                                        fontWeight: FontWeight.w800,
                                        fontSize: 10,
                                      )),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Obx(() => Text(
                                        controller.memberSince.value.isNotEmpty
                                            ? controller.memberSince.value
                                            : 'Membre',
                                        style: AppTextStyles.caption,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                ),
                              ],
                            ),
                            Obx(() => controller.email.value.isEmpty
                                ? const SizedBox.shrink()
                                : Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text(controller.email.value,
                                        style: AppTextStyles.caption,
                                        overflow: TextOverflow.ellipsis),
                                  )),
                          ],
                        ),
                      ),
                      // Settings icon
                      IconButton(
                        icon: Icon(Icons.settings_outlined,
                            size: 22,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textHint),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Stats row ────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingMd),
                child: Row(
                  children: [
                    Expanded(
                      child: ProfileStatCard(
                        icon: Icons.trending_up_rounded,
                        iconColor: AppColors.primary,
                        iconBg: AppColors.violetSurface,
                        count: 0,
                        label: 'ESTIMATIONS',
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingSm),
                    Expanded(
                      child: ProfileStatCard(
                        icon: Icons.favorite_rounded,
                        iconColor: AppColors.error,
                        iconBg: AppColors.errorSurface,
                        count: 0,
                        label: 'FAVORIS',
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingSm),
                    Expanded(
                      child: ProfileStatCard(
                        icon: Icons.apartment_rounded,
                        iconColor: const Color(0xFF0891B2),
                        iconBg: const Color(0xFFCFFAFE),
                        count: 0,
                        label: 'ANNONCES',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── SHORTCUTS ────────────────────────────────────────────────
            const SliverToBoxAdapter(
                child: ProfileSectionHeader(title: 'Raccourcis')),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingMd),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: AppButton(
                        label: 'Nouvelle estimation',
                        variant: AppButtonVariant.gradient,
                        icon: Icons.auto_awesome,
                        onPressed: () => Get.toNamed(Routes.speed30),
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingSm),
                    Expanded(
                      flex: 2,
                      child: AppButton(
                        label: 'Comparer',
                        variant: AppButtonVariant.outline,
                        icon: Icons.balance_outlined,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── MY ACTIVITY ──────────────────────────────────────────────
            const SliverToBoxAdapter(
                child: ProfileSectionHeader(title: 'Mon activité')),
            SliverToBoxAdapter(
              child: _MenuCard(
                children: [
                  ProfileMenuItem(
                    icon: Icons.trending_up_rounded,
                    iconColor: AppColors.primary,
                    iconBg: AppColors.violetSurface,
                    title: 'Mes estimations',
                    subtitle: '0 rapports experts',
                    count: 0,
                  ),
                  _Divider(),
                  ProfileMenuItem(
                    icon: Icons.favorite_rounded,
                    iconColor: AppColors.error,
                    iconBg: AppColors.errorSurface,
                    title: 'Mes favoris',
                    subtitle: '0 biens sauvegardés',
                    count: 0,
                  ),
                  _Divider(),
                  ProfileMenuItem(
                    icon: Icons.home_outlined,
                    iconColor: const Color(0xFF0891B2),
                    iconBg: const Color(0xFFCFFAFE),
                    title: 'Mes annonces',
                    subtitle: 'Gérer mes publications',
                    count: 0,
                  ),
                  _Divider(),
                  ProfileMenuItem(
                    icon: Icons.calendar_today_outlined,
                    iconColor: AppColors.warning,
                    iconBg: AppColors.warningSurface,
                    title: 'Mes rendez-vous',
                    subtitle: '0 visites planifiées',
                    count: 0,
                  ),
                ],
              ),
            ),

            // ── DOCUMENTS & INVOICING ─────────────────────────────────────
            const SliverToBoxAdapter(
                child: ProfileSectionHeader(
                    title: 'Documents & Facturation')),
            SliverToBoxAdapter(
              child: _MenuCard(
                children: [
                  ProfileMenuItem(
                    icon: Icons.description_outlined,
                    iconColor: const Color(0xFFD97706),
                    iconBg: const Color(0xFFFEF3C7),
                    title: 'Mes documents',
                    subtitle: 'Contrats, mandats, PDF',
                  ),
                  _Divider(),
                  ProfileMenuItem(
                    icon: Icons.shopping_bag_outlined,
                    iconColor: AppColors.error,
                    iconBg: AppColors.errorSurface,
                    title: 'Mes commandes',
                    subtitle: 'Suivi & paiement',
                  ),
                  _Divider(),
                  ProfileMenuItem(
                    icon: Icons.receipt_outlined,
                    iconColor: AppColors.textSecondary,
                    iconBg: AppColors.border,
                    title: 'Mes factures',
                    subtitle: 'Téléchargement PDF',
                  ),
                ],
              ),
            ),

            // ── MY DZ TOOLS ───────────────────────────────────────────────
            const SliverToBoxAdapter(
                child: ProfileSectionHeader(title: 'Mes outils DZ')),
            SliverToBoxAdapter(
              child: _MenuCard(
                children: [
                  ProfileMenuItem(
                    icon: Icons.balance_outlined,
                    iconColor: AppColors.primary,
                    iconBg: AppColors.violetSurface,
                    title: 'Comparateur de crédits',
                    subtitle: 'CNEP, BEA, BNA, CPA, Salam, Al Baraka',
                  ),
                  _Divider(),
                  ProfileMenuItem(
                    icon: Icons.calculate_outlined,
                    iconColor: const Color(0xFF0891B2),
                    iconBg: const Color(0xFFCFFAFE),
                    title: 'Calculatrices DZ',
                    subtitle: 'Mensualité, capacité, frais notaire',
                  ),
                  _Divider(),
                  ProfileMenuItem(
                    icon: Icons.contacts_outlined,
                    iconColor: AppColors.textSecondary,
                    iconBg: AppColors.border,
                    title: 'Annuaire des experts',
                    subtitle: 'Notaires, avocats, géomètres, conseillers',
                  ),
                ],
              ),
            ),

            // ── ACCOUNT & PREFERENCES ─────────────────────────────────────
            const SliverToBoxAdapter(
                child: ProfileSectionHeader(
                    title: 'Compte & Préférences')),
            SliverToBoxAdapter(
              child: _MenuCard(
                children: [
                  Obx(() => ProfileMenuItem(
                        icon: Icons.translate_rounded,
                        iconColor: AppColors.primary,
                        iconBg: AppColors.violetSurface,
                        title: 'Langue',
                        subtitle: "Langue de l'application",
                        trailingText: controller.languageLabel,
                        onTap: controller.changeLanguage,
                      )),
                  _Divider(),
                  Obx(() => ProfileMenuItem(
                        icon: Icons.dark_mode_outlined,
                        iconColor: const Color(0xFF0891B2),
                        iconBg: const Color(0xFFCFFAFE),
                        title: 'Apparence',
                        subtitle: 'Thème clair ou sombre',
                        trailingText: controller.themeLabel,
                        onTap: controller.changeTheme,
                      )),
                  _Divider(),
                  ProfileMenuItem(
                    icon: Icons.security_outlined,
                    iconColor: AppColors.primary,
                    iconBg: AppColors.violetSurface,
                    title: 'Connexion & sécurité',
                    subtitle: 'Mot de passe, double authentification',
                  ),
                  _Divider(),
                  ProfileMenuItem(
                    icon: Icons.notifications_outlined,
                    iconColor: AppColors.error,
                    iconBg: AppColors.errorSurface,
                    title: 'Notifications',
                    subtitle: 'Alertes prix & messages',
                  ),
                  _Divider(),
                  ProfileMenuItem(
                    icon: Icons.language_outlined,
                    iconColor: const Color(0xFF0891B2),
                    iconBg: const Color(0xFFCFFAFE),
                    title: 'Espace Diaspora',
                    subtitle: 'FAQ adaptée à votre pays de résidence',
                    badgeLabel: 'Premium',
                    badgeColor: AppColors.primary,
                  ),
                ],
              ),
            ),

            // ── Partner banner ────────────────────────────────────────────
            SliverToBoxAdapter(
              child: ProfilePartnerBanner(
                  onTap: controller.openAgencySignup),
            ),

            // ── Logout ────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppConstants.spacingMd, 0,
                    AppConstants.spacingMd, AppConstants.spacingXl),
                child: Center(
                  child: TextButton.icon(
                    icon: const Icon(Icons.logout_rounded, size: 18),
                    label: const Text('Se déconnecter'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                    ),
                    onPressed: () async {
                      final api = Get.find<ApiClient>();
                      try {
                        await api.call(ApiConstants.logout, params: {});
                      } catch (_) {}
                      await api.clearSession();
                      await Get.find<StorageService>().clear();
                      Get.offAllNamed(Routes.shell);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// GUEST PROFILE
// ══════════════════════════════════════════════════════════════════════════════

class _GuestProfile extends StatelessWidget {
  final ProfileController controller;
  const _GuestProfile({required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : AppColors.background;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppConstants.spacingMd, AppConstants.spacingMd,
                    AppConstants.spacingMd, 0),
                child: Text('Mon compte', style: AppTextStyles.h2),
              ),
            ),

            // Login/register hero
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                child: Container(
                  padding: const EdgeInsets.all(AppConstants.spacingXl),
                  decoration: BoxDecoration(
                    gradient: AppGradients.purpleFade,
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusMd),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.20),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person_outline,
                            size: 44, color: Colors.white),
                      ),
                      const SizedBox(height: AppConstants.spacingMd),
                      Text(
                        'Connectez-vous',
                        style: AppTextStyles.h2
                            .copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: AppConstants.spacingSm),
                      Text(
                        'Accédez à vos favoris, annonces et\noutils depuis votre compte.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodySecondary.copyWith(
                            color: Colors.white.withValues(alpha: 0.80)),
                      ),
                      const SizedBox(height: AppConstants.spacingXl),
                      // White solid button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () =>
                              Get.toNamed(Routes.login),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            elevation: 0,
                            shape: const StadiumBorder(),
                          ),
                          child: Text('Se connecter',
                              style: AppTextStyles.button.copyWith(
                                  color: AppColors.primary)),
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingSm),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton(
                          onPressed: () =>
                              Get.toNamed(Routes.register),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(
                                color: Colors.white, width: 1.5),
                            shape: const StadiumBorder(),
                          ),
                          child: Text('Créer un compte',
                              style: AppTextStyles.button
                                  .copyWith(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Tools section (accessible even when guest)
            const SliverToBoxAdapter(
                child: ProfileSectionHeader(title: 'Outils gratuits')),
            SliverToBoxAdapter(
              child: _MenuCard(
                children: [
                  ProfileMenuItem(
                    icon: Icons.balance_outlined,
                    iconColor: AppColors.primary,
                    iconBg: AppColors.violetSurface,
                    title: 'Comparateur de crédits',
                    subtitle: 'CNEP, BEA, BNA, CPA, Salam, Al Baraka',
                  ),
                  _Divider(),
                  ProfileMenuItem(
                    icon: Icons.calculate_outlined,
                    iconColor: const Color(0xFF0891B2),
                    iconBg: const Color(0xFFCFFAFE),
                    title: 'Calculatrices DZ',
                    subtitle: 'Mensualité, capacité, frais notaire',
                  ),
                  _Divider(),
                  ProfileMenuItem(
                    icon: Icons.contacts_outlined,
                    iconColor: AppColors.textSecondary,
                    iconBg: AppColors.border,
                    title: 'Annuaire des experts',
                    subtitle: 'Notaires, avocats, géomètres, conseillers',
                  ),
                ],
              ),
            ),

            // Preferences (language + theme) — available to guests too
            const SliverToBoxAdapter(
                child: ProfileSectionHeader(title: 'Préférences')),
            SliverToBoxAdapter(
              child: _MenuCard(
                children: [
                  Obx(() => ProfileMenuItem(
                        icon: Icons.translate_rounded,
                        iconColor: AppColors.primary,
                        iconBg: AppColors.violetSurface,
                        title: 'Langue',
                        subtitle: "Langue de l'application",
                        trailingText: controller.languageLabel,
                        onTap: controller.changeLanguage,
                      )),
                  _Divider(),
                  Obx(() => ProfileMenuItem(
                        icon: Icons.dark_mode_outlined,
                        iconColor: const Color(0xFF0891B2),
                        iconBg: const Color(0xFFCFFAFE),
                        title: 'Apparence',
                        subtitle: 'Thème clair ou sombre',
                        trailingText: controller.themeLabel,
                        onTap: controller.changeTheme,
                      )),
                ],
              ),
            ),

            // Partner banner
            SliverToBoxAdapter(
                child: ProfilePartnerBanner(
                    onTap: controller.openAgencySignup)),

            const SliverToBoxAdapter(
                child: SizedBox(height: AppConstants.spacingXl)),
          ],
        ),
      ),
    );
  }
}

// ── Private helpers ───────────────────────────────────────────────────────────

/// Card container that groups a list of [ProfileMenuItem]s.
class _MenuCard extends StatelessWidget {
  final List<Widget> children;
  const _MenuCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMd, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0A0A0A41),
                blurRadius: 8,
                offset: Offset(0, 2)),
          ],
        ),
        child: Column(children: children),
      ),
    );
  }
}

/// Thin divider between menu items.
class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Divider(
      height: 1,
      thickness: 1,
      indent: 72,
      color: isDark ? AppColors.darkSurface : AppColors.border,
    );
  }
}
