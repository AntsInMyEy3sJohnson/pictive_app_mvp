import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:pictive_app_mvp/data/collection/collection.dart';
import 'package:pictive_app_mvp/data/user/user.dart';
import 'package:pictive_app_mvp/data/user/user_bag.dart';
import 'package:pictive_app_mvp/graphql/g_client_wrapper.dart';
import 'package:pictive_app_mvp/widgets/centered_circular_progress_indicator.dart';
import 'package:pictive_app_mvp/widgets/queries/populate_collection.dart';

class PopulateCollectionList extends StatefulWidget {
  final String userMail;

  const PopulateCollectionList(this.userMail);

  @override
  _PopulateCollectionListState createState() => _PopulateCollectionListState();
}

class _PopulateCollectionListState extends State<PopulateCollectionList> {
  static const String _GET_USER_SHARED_COLLECTIONS = r'''
      query UserSharedCollections($mail: String!) {
        getUserByMail(mail: $mail) {
          users {
            id
            sharedCollections {
              id
              defaultCollection
            }
          }
        }
      }
  ''';

  late final Future<QueryResult> _getUserSharedCollectionsFuture;

  @override
  void initState() {
    super.initState();
    _getUserSharedCollectionsFuture = GClientWrapper.getInstance().performQuery(
        _GET_USER_SHARED_COLLECTIONS,
        <String, dynamic>{'mail': widget.userMail});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QueryResult>(
      future: _getUserSharedCollectionsFuture,
      builder: (BuildContext context, AsyncSnapshot<QueryResult> snapshot) {
        if (snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting) {
          return CenteredCircularProgressIndicator();
        } else if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          final User user = _extractUserBag(snapshot.data!).users![0];
          final List<Collection> sharedCollections = user.sharedCollections!;
          return ListView.builder(
            itemCount: sharedCollections.length,
            itemBuilder: (context, index) => PopulateCollection(
              sharedCollections[index].id!,
              expandedByDefault: sharedCollections[index].defaultCollection!,
            ),
          );
        }
        return const Icon(Icons.error);
      },
    );
  }

  UserBag _extractUserBag(QueryResult queryResult) {
    return UserBag.fromJson(queryResult.data!["getUserByMail"]);
  }
}
