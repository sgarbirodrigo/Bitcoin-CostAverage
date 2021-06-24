import 'dart:ui';

import 'package:flutter/material.dart';
/*
List<Color> colorsList = [
  Color(0xff845bef),
  Color(0xffF47A1F),
  Color(0xff0293ee),
  Color(0xff13d38e),
  Color(0xfff8b250),
  Color(0xff67C3D0),
  Color(0xffE97B86),
  Color(0xff377B2B),
  Color(0xff7AC142),
  Color(0xff007CC3)
];*/
const List<Color> colorsList = [
  Color(0xff3366cc),
  Color(0xffdc3912),
  Color(0xffff9900),
  Color(0xff109618),
  Color(0xff990099),
  Color(0xff0099c6),
  Color(0xffdd4477),
  Color(0xff66aa00),
  Color(0xffb82e2e),
  Color(0xff316395),
  Color(0xff994499),
  Color(0xff22aa99),
  Color(0xffaaaa11),
  Color(0xff6633cc),
  Color(0xffe67300),
  Color(0xff8b0707),
  Color(0xff651067),
  Color(0xff329262),
  Color(0xff5574a6),
  Color(0xff3b3eac),
  Color(0xffb77322),
  Color(0xff16d620),
  Color(0xffb91383),
  Color(0xfff4359e),
  Color(0xff9c5935),
  Color(0xffa9c413),
  Color(0xff2a778d),
  Color(0xff668d1c),
  Color(0xffbea413),
  Color(0xff0c5922),
  Color(0xff743411),
];
//TO DO: add the API key for your app from the RevenueCat dashboard: https://app.revenuecat.com
const apiKey = 'bwzpyaCedynvkCMJndIPRCGLWesrHflv';

//TO DO: add the entitlement ID from the RevenueCat dashboard that is activated upon successful in-app purchase for the duration of the purchase.
const entitlementID = 'premium';

//TO DO: add your subscription terms and conditions
const footerText = "Don't forget to add your subscription terms and conditions.";


// UI Colors
const kColorBar = Colors.black;
const kColorText = Colors.white;
const kColorAccent = Color.fromRGBO(10, 115, 217, 1.0);
const kColorError = Colors.red;
const kColorSuccess = Colors.green;
const kColorNavIcon = Color.fromRGBO(131, 136, 139, 1.0);
const kColorBackground = Color.fromRGBO(30, 28, 33, 1.0);

// Weather Colors
const kWeatherReallyCold = Color.fromRGBO(3, 75, 132, 1);
const kWeatherCold = Color.fromRGBO(0, 39, 96, 1);
const kWeatherCloudy = Color.fromRGBO(51, 0, 58, 1);
const kWeatherSunny = Color.fromRGBO(212, 70, 62, 1);
const kWeatherHot = Color.fromRGBO(181, 0, 58, 1);
const kWeatherReallyHot = Color.fromRGBO(204, 0, 58, 1);

// Text Styles
const kFontSizeSuperSmall = 10.0;
const kFontSizeNormal = 16.0;
const kFontSizeMedium = 18.0;
const kFontSizeLarge = 96.0;

const kDescriptionTextStyle = TextStyle(
  color: kColorText,
  fontWeight: FontWeight.normal,
  fontSize: kFontSizeNormal,
);

const kTitleTextStyle = TextStyle(
  color: kColorText,
  fontWeight: FontWeight.bold,
  fontSize: kFontSizeMedium,
);

// Inputs
const kButtonRadius = 10.0;

const userInputDecoration = InputDecoration(
  fillColor: Colors.black,
  filled: true,
  hintText: 'Enter App User ID',
  hintStyle: TextStyle(color: kColorText),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(kButtonRadius)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 0),
    borderRadius: BorderRadius.all(Radius.circular(kButtonRadius)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(kButtonRadius)),
  ),
);