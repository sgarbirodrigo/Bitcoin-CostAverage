import 'dart:convert';
import 'package:bitbybit/models/settings_model.dart';
import 'package:quiver/iterables.dart';
import 'package:bitbybit/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'binanceOrderMaker.dart';
import 'models/history_model.dart';

class PriceAVGChartLine extends StatefulWidget {
  User user;
  Settings settings;

  PriceAVGChartLine(this.user, this.settings);

  @override
  State<StatefulWidget> createState() => PriceAVGChartLineState();
}

enum ScaleLineChart { WEEK1, WEEK2, MONTH1, MONTH6, YEAR1 }

class PriceAVGChartLineState extends State<PriceAVGChartLine> {
  //bool isShowingMainData;
  double interval; //intervalo de 24 horas
  ScaleLineChart selectedScaleLineChart;

  @override
  void initState() {
    super.initState();
    xmax = DateTime.now().millisecondsSinceEpoch / 1000;
    xmin = DateTime.now().add(Duration(days: -7)).millisecondsSinceEpoch / 1000;
    selectedScaleLineChart = ScaleLineChart.WEEK1;
    interval = (1.0 * (60 * 60 * 24)) - 1;
    selectedScaleLineChart = ScaleLineChart.WEEK1;
    //isShowingMainData = false;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.only(top: 0, left: 16, bottom: 16, right: 16),
        child: AspectRatio(
          aspectRatio: 1.75,
          child: Container(
            /*decoration: const BoxDecoration(
          //borderRadius: BorderRadius.all(Radius.circular(18)),
          gradient: LinearGradient(
            colors: [
              Color(0xff2c274c),
              Color(0xff46426c),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),*/
            padding: EdgeInsets.all(16),
            child: Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    /*Text(
                      '${widget.settings.base_pair}',
                      style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2),
                      textAlign: TextAlign.center,
                    ),*/
                    const SizedBox(
                      height: 4,
                    ),
                    /*Text(
                      '${widget.settings.base_pair}',
                      style: TextStyle(
                        color: Color(0xff827daa),
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),*/
                    /*const SizedBox(
                      height: 37,
                    ),*/
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 0, left: 0),
                        child: LineChart(
                          sampleData2(),
                          swapAnimationDuration:
                              const Duration(milliseconds: 250),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            onPressed: () {
                              setState(() {
                                xmin = DateTime.now()
                                        .add(Duration(days: -7))
                                        .millisecondsSinceEpoch /
                                    1000;
                                interval = (1.0 * (60 * 60 * 24)) - 1;
                                selectedScaleLineChart = ScaleLineChart.WEEK1;
                              });
                            },
                            child: Text("1W")),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                xmin = DateTime.now()
                                        .add(Duration(days: -14))
                                        .millisecondsSinceEpoch /
                                    1000;
                                interval = (2.0 * (60 * 60 * 24)) - 1;
                                selectedScaleLineChart = ScaleLineChart.WEEK2;
                              });
                            },
                            child: Text("2W")),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                xmin = DateTime.now()
                                        .add(Duration(days: -30))
                                        .millisecondsSinceEpoch /
                                    1000;
                                interval = (7.0 * (60 * 60 * 24)) - 1;
                                selectedScaleLineChart = ScaleLineChart.MONTH1;
                              });
                            },
                            child: Text("1M")),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                xmin = DateTime.now()
                                        .add(Duration(days: -180))
                                        .millisecondsSinceEpoch /
                                    1000;
                                interval = (30.0 * (60 * 60 * 24)) - 1;
                                selectedScaleLineChart = ScaleLineChart.MONTH6;
                              });
                            },
                            child: Text("6M")),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                xmin = DateTime.now()
                                        .add(Duration(days: -365))
                                        .millisecondsSinceEpoch /
                                    1000;
                              });
                              interval = (30.0 * (60 * 60 * 24)) - 1;
                              selectedScaleLineChart = ScaleLineChart.YEAR1;
                            },
                            child: Text("1Y"))
                      ],
                    )
                    /*const SizedBox(
                      height: 10,
                    ),*/
                  ],
                ),
                /* IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white.withOpacity(1.0),
              ),
              onPressed: () {
                setState(() {
                  //isShowingMainData = !isShowingMainData;
                });
              },
            )*/
              ],
            ),
          ),
        ));
  }

  /*LineChartData sampleData1() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'SEPT';
              case 7:
                return 'OCT';
              case 12:
                return 'DEC';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '1m';
              case 2:
                return '2m';
              case 3:
                return '3m';
              case 4:
                return '5m';
            }
            return '';
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 4,
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
      minX: 0,
      maxX: 14,
      maxY: 4,
      minY: 0,
      lineBarsData: linesBarData1(),
    );
  }*/
