import 'package:mocktail/mocktail.dart';
import 'package:my_headspace/features/journey/application/providers/journal_provider.dart';
import 'package:my_headspace/features/journey/application/usecases/delete_journal.dart';
import 'package:my_headspace/features/journey/application/usecases/get_all_journals.dart';
import 'package:my_headspace/features/journey/application/usecases/get_journal.dart';
import 'package:my_headspace/features/journey/application/usecases/save_journal.dart';
import 'package:my_headspace/features/journey/application/usecases/toggle_journal_favourite.dart';
import 'package:my_headspace/features/journey/data/datasources/cloud_journal_datasources.dart';
import 'package:my_headspace/features/journey/data/datasources/local_journal_datasources.dart';
import 'package:my_headspace/features/journey/data/local/database.dart';
import 'package:my_headspace/features/journey/data/model/journal_model.dart';
import 'package:my_headspace/features/journey/data/repositories/journal_repository.dart';
import 'package:my_headspace/features/journey/domain/entities/journal_entity.dart';
import 'package:my_headspace/features/journey/domain/repositories/journal_repository.dart'
    as domain;

class FakeCloudJournalDatasource implements CloudJournalDatasource {
  @override
  Future<void> deleteEntry(JournalId id) async {}

  @override
  Future<List<JournalModel>> getAllEntries() async => [];

  @override
  Future<JournalModel?> getEntry(JournalId id) async => null;

  @override
  Future<JournalId> saveEntry(JournalModel journal) async => journal.id ?? 'id';

  @override
  Future<bool> syncAllEntries(List<JournalModel> journals) async => true;

  @override
  Future<void> toggleFavourite(bool value, JournalId id) async {}
}

class FakeJournal extends Fake implements Journal {}

class MockJournalRepository extends Mock implements domain.JournalRepository {}

void registerJournalProviderFallbacks() {
  registerFallbackValue(FakeJournal());
}

JournalProvider buildProviderFromRepository(domain.JournalRepository repository) {
  return JournalProvider(
    deleteJournal: DeleteJournal(repository),
    saveJournal: SaveJournal(repository),
    getJournal: GetJournal(repository),
    getAllJournals: GetAllJournals(repository),
    toggleJournalFavourite: ToggleJournalFavourite(repository),
    journalRepository: repository,
  );
}

JournalProvider buildProviderWithInMemoryDb(AppDatabase database) {
  final localDatasource = LocalJournalDatasourceImpl(database);
  final cloudDatasource = FakeCloudJournalDatasource();
  final repository = JournalRepositoryImpl(localDatasource, cloudDatasource);
  return buildProviderFromRepository(repository);
}
