import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../app/constants/app_constants.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_gradients.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../data/models/simulation_result_model.dart';
import '../../../shared/extensions/l10n_extension.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_progress_bar.dart';
import '../controllers/simulation_controller.dart';

class SimulationResultView extends GetView<SimulationController> {
  const SimulationResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _ResultHeader(controller: controller),
          Expanded(
            child: Obx(() {
              if (controller.isSubmitting.value) {
                return const _LoadingBody();
              }
              if (controller.submitError.value.isNotEmpty) {
                return _ErrorBody(
                  error: controller.submitError.value,
                  onRetry: controller.submit,
                );
              }
              final result = controller.simulationResult.value;
              if (result == null) {
                return const _LoadingBody();
              }
              return _ResultBody(
                result: result,
                offers: controller.bankOffers,
                onNewSim: controller.startNewSimulation,
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _ResultHeader extends StatelessWidget {
  final SimulationController controller;
  const _ResultHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: AppGradients.purpleFade),
      padding: EdgeInsets.fromLTRB(
          AppConstants.spacingMd, top + 12, AppConstants.spacingMd, 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.simulationResultTitle,
                  style: AppTextStyles.title.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  context.l10n.simResultSubtitle,
                  style: AppTextStyles.caption
                      .copyWith(color: Colors.white.withValues(alpha: 0.80)),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppConstants.spacingSm),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConstants.radiusPill),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => Get.back(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back,
                        size: 14, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      context.l10n.commonBack,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Loading ───────────────────────────────────────────────────────────────────

class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            context.l10n.simResultLoading,
            style: AppTextStyles.body
                .copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

// ── Error ─────────────────────────────────────────────────────────────────────

class _ErrorBody extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  const _ErrorBody({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            context.l10n.commonError,
            style: AppTextStyles.h3,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            error,
            style: AppTextStyles.caption
                .copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacingLg),
          AppButton(
            label: context.l10n.commonRetry,
            variant: AppButtonVariant.gradient,
            onPressed: onRetry,
            expanded: false,
          ),
        ],
      ),
    );
  }
}

// ── Result body ───────────────────────────────────────────────────────────────

class _ResultBody extends StatelessWidget {
  final SimulationResult result;
  final List<BankOffer> offers;
  final VoidCallback onNewSim;

