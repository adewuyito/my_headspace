import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:my_headspace/features/journey/data/datasources/cloud_journal_datasources.dart';
import 'package:my_headspace/features/journey/data/datasources/local_journal_datasources.dart';
import 'package:my_headspace/features/journey/data/model/journal_mapper.dart';
import 'package:my_headspace/features/journey/domain/entities/journal_entity.dart';
import 'package:my_headspace/features/journey/domain/repositories/journal_repository.dart';

class JournalRepositoryImpl implements JournalRepository {
  final LocalJournalDatasource localDS;
  final CloudJournalDatasource cloudDS;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

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
  Future<void> saveJournal(
    Journal journal, {
    bool backupToCloud = false,
  }) async {
    final localModel = JournalMapper.fromEntity(
      journal.copyWith(isBackedUp: false),
    );
    await localDS.saveEntry(localModel);

    if (backupToCloud) {
      final cloudModel = JournalMapper.fromEntity(
        journal.copyWith(isBackedUp: true),
      );
      try {
        await cloudDS.saveEntry(cloudModel);
        await localDS.saveEntry(cloudModel);
      } catch (_) {
        // Preserve local-first behavior: note remains saved locally even if backup fails.
      }
    }
  }

  @override
  Future<List<Journal>> getAllJournals() async {
    final models = await localDS.getAllEntries();
    return models.map((model) => JournalMapper.toEntity(model)).toList();
  }

  @override
  Future<void> toggleFavourite(bool value, String id) async {
    await localDS.toggleFavourite(value, id);

    final journal = await localDS.getEntry(id);
    if (journal == null || !journal.isBackedUp) {
      return;
    }
  }

  @override
  Future<void> syncPendingData() async {
    final connectivity = await Connectivity().checkConnectivity();
    final hasConnection = connectivity.any(
      (result) => result != ConnectivityResult.none,
    );
    if (!hasConnection) return;

    final unsyncedNotes = await localDS.getUnsyncedEntry();
    if (unsyncedNotes.isEmpty) return;

    final uploadResult = await cloudDS.syncAllEntries(unsyncedNotes);

    if (uploadResult) {
      for (final note in unsyncedNotes) {
        await localDS.markAsBackedUp(note.id!);
      }
    }
  }

  @override
  void startConnectivityListener() {
    if (_connectivitySubscription != null) return;

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (result) {
        final hasConnection = result.any((r) => r != ConnectivityResult.none);
        if (hasConnection) {
          syncPendingData();
        }
      },
      onError: (_) {
        // Ignore connectivity stream plugin errors during startup/reload.
      },
    );
  }

  @override
  void stopConnectivityListener() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }
}
