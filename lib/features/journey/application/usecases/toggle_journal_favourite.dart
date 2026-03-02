import 'package:my_headspace/features/journey/domain/repositories/journal_repository.dart';

class ToggleJournalFavourite {
  final JournalRepository repository;

  ToggleJournalFavourite(this.repository);

  Future<void> call({required String id, required bool isFavourite}) {
    return repository.toggleFavourite(isFavourite, id);
  }
}
