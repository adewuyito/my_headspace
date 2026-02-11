import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:my_headspace/features/journey/domain/repositories/journal_repository.dart'
    as domain;
import 'package:my_headspace/routes/app_route_guard.dart';

class ServiceLocator {
  final _getit = GetIt.instance;

  GetIt get getIt => _getit;

  void configure() {
    // _getit.registerSingleton<My_Provider>(My_Provider());

    _getit.registerLazySingleton<CreateAccountProvider>(
        () => CreateAccountProvider());

    _getit.registerSingleton<AuthGuard>(AuthGuard());

    // ~ Ripositories
    _getit.registerLazySingleton<AuthRepository>(() => AuthRepository());

    _getit.registerSingleton<AuthProvider>(AuthProvider());

    _getit.registerLazySingleton<PersonalisationProvider>(
      () => PersonalisationProvider(),
    );

    // Journal Feature
    _getit.registerLazySingleton<AppDatabase>(() => AppDatabase());
    _getit.registerLazySingleton<domain.JournalRepository>(() =>
        JournalRepositoryImpl(
            serviceLocator.getIt(), serviceLocator.getIt()));
    _getit.registerLazySingleton(() => SaveJournal(serviceLocator.getIt()));
    _getit.registerLazySingleton(() => GetJournal(serviceLocator.getIt()));
    _getit.registerLazySingleton(() => DeleteJournal(serviceLocator.getIt()));
    _getit.registerLazySingleton(() => GetAllJournals(serviceLocator.getIt()));
    _getit.registerLazySingleton(
        () => ToggleJournalFavourite(serviceLocator.getIt()));
    _getit.registerLazySingleton(() => JournalProvider());
    _getit.registerLazySingleton<CloudJournalDatasource>(
        () => CloudJournalDatasourceImpl(FirebaseFirestore.instance));
    _getit.registerLazySingleton<LocalJournalDatasource>(
        () => LocalJournalDatasourceImpl(serviceLocator.getIt()));
  }
}

final serviceLocator = ServiceLocator();

