import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'biometric_authenticator.dart';
import 'local_auth_authenticator.dart';

class LockController extends ChangeNotifier {
  LockController._(this._preferences, this._authenticator, bool enabled)
    : _enabled = enabled,
      _unlocked = !enabled;

  static const String _enabledKey = 'security.biometricLockEnabled';

  final SharedPreferences _preferences;
  final BiometricAuthenticator _authenticator;
  bool _enabled;
  bool _unlocked;

  bool get isEnabled => _enabled;

  bool get isUnlocked => _unlocked;

  static Future<LockController> load({
    BiometricAuthenticator? authenticator,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    final enabled = preferences.getBool(_enabledKey) ?? false;
    return LockController._(
      preferences,
      authenticator ?? LocalAuthBiometricAuthenticator(),
      enabled,
    );
  }

  Future<bool> checkAvailability() => _authenticator.isSupported();

  Future<bool> authenticate(String reason) async {
    final success = await _authenticator.authenticate(reason);
    if (success) {
      _unlocked = true;
      notifyListeners();
    }
    return success;
  }

  Future<void> setEnabled(bool value) async {
    if (value == _enabled) {
      return;
    }
    _enabled = value;
    if (!value) {
      _unlocked = true;
    }
    notifyListeners();
    await _preferences.setBool(_enabledKey, value);
  }

  void lock() {
    if (_enabled && _unlocked) {
      _unlocked = false;
      notifyListeners();
    }
  }
}
