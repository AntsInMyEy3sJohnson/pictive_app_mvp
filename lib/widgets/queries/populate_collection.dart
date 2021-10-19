import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:graphql/client.dart';
import 'package:pictive_app_mvp/data/collection/collection.dart';
import 'package:pictive_app_mvp/data/collection/collection_bag.dart';
import 'package:pictive_app_mvp/graphql/g_client_wrapper.dart';
import 'package:pictive_app_mvp/routes/image_grid_page.dart';
import 'package:pictive_app_mvp/state/app/app_bloc.dart';
import 'package:pictive_app_mvp/state/app/app_state.dart';
import 'package:pictive_app_mvp/state/app/events/collection_activated.dart';
import 'package:pictive_app_mvp/state/app/events/collection_deleted.dart';
import 'package:pictive_app_mvp/widgets/centered_circular_progress_indicator.dart';
import 'package:pictive_app_mvp/widgets/dialogs/delete_collection_dialog.dart';
import 'package:pictive_app_mvp/widgets/dialogs/dialog_helper.dart';
import 'package:pictive_app_mvp/widgets/loading_overlay.dart';

class PopulateCollection extends StatefulWidget {
  final String collectionID;

  const PopulateCollection(this.collectionID);

  @override
  _PopulateCollectionState createState() => _PopulateCollectionState();
}

class _PopulateCollectionState extends State<PopulateCollection> {
  // TODO Represent IconData as constants in other classes, too
  static const IconData _tileIcon = Icons.keyboard_arrow_right;
  static const String _getCollectionByIdQuery = r'''
    query GetCollectionByID($id: ID!) {
      getCollectionByID(id: $id) {
        collections {
          id
          displayName
          defaultCollection
          images {
            id
          }
          sharedWith {
            id
          }
        }
      }
    }
    ''';
  static const String _deleteCollectionByIdQuery = r'''
    mutation DeleteCollection(
      $collectionID: ID!
      $deleteContainedImages: Boolean!
    ) {
      deleteCollection(
        collectionID: $collectionID
        deleteContainedImages: $deleteContainedImages
      ) {
        collections {
          id
        }
      }
    }
  ''';

  late final AppBloc _appBloc;
  late bool _active;

  Future<QueryResult>? _getCollectionByIdFuture;

  @override
  void initState() {
    super.initState();
    _getCollectionByIdFuture = _performGetCollectionByIdQuery();
    _appBloc = context.read<AppBloc>();
    _active = _appBloc.state.isCollectionActive(widget.collectionID);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      buildWhen: (previous, current) {
        if (!current.doesCollectionExist(widget.collectionID)) {
          return false;
        }
        final bool newActiveState =
            current.activeCollectionsOverview[widget.collectionID]!;
        final bool needsRebuild = newActiveState != _active;
        _active = newActiveState;
        // Don't re-query Future in here, as this will lead to ugly visual
        // effects in the list. Rather, if collection data needs to be refreshed,
        // do so on-the-fly wherever it is required (e. g. collection deletion).
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
              final Size size = MediaQuery.of(context).size;
              final double horizontalPadding =
                  _active ? size.width * 0.02 : size.width * 0.03;
              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.001,
                  horizontal: horizontalPadding,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Slidable(
                      actionPane: const SlidableDrawerActionPane(),
                      actionExtentRatio: 0.3,
                      actions: [
                        if (!collection.defaultCollection!)
                          IconSlideAction(
                            caption: "Delete",
                            color: Theme.of(context).colorScheme.background,
                            icon: Icons.delete_forever,
                            onTap: () => _processCollectionDeleteTapped(
                              collection.id!,
                            ),
                          )
                      ],
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: const Color(0xffffb551),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            if (_active)
                              const BoxShadow(
                                color: Color(0xffffdb97),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: Offset(3, 5),
                              )
                          ],
                        ),
                        child: ListTile(
                          onTap: _changeCollectionActiveState,
                          leading: Container(
                            decoration:
                                const BoxDecoration(shape: BoxShape.circle),
                            // Enable user to pick a thumbnail for the collection
                            child: const Icon(Icons.image),
                          ),
                          title: Text("${collection.displayName}"),
                          trailing: ElevatedButton(
                            onPressed: () =>
                                _processShowCollectionButtonPressed(
                              collection.id!,
                              collection.displayName!,
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                            ),
                            child: const Icon(_tileIcon),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const Icon(Icons.error);
          },
        );
      },
    );
  }

  Future<void> _processCollectionDeleteTapped(String collectionID) async {
    final QueryResult getCollectionByIdResult =
        await GClientWrapper.getInstance().performQuery(
      _getCollectionByIdQuery,
      <String, dynamic>{'id': widget.collectionID},
    );
    final Collection refreshedCollection =
        _extractCollectionBag(getCollectionByIdResult).collections![0];
    final List<bool> shouldDeleteCollection =
        await const DialogHelper<List<bool>?>().show(
              context,
              DeleteCollectionDialog(
                refreshedCollection.displayName!,
                refreshedCollection.images?.length ?? 0,
                // List of users a collection is shared with must always
                // contain at least one user, namely, the collection owner
                refreshedCollection.sharedWith!.length,
              ),
            ) ??
            [];
    if (shouldDeleteCollection.isNotEmpty && shouldDeleteCollection[0]) {
      debugPrint("${shouldDeleteCollection[0]}, ${shouldDeleteCollection[1]}");
      final QueryResult deleteCollectionResult =
          await LoadingOverlay.of(context).during(
        _performDeleteCollectionByIdMutation(shouldDeleteCollection[1]),
      );
      if (deleteCollectionResult.hasException) {
        debugPrint(
          "Attempt to delete collection failed: ${deleteCollectionResult.exception}",
        );
        return;
      }
      _appBloc.add(CollectionDeleted(collectionID));
    }
  }

  void _changeCollectionActiveState() {
    if (!_active) {
      // In case of a collection activation, all other collections have to be deactivated
      _appBloc.add(CollectionActivated(widget.collectionID));
    }
    // Do nothing in case '_active' is true -- the collection has already been
    // active, so it can't be activated again
  }

  CollectionBag _extractCollectionBag(QueryResult queryResult) {
    return CollectionBag.fromJson(
      queryResult.data!["getCollectionByID"] as Map<String, dynamic>,
    );
  }

  Future<QueryResult> _performGetCollectionByIdQuery() {
    return GClientWrapper.getInstance().performQuery(
      _getCollectionByIdQuery,
      <String, dynamic>{'id': widget.collectionID},
    );
  }

  Future<QueryResult> _performDeleteCollectionByIdMutation(
    bool deleteContainedImages,
  ) {
    return GClientWrapper.getInstance().performQuery(
      _deleteCollectionByIdQuery,
      <String, dynamic>{
        'collectionID': widget.collectionID,
        'deleteContainedImages': deleteContainedImages
      },
    );
  }

  void _processShowCollectionButtonPressed(
    String collectionID,
    String collectionName,
  ) {
    Navigator.pushNamed(
      context,
      ImageGridPage.routeID,
      arguments: [collectionID, collectionName],
    );
  }
}
