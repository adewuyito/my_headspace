/* import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';

@RoutePage()
class NotesListPage extends StatelessWidget {
  const NotesListPage({Key? key}) : super(key: key);

  String _getNotePreview(int noteId) {
    // In real app, load from database and extract plain text
    final delta = Delta()..insert('This is the content of note $noteId\n');
    final doc = Document.fromDelta(delta);
    return doc.toPlainText().trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Notes')),
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              onTap: () {
                // Navigate with noteId for editing
                context.router.root.push(NoteDetailRoute(noteId: index));
              },
              title: Hero(
                tag: 'note-title-$index',
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    'Note $index',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Hero(
                  tag: 'note-content-$index',
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      _getNotePreview(index),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ),
              ),
              trailing: const Icon(Icons.chevron_right),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate WITHOUT noteId for creating new note
          context.router.root.push(const NoteDetailRoute());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}  */