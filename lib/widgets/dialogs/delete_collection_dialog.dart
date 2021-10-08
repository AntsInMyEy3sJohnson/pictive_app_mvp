import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeleteCollectionDialog extends StatefulWidget {
  final String collectionName;
  final int numImages;

  const DeleteCollectionDialog(this.collectionName, this.numImages);

  @override
  State<DeleteCollectionDialog> createState() => _DeleteCollectionDialogState();
}

class _DeleteCollectionDialogState extends State<DeleteCollectionDialog> {
  bool _deleteContainedImages = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.02,
            ),
            // TODO What happens to this Text widget in case of a very long collection name?
            child: Text(
              "Delete collection '${widget.collectionName}'?",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (widget.numImages == 0)
            const Text("This collection does not contain any images."),
          if (widget.numImages > 0)
            CheckboxListTile(
              value: _deleteContainedImages,
              onChanged: (newValue) {
                setState(() {
                  _deleteContainedImages = newValue ?? false;
                });
              },
              title: Text(
                "Delete ${widget.numImages} contained image/-s, too",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.037,
                ),
              ),
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
    );
  }

  void _processAbort() {
    Navigator.pop(context, [false]);
  }

  void _processConfirm() {
    Navigator.pop(context, [true, _deleteContainedImages]);
  }
}
