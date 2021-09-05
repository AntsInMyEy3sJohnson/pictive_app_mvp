import 'package:flutter/cupertino.dart';

class DialogHelper<T> {
  const DialogHelper();

  Future<T?> show(BuildContext context, Widget dialog) {
    return Navigator.push(
      context,
      PageRouteBuilder(
        barrierDismissible: true,
        opaque: false,
        pageBuilder: (context, animation1, animation2) => dialog,
      ),
    );
  }
}
