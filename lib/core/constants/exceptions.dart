
class JournalException implements Exception {
  final String message;
  JournalException(this.message);

  @override
  String toString() => 'JournalException: $message';
}
