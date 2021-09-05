import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pictive_app_mvp/state/app/app_state.dart';
import 'package:pictive_app_mvp/state/app/events/app_event.dart';
import 'package:pictive_app_mvp/state/app/events/collection_created.dart';
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
    } else if (event is CollectionCreated) {
      yield await _mapCollectionCreatedToAppState(event);
    }
  }

  Future<AppState> _mapCollectionCreatedToAppState(
      CollectionCreated collectionCreated) async {
    return state.copyWithNewActiveCollectionAndAdditionalCollectionID(
      collectionCreated.collectionID,
      collectionCreated.collectionID,
    );
  }

  Future<AppState> _mapDefaultCollectionAddedToAppState(
      DefaultCollectionAdded defaultCollectionAdded) async {
    return state
        .copyWithNewActiveCollection(defaultCollectionAdded.collectionID);
  }

  Future<AppState> _mapImagesAddedToCollectionToAppState(
      ImagesAddedToCollection imagesAddedToCollection) async {
    return state.copyWithNewActiveCollectionAndAdditionalCollectionID(
        imagesAddedToCollection.collectionID,
        imagesAddedToCollection.collectionID);
  }
}
