import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tawd_ivm/src/route.dart';
import 'package:tawd_ivm/src/theme/style.dart';

class AdsPage extends StatefulWidget {
  const AdsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdsPageState();
}

// 產生初始畫面_AdsPageState，裡面有一個滿版的圖片，
// 還有一個大小為225dp × 65dp的圖片左右置中、向上偏移345dp的位置、向下偏移402dp的位置
// 並且有一個計數器，計數器計算到5秒後，從 Hive 資料庫中取得PairedDevice的資料，
// 如果PairedDevice的資料為空，則導向DeviceConnectPage，
// 如果PairedDevice的資料不為空，則導向DeviceListPage
class _AdsPageState extends State<AdsPage> {
  int _counter = 0;

  //裡面有一個滿版的圖片，
  //還有一個大小為225dp × 65dp的圖片左右置中、向上偏移345dp的位置、向下偏移402dp的位置
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Expanded(child: Container(
              width: 375.w,
              height: 812.h,
              decoration: const BoxDecoration(
                  color: ColorTheme.primary
              )
          )),
          Center(
            child: Image.asset(
                'assets/logo.png',
                fit: BoxFit.fill,
                width: 225.w,
                height: 65.h
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 5000)).then((value) =>
        Navigator.pushNamedAndRemoveUntil(
            context, kRouteScanPage, (route) => false));
  }
}