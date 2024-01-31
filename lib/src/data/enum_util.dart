enum PressureUnit {
  psi(0),
  kPa(1),
  bar(2);

  final int id;

  const PressureUnit(this.id);

  static PressureUnit fromInt(int value) {
    return PressureUnit.values.firstWhere((element) => element.id == value);
  }
}

enum TorqueUnit {
  nm(0),
  kgfcm(1);

  final int id;

  const TorqueUnit(this.id);

  static TorqueUnit fromInt(int value) {
    return TorqueUnit.values.firstWhere((element) => element.id == value);
  }
}
