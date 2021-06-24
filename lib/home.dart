import 'package:Bit.Me/contants.dart';
import 'package:Bit.Me/external/binance_api.dart';
import 'package:Bit.Me/main_pages/dashboard.dart';
import 'package:Bit.Me/main_pages/history.dart';
import 'package:Bit.Me/main_pages/orders.dart';
import 'package:Bit.Me/main_pages/settings.dart';
import 'package:Bit.Me/models/settings_model.dart';
import 'package:Bit.Me/models/user_model.dart';
import 'package:Bit.Me/widgets/appbar.dart';
import 'package:Bit.Me/widgets/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'dialog_config.dart';

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
  Section section;
  User user;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool entitlementIsActive = false;

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
          settings.updateBasePair(
              this.user.userData.orders.values.toList()[0].pair.toString());
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
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return DialogConfig(this.user);
                },
              );
            },
          ),
        ));
      }
    });

    section = Section.DASHBOARD;
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

  @override
  Widget build(BuildContext context) {
    Widget body;
    String title = "Bitcoin-Cost Average";
    switch (section) {
      case Section.LOGIN:
        break;
      case Section.DASHBOARD:
        body = DashboardBitMe(
          /*key: context.widget.key,*/
          settings: settings,
          user: user,
        );
        title = "Bitcoin-Cost Average";
        break;
      case Section.ORDERS:
        body = OrdersPage(this.user);
        title = "Orders";
        break;
      case Section.HISTORY:
        body = HistoryPage(this.user);
        title = "History";
        break;
      case Section.SETTINGS:
        title = "Settings";
        body = SettingsPage(this.user);
        // TODO: Handle this case.
        break;
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBarBitMe(
        title: title,
        scaffoldKey: _scaffoldKey,
      ),
      backgroundColor: Color(0xffF9F8FD),
      //backgroundColor: Colors.grey,
      drawer: DrawerBitMe(
        onPageChange: (Section section) {
          setState(() {
            this.section = section;
          });
        },
        scaffoldKey: _scaffoldKey,
        user: widget.firebaseUser,
      ),
      body: body,
    );
  }
}

/*
StreamBuilder<QuerySnapshot>(
stream: Firestore.instance
    .collection("users")
.document(widget.user.uid)
.collection("orders")
.orderBy("active", descending: true)
.snapshots(),
builder: (context, querySnapshot) {
//Map<String, double> totalBuying = Map();
Map<String, double> totalExpending = Map();
if (querySnapshot.hasData && settings.binanceTicker != null) {
*/ /*if (querySnapshot.data.documents.length > 0 &&
                settings.base_coin == null) {
              settings.base_coin = querySnapshot.data.documents[0].data["pair"]
                  .toString()
                  .split("/")[1];
            }*/ /*
*/ /*querySnapshot.data.documents.forEach((DocumentSnapshot element) {
              String pair = element.data["pair"].toString();
              double amount = double.parse(element.data["amount"].toString());
              if (element.data["active"]) {
                if (totalBuying[pair] != null) {
                  totalBuying[pair] += amount;
                } else {
                  totalBuying[pair] = amount;
                }
                if (totalExpending[pair.split("/")[1]] != null) {
                  totalExpending[pair.split("/")[1]] += amount;
                } else {
                  totalExpending[pair.split("/")[1]] = amount;
                }
              }
            });*/ /*
*/ /*List<MyChartSectionData> data = List();
            double total = 0;
            totalBuying.forEach((pair, amount) {
              if (pair.split("/")[1] == base_coin) {
                double price = binanceTicker["BTC${pair.split("/")[1]}"];
                double percentage;
                if (price == null) {
                  percentage = amount;
                } else {
                  percentage = amount / price;
                }
                total += percentage;
              }
            });
            totalBuying.forEach((pair, amount) {
              if (pair.split("/")[1] == base_coin) {
                double price = binanceTicker["BTC${pair.split("/")[1]}"];
                double percentage = 1;
                if (price == null) {
                  percentage = amount;
                } else {
                  percentage = amount / price;
                }
                //print(percentage/total);
                data.add(MyChartSectionData(pair, percentage / total, amount));
              }
            });*/ /*

switch (section) {
case Section.LOGIN:
break;
case Section.DASHBOARD:
body = DashboardBitMe(
settings: settings,
user: user,
);
break;
case Section.ORDERS:
body = OrdersPage(
querySnapshot: querySnapshot.data,
);
break;
case Section.HISTORY:
//body = Page2Section();
break;
case Section.SETTINGS:
// TODO: Handle this case.
break;
}
return body;
} else if (querySnapshot.hasError) {
return Text(querySnapshot.error.toString());
} else {
return Center(
child: CircularProgressIndicator(),
);
}
},
)*/
