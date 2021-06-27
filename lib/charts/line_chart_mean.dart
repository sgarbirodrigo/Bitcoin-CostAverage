import 'package:Bit.Me/tools.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/history_model.dart';
import '../models/settings_model.dart';
import '../models/user_model.dart';

class PriceAVGChartLine extends StatefulWidget {
  User user;
  Settings settings;
  String pair;
  Color color;

  PriceAVGChartLine({this.user, this.settings, this.pair, this.color});

  @override
  State<StatefulWidget> createState() => PriceAVGChartLineState();
}

enum ScaleLineChart { WEEK1, WEEK2, MONTH1, MONTH6, YEAR1 }

class PriceAVGChartLineState extends State<PriceAVGChartLine> {
  //bool isShowingMainData;
  //double interval = 1; //intervalo de 24 horas
  PairData _pairData;
  List<FlSpot> price_spots = List();
  double xmin, xmax;

  @override
  void initState() {
    super.initState();
    //_pairData = widget.user.pairDataItems[widget.pair];
    //print("pairItens: ${_pairData.historyItems.length}");
  }

  void fillLineChart() {
    price_spots.clear();
    if (_pairData.price_spots.isNotEmpty) {
      int spots_missing = 0;
      switch (widget.settings.scaleLineChart) {
        case ScaleLineChart.WEEK1:
          spots_missing = 7 - _pairData.price_spots.length;
          break;
        case ScaleLineChart.WEEK2:
          spots_missing = 14 - _pairData.price_spots.length;
          break;
        case ScaleLineChart.MONTH1:
          spots_missing = 30 - _pairData.price_spots.length;
          break;
        case ScaleLineChart.MONTH6:
          spots_missing = 180 - _pairData.price_spots.length;
          break;
        case ScaleLineChart.YEAR1:
          spots_missing = 365 - _pairData.price_spots.length;
          break;
      }
      if (spots_missing > 0) {
        FlSpot reference = _pairData.price_spots.first;
        Timestamp firstPoint = Timestamp.fromDate(
            DateTime.fromMillisecondsSinceEpoch(reference.x.toInt() * 1000)
                .add(Duration(days: -spots_missing)));
        price_spots.add(FlSpot(firstPoint.seconds.toDouble(), reference.y));
      }

      price_spots.addAll(_pairData.price_spots);

    } else {
      int spots_missing = 0;
      switch (widget.settings.scaleLineChart) {
        case ScaleLineChart.WEEK1:
          spots_missing = 7;
          break;
        case ScaleLineChart.WEEK2:
          spots_missing = 14;
          break;
        case ScaleLineChart.MONTH1:
          spots_missing = 30;
          break;
        case ScaleLineChart.MONTH6:
          spots_missing = 180;
          break;
        case ScaleLineChart.YEAR1:
          spots_missing = 365;
          break;
      }
      price_spots.add(FlSpot(
          Timestamp.fromMillisecondsSinceEpoch(DateTime.now()
                  .add(Duration(days: -spots_missing))
                  .millisecondsSinceEpoch)
              .seconds
              .toDouble(),
          1.toDouble()));
      price_spots.add(FlSpot(Timestamp.now().seconds.toDouble(), 1.toDouble()));

      _pairData.max = 2;
      _pairData.min = 0;
      widget.color = Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    _pairData = widget.user.pairDataItems[widget.pair];
    fillLineChart();
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
        xmin = DateTime.now().add(Duration(days: -180)).millisecondsSinceEpoch /
            1000;
        break;
      case ScaleLineChart.YEAR1:
        xmin = DateTime.now().add(Duration(days: -365)).millisecondsSinceEpoch /
            1000;
        break;
    }
    return Container(
      height: 64,
      //padding: EdgeInsets.,
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            enabled: false,
            touchTooltipData: LineTouchTooltipData(
                fitInsideHorizontally: true,
                fitInsideVertically: true,
                showOnTopOfTheChartBoxArea: true,
                tooltipBgColor: Colors.grey,
                getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                  DateTime date = Timestamp.fromMillisecondsSinceEpoch(
                          touchedBarSpots[0].x.toInt() * 1000)
                      .toDate();
                  String dateString = DateFormat('MMM d').format(date);

                  //print("${touchedBarSpots[0].barIndex} - ${touchedBarSpots[0].y}");
                  //int index = touchedBarSpots[0].barIndex;
                  LineTooltipItem _priceTooltip = LineTooltipItem(
                      "${dateString}\n",
                      TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text:
                              '${"Price: "} ${doubleToValueString(touchedBarSpots[touchedBarSpots[0].barIndex == 0 ? 0 : 1].y)}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        TextSpan(
                          text: ' ${_pairData.pair.split("/")[1]}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ]);

                  LineTooltipItem _avgTooltip = LineTooltipItem(
                      "AVG: ${doubleToValueString(touchedBarSpots[touchedBarSpots[0].barIndex == 0 ? 1 : 0].y)}",
                      TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.normal,
                      ),
                      children: [
                        TextSpan(
                          text: ' ${_pairData.pair.split("/")[1]}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                          ),
                        )
                      ]);

                  return [_priceTooltip, _avgTooltip];
                }),
            //touchCallback: (LineTouchResponse touchResponse) {},
            //handleBuiltInTouches: true,
          ),
          clipData: FlClipData.vertical(),
          gridData: FlGridData(
            show: false,
          ),
          titlesData: FlTitlesData(
            bottomTitles: SideTitles(
              showTitles: false,
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
            show: true,
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
          maxY: _pairData.max * 1.01,
          minY: _pairData.min * 0.95,
          lineBarsData: [
            LineChartBarData(
              spots: price_spots,
              isCurved: true,
              curveSmoothness: 0,
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
                      strokeWidth: 0,
                      //trokeColor: Colors.green
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
              spots: _pairData.avg_price_spots,
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
        ),
        swapAnimationCurve: Curves.linear,
        swapAnimationDuration: Duration(milliseconds: 250),
      ),
    );
  }
}
