import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension ExtString on String? {
  bool get isValidEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(this!);
  }

  bool get isValidName {
    final nameRegExp = RegExp(
      r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$",
    );
    return nameRegExp.hasMatch(this!);
  }

  bool get isValidPassword {
    final passwordRegExp = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\><*~]).{8,}/pre>',
    );
    return passwordRegExp.hasMatch(this!);
  }

  bool isAValidPassword() {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(this!);
  }

  String toMSDN() {
    String mobileNumber = this!;
    String number = "";
    mobileNumber = mobileNumber.replaceAll(
      RegExp(r"\D"),
      '*',
    ); //RegExp.Replace(mobileNumber, @"\D+", "");

    if (mobileNumber.startsWith("0")) {
      if (mobileNumber.length == 11) {
        return mobileNumber;
      }
    }
    if (mobileNumber.startsWith("234")) {
      if (mobileNumber.length == 13) {
        number = mobileNumber;
      }
    } else if (mobileNumber.startsWith("+234")) {
      if (mobileNumber.length == 14) {
        mobileNumber = mobileNumber.substring(1, 13);
        number = mobileNumber;
      } else {
        number = mobileNumber;
      }
    } else {
      number = "+234";
      if (mobileNumber.length == 11) {
        number += mobileNumber.substring(1, 10);
      } else if (number.length == 10) {
        number += mobileNumber;
      } else {
        number = mobileNumber;
      }
    }
    return number;
  }

  String removeAllWhitespace() {
    // Remove all white space.
    return this!.replaceAll(RegExp(r"\s+"), "");
  }

  bool get isNullOrEmptyOrWhitespace {
    return this == null || this == "" || this!.trim().isEmpty;
  }

  bool get isNullOrEmpty => this == null || this == '';
  bool get isNotNullAndEmpty {
    // if (this != null) {
    //   return false;
    // } else {
    //   return this!.isNotEmpty;
    // }
    return !isNullOrEmpty; //this?.isNotEmpty ?? false;
  }

  bool get isNotEmptyOrNull {
    return this != null && this!.isNotEmpty;
  }

  bool get isNotNullAndAtLeastOneCharacter => this?.isNotEmpty ?? false;

  bool get isNotNull => this != null; //|| this!.isNotEmpty;

  bool get isValidPhone {
    final phoneRegExp = RegExp(r"^\+?0[0-9]{10}$");
    return phoneRegExp.hasMatch(this!);
  }

  String capitalize() {
    return this!.isNotNull
        ? "${this![0].toUpperCase()}${this!.substring(1).toLowerCase()}"
        : "";
  }

  String svg() {
    return this!.isNotNull ? "assets/images/$this.svg" : "";
  }

  Color toColor() {
    return Color(int.parse(this!.substring(1, 7), radix: 16) + 0xFF000000);
  }

  Color statusToColor() {
    switch (this!.toLowerCase()) {
      case 'processing':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      case 'completed':
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  double toDouble() => double.tryParse(this!) ?? 0.0;
  double toDoubleOrNull() {
    try {
      return double.parse(this!);
    } catch (e) {
      return 0.0; // or you can return null if you prefer
    }
  }

  int toIntegerOrNull() {
    try {
      return int.parse(this!);
    } catch (e) {
      return 0; // or you can return null if you prefer
    }
  }
  // String toCurrency() {
  //   try {
  //     // Locale locale = Localizations.localeOf(context);
  //     // String nairaSign = '₦';
  //     var format =
  //         NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'NGN');
  //     return toCurrencyString(
  //       this!,
  //       leadingSymbol: format.currencySymbol,
  //     );
  //     // return format.currencySymbol + this!;
  //   } catch (e) {
  //     return this!;
  //   }
  // }

  String maskLastNCharacters(int n) {
    if (n <= 0 || n >= this!.length) {
      return '*' * this!.length;
    }

    String maskedPart = '*' * n;
    String remainingPart = this!.substring(0, this!.length - n);

    return remainingPart + maskedPart;
  }

  String maskWithAsterisks(int startIndex, int endIndex) {
    if (startIndex < 0 || endIndex >= this!.length || startIndex > endIndex) {
      throw ArgumentError("Invalid start or end index");
    }

    final maskedPart = '*' * (endIndex - startIndex + 1);
    final unmaskedPart =
        this!.substring(0, startIndex) +
        maskedPart +
        this!.substring(endIndex + 1);

    return unmaskedPart;
  }

  String getCurrencySymbol() {
    try {
      var format = NumberFormat.simpleCurrency(
        locale: Platform.localeName,
        name: this, // Use the ISO code as the locale
      );
      return format.currencySymbol;
    } catch (e) {
      return toString();
    }
  }

  String toSentenceCase() {
    if (this == null) {
      return this!;
    }

    return "${this![0].toUpperCase()}${this!.substring(1).toLowerCase()}";
  }

  String toDateString() {
    try {
      if (this == null || this!.isEmpty) {
        return this!;
      }
      final DateTime dateTime = DateTime.parse(this!).toLocal();
      final DateFormat formatter = DateFormat('dd MMMM, yyyy. hh:mma');

      String formattedDate = formatter.format(dateTime);

      return formattedDate;
    } catch (e) {
      print('Error parsing date string: $e');
      return this ?? "";
    }
  }

  String toBp() {
    try {
      String formattedValue = '${this!.toString()} mmHg';
      return formattedValue;
    } catch (e) {
      return toString();
    }
  }

  String toBs() {
    try {
      String formattedValue = '${this!.toString()} mg/dl';
      return formattedValue;
    } catch (e) {
      return toString();
    }
  }

  String get nullToEmpty => this ?? '';

  String? get emptyToNull => this?.trim() == '' ? null : this;

  // String get capitalize {
  //   if (this == null) return '';
  //   return this![0].toUpperCase() + this!.substring(1);
  // }

  bool get isEmptyOrNull {
    if (this == null) return true;
    if (this!.isEmpty) return true;
    return false;
  }

  String get capitalizeAllFirst {
    if (this == null) return '';
    List<String> words = this!.split(" ");
    return words.map((e) => e.capitalize()).join(" ");
  }

  String pluralize([num? number]) {
    if (this == null) return '';
    if ((number ?? 1) > 1) return '${this!}s';
    return this!;
  }

  String? get firstLetter {
    if (this == null) return null;
    if (this!.trim().isEmpty) return null;
    return this![0];
  }
}
