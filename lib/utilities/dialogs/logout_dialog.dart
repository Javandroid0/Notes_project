import 'package:flutter/material.dart';
import 'package:notes_project/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Log out',
    content: 'Are you sure you want to log out ? ',
    optionBuilder: () => {
      'Cancel': false,
      'LogOut': true,
    },
  ).then((value) => value ?? false);
}
