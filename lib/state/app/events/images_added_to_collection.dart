import 'package:pictive_app_mvp/state/app/events/app_event.dart';

class ImagesAddedToCollection extends AppEvent {

  final String collectionID;

  const ImagesAddedToCollection(this.collectionID);

  @override
  List<Object?> get props => [collectionID];

}
