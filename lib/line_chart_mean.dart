import 'dart:convert';
import 'package:bitbybit/models/settings_model.dart';
import 'package:bitbybit/tools.dart';
import 'package:quiver/iterables.dart';
import 'package:bitbybit/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'models/history_model.dart';

class PriceAVGChartLine extends StatefulWidget {
  User user;
  Settings settings;
  String pair;
  Color color;

  PriceAVGChartLine(this.user, this.settings, this.pair, this.color);

  @override
  State<StatefulWidget> createState() => PriceAVGChartLineState();
}

enum ScaleLineChart { WEEK1, WEEK2, MONTH1, MONTH6, YEAR1 }

class PriceAVGChartLineState extends State<PriceAVGChartLine> {
  //bool isShowingMainData;
  double interval = 1; //intervalo de 24 horas
  PairData _pairData;
  List<FlSpot> price_spots = List();
  List<FlSpot> avg_price_spots = List();
  double xmin, xmax;

  @override
  void initState() {
    super.initState();
    _pairData = widget.user.pairDataItems[widget.pair];
    xmax = DateTime.now().millisecondsSinceEpoch / 1000;
    xmin = DateTime.now().add(Duration(days: -7)).millisecondsSinceEpoch / 1000;
    //interval = (1.0 * (60 * 60 * 24)) - 1;
    switch (widget.settings.scaleLineChart) {
      case ScaleLineChart.WEEK1:
        xmin = DateTime.now().add(Duration(days: -7)).millisecondsSinceEpoch /
            1000;
        break;
      case ScaleLineChart.WEEK2:
        xmin = DateTime.now().add(Duration(days: -14)).millisecondsSinceEpoch /
            1000;
        break;
      case ScaleLineChart.MONTH1:
        xmin = DateTime.now().add(Duration(days: -30)).millisecondsSinceEpoch /
            1000;
        break;
      case ScaleLineChart.MONTH6:
        xmin = DateTime.now().add(Duration(days: -365)).millisecondsSinceEpoch /
            1000;
        break;
      case ScaleLineChart.YEAR1:
        xmin = DateTime.now().add(Duration(days: -365)).millisecondsSinceEpoch /
            1000;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    price_spots = _pairData.price_spots;
    avg_price_spots = _pairData.avg_price_spots;
    return Container(
      height: 86,
      //padding: EdgeInsets.,
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
                fitInsideHorizontally: true,
                tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
                getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                  return touchedBarSpots.map((barSpot) {
                    final flSpot = barSpot;
                    if (flSpot.x == 0) {
                      return null;
                    }

                    return LineTooltipItem(
                      '${doubleToValueString(flSpot.y)}',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: ' ${_pairData.pair.split("/")[1]}',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    );
                  }).toList();
                }),
            touchCallback: (LineTouchResponse touchResponse) {},
            handleBuiltInTouches: true,
          ),
          clipData: FlClipData.vertical(),
          gridData: FlGridData(
            show: false,
          ),
          titlesData: FlTitlesData(
            bottomTitles: SideTitles(
              showTitles: false,
              //reservedSize: 10,
              //interval: interval,
              /*getTextStyles: (value) => const TextStyle(
                color: Color(0xff72719b),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),*/
              //margin: 10,
              /*getTitles: (value) {
                Timestamp timestamp = Timestamp.fromMillisecondsSinceEpoch(
                    (value * 1000).toInt());
                String xTitle = "${timestamp.toDate().day}";
                //print(xTitle);
                //return Timestamp.fromMillisecondsSinceEpoch((value*1000).toInt()).toDate()-1000);
                *//* print(
                "value: ${value} - dia: ${Timestamp.fromMillisecondsSinceEpoch(value.toInt()).toDate().day.toString()}");*//*
                //return Timestamp.fromMillisecondsSinceEpoch(value.toInt()).toDate().day.toString();
                return xTitle;
              },*/
            ),
            leftTitles: SideTitles(
              showTitles: false,
              reservedSize: 90,
              margin: 0,
              getTitles: (value) {
                return null;
              },
            ),
          ),
          borderData: FlBorderData(
            show: false,
            border: const Border(
              bottom: BorderSide(
                color: Colors.transparent,
                //width: 1,
              ),
              left: BorderSide(
                color: Colors.transparent,
              ),
              right: BorderSide(
                color: Colors.transparent,
              ),
              top: BorderSide(
                color: Colors.transparent,
              ),
            ),
          ),
          minX: xmin,
          maxX: xmax,
          maxY: _pairData.max *1.01,
          minY: _pairData.min * 0.95,
          lineBarsData: [
            LineChartBarData(
              spots: price_spots,
              isCurved: false,
              //curveSmoothness: 0,
              colors: [
                widget.color,
              ],
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 2,
                      color: widget.color,
                      //strokeWidth: 1,
                      //strokeColor: Colors.green
                    );
                  }),

              belowBarData: BarAreaData(
                show: true,
                colors: [
                  widget.color.withOpacity(0.5),
                  widget.color.withOpacity(0.0),
                ],
                gradientColorStops: [0.1, 1.0],
                gradientFrom: const Offset(0, 0),
                gradientTo: const Offset(0, 1),
              ),
              /*gradientTo: Offset(0, 0),
          gradientFrom: Offset(0, 0),*/
            ),
            LineChartBarData(
              spots: avg_price_spots,
              isCurved: true,
              curveSmoothness: 0.2,
              dashArray: [8, 8],
              colors: [
                widget.color,
              ],
              barWidth: 2,
              isStrokeCapRound: false,
              dotData: FlDotData(
                show: false,
              ),
              belowBarData: BarAreaData(
                  //show: true,
                  ),
            )
          ],
        ),swapAnimationCurve:Curves.linear,
        swapAnimationDuration: Duration(milliseconds: 1000),
      ),
    );
  }
}
