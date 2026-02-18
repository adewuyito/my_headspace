import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:my_headspace/core/constants/note_colors.dart';
import 'dart:convert';
import 'package:my_headspace/core/constants/styles.dart';
import 'package:my_headspace/features/journey/application/providers/journal_provider.dart';
import 'package:my_headspace/features/journey/domain/entities/journal_entity.dart';
import 'package:my_headspace/features/journey/presentation/widget/editor_heading_textfield.dart';
import 'package:my_headspace/features/journey/presentation/widget/editor_options.dart';
import 'package:my_headspace/gen/assets.gen.dart';
import 'package:my_headspace/service/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

@RoutePage()
class JournalExpandedView extends HookWidget {
  final Journal? journal;

  const JournalExpandedView({super.key, this.journal});

  @override
  Widget build(BuildContext context) {
    final journalProvider = useMemoized(
      () => serviceLocator.getIt<JournalProvider>(),
    );
    // final auth = useMemoized(
    //   () => serviceLocator.getIt<firebase_auth.FirebaseAuth>(),
    // );
    final titleController = useTextEditingController(
      text: journal?.title ?? '',
    );
    final isFavourite = useState(journal?.isFavourite ?? false);

    final quillController = useMemoized(() {
      if (journal != null && journal!.content.isNotEmpty) {
        try {
          final contentJson = jsonDecode(journal!.content);
          return QuillController(
            document: Document.fromJson(contentJson),
            selection: const TextSelection.collapsed(offset: 0),
          );
        } catch (e) {
          // Could be plain text
          return QuillController(
            document: Document()..insert(0, journal!.content),
            selection: TextSelection.collapsed(offset: journal!.content.length),
          );
        }
      }
      return QuillController.basic();
    }, [journal]);

    final Color noteColor = useMemoized(() {
      return Color(journal?.color ?? NoteColors.defaultJournalColor);
    }, [journal?.color]);

    final selectedColor = useState<Color>(noteColor);

    useEffect(() {
      selectedColor.value = noteColor;
      return null;
    }, [noteColor]);

    Future<bool> saveNote({
      bool showSnackbar = false,
      bool backupToCloud = false,
    }) async {
      final deltaJson = jsonEncode(quillController.document.toDelta().toJson());
      final title = titleController.text;

      if (title.trim().isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please add a title')));
        return false;
      }

      final newJournal = Journal(
        id: journal?.id ?? const Uuid().v4(),
        title: title,
        content: deltaJson,
        createdAt: journal?.createdAt ?? DateTime.now(),
        isFavourite: isFavourite.value,
        color: selectedColor.value.toARGB32(),
      );

      final saved = await journalProvider.saveJournal(
        newJournal,
        backupToCloud: backupToCloud,
      );

      if (showSnackbar && context.mounted && saved) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Note saved!')));
      }
      if (context.mounted && !saved) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to save note. Please try again.')),
        );
      }
      return saved;
    }

    void favouriteNote() {
      if (journal?.id != null) {
        final newFavouriteState = !isFavourite.value;
        isFavourite.value = newFavouriteState; // Optimistic update
        journalProvider.toggleFavourite(journal!.id!, newFavouriteState);
      }
    }

    final isNewNote = journal == null;

    return ChangeNotifierProvider.value(
      value: journalProvider,
      child: Scaffold(
        backgroundColor: selectedColor.value,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () async {
              final wasSaved = await saveNote(
                // backupToCloud: auth.currentUser != null,
              );
              if (wasSaved && context.mounted) {
                context.router.maybePop();
              }
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          centerTitle: true,
          title: Text(
            isNewNote ? 'New Note' : 'Edit Note',
            style: hpStyles.m11.copyWith(color: const Color(0x4D262323)),
          ),
          actions: [
            IconButton(
              icon: Icon(
                isFavourite.value ? Icons.favorite : Icons.favorite_outline,
              ),
              onPressed: favouriteNote,
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () async {
                await saveNote(
                  showSnackbar: true,
                  // backupToCloud: auth.currentUser != null,
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: EditorHeadingTextfield(
                // ~ Fix the hero animation
                tag: '',
                // tag: 'note-title-${journal!.id}',
                isNewNote,
                controller: titleController,
              ),
            ),
            Assets.icons.notesDivider.svg(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: QuillEditor.basic(
                  controller: quillController,
                  config: const QuillEditorConfig(
                    placeholder: 'Write note here',
                  ),
                ),
              ),
            ),
            EditorToolbar(
              controller: quillController,
              onColorChanged: (color) {
                selectedColor.value = color;
              },
              activeColor: selectedColor.value,
            ),
          ],
        ),
      ),
    );
  }
}
