class QueryProvider {

  QueryProvider._();



  static String getCollectionDisplayNamesQuery() {
    return r'''
      query {
        getCollections{
          collections{
            displayName
          }
        }
      }
    ''';
  }

}