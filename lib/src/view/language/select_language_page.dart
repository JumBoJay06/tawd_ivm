// 產生一個選擇語言的畫面，裡面有中文跟英文

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tawd_ivm/src/bloc/language/lang_bloc.dart';

import '../../../generated/l10n.dart';

class SelectLanguagePage extends StatelessWidget {
  const SelectLanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return _SelectLanguagePage();
  }

}

class _SelectLanguagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).language_choose_language),),
      body: BlocBuilder<LangBloc, LangState>(
        builder: (context, state) {
          // 實作語言 List 與勾勾
          return SizedBox();
        },
      ),
    );
  }

}