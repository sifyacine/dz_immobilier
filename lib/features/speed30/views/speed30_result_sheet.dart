import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../app/constants/app_constants.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_gradients.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../data/models/speed30_model.dart';
import '../../../shared/widgets/app_button.dart';

/// Result of a Speed30 quick estimate, shown as a bottom sheet.
class Speed30ResultSheet extends StatelessWidget {
  final QuickEstimate result;
  final double surface;
  final bool isRent;

  const Speed30ResultSheet({
    super.key,
    required this.result,
    required this.surface,
    this.isRent = false,
  });

  static final _money = NumberFormat.decimalPattern('fr');
  String _fmt(double v) => _money.format(v.round());
  String get _suffix => isRent ? 'DZD/mois' : 'DZD';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppConstants.radiusLg)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppConstants.spacingLg,
        AppConstants.spacingSm,
        AppConstants.spacingLg,
        AppConstants.spacingLg + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Headline price card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            decoration: BoxDecoration(
              gradient: AppGradients.inkViolet,
              borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Valeur estimée',
                    style: AppTextStyles.caption.copyWith(color: Colors.white70)),
                const SizedBox(height: 4),
                Text('${_fmt(result.avg)} $_suffix',
                    style: AppTextStyles.h1.copyWith(color: Colors.white)),
                const SizedBox(height: 4),
                Text(
                  'Fourchette : ${_fmt(result.min)} – ${_fmt(result.max)} DZD',
                  style: AppTextStyles.bodySecondary
                      .copyWith(color: Colors.white70),
                ),
                if (result.confidence > 0) ...[
                  const SizedBox(height: AppConstants.spacingMd),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Confiance',
                          style: AppTextStyles.caption
                              .copyWith(color: Colors.white70)),
                      Text('${(result.confidence * 100).round()}%',
                          style: AppTextStyles.title
                              .copyWith(color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: result.confidence.clamp(0, 1),
                      minHeight: 8,
                      backgroundColor: Colors.white24,
                      valueColor:
                          const AlwaysStoppedAnimation(AppColors.heliotrope),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),

          // Sub-metrics
          Row(
            children: [
              Expanded(
                child: _Metric(
                  label: 'Prix au m²',
                  value: '${_fmt(result.pricePerSqm)} DZD',
                ),
              ),
              Expanded(
                child: _Metric(
                  label: 'Surface',
                  value: '${surface.toInt()} m²',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),

          Text(
            'Estimation indicative générée par notre moteur IA. Pour un '
            'rapport complet (DGI, comparables, PDF), lancez l’estimation '
            'détaillée.',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: AppConstants.spacingLg),

          AppButton(
            label: 'Estimation détaillée',
            variant: AppButtonVariant.gradient,
            trailingIcon: Icons.arrow_forward,
            onPressed: () {
              Get.back(); // close sheet
              Get.toNamed(Routes.estimation);
            },
          ),
          const SizedBox(height: AppConstants.spacingSm),
          AppButton(
            label: 'Fermer',
            variant: AppButtonVariant.ghost,
            onPressed: Get.back,
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  const _Metric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: AppTextStyles.title),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}
