import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/constants/api_constants.dart';
import '../../../app/constants/app_constants.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_gradients.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../data/models/valuation_result_model.dart';
import '../controllers/estimation_controller.dart';

final _numFmt = NumberFormat.decimalPattern('fr');

class EstimationResultView extends GetView<EstimationController> {
  const EstimationResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final result = controller.valuationResult.value;
    if (result == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _ResultHeader(result: result),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              child: Column(
                children: [
                  _ConsensusCard(result: result),
                  const SizedBox(height: AppConstants.spacingMd),
                  _DgiCard(dgi: result.dgi),
                  const SizedBox(height: AppConstants.spacingMd),
                  _ThreeSourcesSection(result: result),
                  const SizedBox(height: AppConstants.spacingMd),
                  _OwnerEstimateAfterSection(result: result),
                  const SizedBox(height: AppConstants.spacingMd),
                  _ActionButtons(result: result),
                  const SizedBox(height: AppConstants.spacingMd),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Gradient header ───────────────────────────────────────────────────────────

class _ResultHeader extends StatelessWidget {
  final ValuationResult result;
  const _ResultHeader({required this.result});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: AppGradients.purpleFade),
      padding: EdgeInsets.fromLTRB(16, top + 12, 16, 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Votre Estimation',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  result.refName,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => Get.offAllNamed(Routes.shell),
            style: TextButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.15),
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusPill)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              'Nouvelle →',
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Consensus card ────────────────────────────────────────────────────────────

class _ConsensusCard extends StatelessWidget {
  final ValuationResult result;
  const _ConsensusCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final c = result.consensus;
    final e = result.estimation;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Tags row ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppConstants.spacingMd,
                AppConstants.spacingMd,
                AppConstants.spacingMd,
                0),
            child: Wrap(
              spacing: 8,
              children: [
                _Chip(
                  label: 'CONSENSUS IA · ANALYSE DU MARCHÉ',
                  color: AppColors.primary,
                ),
                if (!c.hasData)
                  _Chip(
                    label: 'REPLI WILAYA',
                    color: AppColors.warning,
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),

          // ── Main consensus + spread ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingMd),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'VALEUR DE CONSENSUS',
                        style: AppTextStyles.caption.copyWith(
                            letterSpacing: 0.8,
                            color: AppColors.textSecondary),
                      ),
                      Text(
                        '${_numFmt.format(c.m2)} DA/m²',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        'Valeur médiane tous modèles',
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'ÉCART INTER-MODÈLES',
                      style: AppTextStyles.caption.copyWith(
                          letterSpacing: 0.8,
                          color: AppColors.textSecondary),
                    ),
                    Text(
                      '${c.spreadPct.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.success),
                        borderRadius: BorderRadius.circular(
                            AppConstants.radiusPill),
                      ),
                      child: Text(
                        c.levelLabel.toUpperCase(),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),

          // ── Range bar ────────────────────────────────────────────────
          _RangeBar(min: e.min, avg: e.avg, max: e.max),
          const SizedBox(height: AppConstants.spacingMd),

          // ── Provider grid ────────────────────────────────────────────
          if (c.providers.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingMd),
              child: _ProviderGrid(providers: c.providers),
            ),
            const SizedBox(height: AppConstants.spacingMd),
          ],
        ],
      ),
    );
  }
}

// ── Range bar ─────────────────────────────────────────────────────────────────

class _RangeBar extends StatelessWidget {
  final double min, avg, max;
  const _RangeBar({required this.min, required this.avg, required this.max});

