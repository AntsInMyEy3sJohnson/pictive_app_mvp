import 'package:pictive_app_mvp/data/user/user.dart';
import 'package:pictive_app_mvp/state/user/events/user_event.dart';

class UserLoggedIn extends UserEvent {

  final User user;

  const UserLoggedIn(this.user);

  @override
  List<Object?> get props => [user];

}
