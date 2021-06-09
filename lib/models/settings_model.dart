import '../external/binance_api.dart';

class Settings {
  Map<String, double> binanceTicker;
  String base_coin;
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
}