  @override
  Widget build(BuildContext context) {
    final span = max - min;
    final pct = span > 0 ? ((avg - min) / span).clamp(0.0, 1.0) : 0.5;
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMd),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_numFmt.format(min.toInt()),
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.textSecondary)),
              Text('Total estimé',
                  style: AppTextStyles.caption),
              Text(_numFmt.format(max.toInt()),
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 6),
          LayoutBuilder(builder: (_, constraints) {
            final w = constraints.maxWidth;
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                Container(
                  height: 6,
                  width: w * pct,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                Positioned(
                  left: w * pct - 6,
                  top: -3,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            );
          }),
          const SizedBox(height: 6),
          Text(
            'Moy. ${_numFmt.format(avg.toInt())} DA',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Provider grid ─────────────────────────────────────────────────────────────

class _ProviderGrid extends StatelessWidget {
  final List<ValuationProvider> providers;
  const _ProviderGrid({required this.providers});

  static Color _hex(String hex) {
    final code = hex.replaceFirst('#', '');
    return Color(int.parse('FF$code', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1.3,
      children: providers.map((p) {
        final color = _hex(p.colorHex);
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius:
                BorderRadius.circular(AppConstants.radiusSm),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        color: color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      p.label.toUpperCase(),
                      style: AppTextStyles.caption.copyWith(
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                _numFmt.format(p.m2),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              Text('DA / m²', style: AppTextStyles.caption),
              Text(
                'Confiance ${p.confidencePct}%',
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ── DGI card ──────────────────────────────────────────────────────────────────

class _DgiCard extends StatelessWidget {
  final ValuationDgi dgi;
  const _DgiCard({required this.dgi});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppGradients.inkViolet,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      ),
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title + badge ────────────────────────────────────────────
          Row(
            children: [
              const Icon(Icons.balance, color: Colors.white70, size: 20),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Conformité Fiscale DGI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: dgi.isSafe ? AppColors.success : AppColors.error,
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusPill),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      dgi.isSafe ? Icons.check : Icons.warning,
                      color: Colors.white,
                      size: 13,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      dgi.isSafe ? 'Conforme' : 'Attention',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Référence officielle DGI ${dgi.periodName}',
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: AppConstants.spacingMd),

          // ── Stats row ────────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: _DgiStat(
                  label: 'TAXE MIN (DA/M²)',
                  value:
                      '${_numFmt.format(dgi.minPricePerSqm.toInt())} DA / m²',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _DgiStat(
                  label: 'VALEUR MIN DÉCLARABLE',
                  value:
                      '${_numFmt.format(dgi.minValueTotal.toInt())} DA',
                ),
              ),
            ],
          ),

          // ── Message ──────────────────────────────────────────────────
          if (dgi.message.isNotEmpty) ...[
            const SizedBox(height: AppConstants.spacingMd),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius:
                    BorderRadius.circular(AppConstants.radiusSm),
              ),
              child: Text(
                dgi.message,
                style: const TextStyle(
                    color: Colors.white70, fontSize: 12),
              ),
            ),
          ],
          const SizedBox(height: AppConstants.spacingMd),

          // ── Match quality ────────────────────────────────────────────
          Row(
            children: [
              const Icon(Icons.location_on,
                  color: Colors.white38, size: 14),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Précision : ${dgi.matchQuality == 'commune' ? 'Niveau commune' : 'Repli wilaya'}  ·  Période ${dgi.periodName}',
                  style: const TextStyle(
                      color: Colors.white38, fontSize: 11),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DgiStat extends StatelessWidget {
  final String label;
  final String value;
  const _DgiStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 10,
                  letterSpacing: 0.8),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      );
}

// ── Action buttons ────────────────────────────────────────────────────────────

class _ActionButtons extends StatelessWidget {
  final ValuationResult result;
  const _ActionButtons({required this.result});

  Future<void> _openPdf(String reportUrl) async {
    // report_url may be relative ("/valuation/167/.../pdf") or absolute.
    final full = reportUrl.startsWith('http')
        ? reportUrl
        : '${ApiConstants.baseUrl}$reportUrl';
    final uri = Uri.parse('$full${full.contains('?') ? '&' : '?'}lang=fr_FR');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      Get.log('_openPdf error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (result.reportUrl != null)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _openPdf(result.reportUrl!),
              icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
              label: const Text(
                'Voir le rapport complet (PDF)',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding:
                    const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        AppConstants.radiusMd)),
              ),
            ),
          ),
        const SizedBox(height: AppConstants.spacingSm),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Get.offAllNamed(Routes.shell),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      AppConstants.radiusMd)),
            ),
            child: const Text(
              'Nouvelle estimation',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Three Sources, One Verdict ────────────────────────────────────────────────

class _ThreeSourcesSection extends StatelessWidget {
  final ValuationResult result;
  const _ThreeSourcesSection({required this.result});

  EstimationController get _c => Get.find();

  @override
  Widget build(BuildContext context) {
    final userEstimate =
        double.tryParse(_c.userEstimateCtrl.text.trim()) ?? 0;
    final surface = double.tryParse(_c.surfaceText.value) ?? 1;
    final userM2 =
        userEstimate > 0 && surface > 0 ? userEstimate / surface : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.compare_arrows,
                  color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Trois Sources, Un Verdict',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _SourceCard(
            topColor: const Color(0xFF2563EB),
            icon: Icons.account_balance,
            label: 'Référence Fiscale',
            source: 'DGI · ${result.dgi.periodName}',
            m2Value: result.dgi.minPricePerSqm,
            totalValue: result.dgi.minValueTotal,
            note: 'Minimum légal déclarable',
          ),
          const SizedBox(height: 8),
          _SourceCard(
            topColor: AppColors.primary,
            isDashed: true,
            icon: Icons.trending_up,
            label: 'Marché Live',
            source: 'Kloufi.com',
            m2Value: result.marketAvailable
                ? result.consensus.m2.toDouble()
                : 0,
            totalValue:
                result.marketAvailable ? result.consensus.total : 0,
            note: result.marketAvailable
                ? 'Annonces actives'
                : 'Pas assez de données',
            unavailable: !result.marketAvailable,
          ),
          const SizedBox(height: 8),
          _SourceCard(
            topColor: const Color(0xFFF97316),
            icon: Icons.psychology,
            label: 'Votre Ressenti',
            source: 'Estimation propriétaire',
            m2Value: userM2,
            totalValue: userEstimate,
            note: userEstimate > 0 ? 'Prix estimé par vous' : 'Non renseigné',
            unavailable: userEstimate <= 0,
          ),
        ],
      ),
    );
  }
}

