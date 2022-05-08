
class Schedule {
  //bool monday=false;
  bool monday = false,
      tuesday = true,
      wednesday = true,
      thursday = false,
      friday = true,
      saturday = false,
      sunday = true;


  Schedule(
      {this.monday = false,
        this.tuesday = false,
        this.wednesday = false,
        this.thursday = false,
        this.friday = false,
        this.saturday = false,
        this.sunday = false});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['monday'] = this.monday;
    data['tuesday'] = this.tuesday;
    data['thursday'] = this.thursday;
    data['wednesday'] = this.wednesday;
    data['friday'] = this.friday;
    data['saturday'] = this.saturday;
    data['sunday'] = this.sunday;
    return data;
  }

  int getMultiplier() {
    int _multiplier = 0;
    _multiplier = 0;
    if (this.monday) {
      _multiplier += 1;
    }
    if (this.tuesday) {
      _multiplier += 1;
    }
    if (this.wednesday) {
      _multiplier += 1;
    }
    if (this.thursday) {
      _multiplier += 1;
    }
    if (this.friday) {
      _multiplier += 1;
    }
    if (this.saturday) {
      _multiplier += 1;
    }
    if (this.sunday) {
      _multiplier += 1;
    }
    return _multiplier;
  }
}