import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tawd_ivm/route.dart';
import 'package:tawd_ivm/src/theme/style.dart';

class AdsPage extends StatefulWidget {
  const AdsPage({super.key});

  @override
  State<StatefulWidget> createState() => _AdsPageState();
}

class _AdsPageState extends State<AdsPage> {

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