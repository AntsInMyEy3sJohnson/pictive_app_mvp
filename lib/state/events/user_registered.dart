import 'package:pictive_app_mvp/data/user/user.dart';
import 'package:pictive_app_mvp/state/events/user_event.dart';

class UserRegistered extends UserEvent {

  final User user;

  const UserRegistered(this.user);

  @override
  List<Object?> get props => [user];

}