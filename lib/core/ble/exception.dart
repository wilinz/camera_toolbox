class HandshakeException implements Exception {
  final String message;

  HandshakeException([this.message = '用户新系统 ID 为空']);

  @override
  String toString() => 'HandshakeException: $message';
}
