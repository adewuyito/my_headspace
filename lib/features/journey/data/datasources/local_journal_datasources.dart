import 'package:my_headspace/features/journey/data/model/journal_model.dart';

abstract interface class LocalJournalDatasource {
  Future<JournalId> saveEntry(JournalModel journal);
  Future<JournalModel?> getEntry(JournalId id);
  Future<void> deleteEntry(JournalId id);
  Future<void> toggleFavourite(bool value, String id);
}

class LocalJournalDatasourceImpl implements LocalJournalDatasource {
  @override
  Future<void> deleteEntry(JournalId id) {
    // TODO: implement deleteEntry
    throw UnimplementedError();
  }

  @override
  Future<JournalModel?> getEntry(JournalId id) {
    // TODO: implement getEntry
    throw UnimplementedError();
  }

  @override
  Future<JournalId> saveEntry(JournalModel journal) {
    // TODO: implement saveEntry
    throw UnimplementedError();
  }
  
  @override
  Future<void> toggleFavourite(bool value, String id) {
    // TODO: implement toggleFavourite
    throw UnimplementedError();
  }
}