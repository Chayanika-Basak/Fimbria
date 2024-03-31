import 'package:flutter/material.dart';

final LinearGradient linearGradient = LinearGradient(
  colors: colors,
  stops: <double>[0.5,1],
  // Setting alignment for the series gradient
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
);

List<Color> colors = <Color>[
  Color.fromARGB(255, 131, 220, 135)!,
  Color.fromARGB(255, 254, 93, 93)!,
];
