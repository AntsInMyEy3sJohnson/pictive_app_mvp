import 'package:flutter/material.dart';
import 'package:pictive_app_mvp/input_validation/generic_input_validation.dart';

class CreateNewCollectionDialog extends StatefulWidget {
  const CreateNewCollectionDialog();

  @override
  _CreateNewCollectionDialogState createState() =>
      _CreateNewCollectionDialogState();
}

class _CreateNewCollectionDialogState extends State<CreateNewCollectionDialog> {
  final TextEditingController _collectionNameController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _collectionNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Create new Collection",
              textAlign: TextAlign.center,
            ),
            // TODO Add input for:
            // * Pin
            // * Whether or not non-owners can share
            // * whether or not non-owners can write
            TextFormField(
              controller: _collectionNameController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Collection name",
              ),
              validator: _validateCollectionName,
            ),
            ButtonBar(
              children: [
                TextButton(
                  onPressed: _processAbort,
                  child: const Text(
                    "Abort",
                    textAlign: TextAlign.end,
                  ),
                ),
                TextButton(
                  onPressed: _processConfirm,
                  child: const Text(
                    "Confirm",
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _processConfirm() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pop(context, _collectionNameController.text);
    }
  }

  void _processAbort() {
    Navigator.pop(context);
  }

  String? _validateCollectionName(String? collectionName) {
    // Use generic input validation for now
    return GenericInputValidation.stringValidation(collectionName);
  }
}
