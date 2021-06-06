import 'dart:convert';

import 'BinanceSymbolModel.dart';
import 'package:http/http.dart' as http;

Map<String, BinanceSymbol> listOfSymbols;

Future<Map<String, double>> fetchBinancePairData() async {
  final response =
      await http.get(Uri.https("api.binance.com", "api/v3/ticker/price"));
  if (response.statusCode == 200) {
    Map<String, double> entry = Map();
    (jsonDecode(response.body) as List<dynamic>).forEach((element) {
      entry[element["symbol"]] = double.parse(element["price"].toString());
    });
    return entry;

    /*List symbols = jsonDecode(response.body)["symbols"];
    listOfSymbols = Map();
    symbols.forEach((element) {
      listOfSymbols[BinanceSymbol.fromJson(element).symbol] =
          BinanceSymbol.fromJson(element);
    });
    return listOfSymbols;*/
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load pairs');
  }
}
