class MutationProvider {

  MutationProvider._();

  static String createUserMutation() {
    return r'''
    mutation CreateUserWithDefaultCollection($mail: String!, $password: String!) {
      createUserWithDefaultCollection(mail: $mail, password: $password) {
        users {
          id
          mail
          ownedCollections {
            id
          }
          sharedCollections {
            id
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

}