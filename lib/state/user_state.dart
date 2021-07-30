import 'package:equatable/equatable.dart';

class UserState extends Equatable {

  static const String _PLACEHOLDER = "N/A";

  final String email;
  final String password;

  const UserState(this.email, this.password);

  factory UserState.dummyState() {
    return UserState(_PLACEHOLDER, _PLACEHOLDER);
  }

  @override
  List<Object?> get props => [
    email,
    password
  ];

}