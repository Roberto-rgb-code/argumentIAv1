import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import '../../theme/app_theme.dart';

/// Componentes Material Design 3 personalizados para Dialecta
class DialectaM3Components {
  
  // === FAB (Floating Action Button) ===
  static Widget fab({
    required VoidCallback onPressed,
    required IconData icon,
    String? tooltip,
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      tooltip: tooltip,
      backgroundColor: backgroundColor ?? AppTheme.primaryBlue,
      foregroundColor: foregroundColor ?? Colors.white,
      elevation: 8,
      extendedPadding: const EdgeInsets.symmetric(horizontal: 24),
      icon: Icon(icon, size: 20),
      label: Text(
        tooltip ?? '',
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // === Navigation Bar M3 ===
  static Widget navigationBar({
    required int selectedIndex,
    required ValueChanged<int> onDestinationSelected,
    required List<NavigationDestination> destinations,
  }) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: destinations,
      backgroundColor: Colors.white,
      surfaceTintColor: AppTheme.primaryBlue,
      indicatorColor: AppTheme.primaryBlue.withOpacity(0.2),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      height: 80,
    );
  }

  // === Cards M3 ===
  static Widget card({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? backgroundColor,
    double? elevation,
    VoidCallback? onTap,
  }) {
    final card = Card(
      elevation: elevation ?? 2,
      color: backgroundColor ?? Colors.white,
      surfaceTintColor: AppTheme.primaryBlue.withOpacity(0.1),
      margin: margin ?? const EdgeInsets.all(8),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: card,
      );
    }

    return card;
  }

