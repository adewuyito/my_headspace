import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_headspace/features/journey/data/local/database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => database.close());

  test('can search for journal entries', () async {
    final entry = await database
        .into(database.journals)
        .insertReturning(
          JournalsCompanion.insert(
            id: 'journal-1',
            title: 'test title',
            content: 'this is a test todo entry',
            createdAt: DateTime(2026, 2, 23),
          ),
        );

    final result = await database.search('test');
    expect(result, contains(entry));
  });
}
