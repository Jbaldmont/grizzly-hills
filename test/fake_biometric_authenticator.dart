import 'package:grizzly_hills/core/security/biometric_authenticator.dart';

class FakeBiometricAuthenticator implements BiometricAuthenticator {
  FakeBiometricAuthenticator({
    this.supported = true,
    this.authenticateResult = true,
  });

  bool supported;
  bool authenticateResult;
  int authenticateCallCount = 0;

  @override
  Future<bool> isSupported() async => supported;

  @override
  Future<bool> authenticate(String reason) async {
    authenticateCallCount++;
    return authenticateResult;
  }
}