  // === Chips M3 ===
  static Widget chip({
    required String label,
    bool selected = false,
    VoidCallback? onSelected,
    Widget? avatar,
    Widget? deleteIcon,
    VoidCallback? onDeleted,
  }) {
    return FilterChip(
      label: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          color: selected ? Colors.white : AppTheme.primaryBlue,
        ),
      ),
      selected: selected,
      onSelected: onSelected != null ? (_) => onSelected() : null,
      avatar: avatar,
      deleteIcon: deleteIcon,
      onDeleted: onDeleted,
      backgroundColor: Colors.white,
      selectedColor: AppTheme.primaryBlue,
      checkmarkColor: Colors.white,
      side: BorderSide(
        color: AppTheme.primaryBlue.withOpacity(0.3),
        width: 1,
      ),
      elevation: selected ? 4 : 0,
      pressElevation: 2,
    );
  }

  // === Buttons M3 ===
  static Widget filledButton({
    required String text,
    required VoidCallback onPressed,
    IconData? icon,
    Color? backgroundColor,
    Color? foregroundColor,
    EdgeInsetsGeometry? padding,
  }) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon, size: 18) : const SizedBox.shrink(),
      label: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor ?? AppTheme.primaryBlue,
        foregroundColor: foregroundColor ?? Colors.white,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  static Widget outlinedButton({
    required String text,
    required VoidCallback onPressed,
    IconData? icon,
    Color? borderColor,
    Color? foregroundColor,
    EdgeInsetsGeometry? padding,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon, size: 18) : const SizedBox.shrink(),
      label: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: foregroundColor ?? AppTheme.primaryBlue,
        side: BorderSide(
          color: borderColor ?? AppTheme.primaryBlue,
          width: 1.5,
        ),
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  static Widget textButton({
    required String text,
    required VoidCallback onPressed,
    IconData? icon,
    Color? foregroundColor,
    EdgeInsetsGeometry? padding,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon, size: 18) : const SizedBox.shrink(),
      label: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: TextButton.styleFrom(
        foregroundColor: foregroundColor ?? AppTheme.primaryBlue,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // === Text Fields M3 ===
  static Widget textField({
    required String label,
    String? hint,
    String? helperText,
    String? errorText,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    bool obscureText = false,
    Widget? prefixIcon,
    Widget? suffixIcon,
    int? maxLines,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      obscureText: obscureText,
      maxLines: maxLines ?? 1,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.inter(
        fontSize: 16,
        color: AppTheme.charcoalBlack,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helperText,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppTheme.primaryBlue.withOpacity(0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppTheme.primaryBlue.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppTheme.primaryBlue,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppTheme.errorRed,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  // === Lists M3 ===
  static Widget listTile({
    required String title,
    String? subtitle,
    Widget? leading,
    Widget? trailing,
    VoidCallback? onTap,
    bool selected = false,
  }) {
    return ListTile(
      leading: leading,
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: selected ? AppTheme.primaryBlue : AppTheme.charcoalBlack,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.primaryBlue.withOpacity(0.7),
              ),
            )
          : null,
      trailing: trailing,
      onTap: onTap,
      selected: selected,
      selectedTileColor: AppTheme.primaryBlue.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  // === Dialogs M3 ===
  static Widget alertDialog({
    required String title,
    required String content,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    Color? confirmButtonColor,
  }) {
    return AlertDialog(
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppTheme.charcoalBlack,
        ),
      ),
      content: Text(
        content,
        style: GoogleFonts.inter(
          fontSize: 16,
          color: AppTheme.charcoalBlack.withOpacity(0.8),
        ),
      ),
      actions: [
        if (cancelText != null)
          TextButton(
            onPressed: onCancel,
            child: Text(
              cancelText,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryBlue,
              ),
            ),
          ),
        if (confirmText != null)
          FilledButton(
            onPressed: onConfirm,
            style: FilledButton.styleFrom(
              backgroundColor: confirmButtonColor ?? AppTheme.primaryBlue,
            ),
            child: Text(
              confirmText,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  // === Progress Indicators M3 ===
  static Widget linearProgress({
    required double value,
    Color? backgroundColor,
    Color? valueColor,
    double? height,
  }) {
    return LinearProgressIndicator(
      value: value,
      backgroundColor: backgroundColor ?? AppTheme.primaryBlue.withOpacity(0.2),
      valueColor: AlwaysStoppedAnimation<Color>(
        valueColor ?? AppTheme.primaryBlue,
      ),
      minHeight: height ?? 4,
    );
  }

  static Widget circularProgress({
    double? value,
    Color? backgroundColor,
    Color? valueColor,
    double? strokeWidth,
  }) {
    return CircularProgressIndicator(
      value: value,
      backgroundColor: backgroundColor ?? AppTheme.primaryBlue.withOpacity(0.2),
      valueColor: AlwaysStoppedAnimation<Color>(
        valueColor ?? AppTheme.primaryBlue,
      ),
      strokeWidth: strokeWidth ?? 4,
    );
  }

  // === Badges M3 ===
  static Widget badge({
    required Widget child,
    required String label,
    Color? backgroundColor,
    Color? textColor,
    bool showBadge = true,
  }) {
    return Badge(
      label: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor ?? Colors.white,
        ),
      ),
      backgroundColor: backgroundColor ?? AppTheme.errorRed,
      isLabelVisible: showBadge,
      child: child,
    );
  }

  // === Segmented Control M3 ===
  static Widget segmentedControl({
    required List<String> options,
    required int selectedIndex,
    required ValueChanged<int> onSelectionChanged,
  }) {
    return SegmentedButton<int>(
      segments: options.asMap().entries.map((entry) {
        return ButtonSegment<int>(
          value: entry.key,
          label: Text(
            entry.value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
      selected: {selectedIndex},
      onSelectionChanged: (Set<int> newSelection) {
        onSelectionChanged(newSelection.first);
      },
      style: SegmentedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.primaryBlue,
        selectedBackgroundColor: AppTheme.primaryBlue,
        selectedForegroundColor: Colors.white,
        side: BorderSide(
          color: AppTheme.primaryBlue.withOpacity(0.3),
        ),
      ),
    );
  }
}
