import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pictive_app_mvp/data/collection/collection.dart';
import 'package:pictive_app_mvp/data/image/image.dart';
import 'package:pictive_app_mvp/data/user/user.dart';
import 'package:pictive_app_mvp/state/events/collection_retrieved.dart';
import 'package:pictive_app_mvp/state/events/images_added.dart';
import 'package:pictive_app_mvp/state/events/user_event.dart';
import 'package:pictive_app_mvp/state/events/user_logged_in.dart';

class UserBloc extends Bloc<UserEvent, User> {
  UserBloc(User initialState) : super(initialState);

  @override
  Stream<User> mapEventToState(UserEvent event) async* {
    if (event is UserLoggedIn) {
      yield await _mapUserLoggedInToUserState(event);
    } else if (event is CollectionRetrieved) {
      yield await _mapCollectionRetrievedToUserState(event);
    } else if (event is ImagesAdded) {
      yield await _mapImagesAddedToUserState(event);
    }
  }

  Future<User> _mapImagesAddedToUserState(ImagesAdded imagesAdded) async {
    final Collection affectedCollection = state.sharedCollections!
        .firstWhere((collection) => collection.id == imagesAdded.collectionID);
    final List<Image> existingImages = List.of(affectedCollection.images ?? []);
    final List<Image> newImages =
        imagesAdded.base64Payloads.map((e) => Image()..payload = e).toList();
    existingImages.addAll(newImages);

    affectedCollection.images = existingImages;
    final bool userOwnsImages = state.ownedCollections!.any((element) => element == affectedCollection);
    final List<Image> ownedImages = List.of(state.ownedImages ?? []);
    if (userOwnsImages) {
      ownedImages.addAll(newImages);
    }

    final List<Collection> sharedCollections = List.of(state.sharedCollections!);
    final List<Collection> ownedCollections = List.of(state.ownedCollections!);

    _replaceCollection(affectedCollection, sharedCollections, ownedCollections);

    return User()
      ..id = state.id
      ..mail = state.mail
      ..ownedCollections = ownedCollections
      ..sharedCollections = sharedCollections
      ..defaultCollection = state.defaultCollection
      ..ownedImages = ownedImages;

  }

  Future<User> _mapCollectionRetrievedToUserState(
      CollectionRetrieved collectionRetrieved) async {
    final Collection collection = collectionRetrieved.collection;
    final List<Collection> ownedCollections =
        List.from(state.ownedCollections ?? []);
    final List<Collection> sharedCollections =
        List.from(state.sharedCollections ?? []);

    _replaceCollection(collection, sharedCollections, ownedCollections);

    return User()
      ..id = state.id
      ..mail = state.mail
      ..ownedCollections = ownedCollections
      ..sharedCollections = sharedCollections
      ..defaultCollection = state.defaultCollection
      ..ownedImages = state.ownedImages;
  }

  Future<User> _mapUserLoggedInToUserState(UserLoggedIn userLoggedIn) async {
    return userLoggedIn.user;
  }

  void _replaceCollection(Collection collectionToReplace,
      List<Collection> sharedCollections, List<Collection> ownedCollections) {
    sharedCollections.removeWhere((element) => element == collectionToReplace);
    sharedCollections.add(collectionToReplace);

    if (collectionToReplace.owner == state) {
      ownedCollections.removeWhere((element) => element == collectionToReplace);
      ownedCollections.add(collectionToReplace);
    }
  }
}
