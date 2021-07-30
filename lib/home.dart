import 'package:Bit.Me/auth_pages/authentication.dart';
import 'package:Bit.Me/charts/line_chart_mean.dart';
import 'package:Bit.Me/contants.dart';
import 'package:Bit.Me/controllers/database_controller.dart';
import 'package:Bit.Me/controllers/purchase_controller.dart';
import 'package:Bit.Me/external/binance_api.dart';
import 'package:Bit.Me/pages/dashboard.dart';
import 'package:Bit.Me/pages/settings.dart';
import 'package:Bit.Me/models/settings_model.dart';
import 'package:Bit.Me/models/user_model.dart';
import 'package:Bit.Me/purchase/paywall.dart';
import 'package:Bit.Me/purchase/paywall_bca.dart';
import 'package:Bit.Me/purchase/paywall_bcav2.dart';
import 'package:Bit.Me/external/sql_database.dart';
import 'package:Bit.Me/widgets/bottomnavigation_bar.dart';
import 'package:Bit.Me/widgets/circular_progress_indicator.dart';
import 'package:Bit.Me/widgets/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'CreateEditOrder.dart';
import 'controllers/auth_controller.dart';
import 'controllers/connectivityController.dart';
import 'controllers/user_controller.dart';
import 'wizards/IntroductionConnectPage.dart';
import 'wizards/IntroductionPage.dart';
import 'pages/orders_Page.dart';

enum Section { LOGIN, DASHBOARD, ORDERS, HISTORY, SETTINGS }

class HomeController extends GetxController {
  var pageController = PageController(initialPage: 0).obs;
  var pages = [DashboardBitMe(), OrdersPage(), SettingsPage()];
  var pageIndex = 1.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void setPage(int index) {
    if (index != 0) {
      //print("jumping to $index");
      pageController.value.jumpToPage(index >= 1 ? index - 1 : index);
      pageIndex.value = index;
    } else {
      pageIndex.value = pageIndex.value;
    }
  }
}

class Home extends StatelessWidget {
  var authController = Get.find<AuthController>();
  var purchaseController = Get.find<PurchaseController>();
  var userController = Get.find<UserController>();
  var homeController = Get.put(HomeController());
  var connectivityController = Get.find<ConnectivityController>();

  SettingsApp settings;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // print("Home");
    return userController.obx(
        (_) {
          if (!userController.user.hasIntroduced) {
            return IntroductionPage();
          }
          if (purchaseController.entitlementIsActive.isFalse && !kDebugMode) {
            return FutureBuilder(
              future: Purchases.getOfferings(),
              builder: (context, AsyncSnapshot<Offerings> offerings) {
                if (offerings.hasData) {
                  print("offer: ${offerings.data}");
                  if ((offerings.data.current != null &&
                      offerings.data.current.availablePackages.isNotEmpty)) {
                    return PaywallMy_v2(
                      offering: offerings.data.current,
                    );
                  } else {
                    return Scaffold(
                      body: SafeArea(
                        child: Center(
                          child: CircularProgressIndicatorMy(
                            info: "null data.current or packages empty",
                          ),
                        ),
                      ),
                    );
                  }
                } else {
                  return Scaffold(
                    body: SafeArea(
                      child: Center(
                        child: CircularProgressIndicatorMy(
                          info: "no offerings available",
                        ),
                      ),
                    ),
                  );
                }
              },
            );
          }
          if (!userController.user.hasConnected) {
            return ConnectToBinancePage();
          }
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBarBitMe(),
            backgroundColor: Color(0xffF9F8FD),
            bottomNavigationBar: MyBottomNavigationBar(),
            body: PageView.builder(
                controller: homeController.pageController.value,
                itemCount: homeController.pages.length,
                physics: NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  print("change $index");

                  //homeController.setPage(index);
                },
                itemBuilder: (context, index) {
                  return homeController.pages[index];
                }),
          );
        },
        onLoading: CircularProgressIndicatorMy(
          info: "loading user controller",
        ),
        onEmpty: CircularProgressIndicatorMy(
          info: "empty user controller",
        ),
        // here also you can set your own error widget, but by
        // default will be an Center(child:Text(error))
        onError: (error) {
          callSnackbar("Oops!", error);
          return Authentication();
        });
  }
}
