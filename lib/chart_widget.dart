import 'package:bitbybit/dialog_config.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyChartSectionData {
  String _pair;
  double _percentage;
  double _amount;

  String get pair => _pair;

  set pair(String value) {
    _pair = value;
  }

  MyChartSectionData(this._pair, this._percentage, this._amount);

  double get percentage => _percentage;

  set percentage(double value) {
    _percentage = value;
  }

  double get amount => _amount;

  set amount(double value) {
    _amount = value;
  }
}

class ChartWidget extends StatefulWidget {
  List<MyChartSectionData> data;
  Map<String, double> totalExpending;
  double trading_daily;
  String base_unit;
  Function basecoin_onChange;

  ChartWidget(this.data, this.trading_daily, this.base_unit,
      this.basecoin_onChange, this.totalExpending);

  @override
  State<StatefulWidget> createState() {
    return _ChartWidgetState();
  }
}

class _ChartWidgetState extends State<ChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width*0.9,
      //color: Color(0xffF9F8FD),
      child: Stack(children: [
        widget.trading_daily != null
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Trading ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 18,
                          color: Colors.black.withOpacity(0.7)),
                    ),
                    Text(
                      "${widget.trading_daily} ${widget.base_unit}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Text(
                      " daily",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 18,
                          color: Colors.black.withOpacity(0.7)),
                    )
                  ],
                ),
              )
            : Center(
                child: Container(
                  width:256,
                  child: Text(
                    "Each order you create will be easily shown here so you can better understand your money flow.",
                    textAlign: TextAlign.center,style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
        Center(
          child: PieChart(
            PieChartData(
                pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                  setState(() {
                    final desiredTouch =
                        pieTouchResponse.touchInput is! PointerExitEvent &&
                            pieTouchResponse.touchInput is! PointerUpEvent;
                    if (desiredTouch &&
                        pieTouchResponse.touchedSection != null) {
                      touchedIndex =
                          pieTouchResponse.touchedSection.touchedSectionIndex;
                    } else {
                      touchedIndex = -1;
                    }
                  });
                }),
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 1,
                centerSpaceRadius: 54,
                sections: showingSections()),

            swapAnimationDuration: Duration(milliseconds: 250), // Optional
            swapAnimationCurve: Curves.linear, // Optional
          ),
        ),
      ]),
    );
  }

  List<Color> colorsList = [
    Color(0xff845bef),
    Color(0xffF47A1F),
    Color(0xff0293ee),
    Color(0xff13d38e),
    Color(0xfff8b250),
    Color(0xff67C3D0),
    Color(0xffE97B86),
    Color(0xff377B2B),
    Color(0xff7AC142),
    Color(0xff007CC3)
  ];

  PieChartSectionData SectionData(i) {
    final isTouched = i == touchedIndex;
    final fontSize = isTouched ? 16.0 : widget.data[i].percentage>=1?10.0:12.0;
    final radius = isTouched ? 48.0 : 30.0;
    final Color sectionColor = colorsList[i];
    return PieChartSectionData(
      badgePositionPercentageOffset: isTouched ? -1.5 : 2.8,
      badgeWidget: GestureDetector(
        child: Card(
          color: sectionColor,
          elevation: widget.totalExpending.keys
                  .contains(widget.data[i].pair.split("/")[0])
              ? 4
              : 0,
          child: Container(
            height: 48,
            width: 96,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.data[i].pair,
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  widget.data[i].amount.toString() +
                      " " +
                      widget.data[i].pair.split("/")[1],
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                )
              ],
            ),
          ),
        ),
        onTap: () {
          widget.basecoin_onChange(widget.data[i].pair.split("/")[0]);
        },
      ),
      color: sectionColor,
      value: widget.data[i].percentage,
      title: "${(widget.data[i].percentage * 100).toStringAsFixed(0) }%",
      radius: radius,
      //showTitle: false,
      titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w400,
          color: const Color(0xffffffff)),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(widget.data.length, (i) {
      return SectionData(i);
    });
  }
}
