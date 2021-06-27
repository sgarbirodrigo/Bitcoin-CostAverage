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
  Color color;
  PairData pairData;

  PriceAVGChartLinePair({this.user, this.settings, this.pairData, this.color});

  @override
  State<StatefulWidget> createState() => PriceAVGChartLinePairState();
}

class PriceAVGChartLinePairState extends State<PriceAVGChartLinePair> {
  //bool isShowingMainData;
  double interval; //intervalo de 24 horas
  //ScaleLineChart selectedScaleLineChart;
  List<FlSpot> price_spots = List();
  List<FlSpot> avg_price_spots = List();
  double xmin, xmax;
  Color _chartLineColor = Colors.deepPurple.withOpacity(1);

  @override
  void initState() {
    super.initState();
  }

  void setScale() {
    xmin = widget.pairData.historyItems.first.timestamp.seconds.toDouble();
    xmax = widget.pairData.historyItems.last.timestamp.seconds.toDouble();
    interval = (xmax - xmin) / 7;
  }

  @override
  Widget build(BuildContext context) {
    price_spots = widget.pairData.price_spots;
    avg_price_spots = widget.pairData.avg_price_spots;
    //xmax = DateTime.now().millisecondsSinceEpoch / 1000;
    //xmin = DateTime.now().add(Duration(days: -7)).millisecondsSinceEpoch / 1000;
    //interval = (1.0 * (60 * 60 * 24)) - 1;
    setScale();
    return Column(
      children: [
        Container(
          height: 200,
          padding: EdgeInsets.only(bottom: 8),
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                    fitInsideHorizontally: true,
                    //fitInsideVertically: true,
                    /*showOnTopOfTheChartBoxArea: true,*/
                    tooltipBgColor: Colors.black,
                    maxContentWidth: 256,
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      DateTime date = Timestamp.fromMillisecondsSinceEpoch(
                              touchedBarSpots[0].x.toInt() * 1000)
                          .toDate();
                      String dateString = DateFormat('MMM d - hh:mm').format(date);
                      LineTooltipItem _priceTooltip = LineTooltipItem(
                          "${dateString}\n",
                          TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  '${"Price: "} ${doubleToValueString(touchedBarSpots[touchedBarSpots[0].barIndex == 0 ? 0 : 1].y)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            TextSpan(
                              text: ' ${widget.pairData.pair.split("/")[1]}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ]);

                      LineTooltipItem _avgTooltip = LineTooltipItem(
                          "AVG: ${doubleToValueString(touchedBarSpots[touchedBarSpots[0].barIndex == 0 ? 1 : 0].y)}",
                          TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                          children: [
                            TextSpan(
                              text: ' ${widget.pairData.pair.split("/")[1]}',
                              style: TextStyle(
                                fontSize: 16,
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
                  reservedSize: 0,
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
                  interval: interval == 0 ? 1 : interval,
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
                    //print("inter: ${interval} - ${60*60*24}");
                    if (interval < 60 * 60 * 24) {
                      xTitle =
                          "${DateFormat('hh:mm\nMMM d').format(timestamp.toDate())}";
                    }

                    if (timestamp.seconds ==
                            widget.pairData.price_spots.first.x ||
                        timestamp.seconds ==
                            widget.pairData.price_spots.last.x) {
                      return "";
                    }
                    return xTitle;
                  },
                ),
                leftTitles: SideTitles(
                  interval: widget.pairData.avgPrice * 0.03,
                  showTitles: true,
                  reservedSize: 0,
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
                  border: Border.all(color: Colors.transparent, width: 1)),
              minX: xmin,
              maxX: xmax,
              maxY: widget.pairData.max * 1.01,
              minY: widget.pairData.min * 0.95,
              lineBarsData: [
                LineChartBarData(
                  spots: price_spots,
                  isCurved: true,
                  curveSmoothness:0,
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
          //height: 64,
          margin: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: Column(
                children: [
                  Text(
                    "Average Price",
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "${doubleToValueString(widget.pairData.avgPrice)} ${widget.pairData.pair.split("/")[1]}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 8,
                  ),
                  DotWidget(
                    dashColor: Colors.deepPurple,
                    dashHeight: 2,
                    totalWidth: 60,
                    dashWidth: 8,
                  )
                ],
              )),
              Expanded(
                  child: Column(
                children: [
                  Text("Price Now", textAlign: TextAlign.center),
                  Text(
                    "${doubleToValueString(widget.settings.binanceTicker[widget.pairData.pair.replaceAll("/", "")])} ${widget.pairData.pair.split("/")[1]}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 8,
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
       Card(
          color: Colors.white,elevation: 6,
          /*decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.all(Radius.circular(16.0))),*/
          margin: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        ScaleLineChart.WEEK1 == widget.settings.scaleLineChart
                            ? MaterialStateProperty.all<Color>(
                                Colors.deepPurple.withOpacity(0.2),
                              )
                            : null,
                  ),
                  onPressed: () {
                    this.setState(() {
                      widget.settings
                          .updateScaleLineChart(ScaleLineChart.WEEK1);
                      //interval = (2.0 * (60 * 60 * 24)) - 1;
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
                    //interval = (4.0 * (60 * 60 * 24)) - 1;
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
                    //interval = (8.0 * (60 * 60 * 24)) - 1;
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
                    //interval = (28.0 * (60 * 60 * 24)) - 1;
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
                      //interval = (60.0 * (60 * 60 * 24)) - 1;
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
