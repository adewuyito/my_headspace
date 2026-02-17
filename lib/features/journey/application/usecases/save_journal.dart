import 'package:my_headspace/features/journey/domain/entities/journal_entity.dart';
import 'package:my_headspace/features/journey/domain/repositories/journal_repository.dart';

class SaveJournal {
  final JournalRepository repository;

  SaveJournal(this.repository);

  Future<void> call(Journal journal, {bool backupToCloud = false}) {
    return repository.saveJournal(journal, backupToCloud: backupToCloud);
  }
}
