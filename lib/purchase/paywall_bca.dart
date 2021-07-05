import 'dart:convert';
import 'dart:ui';

import 'package:Bit.Me/tools.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../contants.dart';

class PaywallMy extends StatefulWidget {
  final Offering offering;

  PaywallMy({Key key, @required this.offering}) : super(key: key);

  @override
  _PaywallMyState createState() => _PaywallMyState();
}

class _PaywallMyState extends State<PaywallMy> {
  CarouselController buttonCarouselController = CarouselController();
  int _current = 0;
  bool isPaying = false;
  bool isDebug = false;

  @override
  Widget build(BuildContext context) {
    var offeringDescription = isDebug
        ? json.decode(
            '{"title":"Full Access","features":[{"title":"Buy everyday","description":"From Monday to Sunday"},{"title":"Unlimited orders","description":"Recurrent buys for your favorite investments"}]}')
        : json.decode(widget.offering.serverDescription);

    List<dynamic> features = offeringDescription["features"] as List;
    TextStyle _linkStyle =
        TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline);
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: <Widget>[
                /* CarouselSlider.builder(
              itemCount: widget.offering.availablePackages.length,
              itemBuilder: (ctx, index, realIdx) {
                return;
              },
              carouselController: buttonCarouselController,
              options: CarouselOptions(
                  autoPlay: false,
                  enlargeCenterPage: true,
                  viewportFraction: 0.8,
                  aspectRatio: 1,
                  initialPage: 2,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
            ),*/
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                  color: Colors.white,
                  child: Container(
                    padding: EdgeInsets.only(bottom: 8, left: 8, right: 8, top: 32),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          //width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(75),
                            //color: Colors.grey,
                          ),
                          child: Center(child: Image.asset('assets/images/unlock.png')),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                          child: Text(
                            "${offeringDescription["title"]}",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: 'Arial Rounded MT Bold', fontSize: 28),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 16),
                          child: Text(
                            "1-week free trial",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Arial', fontSize: 20, color: Colors.deepOrange),
                          ),
                        ),
                        Column(
                            children: Iterable<int>.generate(features.length).map((entry) {
                          return productItem(
                              title: features[entry]["title"],
                              description: features[entry]["description"]);
                        }).toList())
                      ],
                    ),
                  ),
                )
                /*Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: Iterable<int>.generate(
                        widget.offering.availablePackages.length)
                    .map((entry) {
                  return GestureDetector(
                    onTap: () => setState(() {
                      buttonCarouselController.animateToPage(entry);
                    }),
                    child: Container(
                      width: 12.0,
                      height: 12.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              (Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white
                                      : Colors.black)
                                  .withOpacity(_current == entry ? 0.9 : 0.2)),
                    ),
                  );
                }).toList())*/
                ,
                Column(
                    children: Iterable<int>.generate(/*widget.offering.availablePackages.length*/ 2)
                        .map((entry) {
                  return AnimatedContainer(
                    //width: 300,
                    margin: EdgeInsets.only(top: 16),
                    duration: Duration(milliseconds: 250),
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() => this.isPaying = true);
                        try {
                          PurchaserInfo purchaserInfo = await Purchases.purchasePackage(
                              widget.offering.availablePackages[entry]);
                          var isPro = purchaserInfo.entitlements.all[entitlementID].isActive;
                          if (isPro) {
                            print("purchaser info: $purchaserInfo");
                            setState(() => this.isPaying = false);
                          }
                        } on PlatformException catch (e) {
                          var errorCode = PurchasesErrorHelper.getErrorCode(e);
                          if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
                            //showError(e);
                            //todo handle error
                          }
                        }
                        setState(() => this.isPaying = false);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.deepPurple.shade800,
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          //side: BorderSide(color: Colors.deepPurple)
                        )),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 32, vertical: 8)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            children: [
                              Text(
                                isDebug
                                    ? "Monthly Plan"
                                    : "${widget.offering.availablePackages[entry].product.title}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Arial Rounded MT Bold',
                                    fontSize: 22),
                              ),
                              Container(
                                height: 4,
                              ),
                              Text(
                                isDebug
                                    ? "R\$ 29.90/month - R\$ 309.90"
                                    : "${widget.offering.availablePackages[entry].product.identifier.contains("anual") ? "${getCurrencySymbolFromCode(widget.offering.availablePackages[entry].product.currencyCode)} ${(widget.offering.availablePackages[entry].product.price / 12).toStringAsFixed(2)}/month - ${getCurrencySymbolFromCode(widget.offering.availablePackages[entry].product.currencyCode)} ${(widget.offering.availablePackages[entry].product.price).toStringAsFixed(2)}" : "${getCurrencySymbolFromCode(widget.offering.availablePackages[entry].product.currencyCode)} ${(widget.offering.availablePackages[entry].product.price).toStringAsFixed(2)}/month"}",
                                style: TextStyle(
                                    color: Colors.white, fontFamily: 'Arial', fontSize: 18),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList()),
                Padding(
                  padding: const EdgeInsets.only(top: 32, bottom: 64, left: 16.0, right: 16.0),
                  child: Container(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: "You can cancel anytime.",
                          style: TextStyle(fontSize: 16),
                          children: [
                            TextSpan(text: "\nBy subscribing you agreed with our "),
                            TextSpan(
                                text: "Privacy Policy",
                                style: _linkStyle,
                                recognizer: _privacyClick()),
                            TextSpan(text: " and "),
                            TextSpan(
                                text: "Terms of Use",
                                style: _linkStyle,
                                recognizer: _privacyClick()),
                            TextSpan(text: ".\n\n"),
                            TextSpan(
                                text: "Restore Purchase",
                                style: _linkStyle,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    try {
                                      PurchaserInfo restoredInfo =
                                          await Purchases.restoreTransactions();
                                      print("Restore info: $restoredInfo");
                                      // ... check restored purchaserInfo to see if entitlement is now active
                                    } on PlatformException catch (e) {
                                      print("Restore error: $e");
                                      // Error restoring purchases
                                    }
                                  })
                          ]),
                    ),
                    width: double.infinity,
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: isPaying,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.white.withOpacity(0.6),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  TapGestureRecognizer _privacyClick() {
    TapGestureRecognizer recognizer = TapGestureRecognizer();
    recognizer.onTap = () {
      launch('https://bitcoincostaverage.com/terms');
    };
    return recognizer;
  }

  Widget productItem({String title, String description}) {
    return Container(
      //height: 72,
      padding: EdgeInsets.only(top: 8, bottom: 16, left: 16, right: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.pages,
            size: 36,
            color: Colors.deepPurple,
          ),
          Container(
            width: 16,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$title",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  "$description",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
