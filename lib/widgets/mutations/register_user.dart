import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:pictive_app_mvp/data/user/user_bag.dart';
import 'package:pictive_app_mvp/routes/overview_page.dart';
import 'package:pictive_app_mvp/state/events/user_registered.dart';
import 'package:pictive_app_mvp/state/user_bloc.dart';
import 'package:pictive_app_mvp/widgets/centered_circular_progress_indicator.dart';
import 'package:pictive_app_mvp/widgets/sized_button_child.dart';

class RegisterUser extends StatefulWidget {

  final Future<QueryResult>? resultFuture;

  const RegisterUser(this.resultFuture);

  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  late final UserBloc _userBloc;

  @override
  void initState() {
    super.initState();
    _userBloc = context.read<UserBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QueryResult>(
      future: widget.resultFuture,
      initialData: QueryResult.unexecuted,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none &&
            snapshot.data == QueryResult.unexecuted) {
          return const SizedButtonChild(Text("Register"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedButtonChild(CenteredCircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            _onRegistrationComplete(snapshot.data!);
            return SizedButtonChild(Icon(
              Icons.check,
              color: Colors.white,
            ));
          }
        }
        return const Text("Please try again later.");
      }
    );
  }

  void _onRegistrationComplete(QueryResult queryResult) {
    final UserBag userBag =
        UserBag.fromJson(queryResult.data!["createUserWithDefaultCollection"]);
    _userBloc.add(UserRegistered(userBag.users![0]));
    Navigator.pushReplacementNamed(context, OverviewPage.ROUTE_ID);
  }
}
