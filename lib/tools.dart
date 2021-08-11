import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';

Future<bool> runAppVersionCheck()async {
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

  if (integerPart.toString().length >= numberOfDecimals) {
    numberOfDecimals = 0;
  } else {
    numberOfDecimals -= integerPart.toString().length;
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
  return NumberFormat.simpleCurrency(name: currencyCode).currencySymbol;
}

String returnCurrencyName(String currencyCode) {
  String name = NumberFormat.simpleCurrency(name: currencyCode).currencyName;
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
