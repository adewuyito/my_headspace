import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter/foundation.dart';
import 'package:my_headspace/features/journey/application/usecases/delete_journal.dart';
import 'package:my_headspace/features/journey/application/usecases/get_all_journals.dart';
import 'package:my_headspace/features/journey/application/usecases/get_journal.dart';
import 'package:my_headspace/features/journey/application/usecases/save_journal.dart';
import 'package:my_headspace/features/journey/application/usecases/toggle_journal_favourite.dart';
import 'package:my_headspace/features/journey/domain/entities/journal_entity.dart';
import 'package:my_headspace/service/service_locator.dart';
import 'package:path_provider/path_provider.dart';

import 'journal_state.dart';

class JournalProvider extends ChangeNotifier {
  JournalState _state = const JournalState();
  final SaveJournal _saveJournal;
  final GetJournal _getJournal;
  final DeleteJournal _deleteJournal;
  final GetAllJournals _getAllJournals;
  final ToggleJournalFavourite _toggleJournalFavourite;

  JournalState get state => _state;

  JournalProvider({
    SaveJournal? saveJournal,
    GetJournal? getJournal,
    DeleteJournal? deleteJournal,
    GetAllJournals? getAllJournals,
    ToggleJournalFavourite? toggleJournalFavourite,
  }) : _saveJournal = saveJournal ?? serviceLocator.getIt<SaveJournal>(),
       _getJournal = getJournal ?? serviceLocator.getIt<GetJournal>(),
       _deleteJournal = deleteJournal ?? serviceLocator.getIt<DeleteJournal>(),
       _getAllJournals =
           getAllJournals ?? serviceLocator.getIt<GetAllJournals>(),
       _toggleJournalFavourite =
           toggleJournalFavourite ??
           serviceLocator.getIt<ToggleJournalFavourite>();

  Future<void> _internalGetAllJournals() async {
    try {
      final journals = await _getAllJournals();
      _state = _state.copyWith(journals: journals);
    } catch (e) {
      _state = _state.copyWith(
        errorMessage: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  Future<void> saveJournal(Journal journal) async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    try {
      await _saveJournal(journal);
      await _internalGetAllJournals();
    } catch (e) {
      _state = _state.copyWith(
        errorMessage: 'An unexpected error occurred. Please try again.',
      );
    } finally {
      _state = _state.copyWith(isLoading: false);
    }
    notifyListeners();
  }

  Future<void> getJournal(String id) async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    try {
      final journal = await _getJournal(id);
      // For now, we'll just set loading to false.
      _state = _state.copyWith(isLoading: false);
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred. Please try again.',
      );
    }
    notifyListeners();
  }

  Future<void> deleteJournal(String id) async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    try {
      await _deleteJournal(id);
      await _internalGetAllJournals();
    } catch (e) {
      _state = _state.copyWith(
        errorMessage: 'An unexpected error occurred. Please try again.',
      );
    } finally {
      _state = _state.copyWith(isLoading: false);
    }
    notifyListeners();
  }

  Future<void> getAllJournals() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    await _internalGetAllJournals();

    _state = _state.copyWith(isLoading: false);
    notifyListeners();
  }

  Future<void> toggleFavourite(String id, bool isFavourite) async {
    try {
      await _toggleJournalFavourite(id: id, isFavourite: isFavourite);

      // Update the local state
      final updatedJournals = _state.journals.map((journal) {
        if (journal.id == id) {
          return journal.copyWith(isFavourite: isFavourite);
        }
        return journal;
      }).toList();

      _state = _state.copyWith(journals: updatedJournals);
      notifyListeners();
    } catch (e) {
      // Handle error if needed
      _state = _state.copyWith(
        errorMessage:
            'An unexpected error occurred while updating favourite status. Please try again.',
      );
      notifyListeners();
    }
  }

  // ! Development, Delete database
  Future<void> deleteDatabaseFile() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    if (await file.exists()) {
      await file.delete();
      print('Database deleted');
    }
  }
}
