// From https://www.greycastle.se/loading-overlay-in-flutter/
import 'package:flutter/material.dart';
import 'package:pictive_app_mvp/widgets/centered_circular_progress_indicator.dart';

class LoadingOverlay {
  late final BuildContext _context;

  LoadingOverlay._(this._context);

  factory LoadingOverlay.of(BuildContext context) {
    return LoadingOverlay._(context);
  }

  Future<T> during<T>(Future<T> future) {
    show();
    return future.whenComplete(() => hide());
  }

  void show() {
    showDialog(
      context: _context,
      barrierDismissible: false,
      builder: (_) => _FullScreenLoader(),
    );
  }

  void hide() {
    Navigator.of(_context).pop();
  }
}

class _FullScreenLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.5)),
      child: const CenteredCircularProgressIndicator(),
    );
  }
}
