import 'dart:convert';

import 'package:Bit.Me/tools.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
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

  @override
  Widget build(BuildContext context) {
    var offeringDescription = json.decode(widget.offering.serverDescription);
    List<dynamic> features = offeringDescription["features"] as List;
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  top: 32, bottom: 16, left: 16.0, right: 16.0),
              child: Container(
                child: Text(
                  'CHOOSE YOUR PLAN',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Arial Rounded MT Bold',
                      color: Colors.white),
                ),
                width: double.infinity,
              ),
            ),
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
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      //width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(75),
                        //color: Colors.grey,
                      ),
                      child: Center(
                          child: Image.asset('assets/images/unlock.png')),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                      child: Text(
                        "${offeringDescription["title"]}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Arial Rounded MT Bold', fontSize: 28),
                      ),
                    ),
                    Column(
                        children: Iterable<int>.generate(features.length)
                            .map((entry) {
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
            Expanded(child: Container()),
            Visibility(
              visible: this.isPaying,
              child: Container(
                  margin: EdgeInsets.only(left: 16),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  )),
            ),
            Column(
                children: Iterable<int>.generate(
                        widget.offering.availablePackages.length)
                    .map((entry) {
              return AnimatedContainer(
                //width: 300,
                margin: EdgeInsets.only(top: 16),
                duration: Duration(milliseconds: 250),
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() => this.isPaying = true);
                    Purchases.purchasePackage(
                            widget.offering.availablePackages[entry])
                        .then((purchaseInfo) {
                      print("purchaser info: $purchaseInfo");
                      setState(() => this.isPaying = false);
                    }).catchError((error) {
                      setState(() => this.isPaying = false);
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.deepPurple.shade800,
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(64.0),
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
                            "${widget.offering.availablePackages[entry].product.title}",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Arial Rounded MT Bold',
                                fontSize: 22),
                          ),
                          Container(
                            height: 4,
                          ),
                          Text(
                            "${widget.offering.availablePackages[entry].product.introductoryPrice.introPricePeriodNumberOfUnits}-${widget.offering.availablePackages[entry].product.introductoryPrice.introPricePeriodUnit} free trial",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Arial',
                                fontSize: 16),
                          ),
                          Container(
                            height: 4,
                          ),
                          Text(
                            "${widget.offering.availablePackages[entry].product.identifier.contains("anual") ? "${getCurrencySymbolFromCode(widget.offering.availablePackages[entry].product.currencyCode)} ${(widget.offering.availablePackages[entry].product.price / 12).toStringAsFixed(2)}/month - ${getCurrencySymbolFromCode(widget.offering.availablePackages[entry].product.currencyCode)} ${(widget.offering.availablePackages[entry].product.price).toStringAsFixed(2)}" : "${getCurrencySymbolFromCode(widget.offering.availablePackages[entry].product.currencyCode)} ${(widget.offering.availablePackages[entry].product.price).toStringAsFixed(2)}/month"}",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Arial',
                                fontSize: 18),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList()),
            Padding(
              padding: const EdgeInsets.only(
                  top: 32, bottom: 64, left: 16.0, right: 16.0),
              child: Container(
                child: Text(
                  "Subscription automatically renew after you\'ve finished your trial period. You can cancel anytime.",
                  textAlign: TextAlign.center,
                  style: kDescriptionTextStyle,
                ),
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                Text("$description", textAlign: TextAlign.left)
              ],
            ),
          )
        ],
      ),
    );
  }
}
