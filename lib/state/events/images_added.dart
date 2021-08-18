import 'package:pictive_app_mvp/state/events/user_event.dart';

class ImagesAdded extends UserEvent {

  final String payload;

  const ImagesAdded(this.payload);

  @override
  List<Object?> get props => [payload];

}