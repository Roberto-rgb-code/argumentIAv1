import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Paleta de colores de la identidad corporativa
  static const Color primaryBlue = Color(0xFF0066FF);
  static const Color charcoalBlack = Color(0xFF1A1A1A);
  static const Color mintGreen = Color(0xFF00D4AA);
  static const Color brightOrange = Color(0xFFFF6B35);
  static const Color lightGray = Color(0xFFF5F5F7);
  static const Color coralRed = Color(0xFFFF4757);
  static const Color purple = Color(0xFF7C4DFF);

  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, Color(0xFF0052CC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [mintGreen, Color(0xFF00BFA5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [brightOrange, Color(0xFFE55A2B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient premiumGradient = LinearGradient(
    colors: [purple, Color(0xFF6A4C93)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Sombras neomórficas
  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: charcoalBlack.withOpacity(0.08),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: Colors.white.withOpacity(0.8),
      blurRadius: 20,
      offset: const Offset(0, -8),
    ),
  ];

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: charcoalBlack.withOpacity(0.04),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get buttonShadow => [
    BoxShadow(
      color: primaryBlue.withOpacity(0.3),
      blurRadius: 12,
      offset: const Offset(0, 6),
    ),
  ];

  // Configuración del tema
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Colores principales
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: mintGreen,
        tertiary: brightOrange,
        surface: Colors.white,
        background: lightGray,
        error: coralRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: charcoalBlack,
        onBackground: charcoalBlack,
        onError: Colors.white,
      ),

      // Fuentes
      textTheme: TextTheme(
        // Títulos principales
        displayLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: charcoalBlack,
          height: 1.2,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: charcoalBlack,
          height: 1.2,
        ),
        displaySmall: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: charcoalBlack,
          height: 1.2,
        ),
        
        // Títulos de sección
        headlineLarge: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: charcoalBlack,
          height: 1.3,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: charcoalBlack,
          height: 1.3,
        ),
        headlineSmall: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: charcoalBlack,
          height: 1.3,
        ),
        
        // Subtítulos
        titleLarge: GoogleFonts.ibmPlexSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: charcoalBlack,
          height: 1.4,
        ),
        titleMedium: GoogleFonts.ibmPlexSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: charcoalBlack,
          height: 1.4,
        ),
        titleSmall: GoogleFonts.ibmPlexSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: charcoalBlack,
          height: 1.4,
        ),
        
        // Texto del cuerpo
        bodyLarge: GoogleFonts.ibmPlexSans(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: charcoalBlack,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.ibmPlexSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: charcoalBlack,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.ibmPlexSans(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: charcoalBlack,
          height: 1.5,
        ),
        
        // Etiquetas
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: charcoalBlack,
          height: 1.4,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: charcoalBlack,
          height: 1.4,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: charcoalBlack,
          height: 1.4,
        ),
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: charcoalBlack,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: charcoalBlack,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Botones
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryBlue,
          side: const BorderSide(color: primaryBlue, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: coralRed, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: GoogleFonts.ibmPlexSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: charcoalBlack.withOpacity(0.6),
        ),
        labelStyle: GoogleFonts.ibmPlexSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: charcoalBlack,
        ),
      ),

      // Navigation Bar
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: primaryBlue.withOpacity(0.1),
        labelTextStyle: WidgetStateProperty.all(
          GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Tab Bar
      tabBarTheme: TabBarThemeData(
        labelColor: primaryBlue,
        unselectedLabelColor: charcoalBlack.withOpacity(0.6),
        indicator: UnderlineTabIndicator(
          borderSide: const BorderSide(color: primaryBlue, width: 3),
          insets: const EdgeInsets.symmetric(horizontal: 16),
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      // Bottom Sheet
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: charcoalBlack,
        ),
        contentTextStyle: GoogleFonts.ibmPlexSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: charcoalBlack,
        ),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: charcoalBlack.withOpacity(0.1),
        thickness: 1,
        space: 1,
      ),
    );
  }
}

// Extensiones para facilitar el uso
extension AppColors on ColorScheme {
  Color get primaryBlue => AppTheme.primaryBlue;
  Color get charcoalBlack => AppTheme.charcoalBlack;
  Color get mintGreen => AppTheme.mintGreen;
  Color get brightOrange => AppTheme.brightOrange;
  Color get lightGray => AppTheme.lightGray;
  Color get coralRed => AppTheme.coralRed;
  Color get purple => AppTheme.purple;
}

extension AppGradients on BuildContext {
  LinearGradient get primaryGradient => AppTheme.primaryGradient;
  LinearGradient get successGradient => AppTheme.successGradient;
  LinearGradient get warningGradient => AppTheme.warningGradient;
  LinearGradient get premiumGradient => AppTheme.premiumGradient;
}

extension AppShadows on BuildContext {
  List<BoxShadow> get softShadow => AppTheme.softShadow;
  List<BoxShadow> get cardShadow => AppTheme.cardShadow;
  List<BoxShadow> get buttonShadow => AppTheme.buttonShadow;
}

