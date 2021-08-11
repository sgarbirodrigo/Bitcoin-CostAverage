import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';

class RemoteConfigController extends GetxController {
  RemoteConfig _remoteConfig;

  @override
  void onInit() {
    super.onInit();
    _remoteConfig = RemoteConfig.instance;
    _remoteConfig.setDefaults(<String, dynamic>{
      'sequence_connect_before_paywall': false,
      'paywall_features': [
        {"title": "Buy everyday", "description": "From Monday to Sunday"},
        {"title": "Unlimited orders", "description": "Recurrent buys for your favorite investments"}
      ]
    });
  }

  bool isConnectingFirst() {
    return _remoteConfig.getBool('sequence_connect_before_paywall');
  }

  List<Map<String, String>> getPaywallFeatures() {
    String config = _remoteConfig.getValue('paywall_features').asString();
    print("config: ${config}");

    //final string1 = '{name : "Eduardo", numbers : [12, 23], country: us }';

    // remove all quotes from the string values
    final string2 = config.replaceAll("\"", "");

    // now we add quotes to both keys and Strings values
    final quotedString = string2.replaceAllMapped(RegExp(r'\b\w+\b'), (match) {
      return '"${match.group(0)}"';
    });
    print("quoted: ${quotedString}");

    return json.encode((config)) as List<Map<String, String>>;
    ;
  }
}
