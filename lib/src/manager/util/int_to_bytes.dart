class IntToBytes {
  static List<int> convertToIntList(int value, int length) {
    if (length != 1 && length != 2 && length != 4) {
      throw ArgumentError("Unsupported length. Supported lengths are 1, 2, and 4.");
    }

    switch (length) {
      case 1:
        return [value & 0xFF];
      case 2:
        return [(value >> 8) & 0xFF, value & 0xFF];
      case 4:
        return [
          (value >> 24) & 0xFF,
          (value >> 16) & 0xFF,
          (value >> 8) & 0xFF,
          value & 0xFF,
        ];
      default:
        return [];
    }
  }
}