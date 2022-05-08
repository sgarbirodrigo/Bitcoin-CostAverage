class BinanceSymbol {
  String _symbol;
  String _status;
  String _baseAsset;
  int _baseAssetPrecision;
  String _quoteAsset;
  int _quotePrecision;
  int _quoteAssetPrecision;
  int _baseCommissionPrecision;
  int _quoteCommissionPrecision;
  List<String> _orderTypes;
  bool _icebergAllowed;
  bool _ocoAllowed;
  bool _quoteOrderQtyMarketAllowed;
  bool _isSpotTradingAllowed;
  bool _isMarginTradingAllowed;
  List<Filters> _filters;
  List<String> _permissions;

  BinanceSymbol(
      {String symbol,
      String status,
      String baseAsset,
      int baseAssetPrecision,
      String quoteAsset,
      int quotePrecision,
      int quoteAssetPrecision,
      int baseCommissionPrecision,
      int quoteCommissionPrecision,
      List<String> orderTypes,
      bool icebergAllowed,
      bool ocoAllowed,
      bool quoteOrderQtyMarketAllowed,
      bool isSpotTradingAllowed,
      bool isMarginTradingAllowed,
      List<Filters> filters,
      List<String> permissions}) {
    this._symbol = symbol;
    this._status = status;
    this._baseAsset = baseAsset;
    this._baseAssetPrecision = baseAssetPrecision;
    this._quoteAsset = quoteAsset;
    this._quotePrecision = quotePrecision;
    this._quoteAssetPrecision = quoteAssetPrecision;
    this._baseCommissionPrecision = baseCommissionPrecision;
    this._quoteCommissionPrecision = quoteCommissionPrecision;
    this._orderTypes = orderTypes;
    this._icebergAllowed = icebergAllowed;
    this._ocoAllowed = ocoAllowed;
    this._quoteOrderQtyMarketAllowed = quoteOrderQtyMarketAllowed;
    this._isSpotTradingAllowed = isSpotTradingAllowed;
    this._isMarginTradingAllowed = isMarginTradingAllowed;
    this._filters = filters;
    this._permissions = permissions;
  }

  String get mySymbol => "${baseAsset}/${quoteAsset}";

  String get symbol => _symbol;

  set symbol(String symbol) => _symbol = symbol;

  String get status => _status;

  set status(String status) => _status = status;

  String get baseAsset => _baseAsset;

  set baseAsset(String baseAsset) => _baseAsset = baseAsset;

  int get baseAssetPrecision => _baseAssetPrecision;

  set baseAssetPrecision(int baseAssetPrecision) =>
      _baseAssetPrecision = baseAssetPrecision;

  String get quoteAsset => _quoteAsset;

  set quoteAsset(String quoteAsset) => _quoteAsset = quoteAsset;

  int get quotePrecision => _quotePrecision;

  set quotePrecision(int quotePrecision) => _quotePrecision = quotePrecision;

  int get quoteAssetPrecision => _quoteAssetPrecision;

  set quoteAssetPrecision(int quoteAssetPrecision) =>
      _quoteAssetPrecision = quoteAssetPrecision;

  int get baseCommissionPrecision => _baseCommissionPrecision;

  set baseCommissionPrecision(int baseCommissionPrecision) =>
      _baseCommissionPrecision = baseCommissionPrecision;

  int get quoteCommissionPrecision => _quoteCommissionPrecision;

  set quoteCommissionPrecision(int quoteCommissionPrecision) =>
      _quoteCommissionPrecision = quoteCommissionPrecision;

  List<String> get orderTypes => _orderTypes;

  set orderTypes(List<String> orderTypes) => _orderTypes = orderTypes;

  bool get icebergAllowed => _icebergAllowed;

  set icebergAllowed(bool icebergAllowed) => _icebergAllowed = icebergAllowed;

  bool get ocoAllowed => _ocoAllowed;

  set ocoAllowed(bool ocoAllowed) => _ocoAllowed = ocoAllowed;

  bool get quoteOrderQtyMarketAllowed => _quoteOrderQtyMarketAllowed;

  set quoteOrderQtyMarketAllowed(bool quoteOrderQtyMarketAllowed) =>
      _quoteOrderQtyMarketAllowed = quoteOrderQtyMarketAllowed;

  bool get isSpotTradingAllowed => _isSpotTradingAllowed;

  set isSpotTradingAllowed(bool isSpotTradingAllowed) =>
      _isSpotTradingAllowed = isSpotTradingAllowed;

  bool get isMarginTradingAllowed => _isMarginTradingAllowed;

  set isMarginTradingAllowed(bool isMarginTradingAllowed) =>
      _isMarginTradingAllowed = isMarginTradingAllowed;

  List<Filters> get filters => _filters;

  set filters(List<Filters> filters) => _filters = filters;

  List<String> get permissions => _permissions;

  set permissions(List<String> permissions) => _permissions = permissions;

  BinanceSymbol.fromJson(Map<String, dynamic> json) {
    _symbol = json['symbol'];
    _status = json['status'];
    _baseAsset = json['baseAsset'];
    _baseAssetPrecision = json['baseAssetPrecision'];
    _quoteAsset = json['quoteAsset'];
    _quotePrecision = json['quotePrecision'];
    _quoteAssetPrecision = json['quoteAssetPrecision'];
    _baseCommissionPrecision = json['baseCommissionPrecision'];
    _quoteCommissionPrecision = json['quoteCommissionPrecision'];
    _orderTypes = json['orderTypes'].cast<String>();
    _icebergAllowed = json['icebergAllowed'];
    _ocoAllowed = json['ocoAllowed'];
    _quoteOrderQtyMarketAllowed = json['quoteOrderQtyMarketAllowed'];
    _isSpotTradingAllowed = json['isSpotTradingAllowed'];
    _isMarginTradingAllowed = json['isMarginTradingAllowed'];
    if (json['filters'] != null) {
      _filters = new List<Filters>();
      json['filters'].forEach((v) {
        _filters.add(new Filters.fromJson(v));
      });
    }
    _permissions = json['permissions'].cast<String>();
  }
}

