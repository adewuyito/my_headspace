import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_headspace/features/journey/application/providers/journal_provider.dart';
import 'package:my_headspace/features/journey/data/local/database.dart';
import 'package:my_headspace/features/journey/domain/entities/journal_entity.dart';
import 'package:my_headspace/features/journey/presentation/journey_expanded_view.dart';
import 'package:my_headspace/service/service_locator.dart';

import '../../unit-features/journey/support/journal_provider_test_support.dart';

void main() {
  late AppDatabase database;
  late JournalProvider provider;

  Future<void> pumpExpandedView(WidgetTester tester, {Journal? journal}) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (_, __) {
          return MaterialApp(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              FlutterQuillLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en')],
            home: JournalExpandedView(journal: journal),
          );
        },
      ),
    );
    await tester.pumpAndSettle();
  }

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    provider = buildProviderWithInMemoryDb(database);

    if (serviceLocator.getIt.isRegistered<JournalProvider>()) {
      serviceLocator.getIt.unregister<JournalProvider>();
    }
    serviceLocator.getIt.registerSingleton<JournalProvider>(provider);
  });

  tearDown(() async {
    if (serviceLocator.getIt.isRegistered<JournalProvider>()) {
      serviceLocator.getIt.unregister<JournalProvider>();
    }
    await database.close();
  });

  testWidgets('shows "New Note" when opened without a journal', (tester) async {
    await pumpExpandedView(tester);

    expect(find.text('New Note'), findsOneWidget);
    expect(find.text('Edit Note'), findsNothing);
  });

  testWidgets('shows "Edit Note" and prefilled title for existing journal', (
    tester,
  ) async {
    final journal = Journal(
      id: 'existing-1',
      title: 'Existing title',
      content: jsonEncode([
        {'insert': 'Existing body'},
      ]),
      createdAt: DateTime(2026, 2, 23),
    );

    await pumpExpandedView(tester, journal: journal);

    expect(find.text('Edit Note'), findsOneWidget);
    expect(find.text('Existing title'), findsOneWidget);
  });

  testWidgets('shows validation snackbar when trying to save without title', (
    tester,
  ) async {
    await pumpExpandedView(tester);

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save note'));
    await tester.pumpAndSettle();

    expect(find.text('Please add a title'), findsOneWidget);
    expect(provider.state.journals, isEmpty);
  });

  testWidgets('saves new note and shows success snackbar', (tester) async {
    await pumpExpandedView(tester);

    await tester.enterText(find.byType(TextField).first, 'Saved title');
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save note'));
    await tester.pumpAndSettle();

    expect(find.text('Note saved!'), findsOneWidget);
    expect(provider.state.journals.length, 1);
    expect(provider.state.journals.first.title, 'Saved title');
  });

  testWidgets(
    'keeps note as favourite when favourite is toggled before tapping save icon',
    (tester) async {
      final existing = Journal(
        id: 'fav-save-1',
        title: 'Favourite me',
        content: jsonEncode([
          {'insert': 'Body'},
        ]),
        createdAt: DateTime(2026, 2, 23),
        isFavourite: false,
      );
      await provider.saveJournal(existing);

      await pumpExpandedView(tester, journal: existing);

      await tester.tap(find.byIcon(Icons.favorite_outline));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save note'));
      await tester.pumpAndSettle();

      expect(find.text('Note saved!'), findsOneWidget);
      expect(provider.state.journals.first.id, 'fav-save-1');
      expect(provider.state.journals.first.isFavourite, isTrue);

      final dbEntry = await (database.select(
        database.journals,
      )..where((j) => j.id.equals('fav-save-1'))).getSingle();
      expect(dbEntry.isFavourite, isTrue);
    },
  );
}
