import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_headspace/features/journey/domain/entities/journal_entity.dart';

part 'journal_state.freezed.dart';

@freezed
abstract class JournalState with _$JournalState {
  const JournalState._();

  const factory JournalState({
    @Default(false) bool isLoading,
    @Default([]) List<Journal> journals,
    @Default('') String searchQuery,
    Journal? currentJournal,
    String? errorMessage,
  }) = _JournalState;

  List<Journal> get filteredJournals {
    if (searchQuery.trim().isEmpty) return journals;
    final query = searchQuery.trim().toLowerCase();
    return journals.where((j) {
      return j.title.toLowerCase().contains(query) || j.content.toLowerCase().contains(query);
    }).toList();
  }
}
