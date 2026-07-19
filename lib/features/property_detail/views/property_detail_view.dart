import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../app/constants/app_constants.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_gradients.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../data/models/property_detail_model.dart';
import '../../../shared/widgets/app_badge.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_shimmer.dart';
import '../controllers/property_detail_controller.dart';

/// Full listing detail screen (mirrors the website product page):
/// gallery, price + AI valuation, specs, DZ scores, description, financing,
/// and the selling agency, with a sticky contact bar.
class PropertyDetailView extends GetView<PropertyDetailController> {
  const PropertyDetailView({super.key});

  static final _money = NumberFormat.decimalPattern('fr');

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: Obx(() {
        final d = controller.detail.value;
        if (controller.isLoading.value && d == null) {
          return const _DetailSkeleton();
        }
        if (d == null) {
          return _ErrorState(
            message: controller.error.value.isEmpty
                ? 'Annonce introuvable.'
                : controller.error.value,
            onRetry: controller.load,
          );
        }
        return _Content(controller: controller, detail: d, isDark: isDark);
      }),
      bottomNavigationBar: Obx(
        () => controller.detail.value == null
            ? const SizedBox.shrink()
            : _BottomBar(controller: controller, isDark: isDark),
      ),
    );
  }

  static String money(double v) => _money.format(v);
  static String compactM(double v) =>
      '${(v / 1000000).toStringAsFixed(1).replaceAll('.', ',')}M';
}

// ════════════════════════════════════════════════════════════════════════════
// CONTENT
// ════════════════════════════════════════════════════════════════════════════

class _Content extends StatelessWidget {
  final PropertyDetailController controller;
  final PropertyDetail detail;
  final bool isDark;
  const _Content({
    required this.controller,
    required this.detail,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final d = detail;
    return CustomScrollView(
      slivers: [
        _GallerySliver(controller: controller, detail: d),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Header(detail: d),
                const SizedBox(height: AppConstants.spacingMd),
                _PriceCard(detail: d),
                const SizedBox(height: AppConstants.spacingMd),
                _QuickActions(controller: controller),
                const SizedBox(height: AppConstants.spacingLg),
                _SpecsSection(detail: d, isDark: isDark),
                if (d.hasValuation) ...[
                  const SizedBox(height: AppConstants.spacingLg),
                  _ValuationCard(detail: d, isDark: isDark),
                ],
                if (_hasScores(d)) ...[
                  const SizedBox(height: AppConstants.spacingLg),
                  _ScoresCard(detail: d, isDark: isDark),
                ],
                if (d.descriptionText.isNotEmpty) ...[
                  const SizedBox(height: AppConstants.spacingLg),
                  _DescriptionCard(detail: d, isDark: isDark),
                ],
                if (d.hasCredit) ...[
                  const SizedBox(height: AppConstants.spacingLg),
                  _FinancingCard(
                      detail: d, isDark: isDark, controller: controller),
                ],
                const SizedBox(height: AppConstants.spacingLg),
                _AgencyCard(
                    detail: d, isDark: isDark, controller: controller),
                const SizedBox(height: AppConstants.spacingMd),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static bool _hasScores(PropertyDetail d) =>
      d.familyScore +
          d.investorScore +
          d.liquidityScore +
          d.rentalScore +
          d.standingScore >
      0;
}

// ── Gallery ─────────────────────────────────────────────────────────────────

class _GallerySliver extends StatelessWidget {
  final PropertyDetailController controller;
  final PropertyDetail detail;
  const _GallerySliver({required this.controller, required this.detail});

  @override
  Widget build(BuildContext context) {
    final images = detail.images;
    return SliverAppBar(
      pinned: true,
      expandedHeight: 320,
      backgroundColor: AppColors.federal,
      foregroundColor: Colors.white,
      leading: _CircleIcon(
        icon: Icons.arrow_back,
        onTap: Get.back,
      ),
      actions: [
        Obx(() => _CircleIcon(
              icon: controller.isFavorite.value
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: controller.isFavorite.value ? AppColors.accent : null,
              onTap: controller.toggleFavorite,
            )),
        _CircleIcon(icon: Icons.share_outlined, onTap: controller.share),
        const SizedBox(width: 4),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              itemCount: images.isEmpty ? 1 : images.length,
              onPageChanged: (i) => controller.carouselIndex.value = i,
              itemBuilder: (_, i) {
                if (images.isEmpty) {
                  return Container(color: AppColors.border);
                }
                return CachedNetworkImage(
                  imageUrl: images[i],
                  fit: BoxFit.cover,
                  placeholder: (_, _) => Container(color: AppColors.border),
                  errorWidget: (_, _, _) => Container(
                    color: AppColors.border,
                    child: const Icon(Icons.home_outlined,
                        size: 48, color: AppColors.textHint),
                  ),
                );
              },
            ),
            // Bottom gradient for legibility
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [Color(0x66000000), Colors.transparent],
                ),
              ),
            ),
            // Ref badge
            if (detail.ref.isNotEmpty)
              Positioned(
                top: kToolbarHeight + 8,
                left: AppConstants.spacingMd,
                child: AppBadge(label: detail.ref, tone: AppBadgeTone.solid),
              ),
            // Page dots
            if (images.length > 1)
              Positioned(
                bottom: AppConstants.spacingMd,
                left: 0,
                right: 0,
                child: Obx(() => _Dots(
                      count: images.length,
                      active: controller.carouselIndex.value,
                    )),
              ),
          ],
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  final int count;
  final int active;
  const _Dots({required this.count, required this.active});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final on = i == active;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: on ? 18 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: on ? Colors.white : Colors.white54,
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  const _CircleIcon({required this.icon, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: Colors.black.withValues(alpha: 0.35),
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, size: 20, color: color ?? Colors.white),
          ),
        ),
      ),
    );
  }
}

