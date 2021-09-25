import 'package:pictive_app_mvp/state/app/events/app_event.dart';

class CollectionDeactivated extends AppEvent {

  final String collectionID;

  const CollectionDeactivated(this.collectionID);

  @override
  List<Object?> get props => [collectionID];

}