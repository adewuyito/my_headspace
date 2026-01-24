import 'package:my_headspace/features/journey/data/datasources/cloud_journal_datasources.dart';
import 'package:my_headspace/features/journey/data/datasources/local_journal_datasources.dart';
import 'package:my_headspace/features/journey/data/model/journal_model.dart';

abstract interface class JournalRepository {
  /// Save a new journal or update an existing on if journal does not exsist;
  Future<JournalId> saveEntry(JournalModel journal);

  /// Get an existing journal;
  Future<JournalModel?> getEntry(JournalId id);

  /// Delete an existing journal
  Future<JournalId> deleteEntry(JournalId id);
}

class JournalRepositoryImpl implements JournalRepository {
  final LocalJournalDatasource localDS;
  final CloudJournalDatasource cloudDS;

  JournalRepositoryImpl(this.localDS, this.cloudDS);

  @override
  Future<JournalId> deleteEntry(JournalId id) {
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
}