/*
  List<FlSpot> prepareHistoryData() {
    List<FlSpot> data = List();
    Firestore.instance
        .collection("users")
        .document(widget.user.firebasUser.uid)
        .collection("history")
        .orderBy("timestamp", descending: true)
        .getDocuments()
        .then((QuerySnapshot value) {
      if (value.documents.length > 0) {
        value.documents.forEach((DocumentSnapshot element) {
          if (element.data["result"] == "success") {
            BinanceResponseMakeOrder binanceResponse =
                BinanceResponseMakeOrder.fromJson(
                    json.decode(element.data["response"]));
            data.add(FlSpot(binanceResponse.timestamp.toDouble(),
                double.parse(binanceResponse.info.price)));
          }
        });
      }
    });
    return data;
  }*/
/*
  List<LineChartBarData> linesBarData1() {
    final lineChartBarData1 = LineChartBarData(
      spots: prepareHistoryData(),
      isCurved: true,
      colors: [
        const Color(0xff4af699),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    final lineChartBarData2 = LineChartBarData(
      spots: [
        FlSpot(1, 1),
        FlSpot(3, 2.8),
        FlSpot(7, 1.2),
        FlSpot(10, 2.8),
        FlSpot(12, 2.6),
        FlSpot(13, 3.9),
      ],
      isCurved: true,
      colors: [
        const Color(0xffaa4cfc),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(show: false, colors: [
        const Color(0x00aa4cfc),
      ]),
    );
    final lineChartBarData3 = LineChartBarData(
      spots: [
        FlSpot(1, 2.8),
        FlSpot(3, 1.9),
        FlSpot(6, 3),
        FlSpot(10, 1.3),
        FlSpot(13, 2.5),
      ],
      isCurved: false,
      colors: const [
        Color(0xff27b6fc),
      ],
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    return [
      lineChartBarData1,
      lineChartBarData2,
      lineChartBarData3,
    ];
  }*/
  //259.201.249
  LineChartData sampleData2() {
    _visibleHistoryItems.clear();
    price_spots.clear();
    avg_price_spots.clear();
    avgPrice = 0;
    totalExpended = 0;
    denominador = 0;
    max = null;
    min = null;

    for (final index in range(0, widget.user.historyItems.length)) {
      HistoryItem element = widget.user.historyItems[index];
      if (element.result == TransactinoResult.SUCCESS) {
        if (widget.settings.base_pair == element.order.pair) {
          _visibleHistoryItems.add(element);
          //print("price: ${element.response.price}");
          if (max != null) {
            if (max < element.response.price) {
              max = element.response.price;
            }
          } else {
            max = element.response.price;
          }
          if (min != null) {
            if (min > element.response.price) {
              min = element.response.price;
            }
          } else {
            min = element.response.price;
          }
          /*if (xmax != null) {
            if (xmax < element.timestamp.seconds.toDouble()) {
              xmax = element.timestamp.seconds.toDouble();
            }
          } else {
            xmax = 0;
          }*/

          /*if (xmin != null) {
            if (xmin > element.timestamp.seconds.toDouble()) {
              xmin = element.timestamp.seconds.toDouble();
            }
          } else {
            xmin = element.timestamp.seconds.toDouble();
          }*/

          totalExpended += element.response.filled;
          denominador += element.response.filled * element.response.price;
          avgPrice = denominador / totalExpended;
          //print("filled: ${element.response.filled} / price: ${element.response.price} = ${ element.response.filled*element.response.price}");
          //print("avg: ${avgPrice} - deno: ${denominador} / total: ${totalExpended}");
          /* print(
              "${price_spots.length}: ${(element.timestamp.seconds).toDouble()} // ${element.response.price}");*/
          //print("Price: ${element.response.price} - AVG: ${avgPrice}");

          price_spots.add(FlSpot(
              (element.timestamp.seconds).toDouble(), element.response.price));
          avg_price_spots
              .add(FlSpot((element.timestamp.seconds).toDouble(), avgPrice));
        }
      }
    }

    /*print("min: ${min} - mean: ${avgPrice} -  max: ${max}");
    print("first: ${xmin} - last: ${xmax}");
    print(
        "spots: ${price_spots.length} / itens: ${_visibleHistoryItems.length}");
    double interval = 1.0 * 60 * 60 * 24 - 1; //intervalo de 24 horas
    print("interval = ${interval}");*/

    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 10,
          interval: interval,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          margin: 0,
          getTitles: (value) {
            Timestamp timestamp =
                Timestamp.fromMillisecondsSinceEpoch((value * 1000).toInt());
            String xTitle = "${timestamp.toDate().day}";
            //print(xTitle);
            //return Timestamp.fromMillisecondsSinceEpoch((value*1000).toInt()).toDate()-1000);
            /* print(
                "value: ${value} - dia: ${Timestamp.fromMillisecondsSinceEpoch(value.toInt()).toDate().day.toString()}");*/
            //return Timestamp.fromMillisecondsSinceEpoch(value.toInt()).toDate().day.toString();
            switch (selectedScaleLineChart) {
              case ScaleLineChart.WEEK1:
                return DateFormat('EEE').format(timestamp.toDate());
                break;
              case ScaleLineChart.WEEK2:
                return DateFormat('EEE').format(timestamp.toDate());
                break;
              case ScaleLineChart.MONTH1:
                return DateFormat('d MMM').format(timestamp.toDate());
                break;
              case ScaleLineChart.MONTH6:
                return DateFormat('MMM').format(timestamp.toDate());
                break;
              case ScaleLineChart.YEAR1:
                return DateFormat('MMM').format(timestamp.toDate());
                // TODO: Handle this case.
                break;
            }
            return xTitle;
            return value.toString();
            /*switch (value.toInt()) {
              case 2:
                return 'SEPT';
              case 7:
                return 'OCT';
              case 12:
                return 'DEC';
            }*/
            return '';
          },
        ),
        leftTitles: SideTitles(
          interval: avgPrice * 0.05,
          showTitles: false,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            return value.toStringAsFixed(5);
            /*
            switch (value.toInt()) {
              case 1:
                return '1m';
              case 2:
                return '2m';
              case 3:
                return '3m';
              case 4:
                return '5m';
              case 5:
                return '6m';
            }*/
            return '';
          },
          margin: 16,
          reservedSize: 32,
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
          )),
      minX: xmin,
      maxX: xmax,
      maxY: max,
      minY: min * 0.95,
      lineBarsData: [
        LineChartBarData(
          spots: price_spots,
          isCurved: false,
          //curveSmoothness: 0,
          colors: [
            widget.settings.base_pair_color,
          ],
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),

          belowBarData: BarAreaData(
            show: true,
            colors: [
              widget.settings.base_pair_color.withOpacity(0.5),
              widget.settings.base_pair_color.withOpacity(0.0),
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
          curveSmoothness: 0.4,
          colors: [
            Colors.deepPurple,
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
    );
  }

  List<HistoryItem> _visibleHistoryItems = List();
  List<FlSpot> price_spots = List();
  List<FlSpot> avg_price_spots = List();
  double min, max, xmin, xmax, avgPrice = 0, totalExpended = 0, denominador = 0;
/*
  List<LineChartBarData> linesBarData2() {
    LineChartBarData BTCBRL = ;

    return [
      BTCBRL,
      */ /*LineChartBarData(
        spots: [
          FlSpot(3, 1),
          FlSpot(3, 4),
          FlSpot(5, 1.8),
          FlSpot(7, 5),
          FlSpot(10, 2),
          FlSpot(12, 2.2),
          FlSpot(13, 1.8),
        ],
        isCurved: true,
        curveSmoothness: 0,
        colors: const [
          Color(0x444af699),
        ],
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: false,
        ),
      ),*/ /*
      */ /*LineChartBarData(
        spots: [
          FlSpot(1, 1),
          FlSpot(3, 2.8),
          FlSpot(7, 1.2),
          FlSpot(10, 2.8),
          FlSpot(12, 2.6),
          FlSpot(13, 3.9),
        ],
        isCurved: true,
        colors: const [
          Color(0x99aa4cfc),
        ],
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(show: true, colors: [
          const Color(0x33aa4cfc),
        ]),
      ),*/ /*
      */ /*LineChartBarData(
        spots: [
          FlSpot(1, 3.8),
          FlSpot(3, 1.9),
          FlSpot(6, 5),
          FlSpot(10, 3.3),
          FlSpot(13, 4.5),
        ],
        isCurved: true,
        curveSmoothness: 0,
        colors: const [
          Color(0x4427b6fc),
        ],
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(
          show: false,
        ),
      ),*/ /*
    ];
  }*/
}
