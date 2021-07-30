import 'dart:convert';
import 'package:Bit.Me/controllers/user_controller.dart';
import 'package:Bit.Me/models/binance_balance_model.dart';
import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BinanceController extends GetxController {
  var tickerPrices = Map<String, double>().obs;
  var balance = Balance().obs;

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

  Future<void> loadBalance(String publicKey, String privateKey) async {
    if (privateKey != null && publicKey != null) {
      int timeStamp = DateTime.now().millisecondsSinceEpoch;
      Map<String, dynamic> parameters = Map();
      parameters["recvWindow"] = "5000";
      parameters["timestamp"] = timeStamp.toString();
      String queryParams = 'recvWindow=5000&timestamp=' + timeStamp.toString();
      List<int> messageBytes = utf8.encode(queryParams);
      List<int> key = utf8.encode(privateKey);
      Hmac hmac = new Hmac(sha256, key);
      Digest digest = hmac.convert(messageBytes);
      String signature = digest.toString();
      parameters["signature"] = signature;
      Uri url = Uri.https("api.binance.com", "api/v3/account", parameters);
      http.Response response = await http.get(url, headers: {"X-MBX-APIKEY": publicKey});
      if (response.statusCode >= 200 && response.statusCode < 300) {
        this.balance.value = Balance.fromJson(jsonDecode(response.body));
      } else {
        this.balance.value = null;
      }
    } else {
      this.balance.value = null;
    }
  }
}
