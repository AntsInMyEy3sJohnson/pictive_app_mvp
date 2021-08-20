import 'package:pictive_app_mvp/state/events/user_event.dart';

class ImagesAdded extends UserEvent {

  final String collectionID;
  final List<String> base64Payloads;

  const ImagesAdded(this.collectionID, this.base64Payloads);

  @override
  List<Object?> get props => [base64Payloads];

}