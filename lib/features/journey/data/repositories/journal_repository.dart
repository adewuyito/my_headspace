import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:my_headspace/features/journey/data/datasources/cloud_journal_datasources.dart';
import 'package:my_headspace/features/journey/data/datasources/local_journal_datasources.dart';
import 'package:my_headspace/features/journey/data/model/journal_mapper.dart';
import 'package:my_headspace/features/journey/data/model/journal_model.dart';
import 'package:my_headspace/features/journey/domain/entities/journal_entity.dart';
import 'package:my_headspace/features/journey/domain/repositories/journal_repository.dart';

class JournalRepositoryImpl implements JournalRepository {
  final LocalJournalDatasource localDS;
  final CloudJournalDatasource cloudDS;

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
    bool backupToCloud = false, // Ignored: Cloud sync is now handled asynchronously by SyncService
  }) async {
    final localModel = JournalMapper.fromEntity(
      journal.copyWith(isBackedUp: false),
    );
    await localDS.saveEntry(localModel);
  }

  @override
  Future<List<Journal>> getAllJournals() async {
    final models = await localDS.getAllEntries();
    return models.map((model) => JournalMapper.toEntity(model)).toList();
  }

  @override
  Future<void> toggleFavourite(bool value, String id) async {
    await localDS.toggleFavourite(value, id);
    // Cloud sync logic is now completely handled by SyncService picking up the job
  }

  @override
  Future<void> syncPendingData() async {
    final connectivity = await Connectivity().checkConnectivity();
    final hasConnection = connectivity.any(
      (result) => result != ConnectivityResult.none,
    );
    if (!hasConnection) return;

    final pendingJobs = await localDS.getPendingSyncJobs();
    if (pendingJobs.isEmpty) return;

    final saveJobs = <dynamic>[]; // Use dynamic to avoid import issues if SyncJob isn't exported properly, but it should be available. Let's use final job.
    final deleteJobs = <dynamic>[];

    for (final job in pendingJobs) {
      if (job.operation == 'DELETE') {
        deleteJobs.add(job);
      } else if (job.operation == 'SAVE') {
        saveJobs.add(job);
      }
    }

    // Process deletes
    for (final job in deleteJobs) {
      try {
        await cloudDS.deleteEntry(job.journalId);
        await localDS.removeSyncJob(job.id);
      } catch (_) {}
    }

    // Process saves
    if (saveJobs.isNotEmpty) {
      final journalsToSync = <JournalModel>[];
      final processedJobs = <dynamic>[];

      for (final job in saveJobs) {
        final localEntry = await localDS.getEntry(job.journalId);
        if (localEntry != null) {
          journalsToSync.add(localEntry);
          processedJobs.add(job);
        } else {
          // Entry deleted locally before sync could run; safely discard job
          await localDS.removeSyncJob(job.id);
        }
      }

      if (journalsToSync.isNotEmpty) {
        // Use a map to ensure we only send unique journals if there are duplicate jobs for the same journal
        final uniqueJournals = List<JournalModel>.from(
          { for (var note in journalsToSync) note.id! : note }.values
        );
        
        final uploadResult = await cloudDS.syncAllEntries(uniqueJournals);

        if (uploadResult) {
          await Future.wait([
            ...uniqueJournals.map((note) => localDS.markAsBackedUp(note.id!)),
            ...processedJobs.map((job) => localDS.removeSyncJob(job.id)),
          ]);
        }
      }
    }
  }

  @override
  void startConnectivityListener() {
    // Stub implementation: Logic moved to dedicated SyncService
  }

  @override
  void stopConnectivityListener() {
    // Stub implementation: Logic moved to dedicated SyncService
  }
}
