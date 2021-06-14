import 'package:flutter/material.dart';

import '../external/binance_api.dart';

class Settings {
  Map<String, double> binanceTicker;
  String base_coin;
  String base_pair;
  Color base_pair_color;
  final Function(Settings newSettings) updateWidgets;

  Settings(this.updateWidgets);

  void updateBinancePrice() async {
    this.binanceTicker = await fetchBinancePairData();
    this.updateWidgets(this);
  }

  void updateBaseCoin(String coin) {
    this.base_coin = coin;
    this.updateWidgets(this);
  }

  void updateBasePair(String pair) {
    this.base_pair = pair;
    this.base_coin = pair.split("/")[1];
    this.updateWidgets(this);
  }
}
