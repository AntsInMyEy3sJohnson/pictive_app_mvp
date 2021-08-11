import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pictive_app_mvp/data/user/user.dart';
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

    // TODO Implement me
    return UserState(User());

  }

  Future<UserState> _mapUserLoggedInToUserState(
      UserLoggedIn userLoggedIn) async {
    // TODO Implement me
    return UserState(User());
  }
}
