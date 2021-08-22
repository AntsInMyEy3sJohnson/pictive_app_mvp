import 'package:equatable/equatable.dart';

class AppState extends Equatable {

  final int generation;
  final String collectionID;

  const AppState(this.generation, this.collectionID);

  factory AppState.dummyState() {
    return AppState(0, "");
  }

  AppState copyWithCollectionID(String newCollectionID) {
    return AppState(generation + 1, newCollectionID);
  }

  @override
  List<Object?> get props => [generation, collectionID];

}