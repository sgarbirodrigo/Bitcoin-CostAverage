import 'package:bitcoin_cost_average/charts/line_chart_mean_small.dart';
import 'package:bitcoin_cost_average/controllers/database_controller.dart';
import 'package:bitcoin_cost_average/controllers/user_controller.dart';
import 'package:bitcoin_cost_average/list_item/history_list_item_v2.dart';
import 'package:bitcoin_cost_average/models/history_model.dart';
import 'package:bitcoin_cost_average/models/settings_model.dart';
import 'package:bitcoin_cost_average/models/user_model.dart';
import 'package:bitcoin_cost_average/pages/pairdetail_page.dart';
import 'package:bitcoin_cost_average/external/sql_database.dart';
import 'package:bitcoin_cost_average/tools.dart';
import 'package:bitcoin_cost_average/widgets/header_weekselector.dart';
import 'package:bitcoin_cost_average/widgets/weekindicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import '../contants.dart';
import '../list_item/order_item_list.dart';
import 'package:bitcoin_cost_average/controllers/history_controller.dart';

class OrdersPageController extends GetxController {}

class HistoryPage extends StatelessWidget {
  var historyController = Get.find<HistoryController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        WeekHeaderSelector(),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10.0,
                  offset: Offset(0.0, 0.0),
                )
              ],
              color: Colors.white,
            ),
            //height: 300,
            child: historyController.history_items.length > 0
                ? Obx(
                    () {
                      return StickyGroupedListView<dynamic, DateTime>(
                        elements: historyController.history_items.value,
                        order: StickyGroupedListOrder.DESC,
                        groupBy: (historyItem) => DateTime(
                            historyItem.timestamp.toDate().year,
                            historyItem.timestamp.toDate().month,
                            historyItem.timestamp.toDate().day),
                        groupSeparatorBuilder: (historyItem) {
                          return Container(
                            height: 36,
                            decoration: BoxDecoration(
                                //color: Colors.black.withOpacity(0.05),
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.black.withOpacity(0.5), width: 1))),
                            padding: EdgeInsets.only(left: 16, right: 16),
                            child: Row(
                              children: [
                                Text(
                                  getDateWeekDayName(historyItem.timestamp.toDate()),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                Text(
                                  "history_header_date".trParams({
                                    'month': getLongMonthName(historyItem.timestamp.toDate()),
                                    'day': historyItem.timestamp.toDate().day.toString(),
                                    'year': historyItem.timestamp.toDate().year.toString(),
                                  }),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                          );
                        },
                        itemBuilder: (context, element) {
                          return HistoryItemListv2(historyItem: element, hideData: true);
                        },
                      );
                    },
                  )
                : Container(
                    height: 200,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Center(
                      child: Text("history_empty".tr,
                          textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
                    ),
                  ),
          ),
        )
      ],
    );
  }
}
