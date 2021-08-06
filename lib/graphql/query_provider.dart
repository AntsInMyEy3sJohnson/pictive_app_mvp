class QueryProvider {

  QueryProvider._();

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