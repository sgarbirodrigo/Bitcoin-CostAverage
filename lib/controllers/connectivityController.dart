import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../contants.dart';

class ConnectivityController extends GetxController {
  StreamSubscription<ConnectivityResult> subscription;
  var connectivityResult = ConnectivityResult.none.obs;

  @override
  void onInit() {
    super.onInit();
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      connectivityResult.value = result;
      if(this.isOffline()){
        callErrorSnackbar("Sorry :\'(","No internet connection.");
      }
    });
    _loadConnectivity();
  }

  _loadConnectivity() async {
    connectivityResult.value = await Connectivity().checkConnectivity();
  }
  isOffline(){
    print("conn: ${connectivityResult.value}");
    if(connectivityResult.value == ConnectivityResult.none){
      return true;
    }
    return false;
  }

  loadConnectivityAsync(Function(ConnectivityResult) onStatusChange) async {
    connectivityResult.value = await Connectivity().checkConnectivity();
    onStatusChange(connectivityResult.value);
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }
}
