import 'package:equatable/equatable.dart';
import 'package:pictive_app_mvp/data/user/user.dart';

class UserState extends Equatable {

  final User user;

  const UserState(this.user);

  factory UserState.dummyState() {
    return UserState(User());
  }

  factory UserState.copyWithUser(User user) {
    return UserState(user);
  }

  @override
  List<Object?> get props => [user];
}
