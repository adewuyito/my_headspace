import 'package:drift/drift.dart';
import 'package:my_headspace/features/journey/data/local/database.dart';
import 'package:my_headspace/features/journey/data/local/journal_drift_mapper.dart';
import 'package:my_headspace/features/journey/data/model/journal_model.dart';
import 'package:uuid/uuid.dart';

abstract interface class LocalJournalDatasource {
  Future<JournalId> saveEntry(JournalModel journal);
  Future<JournalModel?> getEntry(JournalId id);
  Future<void> deleteEntry(JournalId id);
  Future<void> toggleFavourite(bool value, String id);
  Future<void> markAsBackedUp(JournalId id);
  Future<List<JournalModel>> getAllEntries();
  Future<List<JournalModel>> getUnsyncedEntry();
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
    final id = journal.id ?? const Uuid().v4();
    final journalEntry = JournalDriftMapper.toDrift(
      JournalModel(
        id: id,
        title: journal.title,
        content: journal.content,
        createdAt: journal.createdAt,
        isFavourite: journal.isFavourite,
        color: journal.color,
        isBackedUp: journal.isBackedUp,
      ),
    );
    await database.into(database.journals).insertOnConflictUpdate(journalEntry);
    return id;
  }

  @override
  Future<void> toggleFavourite(bool value, String id) {
    return (database.update(database.journals)..where((j) => j.id.equals(id)))
        .write(JournalsCompanion(isFavourite: Value(value)));
  }

  @override
  Future<void> markAsBackedUp(JournalId id) {
    return (database.update(database.journals)..where((j) => j.id.equals(id)))
        .write(const JournalsCompanion(isBackedUp: Value(true)));
  }

  @override
  Future<List<JournalModel>> getAllEntries() async {
    final journals = await (database.select(database.journals)
          ..orderBy([(j) => OrderingTerm.desc(j.createdAt)]))
        .get();
    return journals.map(JournalDriftMapper.fromDrift).toList();
  }

  @override
  Future<List<JournalModel>> getUnsyncedEntry() async {
    final journals = await (database.select(database.journals)
          ..where((j) => j.isBackedUp.equals(false)))
        .get();
    return journals.map(JournalDriftMapper.fromDrift).toList();
  }
}
