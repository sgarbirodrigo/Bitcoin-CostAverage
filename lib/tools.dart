String doubleToValueString(double amount) {
  int numberOfDecimals = 7;
  int integerPart = amount.toInt();

  if (integerPart.toString().length >= numberOfDecimals) {
    numberOfDecimals = 0;
  } else {
    numberOfDecimals -= integerPart.toString().length;
  }
  double floatingPart = amount - integerPart;
  double trucatedFloatingPart =
      double.parse(floatingPart.toStringAsFixed(numberOfDecimals));

  double formattedNumber = double.parse((trucatedFloatingPart + integerPart).toStringAsFixed(numberOfDecimals));
  return formattedNumber.toString();
}

double getValueVariation(double price, double avg) {
  double result = avg / price;
  result = 1- result;
  return (result * 100);
}
