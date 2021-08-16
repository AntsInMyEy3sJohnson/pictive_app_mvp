class QueryProvider {

  QueryProvider._();

  static String getUserByMailQuery() {
    return r'''
    query GetUserByMail($mail: String!){
      getUserByMail(mail: $mail){
        users {
          id
          mail
          ownedCollections {
            id
          }
          sharedCollections {
            id
            defaultCollection
          }
          defaultCollection {
            id
          }
          ownedImages {
            id
          }
        }
      }
    }
    ''';

  }

  static String getCollectionByIdQuery() {
    return r'''
    query GetCollectionByID($id: ID!) {
      getCollectionByID(id: $id) {
        collections {
          id
          displayName
          images {
            id
            preview
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