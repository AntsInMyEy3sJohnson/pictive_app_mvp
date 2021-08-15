import 'package:pictive_app_mvp/data/collection/collection.dart';
import 'package:pictive_app_mvp/state/events/user_event.dart';

class CollectionRetrieved extends UserEvent {

  final Collection collection;

  const CollectionRetrieved(this.collection);

  @override
  List<Object?> get props => [collection];


}