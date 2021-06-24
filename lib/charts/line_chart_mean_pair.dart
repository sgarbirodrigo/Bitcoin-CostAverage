import 'package:Bit.Me/tools.dart';
import 'package:Bit.Me/widgets/dashed_line.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'line_chart_mean.dart';
import '../models/settings_model.dart';
import '../models/user_model.dart';

class PriceAVGChartLinePair extends StatefulWidget {
  User user;
  Settings settings;
  String pair;
  Color color;
  double avgPrice;

  PriceAVGChartLinePair(
      {this.user, this.settings, this.pair, this.color, this.avgPrice});

  @override
  State<StatefulWidget> createState() => PriceAVGChartLinePairState();
}

class PriceAVGChartLinePairState extends State<PriceAVGChartLinePair> {
  //bool isShowingMainData;
  double interval = 1000000; //intervalo de 24 horas
  ScaleLineChart selectedScaleLineChart;
  PairData _pairData;
  List<FlSpot> price_spots = List();
  List<FlSpot> avg_price_spots = List();
  double xmin, xmax;
  Color _chartLineColor = Colors.deepPurple.withOpacity(1);

  @override
  void initState() {
    super.initState();
    interval = (1.0 * (60 * 60 * 24));
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
    //_pairData = widget.user.pairDataItems[widget.pair];
    //print("pairItens: ${_pairData.historyItems.length}");
  }

