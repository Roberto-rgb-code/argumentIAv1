import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';

enum DialectaButtonType {
  primary,
  secondary,
  success,
  warning,
  danger,
  premium,
  outline,
  ghost,
}

enum DialectaButtonSize {
  small,
  medium,
  large,
  extraLarge,
}

class DialectaButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final DialectaButtonType type;
  final DialectaButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Duration? animationDelay;

  const DialectaButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = DialectaButtonType.primary,
    this.size = DialectaButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.padding,
    this.borderRadius,
    this.animationDelay,
  });

  @override
  State<DialectaButton> createState() => _DialectaButtonState();
}

class _DialectaButtonState extends State<DialectaButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle();
    final buttonContent = _buildButtonContent();

    Widget buttonWidget = GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.isFullWidth ? double.infinity : null,
              padding: widget.padding ?? _getPadding(),
              decoration: BoxDecoration(
                gradient: buttonStyle.gradient,
                color: buttonStyle.backgroundColor,
                borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
                border: buttonStyle.border,
                boxShadow: buttonStyle.boxShadow,
              ),
              child: buttonContent,
            ),
          );
        },
      ),
    );

    if (widget.animationDelay != null) {
      return buttonWidget.animate(delay: widget.animationDelay!)
          .fadeIn(duration: 400.ms)
          .slideX(begin: 0.1, curve: Curves.easeOut);
    }

    return buttonWidget;
  }

  Widget _buildButtonContent() {
    if (widget.isLoading) {
      return SizedBox(
        height: _getIconSize(),
        width: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(_getTextColor()),
        ),
      );
    }

    if (widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.icon,
            size: _getIconSize(),
            color: _getTextColor(),
          ),
          const SizedBox(width: 8),
          Text(
            widget.text,
            style: _getTextStyle(),
          ),
        ],
      );
    }

    return Text(
      widget.text,
      style: _getTextStyle(),
      textAlign: TextAlign.center,
    );
  }

  _ButtonStyle _getButtonStyle() {
    switch (widget.type) {
      case DialectaButtonType.primary:
        return _ButtonStyle(
          gradient: AppTheme.primaryGradient,
          backgroundColor: null,
          border: null,
          boxShadow: AppTheme.buttonShadow,
        );
      case DialectaButtonType.secondary:
        return _ButtonStyle(
          gradient: null,
          backgroundColor: AppTheme.lightGray,
          border: null,
          boxShadow: AppTheme.cardShadow,
        );
      case DialectaButtonType.success:
        return _ButtonStyle(
          gradient: AppTheme.successGradient,
          backgroundColor: null,
          border: null,
          boxShadow: [
            BoxShadow(
              color: AppTheme.mintGreen.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        );
      case DialectaButtonType.warning:
        return _ButtonStyle(
          gradient: AppTheme.warningGradient,
          backgroundColor: null,
          border: null,
          boxShadow: [
            BoxShadow(
              color: AppTheme.brightOrange.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        );
      case DialectaButtonType.danger:
        return _ButtonStyle(
          gradient: LinearGradient(
            colors: [AppTheme.coralRed, const Color(0xFFE53E3E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          backgroundColor: null,
          border: null,
          boxShadow: [
            BoxShadow(
              color: AppTheme.coralRed.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        );
      case DialectaButtonType.premium:
        return _ButtonStyle(
          gradient: AppTheme.premiumGradient,
          backgroundColor: null,
          border: null,
          boxShadow: [
            BoxShadow(
              color: AppTheme.purple.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        );
      case DialectaButtonType.outline:
        return _ButtonStyle(
          gradient: null,
          backgroundColor: Colors.transparent,
          border: Border.all(color: AppTheme.primaryBlue, width: 2),
          boxShadow: null,
        );
      case DialectaButtonType.ghost:
        return _ButtonStyle(
          gradient: null,
          backgroundColor: Colors.transparent,
          border: null,
          boxShadow: null,
        );
    }
  }

  EdgeInsetsGeometry _getPadding() {
    switch (widget.size) {
      case DialectaButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case DialectaButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case DialectaButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
      case DialectaButtonSize.extraLarge:
        return const EdgeInsets.symmetric(horizontal: 40, vertical: 20);
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case DialectaButtonSize.small:
        return 16;
      case DialectaButtonSize.medium:
        return 20;
      case DialectaButtonSize.large:
        return 24;
      case DialectaButtonSize.extraLarge:
        return 28;
    }
  }

  TextStyle _getTextStyle() {
    final baseStyle = TextStyle(
      color: _getTextColor(),
      fontWeight: FontWeight.w600,
      height: 1.2,
    );

    switch (widget.size) {
      case DialectaButtonSize.small:
        return baseStyle.copyWith(fontSize: 12);
      case DialectaButtonSize.medium:
        return baseStyle.copyWith(fontSize: 14);
      case DialectaButtonSize.large:
        return baseStyle.copyWith(fontSize: 16);
      case DialectaButtonSize.extraLarge:
        return baseStyle.copyWith(fontSize: 18);
    }
  }

  Color _getTextColor() {
    switch (widget.type) {
      case DialectaButtonType.primary:
      case DialectaButtonType.success:
      case DialectaButtonType.warning:
      case DialectaButtonType.danger:
      case DialectaButtonType.premium:
        return Colors.white;
      case DialectaButtonType.secondary:
        return AppTheme.charcoalBlack;
      case DialectaButtonType.outline:
      case DialectaButtonType.ghost:
        return AppTheme.primaryBlue;
    }
  }
}

class _ButtonStyle {
  final LinearGradient? gradient;
  final Color? backgroundColor;
  final Border? border;
  final List<BoxShadow>? boxShadow;

  _ButtonStyle({
    this.gradient,
    this.backgroundColor,
    this.border,
    this.boxShadow,
  });
}

// Botón especial para debates
class DialectaDebateButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPro;
  final bool isSelected;
  final IconData icon;

  const DialectaDebateButton({
    super.key,
    required this.text,
    this.onPressed,
    required this.isPro,
    this.isSelected = false,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final color = isPro ? AppTheme.mintGreen : AppTheme.coralRed;
    
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : color.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? AppTheme.cardShadow : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? color : color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : color,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              text,
              style: TextStyle(
                color: isSelected ? color : AppTheme.charcoalBlack,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
