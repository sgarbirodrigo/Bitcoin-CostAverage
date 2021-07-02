import 'dart:math';

import 'package:intl/intl.dart';

String doubleToValueString(double amount, {int decimal = 8}) {
  int numberOfDecimals = decimal + 1;
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
    double valueNoZeros = double.parse(doubleToValueString(value));
    return "${valueNoZeros} $currencySymbol";
  } else {
    return "$currencySymbol ${doubleToValueString(value, decimal: 2)}";
  }
}

double getTruncatedNumber(double input, {int precision = 2}) =>
    (input * pow(10, precision)).truncate() / pow(10, precision);

String getAppreciationConverted(double appreciation) {
  String nullValue = "0.00%";
  if (appreciation == null || appreciation.isNaN)  {
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
