import 'dart:ui';

import 'package:tawd_ivm/src/theme/style.dart';

class AboutDeviceData {
  final List<Item> items;

  AboutDeviceData(this.items);
}

class Item {
  final String iconAsset;
  final String title;
  final String content;
  final bool isShowError;
  final Color ledIndicatorColor;

  Item(this.title, this.content,{ this.iconAsset = '', this.isShowError = false, this.ledIndicatorColor = ColorTheme.blue});
}
