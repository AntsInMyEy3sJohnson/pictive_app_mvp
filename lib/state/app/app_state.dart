import 'package:equatable/equatable.dart';

class AppState extends Equatable {
  final int generation;
  final String defaultCollectionID;
  final List<String> collectionIDs;
  final Map<String, bool> activeCollectionsOverview;

  const AppState(
    this.generation,
    this.defaultCollectionID,
    this.collectionIDs,
    this.activeCollectionsOverview,
  );

  factory AppState.dummyState() {
    return AppState(0, "", List.empty(growable: true), const <String, bool>{});
  }

  AppState withDeactivatedCollection(String collectionID) {
    final Map<String, bool> activeCollectionsOverview =
        Map.from(this.activeCollectionsOverview);
    activeCollectionsOverview[collectionID] = false;
    return AppState(
      generation + 1,
      defaultCollectionID,
      collectionIDs,
      activeCollectionsOverview,
    );
  }

  AppState withActivatedCollection(String collectionID) {
    final Map<String, bool> activeCollectionsOverview =
        Map.from(this.activeCollectionsOverview);
    _activateCollection(collectionID, activeCollectionsOverview);
    return AppState(
      generation + 1,
      defaultCollectionID,
      collectionIDs,
      activeCollectionsOverview,
    );
  }

  AppState withAddedCollectionsAndActivatedDefaultCollection(
    List<String> newCollectionIDs,
    String defaultCollectionID,
  ) {
    final List<String> collectionIDs = List.from(this.collectionIDs);
    collectionIDs.addAll(newCollectionIDs);
    final Map<String, bool> activeCollectionsOverview =
        Map.from(this.activeCollectionsOverview);
    for (final String id in newCollectionIDs) {
      if (id == defaultCollectionID) {
        activeCollectionsOverview[id] = true;
      } else {
        activeCollectionsOverview[id] = false;
      }
    }
    return AppState(
      generation + 1,
      defaultCollectionID,
      collectionIDs,
      activeCollectionsOverview,
    );
  }

  AppState withAddedAndActivatedCollection(String collectionID) {
    final List<String> collectionIDs = List.of(this.collectionIDs);
    collectionIDs.add(collectionID);
    final Map<String, bool> activeCollectionsOverview =
        Map.from(this.activeCollectionsOverview);
    _activateCollection(collectionID, activeCollectionsOverview);
    return AppState(
      generation + 1,
      defaultCollectionID,
      collectionIDs,
      activeCollectionsOverview,
    );
  }

  AppState withNextGeneration() {
    return AppState(
      generation + 1,
      defaultCollectionID,
      collectionIDs,
      activeCollectionsOverview,
    );
  }

  String? getIdOfActiveCollection() {
    return activeCollectionsOverview.keys.firstWhere(
      (element) => activeCollectionsOverview[element]!,
      orElse: () => defaultCollectionID,
    );
  }

  bool isCollectionActive(String collectionID) {
    return activeCollectionsOverview[collectionID] ?? false;
  }

  void _activateCollection(
    String collectionID,
    Map<String, bool> activeCollectionsOverview,
  ) {
    activeCollectionsOverview.updateAll((key, value) => false);
    activeCollectionsOverview[collectionID] = true;
  }

  @override
  List<Object?> get props => [generation, collectionIDs];
}
