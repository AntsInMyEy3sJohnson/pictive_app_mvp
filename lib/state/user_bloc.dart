import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:pictive_app_mvp/data/user/user.dart';
import 'package:pictive_app_mvp/data/user/user_bag.dart';
import 'package:pictive_app_mvp/graphql/g_client_wrapper.dart';
import 'package:pictive_app_mvp/state/events/user_event.dart';
import 'package:pictive_app_mvp/state/events/user_logged_in.dart';
import 'package:pictive_app_mvp/state/events/user_registered.dart';
import 'package:pictive_app_mvp/state/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {

  UserBloc(UserState initialState) : super(initialState);

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is UserRegistered) {
      yield await _mapUserRegisteredToUserState(event);
    } else if (event is UserLoggedIn) {
      yield await _mapUserLoggedInToUserState(event);
    }
  }

  Future<UserState> _mapUserRegisteredToUserState(
      UserRegistered userRegistered) async {

    // User object has been created on server along with default collection,
    // so use query result to populate local state
    final QueryResult queryResult = await GClientWrapper.getInstance()
        .performCreateUser(userRegistered.email, userRegistered.password);

    if (queryResult.hasException) {
      print("Query to create user returned error: ${queryResult.exception.toString()}");
      return UserState(User());
    }

    final UserBag userBag = queryResult.data!["createUserWithDefaultCollection"];

    return UserState(userBag.users![0]);

  }

  Future<UserState> _mapUserLoggedInToUserState(
      UserLoggedIn userLoggedIn) async {
    // TODO Implement me
    return UserState(User());
  }
}
