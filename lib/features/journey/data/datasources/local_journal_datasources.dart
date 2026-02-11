import 'package:drift/drift.dart';
import 'package:my_headspace/features/journey/data/local/database.dart';
import 'package:my_headspace/features/journey/data/local/journal_drift_mapper.dart';
import 'package:my_headspace/features/journey/data/model/journal_model.dart';

abstract interface class LocalJournalDatasource {
  Future<JournalId> saveEntry(JournalModel journal);
  Future<JournalModel?> getEntry(JournalId id);
  Future<void> deleteEntry(JournalId id);
  Future<void> toggleFavourite(bool value, String id);
  Future<List<JournalModel>> getAllEntries();
}

class LocalJournalDatasourceImpl implements LocalJournalDatasource {
  final AppDatabase database;

  LocalJournalDatasourceImpl(this.database);

  @override
  Future<void> deleteEntry(JournalId id) {
    return (database.delete(database.journals)..where((j) => j.id.equals(id)))
        .go();
  }

  @override
  Future<JournalModel?> getEntry(JournalId id) async {
    final journal = await (database.select(database.journals)
          ..where((j) => j.id.equals(id)))
        .getSingleOrNull();
    if (journal != null) {
      return JournalDriftMapper.fromDrift(journal);
    }
    return null;
  }

  @override
  Future<JournalId> saveEntry(JournalModel journal) async {
    final journalEntry = JournalDriftMapper.toDrift(journal);
    await database.into(database.journals).insertOnConflictUpdate(journalEntry); // TODO: the methode call has typo error, fix for open-source
    return journal.id!;
  }

  @override
  Future<void> toggleFavourite(bool value, String id) {
    return (database.update(database.journals)..where((j) => j.id.equals(id)))
        .write(JournalsCompanion(isFavourite: Value(value)));
  }

  @override
  Future<List<JournalModel>> getAllEntries() async {
    final journals = await database.select(database.journals).get();
    return journals.map(JournalDriftMapper.fromDrift).toList();
  }
}