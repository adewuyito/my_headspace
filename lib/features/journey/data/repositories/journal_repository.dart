import 'package:my_headspace/features/journey/data/datasources/cloud_journal_datasources.dart';
import 'package:my_headspace/features/journey/data/datasources/local_journal_datasources.dart';
import 'package:my_headspace/features/journey/data/model/journal_mapper.dart';
import 'package:my_headspace/features/journey/domain/entities/journal_entity.dart';
import 'package:my_headspace/features/journey/domain/repositories/journal_repository.dart';

class JournalRepositoryImpl implements JournalRepository {
  final LocalJournalDatasource localDS;
  final CloudJournalDatasource cloudDS; // Keep this for future use

  JournalRepositoryImpl(this.localDS, this.cloudDS);

  @override
  Future<void> deleteJournal(String id) {
    return localDS.deleteEntry(id);
  }

  @override
  Future<Journal?> getJournal(String id) async {
    final model = await localDS.getEntry(id);
    if (model == null) {
      return null;
    }
    return JournalMapper.toEntity(model);
  }

  @override
  Future<void> saveJournal(Journal journal) async {
    final model = JournalMapper.fromEntity(journal);
    await localDS.saveEntry(model);
  }

  @override
  Future<List<Journal>> getAllJournals() async {
    final models = await localDS.getAllEntries();
    return models.map((model) => JournalMapper.toEntity(model)).toList();
  }

  @override
  Future<void> toggleFavourite(bool value, String id) {
    return localDS.toggleFavourite(value, id);
  }
}

