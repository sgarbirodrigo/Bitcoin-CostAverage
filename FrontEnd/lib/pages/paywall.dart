import 'package:bitcoin_cost_average/purchase/paywall_bcav2.dart';
import 'package:bitcoin_cost_average/widgets/circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PaywallPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PaywallPageState();
  }

}
class _PaywallPageState extends State<PaywallPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Purchases.getOfferings(),
      builder: (context, AsyncSnapshot<Offerings> offerings) {
        if (offerings.hasData) {
          print("offer: ${offerings.data}");
          if ((offerings.data.current != null &&
              offerings.data.current.availablePackages.isNotEmpty)) {
            return PaywallMy_v2(
              offering: offerings.data.current,
            );
          } else {
            return Scaffold(
              body: SafeArea(
                child: Center(
                  child: CircularProgressIndicatorMy(
                    info: "null data.current or packages empty",
                  ),
                ),
              ),
            );
          }
        } else {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: CircularProgressIndicatorMy(
                  info: "no offerings available",
                ),
              ),
            ),
          );
        }
      },
    );
  }

}