import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pictive_app_mvp/state/app/app_state.dart';
import 'package:pictive_app_mvp/state/app/events/app_event.dart';
import 'package:pictive_app_mvp/state/app/events/collection_collapsed.dart';
import 'package:pictive_app_mvp/state/app/events/collection_expanded.dart';
import 'package:pictive_app_mvp/state/app/events/collection_created.dart';
import 'package:pictive_app_mvp/state/app/events/default_collection_retrieved.dart';
import 'package:pictive_app_mvp/state/app/events/images_added_to_collection.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc(AppState initialState) : super(initialState);

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is DefaultCollectionRetrieved) {
      yield await _mapDefaultCollectionAddedToAppState(event);
    } else if (event is ImagesAddedToCollection) {
      yield await _mapImagesAddedToCollectionToAppState(event);
    } else if (event is CollectionCreated) {
      yield await _mapCollectionCreatedToAppState(event);
    } else if (event is CollectionExpanded) {
      yield await _mapCollectionExpandedToAppState(event);
    } else if (event is CollectionCollapsed) {
      yield await _mapCollectionCollapsedToAppState(event);
    }
  }

  Future<AppState> _mapCollectionCollapsedToAppState(
      CollectionCollapsed collectionCollapsed) async {
    return state.withCollapsedCollection(collectionCollapsed.collectionID);
  }

  Future<AppState> _mapCollectionExpandedToAppState(
      CollectionExpanded collectionActivated) async {
    return state.withExpandedCollection(collectionActivated.collectionID);
  }

  Future<AppState> _mapCollectionCreatedToAppState(
      CollectionCreated collectionCreated) async {
    return state.withAddedAndExpandedCollection(collectionCreated.collectionID);
  }

  Future<AppState> _mapDefaultCollectionAddedToAppState(
      DefaultCollectionRetrieved defaultCollectionAdded) async {
    return state.withAddedAndExpandedCollection(defaultCollectionAdded.collectionID);
  }

  Future<AppState> _mapImagesAddedToCollectionToAppState(
      ImagesAddedToCollection imagesAddedToCollection) async {
    return state
        .withAddedAndExpandedCollection(imagesAddedToCollection.collectionID);
  }
}
