
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
class BinanceController extends GetxController{
  var tickerPrices = Map<String, double>().obs;

  @override
  void onInit() {
    super.onInit();
    loadPrices();
  }

  Future<void> loadPrices() async {
    final response = await http.get(Uri.https("api.binance.com", "api/v3/ticker/price"));
    if (response.statusCode == 200) {
      Map<String, double> entry = Map();
      (jsonDecode(response.body) as List<dynamic>).forEach((element) {
        entry[element["symbol"]] = double.parse(element["price"].toString());
      });
      tickerPrices.value = entry;

    } else {
      tickerPrices.value = null;
      print("response binance: ${response.body}");
    }
  }
}