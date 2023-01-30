class Estrus {
  int? id;
  String? result;
  String? lastdate;

  Estrus({
    this.id,
    this.result,
    this.lastdate,
  });

  factory Estrus.fromJson(Map<String, dynamic> json) => Estrus(
    id: json["id"],
    result: json["result"],
    lastdate: json["lastdate"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "result": result,
    "lastdate": lastdate,
  };

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["result"] = result;
    map["lastdate"] = lastdate;

    return map;
  }

}