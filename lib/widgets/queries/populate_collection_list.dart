import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:pictive_app_mvp/data/collection/collection.dart';
import 'package:pictive_app_mvp/data/user/user.dart';
import 'package:pictive_app_mvp/data/user/user_bag.dart';
import 'package:pictive_app_mvp/graphql/g_client_wrapper.dart';
import 'package:pictive_app_mvp/state/app/app_bloc.dart';
import 'package:pictive_app_mvp/state/app/app_state.dart';
import 'package:pictive_app_mvp/widgets/centered_circular_progress_indicator.dart';
import 'package:pictive_app_mvp/widgets/queries/populate_collection.dart';

class PopulateCollectionList extends StatefulWidget {
  final String userMail;

  const PopulateCollectionList(this.userMail);

  @override
  _PopulateCollectionListState createState() => _PopulateCollectionListState();
}

class _PopulateCollectionListState extends State<PopulateCollectionList> {
  static const String _getUserSourcedCollections = r'''
      query UserSourcedCollections($mail: String!) {
        getUserByMail(mail: $mail) {
          users {
            id
            sourcedCollections {
              id
              defaultCollection
              creationTimestamp
            }
          }
        }
      }
  ''';

  late Future<QueryResult> _getUserSourcedCollectionsFuture;

  @override
  void initState() {
    super.initState();
    _getUserSourcedCollectionsFuture = _performQuery();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      buildWhen: (previous, current) {
        final bool needsRebuild =
            current.collectionIDs.length != previous.collectionIDs.length;
        if (needsRebuild) {
          debugPrint("Rebuilding PopulateCollectionList");
          _getUserSourcedCollectionsFuture = _performQuery();
        }
        return needsRebuild;
      },
      builder: (context, state) {
        return FutureBuilder<QueryResult>(
          future: _getUserSourcedCollectionsFuture,
          builder: (BuildContext context, AsyncSnapshot<QueryResult> snapshot) {
            if (snapshot.connectionState == ConnectionState.none ||
                snapshot.connectionState == ConnectionState.waiting) {
              return const CenteredCircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              final User user = _extractUserBag(snapshot.data!).users![0];
              final List<Collection> sourcedCollections =
              user.sourcedCollections!;
              sourcedCollections.sort(
                    (c1, c2) => int.parse(c1.creationTimestamp!)
                    .compareTo(int.parse(c2.creationTimestamp!)),
              );
              return ListView.builder(
                itemCount: sourcedCollections.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.005,
                  ),
                  child: PopulateCollection(sourcedCollections[index].id!),
                ),
              );
            }
            return const Icon(Icons.error);
          },
        );
      },
    );
  }

  UserBag _extractUserBag(QueryResult queryResult) {
    return UserBag.fromJson(
      queryResult.data!["getUserByMail"] as Map<String, dynamic>,
    );
  }

  Future<QueryResult> _performQuery() {
    return GClientWrapper.getInstance().performQuery(
      _getUserSourcedCollections,
      <String, dynamic>{'mail': widget.userMail},
    );
  }
}
