import 'package:Bit.Me/CreateOrderDialog.dart';
import 'package:Bit.Me/contants.dart';
import 'package:Bit.Me/external/binance_api.dart';
import 'package:Bit.Me/main_pages/dashboard.dart';
import 'package:Bit.Me/bkp/orders.dart';
import 'package:Bit.Me/main_pages/settings.dart';
import 'package:Bit.Me/models/settings_model.dart';
import 'package:Bit.Me/models/user_model.dart';
import 'package:Bit.Me/widgets/appbar.dart';
import 'package:Bit.Me/widgets/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'CreateEditOrder.dart';
import 'IntroductionConnectPage.dart';
import 'IntroductionPage.dart';
import 'dialog_config.dart';
import 'history_page.dart';
import 'history_selector_coin.dart';
import 'orders_Page.dart';

class Home extends StatefulWidget {
  Home({this.title, this.firebaseUser});

  final FirebaseUser firebaseUser;
  final String title;

  @override
  _HomeState createState() => _HomeState();
}

enum Section { LOGIN, DASHBOARD, ORDERS, HISTORY, SETTINGS }

class _HomeState extends State<Home> {
  Settings settings;

  //Section section;
  User user;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool entitlementIsActive = false;
  int _pageIndex = 1;
  Widget body;
  String title = "Bitcoin-Cost Average";

  /*
  final _ordersKey = new GlobalKey<ScaffoldState>();*/
  @override
  void initState() {
    this.settings = Settings((settings) {
      setState(() {
        this.settings = settings;
      });
    });
    this.settings.updateBinancePrice();
    this.user = User(widget.firebaseUser, this.settings, (user) async {
      setState(() {
        this.user = user;
        if (this.settings.base_pair == null &&
            this.user.userData != null &&
            this.user.userData.orders.length > 0) {
          //print("opa ${this.user.userTotalBuyingAmount.keys.toList()[0]}");

          settings
              .updateBasePair(this.user.userTotalBuyingAmount.keys.toList()[0]);
        }
      });
      if (await areUserKeysSavedCorrect(this.user)) {
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "You are not connected with Binance.\nCheck your API keys.",
            textAlign: TextAlign.left,
          ),
          duration: Duration(days: 1),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Settings',
            textColor: Colors.yellow,
            onPressed: () {
              //section = Section.SETTINGS;
              title = "Settings";
              body = SettingsPage(this.user);
            },
          ),
        ));
      }
    });
    _myPage = PageController(initialPage: 0);
    //section = Section.DASHBOARD;
    initPlatformState();
    super.initState();
  }

  void loadPurchase() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null &&
          offerings.current.availablePackages.isNotEmpty) {
        // Display packages for sale
      }
    } on PlatformException catch (e) {
      // optional error handling
    }
  }

  Future<void> initPlatformState() async {
    // Enable debug logs before calling `configure`.
    await Purchases.setDebugLogsEnabled(true);

    /*
    - appUserID is nil, so an anonymous ID will be generated automatically by the Purchases SDK. Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids
    - observerMode is false, so Purchases will automatically handle finishing transactions. Read more about Observer Mode here: https://docs.revenuecat.com/docs/observer-mode
    */
    await Purchases.setup(apiKey,
        appUserId: this.user.firebaseUser.uid, observerMode: false);

    Purchases.addPurchaserInfoUpdateListener((purchaserInfo) async {
      //appData.appUserID = await Purchases.appUserID;

      PurchaserInfo purchaserInfo = await Purchases.getPurchaserInfo();
      (purchaserInfo.entitlements.all[entitlementID] != null &&
              purchaserInfo.entitlements.all[entitlementID].isActive)
          ? entitlementIsActive = true
          : entitlementIsActive = false;

      setState(() {});
    });
  }

  PageController _myPage;

  @override
  Widget build(BuildContext context) {
    if (user.userData != null) {
      if (user.userData.hasIntroduced) {
        if (user.userData.hasConnected) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBarBitMe(
              title: title,
              scaffoldKey: _scaffoldKey,
            ),
            backgroundColor: Color(0xffF9F8FD),
            bottomNavigationBar: TitledBottomNavigationBar(
                currentIndex: _pageIndex,
                reverse: true,
                onTap: (index) {
                  //print("jumping to $index");
                  _myPage.jumpToPage(index >= 1 ? index - 1 : index);
                  setState(() {
                    _pageIndex = index;
                  });
                },
                items: [
                  TitledNavigationBarItem(
                    title: Text(
                      'ORDER',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                    icon: ElevatedButton(
                      onPressed: () async {
                        // _pageIndex = 2;
                        await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          useRootNavigator: true,
                          builder: (context) => Container(
                            //height: 400,
                            child: Padding(
                                child: CreateEditOrder(this.user),
                                padding: MediaQuery.of(context).viewInsets),
                          ),
                        );
                        user.updateUser();
                        //_pageIndex = I;
                      },
                      child: Icon(
                        Icons.add,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  TitledNavigationBarItem(
                    title: Text('Home'),
                    icon: Icon(
                      Icons.home,
                      color: Colors.grey,
                    ),
                  ),
                  TitledNavigationBarItem(
                    title: Text('Orders'),
                    icon: Icon(
                      Icons.list_alt_sharp,
                      color: Colors.grey,
                    ),
                  ),
                  TitledNavigationBarItem(
                    title: Text('Settings'),
                    icon: Icon(
                      Icons.settings_outlined,
                      color: Colors.grey,
                    ),
                  ),
                  /*TitledNavigationBarItem(
                title: Text('Log Out'), icon: Icon(Icons.logout)),*/
                ]),
            body: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: _myPage,
                children: <Widget>[
                  DashboardBitMe(
                    /*key: context.widget.key,*/
                    settings: settings,
                    user: user,
                  ),
                  OrdersPage(
                    user: this.user,
                    settings: this.settings,
                  ),
                  //HistorySelPage(this.user, this.settings),
                  SettingsPage(this.user)
                ]),
          );
        } else {
          return IntroductionConnectPage(this.user);
        }
      } else {
        return IntroductionPage(this.user);
      }
    } else {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
  }
}
