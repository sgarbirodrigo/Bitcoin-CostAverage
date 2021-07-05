import 'package:Bit.Me/charts/line_chart_mean.dart';
import 'package:Bit.Me/contants.dart';
import 'package:Bit.Me/external/binance_api.dart';
import 'package:Bit.Me/main_pages/dashboard.dart';
import 'package:Bit.Me/main_pages/settings.dart';
import 'package:Bit.Me/models/settings_model.dart';
import 'package:Bit.Me/models/user_model.dart';
import 'package:Bit.Me/purchase/paywall.dart';
import 'package:Bit.Me/purchase/paywall_bca.dart';
import 'package:Bit.Me/sql_database.dart';
import 'package:Bit.Me/widgets/circular_progress_indicator.dart';
import 'package:Bit.Me/widgets/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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
import 'main_pages/orders_Page.dart';

class Home extends StatefulWidget {
  Home({this.title, this.firebaseUser, this.purchaserInfo, this.sql_database});
  SqlDatabase sql_database;
  PurchaserInfo purchaserInfo;
  final User firebaseUser;
  final String title;

  @override
  _HomeState createState() => _HomeState();
}

enum Section { LOGIN, DASHBOARD, ORDERS, HISTORY, SETTINGS }

class _HomeState extends State<Home> {
  SettingsApp settings;
  PageController _myPage;

  //Section section;
  UserManager user;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  //bool entitlementIsActive = false;
  int _pageIndex = 1;
  Widget body;
  String title = "Bitcoin-Cost Average";
  bool entitlementIsActive = false;

  @override
  void initState() {
    this.settings = SettingsApp((settings) {
      this.settings = settings;
      //print("setting-scale: ${this.settings.scaleLineChart}");
      switch (this.settings.scaleLineChart) {
        case ScaleLineChart.WEEK1:
          //this.settings.updateScaleLineChart(ScaleLineChart.WEEK1);
          this.user.forceUpdateHistoryData(14);
          break;
        case ScaleLineChart.WEEK2:
          //this.settings.updateScaleLineChart(ScaleLineChart.MONTH1);
          this.user.forceUpdateHistoryData(30);
          break;
        case ScaleLineChart.MONTH1:
          //this.settings.updateScaleLineChart(ScaleLineChart.MONTH6);
          this.user.forceUpdateHistoryData(180);
          break;
        case ScaleLineChart.MONTH6:
          //this.settings.updateScaleLineChart(ScaleLineChart.YEAR1);
          this.user.forceUpdateHistoryData(365);
          break;
        case ScaleLineChart.YEAR1:
          //this.settings.updateScaleLineChart(ScaleLineChart.WEEK1);
          this.user.forceUpdateHistoryData(7);
          break;
      }
      if (mounted) setState(() {});
    });
    this.settings.updateBinancePrice();
    this.user = UserManager(widget.sql_database,widget.firebaseUser, this.settings, (user) async {
      this.user = user;
      if (this.settings.base_pair == null &&
          this.user.userData != null &&
          this.user.userData.orders.length > 0) {
        this.settings.updateBasePair(this.user.userTotalBuyingAmount.keys.toList()[0]);
      }
      if (mounted) setState(() {});
    });
    _myPage = PageController(initialPage: 0);

    _checkSubscription();
    Purchases.addPurchaserInfoUpdateListener((purchaserInfo) async {
      widget.purchaserInfo = purchaserInfo;
      print("Updated Purchaser Info: ${purchaserInfo}");
      _checkSubscription();
      if (mounted) setState(() {});
    });

    super.initState();
  }
  //TODO always check before release
  bool isFlutterDebugging=true;

  void _checkSubscription() {
    (widget.purchaserInfo.entitlements.all[entitlementID] != null &&
            widget.purchaserInfo.entitlements.all[entitlementID].isActive)
        ? entitlementIsActive = true
        : entitlementIsActive = false;
  }

  @override
  Widget build(BuildContext context) {
    if (user.userData != null) {
      print("0");
      if (user.userData.hasIntroduced) {
        print("1");
        if (entitlementIsActive || this.isFlutterDebugging) {
          print("2");
          if (user.userData.hasConnected) {
            return Scaffold(
              key: _scaffoldKey,
              /*floatingActionButton: FloatingActionButton(
                onPressed: () {
                //Test functions
                 // FirebaseCrashlytics.instance.crash();
                },
              ),*/
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
                    } else {
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
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(child: CreateEditOrder(this.user));
                            },
                          );
                          /*
                          widget.user.updateUser();
                          await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            useRootNavigator: false,
                            builder: (context) => Container(
                              child: Padding(
                                  child: CreateEditOrder(this.user),
                                  padding: MediaQuery.of(context).viewInsets),
                            ),
                          );*/
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
                      sqlDatabase: widget.sql_database,
                    ),
                    OrdersPage(
                      user: this.user,
                      settings: this.settings,
                      sqlDatabase: widget.sql_database,
                    ),
                    //HistorySelPage(this.user, this.settings),
                    SettingsPage(this.user)
                  ]),
            );
          } else {
            return ConnectToBinancePage(this.user);
          }
        } else {
          return FutureBuilder(
            future: Purchases.getOfferings(),
            builder: (context, AsyncSnapshot<Offerings> offerings) {
              //print("3");
              if (offerings.hasData) {
                //print("oferings: ${offerings.data}");
                if ((offerings.data.current != null &&
                    offerings.data.current.availablePackages.isNotEmpty)) {
                  return PaywallMy(
                    offering: offerings.data.current,
                  );
                } else {
                  //print("4");
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
