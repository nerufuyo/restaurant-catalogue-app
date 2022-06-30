import 'package:flutter/material.dart';

var appTextStyle = const TextStyle(
  fontFamily: 'Fredoka',
  fontWeight: FontWeight.bold,
  fontSize: 25,
);
var subAppTextStyle = const TextStyle(
  fontFamily: 'Fredoka',
  fontWeight: FontWeight.normal,
  fontSize: 18,
);

var titleTextStyle = const TextStyle(
    fontFamily: 'OpenSans', fontWeight: FontWeight.bold, fontSize: 20);

var subTitleTextStyle = const TextStyle(
    fontFamily: 'OpenSans', fontWeight: FontWeight.bold, fontSize: 15);

var informationTextStyle = const TextStyle(
    fontFamily: 'OpenSans', fontWeight: FontWeight.normal, fontSize: 15);

var dateTextStyle = const TextStyle(
    fontFamily: 'OpenSans', fontWeight: FontWeight.normal, fontSize: 12);

var reviewTextStyle = const TextStyle(
    fontFamily: 'OpenSans', fontWeight: FontWeight.bold, fontSize: 12);

const Color black = Color(0xff040303);
const Color darkRed = Color(0xff461111);
const Color bloodRed = Color(0xffA13333);
const Color orange = Color(0xffB3541E);
const Color white = Color(0xffEEEEEE);

ThemeData lightTheme = ThemeData(
  primaryColor: bloodRed,
  scaffoldBackgroundColor: white,
  appBarTheme: AppBarTheme(
    titleTextStyle: appTextStyle,
    elevation: 2,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColor: bloodRed,
  scaffoldBackgroundColor: black,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  appBarTheme: AppBarTheme(
    backgroundColor: bloodRed,
    titleTextStyle: appTextStyle,
    elevation: 2,
  ),
);
