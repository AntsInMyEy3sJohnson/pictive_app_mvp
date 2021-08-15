class QueryProvider {

  QueryProvider._();

  static String getCollectionByIdQuery() {
    return r'''
    query GetCollectionByID($id: ID!) {
      getCollectionByID(id: $id) {
        collections {
          id
          displayName
          images {
            id
          }
          owner {
            id
          }
        }
      }
    }
    ''';

  }


}