class _SourceCard extends StatelessWidget {
  final Color topColor;
  final bool isDashed;
  final IconData icon;
  final String label;
  final String source;
  final double m2Value;
  final double totalValue;
  final String note;
  final bool unavailable;

  const _SourceCard({
    required this.topColor,
    this.isDashed = false,
    required this.icon,
    required this.label,
    required this.source,
    required this.m2Value,
    required this.totalValue,
    required this.note,
    this.unavailable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        border: Border(
          top: BorderSide(
            color: topColor,
            width: 3,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
          left: BorderSide(color: AppColors.border),
          right: BorderSide(color: AppColors.border),
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: topColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: topColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  source,
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          if (unavailable)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius:
                    BorderRadius.circular(AppConstants.radiusPill),
              ),
              child: Text(
                note,
                style: AppTextStyles.caption
                    .copyWith(color: AppColors.textSecondary),
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${_numFmt.format(m2Value.toInt())} DA/m²',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    color: topColor,
                  ),
                ),
                Text(
                  '${_numFmt.format(totalValue.toInt())} DA',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  note,
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

// ── Owner estimate after ──────────────────────────────────────────────────────

class _OwnerEstimateAfterSection extends StatelessWidget {
  final ValuationResult result;
  const _OwnerEstimateAfterSection({required this.result});

  EstimationController get _c => Get.find();

  static const _orange = Color(0xFFF97316);
  static const _orangeDark = Color(0xFFC2410C);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_c.ownerEstimateSaved.value) {
        return Container(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            border: Border.all(
                color: AppColors.success.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: AppColors.success),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Prix confirmé',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.success),
                    ),
                    Text(
                      'Votre prix de vente a été enregistré.',
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }

      final consensusM2 = result.consensus.m2.toDouble();
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFF7ED),
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          border: Border.all(color: _orange.withValues(alpha: 0.3)),
        ),
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.edit_note, color: _orange, size: 22),
                const SizedBox(width: 8),
                const Text(
                  'Votre Prix de Vente',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _orangeDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Après avoir vu l\'estimation, confirmez votre prix de vente réel.',
              style: TextStyle(color: _orangeDark, fontSize: 12),
            ),
            const SizedBox(height: AppConstants.spacingMd),
            TextField(
              controller: _c.ownerEstimateAfterCtrl,
              keyboardType: TextInputType.number,
              onChanged: (v) => _c.ownerEstimateAfterText.value = v,
              decoration: InputDecoration(
                labelText: 'VOTRE PRIX DE VENTE',
                labelStyle: const TextStyle(fontSize: 12, color: _orangeDark),
                suffixText: 'DZD',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusMd),
                  borderSide: BorderSide(
                      color: _orange.withValues(alpha: 0.4)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusMd),
                  borderSide: BorderSide(
                      color: _orange.withValues(alpha: 0.4)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusMd),
                  borderSide: const BorderSide(color: _orange, width: 2),
                ),
              ),
            ),
            // % above market hint
            Obx(() {
              final raw = _c.ownerEstimateAfterText.value.trim();
              final surface =
                  double.tryParse(_c.surfaceText.value) ?? 1;
              final amount = double.tryParse(raw) ?? 0;
              if (amount <= 0 || consensusM2 <= 0 || surface <= 0) {
                return const SizedBox.shrink();
              }
              final userM2 = amount / surface;
              final diffPct =
                  ((userM2 - consensusM2) / consensusM2 * 100);
              final isAbove = diffPct > 0;
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  isAbove
                      ? '${diffPct.toStringAsFixed(1)}% au-dessus du marché'
                      : '${diffPct.abs().toStringAsFixed(1)}% en dessous du marché',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isAbove ? AppColors.warning : AppColors.success,
                  ),
                ),
              );
            }),
            const SizedBox(height: AppConstants.spacingMd),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _c.isSavingOwnerEstimate.value
                    ? null
                    : _c.submitOwnerEstimateAfter,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _orange,
                  disabledBackgroundColor: _orange.withValues(alpha: 0.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          AppConstants.radiusMd)),
                ),
                child: _c.isSavingOwnerEstimate.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text(
                        'Confirmer mon prix',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ── Shared chip ───────────────────────────────────────────────────────────────

class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius:
              BorderRadius.circular(AppConstants.radiusPill),
          border: Border.all(
              color: color.withValues(alpha: 0.30)),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      );
}
