import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:tawd_ivm/src/util/dialog_widget_util.dart';

class DialogLoading {
  static void showLoading(String tag, {String content = ''}) {
    dismissLoading(tag);
    SmartDialog.show(
        clickMaskDismiss: false,
        backDismiss: false,
        tag: tag,
        builder: (context) {
          return DialogWidgetUtil.loadingDialog(context, content);
        });
  }

  static void dismissLoading(String tag) {
    SmartDialog.dismiss(tag: tag);
  }
}
