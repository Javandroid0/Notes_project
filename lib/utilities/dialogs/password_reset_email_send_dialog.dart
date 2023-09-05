import 'package:flutter/material.dart';
import 'package:notes_project/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'password reset',
    content: 'ew send an email reset',
    optionBuilder: () => {
      'OK': null,
    },
  );
}
