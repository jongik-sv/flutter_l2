import 'package:acutal/common/const/colors.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autofocus;
  final String initValue;
  final ValueChanged<String>? onChanged;

  const CustomTextFormField(
      {Key? key, this.hintText, this.errorText, this.obscureText = false, this.autofocus = false, this.onChanged, this.initValue = '',})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: INPUT_BORDER_COLOR,
        width: 1.0,
      ),
    );

    return TextFormField(
      cursorColor: PRIMARY_COLOR,
      obscureText: obscureText,
      autofocus: autofocus,
      onChanged: onChanged,
      initialValue: initValue,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(20),
        // 안으로 들여쓰기
        hintText: hintText,
        errorText: errorText,
        hintStyle: const TextStyle(
          color: BODY_TEXT_COLOR,
          fontSize: 14,
        ),
        fillColor: INPUT_BG_COLOR,
        filled: true,
        // true : 색상 배경색 적용
        border: baseBorder,
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(
            color: PRIMARY_COLOR,
          ),
        ),
      ),
    );
  }
}

class CTFF extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool autofocus;
  final bool obscureText;
  final ValueChanged<String>? onChange;

  const CTFF(
      {Key? key, this.hintText, this.errorText, this.autofocus = false, this.obscureText = false, this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseBorder = OutlineInputBorder(borderSide: BorderSide(color: INPUT_BORDER_COLOR, width: 1.0));

    return TextFormField(
      autofocus: autofocus,
      obscureText: obscureText,
      onChanged: onChange,
      cursorColor: PRIMARY_COLOR,
      decoration: buildInputDecoration(baseBorder),
    );
  }

  InputDecoration buildInputDecoration(OutlineInputBorder baseBorder) {
    return InputDecoration(
        contentPadding: EdgeInsets.all(20),
        hintText: hintText,
        errorText: errorText,
        hintStyle: TextStyle(color: BODY_TEXT_COLOR, fontSize: 14),
        filled: true,
        fillColor: INPUT_BG_COLOR,
        border: baseBorder,
        focusedBorder: focusedBorder(baseBorder)
    );
  }

  OutlineInputBorder focusedBorder(OutlineInputBorder baseBorder) {
    return baseBorder.copyWith(
        borderSide: baseBorder.borderSide.copyWith(color: PRIMARY_COLOR)
    );
  }
}
