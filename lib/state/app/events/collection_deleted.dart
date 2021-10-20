import 'package:pictive_app_mvp/state/app/events/app_event.dart';

class CollectionDeleted extends AppEvent {

  final String collectionID;

  const CollectionDeleted(this.collectionID);

  @override
  List<Object?> get props => [collectionID];

}
