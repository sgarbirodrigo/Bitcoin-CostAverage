import 'package:bitcoin_cost_average/controllers/user_controller.dart';
import 'package:bitcoin_cost_average/pages/paywall.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlanWidget extends StatelessWidget {
  final List<String> features;
  final String title;
  final String price;
  final bool isSelected;
  final Color bkgColor;

  const PlanWidget({
    @required this.features,
    @required this.title,
    @required this.price,
    this.isSelected = false,
    this.bkgColor = const Color(0xff292931),
  });

  @override
  Widget build(BuildContext context) {
    var userController = Get.find<UserController>();
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: this.bkgColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      this.title,
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    Text(
                      this.price,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 64,
              child: ListView.builder(
                  itemCount: this.features.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      //width: 250,
                      color: index % 2 == 0 ? Color(0xffEAEAEA) : Color(0xffF1F1F1),
                      child: Text(
                        this.features[index], //"Limited to one order",
                        textAlign: TextAlign.center,
                      ),
                    );
                  }),
            ),
            /*Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              width: 250,
              color: Color(0xffEAEAEA),
              child: Text(
                "Limited to one order",
                textAlign: TextAlign.center,
              ),
            ),*/
            /*Container(
              width: 250,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              color: Color(0xffF1F1F1),
              child: Text("Advertising", textAlign: TextAlign.center),
            ),*/
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: this.isSelected
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Color(0xff292931),
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      child: Text(
                        "SELECTED",
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PaywallPage(),
                          ),
                        );
                      },
                      child: Text("Upgrade"),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
