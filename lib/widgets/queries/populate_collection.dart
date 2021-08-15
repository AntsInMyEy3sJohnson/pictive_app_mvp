import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:pictive_app_mvp/data/collection/collection_bag.dart';
import 'package:pictive_app_mvp/data/user/user.dart';
import 'package:pictive_app_mvp/graphql/g_client_wrapper.dart';
import 'package:pictive_app_mvp/state/events/collection_retrieved.dart';
import 'package:pictive_app_mvp/state/user_bloc.dart';
import 'package:pictive_app_mvp/widgets/centered_circular_progress_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopulateCollection extends StatefulWidget {
  final String collectionID;

  const PopulateCollection(this.collectionID);

  @override
  _PopulateCollectionState createState() => _PopulateCollectionState();
}

class _PopulateCollectionState extends State<PopulateCollection> {
  static const IconData _TILE_ICON_WHEN_COLLAPSED = Icons.keyboard_arrow_right;
  static const IconData _TILE_ICON_WHEN_EXPANDED = Icons.keyboard_arrow_down;

  late final UserBloc _userBloc;

  bool _expanded = false;
  IconData _tileIcon = _TILE_ICON_WHEN_COLLAPSED;

  Future<QueryResult>? _resultFuture;

  @override
  void initState() {
    super.initState();
    _resultFuture = GClientWrapper.getInstance()
        .performGetCollectionByID(widget.collectionID);
    _userBloc = context.read<UserBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.005),
      child: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
            child: FutureBuilder<QueryResult>(
                future: _resultFuture,
                initialData: QueryResult.unexecuted,
                builder: (BuildContext context,
                    AsyncSnapshot<QueryResult> snapshot) {
                  if (snapshot.connectionState == ConnectionState.none ||
                      snapshot.connectionState == ConnectionState.waiting) {
                    return const CenteredCircularProgressIndicator();
                  } else if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    _onCollectionQueryComplete(snapshot.data!);
                    return ListTile(
                      leading: Container(
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        // Enable user to pick a thumbnail for the collection
                        child: Icon(Icons.image),
                      ),
                      title: Text("${_extractCollectionBag(snapshot.data!).collections![0].displayName}"),
                      trailing: ElevatedButton(
                        onPressed: _processExpandButtonPressed,
                        child: Icon(_tileIcon),
                        style: ElevatedButton.styleFrom(shape: CircleBorder()),
                      ),
                    );
                  }
                  return const Icon(Icons.error);
                }),
          ),
        ],
      ),
    );
  }

  void _onCollectionQueryComplete(QueryResult queryResult) {
    final CollectionBag collectionBag = _extractCollectionBag(queryResult);
    _userBloc.add(CollectionRetrieved(collectionBag.collections![0]));
  }

  CollectionBag _extractCollectionBag(QueryResult queryResult) {
    return CollectionBag.fromJson(queryResult.data!["getCollectionByID"]);
  }

  void _processExpandButtonPressed() {
    setState(() {
      _expanded = !_expanded;
      if (_expanded) {
        _tileIcon = _TILE_ICON_WHEN_EXPANDED;
      } else {
        _tileIcon = _TILE_ICON_WHEN_COLLAPSED;
      }
    });
  }
}
