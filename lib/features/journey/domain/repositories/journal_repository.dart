import 'package:my_headspace/features/journey/domain/entities/journal_entity.dart';

abstract class JournalRepository {
  Future<void> saveJournal(Journal journal);
  Future<Journal?> getJournal(String id);
  Future<void> deleteJournal(String id);
  Future<List<Journal>> getAllJournals();
  Future<void> toggleFavourite(bool value, String id);
}
