import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:get/get.dart';

Future<bool> runAppVersionCheck() async {
  //control app version
  bool appUpdated = true;
  try {
    if (Platform.isAndroid || Platform.isIOS) {
      appUpdated = await checkAppVersion();
    }
  } catch (e) {
    appUpdated = true;
  }
  return appUpdated;
}

String getDateWeekDayName(DateTime date) {
  switch (date.weekday) {
    case 1:
      return "Monday".tr;
    case 2:
      return "Tuesday".tr;
    case 3:
      return "Wednesday".tr;
    case 4:
      return "Thursday".tr;
    case 5:
      return "Friday".tr;
    case 6:
      return "Saturday".tr;
    case 7:
      return "Sunday".tr;
  }
}

String getShortMonthName(DateTime date) {
  switch (date.month) {
    case 1:
      return 'Jan'.tr;
    case 2:
      return 'Feb'.tr;
    case 3:
      return 'Mar'.tr;
    case 4:
      return 'Apr'.tr;
    case 5:
      return 'May_short'.tr;
    case 6:
      return 'Jun'.tr;
    case 7:
      return 'Jul'.tr;
    case 8:
      return 'Aug'.tr;
    case 9:
      return 'Sep'.tr;
    case 10:
      return 'Oct'.tr;
    case 11:
      return 'Nov'.tr;
    case 12:
      return 'Dec'.tr;
  }
}

String getLongMonthName(DateTime date) {
  switch (date.month) {
    case 1:
      return 'January'.tr;
    case 2:
      return 'February'.tr;
    case 3:
      return 'March'.tr;
    case 4:
      return 'April'.tr;
    case 5:
      return 'Maio'.tr;
    case 6:
      return 'June'.tr;
    case 7:
      return 'July'.tr;
    case 8:
      return 'August'.tr;
    case 9:
      return 'September'.tr;
    case 10:
      return 'October'.tr;
    case 11:
      return 'November'.tr;
    case 12:
      return 'December'.tr;
  }
}

Future<bool> checkAppVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String appName = packageInfo.appName;
  String packageName = packageInfo.packageName;
  String version = packageInfo.version;
  String buildNumber = packageInfo.buildNumber;

  DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
  await FirebaseFirestore.instance.collection("appConfig").doc("standard").get();
  var data = documentSnapshot.data();
  bool result = int.parse(buildNumber) >= int.parse(data["min_version_build"].toString());
  return result;
}

String doubleToValueString(double amount, {int decimal = 8}) {
  int numberOfDecimals = decimal + 1;
  if (amount == null) {
    amount = 0;
  }
  int integerPart = amount.truncate();

  if (integerPart
      .toString()
      .length >= numberOfDecimals) {
    numberOfDecimals = 0;
  } else {
    numberOfDecimals -= integerPart
        .toString()
        .length;
  }

  double finalNumber = getTruncatedNumber(amount, precision: numberOfDecimals);
  //print("amount: ${amount} - dec:${decimal} - final: ${finalNumber}");
  return finalNumber.toStringAsFixed(decimal);
}

double getValueVariation(double price, double avg) {
  double result = avg / price;
  result = 1 - result;
  return (result * 100);
}

String getCurrencySymbolFromCode(String currencyCode) {
  return NumberFormat
      .simpleCurrency(name: currencyCode)
      .currencySymbol;
}

String returnCurrencyName(String currencyCode) {
  String name = NumberFormat
      .simpleCurrency(name: currencyCode)
      .currencyName;
  return name;
}

String returnCurrencyCorrectedNumber(String currencyCode, double value) {
  String currencySymbol = getCurrencySymbolFromCode(currencyCode);
  if (currencyCode == currencySymbol) {
    //print("$currencyCode: $value");
    double valueNoZeros = double.parse(doubleToValueString(value));
    //Decimal decimal = Decimal;
    Decimal convertedNum = Decimal.parse(valueNoZeros.toString());
    return "$convertedNum $currencySymbol";
  } else {
    return "$currencySymbol ${doubleToValueString(value, decimal: 2)}";
  }
}

double getTruncatedNumber(double input, {int precision = 2}) =>
    (input * pow(10, precision)).truncate() / pow(10, precision);

String getAppreciationConverted(double appreciation) {
  String nullValue = "0.00%";
  if (appreciation == null || appreciation.isNaN) {
    return nullValue;
  }
  String arrow = "";
  if (appreciation < 0) {
    arrow = "\u25BC";
  } else if (appreciation > 0) {
    arrow = "\u25B2";
  } else {
    arrow = "";
  }
  return "$arrow${(appreciation.abs()).toStringAsFixed(2)}%";
}
