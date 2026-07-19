import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../app/constants/app_constants.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../controllers/estimation_controller.dart';
import '../widgets/step_hint_box.dart';
import '../widgets/step_title.dart';
import '../widgets/step_field_label.dart';

class Step3Surface extends GetView<EstimationController> {
  const Step3Surface({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StepTitle(
          prefix: 'Surface',
          accent: 'précise du bien.',
        ),
        const SizedBox(height: AppConstants.spacingMd),
        const StepHintBox(
          text: "La surface est le seul paramètre numérique — tous les autres "
              'critères (étage, vue, état...) sont traités à l\'étape suivante.',
        ),
        const SizedBox(height: AppConstants.spacingLg),

        const StepFieldLabel(label: 'SURFACE (M²)', required: true),
        const SizedBox(height: AppConstants.spacingSm),

        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller.surfaceCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                style: AppTextStyles.body,
                decoration: const InputDecoration(hintText: 'Ex : 95'),
                onChanged: (v) => controller.surfaceText.value = v,
              ),
            ),
            const SizedBox(width: AppConstants.spacingXs),
            // Spinner buttons
            Column(
              children: [
                _SpinButton(
                  icon: Icons.keyboard_arrow_up,
                  onTap: () => _adjust(1),
                ),
                const SizedBox(height: 2),
                _SpinButton(
                  icon: Icons.keyboard_arrow_down,
                  onTap: () => _adjust(-1),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingMd),
      ],
    );
  }

  void _adjust(int delta) {
    final current = double.tryParse(controller.surfaceCtrl.text) ?? 0;
    final next = (current + delta).clamp(1, 99999).toInt();
    controller.surfaceCtrl.text = next.toString();
    controller.surfaceText.value = controller.surfaceCtrl.text;
    controller.surfaceCtrl.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.surfaceCtrl.text.length));
  }
}

class _SpinButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SpinButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.violetSurface,
      borderRadius: BorderRadius.circular(AppConstants.radiusXs),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 36,
          height: 24,
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
      ),
    );
  }
}
