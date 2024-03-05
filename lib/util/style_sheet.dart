// ignore_for_file: prefer_const_constructors

// import 'dart:math';

import 'package:flutter/material.dart';

class ColorForm {
  late Color main, text, light, dark, lightText, darkText;
  ColorForm(this.main, this.text) {
    HSLColor hsl = HSLColor.fromColor(main);
    light = hsl.withLightness((hsl.lightness + .1).clamp(0, 1)).toColor();
    dark = hsl
        .withLightness((hsl.lightness - .1).clamp(0, 1))
        .withSaturation((hsl.saturation + .1).clamp(0, 1))
        .toColor();
    hsl = HSLColor.fromColor(text);
    lightText = hsl.withLightness((hsl.lightness + .2).clamp(0, 1)).toColor();
    darkText = hsl
        .withLightness((hsl.lightness - .2).clamp(0, 1))
        .withSaturation((hsl.saturation + .2).clamp(0, 1))
        .toColor();
  }
}

class Palette {
  static final Map<String, Palette> _style = {"default": Palette(null)};
  static String _currentStyle = "default";

  ColorForm core = ColorForm(
    Color.fromARGB(255, 218, 218, 218),
    Color.fromARGB(255, 36, 18, 0),
  );
  ColorForm tint = ColorForm(
    Colors.deepOrange,
    Color.fromARGB(255, 63, 32, 0),
  );
  ColorForm input = ColorForm(
    Color.fromARGB(255, 241, 241, 241),
    Color.fromARGB(255, 36, 18, 0),
  );
  ColorForm button = ColorForm(
    Colors.deepPurple,
    Color.fromARGB(255, 224, 238, 234),
  );
  ColorForm link = ColorForm(
    Color.fromARGB(255, 36, 18, 0),
    Color.fromARGB(255, 22, 145, 246),
  );
  ColorForm error = ColorForm(
    Color.fromARGB(255, 214, 14, 0),
    Colors.black,
  );

  Palette(String? name,
      {ColorForm? core, ColorForm? tint, ColorForm? input, ColorForm? button}) {
    this.core = core ?? this.core;
    this.tint = tint ?? this.tint;
    this.input = input ?? this.input;
    this.button = button ?? this.button;

    if (name != null) _style[name] = this;
  }
  static void set(String name) {
    _currentStyle = _style[name] == null ? _currentStyle : name;
  }

  static Palette get() => _style[_currentStyle]!;

  static ColorForm getCore() => get().core;
  static ColorForm getTint() => get().tint;
  static ColorForm getInput() => get().input;
  static ColorForm getButton() => get().button;
  static ColorForm getLink() => get().link;
  static ColorForm getError() => get().error;
}
