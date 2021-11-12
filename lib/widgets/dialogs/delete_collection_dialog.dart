import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pictive_app_mvp/widgets/sizable_text_field.dart';

class DeleteCollectionDialog extends StatefulWidget {
  final String collectionName;
  final int numImages;
  final int numSourcedBy;

  const DeleteCollectionDialog(
    this.collectionName,
    this.numImages,
    this.numSourcedBy,
  );

  @override
  State<DeleteCollectionDialog> createState() => _DeleteCollectionDialogState();
}

class _DeleteCollectionDialogState extends State<DeleteCollectionDialog> {
  static const double _titleTextSizeWidthModifier = 0.04;
  static const double _infoTextSizeWidthModifier = 0.037;

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
            child: SizableTextField(
              "Delete collection '${widget.collectionName}'?",
              _titleTextSizeWidthModifier,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (widget.numImages == 0)
            const SizableTextField(
              "This collection does not contain any images.",
              _infoTextSizeWidthModifier,
            ),
          if (widget.numImages > 0)
            CheckboxListTile(
              value: _deleteContainedImages,
              onChanged: (newValue) {
                setState(() {
                  _deleteContainedImages = newValue ?? false;
                });
              },
              title: SizableTextField(
                "Delete ${widget.numImages} contained image/-s, too",
                0.037,
              ),
            ),
          if (widget.numSourcedBy > 1)
            SizableTextField(
              "Caution! This collection was sourced by ${widget.numSourcedBy - 1} other users. They will lose access to this collection!",
              _infoTextSizeWidthModifier,
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
