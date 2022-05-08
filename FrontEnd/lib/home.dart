import 'package:bitcoin_cost_average/auth_pages/authentication.dart';
import 'package:bitcoin_cost_average/contants.dart';
import 'package:bitcoin_cost_average/controllers/deviceController.dart';
import 'package:bitcoin_cost_average/controllers/purchase_controller.dart';
import 'package:bitcoin_cost_average/controllers/remoteConfigController.dart';
import 'package:bitcoin_cost_average/pages/dashboard.dart';
import 'package:bitcoin_cost_average/pages/history_page.dart';
import 'package:bitcoin_cost_average/pages/paywall.dart';
import 'package:bitcoin_cost_average/pages/settings.dart';
import 'package:bitcoin_cost_average/models/settings_model.dart';
import 'package:bitcoin_cost_average/pages/settings_v2.dart';
import 'package:bitcoin_cost_average/widgets/bottomnavigation_bar.dart';
import 'package:bitcoin_cost_average/widgets/circular_progress_indicator.dart';
import 'package:bitcoin_cost_average/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    pages = [DashboardBitMe(), OrdersPage(), HistoryPage(), SettingsV2Page()];
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
  var remoteConfigController = Get.find<RemoteConfigController>();
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
/*

          if (!userController.user.hasConnected) {
            return ConnectToBinancePage();
          }
*/

          //print("isConnectigFirst: ${remoteConfigController.isConnectingFirst()} - ${userController.user.hasConnected}");
          /*if (remoteConfigController.isConnectingFirst()) {
            if (!userController.user.hasConnected) {
              return ConnectToBinancePage();
            }
            if (!(purchaseController.entitlementIsActive.isTrue || userController.user.active)) {
              return PaywallPage();
            }
          } else {
            if (!(purchaseController.entitlementIsActive.isTrue || userController.user.active)) {
              return PaywallPage();
            }
            if (!userController.user.hasConnected) {
              return ConnectToBinancePage();
            }
          }*/

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
