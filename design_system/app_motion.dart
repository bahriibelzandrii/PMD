import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// Motion & Animation Tokens and Approved Animation Widgets
/// for TaskMaster Flutter Labs 1–10.
///
/// Approved Stack:
/// 1. Transitions: Shared Axis Slide (A) + Hero Container (B)
/// 2. Buttons: Spring Bouncy Press (A) + Morphing Checkbox (C)
/// 3. Celebration: Slow Confetti Blast (A) + Count-Up Ring (C)
/// 4. Lists & Drawers: Staggered Fade Up (A) + Fluid Bottom Sheet (B)
class AppMotion {
  AppMotion._();

  // ===========================================================================
  // 1. DURATION TOKENS
  // ===========================================================================
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 350);
  static const Duration pageTransition = Duration(milliseconds: 450);
  static const Duration heroExpand = Duration(milliseconds: 500);
  static const Duration countUp = Duration(milliseconds: 800);
  static const Duration celebration = Duration(milliseconds: 2800);

  // ===========================================================================
  // 2. CURVE TOKENS
  // ===========================================================================
  static const Curve standard = Curves.easeOutCubic;
  static const Curve spring = Curves.elasticOut;
  static const Curve bounce = Curves.easeOutBack;
  static const Curve easeInOut = Curves.easeInOutQuad;
}

// =============================================================================
// 1A. SHARED AXIS PAGE ROUTE (Screen Transition)
// =============================================================================
class SharedAxisPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  SharedAxisPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: AppMotion.pageTransition,
          reverseTransitionDuration: AppMotion.pageTransition,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: AppMotion.standard,
            );

            final slideTween = Tween<Offset>(
              begin: const Offset(0.08, 0.0),
              end: Offset.zero,
            ).animate(curved);

            final fadeTween = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(curved);

            return SlideTransition(
              position: slideTween,
              child: FadeTransition(
                opacity: fadeTween,
                child: child,
              ),
            );
          },
        );
}

// =============================================================================
// 2A. SPRING BOUNCY BUTTON (Micro-interaction)
// =============================================================================
class SpringButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scaleFactor;

  const SpringButton({
    super.key,
    required this.child,
    this.onTap,
    this.scaleFactor = 0.88,
  });

  @override
  State<SpringButton> createState() => _SpringButtonState();
}

class _SpringButtonState extends State<SpringButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: AppMotion.normal,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleFactor,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
        reverseCurve: AppMotion.spring,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _controller.forward();

  void _onTapUp(TapUpDetails _) {
    _controller.reverse();
    widget.onTap?.call();
  }

  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}

// =============================================================================
// 2C. MORPHING CHECKBOX (Interactive Checkmark)
// =============================================================================
class MorphCheckbox extends StatefulWidget {
  final bool isChecked;
  final ValueChanged<bool>? onChanged;
  final double size;

  const MorphCheckbox({
    super.key,
    required this.isChecked,
    this.onChanged,
    this.size = 24.0,
  });

  @override
  State<MorphCheckbox> createState() => _MorphCheckboxState();
}

class _MorphCheckboxState extends State<MorphCheckbox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: widget.isChecked ? 1.0 : 0.0,
    );
  }

  @override
  void didUpdateWidget(covariant MorphCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isChecked != oldWidget.isChecked) {
      if (widget.isChecked) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        final next = !widget.isChecked;
        widget.onChanged?.call(next);
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final val = _controller.value;
          final borderCol = Color.lerp(
            isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            theme.colorScheme.primary,
            val,
          )!;
          final fillCol = Color.lerp(
            Colors.transparent,
            theme.colorScheme.primary,
            val,
          )!;

          return Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: fillCol,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: borderCol, width: 1.8),
              boxShadow: val > 0.5
                  ? [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.35 * val),
                        blurRadius: 8 * val,
                      )
                    ]
                  : null,
            ),
            child: val > 0.1
                ? Transform.scale(
                    scale: val,
                    child: Icon(
                      Icons.check,
                      size: widget.size * 0.75,
                      color: theme.colorScheme.onPrimary,
                    ),
                  )
                : null,
          );
        },
      ),
    );
  }
}

// =============================================================================
// 3A. SLOW NEON CONFETTI CELEBRATION (CustomPainter Physics)
// =============================================================================
class GentleConfettiOverlay extends StatefulWidget {
  final Widget child;
  final bool trigger;

  const GentleConfettiOverlay({
    super.key,
    required this.child,
    required this.trigger,
  });

  @override
  State<GentleConfettiOverlay> createState() => _GentleConfettiOverlayState();
}

