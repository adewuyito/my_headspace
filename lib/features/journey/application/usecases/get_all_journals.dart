import 'package:my_headspace/features/journey/domain/entities/journal_entity.dart';
import 'package:my_headspace/features/journey/domain/repositories/journal_repository.dart';

class GetAllJournals {
  final JournalRepository repository;

  GetAllJournals(this.repository);

  Future<List<Journal>> call() {
    return repository.getAllJournals();
  }
}
