import 'package:pictive_app_mvp/state/app/events/app_event.dart';

class DefaultCollectionRetrieved extends AppEvent {

  final String collectionID;

  const DefaultCollectionRetrieved(this.collectionID);

  @override
  List<Object?> get props => [collectionID];

}