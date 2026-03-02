class JournalException implements Exception {
  final String message;
  JournalException(this.message);

  @override
  String toString() => 'JournalException: $message';
}

class ErrorStrings {
  static const unexpectedGeneralError = 'An unexpected error occurred. Please try again.';
  static const unexpectedFavouriteError =
      'An unexpected error occurred while updating favourite status. Please try again.';
}
