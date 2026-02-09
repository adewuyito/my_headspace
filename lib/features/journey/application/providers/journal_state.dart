import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_headspace/features/journey/domain/entities/journal_entity.dart';

part 'journal_state.freezed.dart';

@freezed
abstract class JournalState with _$JournalState {
  const factory JournalState({
    @Default(false) bool isLoading,
    @Default([]) List<Journal> journals,
    String? errorMessage,
  }) = _JournalState;
}
