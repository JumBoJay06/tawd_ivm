class DigitsUtil {
  static List<int> extractDigits(int inputNumber) {
    // 取前四位
    int firstFourBits = (inputNumber & 0xF0) >> 4;

    // 取後四位
    int lastFourBits = inputNumber & 0x0F;

    return [firstFourBits, lastFourBits];
  }

  static int combineDigits(int firstFourBits, int lastFourBits) {
    // 將前四位左移4位，然後再or合併
    int combinedNumber = (firstFourBits << 4) | lastFourBits;

    return combinedNumber;
  }
}