// ── Header ──────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final PropertyDetail detail;
  const _Header({required this.detail});

  @override
  Widget build(BuildContext context) {
    final d = detail;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppBadge(
              label: d.isRent ? 'À louer' : 'À vendre',
              tone: d.isRent ? AppBadgeTone.danger : AppBadgeTone.info,
            ),
            if (d.category.isNotEmpty) ...[
              const SizedBox(width: AppConstants.spacingSm),
              Text(d.category, style: AppTextStyles.bodySecondary),
            ],
            const Spacer(),
            if (d.publishedDaysAgo > 0)
              Text('Publié il y a ${d.publishedDaysAgo} j',
                  style: AppTextStyles.caption),
          ],
        ),
        const SizedBox(height: AppConstants.spacingSm),
        Text(d.title, style: AppTextStyles.h2),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.location_on_outlined,
                size: 16, color: AppColors.textHint),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                [d.neighborhood, d.city].where((s) => s.isNotEmpty).join(', '),
                style: AppTextStyles.bodySecondary,
              ),
            ),
          ],
        ),
        if (d.dgiCompliant || d.diasporaFriendly) ...[
          const SizedBox(height: AppConstants.spacingSm),
          Wrap(
            spacing: AppConstants.spacingSm,
            runSpacing: AppConstants.spacingXs,
            children: [
              if (d.dgiCompliant)
                const AppBadge(
                    label: 'Conforme fiscalité',
                    tone: AppBadgeTone.success,
                    icon: Icons.verified_outlined),
              if (d.diasporaFriendly)
                const AppBadge(
                    label: 'Diaspora-friendly',
                    tone: AppBadgeTone.info,
                    icon: Icons.public),
            ],
          ),
        ],
      ],
    );
  }
}

// ── Price card ──────────────────────────────────────────────────────────────

class _PriceCard extends StatelessWidget {
  final PropertyDetail detail;
  const _PriceCard({required this.detail});

