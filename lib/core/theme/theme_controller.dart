import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_themes.dart';

class ThemeController extends ChangeNotifier {
  ThemeController._(this._preferences, this._scheme, this._mode);

  static const String _schemeKey = 'theme.scheme';
  static const String _modeKey = 'theme.mode';

  final SharedPreferences _preferences;
  FlexScheme _scheme;
  ThemeMode _mode;

  FlexScheme get scheme => _scheme;

  ThemeMode get mode => _mode;

  static Future<ThemeController> load() async {
    final preferences = await SharedPreferences.getInstance();
    final scheme =
        FlexScheme.values.asNameMap()[preferences.getString(_schemeKey)] ??
        defaultScheme;
    final mode =
        ThemeMode.values.asNameMap()[preferences.getString(_modeKey)] ??
        ThemeMode.system;
    return ThemeController._(preferences, scheme, mode);
  }

  Future<void> setScheme(FlexScheme value) async {
    if (value == _scheme) {
      return;
    }
    _scheme = value;
    notifyListeners();
    await _preferences.setString(_schemeKey, value.name);
  }

  Future<void> setMode(ThemeMode value) async {
    if (value == _mode) {
      return;
    }
    _mode = value;
    notifyListeners();
    await _preferences.setString(_modeKey, value.name);
  }
}
