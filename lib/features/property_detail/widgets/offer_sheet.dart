import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../app/constants/app_constants.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../data/models/property_detail_model.dart';
import '../../../shared/widgets/app_button.dart';
import '../controllers/property_detail_controller.dart';

/// "Faire une offre" bottom sheet — propose a price, financing mode and contact
/// details. Submits to `/dz/listing/offer-request` via the controller.
class OfferSheet extends StatefulWidget {
  final PropertyDetail detail;
  final PropertyDetailController controller;
  const OfferSheet({super.key, required this.detail, required this.controller});

  @override
  State<OfferSheet> createState() => _OfferSheetState();
}

class _OfferSheetState extends State<OfferSheet> {
  static final _money = NumberFormat.decimalPattern('fr');

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amount;
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();

  String _financing = 'classic';
  bool _submitting = false;

  static const _financingOptions = <(String, String)>[
    ('classic', 'Crédit bancaire classique'),
    ('mourabaha', 'Mourabaha · financement halal'),
    ('cash', 'Comptant (cash)'),
  ];

  @override
  void initState() {
    super.initState();
    // Default to 95% of the asking price, like the website.
    final suggested = (widget.detail.price * 0.95).round();
    _amount = TextEditingController(
        text: suggested > 0 ? suggested.toString() : '');
  }

  @override
  void dispose() {
    _amount.dispose();
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final amount = num.tryParse(
            _amount.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
        0;
    setState(() => _submitting = true);
    try {
      await widget.controller.submitOffer(
        amount: amount,
        financing: _financing,
        name: _name.text.trim(),
        phone: _phone.text.trim(),
        email: _email.text.trim(),
        message: _message.text.trim(),
      );
      Get.back(); // close the sheet
      Get.snackbar(
        'Offre envoyée',
        'Le vendeur vous répondra sous 24 h.',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar('Erreur', e.toString(),
          snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 3));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.surface;
    final d = widget.detail;

    return Padding(
      // Lift above the keyboard.
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.92,
        ),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppConstants.radiusLg)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppConstants.spacingLg,
            AppConstants.spacingMd,
            AppConstants.spacingLg,
            AppConstants.spacingLg,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Header row: close + pill ──────────────────────────────
                Row(
                  children: [
                    _CloseButton(onTap: Get.back),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.violetSurface,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusPill),
                      ),
                      child: Text('Négociation · Offre',
                          style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingMd),

                // ── Title + subtitle ──────────────────────────────────────
                RichText(
                  text: TextSpan(
                    style: AppTextStyles.h2
                        .copyWith(color: AppColors.textPrimary),
                    children: [
                      const TextSpan(text: 'Proposez votre prix. '),
                      TextSpan(
                          text: 'Réponse sous 24 h.',
                          style: AppTextStyles.h2
                              .copyWith(color: AppColors.accent)),
                    ],
                  ),
                ),
                const SizedBox(height: AppConstants.spacingSm),
                Text(
                  'Le vendeur reçoit votre offre par e-mail. Aucun engagement '
                  'avant la signature de la promesse de vente.',
                  style: AppTextStyles.bodySecondary,
                ),
                const SizedBox(height: AppConstants.spacingLg),

                // ── Proposed price ────────────────────────────────────────
                _Label('Prix proposé (${d.currency})'),
                _Input(
                  controller: _amount,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  textStyle: AppTextStyles.h3,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) {
                    final n = num.tryParse(
                        (v ?? '').replaceAll(RegExp(r'[^0-9]'), ''));
                    if (n == null || n <= 0) return 'Saisissez un montant';
                    return null;
                  },
                ),
                const SizedBox(height: 6),
                if (d.price > 0)
                  Text('Prix demandé : ${_money.format(d.price)} ${d.currency}',
                      style: AppTextStyles.caption),
                const SizedBox(height: AppConstants.spacingMd),

                // ── Financing ─────────────────────────────────────────────
                _Label('Mode de financement souhaité'),
                _FinancingDropdown(
                  value: _financing,
                  options: _financingOptions,
                  isDark: isDark,
                  onChanged: (v) => setState(() => _financing = v ?? 'classic'),
                ),
                const SizedBox(height: AppConstants.spacingMd),

                // ── Contact ───────────────────────────────────────────────
                Text('Vos coordonnées', style: AppTextStyles.title),
                const SizedBox(height: AppConstants.spacingSm),
                _Input(
                  controller: _name,
                  hint: 'Nom complet',
                  textInputAction: TextInputAction.next,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Nom requis' : null,
                ),
                const SizedBox(height: AppConstants.spacingSm),
                _Input(
                  controller: _phone,
                  hint: 'Téléphone (avec WhatsApp)',
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  validator: (v) => (v == null || v.trim().length < 6)
                      ? 'Téléphone requis'
                      : null,
                ),
                const SizedBox(height: AppConstants.spacingMd),

                // ── Email ─────────────────────────────────────────────────
                _Label('E-mail (optionnel)'),
                _Input(
                  controller: _email,
                  hint: 'exemple@email.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return null;
                    final ok =
                        RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim());
                    return ok ? null : 'E-mail invalide';
                  },
                ),
                const SizedBox(height: AppConstants.spacingMd),

                // ── Message ───────────────────────────────────────────────
                _Label('Message au vendeur (optionnel)'),
                _Input(
                  controller: _message,
                  hint: 'Contexte de votre offre…',
                  maxLines: 4,
                ),
                const SizedBox(height: AppConstants.spacingLg),

                AppButton(
                  label: 'Envoyer mon offre',
                  variant: AppButtonVariant.gradient,
                  trailingIcon: Icons.send_rounded,
                  isLoading: _submitting,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Private bits ──────────────────────────────────────────────────────────────

class _CloseButton extends StatelessWidget {
  final VoidCallback onTap;
  const _CloseButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: isDark ? AppColors.darkCard : AppColors.background,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: const SizedBox(
          width: 40,
          height: 40,
          child: Icon(Icons.close, size: 20, color: AppColors.textSecondary),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text,
          style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w700)),
    );
  }
}

class _Input extends StatelessWidget {
  final TextEditingController controller;
  final String? hint;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final int maxLines;
  final TextAlign textAlign;
  final TextStyle? textStyle;

  const _Input({
    required this.controller,
    this.hint,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.validator,
    this.maxLines = 1,
    this.textAlign = TextAlign.start,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fill = isDark ? AppColors.darkCard : AppColors.background;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      borderSide: const BorderSide(color: AppColors.border),
    );
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      validator: validator,
      maxLines: maxLines,
      textAlign: textAlign,
      style: textStyle,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: fill,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingMd, vertical: 14),
        border: border,
        enabledBorder: border,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
        ),
      ),
    );
  }
}

class _FinancingDropdown extends StatelessWidget {
  final String value;
  final List<(String, String)> options;
  final bool isDark;
  final ValueChanged<String?> onChanged;
  const _FinancingDropdown({
    required this.value,
    required this.options,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final fill = isDark ? AppColors.darkCard : AppColors.background;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      borderSide: const BorderSide(color: AppColors.border),
    );
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      decoration: InputDecoration(
        filled: true,
        fillColor: fill,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingMd, vertical: 4),
        border: border,
        enabledBorder: border,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
        ),
      ),
      items: [
        for (final o in options)
          DropdownMenuItem(value: o.$1, child: Text(o.$2)),
      ],
      onChanged: onChanged,
    );
  }
}