class Filters {
  String _filterType;
  double _minPrice;
  int _maxPrice;
  double _tickSize;
  int _multiplierUp;
  double _multiplierDown;
  int _avgPriceMins;
  double _minQty;
  double _maxQty;
  double _stepSize;
  double _minNotional;
  bool _applyToMarket;
  int _limit;
  int _maxNumOrders;
  int _maxNumAlgoOrders;

  Filters(
      {String filterType,
      double minPrice,
      int maxPrice,
      double tickSize,
      int multiplierUp,
      double multiplierDown,
      int avgPriceMins,
      double minQty,
      double maxQty,
      double stepSize,
      double minNotional,
      bool applyToMarket,
      int limit,
      int maxNumOrders,
      int maxNumAlgoOrders}) {
    this._filterType = filterType;
    this._minPrice = minPrice;
    this._maxPrice = maxPrice;
    this._tickSize = tickSize;
    this._multiplierUp = multiplierUp;
    this._multiplierDown = multiplierDown;
    this._avgPriceMins = avgPriceMins;
    this._minQty = minQty;
    this._maxQty = maxQty;
    this._stepSize = stepSize;
    this._minNotional = minNotional;
    this._applyToMarket = applyToMarket;
    this._limit = limit;
    this._maxNumOrders = maxNumOrders;
    this._maxNumAlgoOrders = maxNumAlgoOrders;
  }

  String get filterType => _filterType;

  set filterType(String filterType) => _filterType = filterType;

  double get minPrice => _minPrice;

  set minPrice(double minPrice) => _minPrice = minPrice;

  int get maxPrice => _maxPrice;

  set maxPrice(int maxPrice) => _maxPrice = maxPrice;

  double get tickSize => _tickSize;

  set tickSize(double tickSize) => _tickSize = tickSize;

  int get multiplierUp => _multiplierUp;

  set multiplierUp(int multiplierUp) => _multiplierUp = multiplierUp;

  double get multiplierDown => _multiplierDown;

  set multiplierDown(double multiplierDown) => _multiplierDown = multiplierDown;

  int get avgPriceMins => _avgPriceMins;

  set avgPriceMins(int avgPriceMins) => _avgPriceMins = avgPriceMins;

  double get minQty => _minQty;

  set minQty(double minQty) => _minQty = minQty;

  double get maxQty => _maxQty;

  set maxQty(double maxQty) => _maxQty = maxQty;

  double get stepSize => _stepSize;

  set stepSize(double stepSize) => _stepSize = stepSize;

  double get minNotional => _minNotional;

  set minNotional(double minNotional) => _minNotional = minNotional;

  bool get applyToMarket => _applyToMarket;

  set applyToMarket(bool applyToMarket) => _applyToMarket = applyToMarket;

  int get limit => _limit;

  set limit(int limit) => _limit = limit;

  int get maxNumOrders => _maxNumOrders;

  set maxNumOrders(int maxNumOrders) => _maxNumOrders = maxNumOrders;

  int get maxNumAlgoOrders => _maxNumAlgoOrders;

  set maxNumAlgoOrders(int maxNumAlgoOrders) =>
      _maxNumAlgoOrders = maxNumAlgoOrders;

  Filters.fromJson(Map<String, dynamic> json) {
    _filterType = json['filterType'];
    _minPrice = double.tryParse(json['minPrice'].toString() ?? "0");
    _maxPrice = int.tryParse(json['maxPrice'].toString() ?? "0");
    _tickSize = double.tryParse(json['tickSize'].toString() ?? "0");
    _multiplierUp = int.tryParse(json['multiplierUp'].toString() ?? "0");
    _multiplierDown = double.tryParse(json['multiplierDown'].toString() ?? "0");
    _avgPriceMins = int.tryParse(json['avgPriceMins'].toString() ?? "0");
    _minQty = double.tryParse(json['minQty'].toString() ?? "0");
    _maxQty = double.tryParse(json['maxQty'].toString() ?? "0");
    _stepSize = double.tryParse(json['stepSize'].toString() ?? "0");
    _minNotional = double.tryParse(json['minNotional'].toString() ?? "0");
    _applyToMarket = json['applyToMarket'];
    _limit = int.tryParse(json['limit'].toString() ?? "0");
    _maxNumOrders = int.tryParse(json['maxNumOrders'].toString() ?? "0");
    _maxNumAlgoOrders =
        int.tryParse(json['maxNumAlgoOrders'].toString() ?? "0");
  }
}
