import 'package:flutter/material.dart';

const String arka_renk = "ffffff";
const String metin_renk = "7F8C99";
const String laci = "224ABE";
const String TextBox ="2ab4ff";
const String bubble = "4fb0ae";
const String api_key = "0cihdbscjnklsmxksmksmjdn";

class renk extends Color {
  static int _donustur(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }

    return int.parse(hexColor, radix: 16);
  }

  renk(final String renk_kodu) : super(_donustur(renk_kodu));
}
