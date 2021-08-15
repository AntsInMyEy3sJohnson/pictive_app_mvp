import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pictive_app_mvp/data/collection/collection.dart';
import 'package:pictive_app_mvp/data/user/user.dart';
import 'package:pictive_app_mvp/state/events/collection_retrieved.dart';
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
    }
  }

  Future<User> _mapCollectionRetrievedToUserState(CollectionRetrieved collectionRetrieved) async {
    final Collection collection = collectionRetrieved.collection;
    final List<Collection> ownedCollections = List.from(state.ownedCollections ?? []);
    final List<Collection> sharedCollections = List.from(state.sharedCollections ?? []);

    sharedCollections.removeWhere((element) => element == collection);
    sharedCollections.add(collection);

    if (collection.owner == state) {
      ownedCollections.removeWhere((element) => element == collection);
      ownedCollections.add(collection);
    }

    return User()
        ..id = state.id
        ..mail = state.mail
        ..ownedCollections = ownedCollections
        ..sharedCollections = sharedCollections
        ..defaultCollection = state.defaultCollection
        ..ownedImages = state.ownedImages;

  }

  Future<User> _mapUserLoggedInToUserState(
      UserLoggedIn userLoggedIn) async {
    return userLoggedIn.user;
  }
}
