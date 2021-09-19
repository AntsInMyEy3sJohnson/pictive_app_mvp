import 'package:equatable/equatable.dart';

class AppState extends Equatable {
  final int generation;
  final List<String> collectionIDs;
  final Map<String, bool> expandedCollectionsOverview;

  const AppState(
      this.generation, this.collectionIDs, this.expandedCollectionsOverview);

  factory AppState.dummyState() {
    return AppState(0, List.empty(growable: true), <String, bool>{});
  }

  AppState withCollapsedCollection(String collectionID) {
    final Map<String, bool> expandedCollapsedCollectionIDs =
        Map.from(this.expandedCollectionsOverview);
    expandedCollapsedCollectionIDs[collectionID] = false;
    return AppState(
        generation + 1, collectionIDs, expandedCollapsedCollectionIDs);
  }

  AppState withExpandedCollection(String collectionID) {
    final Map<String, bool> expandedCollectionsOverview =
        Map.from(this.expandedCollectionsOverview);
    _addAndExpandCollection(collectionID, expandedCollectionsOverview);
    return AppState(
        generation + 1, collectionIDs, expandedCollectionsOverview);
  }

  AppState withAddedCollectionsAndExpandedDefaultCollection(
      List<String> newCollectionIDs, String defaultCollectionID) {
    final List<String> collectionIDs = List.from(this.collectionIDs);
    collectionIDs.addAll(newCollectionIDs);
    final Map<String, bool> expandedCollectionsOverview =
        Map.from(this.expandedCollectionsOverview);
    newCollectionIDs.forEach((element) {
      if (element == defaultCollectionID) {
        expandedCollectionsOverview[element] = true;
      } else {
        expandedCollectionsOverview[element] = false;
      }
    });
    return AppState(
        generation + 1, collectionIDs, expandedCollectionsOverview);
  }

  AppState withAddedAndExpandedCollection(String collectionID) {
    final List<String> collectionIDs = List.of(this.collectionIDs);
    collectionIDs.add(collectionID);
    final Map<String, bool> expandedCollectionsOverview =
        Map.from(this.expandedCollectionsOverview);
    _addAndExpandCollection(collectionID, expandedCollectionsOverview);
    return AppState(generation + 1, collectionIDs, expandedCollectionsOverview);
  }

  bool isCollectionActive(String collectionID) {
    return this.expandedCollectionsOverview[collectionID] ?? false;
  }

  void _addAndExpandCollection(String collectionID, Map<String, bool> expandedCollectionsOverview) {
    expandedCollectionsOverview.updateAll((key, value) => false);
    expandedCollectionsOverview[collectionID] = true;
  }

  @override
  List<Object?> get props => [generation, collectionIDs];
}
