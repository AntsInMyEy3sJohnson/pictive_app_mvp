import 'package:pictive_app_mvp/state/app/events/app_event.dart';

class CollectionsRetrieved extends AppEvent {

  final List<String> collectionIDs;
  final String defaultCollectionID;

  const CollectionsRetrieved(this.collectionIDs, this.defaultCollectionID);

  @override
  List<Object?> get props => [defaultCollectionID, collectionIDs];

}