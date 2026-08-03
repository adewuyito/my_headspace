import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:my_headspace/features/journey/domain/repositories/journal_repository.dart';

class SyncService {
  final JournalRepository _repository;
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isSyncing = false;

  SyncService(this._repository, {Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  bool get isSyncing => _isSyncing;

  /// Starts the connectivity listener and performs initial sync.
  void initialize() {
    _startConnectivityListener();
    triggerSync();
  }

  /// Triggers a non-blocking background sync of all unsynced journals.
  void triggerSync() {
    unawaited(_syncPendingData());
  }

  bool _syncRequested = false;

  Future<void> _syncPendingData() async {
    if (_isSyncing) {
      _syncRequested = true;
      debugPrint('[SyncService] Sync already in progress, queued request...');
      return;
    }
    _isSyncing = true;

    try {
      do {
        _syncRequested = false;
        debugPrint('[SyncService] Starting background sync...');
        await _repository.syncPendingData();
        debugPrint('[SyncService] Background sync completed successfully.');
      } while (_syncRequested);
    } catch (e) {
      debugPrint('[SyncService] Background sync failed: $e');
    } finally {
      _isSyncing = false;
    }
  }

  void _startConnectivityListener() {
    if (_connectivitySubscription != null) return;

    debugPrint('[SyncService] Starting connectivity listener...');
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (result) {
        final hasConnection = result.any((r) => r != ConnectivityResult.none);
        debugPrint('[SyncService] Connectivity changed: $result (hasConnection: $hasConnection)');
        if (hasConnection) {
          triggerSync();
        }
      },
      onError: (error) {
        debugPrint('[SyncService] Connectivity listener error: $error');
      },
    );
  }

  /// Clean up subscriptions.
  void dispose() {
    debugPrint('[SyncService] Disposing sync listener...');
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }
}
