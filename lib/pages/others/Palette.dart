import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor kToDark = MaterialColor(
    0xffb7bb9b9,
    // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xffb7bb9b9), //10%
      100: Color(0xffb7bb9b9), //20%
      200: Color(0xffb7bb9b9), //30%
      300: Color(0xffb7bb9b9), //40%
      400: Color(0xffb7bb9b9), //50%
      500: Color(0xffb7bb9b9), //60%
      600: Color(0xffb7bb9b9), //70%
      700: Color(0xffb7bb9b9), //80%
      800: Color(0xffb7bb9b9), //90%
      900: Color(0xffb7bb9b9), //100%
    },
  );
}