  @override
  Widget build(BuildContext context) {
    final d = detail;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: AppGradients.inkViolet,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Prix demandé',
              style: AppTextStyles.caption.copyWith(color: Colors.white70)),
          const SizedBox(height: 4),
          Text(
            '${PropertyDetailView.money(d.price)} ${d.currency}',
            style: AppTextStyles.h1.copyWith(color: Colors.white),
          ),
          if (d.pricePerSqm > 0)
            Text(
              '${PropertyDetailView.money(d.pricePerSqm)} ${d.currency}/m² · négociable',
              style: AppTextStyles.bodySecondary.copyWith(color: Colors.white70),
            ),
          if (d.hasValuation) ...[
            Divider(
                height: AppConstants.spacingLg * 1.4,
                color: Colors.white.withValues(alpha: 0.18)),
            Text('Estimation IA',
                style: AppTextStyles.caption.copyWith(color: Colors.white70)),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${PropertyDetailView.compactM(d.valuationMin)} → ${PropertyDetailView.compactM(d.valuationMax)}',
                  style: AppTextStyles.h3.copyWith(color: AppColors.heliotrope),
                ),
              ],
            ),
            if (d.alignedText.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(d.alignedText,
                  style: AppTextStyles.caption
                      .copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
            ],
            if (d.valuationConfidence > 0) ...[
              const SizedBox(height: AppConstants.spacingMd),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Confiance',
                      style:
                          AppTextStyles.caption.copyWith(color: Colors.white70)),
                  Text('${(d.valuationConfidence * 100).round()}%',
                      style: AppTextStyles.title.copyWith(color: Colors.white)),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: d.valuationConfidence.clamp(0, 1),
                  minHeight: 8,
                  backgroundColor: Colors.white24,
                  valueColor:
                      const AlwaysStoppedAnimation(AppColors.heliotrope),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

// ── Quick actions ───────────────────────────────────────────────────────────

class _QuickActions extends StatelessWidget {
  final PropertyDetailController controller;
  const _QuickActions({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _QuickAction(
            icon: Icons.share_outlined,
            label: 'Partager',
            onTap: controller.share),
        _QuickAction(
            icon: Icons.balance_outlined,
            label: 'Comparer',
            onTap: controller.openComparator),
        Obx(() => _QuickAction(
              icon: controller.isFavorite.value
                  ? Icons.favorite
                  : Icons.favorite_border,
              label: 'Sauvegarder',
              onTap: controller.toggleFavorite,
            )),
        _QuickAction(
            icon: Icons.handshake_outlined,
            label: 'Faire une offre',
            onTap: controller.makeOffer),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickAction(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(height: 4),
            Text(label,
                style: AppTextStyles.caption
                    .copyWith(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

// ── Specs ───────────────────────────────────────────────────────────────────

class _SpecsSection extends StatelessWidget {
  final PropertyDetail detail;
  final bool isDark;
  const _SpecsSection({required this.detail, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final d = detail;
    final tiles = <Widget>[
      if (d.surface > 0)
        _SpecTile(
            icon: Icons.straighten,
            value: '${d.surface.toInt()} m²',
            label: 'Surface',
            isDark: isDark),
      if (d.typeLabel.isNotEmpty && d.typeLabel != '—')
        _SpecTile(
            icon: Icons.home_work_outlined,
            value: d.typeLabel,
            label: 'Type',
            isDark: isDark),
      if (d.bedrooms > 0)
        _SpecTile(
            icon: Icons.bed_outlined,
            value: '${d.bedrooms}',
            label: 'Chambres',
            isDark: isDark),
      if (d.bathrooms > 0)
        _SpecTile(
            icon: Icons.bathtub_outlined,
            value: '${d.bathrooms}',
            label: 'Salles de bain',
            isDark: isDark),
      if (d.parkings > 0)
        _SpecTile(
            icon: Icons.directions_car_outlined,
            value: '${d.parkings}',
            label: 'Parkings',
            isDark: isDark),
      if (d.floorTotal > 0)
        _SpecTile(
            icon: Icons.stairs_outlined,
            value: '${d.floorNumber}/${d.floorTotal}',
            label: 'Étage',
            isDark: isDark),
    ];
    if (tiles.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('Caractéristiques'),
        const SizedBox(height: AppConstants.spacingSm),
        LayoutBuilder(builder: (context, c) {
          const gap = AppConstants.spacingSm;
          final w = (c.maxWidth - gap) / 2;
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: [
              for (final t in tiles) SizedBox(width: w, child: t),
            ],
          );
        }),
      ],
    );
  }
}

class _SpecTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final bool isDark;
  const _SpecTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: _cardDecoration(isDark),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.violetSurface,
              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: AppConstants.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: AppTextStyles.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text(label,
                    style: AppTextStyles.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Valuation analysis ──────────────────────────────────────────────────────

class _ValuationCard extends StatelessWidget {
  final PropertyDetail detail;
  final bool isDark;
  const _ValuationCard({required this.detail, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final d = detail;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.primary, size: 18),
              const SizedBox(width: 6),
              Text('Analyse de prix (IA)', style: AppTextStyles.title),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  value:
                      '${PropertyDetailView.compactM(d.valuationMin)} → ${PropertyDetailView.compactM(d.valuationMax)}',
                  label: 'Fourchette estimée',
                ),
              ),
              if (d.comparablesCount > 0)
                Expanded(
                  child: _Metric(
                    value: '${d.comparablesCount}',
                    label: 'Biens comparables',
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Row(
            children: [
              if (d.dgiPsqm > 0)
                Expanded(
                  child: _Metric(
                    value:
                        '${PropertyDetailView.money(d.dgiPsqm)} ${d.currency}/m²',
                    label: 'Référence DGI',
                  ),
                ),
              Expanded(
                child: _Metric(
                  value: d.dgiCompliant ? 'Conforme' : 'À vérifier',
                  label: 'Statut fiscal',
                  valueColor:
                      d.dgiCompliant ? AppColors.success : AppColors.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String value;
  final String label;
  final Color? valueColor;
  const _Metric({required this.value, required this.label, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: AppTextStyles.title.copyWith(color: valueColor)),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}

// ── DZ scores ───────────────────────────────────────────────────────────────

class _ScoresCard extends StatelessWidget {
  final PropertyDetail detail;
  final bool isDark;
  const _ScoresCard({required this.detail, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final d = detail;
    final rows = <(String, int)>[
      ('Famille', d.familyScore),
      ('Investisseur', d.investorScore),
      ('Liquidité', d.liquidityScore),
      ('Locatif', d.rentalScore),
      ('Standing', d.standingScore),
    ].where((e) => e.$2 > 0).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Scores DZ', style: AppTextStyles.title),
              const Spacer(),
              if (d.scoreBand.isNotEmpty)
                AppBadge(
                  label: d.scoreBand.toUpperCase(),
                  tone: AppBadgeTone.info,
                ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          for (final r in rows) ...[
            _ScoreRow(label: r.$1, score: r.$2),
            const SizedBox(height: AppConstants.spacingSm),
          ],
        ],
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  final String label;
  final int score; // 0..100
  const _ScoreRow({required this.label, required this.score});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
            width: 96,
            child: Text(label, style: AppTextStyles.bodySecondary)),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: (score / 100).clamp(0, 1),
              minHeight: 8,
              backgroundColor: AppColors.border,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
        ),
        const SizedBox(width: AppConstants.spacingSm),
        SizedBox(
          width: 32,
          child: Text('$score',
              textAlign: TextAlign.end,
              style: AppTextStyles.caption
                  .copyWith(fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}

// ── Description ─────────────────────────────────────────────────────────────

class _DescriptionCard extends StatelessWidget {
  final PropertyDetail detail;
  final bool isDark;
  const _DescriptionCard({required this.detail, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Description', style: AppTextStyles.title),
          const SizedBox(height: AppConstants.spacingSm),
          Text(detail.descriptionText,
              style: AppTextStyles.body.copyWith(height: 1.5)),
        ],
      ),
    );
  }
}

// ── Financing ───────────────────────────────────────────────────────────────

class _FinancingCard extends StatelessWidget {
  final PropertyDetail detail;
  final bool isDark;
  final PropertyDetailController controller;
  const _FinancingCard({
    required this.detail,
    required this.isDark,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final d = detail;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_balance_outlined,
                  color: AppColors.primary, size: 18),
              const SizedBox(width: 6),
              Text('Financement', style: AppTextStyles.title),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          if (d.creditBanks.isNotEmpty)
            for (final b in d.creditBanks) ...[
              _BankRow(bank: b, currency: d.currency, isDark: isDark),
              const SizedBox(height: AppConstants.spacingSm),
            ]
          else
            Row(
              children: [
                if (d.creditBestMonthly > 0)
                  Expanded(
                    child: _Metric(
                      value:
                          '${PropertyDetailView.money(d.creditBestMonthly)} ${d.currency}/mois',
                      label: 'Crédit classique (dès)',
                    ),
                  ),
                if (d.mourabahaMonthly > 0)
                  Expanded(
                    child: _Metric(
                      value:
                          '${PropertyDetailView.money(d.mourabahaMonthly)} ${d.currency}/mois',
                      label: 'Mourabaha (dès)',
                    ),
                  ),
              ],
            ),
          if (d.creditSavings > 0) ...[
            const SizedBox(height: AppConstants.spacingSm),
            Text(
              'Économie potentielle : ${PropertyDetailView.money(d.creditSavings)} ${d.currency} sur 20 ans',
              style:
                  AppTextStyles.caption.copyWith(color: AppColors.success),
            ),
          ],
          const SizedBox(height: AppConstants.spacingMd),
          AppButton(
            label: 'Comparer les banques',
            variant: AppButtonVariant.outline,
            icon: Icons.balance_outlined,
            onPressed: controller.openComparator,
          ),
        ],
      ),
    );
  }
}

class _BankRow extends StatelessWidget {
  final CreditBank bank;
  final String currency;
  final bool isDark;
  const _BankRow(
      {required this.bank, required this.currency, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMd, vertical: AppConstants.spacingSm),
      decoration: BoxDecoration(
        color: bank.isBest
            ? AppColors.violetSurface
            : (isDark ? AppColors.darkSurface : AppColors.background),
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        border: bank.isBest
            ? Border.all(color: AppColors.primary, width: 1.2)
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(bank.shortName,
                          style: AppTextStyles.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                    if (bank.isBest) ...[
                      const SizedBox(width: 6),
                      const AppBadge(label: 'BEST', tone: AppBadgeTone.info),
                    ],
                  ],
                ),
                Text(
                  '${bank.type} · ${bank.rate.toStringAsFixed(2)}%',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppConstants.spacingSm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(PropertyDetailView.money(bank.monthly),
                  style: AppTextStyles.title.copyWith(
                      color: bank.isBest ? AppColors.primary : null)),
              Text('$currency/mois', style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Agency ──────────────────────────────────────────────────────────────────

class _AgencyCard extends StatelessWidget {
  final PropertyDetail detail;
  final bool isDark;
  final PropertyDetailController controller;
  const _AgencyCard({
    required this.detail,
    required this.isDark,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final d = detail;
    final name = d.sellerName.isNotEmpty ? d.sellerName : d.agentName;
    if (name.isEmpty) return const SizedBox.shrink();
    final initials = d.agentInitials.isNotEmpty
        ? d.agentInitials
        : (name.isNotEmpty ? name[0].toUpperCase() : '?');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  gradient: AppGradients.purpleFade,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(initials,
                    style:
                        AppTextStyles.title.copyWith(color: Colors.white)),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                            child: Text(name,
                                style: AppTextStyles.title,
                                overflow: TextOverflow.ellipsis)),
                        const SizedBox(width: 4),
                        const Icon(Icons.verified,
                            size: 16, color: AppColors.primary),
                      ],
                    ),
                    if (d.agentResponseTime.isNotEmpty)
                      Text('Répond en ${d.agentResponseTime}',
                          style: AppTextStyles.caption),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Row(
            children: [
              if (_phone(d).isNotEmpty) ...[
                Expanded(
                  child: AppButton(
                    label: 'Appeler',
                    variant: AppButtonVariant.outline,
                    icon: Icons.call_outlined,
                    onPressed: controller.call,
                  ),
                ),
                const SizedBox(width: AppConstants.spacingSm),
                Expanded(
                  child: AppButton(
                    label: 'WhatsApp',
                    variant: AppButtonVariant.primary,
                    icon: Icons.chat_outlined,
                    onPressed: controller.whatsapp,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  static String _phone(PropertyDetail d) =>
      d.agentMobile.isNotEmpty ? d.agentMobile : d.agentPhone;
}

// ── Bottom bar ──────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  final PropertyDetailController controller;
  final bool isDark;
  const _BottomBar({required this.controller, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppConstants.spacingMd,
        AppConstants.spacingSm,
        AppConstants.spacingMd,
        AppConstants.spacingSm + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        boxShadow: const [
          BoxShadow(
              color: Color(0x14000000), blurRadius: 12, offset: Offset(0, -2)),
        ],
      ),
      child: Row(
        children: [
          Obx(() => _SquareIconButton(
                icon: controller.isFavorite.value
                    ? Icons.favorite
                    : Icons.favorite_border,
                color:
                    controller.isFavorite.value ? AppColors.accent : null,
                onTap: controller.toggleFavorite,
                isDark: isDark,
              )),
          const SizedBox(width: AppConstants.spacingSm),
          Expanded(
            child: AppButton(
              label: 'Contacter',
              variant: AppButtonVariant.gradient,
              icon: Icons.chat_outlined,
              onPressed: controller.whatsapp,
            ),
          ),
          const SizedBox(width: AppConstants.spacingSm),
          Expanded(
            child: AppButton(
              label: 'Faire une offre',
              variant: AppButtonVariant.outline,
              onPressed: controller.makeOffer,
            ),
          ),
        ],
      ),
    );
  }
}

class _SquareIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  final bool isDark;
  const _SquareIconButton({
    required this.icon,
    required this.onTap,
    required this.isDark,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDark ? AppColors.darkCard : AppColors.background,
      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 52,
          height: 52,
          child: Icon(icon, color: color ?? AppColors.primary),
        ),
      ),
    );
  }
}

// ── Shared bits ─────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) =>
      Text(title, style: AppTextStyles.h3);
}

BoxDecoration _cardDecoration(bool isDark) => BoxDecoration(
      color: isDark ? AppColors.darkCard : AppColors.surface,
      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      boxShadow: const [
        BoxShadow(
            color: Color(0x0F0A0A41), blurRadius: 10, offset: Offset(0, 3)),
      ],
    );

// ── Loading skeleton ────────────────────────────────────────────────────────

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          // Gallery
          const ShimmerBox(height: 300, radius: 0),
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerBox(width: 90, height: 22, radius: 999), // badge
                const SizedBox(height: AppConstants.spacingMd),
                const ShimmerBox(width: double.infinity, height: 22), // title
                const SizedBox(height: 8),
                const ShimmerBox(width: 220, height: 22),
                const SizedBox(height: 10),
                const ShimmerBox(width: 170, height: 14), // location
                const SizedBox(height: AppConstants.spacingMd),
                // Price card
                const ShimmerBox(
                    width: double.infinity,
                    height: 150,
                    radius: AppConstants.radiusLg),
                const SizedBox(height: AppConstants.spacingMd),
                // Quick actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    4,
                    (_) => const ShimmerBox(width: 56, height: 44),
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLg),
                const ShimmerBox(width: 150, height: 18), // section title
                const SizedBox(height: AppConstants.spacingSm),
                // Specs grid (2 columns × 2 rows)
                LayoutBuilder(builder: (context, c) {
                  const gap = AppConstants.spacingSm;
                  final w = (c.maxWidth - gap) / 2;
                  return Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: List.generate(
                      4,
                      (_) => SizedBox(
                        width: w,
                        child: const ShimmerBox(
                            height: 64, radius: AppConstants.radiusMd),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: AppConstants.spacingLg),
                // Description block
                const ShimmerBox(
                    width: double.infinity,
                    height: 120,
                    radius: AppConstants.radiusMd),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
                onPressed: Get.back, icon: const Icon(Icons.arrow_back)),
          ),
          const Spacer(),
          const Icon(Icons.cloud_off, size: 48, color: AppColors.textHint),
          const SizedBox(height: AppConstants.spacingMd),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg),
            child: Text(message, textAlign: TextAlign.center),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          AppButton(
            label: 'Réessayer',
            icon: Icons.refresh,
            expanded: false,
            onPressed: onRetry,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
