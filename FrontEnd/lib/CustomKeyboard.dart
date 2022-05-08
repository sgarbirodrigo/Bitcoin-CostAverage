import 'package:bitcoin_cost_average/tools.dart';
import 'package:cool_ui/cool_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomNumberKeyboard extends StatelessWidget {
  static const CKTextInputType inputType = const CKTextInputType(name: 'CKNumberKeyboard');

  static double minimumAmount = 0.0;

  static double getHeight(BuildContext ctx) {
    return 2 * (MediaQuery.of(ctx).size.width / 3) + 2;
  }

  final KeyboardController controller;

  const CustomNumberKeyboard({this.controller});

  static setMinimumAmount(double min) {
    minimumAmount = min;
  }

  static register() {
    CoolKeyboard.addKeyboard(
        CustomNumberKeyboard.inputType,
        KeyboardConfig(
            builder: (context, controller, params) {
              return CustomNumberKeyboard(controller: controller);
            },
            getHeight: CustomNumberKeyboard.getHeight));
  }

  /*GestureDetector(
  behavior: HitTestBehavior.translucent,
  child: Center(
  child: Text('1'),
  ),
  onTap: () {
  controller.addText('1');
  },
  )*/
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: getHeight(context),
        color: Color(0xffCACDD2),
        child: GridView.count(
          childAspectRatio: 1.5,
          shrinkWrap: true,
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
          crossAxisCount: 4,
          children: <Widget>[
            number(1),
            number(2),
            number(3),
            min(),
            number(4),
            number(5),
            number(6),
            plus(),
            number(7),
            number(8),
            number(9),
            minus(),
            dot(),
            number(0),
            backspace(),
            clear()
          ],
        ),
      ),
    );
  }

  Widget number(int value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      child: ElevatedButton(
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(1),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              overlayColor: MaterialStateProperty.all<Color>(Colors.black.withOpacity(0.1))),
          onPressed: () {
            controller.addText(value.toString());
          },
          child: Container(
            child: Text(
              value.toString(),
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
            ),
          )),
    );
  }

  Widget btn(String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      child: ElevatedButton(
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(1),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              overlayColor: MaterialStateProperty.all<Color>(Colors.black.withOpacity(0.1))),
          onPressed: () {
            //controller.addText(value.toString());
          },
          child: Container(
            child: Text(
              value.toString(),
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 20),
            ),
          )),
    );
  }

  Widget min() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      child: ElevatedButton(
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(1),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              overlayColor: MaterialStateProperty.all<Color>(Colors.black.withOpacity(0.1))),
          onPressed: () {
            controller.clear();
            controller.addText(minimumAmount.toString());
          },
          child: Container(
            child: Text(
              "Min",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 20),
            ),
          )),
    );
  }

  Widget plus() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      child: ElevatedButton(
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(1),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              overlayColor: MaterialStateProperty.all<Color>(Colors.black.withOpacity(0.1))),
          onPressed: () {
            String value = controller.text.isEmpty ? "0" : controller.text;
            controller.clear();
            double valueFinal =
                double.parse(doubleToValueString((double.tryParse(value) + minimumAmount)));
            controller.addText(valueFinal.toString());
          },
          child: Container(
            child: Text(
              "+",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 20),
            ),
          )),
    );
  }

  Widget minus() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      child: ElevatedButton(
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(1),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              overlayColor: MaterialStateProperty.all<Color>(Colors.black.withOpacity(0.1))),
          onPressed: () {
            double value = double.parse(controller.text);
            controller.clear();

            double newValue = double.parse(doubleToValueString(value - minimumAmount));
            if (newValue < minimumAmount) {
              newValue = minimumAmount;
            }
            controller.addText(newValue.toString());
          },
          child: Container(
            child: Text(
              "-",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 20),
            ),
          )),
    );
  }

  Widget dot() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      child: ElevatedButton(
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(1),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              overlayColor: MaterialStateProperty.all<Color>(Colors.black.withOpacity(0.1))),
          onPressed: () {
            if (!controller.text.contains(".")) {
              controller.addText(".");
            }
          },
          child: Container(
            child: Text(
              ".",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 20),
            ),
          )),
    );
  }

  Widget clear() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      child: ElevatedButton(
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(1),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              overlayColor: MaterialStateProperty.all<Color>(Colors.black.withOpacity(0.1))),
          onPressed: () {
            controller.clear();
            controller.addText("0.0");
          },
          child: Container(
            child: Text(
              "Clear",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 20),
            ),
          )),
    );
  }

  Widget backspace() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      child: ElevatedButton(
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(1),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              overlayColor: MaterialStateProperty.all<Color>(Colors.black.withOpacity(0.1))),
          onPressed: () {
            controller.deleteOne();
          },
          child: Container(
            child: Icon(
              Icons.backspace_outlined,
              color: Colors.black.withOpacity(0.6),
            ),
          )),
    );
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: TextButton(
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              overlayColor: MaterialStateProperty.all<Color>(Colors.black.withOpacity(0.1))),
          onPressed: () {
            //controller.addText(value.toString());
          },
          child: Container(
            child: Icon(
              Icons.backspace_outlined,
              color: Colors.black.withOpacity(0.6),
            ),
          )),
    );
    return Container(
      color: Colors.white,
      child: Center(
        child: IconButton(
          onPressed: () {},
          icon: Icon(Icons.backspace_outlined),
        ),
      ),
    );
  }
}
