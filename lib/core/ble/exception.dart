class HandshakeException implements Exception {
  final String message;

  HandshakeException([this.message = '']);

  @override
  String toString() => 'HandshakeException: $message';
}
