import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../contants.dart';

class PurchaseController extends GetxController with StateMixin {
  var _purchaserInfo = Rx<PurchaserInfo>(null);
  var entitlementIsActive = false.obs;

  PurchaserInfo get purchaserInfo => _purchaserInfo.value;

  @override
  void onInit() {
    super.onInit();
  }

  void load() async {
    change(this, status: RxStatus.loading());
    try {
      await Purchases.setup(apiKey, observerMode: false);

      change(this, status: RxStatus.success());
    } catch (e) {
      change(this, status: RxStatus.error(e));
    }
  }

  void setUser(String uid) async {
    change(this, status: RxStatus.loading());
    try {
      await Purchases.identify(uid);
      Purchases.addPurchaserInfoUpdateListener((purchaserInfo) async {
        _purchaserInfo.value = purchaserInfo;
        (_purchaserInfo.value.entitlements.all[entitlementID] != null &&
            _purchaserInfo.value.entitlements.all[entitlementID].isActive)
            ? entitlementIsActive.value = true
            : entitlementIsActive.value = false;
        refresh();
      });
      change(this, status: RxStatus.success());
    } catch (e) {
      change(this, status: RxStatus.error(e));
    }
  }

  @override
  void onClose() {}

  @override
  void onReady() {}
}
