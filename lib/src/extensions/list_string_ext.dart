
extension CommaSeparatedString on List<String?> {
  String toCommaSeparated() {
    return join(', ');
  }

  bool get isNotEmptyOrNull {
    return isNotEmpty;
  }
}
