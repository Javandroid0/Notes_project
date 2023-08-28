import 'package:flutter/material.dart';
import 'package:notes_project/services/cloud/cloud_note.dart';
import 'package:notes_project/utilities/dialogs/delete_dialog.dart';

typedef NoteCallBack = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallBack onDeleteNote;
  final NoteCallBack onTap;

  const NotesListView({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes.elementAt(index);
          return ListTile(
            onTap: () {
              onTap(note);
            },
            title: Text(
              note.text,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              onPressed: () async {
                final shouldBeDelete = await showDeleteDialog(context);
                if (shouldBeDelete) {
                  onDeleteNote(note);
                }
              },
              icon: const Icon(Icons.delete),
            ),
          );
        });
  }
}
