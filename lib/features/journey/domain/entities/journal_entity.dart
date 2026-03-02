import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_headspace/core/constants/note_colors.dart';

part 'journal_entity.freezed.dart';
part 'journal_entity.g.dart';

@freezed
abstract class Journal with _$Journal {
  const factory Journal({
    String? id,
    required String title,
    required String content,
    required DateTime createdAt,
    @Default(NoteColors.defaultJournalColor) int color,
    @Default(false) bool isFavourite,
    @Default(false) bool isBackedUp,
  }) = _Journal;

  factory Journal.fromJson(Map<String, dynamic> json) =>
      _$JournalFromJson(json);
}