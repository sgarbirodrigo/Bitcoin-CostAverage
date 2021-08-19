import 'package:bitcoin_cost_average/contants.dart';
import 'package:bitcoin_cost_average/controllers/user_controller.dart';
import 'package:bitcoin_cost_average/pages/plans/basic_plan.dart';
import 'package:bitcoin_cost_average/pages/settings.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsV2Page extends StatelessWidget {
  CarouselController buttonCarouselController = CarouselController();
  var userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            height: 24,
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
          Container(
            height: 8,
          ),
          Expanded(
            child: Card(
              elevation: 1,
              margin: EdgeInsets.only(left: 0, right: 0, top: 8, bottom: 0),
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
                          title: Text("Connection with your exchange"),
                          subtitle: Text("Binance"),
                          trailing: userController.user.private_key.isNotEmpty &&
                                  userController.user.public_key.isNotEmpty
                              ? Icon(
                                  Icons.check,
                                  color: greenAppColor,
                                )
                              : Icon(
                                  Icons.warning,
                                  color: redAppColor,
                                ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ExchangeSettingsPage(),
                          ),
                        );
                      },
                    ),
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
