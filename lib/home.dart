import 'package:bitbybit/external/authService.dart';
import 'package:bitbybit/external/binance_api.dart';
import 'package:bitbybit/main_pages/dashboard_widget/chart_widget.dart';
import 'package:bitbybit/dialog_config.dart';
import 'package:bitbybit/home/drawer.dart';
import 'package:bitbybit/main_pages/history.dart';
import 'package:bitbybit/main_pages/dashboard.dart';
import 'package:bitbybit/main_pages/orders.dart';
import 'package:bitbybit/models/settings_model.dart';
import 'package:bitbybit/main_pages/dashboard_widget/orders_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home/appbar.dart';
import 'main_pages/settings.dart';
import 'models/user_model.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title, this.firebaseUser}) : super(key: key);
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

  @override
  void initState() {
    this.settings = Settings((settings) {
      setState(() {
        this.settings = settings;
      });
    });
    this.settings.updateBinancePrice();
    this.user = User(widget.firebaseUser, (user) async {
      setState(() {
        this.user = user;
        /*settings.base_coin =
            this.user.orderItems[0].pair.toString().split("/")[1];
        */
        settings.base_pair = this.user.orderItems[0].pair.toString();
      });
      if (await areUserKeysSavedCorrect(this.user)) {

      } else {
        ScaffoldMessenger.of(context).showSnackBar(new SnackBar(backgroundColor: Colors.red,content:Text("You are not connected with Binance.\nCheck your API keys.",textAlign: TextAlign.left,),duration: Duration(days: 1),behavior: SnackBarBehavior.floating,
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

          ),));
      }
    });

    section = Section.DASHBOARD;
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    Widget body;
    String title = "Bit.Me";
    switch (section) {
      case Section.LOGIN:
        break;
      case Section.DASHBOARD:
        body = DashboardBitMe(
          settings: settings,
          user: user,
        );
        title = "Dashboard";
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
        user: this.user,
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
