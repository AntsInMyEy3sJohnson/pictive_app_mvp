import 'package:pictive_app_mvp/state/app/events/app_event.dart';

class DefaultCollectionAdded extends AppEvent {

  final String collectionID;

  const DefaultCollectionAdded(this.collectionID);

  @override
  List<Object?> get props => [collectionID];

}