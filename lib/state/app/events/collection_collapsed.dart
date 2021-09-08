import 'package:pictive_app_mvp/state/app/events/app_event.dart';

class CollectionCollapsed extends AppEvent {

  final String collectionID;

  const CollectionCollapsed(this.collectionID);

  @override
  List<Object?> get props => [collectionID];

}