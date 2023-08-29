import 'package:flutter/material.dart';
import 'package:notes_project/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShsareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Sharing',
    content: 'You cannot share empty note',
    optionBuilder: () => {
      'OK': null,
    },
  );
}
