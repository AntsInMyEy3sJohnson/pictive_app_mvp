import 'package:equatable/equatable.dart';

class AppState extends Equatable {

  final int generation;
  final String activeCollectionID;
  final List<String> collectionIDs;

  const AppState(this.generation, this. activeCollectionID, this.collectionIDs);

  factory AppState.dummyState() {
    return AppState(0, "", List.empty(growable: true));
  }

  AppState copyWithNewActiveCollection(String newActiveCollectionID) {
    return AppState(generation + 1, newActiveCollectionID, collectionIDs);
  }

  AppState copyWithNewActiveCollectionAndAdditionalCollectionID(String newActiveCollectionID, String newCollectionID) {
    final List<String> collectionIDs = List.of(this.collectionIDs);
    collectionIDs.add(newCollectionID);
    return AppState(generation + 1, newActiveCollectionID, collectionIDs);
  }

  @override
  List<Object?> get props => [generation, collectionIDs];

}