import 'package:Bit.Me/tools.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ExampleChartPie extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ExampleChartPieState();
  }
}

class _ExampleChartPieState extends State<ExampleChartPie> {
  final List<double> dataAmount = [70, 30, 30, 25];
  List<double> dataPercentage=[];
  final List<String> dataPair = ["BTC/USD", "ETH/USD", "NANO/USD", "IOTA/USD"];
  double total = 0;
  @override
  void initState() {
    _multiplier = _multiplierOptions[0];
    _multiplierIndex = 0;

    dataAmount.forEach((element) {
      total+=element;
    });
    dataAmount.forEach((element) {
      dataPercentage.add((element/total));
    });

  }

  double legendHeight = 42;
  List<Color> colors = [
    Colors.grey.shade500,
    Colors.grey.shade300,
    Colors.grey.shade200,
    Colors.grey.shade400,
  ];
  List<int> _multiplierOptions = [1, 4];
  int _multiplier;
  List<String> _multiplierOptionsTitles = ["weekly", "monthly"];
  int _multiplierIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(children: [
          Padding(
            padding: EdgeInsets.only(top: 32),
            child: Text(
              "USD Allocation",
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
                      fontFamily: 'Arial', fontSize: 20, color: Colors.black.withOpacity(0.7)),
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
              child: Stack(
                children: [
                  Center(
                    child: PieChart(
                      PieChartData(
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 1,
                          centerSpaceRadius: 84,
                          sections: List.generate(4, (i) {
                            final radius = 48.0;
                            final fontSize = 16.0;
                            final Color sectionColor = colors[i];

                            return PieChartSectionData(
                              badgePositionPercentageOffset: 2.8,
                              color: sectionColor,
                              value: dataPercentage[i],
                              title: "${(dataPercentage[i] * 100).toStringAsFixed(0)}%",
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
                      decoration: BoxDecoration(boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 16.0,
                            offset: Offset(0.0, 0.0))
                      ], color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(128))),
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
                                color: Colors.black.withOpacity(0.3)),
                          ),
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              "${returnCurrencyCorrectedNumber("USD", total*_multiplier)}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black.withOpacity(0.3)),
                            ),
                          ),
                        ],
                      )),
                    ),
                  ),
                ],
              )),
          AnimatedContainer(
            height: dataAmount != null
                ? ((dataAmount.length / 2).ceil().toDouble() * legendHeight) + 16
                : 0,
            duration: Duration(milliseconds: 250),
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                  childAspectRatio: ((MediaQuery.of(context).size.width - 32) / 2) / legendHeight),
              // padding: EdgeInsets.all(8),
              //shrinkWrap: true,
              itemCount: dataAmount != null ? dataAmount.length : 0,
              itemBuilder: (context, index) {
                //widget.settings.updateBasePair(data[index].pair);
                return GestureDetector(
                  onTap: () {
                    //widget.settings.updateBasePair(data[index].pair);
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
                            color: colors[index],
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
                                  dataPair[index],
                                  style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 24,
                                      //fontWeight: FontWeight.w400,
                                      color: Colors.black.withOpacity(0.34)),
                                ),
                                RichText(
                                  textAlign: TextAlign.left,
                                  softWrap: true,
                                  text: TextSpan(
                                    text: '',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.3), fontSize: 11),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            '${returnCurrencyCorrectedNumber(dataPair[index].split("/")[1], dataAmount[index] * _multiplier)}',
                                        style: TextStyle(
                                            color: Colors.black.withOpacity(0.4), fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(text: ' for '),
                                      TextSpan(
                                        text: '${dataPair[index].toString().split("/")[0]}',
                                        style: TextStyle(
                                            color: Colors.black.withOpacity(0.4), fontWeight: FontWeight.bold),
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
          )
        ]),
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
                  itemCount: 1,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    List coins = dataPair;
                    return GestureDetector(
                      onTap: () {},
                      child: AnimatedContainer(
                        width: 150,
                        //padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                            //color: Color(0xffF7F8F9),
                            color: Colors.grey.withOpacity(0.1),
                            border: Border(
                                top: BorderSide(color: Colors.grey.withOpacity(0.4), width: 4),
                                right: BorderSide(color:Colors.grey.withOpacity(0.3), width: 0.5),
                                left:
                                    BorderSide(color: Colors.grey.withOpacity(0.3), width: 0.5))),
                        duration: Duration(milliseconds: 250),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text(
                                "USD",
                                style: TextStyle(
                                    fontFamily: 'Arial', fontSize: 24, color: Colors.black.withOpacity(0.4)),
                              ),
                            ),
                            Container(
                              height: 0,
                            ),
                            Text(
                              "${returnCurrencyCorrectedNumber("USD", 12453)}",
                              style: TextStyle(color: Colors.black.withOpacity(0.4), fontWeight: FontWeight.w400),
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
    );
  }
}
