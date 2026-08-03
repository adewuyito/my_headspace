import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_headspace/features/journey/application/services/sync_service.dart';
import 'package:my_headspace/features/journey/domain/repositories/journal_repository.dart';

class MockJournalRepository extends Mock implements JournalRepository {}
class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late MockJournalRepository mockRepository;
  late MockConnectivity mockConnectivity;
  late SyncService syncService;
  late StreamController<List<ConnectivityResult>> connectivityStreamController;

  setUp(() {
    mockRepository = MockJournalRepository();
    mockConnectivity = MockConnectivity();
    connectivityStreamController = StreamController<List<ConnectivityResult>>.broadcast();

    when(() => mockConnectivity.onConnectivityChanged)
        .thenAnswer((_) => connectivityStreamController.stream);

    syncService = SyncService(mockRepository, connectivity: mockConnectivity);
  });

  tearDown(() {
    connectivityStreamController.close();
    syncService.dispose();
  });

  test('initialize starts connectivity listener and triggers initial sync', () async {
    when(() => mockRepository.syncPendingData()).thenAnswer((_) async {});

    syncService.initialize();

    // Verify initial sync was triggered
    verify(() => mockRepository.syncPendingData()).called(1);
    
    // Wait a brief moment for the unawaited Future to finish execution
    await Future<void>.delayed(Duration.zero);
    
    expect(syncService.isSyncing, isFalse);
  });

  test('triggerSync triggers non-blocking background sync', () async {
    final completer = Completer<void>();
    when(() => mockRepository.syncPendingData()).thenAnswer((_) => completer.future);

    syncService.triggerSync();

    expect(syncService.isSyncing, isTrue);

    completer.complete();
    await Future<void>.delayed(Duration.zero); // let microtasks run

    expect(syncService.isSyncing, isFalse);
  });

  test('subsequent triggerSync calls are queued and run sequentially', () async {
    final completer1 = Completer<void>();
    final completer2 = Completer<void>();
    var syncCount = 0;

    when(() => mockRepository.syncPendingData()).thenAnswer((_) async {
      syncCount++;
      if (syncCount == 1) {
        await completer1.future;
      } else if (syncCount == 2) {
        await completer2.future;
      }
    });

    // Trigger first sync
    syncService.triggerSync();
    expect(syncService.isSyncing, isTrue);

    // Trigger second sync while first is in progress
    syncService.triggerSync();
    expect(syncService.isSyncing, isTrue);

    // Complete first sync
    completer1.complete();
    await Future<void>.delayed(Duration.zero); // allow first sync to complete and start second

    // Since first sync is complete, second one should be running
    expect(syncCount, 2);
    expect(syncService.isSyncing, isTrue);

    // Complete second sync
    completer2.complete();
    await Future<void>.delayed(Duration.zero);

    expect(syncService.isSyncing, isFalse);
    verify(() => mockRepository.syncPendingData()).called(2);
  });

  test('sync exceptions are caught and isSyncing is set to false', () async {
    when(() => mockRepository.syncPendingData()).thenThrow(Exception('Sync failed'));

    syncService.triggerSync();

    // Wait a brief moment for the unawaited Future to finish execution
    await Future<void>.delayed(Duration.zero);

    expect(syncService.isSyncing, isFalse);
    verify(() => mockRepository.syncPendingData()).called(1);
  });

  test('connectivity transitions from offline to online triggers sync', () async {
    when(() => mockRepository.syncPendingData()).thenAnswer((_) async {});

    syncService.initialize();
    
    // Clear initial sync verification call
    clearInteractions(mockRepository);

    // Emit offline connection -> should NOT trigger sync
    connectivityStreamController.add([ConnectivityResult.none]);
    await Future<void>.delayed(Duration.zero);
    verifyNever(() => mockRepository.syncPendingData());

    // Emit online connection -> should trigger sync
    connectivityStreamController.add([ConnectivityResult.wifi]);
    await Future<void>.delayed(Duration.zero);
    verify(() => mockRepository.syncPendingData()).called(1);
  });
}
