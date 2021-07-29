class GenericInputValidation {

  GenericInputValidation._();

  static String? stringValidation(String? value) {
    if (_isNullOrEmpty(value)) {
      return "Must not be empty";
    }
    return null;
  }

  static bool _isNullOrEmpty(String? value) {
    return value == null || value.isEmpty;
  }

}