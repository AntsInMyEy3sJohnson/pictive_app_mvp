import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:pictive_app_mvp/data/collection/collection_bag.dart';
import 'package:pictive_app_mvp/graphql/query_provider.dart';
import 'package:pictive_app_mvp/state/events/user_event.dart';
import 'package:pictive_app_mvp/state/events/user_logged_in.dart';
import 'package:pictive_app_mvp/state/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  // TODO Move GraphQL stuff out of here
  // Maybe better use 'graphql_flutter' after all...
  late final GraphQLClient _graphQLClient;

  UserBloc(UserState initialState) : super(initialState) {
    _graphQLClient = GraphQLClient(
        link: HttpLink("http://104.198.129.127:8080/graphql"),
        cache: GraphQLCache());
  }

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is UserLoggedIn) {
      yield await _mapUserLoggedInToUserState(event);
    }
  }

  Future<UserState> _mapUserLoggedInToUserState(
      UserLoggedIn userLoggedIn) async {

    // User has logged in -- we can now query his collections
    // (Right now, this will return all collections)
    final QueryOptions queryOptions = QueryOptions(
      document: gql(QueryProvider.getCollectionDisplayNamesQuery()),
    );
    final result = await _graphQLClient.query(queryOptions);

    final collectionBag = CollectionBag.fromJson(result.data!["getCollections"]);

    return UserState(userLoggedIn.email, userLoggedIn.password);
  }
}
