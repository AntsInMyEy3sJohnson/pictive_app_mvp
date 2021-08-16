import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:pictive_app_mvp/data/user/user_bag.dart';
import 'package:pictive_app_mvp/graphql/g_client_wrapper.dart';
import 'package:pictive_app_mvp/routes/overview_page.dart';
import 'package:pictive_app_mvp/state/events/user_logged_in.dart';
import 'package:pictive_app_mvp/state/user_bloc.dart';
import 'package:pictive_app_mvp/widgets/centered_circular_progress_indicator.dart';
import 'package:pictive_app_mvp/widgets/sized_button_child.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogInUser extends StatefulWidget {
  final String email;

  const LogInUser(this.email);

  @override
  _LogInUserState createState() => _LogInUserState();
}

class _LogInUserState extends State<LogInUser> {
  late final Future<QueryResult> _resultFuture;
  late final UserBloc _userBloc;

  @override
  void initState() {
    super.initState();
    _resultFuture =
        GClientWrapper.getInstance().performGetUserByMail(widget.email);
    _userBloc = context.read<UserBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QueryResult>(
      future: _resultFuture,
      initialData: QueryResult.unexecuted,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedButtonChild(CenteredCircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          Future.delayed(Duration(milliseconds: 200),
              () => _onLoginComplete(snapshot.data!));
          return SizedButtonChild(
            Icon(
              Icons.check,
              color: Colors.white,
            ),
          );
        }
        return const Text("Please try again later.");
      },
    );
  }

  void _onLoginComplete(QueryResult queryResult) async {
    final UserBag userBag =
        UserBag.fromJson(queryResult.data!["getUserByMail"]);
    _userBloc.add(UserLoggedIn(userBag.users![0]));
    // TODO Pass this as callback into widget -- currently, there
    //  is still a back arrow displayed on the Overview page
    Navigator.pushReplacementNamed(context, OverviewPage.ROUTE_ID);
  }
}
