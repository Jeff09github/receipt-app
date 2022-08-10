// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:material_color_utilities/material_color_utilities.dart';

// class ThemeProvider {
//   const ThemeProvider({
//     required this.settings,
//     required this.colorScheme,
//   });

//   final ThemeSettings settings;
//   final ColorScheme? colorScheme;

//   Color custom(CustomColor custom) {
//     if (custom.blend) {
//       return blend(custom.color);
//     } else {
//       return custom.color;
//     }
//   }

//   Color blend(Color targetColor) {
//     return Color(
//         Blend.harmonize(targetColor.value, settings.sourceColor.value));
//   }

//   Color source(Color? target) {
//     Color source = settings.sourceColor;
//     if (target != null) {
//       source = blend(target);
//     }
//     return source;
//   }

//   ColorScheme colors(Brightness brightness, Color? targetColor) {
//     return ColorScheme.fromSeed(
//       seedColor: colorScheme?.primary ?? source(targetColor),
//       brightness: brightness,
//     );
//   }

//   AppBarTheme appBarTheme(ColorScheme colors) {
//     return AppBarTheme(
//       elevation: 0,
//       backgroundColor: colors.surface,
//       foregroundColor: colors.onSurface,
//     );
//   }

//   ThemeData appThemeData([Color? targetColor]) {
//     final colorScheme = colors(Brightness.light, targetColor);
//     return ThemeData.light().copyWith(
//       colorScheme: colorScheme,
//       appBarTheme: appBarTheme(colorScheme),
//       scaffoldBackgroundColor: colorScheme.background,
//       useMaterial3: true,
//     );
//   }

//   ThemeMode themeMode() {
//     return settings.themeMode;
//   }

//   ThemeData theme(BuildContext context, [Color? targetColor]) {
//     return appThemeData(targetColor);
//   }
// }

// class ThemeSettings {
//   ThemeSettings({
//     required this.sourceColor,
//     required this.themeMode,
//   });

//   final Color sourceColor;
//   final ThemeMode themeMode;
// }

// Color randomColor() {
//   return Color(Random().nextInt(0xFFFFFFFF));
// }

// // Custom Colors
// const linkColor = CustomColor(
//   name: 'Link Color',
//   color: Color(0xFF00B0FF),
// );

// class CustomColor {
//   const CustomColor({
//     required this.name,
//     required this.color,
//     this.blend = true,
//   });

//   final String name;
//   final Color color;
//   final bool blend;

//   Color value(ThemeProvider provider) {
//     return provider.custom(this);
//   }
// }
