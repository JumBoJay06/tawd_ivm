import 'dart:typed_data';

import 'package:logging/logging.dart';

class BytesToInt {
  static Logger get _logger => Logger("BytesToInt");

  static convert(List<int> list) {
    var length = list.length;

    switch (length) {
      case 1:
        return list[0];

      case 2:
        return toInt16(list);

      case 4:
        return toInt32(list);

      default:
        _logger.shout("無法轉換 -> $list");
        break;
    }
  }

//byte[] to int

  static int toInt16(List<int> list, {int index = 0}) {
    Uint8List byteArray = Uint8List.fromList(list);

    ByteBuffer buffer = byteArray.buffer;

    ByteData data = ByteData.view(buffer);

    int short = data.getInt16(index, Endian.big);

    return short;
  }

  static int toInt32(List<int> list, {int index = 0}) {
    Uint8List byteArray = Uint8List.fromList(list);

    ByteBuffer buffer = byteArray.buffer;

    ByteData data = ByteData.view(buffer);

    int short = data.getInt32(index, Endian.big);

    return short;
  }

  static int toInt64(List<int> list, {int index = 0}) {
    Uint8List byteArray = Uint8List.fromList(list);

    ByteBuffer buffer = byteArray.buffer;

    ByteData data = ByteData.view(buffer);

    int short = data.getInt64(index, Endian.big);

    return short;
  }
}
