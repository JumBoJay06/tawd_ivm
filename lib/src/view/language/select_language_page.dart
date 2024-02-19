// 產生一個選擇語言的畫面，裡面有中文跟英文

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tawd_ivm/route.dart';

import '../../../generated/l10n.dart';
import '../../bloc/language/lang_bloc.dart';
import '../../theme/style.dart';

class SelectLanguagePage extends StatelessWidget {
  const SelectLanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return _SelectLanguagePage();
  }
}

class _SelectLanguagePage extends StatefulWidget {
  @override
  State<_SelectLanguagePage> createState() => _SelectLanguagePageState();
}

class _SelectLanguagePageState extends State<_SelectLanguagePage> {
  int selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              S.of(context).language_choose_language,
              style: const TextStyle(color: ColorTheme.fontColor),
            ),
          ),
          flexibleSpace: const Image(
            image: AssetImage('assets/header_bg_1.png'),
            fit: BoxFit.fill,
          ),
        ),
        body: Stack(
          children: [
            _createHeaderIcon(context),
            _createLangList(context),
            _createSaveButton(context)
          ],
        ));
  }

  Widget _createLangList(BuildContext context) {
    return Positioned(
        left: 16.w,
        right: 16.w,
        top: 201.h,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 407.h),
          child: ListView.builder(
              itemCount: ELanguage.values.length,
              itemBuilder: (BuildContext context, int index) {
                return _createListItem(context, index);
              }),
        ));
  }

  Widget _createListItem(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          selectIndex = index;
        });
      },
      child: SizedBox(
        height: 64.w,
        width: 343.w,
        child: Stack(
          children: [
            _createCheckWidget(index),
            _createLangWidget(context, index),
            _createDivide()
          ],
        ),
      ),
    );
  }

  Widget _createCheckWidget(int index) {
    if (selectIndex == index) {
      return Positioned(
          left: 8.w,
          top: 20.h,
          bottom: 20.h,
          child: Image.asset(
            'assets/icon_check.png',
            width: 24.w,
            height: 24.h,
          ));
    } else {
      return Positioned(
          left: 8.w,
          top: 20.h,
          bottom: 20.h,
          child: SizedBox(
            width: 24.w,
            height: 24.h,
          ));
    }
  }

  Widget _createLangWidget(BuildContext context, int index) {
    return Stack(
      children: [
        Positioned(
            left: 40.w,
            top: 16.h,
            bottom: 16.h,
            child: _getItemImage(context, index)),
        Positioned(
            left: 88.w,
            top: 0,
            bottom: 0,
            child: Center(
              child: Text(_getItemName(context, index),
                  style: TextStyle(
                      color: ColorTheme.primary,
                      fontWeight: FontWeight.w500,
                      fontFamily: "SFProDisplay",
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0.sp)),
            ))
      ],
    );
  }

  Widget _createDivide() {
    return Positioned(
        top: 63.h,
        left: 0,
        right: 0,
        child: Container(
            width: 343.w,
            height: 1.h,
            decoration:
                const BoxDecoration(color: ColorTheme.primaryAlpha_10)));
  }

  Widget _createSaveButton(BuildContext context) {
    return Positioned(
        left: 16.w,
        right: 16.w,
        bottom: 48.h,
        child: GestureDetector(
          onTap: () async {
            final lang = ELanguage.values[selectIndex];
            switch (lang) {
              case ELanguage.en:
                context.read<LangBloc>().add(SettingLangEn());
                break;
              case ELanguage.zh:
                context.read<LangBloc>().add(SettingLangZhTW());
                break;
            }
            Navigator.pushNamed(context, kRouteScanStartPage);
          },
          child: Container(
            width: 343.w,
            height: 56.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30.h)),
              boxShadow: const [
                BoxShadow(
                    color: ColorTheme.primary,
                    offset: Offset(0, 10),
                    blurRadius: 25,
                    spreadRadius: 0)
              ],
              gradient: const LinearGradient(
                  begin: Alignment(0.6116728186607361, 0),
                  end: Alignment(0.37270376086235046, 1.0995962619781494),
                  colors: [ColorTheme.primaryGradient, ColorTheme.primary]),
            ),
            child: Center(
              child: Text(
                S.of(context).language_finish_setting,
                style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorTheme.fontColor),
              ),
            ),
          ),
        ));
  }

  Widget _createHeaderIcon(BuildContext context) {
    return Positioned(
        top: 16.h,
        right: 67.w,
        left: 67.w,
        child: Align(
          child: SizedBox(
            width: 240.w,
            height: 185.h,
            child: Stack(
              children: [
                Align(
                  child: Image.asset(
                    'assets/background_round.png',
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height,
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0, 1),
                  child: Image.asset(
                    'assets/icon_language.png',
                    width: 145.w,
                    height: 145.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  String _getItemName(BuildContext context, int index) {
    String name = '';

    if (index < ELanguage.values.length) {
      final lang = ELanguage.values[index];
      switch (lang) {
        case ELanguage.en:
          name = 'English';
          break;
        case ELanguage.zh:
          name = '中文';
          break;
      }
    }

    return name;
  }

  Image _getItemImage(BuildContext context, int index) {
    Image image = Image.asset(
      'assets/icon_flag_zh.png',
      width: 32.w,
      height: 32.h,
    );

    if (index < ELanguage.values.length) {
      final lang = ELanguage.values[index];
      switch (lang) {
        case ELanguage.en:
          image = Image.asset(
            'assets/icon_flag_en.png',
            width: 32.w,
            height: 32.h,
          );
          break;
        case ELanguage.zh:
          image = Image.asset(
            'assets/icon_flag_zh.png',
            width: 32.w,
            height: 32.h,
          );
          break;
      }
    }

    return image;
  }
}

enum ELanguage { zh, en }
