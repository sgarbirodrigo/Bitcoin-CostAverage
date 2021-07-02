import 'package:Bit.Me/bkp/CreateOrderDialog.dart';
import 'package:Bit.Me/contants.dart';
import 'package:Bit.Me/external/binance_api.dart';
import 'package:Bit.Me/main_pages/dashboard.dart';
import 'package:Bit.Me/bkp/orders.dart';
import 'package:Bit.Me/main_pages/settings.dart';
import 'package:Bit.Me/models/settings_model.dart';
import 'package:Bit.Me/models/user_model.dart';
import 'package:Bit.Me/purchase/paywall.dart';
import 'package:Bit.Me/purchase/paywall_bca.dart';
import 'package:Bit.Me/widgets/circular_progress_indicator.dart';
import 'package:Bit.Me/widgets/appbar.dart';
import 'package:Bit.Me/widgets/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'CreateEditOrder.dart';
import 'wizards/IntroductionConnectPage.dart';
import 'wizards/IntroductionPage.dart';
import 'bkp/dialog_config.dart';
import 'bkp/history_page.dart';
import 'bkp/history_selector_coin.dart';
import 'main_pages/orders_Page.dart';

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
  PageController _myPage;
  //Section section;
  User user;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  //bool entitlementIsActive = false;
  int _pageIndex = 1;
  Widget body;
  String title = "Bitcoin-Cost Average";

  /*
  final _ordersKey = new GlobalKey<ScaffoldState>();*/
  @override
  void initState() {
    this.settings = Settings((settings) {
      this.settings = settings;
      if (mounted) setState(() {});
    });
    this.settings.updateBinancePrice();
    this.user = User(widget.firebaseUser, this.settings, (user) async {
      this.user = user;
      if (this.settings.base_pair == null &&
          this.user.userData != null &&
          this.user.userData.orders.length > 0) {
        settings
            .updateBasePair(this.user.userTotalBuyingAmount.keys.toList()[0]);
      }
      if (mounted) setState(() {});
    });
    _myPage = PageController(initialPage: 0);
    //section = Section.DASHBOARD;
    validateSubscription();

    super.initState();
  }

  PurchaserInfo purchaserInfo;

  Future<void> validateSubscription() async {
    await Purchases.setup(apiKey,
        appUserId: this.user.firebaseUser.uid, observerMode: false);
    this.purchaserInfo = await Purchases.getPurchaserInfo();
    print("0 purchaserInfo: ${purchaserInfo.activeSubscriptions}");
    /*if (purchaserInfo.activeSubscriptions.length > 0) {
      print("have");
    } else {
      //offerings = await Purchases.getOfferings();
      if (offerings.current != null &&
          offerings.current.availablePackages.isNotEmpty) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PaywallMy(
                  offering: offerings.current,
                )));
        */ /*offerings.all.forEach((key, value) {
          print("key: ${key} - value: ${value}");
        });*/ /*
      }
    }*/
    Purchases.addPurchaserInfoUpdateListener((purchaserInfo) async {
      print("app userID: ${await Purchases.appUserID}");
      this.purchaserInfo = await Purchases.getPurchaserInfo();
      print("purchaserInfo: ${purchaserInfo.activeSubscriptions}");
      //this.user.updateUser();
      setState(() {});
      /* (purchaserInfo.entitlements.all[entitlementID] != null &&
              purchaserInfo.entitlements.all[entitlementID].isActive)
          ? entitlementIsActive = true
          : entitlementIsActive = false;*/
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user.userData != null) {
      if (user.userData.hasIntroduced) {
        if (purchaserInfo.activeSubscriptions.length > 0) {
          print("subs: ${purchaserInfo.activeSubscriptions.length}");
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
                    if (index != 0) {
                      //print("jumping to $index");
                      _myPage.jumpToPage(index >= 1 ? index - 1 : index);
                      setState(() {
                        _pageIndex = index;
                      });
                    }else{
                      setState(() {
                        _pageIndex = _pageIndex;
                      });
                      return;
                    }
                  },
                  items: [
                    TitledNavigationBarItem(
                      title: Text(
                        '',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                      icon: ElevatedButton(
                        onPressed: () async {
                          // _pageIndex = 2;
                          await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            useRootNavigator: false,
                            builder: (context) => Container(
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
              /*floatingActionButton: FloatingActionButton(
              onPressed: () {
                IconButton(
                  icon: Icon(
                    Icons.terrain_sharp,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            Paywall(offering: offerings.current)));
                  },
                );
              },
            ),*/
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
            return ConnectToBinancePage(this.user);
          }
        } else {
          print("0-subs: ${purchaserInfo.activeSubscriptions.length>0}");
          return FutureBuilder(
            future: Purchases.getOfferings(),
            builder: (context, AsyncSnapshot<Offerings> offerings) {
              if (offerings.hasData) {
                if (offerings.data.current != null &&
                    offerings.data.current.availablePackages.isNotEmpty) {
                  return PaywallMy(
                    offering: offerings.data.current,
                  );
                } else {
                  return Scaffold(
                    body: SafeArea(
                      child: Center(
                        child: CircularProgressIndicatorMy(),
                      ),
                    ),
                  );
                }
              } else {
                return Scaffold(
                  body: SafeArea(
                    child: Center(
                      child: CircularProgressIndicatorMy(),
                    ),
                  ),
                );
              }
            },
          );
        }
      } else {
        return IntroductionPage(this.user);
      }
    } else {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: CircularProgressIndicatorMy(),
          ),
        ),
      );
    }
  }
}
