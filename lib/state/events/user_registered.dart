import 'package:pictive_app_mvp/state/events/user_event.dart';

class UserRegistered extends UserEvent {

  final String email;
  final String password;

  const UserRegistered(this.email, this.password);

  @override
  List<Object?> get props => [email, password];

}