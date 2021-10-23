extension ElseEmpty on String? {
  /// Essentially converts String? to String by replacing null with empty string.
  String elseEmpty() {
    return this ?? '';
  }
}
