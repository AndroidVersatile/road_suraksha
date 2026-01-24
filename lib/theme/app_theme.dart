import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme extends ChangeNotifier {
  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);

  static ThemeData lightThemeData =
      themeData(lightColorScheme, _lightFocusColor);
  static ThemeData darkThemeData =
      themeData(lightColorScheme, _lightFocusColor);

  static const ColorScheme lightColorScheme = ColorScheme(
    primary: Color(0xFF850000),
    outline: Color(0xFF850000),
    shadow: Color(0xFF8189B0),
    onTertiary: Color(0xFFFFFFFF),
    secondary: Color(0xFF850000),
    surface: Color(0xFFF5F6F6),
    background: Color(0xFFF4F5F9),
    error: Color(0xFFBA1B1B),
    onPrimary: Color(0xFFFFFFFF),
    onSecondary: Color(0xFFFFFFFF),
    onSurface: Color(0xFF1B1B1F),
    onBackground: Color(0xFF1B1B1F),
    onError: Color(0xFFFFFFFF),
    brightness: Brightness.light,
  );

  static const radius = 7.0;

  static final shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(radius),
  );

  static const _regular = FontWeight.w400;
  static const _medium = FontWeight.w500;
  static const _semiBold = FontWeight.w500;
  static const _bold = FontWeight.w700;

  static final TextTheme _textTheme = GoogleFonts.poppinsTextTheme(TextTheme(
    displayLarge: GoogleFonts.poppins(fontWeight: _bold, letterSpacing: 0),
    displayMedium: GoogleFonts.poppins(fontWeight: _semiBold, letterSpacing: 0),
    displaySmall: GoogleFonts.poppins(fontWeight: _regular, letterSpacing: 0),
    headlineMedium: GoogleFonts.poppins(fontWeight: _regular, letterSpacing: 0),
    headlineSmall: GoogleFonts.poppins(fontWeight: _regular, letterSpacing: 0),
    titleLarge: GoogleFonts.poppins(fontWeight: _regular, letterSpacing: 0),
    titleMedium: GoogleFonts.poppins(fontWeight: _semiBold, letterSpacing: 0),
    titleSmall: GoogleFonts.poppins(fontWeight: _medium, letterSpacing: 0),
    bodyLarge: GoogleFonts.poppins(fontWeight: _regular, letterSpacing: 0.0),
    bodyMedium: GoogleFonts.poppins(fontWeight: _regular, letterSpacing: 0.0),
    // titleLarge: GoogleFonts.poppins(fontWeight: _bold),
    // titleMedium: GoogleFonts.poppins(fontWeight: _semiBold),
    // titleSmall: GoogleFonts.poppins(fontWeight: _regular),
    // displayLarge: GoogleFonts.poppins(fontWeight: _bold),
    // displayMedium: GoogleFonts.poppins(fontWeight: _semiBold),
    // displaySmall: GoogleFonts.poppins(fontWeight: _regular),
    // headlineLarge: GoogleFonts.poppins(fontWeight: _bold),
    // headlineMedium: GoogleFonts.poppins(fontWeight: _semiBold),
    // headlineSmall: GoogleFonts.poppins(fontWeight: _regular),
    // bodyLarge: GoogleFonts.poppins(fontWeight: _bold),
    // bodyMedium: GoogleFonts.poppins(fontWeight: _semiBold),
    // bodySmall: GoogleFonts.poppins(fontWeight: _regular),
    // labelLarge: GoogleFonts.poppins(fontWeight: _bold),
    // labelMedium: GoogleFonts.poppins(fontWeight: _semiBold),
    // labelSmall: GoogleFonts.poppins(fontWeight: _regular),
    labelLarge: GoogleFonts.poppins(fontWeight: _medium, letterSpacing: 1.25),
    labelSmall: GoogleFonts.poppins(fontWeight: _regular, letterSpacing: 0.2),
    bodySmall: GoogleFonts.poppins(fontWeight: _regular, letterSpacing: 1.5),
  ));
  static List<Color> lightColorList = [
    Color(0xFFFCDCD3),
    Color(0xFFD7D9FF),
    Color(0xFFD5ECE0),
    Color(0xFFA8EAFF),
    Color(0xFFABC7F1),
    Color(0xFFABC7F1),
    // Color(0xFF798CE1),
    // Color(0xFF8EDFEB),
    // Color(0xFFEC7468),
    // Color(0xFF79EAE5),
    // Color(0xFF54A4D7),
    // Color(0xFF63CB8F),
    // Color(0xFF618EE1),
    // Color(0xFF),
    // Color(0xFF),
  ];
  static var screenPadding =
      const EdgeInsets.only(top: 8, left: 10, right: 10, bottom: 8);

  static var boxPadding = const EdgeInsets.all(10);
  static var screenHorizontalPadding =
      const EdgeInsets.only(top: 2, left: 10, right: 10, bottom: 2);
  static var buttonPadding =
      const EdgeInsets.symmetric(horizontal: 8, vertical: 4);

  static SizedBox verticalSpacing({double mul = 1.0}) {
    return SizedBox(height: 8 * mul);
  }

  static var appBarSpacing = const SizedBox(
    height: 52,
  );

  static SizedBox horizontalSpacing({double mul = 1}) => SizedBox(
        width: 12 * mul,
      );

  static ThemeData themeData(ColorScheme colorScheme, Color focusColor) {
    return ThemeData(
        primaryTextTheme: AppTheme._textTheme,
        listTileTheme: ListTileThemeData(
          iconColor: colorScheme.secondary,
          textColor: colorScheme.primary,
          // tileColor: colorScheme.shadow,
        ),
        primaryColor: colorScheme.primary,
        brightness: Brightness.light,
        scaffoldBackgroundColor: colorScheme.background,
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateColor.resolveWith(
            (states) {
              return colorScheme.secondary;
            },
          ),
        ),
        cardColor: Colors.white,
        bannerTheme: MaterialBannerThemeData(
          backgroundColor: const Color(0xffFFA37B),
          contentTextStyle: _textTheme.titleMedium!.apply(color: Colors.black),
        ),
        tabBarTheme: TabBarThemeData(
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: colorScheme.primary,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: colorScheme.secondary, width: 3),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.primary,
          iconTheme: IconThemeData(color: Colors.white),
          actionsIconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          elevation: 0,
          // shadowColor: colorScheme.secondary,
          toolbarTextStyle:
              _textTheme.titleLarge!.copyWith(color: Colors.white),
          titleTextStyle: _textTheme.titleMedium!.copyWith(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),

          // systemOverlayStyle: const SystemUiOverlayStyle(
          //   statusBarColor: Colors.white,
          //   statusBarBrightness: Brightness.light,
          //   statusBarIconBrightness: Brightness.dark,
          // ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: colorScheme.secondary,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: colorScheme.secondary,
            side: BorderSide(color: colorScheme.secondary),
            textStyle: _textTheme.labelLarge!.apply(
              color: colorScheme.onSecondary,
            ),
            shape: shape,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: shape,
            elevation: 0,
            backgroundColor: colorScheme.secondary,
            padding: buttonPadding,
            maximumSize: const Size(200, 50),
            minimumSize: const Size(60, 35),
            side: BorderSide.none,
            textStyle: _textTheme.labelLarge!.copyWith(color: Colors.white),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            shadowColor: colorScheme.shadow,
          ),
        ),
        popupMenuTheme: PopupMenuThemeData(
          elevation: 2,
          color: colorScheme.background,
          enableFeedback: true,
          shape: shape,
          textStyle: _textTheme.titleSmall,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          shape: shape.copyWith(
            side: BorderSide(
              color: colorScheme.background,
              width: 1,
            ),
          ),
          // color: Colors.white,
          elevation: 0,
        ),
        dialogTheme: DialogThemeData(shape: shape, elevation: 2),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: _textTheme,
        useMaterial3: true,
        scrollbarTheme: const ScrollbarThemeData(),
        colorScheme:
            lightColorScheme.copyWith(background: colorScheme.background),
        iconTheme: IconThemeData(color: colorScheme.primary),
        expansionTileTheme: const ExpansionTileThemeData());
  }
}

extension ScreenSize on BuildContext {
  double get screenHeight => MediaQuery.of(this).size.height;

  Size get screenSize => MediaQuery.of(this).size;

  double get screenWidth => MediaQuery.of(this).size.width;

  TextTheme get textTheme => Theme.of(this).textTheme;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}
