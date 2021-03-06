import 'dart:convert';
import 'package:bitcoin_cost_average/models/binance_balance_model.dart';
import 'package:bitcoin_cost_average/models/user_model.dart';
import 'package:crypto/crypto.dart';
import 'BinanceSymbolModel.dart';
import 'package:http/http.dart' as http;

import 'firestoreService.dart';

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
  } else {
    throw Exception('Failed to load pairs');
  }
}
/*
Future<bool> areUserKeysSavedCorrect(UserManager user) async {
  if ((await getBinanceBalance(user)) != null) {
    return true;
  } else {
    return false;
  }
}*/
Future<bool> areUserKeysNewCorrect(String private_key,String public_key) async {
  /*int timeStamp = DateTime.now().millisecondsSinceEpoch;
  Map<String, dynamic> parameters = Map();
  parameters["recvWindow"] = "5000";
  parameters["timestamp"] = timeStamp.toString();
  String queryParams = 'recvWindow=5000&timestamp=' + timeStamp.toString();
  List<int> messageBytes = utf8.encode(queryParams);
  List<int> key = utf8.encode(private_key);
  Hmac hmac = new Hmac(sha256, key);
  Digest digest = hmac.convert(messageBytes);
  String signature = digest.toString();
  parameters["signature"] = signature;
  Uri url = Uri.https("api.binance.com", "api/v3/account", parameters);
  http.Response response = await http.get(url, headers: {"X-MBX-APIKEY": public_key});
  print("ok: ${jsonDecode(response.body)["msg"]}");
  if (response.statusCode >= 200 && response.statusCode < 300) {
    return true;
  } else {
    print(jsonDecode(response.body)["msg"]);
    return false;
  }*/
  if(private_key.isEmpty || public_key.isEmpty){
    return false;
  }
  /*if(private_key.contains(" ") || public_key.contains(" ")){
    return false;
  }*/
  final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');
  if(!validCharacters.hasMatch(public_key) || !validCharacters.hasMatch(private_key)){
    return false;
  }
  return true;




}

/*

Future<Balance> getBinanceBalance(UserManager user) async {
  UserData userData = await FirestoreDB.getUserData(user.firebaseUser.uid);
  if (userData != null) {
    if (userData.private_key != null && userData.public_key != null) {
      int timeStamp = DateTime.now().millisecondsSinceEpoch;
      Map<String, dynamic> parameters = Map();
      parameters["recvWindow"] = "5000";
      parameters["timestamp"] = timeStamp.toString();
      String queryParams = 'recvWindow=5000&timestamp=' + timeStamp.toString();
      List<int> messageBytes = utf8.encode(queryParams);
      List<int> key = utf8.encode(userData.private_key);
      Hmac hmac = new Hmac(sha256, key);
      Digest digest = hmac.convert(messageBytes);
      String signature = digest.toString();
      parameters["signature"] = signature;
      Uri url = Uri.https("api.binance.com", "api/v3/account", parameters);
      http.Response response = await http.get(url, headers: {"X-MBX-APIKEY": userData.public_key});
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Balance.fromJson(jsonDecode(response.body));
      } else {
        print(jsonDecode(response.body)["msg"]);
        return null;
      }
    }
  }
}
*/
