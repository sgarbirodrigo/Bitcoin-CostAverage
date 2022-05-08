import 'package:bitcoin_cost_average/contants.dart';
import 'package:bitcoin_cost_average/controllers/purchase_controller.dart';
import 'package:bitcoin_cost_average/controllers/user_controller.dart';
import 'package:bitcoin_cost_average/pages/plans/basic_plan.dart';
import 'package:bitcoin_cost_average/pages/settings.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/entitlement_info_wrapper.dart';

class SettingsV2Page extends StatelessWidget {
  CarouselController buttonCarouselController = CarouselController();
  var userController = Get.find<UserController>();
  var purchaseController = Get.find<PurchaseController>();

  @override
  Widget build(BuildContext context) {
    //print("${purchaseController.purchaserInfo.entitlements.active["Premium"].productIdentifier.split("_")[1]}");
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            color: Colors.deepPurple,
            child: Column(
              children: [
                purchaseController.purchaserInfo.entitlements.active.length>0?Column(
                  children: [
                    Text(
                      purchaseController.purchaserInfo.entitlements.active["Premium"].identifier
                          .toUpperCase(),
                      style: TextStyle(color: Colors.white, fontSize: 28),
                    ),
                    Text(
                      purchaseController
                          .purchaserInfo.entitlements.active["Premium"].productIdentifier
                          .split("_")[1]
                          .tr
                          .toUpperCase(),
                      style: TextStyle(color: Color(0xffFFD400), fontSize: 18),
                    ),
                    Container(
                      height: 32,
                    ),
                    purchaseController.purchaserInfo.entitlements.active["Premium"].periodType ==
                            PeriodType.trial
                        ? Text(
                            "x_days_left".trParams({
                              "days_left": DateTime.parse(purchaseController
                                      .purchaserInfo.entitlements.active["Premium"].expirationDate)
                                  .difference(DateTime.now())
                                  .inDays
                                  .toString()
                            }),
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          )
                        : Container(),
                  ],
                ):Container(child: Text("Free Trial",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),),
                Text(
                  userController.user.email,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          /*userController.user.active
              ? Container(
            child: Column(
              children: [
                Icon(
                  Icons.celebration,
                  color: Colors.deepPurple,size: 128,
                ),
                Text(
                  "Premium Plan",
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
          )
              : */
          /*Container(
            padding: EdgeInsets.only(bottom: 16,),
            //color: Colors.deepPurple,
            child: CarouselSlider.builder(
              itemCount: userController.user.active ? 1 : 2,
              itemBuilder: (ctx, index, realIdx) {
                if (realIdx % 2 == 0 && !userController.user.active) {
                  return PlanWidget(
                    features: [
                      "Limited to one order",
                      "advertisements",
                    ],
                    title: "Basic Plan",
                    price: "Free",
                    isSelected: !userController.user.active,
                  );
                } else {
                  return PlanWidget(
                    features: [
                      "Unlimited orders",
                      "NO advertisements",
                    ],
                    title: "Premium Plan",
                    price: "1 Week free trial",
                    isSelected: userController.user.active,
                  );
                }
              },
              carouselController: buttonCarouselController,
              options: CarouselOptions(
                  //autoPlay: true,
                  //autoPlayInterval: Duration(seconds: 6),
                  //autoPlayAnimationDuration: Duration(seconds: 5),
                  enlargeCenterPage: true,
                  viewportFraction: 0.7,
                  aspectRatio: 1.5,
                  initialPage: !userController.user.active ? 1 : 0,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    //_current = index;
                  }),
            ),
          ),*/
          /*
          Text(
            "sgarbi.rodrigo@gmail.com",
            style: TextStyle(fontSize: 18),
          ),*/
          Expanded(
            child: Card(
              elevation: 1,
              margin: EdgeInsets.only(left: 0, right: 0, bottom: 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              child: Container(
                child: ListView(
                  children: [
                    GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.black.withOpacity(0.3), width: 1))),
                        child: ListTile(
                          title: Text("Exchange:"),
                          subtitle: Text("Binance"),
                          trailing: Container(
                            height: 32,
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                            //width: 86,
                            decoration: BoxDecoration(
                                color: userController.isUserConnectedToExchange()
                                    ? greenAppColor
                                    : redAppColor,
                                borderRadius: BorderRadius.all(Radius.circular(12))),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  userController.isUserConnectedToExchange()
                                      ? "CONNECTED".tr
                                      : "DISCONNECTED".tr,
                                  style: TextStyle(color: Colors.white),
                                ),
                                Container(
                                  width: 8,
                                ),
                                Icon(
                                  userController.isUserConnectedToExchange()
                                      ? Icons.done
                                      : Icons.keyboard_arrow_right,
                                  color: Colors.white,
                                  size: 12,
                                )
                              ],
                            ),
                          ),
                        ),
                        /* userController.user.private_key.isNotEmpty &&
                              userController.user.public_key.isNotEmpty
                              ? Icon(
                            Icons.check,
                            color: greenAppColor,
                          )
                              : Icon(
                            Icons.warning,
                            color: redAppColor,
                          )*/
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ExchangeSettingsPage(),
                          ),
                        );
                      },
                    ),
                    /*Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.black.withOpacity(0.3), width: 1))),
                      child: ListTile(
                        title: Text("Exchange:"),
                        subtitle: Text("Binance"),
                        trailing: Container(
                          height: 32,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                          //width: 86,
                          decoration: BoxDecoration(
                              color: userController.isUserConnectedToExchange()
                                  ? greenAppColor
                                  : redAppColor,
                              borderRadius: BorderRadius.all(Radius.circular(12))),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                userController.isUserConnectedToExchange()
                                    ? "CONNECTED".tr
                                    : "DISCONNECTED".tr,
                                style: TextStyle(color: Colors.white),
                              ),
                              Container(
                                width: 8,
                              ),
                              Icon(
                                userController.isUserConnectedToExchange()
                                    ? Icons.done
                                    : Icons.keyboard_arrow_right,
                                color: Colors.white,
                                size: 12,
                              )
                            ],
                          ),
                        ),
                      ),
                      *//* userController.user.private_key.isNotEmpty &&
                              userController.user.public_key.isNotEmpty
                              ? Icon(
                            Icons.check,
                            color: greenAppColor,
                          )
                              : Icon(
                            Icons.warning,
                            color: redAppColor,
                          )*//*
                    )*/
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
