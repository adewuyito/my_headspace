import 'package:my_headspace/features/journey/domain/entities/journal_entity.dart';
import 'package:my_headspace/features/journey/domain/repositories/journal_repository.dart';

class MakeFavourite {
  final JournalRepository repository;

  MakeFavourite(this.repository);

  Future<void> call(Journal journal) {
    return repository.saveJournal(journal, backupToCloud: false);
  }
}
