class HistoryLog {
  final int index;
  final int time;
  final double pressure;
  final int strainGauge;
  final double temperature; //°C °F
  final int valveAngle; //°

  HistoryLog(this.index, this.time, this.pressure, this.strainGauge, this.temperature, this.valveAngle);
}