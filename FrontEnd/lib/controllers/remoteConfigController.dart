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
      //todo translate features
      'paywall_features':
          '{"en_US":[{"title": "Buy everyday", "description": "From Monday to Sunday"}, {"title": "Unlimited orders", "description": "Recurrent buys for your favorite investments"}],"pt_BR":[{"title": "Compre todos os dias", "description": "Selecione o dia da semana que você prefere comprar"}, {"title": "Compras ilimitadas", "description": "Compre as suas moedas preferidas nos melhores dias para você"}]}'
    });
  }

  bool isConnectingFirst() {
    return _remoteConfig.getBool('sequence_connect_before_paywall');
  }

  List<Map<String, String>> getPaywallFeatures() {

    Map<String, List<dynamic>> languages = Map<String, List<dynamic>>.from(json.decode(_remoteConfig.getString('paywall_features')));
    print("language:  ${languages["pt_BR"]}");
    print("locale: ${Get.locale}/${languages.keys} - ${languages.containsKey(Get.locale.toString())}");


    List<dynamic> selected_features;
    if(languages.keys.contains(Get.locale.toString())){
      selected_features = languages[Get.locale.toString()];
    }else{
      selected_features = languages["en_US"];
    }
    List<Map<String, String>> listao = new List();
    selected_features.forEach((element) {
      Map mapinho = Map<String, String>.from(element);
      listao.add(mapinho);
    });

    return listao;
  }
}
