import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:pictive_app_mvp/data/collection/collection.dart';
import 'package:pictive_app_mvp/data/collection/collection_bag.dart';
import 'package:pictive_app_mvp/graphql/g_client_wrapper.dart';
import 'package:pictive_app_mvp/routes/image_grid_page.dart';
import 'package:pictive_app_mvp/state/app/app_bloc.dart';
import 'package:pictive_app_mvp/widgets/centered_circular_progress_indicator.dart';

class PopulateCollection extends StatefulWidget {
  final String collectionID;

  const PopulateCollection(this.collectionID);

  @override
  _PopulateCollectionState createState() => _PopulateCollectionState();
}

class _PopulateCollectionState extends State<PopulateCollection> {
  static const IconData _TILE_ICON_WHEN_COLLAPSED = Icons.keyboard_arrow_right;
  static const IconData _TILE_ICON_WHEN_EXPANDED = Icons.keyboard_arrow_down;
  static const String _GET_COLLECTION_BY_ID_QUERY = r'''
    query GetCollectionByID($id: ID!) {
      getCollectionByID(id: $id) {
        collections {
          id
          displayName
          images {
            id
            payload
            creationTimestamp
          }
          owner {
            id
          }
        }
      }
    }
    ''';

  late final AppBloc _appBloc;
  late bool _expanded;
  late IconData _tileIcon;

  Future<QueryResult>? _getCollectionByIdFuture;

  @override
  void initState() {
    super.initState();
    _getCollectionByIdFuture = _performQuery();
    _appBloc = context.read<AppBloc>();
    _expanded = _appBloc.state.isCollectionExpanded(widget.collectionID);
    _tileIcon =
        _expanded ? _TILE_ICON_WHEN_EXPANDED : _TILE_ICON_WHEN_COLLAPSED;
  }

  @override
  Widget build(BuildContext context) {
        return FutureBuilder<QueryResult>(
          future: _getCollectionByIdFuture,
          initialData: QueryResult.unexecuted,
          builder: (BuildContext context, AsyncSnapshot<QueryResult> snapshot) {
            if (snapshot.connectionState == ConnectionState.none ||
                snapshot.connectionState == ConnectionState.waiting) {
              return const CenteredCircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              final Collection collection =
                  _extractCollectionBag(snapshot.data!).collections![0];
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                    ),
                    child: ListTile(
                      leading: Container(
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        // Enable user to pick a thumbnail for the collection
                        child: Icon(Icons.image),
                      ),
                      title: Text("${collection.displayName}"),
                      trailing: ElevatedButton(
                        onPressed: _processShowCollectionButtonPressed,
                        child: Icon(_tileIcon),
                        style: ElevatedButton.styleFrom(shape: CircleBorder()),
                      ),
                    ),
                  ),
                ],
              );
            }
            return const Icon(Icons.error);
          },
        );
  }

  CollectionBag _extractCollectionBag(QueryResult queryResult) {
    return CollectionBag.fromJson(queryResult.data!["getCollectionByID"]);
  }

  Future<QueryResult> _performQuery() {
    return GClientWrapper.getInstance().performQuery(
        _GET_COLLECTION_BY_ID_QUERY,
        <String, dynamic>{'id': widget.collectionID});
  }

  void _processShowCollectionButtonPressed() {
    Navigator.pushNamed(context, ImageGridPage.ROUTE_ID, arguments: widget.collectionID);
  }
}
