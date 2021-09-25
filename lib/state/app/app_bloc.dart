import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pictive_app_mvp/state/app/app_state.dart';
import 'package:pictive_app_mvp/state/app/events/app_event.dart';
import 'package:pictive_app_mvp/state/app/events/collection_activated.dart';
import 'package:pictive_app_mvp/state/app/events/collection_created.dart';
import 'package:pictive_app_mvp/state/app/events/default_collection_retrieved.dart';
import 'package:pictive_app_mvp/state/app/events/images_added_to_collection.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc(AppState initialState) : super(initialState);

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is CollectionsRetrieved) {
      yield await _mapCollectionsRetrievedToAppState(event);
    } else if (event is ImagesAddedToCollection) {
      yield await _mapImagesAddedToCollectionToAppState(event);
    } else if (event is CollectionCreated) {
      yield await _mapCollectionCreatedToAppState(event);
    } else if (event is CollectionActivated) {
      yield await _mapCollectionActivatedToAppState(event);
    }
  }

  Future<AppState> _mapCollectionActivatedToAppState(
      CollectionActivated collectionActivated) async {
    return state.withActivatedCollection(collectionActivated.collectionID);
  }

  Future<AppState> _mapCollectionCreatedToAppState(
      CollectionCreated collectionCreated) async {
    return state.withAddedAndActivatedCollection(collectionCreated.collectionID);
  }

  Future<AppState> _mapCollectionsRetrievedToAppState(
      CollectionsRetrieved collectionsRetrieved) async {
    return state.withAddedCollectionsAndActivatedDefaultCollection(collectionsRetrieved.collectionIDs, collectionsRetrieved.defaultCollectionID);
  }

  Future<AppState> _mapImagesAddedToCollectionToAppState(
      ImagesAddedToCollection imagesAddedToCollection) async {
    return state
        .withAddedAndActivatedCollection(imagesAddedToCollection.collectionID);
  }
}