  @override
  Widget build(BuildContext context) {
    _pairData = widget.user.pairDataItems[widget.pair];
    price_spots = _pairData.price_spots;
    avg_price_spots = _pairData.avg_price_spots;
    xmax = DateTime.now().millisecondsSinceEpoch / 1000;
    xmin = DateTime.now().add(Duration(days: -7)).millisecondsSinceEpoch / 1000;
    //interval = (1.0 * (60 * 60 * 24)) - 1;
    switch (widget.settings.scaleLineChart) {
      case ScaleLineChart.WEEK1:
        xmin = DateTime.now().add(Duration(days: -7)).millisecondsSinceEpoch /
            1000;
        interval = (2.0 * (60 * 60 * 24)) - 1;
        break;
      case ScaleLineChart.WEEK2:
        xmin = DateTime.now().add(Duration(days: -14)).millisecondsSinceEpoch /
            1000;
        interval = (4.0 * (60 * 60 * 24)) - 1;
        break;
      case ScaleLineChart.MONTH1:
        xmin = DateTime.now().add(Duration(days: -30)).millisecondsSinceEpoch /
            1000;
        interval = (8.0 * (60 * 60 * 24)) - 1;
        break;
      case ScaleLineChart.MONTH6:
        xmin = DateTime.now().add(Duration(days: -180)).millisecondsSinceEpoch /
            1000;
        interval = (28.0 * (60 * 60 * 24)) - 1;
        break;
      case ScaleLineChart.YEAR1:
        xmin = DateTime.now().add(Duration(days: -365)).millisecondsSinceEpoch /
            1000;
        interval = (55.0 * (60 * 60 * 24)) - 1;
        break;
    }
    return Column(
      children: [
        Text(
          "Purchase History",
          style: TextStyle(
              fontSize: 24,
              color: Colors.deepPurple,
              fontFamily: 'Arial Rounded MT Bold'),
        ),
        Container(
          height: 16,
        ),
        Container(
          height: 64,
          margin: EdgeInsets.only(left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text("Average Price",textAlign: TextAlign.center,),
                    Container(
                      height: 16,
                    ),
                    DotWidget(
                      dashColor: Colors.deepPurple,
                      dashHeight: 2,
                      totalWidth: 60,
                      dashWidth: 8,
                    )
                  ],
                ),
              ),
              Container(
                width: 64,
              ),
              Expanded(
                  child: Column(
                children: [
                  Text("Purchase Price",textAlign: TextAlign.center),
                  Container(
                    height: 16,
                  ),
                  DotWidget(
                    dashColor: Colors.deepPurple,
                    dashHeight: 2,
                    totalWidth: 80,
                    dashWidth: 50,
                  )
                ],
              ))
            ],
          ),
        ),
        Container(
          height: 200,
          padding: EdgeInsets.only(bottom: 8),
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                    fitInsideHorizontally: true,
                    fitInsideVertically: true,
                    /*showOnTopOfTheChartBoxArea: true,*/
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
                touchCallback: (LineTouchResponse touchResponse) {},
                handleBuiltInTouches: true,
              ),
              //clipData: FlClipData.vertical(),
              gridData: FlGridData(
                show: false,
                drawVerticalLine: true,
                drawHorizontalLine: true,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: _chartLineColor,
                    strokeWidth: 1,
                  );
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: _chartLineColor,
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                rightTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 20,
                  getTitles: (value) {
                    Timestamp timestamp = Timestamp.fromMillisecondsSinceEpoch(
                        (value * 1000).toInt());
                    String xTitle =
                        "${DateFormat('MMM d').format(timestamp.toDate())}";
                    return "";
                  },
                  margin: 0,
                ),
                bottomTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 10,
                  interval: interval,
                  getTextStyles: (value) => const TextStyle(
                    color: Color(0xff72719b),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  margin: 12,
                  getTitles: (value) {
                    Timestamp timestamp = Timestamp.fromMillisecondsSinceEpoch(
                        (value * 1000).toInt());
                    String xTitle =
                        "${DateFormat('MMM d').format(timestamp.toDate())}";
                    return xTitle;
                  },
                ),
                leftTitles: SideTitles(
                  interval: widget.avgPrice * 0.03,
                  showTitles: true,
                  getTextStyles: (value) => const TextStyle(
                    color: Color(0xff75729e),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  getTitles: (value) {
                    /*return "${doubleToValueString(value)}";*/
                    return "";
                  },
                  margin: 0,
                  //reservedSize: 84,
                ),
              ),
              borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: _chartLineColor, width: 1)),
              minX: xmin,
              maxX: xmax,
              maxY: _pairData.max * 1.01,
              minY: _pairData.min * 0.95,
              lineBarsData: [
                LineChartBarData(
                  spots: price_spots,
                  isCurved: true,
                  curveSmoothness: 0.2,
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
            ),
            swapAnimationCurve: Curves.linear,
            swapAnimationDuration: Duration(milliseconds: 500),
          ),
        ),
        Container(
          color: Colors.grey.shade200,
          margin: EdgeInsets.only(top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        ScaleLineChart.WEEK1 == widget.settings.scaleLineChart
                            ? MaterialStateProperty.all<Color>(
                                Colors.deepPurple.withOpacity(0.2))
                            : null,
                  ),
                  onPressed: () {
                    this.setState(() {
                      widget.settings
                          .updateScaleLineChart(ScaleLineChart.WEEK1);
                      interval = (2.0 * (60 * 60 * 24)) - 1;
                      widget.user.forceUpdateHistoryData(7);
                    });
                  },
                  child: Text("1W")),
              TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      ScaleLineChart.WEEK2 == widget.settings.scaleLineChart
                          ? MaterialStateProperty.all<Color>(
                              Colors.deepPurple.withOpacity(0.2))
                          : null,
                ),
                onPressed: () {
                  this.setState(() {
                    widget.settings.updateScaleLineChart(ScaleLineChart.WEEK2);
                    interval = (4.0 * (60 * 60 * 24)) - 1;
                    widget.user.forceUpdateHistoryData(14);
                  });
                },
                child: Text("2W"),
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      ScaleLineChart.MONTH1 == widget.settings.scaleLineChart
                          ? MaterialStateProperty.all<Color>(
                              Colors.deepPurple.withOpacity(0.2))
                          : null,
                ),
                onPressed: () {
                  this.setState(() {
                    widget.settings.updateScaleLineChart(ScaleLineChart.MONTH1);
                    interval = (8.0 * (60 * 60 * 24)) - 1;
                    widget.user.forceUpdateHistoryData(30);
                  });
                },
                child: Text("1M"),
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      ScaleLineChart.MONTH6 == widget.settings.scaleLineChart
                          ? MaterialStateProperty.all<Color>(
                              Colors.deepPurple.withOpacity(0.2))
                          : null,
                ),
                onPressed: () {
                  this.setState(() {
                    widget.settings.updateScaleLineChart(ScaleLineChart.MONTH6);
                    interval = (28.0 * (60 * 60 * 24)) - 1;
                    widget.user.forceUpdateHistoryData(180);
                  });
                },
                child: Text("6M"),
              ),
              TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        ScaleLineChart.YEAR1 == widget.settings.scaleLineChart
                            ? MaterialStateProperty.all<Color>(
                                Colors.deepPurple.withOpacity(0.2))
                            : null,
                  ),
                  onPressed: () {
                    this.setState(() {
                      widget.settings
                          .updateScaleLineChart(ScaleLineChart.YEAR1);
                      interval = (60.0 * (60 * 60 * 24)) - 1;
                      widget.user.forceUpdateHistoryData(365);
                    });
                  },
                  child: Text("1Y"))
            ],
          ),
        ),
        AnimatedContainer(
            height: widget.user.isUpdatingHistory ? 4 : 0,
            duration: Duration(milliseconds: 250),
            child: LinearProgressIndicator()),
      ],
    );
  }
}