import 'package:flutter/material.dart';

void showErrorMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        content: const Text('Form cannot be submitted!'),
        backgroundColor: Theme.of(context).errorColor),
  );
}

void showSuccessMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        content: const Text('Form cannot be submitted!'),
        backgroundColor: Theme.of(context).primaryColor),
  );
}
