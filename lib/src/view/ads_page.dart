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
          Container(
              width: 375.w,
              height: 812.h,
              decoration: const BoxDecoration(color: ColorTheme.primary)),
          Positioned(
              top: 0,
              left: 0,
              child: Container(
                  width: 277.w,
                  height: 288.h,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(154)),
                      gradient: RadialGradient(colors: [
                        ColorTheme.primaryVariant,
                        ColorTheme.mask
                      ])))),
          Positioned(
              bottom: -75.h,
              right: -60.w,
              child: Container(
                  width: 338.w,
                  height: 406.h,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(154)),
                      gradient: RadialGradient(colors: [
                        ColorTheme.primaryVariant,
                        ColorTheme.mask
                      ])))),
          Center(
            child: Image.asset('assets/logo.png',
                fit: BoxFit.fill, width: 225.w, height: 65.h),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3000)).then((value) =>
        Navigator.pushNamedAndRemoveUntil(
            context, kRouteSelectLanguage, (route) => false));
  }
}
