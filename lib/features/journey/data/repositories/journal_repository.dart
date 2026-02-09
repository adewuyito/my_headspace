import 'package:my_headspace/features/journey/data/datasources/cloud_journal_datasources.dart';
import 'package:my_headspace/features/journey/data/datasources/local_journal_datasources.dart';
import 'package:my_headspace/features/journey/data/model/journal_mapper.dart';
import 'package:my_headspace/features/journey/domain/entities/journal_entity.dart';
import 'package:my_headspace/features/journey/domain/repositories/journal_repository.dart';

class JournalRepositoryImpl implements JournalRepository {
  final LocalJournalDatasource localDS;
  final CloudJournalDatasource cloudDS;

  JournalRepositoryImpl(this.localDS, this.cloudDS);

  @override
  Future<void> deleteJournal(String id) {
    return cloudDS.deleteEntry(id);
  }

  @override
  Future<Journal?> getJournal(String id) async {
    final model = await cloudDS.getEntry(id);
    if (model == null) {
      return null;
    }
    return JournalMapper.toEntity(model);
  }

  @override
  Future<void> saveJournal(Journal journal) async {
    final model = JournalMapper.fromEntity(journal);
    await cloudDS.saveEntry(model);
  }

  @override
  Future<List<Journal>> getAllJournals() async {
    final models = await cloudDS.getAllEntries();
    return models.map((model) => JournalMapper.toEntity(model)).toList();
  }
  
  @override
  Future<void> toggleFavourite(bool value, String id) {
    return cloudDS.toggleFavourite(value, id);
  }
}

