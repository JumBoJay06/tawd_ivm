import 'enum_util.dart';

class AutomatedTestingResult {
  final ItemState isValvePositionState;
  final ItemState isValveTorqueState;
  final ItemState isEmissionDetectionState;
  final ItemState isIvmTempState;
  final bool isSuccess;

  AutomatedTestingResult(this.isValvePositionState, this.isValveTorqueState, this.isEmissionDetectionState, this.isIvmTempState, this.isSuccess);
}