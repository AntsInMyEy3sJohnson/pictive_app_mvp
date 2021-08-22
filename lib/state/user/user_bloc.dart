import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pictive_app_mvp/data/user/user.dart';
import 'package:pictive_app_mvp/state/user/events/user_event.dart';
import 'package:pictive_app_mvp/state/user/events/user_logged_in.dart';

class UserBloc extends Bloc<UserEvent, User> {
  UserBloc(User initialState) : super(initialState);

  @override
  Stream<User> mapEventToState(UserEvent event) async* {
    if (event is UserLoggedIn) {
      yield await _mapUserLoggedInToUserState(event);
    }
  }

  Future<User> _mapUserLoggedInToUserState(UserLoggedIn userLoggedIn) async {
    return userLoggedIn.user;
  }

}
