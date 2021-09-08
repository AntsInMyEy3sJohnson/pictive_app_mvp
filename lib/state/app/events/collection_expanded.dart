import 'package:pictive_app_mvp/state/app/events/app_event.dart';

class CollectionExpanded extends AppEvent {

  final String collectionID;

  const CollectionExpanded(this.collectionID);

  @override
  List<Object?> get props => [collectionID];

}