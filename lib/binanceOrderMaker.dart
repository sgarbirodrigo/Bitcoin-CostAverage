class BinanceResponseMakeOrder {
  Fills info;
  String id;
  String clientOrderId;
  int timestamp;
  String datetime;
  String symbol;
  String type;
  String timeInForce;
  bool postOnly;
  String side;
  double price;
  double amount;
  double cost;
  double average;
  double filled;
  double remaining;
  String status;
  Fee fee;
  List<Trades> trades;

  BinanceResponseMakeOrder(
      {this.info,
        this.id,
        this.clientOrderId,
        this.timestamp,
        this.datetime,
        this.symbol,
        this.type,
        this.timeInForce,
        this.postOnly,
        this.side,
        this.price,
        this.amount,
        this.cost,
        this.average,
        this.filled,
        this.remaining,
        this.status,
        this.fee,
        this.trades});

  BinanceResponseMakeOrder.fromJson(Map<String, dynamic> json) {
    info = json['info'] != null ? new Fills.fromJson(json['info']) : null;
    id = json['id'];
    clientOrderId = json['clientOrderId'];
    timestamp = json['timestamp'];
    datetime = json['datetime'];
    symbol = json['symbol'];
    type = json['type'];
    timeInForce = json['timeInForce'];
    postOnly = json['postOnly'];
    side = json['side'];
    price = double.parse(json['price'].toString());
    amount = double.parse(json['amount'].toString());
    cost = double.parse(json['cost'].toString());
    average = double.parse(json['average'].toString());
    filled = double.parse(json['filled'].toString());
    remaining = double.parse(json['remaining'].toString());
    status = json['status'];
    fee = json['fee'] != null ? new Fee.fromJson(json['fee']) : null;
    if (json['trades'] != null) {
      trades = new List<Trades>();
      json['trades'].forEach((v) {
        trades.add(new Trades.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.info != null) {
      data['info'] = this.info.toJson();
    }
    data['id'] = this.id;
    data['clientOrderId'] = this.clientOrderId;
    data['timestamp'] = this.timestamp;
    data['datetime'] = this.datetime;
    data['symbol'] = this.symbol;
    data['type'] = this.type;
    data['timeInForce'] = this.timeInForce;
    data['postOnly'] = this.postOnly;
    data['side'] = this.side;
    data['price'] = this.price;
    data['amount'] = this.amount;
    data['cost'] = this.cost;
    data['average'] = this.average;
    data['filled'] = this.filled;
    data['remaining'] = this.remaining;
    data['status'] = this.status;
    if (this.fee != null) {
      data['fee'] = this.fee.toJson();
    }
    if (this.trades != null) {
      data['trades'] = this.trades.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Info {
  String symbol;
  int orderId;
  int orderListId;
  String clientOrderId;
  int transactTime;
  String price;
  String origQty;
  String executedQty;
  String cummulativeQuoteQty;
  String status;
  String timeInForce;
  String type;
  String side;
  List<Fills> fills;

  Info(
      {this.symbol,
        this.orderId,
        this.orderListId,
        this.clientOrderId,
        this.transactTime,
        this.price,
        this.origQty,
        this.executedQty,
        this.cummulativeQuoteQty,
        this.status,
        this.timeInForce,
        this.type,
        this.side,
        this.fills});

  Info.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    orderId = json['orderId'];
    orderListId = json['orderListId'];
    clientOrderId = json['clientOrderId'];
    transactTime = json['transactTime'];
    price = json['price'];
    origQty = json['origQty'];
    executedQty = json['executedQty'];
    cummulativeQuoteQty = json['cummulativeQuoteQty'];
    status = json['status'];
    timeInForce = json['timeInForce'];
    type = json['type'];
    side = json['side'];
    if (json['fills'] != null) {
      fills = new List<Fills>();
      json['fills'].forEach((v) {
        fills.add(new Fills.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['symbol'] = this.symbol;
    data['orderId'] = this.orderId;
    data['orderListId'] = this.orderListId;
    data['clientOrderId'] = this.clientOrderId;
    data['transactTime'] = this.transactTime;
    data['price'] = this.price;
    data['origQty'] = this.origQty;
    data['executedQty'] = this.executedQty;
    data['cummulativeQuoteQty'] = this.cummulativeQuoteQty;
    data['status'] = this.status;
    data['timeInForce'] = this.timeInForce;
    data['type'] = this.type;
    data['side'] = this.side;
    if (this.fills != null) {
      data['fills'] = this.fills.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Fills {
  String price;
  String qty;
  String commission;
  String commissionAsset;
  int tradeId;

  Fills(
      {this.price,
        this.qty,
        this.commission,
        this.commissionAsset,
        this.tradeId});

  Fills.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    qty = json['qty'];
    commission = json['commission'];
    commissionAsset = json['commissionAsset'];
   // print("price: ${price}*${qty} /tradeId ${json['tradeId']}");
    //tradeId = json['tradeId']??0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['qty'] = this.qty;
    data['commission'] = this.commission;
    data['commissionAsset'] = this.commissionAsset;
    data['tradeId'] = this.tradeId;
    return data;
  }
}

class Fee {
  double cost;
  String currency;

  Fee({this.cost, this.currency});

  Fee.fromJson(Map<String, dynamic> json) {
    cost = json['cost'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cost'] = this.cost;
    data['currency'] = this.currency;
    return data;
  }
}

class Trades {
  Fills info;
  String symbol;
  double price;
  double amount;
  double cost;
  Fee fee;

  Trades(
      {this.info, this.symbol, this.price, this.amount, this.cost, this.fee});

  Trades.fromJson(Map<String, dynamic> json) {
    info = json['info'] != null ? new Fills.fromJson(json['info']) : null;
    symbol = json['symbol'];
    price = double.parse(json['price'].toString());
    amount = double.parse(json['amount'].toString());
    cost = double.parse(json['cost'].toString());
    fee = json['fee'] != null ? new Fee.fromJson(json['fee']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.info != null) {
      data['info'] = this.info.toJson();
    }
    data['symbol'] = this.symbol;
    data['price'] = this.price;
    data['amount'] = this.amount;
    data['cost'] = this.cost;
    if (this.fee != null) {
      data['fee'] = this.fee.toJson();
    }
    return data;
  }
}

