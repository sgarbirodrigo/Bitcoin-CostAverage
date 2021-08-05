import 'package:bitcoin_cost_average/auth_pages/authentication.dart';
import 'package:bitcoin_cost_average/charts/line_chart_mean_small.dart';
import 'package:bitcoin_cost_average/contants.dart';
import 'package:bitcoin_cost_average/controllers/database_controller.dart';
import 'package:bitcoin_cost_average/controllers/deviceController.dart';
import 'package:bitcoin_cost_average/controllers/purchase_controller.dart';
import 'package:bitcoin_cost_average/external/binance_api.dart';
import 'package:bitcoin_cost_average/pages/dashboard.dart';
import 'package:bitcoin_cost_average/pages/history_page.dart';
import 'package:bitcoin_cost_average/pages/settings.dart';
import 'package:bitcoin_cost_average/models/settings_model.dart';
import 'package:bitcoin_cost_average/models/user_model.dart';
import 'package:bitcoin_cost_average/purchase/paywall.dart';
import 'package:bitcoin_cost_average/purchase/paywall_bca.dart';
import 'package:bitcoin_cost_average/purchase/paywall_bcav2.dart';
import 'package:bitcoin_cost_average/external/sql_database.dart';
import 'package:bitcoin_cost_average/widgets/bottomnavigation_bar.dart';
import 'package:bitcoin_cost_average/widgets/circular_progress_indicator.dart';
import 'package:bitcoin_cost_average/widgets/appbar.dart';
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
  var pageIndex = 0.obs;
  List<Widget> pages;

  @override
  void onInit() {
    super.onInit();
    pages = [DashboardBitMe(), OrdersPage(), HistoryPage(),SettingsPage()];
  }

  void setPage(int index) {
    pageController.value.jumpToPage(index);
    //pageIndex.value = index;
  }
}

class Home extends StatelessWidget {
  var authController = Get.find<AuthController>();
  var purchaseController = Get.find<PurchaseController>();
  var userController = Get.find<UserController>();
  var deviceController = Get.find<DeviceController>();

  //var homeController = Get.put(HomeController());
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
          if (!(purchaseController.entitlementIsActive.isTrue || userController.user.active)) {
            print("entitlementIsActive: ${purchaseController.entitlementIsActive.value}");
            print("simul: ${deviceController.isSimulator.isTrue}");
            print("userController.user.active: ${userController.user.active}");
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
          Get.put(HomeController());
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBarBitMe(),
            backgroundColor: Color(0xffF9F8FD),
            bottomNavigationBar: MyBottomNavigationBar(),
            body: GetBuilder<HomeController>(
              builder: (controller) {
                return PageView.builder(
                    controller: controller.pageController.value,
                    itemCount: controller.pages.length,
                    physics: NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      print("change $index");

                      //homeController.setPage(index);
                    },
                    itemBuilder: (context, index) {
                      return controller.pages[index];
                    });
              },
            ),
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
