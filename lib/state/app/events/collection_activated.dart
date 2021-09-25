import 'package:pictive_app_mvp/state/app/events/app_event.dart';

class CollectionActivated extends AppEvent {

  final String collectionID;

  const CollectionActivated(this.collectionID);

  @override
  List<Object?> get props => [collectionID];

}