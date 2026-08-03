import 'package:cloud_firestore/cloud_firestore.dart' as firebase_firestore;
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:get_it/get_it.dart';
import 'package:my_headspace/features/auth/application/providers/auth_provider.dart';
import 'package:my_headspace/features/auth/application/providers/create_account_provider.dart';
import 'package:my_headspace/features/auth/domain/repository/auth_repository.dart';
import 'package:my_headspace/features/home/application/providers/personalisation_provider.dart';
import 'package:my_headspace/features/journey/application/providers/journal_provider.dart';
import 'package:my_headspace/features/journey/application/usecases/delete_journal.dart';
import 'package:my_headspace/features/journey/application/usecases/get_all_journals.dart';
import 'package:my_headspace/features/journey/application/usecases/get_journal.dart';
import 'package:my_headspace/features/journey/application/usecases/save_journal.dart';
import 'package:my_headspace/features/journey/application/usecases/toggle_journal_favourite.dart';
import 'package:my_headspace/features/journey/data/datasources/cloud_journal_datasources.dart';

import 'package:my_headspace/features/journey/data/datasources/local_journal_datasources.dart';
import 'package:my_headspace/features/journey/data/repositories/journal_repository.dart';
import 'package:my_headspace/features/journey/data/local/database.dart';
import 'package:my_headspace/features/journey/application/services/sync_service.dart';
import 'package:my_headspace/features/journey/domain/repositories/journal_repository.dart'
    as domain;
import 'package:my_headspace/routes/app_route_guard.dart';

class ServiceLocator {
  final _getit = GetIt.instance;

  GetIt get getIt => _getit;

  void configure() {
    // _getit.registerSingleton<My_Provider>(My_Provider());

    // ~ Firebase singlton instances
    _getit.registerLazySingleton<firebase_firestore.FirebaseFirestore>(
      () => firebase_firestore.FirebaseFirestore.instance,
    );
    _getit.registerLazySingleton<firebase_auth.FirebaseAuth>(
      () => firebase_auth.FirebaseAuth.instance,
    );

    // ~ Auth Ripositories
    _getit.registerSingleton<AuthGuard>(AuthGuard());

    _getit.registerLazySingleton<CreateAccountProvider>(
      () => CreateAccountProvider(),
    );

    _getit.registerLazySingleton<AuthRepository>(() => AuthRepository());

    _getit.registerLazySingleton<AuthProvider>(
      () => AuthProvider(
        authRepo: _getit<AuthRepository>(),
        userDataProvider: _getit<CreateAccountProvider>(),
        firebaseAuth: _getit<firebase_auth.FirebaseAuth>(),
      ),
    );

    // ~ Other providers
    _getit.registerLazySingleton<PersonalisationProvider>(
      () => PersonalisationProvider(),
    );

    // ~ Journal Feature
    _getit.registerLazySingleton<AppDatabase>(() => AppDatabase());

    _getit.registerLazySingleton(() => JournalProvider());

    _getit.registerLazySingleton<domain.JournalRepository>(
      () => JournalRepositoryImpl(
        _getit<LocalJournalDatasource>(),
        _getit<CloudJournalDatasource>(),
      ),
    );

    _getit.registerLazySingleton<SyncService>(
      () => SyncService(_getit<domain.JournalRepository>()),
    );

    // ~ Domain Usecases
    _getit.registerLazySingleton(
      () => SaveJournal(_getit<domain.JournalRepository>()),
    );
    _getit.registerLazySingleton(
      () => GetJournal(_getit<domain.JournalRepository>()),
    );
    _getit.registerLazySingleton(
      () => DeleteJournal(_getit<domain.JournalRepository>()),
    );
    _getit.registerLazySingleton(
      () => GetAllJournals(_getit<domain.JournalRepository>()),
    );
    _getit.registerLazySingleton(
      () => ToggleJournalFavourite(_getit<domain.JournalRepository>()),
    );

    // ~ Database Repositories
    _getit.registerLazySingleton<CloudJournalDatasource>(
      () => CloudJournalDatasourceImpl(
        _getit<firebase_firestore.FirebaseFirestore>(),
        _getit<firebase_auth.FirebaseAuth>(),
      ),
    );
    _getit.registerLazySingleton<LocalJournalDatasource>(
      () => LocalJournalDatasourceImpl(_getit<AppDatabase>()),
    );
  }
}

final serviceLocator = ServiceLocator();
