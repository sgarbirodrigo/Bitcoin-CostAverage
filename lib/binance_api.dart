import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:hex/hex.dart';
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

Future<dynamic> getBinanceBalance(String userId,public_key,private_key) async {
  DocumentSnapshot documentSnapshot =
      await Firestore.instance.collection("users").document(userId).get();
  if (documentSnapshot.exists) {
    if (documentSnapshot.data != null) {
      if (documentSnapshot.data.length > 0) {
        //String private_key, public_key;
        if(public_key ==null && private_key==null) {
          if (documentSnapshot.data["private_key"] != null) {
            private_key = documentSnapshot.data["private_key"];
          }
          if (documentSnapshot.data["public_key"] != null) {
            public_key = documentSnapshot.data["public_key"];
          }
        }
        if (private_key != null && public_key != null) {
          int timeStamp = DateTime.now().millisecondsSinceEpoch;
          Map<String, dynamic> parameters = Map();
          parameters["recvWindow"] = "5000";
          parameters["timestamp"] = timeStamp.toString();
          String queryParams =
              'recvWindow=5000&timestamp=' + timeStamp.toString();
          List<int> messageBytes = utf8.encode(queryParams);
          List<int> key = utf8.encode(private_key);
          Hmac hmac = new Hmac(sha256, key);
          Digest digest = hmac.convert(messageBytes);
          String signature = digest.toString();
          parameters["signature"] = signature;
          Uri url = Uri.https("api.binance.com", "api/v3/account", parameters);
          //String queryParams = 'recvWindow=5000' + '&timestamp=' + timeStamp.toString();
          //String url = baseUrl + queryParams + "&signature=" + signature;
          print("url: ${url}");
          var response = await http.get(url, headers: {"X-MBX-APIKEY": public_key});
          print("${response.statusCode} / ${response.body}");
          if (response.statusCode >= 200 && response.statusCode < 300) {
            return jsonDecode(response.body);
          } else {
            print(jsonDecode(response.body)["msg"]);
            return null;
          }
        } else {
          //invalid document
          return null;
        }
      } else {
        //invalid document
        return null;
      }
    } else {
      //invalid document
      return null;
    }
  }

  /*
  final response =
  await http.get(Uri.https("api.binance.com", "api/v3/account"));
  if (response.statusCode == 200) {
    Map<String, double> entry = Map();
    (jsonDecode(response.body) as List<dynamic>).forEach((element) {
      entry[element["symbol"]] = double.parse(element["price"].toString());
    });
    return entry;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load pairs');
  }*/
}
