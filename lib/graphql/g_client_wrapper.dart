import 'package:graphql/client.dart';
import 'package:pictive_app_mvp/graphql/mutation_provider.dart';

class GClientWrapper {
  static final GClientWrapper _theInstance = GClientWrapper._();
  late final GraphQLClient _graphQLClient;

  GClientWrapper._() {
    _graphQLClient = GraphQLClient(
      link: HttpLink("http://34.132.209.200:8080/graphql"),
      cache: GraphQLCache(),
    );
  }

  factory GClientWrapper.getInstance() {
    return _theInstance;
  }

  Future<QueryResult> performCreateUser(String mail, String password) async {
    final MutationOptions mutationOptions = MutationOptions(
        document: gql(MutationProvider.getCreateUserMutation()), variables: <String, dynamic>{
          'mail': mail, 'password': password
    });

    return _graphQLClient.mutate(mutationOptions);
  }
}
