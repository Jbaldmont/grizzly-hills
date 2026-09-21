abstract interface class BiometricAuthenticator {
  Future<bool> isSupported();

  Future<bool> authenticate(String reason);
}
