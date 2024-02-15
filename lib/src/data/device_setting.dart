class DeviceSetting {
  final Item valveTorque;
  final Item emissionDetection;
  final Item valvePosition;
  final Item deviceLocation;
  final Item ledIndicator;
  final Item replaceBallValve;

  DeviceSetting({required this.valveTorque, required this.emissionDetection, required this.valvePosition, required this.deviceLocation, required this.ledIndicator, required this.replaceBallValve});
}

class Item {
  final String iconAsset;
  final String title;
  String? content1;
  String? content2;

  Item(this.iconAsset, this.title, {this.content1, this.content2});
}