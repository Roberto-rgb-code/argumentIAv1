import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import '../../theme/app_theme.dart';

class DialectaAnimations {
  // Animación de carga con Lottie
  static Widget loadingAnimation({
    double? width,
    double? height,
    Color? color,
  }) {
    return SizedBox(
      width: width ?? 60,
      height: height ?? 60,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(color ?? AppTheme.primaryBlue),
      ),
    );
  }

  // Animación de éxito
  static Widget successAnimation({
    double? width,
    double? height,
  }) {
    return SizedBox(
      width: width ?? 60,
      height: height ?? 60,
      child: Icon(
        Icons.check_circle_rounded,
        color: AppTheme.mintGreen,
        size: 60,
      ),
    ).animate()
        .scale(
          duration: 300.ms,
          curve: Curves.elasticOut,
        )
        .then()
        .shimmer(
          duration: 1000.ms,
          color: AppTheme.mintGreen.withOpacity(0.3),
        );
  }

  // Animación de error
  static Widget errorAnimation({
    double? width,
    double? height,
  }) {
    return SizedBox(
      width: width ?? 60,
      height: height ?? 60,
      child: Icon(
        Icons.cancel_rounded,
        color: AppTheme.coralRed,
        size: 60,
      ),
    ).animate()
        .scale(
          duration: 300.ms,
          curve: Curves.elasticOut,
        )
        .then()
        .shake(
          duration: 500.ms,
          curve: Curves.easeInOut,
        );
  }

  // Animación de typing para chatbot
  static Widget typingAnimation() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue,
            shape: BoxShape.circle,
          ),
        ).animate(onPlay: (controller) => controller.repeat())
            .scale(
              duration: 600.ms,
              curve: Curves.easeInOut,
            )
            .then()
            .scale(
              duration: 600.ms,
              curve: Curves.easeInOut,
            ),
        const SizedBox(width: 4),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue,
            shape: BoxShape.circle,
          ),
        ).animate(onPlay: (controller) => controller.repeat())
            .scale(
              duration: 600.ms,
              curve: Curves.easeInOut,
              delay: 200.ms,
            )
            .then()
            .scale(
              duration: 600.ms,
              curve: Curves.easeInOut,
            ),
        const SizedBox(width: 4),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue,
            shape: BoxShape.circle,
          ),
        ).animate(onPlay: (controller) => controller.repeat())
            .scale(
              duration: 600.ms,
              curve: Curves.easeInOut,
              delay: 400.ms,
            )
            .then()
            .scale(
              duration: 600.ms,
              curve: Curves.easeInOut,
            ),
      ],
    );
  }

  // Animación de puntos ganados
  static Widget pointsAnimation({
    required int points,
    required VoidCallback onComplete,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: AppTheme.successGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.mintGreen.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.stars_rounded,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            '+$points pts',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ],
      ),
    ).animate()
        .scale(
          duration: 300.ms,
          curve: Curves.elasticOut,
        )
        .then()
        .moveY(
          begin: 0,
          end: -20,
          duration: 1000.ms,
          curve: Curves.easeOut,
        )
        .fadeOut(
          duration: 1000.ms,
        )
        .then()
        .callback(callback: (_) => onComplete());
  }

  // Animación de progreso
  static Widget progressAnimation({
    required double progress,
    required Color color,
    double? height,
  }) {
    return Container(
      height: height ?? 8,
      decoration: BoxDecoration(
        color: AppTheme.lightGray,
        borderRadius: BorderRadius.circular(4),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.7)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    ).animate()
        .scaleX(
          duration: 800.ms,
          curve: Curves.easeInOut,
        );
  }

  // Animación de entrada escalonada para listas
  static Widget staggeredList({
    required List<Widget> children,
    int? duration,
  }) {
    return Column(
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;
        
        return child.animate(delay: (index * 100).ms)
            .fadeIn(
              duration: Duration(milliseconds: duration ?? 400),
              curve: Curves.easeOut,
            )
            .slideY(
              begin: 0.1,
              end: 0,
              duration: Duration(milliseconds: duration ?? 400),
              curve: Curves.easeOut,
            );
      }).toList(),
    );
  }

  // Animación de pulso para elementos importantes
  static Widget pulseAnimation({
    required Widget child,
    Color? pulseColor,
    double? scale,
  }) {
    return child.animate(onPlay: (controller) => controller.repeat())
        .scale(
          begin: const Offset(1.0, 1.0),
          end: Offset(scale ?? 1.05, scale ?? 1.05),
          duration: 1000.ms,
          curve: Curves.easeInOut,
        )
        .then()
        .scale(
          begin: Offset(scale ?? 1.05, scale ?? 1.05),
          end: const Offset(1.0, 1.0),
          duration: 1000.ms,
          curve: Curves.easeInOut,
        );
  }

  // Animación de rotación continua
  static Widget rotateAnimation({
    required Widget child,
    Duration? duration,
  }) {
    return child.animate(onPlay: (controller) => controller.repeat())
        .rotate(
          duration: duration ?? const Duration(seconds: 2),
          curve: Curves.linear,
        );
  }

  // Animación de rebote
  static Widget bounceAnimation({
    required Widget child,
    Duration? duration,
  }) {
    return child.animate()
        .scale(
          duration: duration ?? 300.ms,
          curve: Curves.elasticOut,
        )
        .then()
        .scale(
          duration: duration ?? 300.ms,
          curve: Curves.elasticOut,
        );
  }

  // Animación de deslizamiento horizontal
  static Widget slideInAnimation({
    required Widget child,
    Duration? duration,
    Curve? curve,
  }) {
    return child.animate()
        .slideX(
          begin: -1,
          end: 0,
          duration: duration ?? 400.ms,
          curve: curve ?? Curves.easeOut,
        )
        .fadeIn(
          duration: duration ?? 400.ms,
        );
  }

  // Animación de deslizamiento vertical
  static Widget slideUpAnimation({
    required Widget child,
    Duration? duration,
    Curve? curve,
  }) {
    return child.animate()
        .slideY(
          begin: 1,
          end: 0,
          duration: duration ?? 400.ms,
          curve: curve ?? Curves.easeOut,
        )
        .fadeIn(
          duration: duration ?? 400.ms,
        );
  }
}

// Widget para animaciones de transición entre páginas
class DialectaPageTransition extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const DialectaPageTransition({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    return child.animate()
        .fadeIn(
          duration: duration,
          curve: curve,
        )
        .slideY(
          begin: 0.1,
          end: 0,
          duration: duration,
          curve: curve,
        );
  }
}