// === Material Design 3 Theme ===
class AppThemeM3 {
  // Color scheme M3 basado en la identidad Dialecta
  static ColorScheme get lightColorScheme {
    return ColorScheme.fromSeed(
      seedColor: AppTheme.primaryBlue,
      brightness: Brightness.light,
      primary: AppTheme.primaryBlue,
      secondary: AppTheme.mintGreen,
      tertiary: AppTheme.brightOrange,
      surface: Colors.white,
      surfaceContainer: AppTheme.lightGray,
      surfaceContainerHigh: Colors.white,
      surfaceContainerHighest: AppTheme.lightGray,
      outline: AppTheme.primaryBlue.withOpacity(0.3),
      outlineVariant: AppTheme.primaryBlue.withOpacity(0.1),
      error: AppTheme.coralRed,
      onPrimary: Colors.white,
      onSecondary: AppTheme.charcoalBlack,
      onTertiary: Colors.white,
      onSurface: AppTheme.charcoalBlack,
      onSurfaceVariant: AppTheme.charcoalBlack.withOpacity(0.7),
      onError: Colors.white,
    );
  }

  static ColorScheme get darkColorScheme {
    return ColorScheme.fromSeed(
      seedColor: AppTheme.primaryBlue,
      brightness: Brightness.dark,
      primary: AppTheme.primaryBlue,
      secondary: AppTheme.mintGreen,
      tertiary: AppTheme.brightOrange,
      surface: const Color(0xFF1A1A1A),
      surfaceContainer: const Color(0xFF2A2A2A),
      surfaceContainerHigh: const Color(0xFF3A3A3A),
      surfaceContainerHighest: const Color(0xFF4A4A4A),
      outline: AppTheme.primaryBlue.withOpacity(0.5),
      outlineVariant: AppTheme.primaryBlue.withOpacity(0.2),
      error: AppTheme.coralRed,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onTertiary: Colors.white,
      onSurface: Colors.white,
      onSurfaceVariant: Colors.white.withOpacity(0.7),
      onError: Colors.white,
    );
  }

  // Tema M3 completo
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      textTheme: GoogleFonts.interTextTheme(),
      
      // AppBar M3
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.charcoalBlack,
        elevation: 0,
        surfaceTintColor: AppTheme.primaryBlue,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppTheme.charcoalBlack,
        ),
        centerTitle: false,
      ),

      // Navigation Bar M3
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: AppTheme.primaryBlue,
        indicatorColor: AppTheme.primaryBlue.withOpacity(0.2),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryBlue,
            );
          }
          return GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppTheme.charcoalBlack.withOpacity(0.6),
          );
        }),
      ),

      // Cards M3
      cardTheme: CardThemeData(
        elevation: 2,
        color: Colors.white,
        surfaceTintColor: AppTheme.primaryBlue.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(8),
      ),

      // Buttons M3
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppTheme.primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.primaryBlue,
          side: BorderSide(
            color: AppTheme.primaryBlue,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppTheme.primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Fields M3
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
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
            color: AppTheme.coralRed,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: GoogleFonts.inter(
          fontSize: 16,
          color: AppTheme.charcoalBlack.withOpacity(0.7),
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 16,
          color: AppTheme.charcoalBlack.withOpacity(0.5),
        ),
      ),

      // Chips M3
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        selectedColor: AppTheme.primaryBlue,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide(
          color: AppTheme.primaryBlue.withOpacity(0.3),
          width: 1,
        ),
      ),

      // Floating Action Button M3
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Progress Indicators M3
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppTheme.primaryBlue,
        linearTrackColor: AppTheme.primaryBlue.withOpacity(0.2),
        circularTrackColor: AppTheme.primaryBlue.withOpacity(0.2),
      ),

      // Dialogs M3
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: AppTheme.primaryBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppTheme.charcoalBlack,
        ),
        contentTextStyle: GoogleFonts.inter(
          fontSize: 16,
          color: AppTheme.charcoalBlack.withOpacity(0.8),
        ),
      ),

      // Snackbar M3
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppTheme.charcoalBlack,
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Bottom Sheet M3
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: AppTheme.primaryBlue,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
      ),

      // Tab Bar M3
      tabBarTheme: TabBarThemeData(
        labelColor: AppTheme.primaryBlue,
        unselectedLabelColor: AppTheme.charcoalBlack.withOpacity(0.6),
        indicatorColor: AppTheme.primaryBlue,
        labelStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      
      // AppBar M3 Dark
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: AppTheme.primaryBlue,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        centerTitle: false,
      ),

      // Navigation Bar M3 Dark
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF1A1A1A),
        surfaceTintColor: AppTheme.primaryBlue,
        indicatorColor: AppTheme.primaryBlue.withOpacity(0.3),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryBlue,
            );
          }
          return GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.6),
          );
        }),
      ),

      // Cards M3 Dark
      cardTheme: CardThemeData(
        elevation: 2,
        color: const Color(0xFF2A2A2A),
        surfaceTintColor: AppTheme.primaryBlue.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(8),
      ),

      // Resto de temas dark similares...
    );
  }
}
