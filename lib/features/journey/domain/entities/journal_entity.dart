import 'package:freezed_annotation/freezed_annotation.dart';

part 'journal_entity.freezed.dart';
part 'journal_entity.g.dart';

@freezed
abstract class Journal with _$Journal {
  const factory Journal({
    String? id,
    required String title,
    required String content,
    required DateTime createdAt,
    @Default(false) bool isFavourite,
  }) = _Journal;

  factory Journal.fromJson(Map<String, dynamic> json) =>
      _$JournalFromJson(json);
}
