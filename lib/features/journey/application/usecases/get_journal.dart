import 'package:my_headspace/features/journey/domain/entities/journal_entity.dart';
import 'package:my_headspace/features/journey/domain/repositories/journal_repository.dart';

class GetJournal {
  final JournalRepository repository;

  GetJournal(this.repository);

  Future<Journal?> call(String id) {
    return repository.getJournal(id);
  }
}
