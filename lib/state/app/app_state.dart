import 'package:equatable/equatable.dart';

class AppState extends Equatable {
  final int generation;
  final List<String> collectionIDs;
  final Map<String, bool> expandedCollapsedCollectionIDs;

  const AppState(
      this.generation, this.collectionIDs, this.expandedCollapsedCollectionIDs);

  factory AppState.dummyState() {
    return AppState(0, List.empty(growable: true), <String, bool>{});
  }

  AppState withCollapsedCollection(String collectionID) {
    final Map<String, bool> expandedCollapsedCollectionIDs =
        Map.from(this.expandedCollapsedCollectionIDs);
    expandedCollapsedCollectionIDs[collectionID] = false;
    return AppState(
        generation + 1, collectionIDs, expandedCollapsedCollectionIDs);
  }

  AppState withExpandedCollection(String collectionID) {
    final Map<String, bool> expandedCollapsedCollectionIDs =
        Map.from(this.expandedCollapsedCollectionIDs);
    expandedCollapsedCollectionIDs.updateAll((key, value) {
      if (key == collectionID) {
        return true;
      }
      return false;
    });
    return AppState(
        generation + 1, collectionIDs, expandedCollapsedCollectionIDs);
  }

  AppState withAddedCollectionsAndExpandedDefaultCollection(
      List<String> newCollectionIDs, String defaultCollectionID) {
    final List<String> collectionIDs = List.from(this.collectionIDs);
    collectionIDs.addAll(newCollectionIDs);
    final Map<String, bool> expandedCollapsedCollectionIDs =
        Map.from(this.expandedCollapsedCollectionIDs);
    newCollectionIDs.forEach((element) {
      if (element == defaultCollectionID) {
        expandedCollapsedCollectionIDs[element] = true;
      } else {
        expandedCollapsedCollectionIDs[element] = false;
      }
    });
    return AppState(
        generation + 1, collectionIDs, expandedCollapsedCollectionIDs);
  }

  AppState withAddedAndExpandedCollection(String collectionID) {
    final List<String> collectionIDs = List.of(this.collectionIDs);
    collectionIDs.add(collectionID);
    final Map<String, bool> collectionActiveOverview =
        Map.from(this.expandedCollapsedCollectionIDs);
    // TODO Refactor commonly used functionality into own methods
    expandedCollapsedCollectionIDs.updateAll((key, value) {
      if (key == collectionID) {
        return true;
      }
      return false;
    });
    return AppState(generation + 1, collectionIDs, collectionActiveOverview);
  }

  bool isCollectionActive(String collectionID) {
    return this.expandedCollapsedCollectionIDs[collectionID] ?? false;
  }

  @override
  List<Object?> get props => [generation, collectionIDs];
}
