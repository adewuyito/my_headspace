import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
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

    void saveNote() async {
      final deltaJson = jsonEncode(quillController.document.toDelta().toJson());
      final title = titleController.text;

      if (title.trim().isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please add a title')));
        return;
      }

      final newJournal = Journal(
        id: journal?.id ?? const Uuid().v4(),
        title: title,
        content: deltaJson,
        createdAt: journal?.createdAt ?? DateTime.now(),
        isFavourite: isFavourite.value,
      );

      await journalProvider.saveJournal(newJournal);

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Note saved!')));
        context.router.maybePop();
      }
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
        appBar: AppBar(
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
            IconButton(icon: const Icon(Icons.more_vert), onPressed: saveNote),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: EditorHeadingTextfield(
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
            EditorToolbar(controller: quillController),
          ],
        ),
      ),
    );
  }
}