class _GentleConfettiOverlayState extends State<GentleConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_ConfettiParticle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppMotion.celebration,
    )..addListener(() {
        if (_controller.isAnimating) {
          _updateParticles();
        }
      });

    if (widget.trigger) {
      _spawnAndPlay();
    }
  }

  @override
  void didUpdateWidget(covariant GentleConfettiOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !oldWidget.trigger) {
      _spawnAndPlay();
    }
  }

  void _spawnAndPlay() {
    _particles.clear();
    const colors = [
      AppColors.cyberLime,
      AppColors.cyberCyan,
      AppColors.white,
      Color(0xFFA855F7),
      Color(0xFF38BDF8),
    ];

    for (int i = 0; i < 45; i++) {
      _particles.add(
        _ConfettiParticle(
          x: 0,
          y: 0,
          vx: (_random.nextDouble() - 0.5) * 4.2,
          vy: -(_random.nextDouble() * 4.0 + 2.0),
          size: _random.nextDouble() * 5.0 + 3.0,
          color: colors[_random.nextInt(colors.length)],
          alpha: 1.0,
          rot: _random.nextDouble() * 360,
          dRot: (_random.nextDouble() - 0.5) * 3.0,
          wobbleFreq: _random.nextDouble() * 0.05 + 0.02,
          wobbleAmp: _random.nextDouble() * 0.8 + 0.4,
        ),
      );
    }
    _controller.forward(from: 0.0);
  }

  void _updateParticles() {
    for (final p in _particles) {
      p.vx *= 0.988;
      p.vy = math.min(p.vy + 0.045, 1.4);
      p.x += p.vx + math.sin(p.y * p.wobbleFreq) * p.wobbleAmp;
      p.y += p.vy;
      p.alpha = math.max(0.0, p.alpha - 0.006);
      p.rot += p.dRot;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_controller.isAnimating)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return CustomPaint(
                    painter: _ConfettiPainter(_particles),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}

class _ConfettiParticle {
  double x;
  double y;
  double vx;
  double vy;
  double size;
  Color color;
  double alpha;
  double rot;
  double dRot;
  double wobbleFreq;
  double wobbleAmp;

  _ConfettiParticle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.color,
    required this.alpha,
    required this.rot,
    required this.dRot,
    required this.wobbleFreq,
    required this.wobbleAmp,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;

  _ConfettiPainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final origin = Offset(size.width / 2, size.height / 2);

    for (final p in particles) {
      if (p.alpha <= 0) continue;

      final paint = Paint()
        ..color = p.color.withValues(alpha: p.alpha)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(origin.dx + p.x, origin.dy + p.y);
      canvas.rotate(p.rot * math.pi / 180);
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: p.size,
          height: p.size * 0.7,
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}

// =============================================================================
// 3C. COUNT-UP PROGRESS RING (Radial Milestone)
// =============================================================================
class CountUpProgressRing extends StatelessWidget {
  final double targetProgress; // e.g., 0.84 for 84%
  final double size;
  final double strokeWidth;
  final Color? color;

  const CountUpProgressRing({
    super.key,
    required this.targetProgress,
    this.size = 80.0,
    this.strokeWidth = 6.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentCol = color ?? theme.colorScheme.primary;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: targetProgress),
      duration: AppMotion.countUp,
      curve: AppMotion.standard,
      builder: (context, value, _) {
        final percent = (value * 100).toInt();

        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: value,
                strokeWidth: strokeWidth,
                backgroundColor: theme.brightness == Brightness.dark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.06),
                valueColor: AlwaysStoppedAnimation<Color>(accentCol),
              ),
              Text(
                '$percent%',
                style: AppTypography.monoStats.copyWith(
                  fontSize: size * 0.22,
                  color: accentCol,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// =============================================================================
// 4A. STAGGERED SLIDE IN (Cascading List Item)
// =============================================================================
class StaggeredSlideIn extends StatelessWidget {
  final Animation<double> parentAnimation;
  final int index;
  final int totalItems;
  final Widget child;

  const StaggeredSlideIn({
    super.key,
    required this.parentAnimation,
    required this.index,
    this.totalItems = 10,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final step = (0.6 / totalItems).clamp(0.02, 0.1);
    final start = (index * step).clamp(0.0, 0.7);
    final end = (start + 0.3).clamp(0.0, 1.0);

    final animation = CurvedAnimation(
      parent: parentAnimation,
      curve: Interval(start, end, curve: AppMotion.standard),
    );

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 0.2),
        end: Offset.zero,
      ).animate(animation),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}

// =============================================================================
// 4B. FLUID MODAL BOTTOM SHEET HELPER
// =============================================================================
Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required Widget child,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      );
    },
  );
}
