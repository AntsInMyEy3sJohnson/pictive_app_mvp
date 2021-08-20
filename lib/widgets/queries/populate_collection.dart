import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:pictive_app_mvp/data/collection/collection.dart';
import 'package:pictive_app_mvp/data/collection/collection_bag.dart';
import 'package:pictive_app_mvp/graphql/g_client_wrapper.dart';
import 'package:pictive_app_mvp/widgets/centered_circular_progress_indicator.dart';
import 'package:pictive_app_mvp/widgets/queries/populate_image_grid.dart';

class PopulateCollection extends StatefulWidget {
  final String collectionID;
  final bool expandedByDefault;

  const PopulateCollection(this.collectionID, {this.expandedByDefault = false});

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
          }
          owner {
            id
          }
        }
      }
    }
    ''';

  late bool _expanded;
  late IconData _tileIcon;

  Future<QueryResult>? _getCollectionByIdFuture;

  @override
  void initState() {
    super.initState();
    _getCollectionByIdFuture = GClientWrapper.getInstance().performQuery(
        _GET_COLLECTION_BY_ID_QUERY,
        <String, dynamic>{'id': widget.collectionID});
    _expanded = widget.expandedByDefault;
    _tileIcon =
        _expanded ? _TILE_ICON_WHEN_EXPANDED : _TILE_ICON_WHEN_COLLAPSED;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.005),
      child: FutureBuilder<QueryResult>(
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
                        onPressed: _processExpandButtonPressed,
                        child: Icon(_tileIcon),
                        style: ElevatedButton.styleFrom(shape: CircleBorder()),
                      ),
                    ),
                  ),
                  if (_expanded)
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.7,
                      ),
                      child: PopulateImageGrid(widget.collectionID),
                    ),
                ],
              );
            }
            return const Icon(Icons.error);
          }),
    );
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
