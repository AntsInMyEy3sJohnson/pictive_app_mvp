import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pictive_app_mvp/state/events/user_event.dart';
import 'package:pictive_app_mvp/state/events/user_logged_in.dart';
import 'package:pictive_app_mvp/state/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc(UserState initialState) : super(initialState);

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is UserLoggedIn) {
      yield await _mapUserLoggedInToUserState(event);
    }
  }

  Future<UserState> _mapUserLoggedInToUserState(
      UserLoggedIn userLoggedIn) async {
    return UserState(userLoggedIn.email, userLoggedIn.password);
  }
}