  const _ResultBody({
    required this.result,
    required this.offers,
    required this.onNewSim,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Column(
        children: [
          _DuelCard(result: result),
          const SizedBox(height: AppConstants.spacingMd),
          _DebtRatioCard(result: result),
          const SizedBox(height: AppConstants.spacingMd),
          if (offers.isNotEmpty) ...[
            _BankOffersCard(offers: offers),
            const SizedBox(height: AppConstants.spacingMd),
          ],
          _ConfirmationCard(onNewSim: onNewSim),
          const SizedBox(height: AppConstants.spacingMd),
        ],
      ),
    );
  }
}

// ── Duel card ─────────────────────────────────────────────────────────────────

class _DuelCard extends StatelessWidget {
  final SimulationResult result;
  const _DuelCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.decimalPattern('fr');

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppConstants.spacingMd, AppConstants.spacingMd, AppConstants.spacingMd, 0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary),
                borderRadius: BorderRadius.circular(AppConstants.radiusPill),
              ),
              child: Text(
                context.l10n.simResultBadge,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                RichText(
                  text: TextSpan(
                    style: AppTextStyles.h1.copyWith(fontSize: 28, height: 1.15),
                    children: [
                      TextSpan(text: '${context.l10n.simDuelPrefix} '),
                      TextSpan(
                        text: context.l10n.simDuelAccent,
                        style: AppTextStyles.h1.copyWith(
                          fontSize: 28,
                          fontStyle: FontStyle.italic,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppConstants.spacingMd),

                // Side-by-side panels
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _LoanPanel(
                        label: context.l10n.simLoanConventional,
                        emoji: '🏛️',
                        borderColor: AppColors.ink,
                        bgColor: AppColors.violetSurface,
                        monthlyPayment: result.calculatedMonthlyPayment,
                        rate: result.appliedRate,
                        termYears: result.requestedDuration,
                        termMonths: result.requestedDuration * 12,
                        totalCost: result.totalFinanceCost,
                        totalLabel: context.l10n.simTotalInterest,
                        howItWorks: context.l10n.simHowConventional,
                        fmt: fmt,
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingSm),
                    Expanded(
                      child: _LoanPanel(
                        label: context.l10n.simLoanMourabaha,
                        emoji: '🌙',
                        borderColor: AppColors.success,
                        bgColor: AppColors.successSurface,
                        monthlyPayment: result.islamicMonthlyPayment,
                        rate: result.islamicProfitRate,
                        termYears: result.requestedDuration,
                        termMonths: result.requestedDuration * 12,
                        totalCost: result.islamicTotalMargin,
                        totalLabel: context.l10n.simTotalMargin,
                        howItWorks: context.l10n.simHowMourabaha,
                        fmt: fmt,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppConstants.spacingMd),

                // Expert analysis
                Container(
                  padding: const EdgeInsets.all(AppConstants.spacingMd),
                  decoration: BoxDecoration(
                    color: AppColors.warningSurface,
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusMd),
                    border: Border.all(
                        color: AppColors.warning.withValues(alpha: 0.4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('🎓',
                              style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 6),
                          Text(
                            context.l10n.simExpertAnalysis,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.warning,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.spacingSm),
                      Text(
                        context.l10n.simExpertBody(
                            '+${fmt.format(result.costGap.round())} DA'),
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Single loan panel ─────────────────────────────────────────────────────────

class _LoanPanel extends StatelessWidget {
  final String label;
  final String emoji;
  final Color borderColor;
  final Color bgColor;
  final double monthlyPayment;
  final double rate;
  final int termYears;
  final int termMonths;
  final double totalCost;
  final String totalLabel;
  final String howItWorks;
  final NumberFormat fmt;

  const _LoanPanel({
    required this.label,
    required this.emoji,
    required this.borderColor,
    required this.bgColor,
    required this.monthlyPayment,
    required this.rate,
    required this.termYears,
    required this.termMonths,
    required this.totalCost,
    required this.totalLabel,
    required this.howItWorks,
    required this.fmt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingSm),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: borderColor, width: 3)),
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 12)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w700, letterSpacing: 0.4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            fmt.format(monthlyPayment.round()),
            style: AppTextStyles.h2.copyWith(fontSize: 22),
          ),
          Text(
            context.l10n.simDaPerMonth,
            style: AppTextStyles.caption
                .copyWith(color: AppColors.textSecondary),
          ),
          const Divider(height: 16),
          _DetailRow(
              label: context.l10n.simRateLabel,
              value: context.l10n.simRateAnnual(rate.round())),
          _DetailRow(
              label: context.l10n.simDurationLabel,
              value: context.l10n.simDurationValue(termYears, termMonths)),
          _DetailRow(
            label: '$totalLabel :',
            value: '${fmt.format(totalCost.round())} DA',
            valueColor: AppColors.error,
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(AppConstants.radiusXs),
            ),
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.caption
                    .copyWith(color: AppColors.textSecondary, fontSize: 10),
                children: [
                  TextSpan(
                    text: '${context.l10n.simHowItWorks} ',
                    style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w700, fontSize: 10),
                  ),
                  TextSpan(text: howItWorks),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow(
      {required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: RichText(
        text: TextSpan(
          style: AppTextStyles.caption
              .copyWith(color: AppColors.textSecondary, fontSize: 10),
          children: [
            TextSpan(
              text: '$label ',
              style: AppTextStyles.caption
                  .copyWith(fontWeight: FontWeight.w700, fontSize: 10),
            ),
            TextSpan(
              text: value,
              style: AppTextStyles.caption.copyWith(
                  color: valueColor ?? AppColors.textSecondary, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Debt ratio card ───────────────────────────────────────────────────────────

class _DebtRatioCard extends StatelessWidget {
  final SimulationResult result;
  const _DebtRatioCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final ratio = result.debtRatio.clamp(0, 100) / 100;
    final exceeded = result.debtCapacityExceeded;
    final pct = result.debtRatio.toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.simDebtRatioLabel,
                style: AppTextStyles.body
                    .copyWith(color: AppColors.textSecondary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: exceeded ? AppColors.errorSurface : AppColors.successSurface,
                  borderRadius: BorderRadius.circular(AppConstants.radiusPill),
                ),
                child: Text(
                  '$pct %',
                  style: AppTextStyles.caption.copyWith(
                    color: exceeded ? AppColors.error : AppColors.success,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingSm),
          AppProgressBar(
            value: ratio.toDouble(),
            showPercent: false,
            gradient: exceeded
                ? const LinearGradient(
                    colors: [AppColors.error, AppColors.error])
                : AppGradients.purpleFade,
          ),
          if (exceeded) ...[
            const SizedBox(height: AppConstants.spacingSm),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('⚠️', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    context.l10n.simDebtExceeded,
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ── Bank offers card ──────────────────────────────────────────────────────────

class _BankOffersCard extends StatelessWidget {
  final List<BankOffer> offers;
  const _BankOffersCard({required this.offers});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.decimalPattern('fr');

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📊', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                context.l10n.simBankOffersTitle,
                style:
                    AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),

          // Column headers
          Row(
            children: [
              Expanded(
                child: Text(
                  context.l10n.simBankColumn,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              SizedBox(
                width: 48,
                child: Text(
                  context.l10n.simRateColumn,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                width: 96,
                child: Text(
                  context.l10n.simMonthlyColumn,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.caption
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),

          const Divider(height: AppConstants.spacingMd),

          // Rows
          ...offers.map((offer) => Padding(
                padding:
                    const EdgeInsets.only(bottom: AppConstants.spacingMd),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            offer.bankName,
                            style: AppTextStyles.caption.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            context.l10n.commonYears(offer.duration),
                            style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 48,
                      child: Text(
                        '${offer.rate.toStringAsFixed(0)}%',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      width: 96,
                      child: Text(
                        '${fmt.format(offer.monthlyPayment.round())} DA',
                        textAlign: TextAlign.right,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ── Confirmation card ─────────────────────────────────────────────────────────

class _ConfirmationCard extends StatelessWidget {
  final VoidCallback onNewSim;
  const _ConfirmationCard({required this.onNewSim});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle,
                  size: 20, color: AppColors.success),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  context.l10n.simulationConfirmation,
                  style: AppTextStyles.body
                      .copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          AppButton(
            label: context.l10n.simulationNewSimulation,
            variant: AppButtonVariant.gradient,
            onPressed: onNewSim,
          ),
        ],
      ),
    );
  }
}
