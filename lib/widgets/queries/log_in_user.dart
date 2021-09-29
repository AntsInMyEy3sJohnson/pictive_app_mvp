import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:pictive_app_mvp/data/user/user.dart';
import 'package:pictive_app_mvp/data/user/user_bag.dart';
import 'package:pictive_app_mvp/graphql/g_client_wrapper.dart';
import 'package:pictive_app_mvp/routes/overview_page.dart';
import 'package:pictive_app_mvp/state/app/app_bloc.dart';
import 'package:pictive_app_mvp/state/app/events/default_collection_retrieved.dart';
import 'package:pictive_app_mvp/state/user/events/user_logged_in.dart';
import 'package:pictive_app_mvp/state/user/user_bloc.dart';
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
  static const String _GET_USER_BY_MAIL_QUERY = r'''
      query GetUserByMail($mail: String!){
      getUserByMail(mail: $mail){
        users {
          id
          mail
          ownedCollections {
            id
          }
          sharedCollections {
            id
            defaultCollection
          }
          defaultCollection {
            id
          }
          ownedImages {
            id
          }
        }
      }
    }
  ''';

  late final Future<QueryResult> _getUserByMailFuture;
  late final UserBloc _userBloc;
  late final AppBloc _appBloc;

  @override
  void initState() {
    super.initState();
    _getUserByMailFuture = GClientWrapper.getInstance().performQuery(
        _GET_USER_BY_MAIL_QUERY, <String, dynamic>{'mail': widget.email});
    _userBloc = context.read<UserBloc>();
    _appBloc = context.read<AppBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QueryResult>(
      future: _getUserByMailFuture,
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
        UserBag.fromJson(queryResult.data!["getUserByMail"] as Map<String, dynamic>);
    final User user = userBag.users![0];
    _userBloc.add(UserLoggedIn(user));
    _appBloc.add(CollectionsRetrieved(
        user.sharedCollections!.map((e) => e.id!).toList(),
        user.defaultCollection!.id!));
    // TODO Pass this as callback into widget -- currently, there
    //  is still a back arrow displayed on the Overview page
    Navigator.pushReplacementNamed(context, OverviewPage.ROUTE_ID);
  }
}
