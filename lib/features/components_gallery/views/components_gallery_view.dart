import 'package:flutter/material.dart';

import '../../../app/constants/app_constants.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_gradients.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../shared/widgets/widgets.dart';

/// Living showcase of the shared component library — useful while building UI
/// and as copy-paste reference. Not part of the production navigation.
class ComponentsGalleryView extends StatefulWidget {
  const ComponentsGalleryView({super.key});

  @override
  State<ComponentsGalleryView> createState() => _ComponentsGalleryViewState();
}

class _ComponentsGalleryViewState extends State<ComponentsGalleryView> {
  String _filter = 'Vente';
  int _propertyType = 0;

  static const _types = [
    (Icons.apartment, 'Appartement'),
    (Icons.home_outlined, 'Villa / Maison'),
    (Icons.map_outlined, 'Terrain'),
    (Icons.storefront_outlined, 'Local Com.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Composants')),
      body: ListView(
        padding: AppConstants.pagePadding,
        children: [
          _section('Buttons', 'gradient · ink · outline · ghost'),
          AppButton(
            label: 'Continuer',
            variant: AppButtonVariant.gradient,
            trailingIcon: Icons.arrow_forward,
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          AppButton(
              label: 'Contactez-nous',
              variant: AppButtonVariant.ink,
              onPressed: () {}),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AppButton(
                    label: 'Voir les détails',
                    variant: AppButtonVariant.outline,
                    onPressed: () {}),
              ),
              const SizedBox(width: 12),
              AppButton(
                  label: 'Filtres',
                  variant: AppButtonVariant.ghost,
                  expanded: false,
                  icon: Icons.tune,
                  onPressed: () {}),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              AppIconButton(icon: Icons.add, onPressed: () {}),
              const SizedBox(width: 16),
              AppIconButton(
                  icon: Icons.favorite_border,
                  variant: AppIconButtonVariant.outline,
                  onPressed: () {}),
              const SizedBox(width: 16),
              const AppButton(
                  label: 'Chargement',
                  isLoading: true,
                  expanded: false,
                  variant: AppButtonVariant.primary),
            ],
          ),

          _section('Chips & badges', 'filter chips · status badges · ribbon'),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final f in ['Vente', 'Location', 'Échange'])
                AppChip(
                  label: f,
                  selected: _filter == f,
                  onTap: () => setState(() => _filter = f),
                ),
              AppChip(label: 'Filtre', icon: Icons.add, onTap: () {}),
            ],
          ),
          const SizedBox(height: 14),
          const Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              AppBadge(label: 'VLIDO01', tone: AppBadgeTone.solid),
              AppBadge(label: 'Nouveau', tone: AppBadgeTone.success),
              AppBadge(label: 'Coup de cœur', tone: AppBadgeTone.danger),
              AppBadge(label: '100% Fini', tone: AppBadgeTone.info),
            ],
          ),
          const SizedBox(height: 14),
          const AmenityRibbon(items: [
            AmenityItem(Icons.place, 'Bordj El Kiffan'),
            AmenityItem(Icons.meeting_room_outlined, '5 P'),
            AmenityItem(Icons.local_parking, 'Parking'),
            AmenityItem(Icons.waves, 'Vue mer'),
          ]),

          _section('Choice tiles', 'estimation step · selected state'),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              for (var i = 0; i < _types.length; i++)
                ChoiceTile(
                  icon: _types[i].$1,
                  label: _types[i].$2,
                  selected: _propertyType == i,
                  onTap: () => setState(() => _propertyType = i),
                ),
            ],
          ),

          _section('Glass card', 'premium · light + dark glass'),
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            decoration: BoxDecoration(
              gradient: AppGradients.purpleFade,
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: GlassCard(
                    child: _glassContent(
                      'ESTIMATION OFFICIELLE',
                      '30 866 000 DA',
                      'Fourchette : 26 236 100 → 35 495 900 DA',
                      AppColors.ink,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GlassCard(
                    variant: GlassVariant.dark,
                    child: _glassContent(
                      'ML CONFIDENCE',
                      '87 %',
                      'Volume d\'annonces récentes — Tiaret · F4',
                      Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          _section('Progress', 'step bar · dots · confidence gauge'),
          const AppProgressBar(value: 0.4, label: 'Étape 2 / 5'),
          const SizedBox(height: 20),
          const StepIndicator(steps: 5, current: 2),
          const SizedBox(height: 20),
          const AppProgressBar(
              value: 0.78,
              label: 'Confiance ML',
              gradient: AppGradients.confidence),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _section(String title, String subtitle) => Padding(
        padding: const EdgeInsets.only(top: 28, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.h2),
            const SizedBox(height: 2),
            Text(subtitle, style: AppTextStyles.bodySecondary),
          ],
        ),
      );

  Widget _glassContent(
          String label, String value, String caption, Color color) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: AppTextStyles.caption
                  .copyWith(color: color, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(value,
              style: AppTextStyles.h2.copyWith(color: color),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          Text(caption,
              style: AppTextStyles.caption.copyWith(color: color.withValues(alpha: 0.7))),
        ],
      );
}
