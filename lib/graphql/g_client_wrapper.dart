import 'package:graphql/client.dart';
import 'package:pictive_app_mvp/graphql/mutation_provider.dart';
import 'package:pictive_app_mvp/graphql/query_provider.dart';

class GClientWrapper {
  static final GClientWrapper _theInstance = GClientWrapper._();
  late final GraphQLClient _graphQLClient;

  GClientWrapper._() {
    _graphQLClient = GraphQLClient(
      link: HttpLink("http://35.232.184.87:8080/graphql"),
      cache: GraphQLCache(),
    );
  }

  factory GClientWrapper.getInstance() {
    return _theInstance;
  }

  Future<QueryResult> performGetUserByMail(String mail) async {
    final QueryOptions queryOptions = QueryOptions(
      document: gql(QueryProvider.getUserByMailQuery()),
      variables: <String, dynamic>{'mail': mail}
    );
    return _graphQLClient.query(queryOptions);

  }

  Future<QueryResult> performGetCollectionByID(String id) async {
    final QueryOptions queryOptions = QueryOptions(
        document: gql(QueryProvider.getCollectionByIdQuery()),
        variables: <String, dynamic>{'id': id});
    return _graphQLClient.query(queryOptions);
  }

  Future<QueryResult> performCreateUser(String mail, String password) async {
    final MutationOptions mutationOptions = MutationOptions(
        document: gql(MutationProvider.createUserMutation()),
        variables: <String, dynamic>{'mail': mail, 'password': password});

    return _graphQLClient.mutate(mutationOptions);
  }
}
