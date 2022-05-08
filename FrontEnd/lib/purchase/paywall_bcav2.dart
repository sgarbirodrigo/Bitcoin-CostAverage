import 'dart:convert';
import 'dart:ui';

import 'package:bitcoin_cost_average/controllers/remoteConfigController.dart';
import 'package:bitcoin_cost_average/controllers/user_controller.dart';
import 'package:bitcoin_cost_average/tools.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../contants.dart';

class PaywallMy_v2 extends StatefulWidget {
  final Offering offering;

  PaywallMy_v2({Key key, @required this.offering}) : super(key: key);

  @override
  _PaywallMy_v2State createState() => _PaywallMy_v2State();
}

class _PaywallMy_v2State extends State<PaywallMy_v2> {
  CarouselController buttonCarouselController = CarouselController();
  int _current = 0;
  bool isPaying = false;
  bool isDebug = false;
  var remoteConfigController = Get.find<RemoteConfigController>();
  //var userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    /*var offeringDescription = isDebug
        ? json.decode(
            '{"title":"Full Access","features":[{"title":"Buy everyday","description":"From Monday to Sunday"},{"title":"Unlimited orders","description":"Recurrent buys for your favorite investments"}]}')
        : json.decode(widget.offering.serverDescription);*/

    List<Map<String, String>> features = remoteConfigController.getPaywallFeatures();
    TextStyle _linkStyle =
        TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline);
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                Card(
                  margin: EdgeInsets.only(top: 8),
                  elevation: 8,
                  color: Colors.white,
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    //padding: EdgeInsets.only(bottom: 8, left: 8, right: 8, top: 32),
                    width: 300,
                    child: Column(
                      children: [
                        Container(
                          height: 212,
                          color: Colors.deepPurple,
                          padding: EdgeInsets.only(top: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text("PREMIUM",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Arial Rounded MT Bold',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 28,
                                      color: Colors.white)),
                              Expanded(
                                //color: Colors.deepPurple,
                                child: CarouselSlider.builder(
                                  itemCount: features.length,
                                  itemBuilder: (ctx, index, realIdx) {
                                    return productItem(
                                        title: features[realIdx]["title"],
                                        description: features[realIdx]["description"]);
                                  },
                                  carouselController: buttonCarouselController,
                                  options: CarouselOptions(
                                      autoPlay: true,
                                      autoPlayInterval: Duration(seconds: 6),
                                      //autoPlayAnimationDuration: Duration(seconds: 5),
                                      enlargeCenterPage: false,
                                      viewportFraction: 1,
                                      aspectRatio: 3.5,
                                      initialPage: 1,
                                      enableInfiniteScroll: false,
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          _current = index;
                                        });
                                      }),
                                ),
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: Iterable<int>.generate(features.length).map((entry) {
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
                                            color: Colors.white
                                                .withOpacity(_current != entry ? 0.9 : 0.2)),
                                      ),
                                    );
                                  }).toList()),
                              Container(
                                height: 8,
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 16),
                          child: Column(
                            children: [
                              Text("week_trial".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Arial Rounded MT Bold',
                                      fontSize: 18,
                                      color: Colors.red)),
                              Column(
                                  children: Iterable<int>.generate(
                                          widget.offering.availablePackages.length)
                                      .map((entry) {
                                print(
                                    "entry: ${widget.offering.availablePackages[entry].product.title}");
                                return AnimatedContainer(
                                  //width: 300,
                                  margin: EdgeInsets.only(top: 16),
                                  duration: Duration(milliseconds: 250),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      setState(() => this.isPaying = true);
                                      try {
                                        PurchaserInfo purchaserInfo =
                                            await Purchases.purchasePackage(
                                                widget.offering.availablePackages[entry]);
                                        var isPro =
                                            purchaserInfo.entitlements.all[entitlementID].isActive;
                                        if (isPro) {
                                          print("purchaser info: $purchaserInfo");
                                          setState(() => this.isPaying = false);
                                        }
                                        //Navigator.pop(context);
                                      } on PlatformException catch (e) {
                                        var errorCode = PurchasesErrorHelper.getErrorCode(e);
                                        if (errorCode !=
                                            PurchasesErrorCode.purchaseCancelledError) {
                                          //showError(e);
                                          //todo handle error
                                        }
                                      }
                                      setState(() => this.isPaying = false);

                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(
                                        widget.offering.availablePackages[entry].product.identifier
                                                .contains("annual")
                                            ? Colors.deepPurple
                                            : Colors.white,
                                      ),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(24),
                                              side: BorderSide(color: Colors.deepPurple))),
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
                                                  : "${widget.offering.availablePackages[entry].product.title}"
                                                      .split("(")[0],
                                              style: TextStyle(
                                                  color: widget.offering.availablePackages[entry]
                                                          .product.identifier
                                                          .contains("annual")
                                                      ? Colors.white
                                                      : Colors.deepPurple,
                                                  fontFamily: 'Arial Rounded MT Bold',
                                                  fontSize: 16),
                                            ),
                                            Container(
                                              height: 4,
                                            ),
                                            Text(
                                              isDebug
                                                  ? "R\$ 29.90/month - R\$ 309.90"
                                                  : "${widget.offering.availablePackages[entry].product.identifier.contains("annual") ? "${getCurrencySymbolFromCode(widget.offering.availablePackages[entry].product.currencyCode)} ${(widget.offering.availablePackages[entry].product.price / 12).toStringAsFixed(2)}/${"month".tr} - ${getCurrencySymbolFromCode(widget.offering.availablePackages[entry].product.currencyCode)} ${(widget.offering.availablePackages[entry].product.price).toStringAsFixed(2)}" : "${getCurrencySymbolFromCode(widget.offering.availablePackages[entry].product.currencyCode)} ${(widget.offering.availablePackages[entry].product.price).toStringAsFixed(2)}/${"month".tr}"}",
                                              style: TextStyle(
                                                  color: widget.offering.availablePackages[entry]
                                                          .product.identifier
                                                          .contains("annual")
                                                      ? Colors.white
                                                      : Colors.deepPurple,
                                                  fontFamily: 'Arial',
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList()),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 16, top: 16),
                          child: GestureDetector(
                            child: Text(
                              "restore_purchase".tr,
                              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                              // style: _linkStyle,
                            ),
                            onTap: () async {
                              setState(() {
                                this.isPaying = true;
                              });
                              try {
                                PurchaserInfo restoredInfo = await Purchases.restoreTransactions();
                                print("Restore info: $restoredInfo");
                                // ... check restored purchaserInfo to see if entitlement is now active
                              } on PlatformException catch (e) {
                                print("Restore error: $e");
                                //todo add snackbar to inform error
                                // Error restoring purchases
                              }
                              setState(() {
                                this.isPaying = false;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 16.0, right: 16.0),
                  child: Container(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: "cancel_anytime".tr,
                          style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
                          children: [
                            TextSpan(text: "agree_with".tr),
                            TextSpan(
                                text: "privacy_policy".tr,
                                style: _linkStyle,
                                recognizer: _privacyClick()),
                            TextSpan(text: "and".tr),
                            TextSpan(
                                text: "terms_of_use".tr,
                                style: _linkStyle,
                                recognizer: _privacyClick()),
                            TextSpan(text: ".\n\n"),
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
      launch('https://bitcoincostaverage.com/tos');
    };
    return recognizer;
  }

  Widget productItem({String title, String description}) {
    return Container(
      //height: 72,
      padding: EdgeInsets.only(top: 16, bottom: 16, left: 8, right: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /*Icon(
            Icons.det,
            color: Colors.white,
            size: 64,
          ),*/
          Container(
            height: 16,
          ),
          Text(
            "$title",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
          ),
          Text(
            "$description",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.white),
          )
        ],
      ),
    );
  }
}
