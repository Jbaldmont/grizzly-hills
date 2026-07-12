import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

const FlexScheme defaultScheme = FlexScheme.outerSpace;

const List<AppThemeOption> availableThemes = [
  AppThemeOption(scheme: FlexScheme.outerSpace, label: 'Outer Space'),
  AppThemeOption(scheme: FlexScheme.money, label: 'Money'),
  AppThemeOption(scheme: FlexScheme.jungle, label: 'Jungle'),
  AppThemeOption(scheme: FlexScheme.deepBlue, label: 'Deep Blue'),
  AppThemeOption(scheme: FlexScheme.bahamaBlue, label: 'Bahama Blue'),
  AppThemeOption(scheme: FlexScheme.gold, label: 'Gold'),
  AppThemeOption(scheme: FlexScheme.amber, label: 'Amber'),
  AppThemeOption(scheme: FlexScheme.greyLaw, label: 'Grey Law'),
];

class AppThemeOption {
  const AppThemeOption({required this.scheme, required this.label});

  final FlexScheme scheme;
  final String label;

  Color get lightPrimary => FlexColor.schemes[scheme]!.light.primary;

  Color get darkPrimary => FlexColor.schemes[scheme]!.dark.primary;
}

ThemeData buildLightTheme(FlexScheme scheme) =>
    FlexThemeData.light(scheme: scheme);

ThemeData buildDarkTheme(FlexScheme scheme) =>
    FlexThemeData.dark(scheme: scheme);
