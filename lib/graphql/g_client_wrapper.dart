import 'package:graphql/client.dart';

class GClientWrapper {
  static final GClientWrapper _theInstance = GClientWrapper._();
  late final GraphQLClient _graphQLClient;

  GClientWrapper._() {
    _graphQLClient = GraphQLClient(
      link: HttpLink("http://192.168.8.132:30080/graphql"),
      cache: GraphQLCache(),
    );
  }

  factory GClientWrapper.getInstance() {
    return _theInstance;
  }

  Future<QueryResult> performQuery(
    String query,
    Map<String, dynamic> variables, {
    FetchPolicy fetchPolicy = FetchPolicy.cacheAndNetwork,
  }) async {
    final QueryOptions queryOptions = QueryOptions(
      document: gql(query),
      variables: variables,
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );
    return _graphQLClient.query(queryOptions);
  }

  Future<QueryResult> performMutation(
    String mutation,
    Map<String, dynamic> variables,
  ) async {
    final MutationOptions mutationOptions =
        MutationOptions(document: gql(mutation), variables: variables);

    return _graphQLClient.mutate(mutationOptions);
  }
}
