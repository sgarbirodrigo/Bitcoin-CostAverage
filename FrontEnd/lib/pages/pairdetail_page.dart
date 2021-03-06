import 'package:bitcoin_cost_average/charts/line_chart_mean_small.dart';
import 'package:bitcoin_cost_average/controllers/binance_controller.dart';
import 'package:bitcoin_cost_average/controllers/user_controller.dart';
import 'package:bitcoin_cost_average/list_item/history_list_item_v2.dart';
import 'package:bitcoin_cost_average/models/order_model.dart';
import 'package:bitcoin_cost_average/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:bitcoin_cost_average/controllers/history_controller.dart';
import '../charts/line_chart_mean_pair.dart';

class PairDetailPage extends StatelessWidget {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  var userController = Get.find<UserController>();
  var historyController = Get.find<HistoryController>();
  var binanceController = Get.find<BinanceController>();
  OrderItem orderItem;

  PairDetailPage(this.orderItem);

  double getPairPrice(String pair) {
    try {
      double value = binanceController.tickerPrices[pair.replaceAll("/", "")];
      if (value == null) return 0;
      return value;
    } catch (e) {
      print("error ticker: $e");
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xff553277),
      body: SafeArea(
          bottom: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 4, top: 8, right: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_outlined,
                        color: Colors.white,
                        size: 36,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Container(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${this.orderItem.pair}",
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontFamily: 'Arial Rounded MT Bold'),
                        ),
                        Tooltip(
                            message: 'Price'.tr,
                            child: Text(
                              "${returnCurrencyCorrectedNumber(this.orderItem.pair.split("/")[1], getPairPrice(this.orderItem.pair))}",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontFamily: 'Arial',
                                  fontWeight: FontWeight.w100),
                            ))
                      ],
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Obx(() => Tooltip(
                          message: 'profit_loss'.tr,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                getAppreciationConverted(
                                    historyController.pairAppreciation[this.orderItem.pair]),
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontFamily: 'Arial Rounded MT Bold'),
                              ),
                              Text(
                                historyController.pairData_items.value[this.orderItem.pair] != null
                                    ? "(${returnCurrencyCorrectedNumber(this.orderItem.pair.split("/")[1], (getPairPrice(this.orderItem.pair) * historyController.pairData_items.value[this.orderItem.pair].coinAccumulated) - historyController.pairData_items.value[this.orderItem.pair].totalExpended)})"
                                    : "...",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily: 'Arial',
                                    fontWeight: FontWeight.w100),
                              )
                            ],
                          ),
                        ))
                  ],
                ),
              ),
              Container(
                color: Colors.deepPurpleAccent.withOpacity(0.03),
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                child: Column(
                  children: [
                    Obx(() => Container(
                          //clipBehavior: Clip.antiAlias,
                          padding: EdgeInsets.only(/*bottom: 8,*/ top: 16),
                          /*margin: EdgeInsets.only(
                          left: 8, right: 8, bottom: 16, top: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 15.0,
                            offset: Offset(0.0, 0.75),
                          )
                        ],
                        color: Colors.grey.shade50,
                      ),*/
                          // height: 30,
                          child:
                              historyController.pairData_items.value[this.orderItem.pair] != null &&
                                      historyController.pairData_items.value[this.orderItem.pair]
                                              .price_spots.length >
                                          0
                                  ? PriceAVGChartLinePair(this.orderItem.pair)
                                  : Container(
                                      height: 200,
                                    ),
                        )),
                    /*Row( mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(children: [Text(
                                    "Accumulated:",
                                    textAlign: TextAlign.center,style: TextStyle(fontSize: 18),
                                  ),Text(
                                    "${timespan_name}",
                                    textAlign: TextAlign.center,style: TextStyle(fontSize: 16),
                                  ),],),
                                  Text(
                                    "+ ${doubleToValueString(pairData.coinAccumulated)} ${pairData.pair.split("/")[0]}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),*/
                    Obx(
                      () => Card(
                        color: Color(0xff825CC5).withOpacity(0.7),
                        elevation: 2,
                        margin: EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
                        child: Container(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    "invested".tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    historyController.pairData_items.value[this.orderItem.pair] !=
                                            null
                                        ? "${returnCurrencyCorrectedNumber(this.orderItem.pair.split("/")[1], historyController.pairData_items.value[this.orderItem.pair].totalExpended)}"
                                        : "...",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      "market_value".tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      historyController.pairData_items.value[this.orderItem.pair] !=
                                              null
                                          ? "${returnCurrencyCorrectedNumber(this.orderItem.pair.split("/")[1], (getPairPrice(this.orderItem.pair) * historyController.pairData_items.value[this.orderItem.pair].coinAccumulated))}"
                                          : "...",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              )
                              /*Container(
                                            color:
                                                Colors.white.withOpacity(0.8),
                                            child: Expanded(
                                              child: RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  text:
                                                      "${appreciation < 0 ? "-" : "+"}${(appreciation.abs()).toStringAsFixed(2)}%",
                                                  style: TextStyle(
                                                      color: appreciation < 0
                                                          ? redAppColor
                                                          : greenAppColor,
                                                      fontSize: 36,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          "\n(${doubleToValueString((widget.settings.binanceTicker[pairData.pair.replaceAll("/", "")] * pairData.coinAccumulated) - pairData.totalExpended)} ${pairData.pair.split("/")[1]})",
                                                      style: TextStyle(
                                                          color: appreciation <
                                                                  0
                                                              ? Color(
                                                                  0xffA96B6B)
                                                              : Color(
                                                                  0xff69A67C),
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ), */ /*
                                      TextSpan(
                                          text: "\n$timespan_name",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black
                                                  .withOpacity(0.7))),*/ /*
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )*/
                            ],
                          ),
                        ),
                      ),
                    ),
                    Obx(() => Card(
                          color: Colors.white,
                          elevation: 2,
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        ScaleLineChart.WEEK1 == userController.scaleLineChart.value
                                            ? MaterialStateProperty.all<Color>(
                                                Colors.deepPurple.withOpacity(0.2),
                                              )
                                            : null,
                                  ),
                                  onPressed: () {
                                    userController.scaleLineChart.value = (ScaleLineChart.WEEK1);
                                  },
                                  child: Text("1W".tr)),
                              TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      ScaleLineChart.WEEK2 == userController.scaleLineChart.value
                                          ? MaterialStateProperty.all<Color>(
                                              Colors.deepPurple.withOpacity(0.2))
                                          : null,
                                ),
                                onPressed: () {
                                  userController.scaleLineChart.value = (ScaleLineChart.WEEK2);
                                },
                                child: Text("2W".tr),
                              ),
                              TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      ScaleLineChart.MONTH1 == userController.scaleLineChart.value
                                          ? MaterialStateProperty.all<Color>(
                                              Colors.deepPurple.withOpacity(0.2))
                                          : null,
                                ),
                                onPressed: () {
                                  userController.scaleLineChart.value = (ScaleLineChart.MONTH1);
                                },
                                child: Text("1M".tr),
                              ),
                              TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      ScaleLineChart.MONTH6 == userController.scaleLineChart.value
                                          ? MaterialStateProperty.all<Color>(
                                              Colors.deepPurple.withOpacity(0.2))
                                          : null,
                                ),
                                onPressed: () {
                                  userController.scaleLineChart.value = (ScaleLineChart.MONTH6);
                                },
                                child: Text("6M".tr),
                              ),
                              TextButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        ScaleLineChart.YEAR1 == userController.scaleLineChart.value
                                            ? MaterialStateProperty.all<Color>(
                                                Colors.deepPurple.withOpacity(0.2))
                                            : null,
                                  ),
                                  onPressed: () {
                                    userController.scaleLineChart.value = (ScaleLineChart.YEAR1);
                                  },
                                  child: Text("1Y".tr))
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              /*
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0),
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        )),
                        margin: EdgeInsets.only(
                            bottom: 0, left: 8, right: 8, top: 0),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          color: Colors.black12,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Accumulated:",
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                "+ ${doubleToValueString(pairData.coinAccumulated)} ${pairData.pair.split("/")[0]}",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      )
                      */
              Expanded(
                  child: Obx(() => Card(
                        clipBehavior: Clip.antiAlias,
                        margin: EdgeInsets.only(bottom: 0, left: 8, right: 8, top: 0),
                        elevation: 2,
                        child: historyController.pairData_items.value[this.orderItem.pair] != null
                            ? ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: historyController
                                    .pairData_items.value[this.orderItem.pair].historyItems.length,
                                itemBuilder: (context, index) {
                                  return HistoryItemListv2(
                                    historyItem: historyController.pairData_items
                                        .value[this.orderItem.pair].historyItems[historyController
                                            .pairData_items
                                            .value[this.orderItem.pair]
                                            .historyItems
                                            .length -
                                        index -
                                        1],
                                  );
                                })
                            : Container(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                    border: Border(
                                  bottom: BorderSide(
                                    color: Colors.black.withOpacity(0.2),
                                    width: 0.5,
                                  ),
                                )),
                                child: Center(
                                  child: Text(
                                    "no_acquisitions_over_period".tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                )),
                      )))
            ],
          )),
    );
  }
}
