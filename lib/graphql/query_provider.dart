class QueryProvider {

  QueryProvider._();

  static String getCreateUserQuery() {
    return """
    mutation {
      createUserWithDefaultCollection(mail: "\$mail", password: "\$password") {
        users {
          id
          mail
          ownedCollections {
            id
          }
          sharedCollections {
            id
            displayName
          }
          defaultCollection {
            id
            displayName
          }
          ownedImages {
            id
          }
        }
      }
    }
    """;
  }

  static String getCollectionDisplayNamesQuery() {
    return """
      query {
        getCollections{
          collections{
            displayName
          }
        }
      }
    """;
  }

}