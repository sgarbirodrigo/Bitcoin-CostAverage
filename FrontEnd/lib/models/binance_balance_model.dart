class Balance {
  int makerCommission;
  int takerCommission;
  int buyerCommission;
  int sellerCommission;
  bool canTrade;
  bool canWithdraw;
  bool canDeposit;
  int updateTime;
  String accountType;
  List<_Balances> balances;
  Map<String,double> balancesMapped;
  List<String> permissions;

  Balance(
      {this.makerCommission,
        this.takerCommission,
        this.buyerCommission,
        this.sellerCommission,
        this.canTrade,
        this.canWithdraw,
        this.canDeposit,
        this.updateTime,
        this.accountType,
        this.balances,
        this.permissions});

  Balance.fromJson(Map<String, dynamic> json) {
    makerCommission = json['makerCommission'];
    takerCommission = json['takerCommission'];
    buyerCommission = json['buyerCommission'];
    sellerCommission = json['sellerCommission'];
    canTrade = json['canTrade'];
    canWithdraw = json['canWithdraw'];
    canDeposit = json['canDeposit'];
    updateTime = json['updateTime'];
    accountType = json['accountType'];
    if (json['balances'] != null) {
      balances = new List<_Balances>();
      balancesMapped = new Map();
      json['balances'].forEach((v) {
        _Balances _balances= new _Balances.fromJson(v);
        if(_balances.free>0) {
          balances.add(_balances);
          balancesMapped[_balances.asset] = _balances.free;
        }
      });
    }
    permissions = json['permissions'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['makerCommission'] = this.makerCommission;
    data['takerCommission'] = this.takerCommission;
    data['buyerCommission'] = this.buyerCommission;
    data['sellerCommission'] = this.sellerCommission;
    data['canTrade'] = this.canTrade;
    data['canWithdraw'] = this.canWithdraw;
    data['canDeposit'] = this.canDeposit;
    data['updateTime'] = this.updateTime;
    data['accountType'] = this.accountType;
    if (this.balances != null) {
      data['balances'] = this.balances.map((v) => v.toJson()).toList();
    }
    data['permissions'] = this.permissions;
    return data;
  }
}

class _Balances {
  String asset;
  double free;
  double locked;

  _Balances({this.asset, this.free, this.locked});

  _Balances.fromJson(Map<String, dynamic> json) {
    asset = json['asset'];
    free = double.parse(double.parse(json['free']).toStringAsFixed(6));
    locked = double.parse(double.parse(json['locked']).toStringAsFixed(6));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['asset'] = this.asset;
    data['free'] = this.free;
    data['locked'] = this.locked;
    return data;
  }
}