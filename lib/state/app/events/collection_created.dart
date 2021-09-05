import 'package:pictive_app_mvp/state/app/events/app_event.dart';

class CollectionCreated extends AppEvent {
  final String collectionID;
  final String collectionName;

  const CollectionCreated(this.collectionID, this.collectionName);

  @override
  List<Object?> get props => [collectionID, collectionName];
}
