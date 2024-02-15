enum RS485BaudRate {
  rate_4800,
  rate_9600,
  rate_19200,
  rate_38400,
  rate_57600,
  rate_115200;

  static RS485BaudRate? findRate(int valve) {
    try {
      return RS485BaudRate.values.firstWhere((element) => element.index == valve);
    } catch (e) {
      return null;
    }
  }
}