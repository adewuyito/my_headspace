import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_headspace/core/constants/exceptions.dart';
import 'package:my_headspace/features/journey/application/providers/journal_provider.dart';
import 'package:my_headspace/features/journey/data/local/database.dart';
import 'package:my_headspace/features/journey/domain/entities/journal_entity.dart';

import 'support/journal_provider_test_support.dart';

void main() {
  late AppDatabase database;
  late JournalProvider provider;

  setUpAll(() {
    registerJournalProviderFallbacks();
  });

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    provider = buildProviderWithInMemoryDb(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('saveJournal creates a new entry and updates provider state', () async {
    const id = 'journal-1';
    final entry = Journal(
      id: id,
      title: 'My title',
      content: 'My content',
      createdAt: DateTime(2026, 2, 23),
    );

    final saved = await provider.saveJournal(entry);

    expect(saved, isTrue);
    expect(provider.state.errorMessage, isNull);
    expect(provider.state.isLoading, isFalse);
    expect(provider.state.journals.length, 1);
    expect(provider.state.journals.first.id, id);
  });

  test('saveJournal edits an existing entry when id already exists', () async {
    const id = 'journal-2';
    final initialEntry = Journal(
      id: id,
      title: 'Old title',
      content: 'Old content',
      createdAt: DateTime(2026, 2, 23),
    );
    await provider.saveJournal(initialEntry);

    final editedEntry = initialEntry.copyWith(
      title: 'Updated title',
      content: 'Updated content',
      isFavourite: true,
    );
    final saved = await provider.saveJournal(editedEntry);

    expect(saved, isTrue);
    expect(provider.state.errorMessage, isNull);
    expect(provider.state.isLoading, isFalse);
    expect(provider.state.journals.length, 1);
    expect(provider.state.journals.first.id, id);
    expect(provider.state.journals.first.title, 'Updated title');
    expect(provider.state.journals.first.content, 'Updated content');
    expect(provider.state.journals.first.isFavourite, isTrue);

    final allRows = await database.select(database.journals).get();
    expect(allRows.length, 1);
    expect(allRows.first.title, 'Updated title');
  });

  test('toggleFavourite updates favourite state in provider and database', () async {
    const id = 'journal-3';
    final entry = Journal(
      id: id,
      title: 'Fav title',
      content: 'Fav content',
      createdAt: DateTime(2026, 2, 23),
    );
    await provider.saveJournal(entry);
    expect(provider.state.journals.first.isFavourite, isFalse);

    await provider.toggleFavourite(id, true);

    expect(provider.state.errorMessage, isNull);
    expect(provider.state.journals.first.id, id);
    expect(provider.state.journals.first.isFavourite, isTrue);

    final dbEntry = await (database.select(database.journals)
          ..where((j) => j.id.equals(id)))
        .getSingle();
    expect(dbEntry.isFavourite, isTrue);
  });

  test('deleteJournal removes an existing entry and updates provider state', () async {
    const id = 'journal-4';
    final entry = Journal(
      id: id,
      title: 'Delete title',
      content: 'Delete content',
      createdAt: DateTime(2026, 2, 23),
    );
    await provider.saveJournal(entry);
    expect(provider.state.journals.length, 1);

    await provider.deleteJournal(id);

    expect(provider.state.errorMessage, isNull);
    expect(provider.state.isLoading, isFalse);
    expect(provider.state.journals, isEmpty);
  });

  test('saveJournal returns false and sets errorMessage when save fails', () async {
    final repository = MockJournalRepository();
    when(
      () => repository.saveJournal(
        any(),
        backupToCloud: any(named: 'backupToCloud'),
      ),
    ).thenThrow(Exception('save failed'));
    final failingProvider = buildProviderFromRepository(repository);
    final journal = Journal(
      id: 'save-fail-1',
      title: 'Title',
      content: 'Content',
      createdAt: DateTime(2026, 2, 23),
    );

    final saved = await failingProvider.saveJournal(journal);

    expect(saved, isFalse);
    expect(failingProvider.state.isLoading, isFalse);
    expect(
      failingProvider.state.errorMessage,
      ErrorStrings.unexpectedGeneralError,
    );
    expect(failingProvider.state.journals, isEmpty);
  });

  test('deleteJournal sets errorMessage when delete fails', () async {
    final journal = Journal(
      id: 'delete-fail-1',
      title: 'Title',
      content: 'Content',
      createdAt: DateTime(2026, 2, 23),
    );
    final repository = MockJournalRepository();
    when(() => repository.getAllJournals()).thenAnswer((_) async => [journal]);
    when(() => repository.deleteJournal('delete-fail-1')).thenThrow(
      Exception('delete failed'),
    );
    final failingProvider = buildProviderFromRepository(repository);
    await failingProvider.getAllJournals();

    await failingProvider.deleteJournal('delete-fail-1');

    expect(failingProvider.state.isLoading, isFalse);
    expect(
      failingProvider.state.errorMessage,
      ErrorStrings.unexpectedGeneralError,
    );
    expect(failingProvider.state.journals.length, 1);
    expect(failingProvider.state.journals.first.id, 'delete-fail-1');
  });

  test('getAllJournals toggles loading and populates journals on success', () async {
    final completer = Completer<List<Journal>>();
    final repository = MockJournalRepository();
    when(() => repository.getAllJournals()).thenAnswer((_) => completer.future);
    final asyncProvider = buildProviderFromRepository(repository);

    final future = asyncProvider.getAllJournals();
    expect(asyncProvider.state.isLoading, isTrue);

    completer.complete([
      Journal(
        id: 'get-all-1',
        title: 'Loaded',
        content: 'Loaded content',
        createdAt: DateTime(2026, 2, 23),
      ),
    ]);
    await future;

    expect(asyncProvider.state.isLoading, isFalse);
    expect(asyncProvider.state.errorMessage, isNull);
    expect(asyncProvider.state.journals.length, 1);
    expect(asyncProvider.state.journals.first.id, 'get-all-1');
  });

  test('getAllJournals sets errorMessage on failure', () async {
    final repository = MockJournalRepository();
    when(() => repository.getAllJournals()).thenThrow(
      Exception('get all failed'),
    );
    final failingProvider = buildProviderFromRepository(repository);

    await failingProvider.getAllJournals();

    expect(failingProvider.state.isLoading, isFalse);
    expect(
      failingProvider.state.errorMessage,
      ErrorStrings.unexpectedGeneralError,
    );
  });

  test('toggleFavourite sets favourite-specific error on failure', () async {
    final journal = Journal(
      id: 'fav-fail-1',
      title: 'Title',
      content: 'Content',
      createdAt: DateTime(2026, 2, 23),
    );
    final repository = MockJournalRepository();
    when(() => repository.getAllJournals()).thenAnswer((_) async => [journal]);
    when(() => repository.toggleFavourite(true, 'fav-fail-1')).thenThrow(
      Exception('toggle failed'),
    );
    final failingProvider = buildProviderFromRepository(repository);
    await failingProvider.getAllJournals();

    await failingProvider.toggleFavourite('fav-fail-1', true);

    expect(
      failingProvider.state.errorMessage,
      ErrorStrings.unexpectedFavouriteError,
    );
    expect(failingProvider.state.journals.first.isFavourite, isFalse);
  });

  test('syncPendingData calls repository sync and refreshes journals', () async {
    var synced = false;
    final repository = MockJournalRepository();
    when(() => repository.syncPendingData()).thenAnswer((_) async {
      synced = true;
    });
    when(() => repository.getAllJournals()).thenAnswer((_) async {
      return [
        Journal(
          id: synced ? 'synced-1' : 'pending-1',
          title: synced ? 'Synced' : 'Pending',
          content: 'Content',
          createdAt: DateTime(2026, 2, 23),
        ),
      ];
    });
    final syncProvider = buildProviderFromRepository(repository);
    await syncProvider.getAllJournals();
    expect(syncProvider.state.journals.first.id, 'pending-1');

    await syncProvider.syncPendingData();

    verify(() => repository.syncPendingData()).called(1);
    expect(syncProvider.state.journals.first.id, 'synced-1');
  });

  test('startConnectivitySyncListener delegates to repository', () {
    final repository = MockJournalRepository();
    final syncProvider = buildProviderFromRepository(repository);

    syncProvider.startConnectivitySyncListener();

    verify(() => repository.startConnectivityListener()).called(1);
  });

  test('getJournal toggles loading and handles error', () async {
    final repository = MockJournalRepository();
    when(() => repository.getJournal('get-journal-1')).thenAnswer((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 10));
      throw Exception('get journal failed');
    });
    final localProvider = buildProviderFromRepository(repository);

    final future = localProvider.getJournal('get-journal-1');
    expect(localProvider.state.isLoading, isTrue);
    await future;

    expect(localProvider.state.isLoading, isFalse);
    expect(
      localProvider.state.errorMessage,
      ErrorStrings.unexpectedGeneralError,
    );
  });
}
