import 'package:flutter/material.dart';

extension ThemeText on TextTheme {
  TextStyle get defaultNormalText =>
      const TextStyle(fontWeight: FontWeight.w400);
  TextStyle get defaultBoldText => const TextStyle(fontWeight: FontWeight.w700);
  TextStyle get defaultSemiBoldText =>
      const TextStyle(fontWeight: FontWeight.w600);
  TextStyle get defaultMediumText =>
      const TextStyle(fontWeight: FontWeight.w500);
  TextStyle get normalText =>
      defaultNormalText.copyWith(fontWeight: FontWeight.w400);
  TextStyle get normal24Text => defaultNormalText.copyWith(fontSize: 24);
  TextStyle get normal22Text => defaultNormalText.copyWith(fontSize: 22);
  TextStyle get normal10Text => defaultNormalText.copyWith(fontSize: 10);
  TextStyle get normal16Text => defaultNormalText.copyWith(fontSize: 16);
  TextStyle get normal14Text => defaultNormalText.copyWith(fontSize: 14);
  TextStyle get normal12Text => defaultNormalText.copyWith(fontSize: 12);
  TextStyle get normal8Text => defaultNormalText.copyWith(fontSize: 8);
  TextStyle get headerText => defaultMediumText.copyWith(fontSize: 18);
  TextStyle get titleText => defaultBoldText.copyWith(fontSize: 18);
  TextStyle get bold8Text => defaultBoldText.copyWith(fontSize: 8);
  TextStyle get bold14Text => defaultBoldText.copyWith(fontSize: 14);
  TextStyle get bold16Text => defaultBoldText.copyWith(fontSize: 16);
  TextStyle get bold12Text => defaultBoldText.copyWith(fontSize: 12);
  TextStyle get bold20Text => defaultBoldText.copyWith(fontSize: 20);
  TextStyle get bold24Text => defaultBoldText.copyWith(fontSize: 24);
  TextStyle get semiBold14Text => defaultSemiBoldText.copyWith(fontSize: 14);
  TextStyle get semiBold12Text => defaultSemiBoldText.copyWith(fontSize: 12);
  TextStyle get semiBold16Text => defaultSemiBoldText.copyWith(fontSize: 16);
  TextStyle get semiBold11Text => defaultSemiBoldText.copyWith(fontSize: 11);
  TextStyle get semiBold24Text => defaultSemiBoldText.copyWith(fontSize: 24);
  TextStyle get semiBold20Text => defaultSemiBoldText.copyWith(fontSize: 20);
  TextStyle get semiBold10Text => defaultSemiBoldText.copyWith(fontSize: 10);
  TextStyle get semiBold8Text => defaultSemiBoldText.copyWith(fontSize: 8);
  TextStyle get semiBold6Text => defaultSemiBoldText.copyWith(fontSize: 6);
  TextStyle get medium14Text => defaultMediumText.copyWith(fontSize: 14);
  TextStyle get medium10Text => defaultMediumText.copyWith(fontSize: 10);
  TextStyle get medium11Text => defaultMediumText.copyWith(fontSize: 11);
  TextStyle get medium8Text => defaultMediumText.copyWith(fontSize: 8);
  TextStyle get medium12Text => defaultMediumText.copyWith(fontSize: 12);
  TextStyle get textFieldText => defaultNormalText.copyWith(fontSize: 12);
  TextStyle get textFieldTitle => defaultMediumText.copyWith(fontSize: 10);
  TextStyle get medium16Text => defaultMediumText.copyWith(fontSize: 16);
  TextStyle get medium24Text => defaultMediumText.copyWith(fontSize: 24);
  TextStyle get subHeaderText => defaultNormalText.copyWith(fontSize: 24);
  TextStyle get buttonText => defaultMediumText.copyWith(fontSize: 16);
  TextStyle get bodyRegular => TextStyle(
    fontSize: 16,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    // height: 24,
    letterSpacing: 0,
  );
  TextStyle get subTextRegular => TextStyle(
    fontSize: 14,
    decoration: TextDecoration.none,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    // height: 21,
    letterSpacing: 0,
  );
}
