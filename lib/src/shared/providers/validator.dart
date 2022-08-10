class Validator {
  String? validateString(String? value) {
    return value == null || value.trim().isEmpty ? 'Enter a valid value' : null;
  }
}
