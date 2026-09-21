import 'package:flutter_test/flutter_test.dart';
import 'package:grizzly_hills/core/security/lock_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_biometric_authenticator.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('deshabilitado por defecto y desbloqueado', () async {
    final controller = await LockController.load(
      authenticator: FakeBiometricAuthenticator(),
    );

    expect(controller.isEnabled, isFalse);
    expect(controller.isUnlocked, isTrue);
  });

  test('al pasar a segundo plano queda bloqueado hasta autenticar', () async {
    final controller = await LockController.load(
      authenticator: FakeBiometricAuthenticator(),
    );

    await controller.setEnabled(true);
    controller.lock();

    expect(controller.isEnabled, isTrue);
    expect(controller.isUnlocked, isFalse);

    final success = await controller.authenticate('motivo');

    expect(success, isTrue);
    expect(controller.isUnlocked, isTrue);
  });

  test('lock() no hace nada si el bloqueo está desactivado', () async {
    final controller = await LockController.load(
      authenticator: FakeBiometricAuthenticator(),
    );

    controller.lock();

    expect(controller.isUnlocked, isTrue);
  });

  test('persiste la preferencia entre cargas', () async {
    final first = await LockController.load(
      authenticator: FakeBiometricAuthenticator(),
    );
    await first.setEnabled(true);

    final second = await LockController.load(
      authenticator: FakeBiometricAuthenticator(),
    );

    expect(second.isEnabled, isTrue);
    expect(second.isUnlocked, isFalse);
  });

  test('autenticación fallida mantiene bloqueado', () async {
    final controller = await LockController.load(
      authenticator: FakeBiometricAuthenticator(authenticateResult: false),
    );
    await controller.setEnabled(true);
    controller.lock();

    final success = await controller.authenticate('motivo');

    expect(success, isFalse);
    expect(controller.isUnlocked, isFalse);
  });
}
