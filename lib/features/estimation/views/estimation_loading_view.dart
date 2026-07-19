import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_text_styles.dart';
import '../controllers/estimation_controller.dart';

class EstimationLoadingView extends StatefulWidget {
  const EstimationLoadingView({super.key});

  @override
  State<EstimationLoadingView> createState() => _EstimationLoadingViewState();
}

class _EstimationLoadingViewState extends State<EstimationLoadingView>
    with SingleTickerProviderStateMixin {
  final _ctrl = Get.find<EstimationController>();
  late final AnimationController _orbit;
  late final Worker _resultWorker;
  late final Worker _errorWorker;

  int _completedSteps = 0;
  bool _minDelayPassed = false;
  bool _navigated = false;

  static const _steps = [
    ('Analyse de 12 458 annonces similaires', '12 458'),
    ('Référencement des tendances locales', '58 wilayas'),
    ('Détection des comparables pertinents', '312 correspondances'),
    ('Évaluation IA · données Kloufi', 'v1.0'),
    ('Vérification DGI / marché', 'Conforme'),
    ('Projection de la valeur estimée', ''),
  ];
  static const _stepDelays = [0, 1500, 3000, 5000, 7000, 9000];

  @override
  void initState() {
    super.initState();

    _orbit = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    for (int i = 0; i < _steps.length; i++) {
      Future.delayed(Duration(milliseconds: _stepDelays[i]), () {
        if (mounted) setState(() => _completedSteps = i + 1);
      });
    }

    Future.delayed(const Duration(milliseconds: 3000), () {
      if (!mounted) return;
      _minDelayPassed = true;
      _tryNavigate();
    });

    _resultWorker = ever(_ctrl.valuationResult, (_) => _tryNavigate());
    _errorWorker = ever(_ctrl.submitError, (err) {
      if (err.isNotEmpty) _handleError(err);
    });
  }

  void _tryNavigate() {
    if (_navigated || !_minDelayPassed) return;
    if (_ctrl.valuationResult.value != null) {
      _navigated = true;
      Get.offNamed(Routes.estimationResult);
    }
  }

  void _handleError(String err) {
    if (_navigated) return;
    _navigated = true;
    Get.back();
    Get.snackbar(
      'Erreur',
      err,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 4),
    );
  }

  @override
  void dispose() {
    _orbit.dispose();
    _resultWorker.dispose();
    _errorWorker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0A0A41),
                Color(0xFF1B1B57),
                Color(0xFF2D0060),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Text(
                    'DZ-IMMO VALUATION ENGINE · V1.0',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white38,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Analyse',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'en cours...',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.italic,
                      color: Colors.white.withValues(alpha: 0.65),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Orbital gauge ──────────────────────────────────────
                  Center(
                    child: AnimatedBuilder(
                      animation: _orbit,
                      builder: (_, _) => SizedBox(
                        width: 200,
                        height: 200,
                        child: CustomPaint(
                          painter: _OrbitalPainter(progress: _orbit.value),
                          child: const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'VALEUR EN DIRECT',
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 9,
                                    letterSpacing: 1.8,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'OK',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 2,
                                  ),
                                ),
                                Text(
                                  '± 0K DA',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Steps list ─────────────────────────────────────────
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(_steps.length, (i) {
                          final (title, sub) = _steps[i];
                          return _StepRow(
                            title: title,
                            subtitle: sub,
                            completed: i < _completedSteps,
                            inProgress: i == _completedSteps,
                          );
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Footer ─────────────────────────────────────────────
                  _FooterProgress(
                    completedSteps: _completedSteps,
                    total: _steps.length,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Orbital painter ───────────────────────────────────────────────────────────

class _OrbitalPainter extends CustomPainter {
  final double progress;
  const _OrbitalPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerR = size.width / 2 - 12;
    final innerR = outerR * 0.55;

    // Rings
    canvas.drawCircle(center, outerR,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.15)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);
    canvas.drawCircle(center, innerR,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.10)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0);

    // 6 outer orbiting dots
    const dotCount = 6;
    final highlightIdx = (progress * dotCount).floor() % dotCount;
    for (int i = 0; i < dotCount; i++) {
      final angle =
          (i / dotCount + progress) * 2 * math.pi - math.pi / 2;
      final x = center.dx + outerR * math.cos(angle);
      final y = center.dy + outerR * math.sin(angle);
      final hl = i == highlightIdx;
      canvas.drawCircle(
        Offset(x, y),
        hl ? 5.5 : 3.0,
        Paint()
          ..color = hl
              ? const Color(0xFFE565FF)
              : Colors.white.withValues(alpha: 0.35),
      );
    }

    // Inner moving dot
    final innerAngle = -progress * 2 * math.pi - math.pi / 2;
    final ix = center.dx + innerR * math.cos(innerAngle);
    final iy = center.dy + innerR * math.sin(innerAngle);
    canvas.drawCircle(
      Offset(ix, iy),
      4.0,
      Paint()..color = const Color(0xFFD640FF).withValues(alpha: 0.85),
    );
  }

  @override
  bool shouldRepaint(_OrbitalPainter old) => old.progress != progress;
}

// ── Step row ──────────────────────────────────────────────────────────────────

class _StepRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool completed;
  final bool inProgress;

  const _StepRow({
    required this.title,
    required this.subtitle,
    required this.completed,
    required this.inProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 28,
          height: 28,
          child: completed
              ? Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF7F00FD),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 16),
                )
              : inProgress
                  ? const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFFE565FF),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.white24,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: completed
                      ? Colors.white
                      : inProgress
                          ? Colors.white70
                          : Colors.white30,
                  fontSize: 13,
                  fontWeight:
                      completed ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle,
                  style: TextStyle(
                    color: completed ? Colors.white38 : Colors.white12,
                    fontSize: 11,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Footer progress ───────────────────────────────────────────────────────────

class _FooterProgress extends StatelessWidget {
  final int completedSteps;
  final int total;

  const _FooterProgress({required this.completedSteps, required this.total});

  @override
  Widget build(BuildContext context) {
    final remaining = math.max(0, total - completedSteps);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$completedSteps / $total étapes complétées',
              style: const TextStyle(color: Colors.white38, fontSize: 12),
            ),
            Text(
              remaining > 0
                  ? '~ ${(remaining * 1.5).toStringAsFixed(0)} sec restant'
                  : 'Finalisation...',
              style: const TextStyle(color: Colors.white38, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: completedSteps / total,
            backgroundColor: Colors.white10,
            valueColor:
                const AlwaysStoppedAnimation(Color(0xFF7F00FD)),
            minHeight: 3,
          ),
        ),
      ],
    );
  }
}
