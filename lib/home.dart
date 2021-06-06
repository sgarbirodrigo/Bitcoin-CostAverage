import 'package:bitbybit/authService.dart';
import 'package:bitbybit/binance_api.dart';
import 'package:bitbybit/chart_widget.dart';
import 'package:bitbybit/dialog_config.dart';
import 'package:bitbybit/history_widget.dart';
import 'package:bitbybit/orders_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title, this.userUid}) : super(key: key);
  final String userUid;
  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, double> binance_price;
  String base_coin;

  @override
  void initState() {
    _loadData();
  }

  _loadData() async {
    binance_price = await fetchBinancePairData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //extendBody: true,
      appBar: PreferredSize(
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Stack(children: [
            Center(
              child: Text(
                'BitMe',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              child: IconButton(
                icon: Icon(
                  Icons.power_settings_new,
                  color: Colors.white,
                ),
                onPressed: () => AuthService().signOut(),
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return DialogConfig(widget.userUid);
                      },
                    );
                  }),
            ),
          ]),
          decoration: BoxDecoration(
              gradient: RadialGradient(
                  radius: 6,
                  center: Alignment.centerRight,
                  colors: [
                    Color(0xff7544AF),
                    Color(0xff553277),
                  ]),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[800],
                  blurRadius: 16.0,
                  spreadRadius: 1.0,
                )
              ]),
        ),
        preferredSize: Size(MediaQuery.of(context).size.width, 54.0),
      )
      /*AppBar(
        title: Text(
          "BitMe",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Arial Rounded MT Bold',
            fontSize: 24,
            shadows: <Shadow>[
              Shadow(
                offset: Offset(1.0, 1.0),
                blurRadius: 10,
                color: Color.fromARGB(10, 0, 0, 0),
              )
            ],
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.account_circle_rounded),
          onPressed: () {},
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return DialogConfig();
                  },
                );
              })
        ],
      )*/
      ,
      backgroundColor: Color(0xffF9F8FD),
      //backgroundColor: Colors.grey,
      body: SafeArea(
        bottom: false,
        child: FutureBuilder<FirebaseUser>(
          future: AuthService().currentUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // Get Current User Email
              String userEmail = snapshot.data.email;
              // Get Current User UID
              String userUid = snapshot.data.uid;

              return StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection("users")
                    .document(userUid)
                    .collection("orders")
                    .orderBy("active", descending: true)
                    .snapshots(),
                builder: (context, querySnapshot) {
                  Map<String, double> totalBuying = Map();
                  Map<String, double> totalExpending = Map();
                  if (querySnapshot.hasData) {
                    if(querySnapshot.data.documents.length>0 && this.base_coin==null) {
                      base_coin = querySnapshot.data.documents[0].data["pair"]
                          .toString()
                          .split("/")[1];
                    }
                    querySnapshot.data.documents
                        .forEach((DocumentSnapshot element) {
                      String pair = element.data["pair"].toString();
                      double amount =
                          double.parse(element.data["amount"].toString());
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
                    });
                    List<MyChartSectionData> data = List();
                    double total = 0;
                    totalBuying.forEach((pair, amount) {
                      if (pair.split("/")[1] == base_coin) {
                        double price =
                            binance_price["BTC${pair.split("/")[1]}"];
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
                        double price =
                            binance_price["BTC${pair.split("/")[1]}"];
                        double percentage = 1;
                        if (price == null) {
                          percentage = amount;
                        } else {
                          percentage = amount / price;
                        }
                        //print(percentage/total);
                        data.add(MyChartSectionData(
                            pair, percentage / total, amount));
                      }
                    });
                    return SingleChildScrollView(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ChartWidget(data, totalExpending[base_coin], base_coin,
                            (value) {
                          setState(() {
                            if (totalExpending.keys.contains(value)) {
                              this.base_coin = value;
                            }
                          });
                        }, totalExpending),
                        OrdersWidget(
                            querySnapshot.data, totalExpending, base_coin,
                            (value) {
                          setState(() {
                            this.base_coin = value;
                          });
                          print(this.base_coin);
                        }, userUid),
                        Container(),
                        HistoryWidget(querySnapshot.data,widget.userUid)
                      ],
                    ));
                  } else if (querySnapshot.hasError) {
                    return Text(querySnapshot.error.toString());
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
/*
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Home"),
      ),
      body: FutureBuilder<FirebaseUser>(
        future: AuthService().currentUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Get Current User Email
            String userEmail = snapshot.data.email;

            // Get Current User UID
            String userUid = snapshot.data.uid;

            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Divider(height: 5,),
                ListTile(
                  // Sign Out Button
                  trailing: IconButton(
                    icon: Icon(Icons.power_settings_new),
                    onPressed: () => AuthService().signOut(),
                  ),

                  // Display User Email
                  title: Text(
                    userEmail,
                    style: TextStyle(color: Colors.white),
                  ),

                  // Display User UID
                  subtitle: Text(userUid),

                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}*/
