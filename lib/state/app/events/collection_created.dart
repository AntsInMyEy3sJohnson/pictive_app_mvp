import 'package:pictive_app_mvp/state/app/events/app_event.dart';

class CollectionCreated extends AppEvent {
  final String collectionName;

  const CollectionCreated(this.collectionName);

  @override
  List<Object?> get props => [collectionName];
}
