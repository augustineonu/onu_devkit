extension IntOperations on int {
  String get itemsFormatted {
    if (this <= 0) {
      return 'No items';
    } else if (this == 1) {
      return '$this item';
    } else {
      return '$this items';
    }
  }
}
