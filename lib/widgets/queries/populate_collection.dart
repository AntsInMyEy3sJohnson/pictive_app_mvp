import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:pictive_app_mvp/data/collection/collection.dart';
import 'package:pictive_app_mvp/data/collection/collection_bag.dart';
import 'package:pictive_app_mvp/graphql/g_client_wrapper.dart';
import 'package:pictive_app_mvp/state/app/app_bloc.dart';
import 'package:pictive_app_mvp/state/app/app_state.dart';
import 'package:pictive_app_mvp/state/app/events/collection_collapsed.dart';
import 'package:pictive_app_mvp/state/app/events/collection_expanded.dart';
import 'package:pictive_app_mvp/widgets/centered_circular_progress_indicator.dart';
import 'package:pictive_app_mvp/widgets/queries/populate_image_grid.dart';
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

  late final AppBloc _appBloc;
  late bool _expanded;
  late IconData _tileIcon;

  Future<QueryResult>? _getCollectionByIdFuture;

  @override
  void initState() {
    super.initState();
    _getCollectionByIdFuture = _performQuery();
    _appBloc = context.read<AppBloc>();
    _expanded = _appBloc.state.isCollectionActive(widget.collectionID);
    _tileIcon =
        _expanded ? _TILE_ICON_WHEN_EXPANDED : _TILE_ICON_WHEN_COLLAPSED;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      buildWhen: (previous, current) {
        final bool newExpanded = current.expandedCollectionsOverview[widget.collectionID]!;
        final bool needsRebuild = _expanded != current.expandedCollectionsOverview[widget.collectionID]!;
        _expanded = newExpanded;
        _tileIcon = _expanded ? _TILE_ICON_WHEN_EXPANDED : _TILE_ICON_WHEN_COLLAPSED;
        if (needsRebuild && _expanded) {
          _getCollectionByIdFuture = _performQuery();
        }
        return needsRebuild;
      },
      builder: (context, state) {
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
                  if (state.isCollectionActive(widget.collectionID))
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
          },
        );
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

  void _processExpandButtonPressed() {
    if(!_expanded) {
      _appBloc.add(CollectionExpanded(widget.collectionID));
    } else {
      _appBloc.add(CollectionCollapsed(widget.collectionID));
    }
  }

}
