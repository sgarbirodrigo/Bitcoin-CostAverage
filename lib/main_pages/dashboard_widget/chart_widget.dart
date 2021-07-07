import 'package:Bit.Me/chart_widget_emptyexample.dart';
import 'package:Bit.Me/models/settings_model.dart';
import 'package:Bit.Me/tools.dart';
import 'package:Bit.Me/widgets/circular_progress_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../contants.dart';
import '../../models/user_model.dart';

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
  SettingsApp settings;
  final UserManager user;

  ChartWidget(this.user, this.settings);

  @override
  State<StatefulWidget> createState() {
    return _ChartWidgetState();
  }
}

class _ChartWidgetState extends State<ChartWidget> {
  int touchedIndex = -1;
  List<int> _multiplierOptions = [1, 4];
  int _multiplier;
  List<String> _multiplierOptionsTitles = ["weekly", "monthly"];
  int _multiplierIndex;
  List<MyChartSectionData> data;
  final _animatedKey = new GlobalKey();

  @override
  void initState() {
    _multiplier = _multiplierOptions[0];
    _multiplierIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    double legendHeight = 42;
    data = convertUserData(widget.user);
    /*print(
        "selected ${widget.settings.base_pair} - ${widget.settings.getBaseCoin()}  ");
    print("exp ${widget.user.userTotalExpendingAmount}");*/
    bool isDataChartLoaded = true;
    if (data == null) {
      isDataChartLoaded = false;
    } else {
      if (!(data.length > 0)) isDataChartLoaded = false;
    }
    if (!(widget.user.userTotalBuyingAmount.length > 0)) isDataChartLoaded = false;

    return AnimatedContainer(
        key: _animatedKey,
        duration: Duration(seconds: 2),
        //height: 600,
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15.0,
              offset: Offset(0.0, 0.75),
            )
          ],
          color: Colors.white,
        ),
        child: AnimatedSwitcher(
          duration: Duration(seconds: 1),
          child: isDataChartLoaded
              ? Column(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 32),
                          child: Text(
                            "${returnCurrencyName(widget.settings.getBaseCoin())} Allocation",
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                  icon: Icon(
                                    Icons.chevron_left,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    _multiplierIndex -= 1;
                                    if (_multiplierIndex < 0) {
                                      _multiplierIndex = _multiplierOptions.length - 1;
                                    }
                                    setState(() {
                                      _multiplier = _multiplierOptions[_multiplierIndex];
                                    });
                                  }),
                              Text(
                                _multiplierOptionsTitles[_multiplierIndex],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 20,
                                    color: Colors.black.withOpacity(0.7)),
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.chevron_right,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    _multiplierIndex += 1;
                                    if (_multiplierIndex > _multiplierOptions.length - 1) {
                                      _multiplierIndex = 0;
                                    }
                                    setState(() {
                                      _multiplier = _multiplierOptions[_multiplierIndex];
                                    });
                                  })
                            ],
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.width * 0.7,
                          child: Stack(children: [
                            Center(
                              child: PieChart(
                                PieChartData(
                                    pieTouchData: PieTouchData(
                                      touchCallback: (pieTouchResponse) {
                                        setState(
                                          () {
                                            final desiredTouch =
                                                pieTouchResponse.touchInput is! PointerExitEvent &&
                                                    pieTouchResponse.touchInput is! PointerUpEvent;
                                            if (desiredTouch &&
                                                pieTouchResponse.touchedSection != null) {
                                              touchedIndex = pieTouchResponse
                                                  .touchedSection.touchedSectionIndex;
                                            } else {
                                              touchedIndex = -1;
                                            }
                                          },
                                        );
                                      },
                                    ),
                                    borderData: FlBorderData(
                                      show: false,
                                    ),
                                    sectionsSpace: 1,
                                    centerSpaceRadius: 84,
                                    sections: List.generate(data.length, (i) {
                                      final isTouched = i == touchedIndex;
                                      //final fontSize = isTouched ? 20.0 : 16.0;
                                      // final radius = isTouched ? 62.0 : 48.0;
                                      final radius = 48.0;
                                      final fontSize = 16.0;
                                      final Color sectionColor = colorsList[i];
                                      return PieChartSectionData(
                                        badgePositionPercentageOffset: isTouched ? -1.5 : 2.8,
                                        color: sectionColor,
                                        value: data[i].percentage,
                                        title: "${(data[i].percentage * 100).toStringAsFixed(0)}%",
                                        radius: radius,
                                        //showTitle: false,
                                        titleStyle: TextStyle(
                                            fontSize: fontSize,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xffffffff)),
                                      );
                                    })),

                                swapAnimationDuration: Duration(milliseconds: 250), // Optional
                                swapAnimationCurve: Curves.linear, // Optional
                              ),
                            ),
                            Center(
                              child: Container(
                                width: 169,
                                height: 169,
                                decoration: BoxDecoration(
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.6),
                                          blurRadius: 16.0,
                                          offset: Offset(0.0, 0.0))
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(128))),
                                child: Center(
                                    child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Trading",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'Arial',
                                          fontSize: 24,
                                          color: Colors.black.withOpacity(0.7)),
                                    ),
                                    FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        "${returnCurrencyCorrectedNumber(widget.settings.getBaseCoin(), widget.user.userTotalExpendingAmount[widget.settings.getBaseCoin()] != null ? (widget.user.userTotalExpendingAmount[widget.settings.getBaseCoin()] * _multiplier) : 0.0)}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                )),
                              ),
                            ),
                          ]),
                        ),
                        AnimatedContainer(
                          height: data != null
                              ? ((data.length / 2).ceil().toDouble() * legendHeight) + 16
                              : 0,
                          duration: Duration(milliseconds: 250),
                          child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 0,
                                childAspectRatio:
                                    ((MediaQuery.of(context).size.width - 32) / 2) / legendHeight),
                            // padding: EdgeInsets.all(8),
                            //shrinkWrap: true,
                            itemCount: data != null ? data.length : 0,
                            itemBuilder: (context, index) {
                              //widget.settings.updateBasePair(data[index].pair);
                              return GestureDetector(
                                onTap: () {
                                  widget.settings.updateBasePair(data[index].pair);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 4, right: 4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(4),
                                          color: colorsList[index],
                                        ),
                                        margin: EdgeInsets.symmetric(horizontal: 16),
                                        height: 12,
                                        width: 12,
                                      ),
                                      //Container(width: ,),
                                      Expanded(
                                        child: Container(
                                          //color: Colors.red,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                data[index].pair,
                                                style: TextStyle(
                                                    fontFamily: 'Arial',
                                                    fontSize: 24,
                                                    //fontWeight: FontWeight.w400,
                                                    color: Colors.black),
                                              ),
                                              RichText(
                                                textAlign: TextAlign.left,
                                                softWrap: true,
                                                text: TextSpan(
                                                  text: '',
                                                  style: TextStyle(
                                                      color: Colors.black.withOpacity(0.4),
                                                      fontSize: 11),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text:
                                                          '${returnCurrencyCorrectedNumber(data[index].pair.split("/")[1], data[index].amount * _multiplier)}',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                    TextSpan(text: ' for '),
                                                    TextSpan(
                                                      text:
                                                          '${data[index].pair.toString().split("/")[0]}',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                    TextSpan(text: ''),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 64,
                      decoration: BoxDecoration(
                        color: Color(0xffF7F8F9),
                        border: Border(
                          top: BorderSide(color: Colors.deepPurple, width: 0.5),
                        ),
                      ),
                      child: Center(
                        child: Container(
                          //color: Colors.red,
                          alignment: Alignment.center,
                          //width: ,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.user.userTotalExpendingAmount.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                List coins = widget.user.userTotalExpendingAmount.keys.toList();
                                List<String> openPairs = List();
                                widget.user.userTotalExpendingAmount.forEach((key, value) {
                                  openPairs.add("$key/$value");
                                });
                                return GestureDetector(
                                  onTap: () {
                                    //widget.settings.updateBaseCoin(coins[index]);
                                    String initial = widget.user.userTotalBuyingAmount.keys
                                        .where((element) => element.contains("/${coins[index]}"))
                                        .first;
                                    print("pair: ${initial}");
                                    widget.settings.updateBasePair(initial);
                                    // widget.settings.base_pair_color = colorsList[0];
                                  },
                                  child: AnimatedContainer(
                                    width: 150,
                                    //padding: EdgeInsets.symmetric(horizontal: 16),
                                    decoration: BoxDecoration(
                                      //color: Color(0xffF7F8F9),
                                      color: coins[index] == widget.settings.getBaseCoin()
                                          ? Colors.deepPurple.shade50
                                          : Color(0xffF7F8F9),
                                      border: coins[index] == widget.settings.getBaseCoin()
                                          ? Border(
                                              top: BorderSide(color: Colors.deepPurple, width: 4),
                                              right: BorderSide(
                                                  color: Colors.black.withOpacity(0.3), width: 0.5),
                                              left: BorderSide(
                                                  color: Colors.black.withOpacity(0.3), width: 0.5))
                                          : Border(
                                              top: BorderSide(color: Colors.deepPurple, width: 0.5),
                                              right: BorderSide(
                                                  color: Colors.black.withOpacity(0.3), width: 0.5),
                                              left: BorderSide(
                                                  color: Colors.black.withOpacity(0.3),
                                                  width: 0.5)),
                                    ),
                                    duration: Duration(milliseconds: 250),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: coins[index] == widget.settings.getBaseCoin()
                                                  ? 4
                                                  : 8),
                                          child: Text(
                                            "${returnCurrencyName(coins[index])}",
                                            style: TextStyle(
                                                fontFamily: 'Arial',
                                                fontSize: 24,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Container(
                                          height: 0,
                                        ),
                                        /*Text(
                                    "${widget.user.userTotalExpendingAmount[coins[index]] * _multiplier} ${coins[index]}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                  ),*/
                                        Text(
                                          widget.user.balance != null
                                              ? "${returnCurrencyCorrectedNumber(coins[index], widget.user.balance.balancesMapped[coins[index]])}"
                                              : "...",
                                          style: TextStyle(
                                              color: Colors.black, fontWeight: FontWeight.w400),
                                        ),
                                        Container(
                                          height: 4,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                    )
                  ],
                )
              : ExampleChartPie(),
        ));
  }

  List<MyChartSectionData> convertUserData(UserManager user) {
    try {
      List<MyChartSectionData> data = List();
      double total = 0;
      user.userTotalBuyingAmount.forEach((pair, amount) {
        if (pair.split("/")[1] == widget.settings.getBaseCoin()) {
          double price = widget.settings.binanceTicker["BTC${pair.split("/")[1]}"];
          double percentage;
          if (price == null) {
            percentage = amount;
          } else {
            percentage = amount / price;
          }
          total += percentage;
        }
      });
      user.userTotalBuyingAmount.forEach((pair, amount) {
        if (pair.split("/")[1] == widget.settings.getBaseCoin()) {
          double price = widget.settings.binanceTicker["BTC${pair.split("/")[1]}"];
          double percentage = 1;
          if (price == null) {
            percentage = amount;
          } else {
            percentage = amount / price;
          }
          //print(percentage/total);
          if (amount >= 0) {
            data.add(MyChartSectionData(pair, percentage / total, amount));
          }
        }
      });
      return data;
    } catch (e) {
      //print("Error: ${e}");
      return null;
    }
  }
}
