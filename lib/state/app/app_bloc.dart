import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pictive_app_mvp/state/app/app_state.dart';
import 'package:pictive_app_mvp/state/app/events/app_event.dart';
import 'package:pictive_app_mvp/state/app/events/default_collection_added.dart';
import 'package:pictive_app_mvp/state/app/events/images_added_to_collection.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc(AppState initialState) : super(initialState);

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is DefaultCollectionAdded) {
      yield await _mapDefaultCollectionAddedToAppState(event);
    } else if (event is ImagesAddedToCollection) {
      yield await _mapImagesAddedToCollectionToAppState(event);
    }
  }

  Future<AppState> _mapDefaultCollectionAddedToAppState(
      DefaultCollectionAdded defaultCollectionAdded) async {
    return state.copyWithCollectionID(defaultCollectionAdded.collectionID);
  }

  Future<AppState> _mapImagesAddedToCollectionToAppState(
      ImagesAddedToCollection imagesAddedToCollection) async {
    return state.copyWithCollectionID(imagesAddedToCollection.collectionID);
  }
}
