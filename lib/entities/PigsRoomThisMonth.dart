class PigsroomThisMonth {
  int? roomNo;
  String? createdate;
  int? preyystock;
  int? premmstock;
  int? preddstock;
  int? intoThis;
  int? outThis;
  int? accidentThis;
  int? stock;

  PigsroomThisMonth({
    this.roomNo,
    this.createdate,
    this.preyystock,
    this.premmstock,
    this.preddstock,
    this.intoThis,
    this.outThis,
    this.accidentThis,
    this.stock,
  });

  factory PigsroomThisMonth.fromJson(Map<String, dynamic> json) => PigsroomThisMonth(
    roomNo: json["roomNo"],
    createdate: json["createdate"],
    preyystock: json["preyystock"],
    premmstock: json["premmstock"],
    preddstock: json["preddstock"],
    intoThis: json["intoThis"],
    outThis: json["outThis"],
    accidentThis: json["accidentThis"],
    stock: json["stock"],
  );

  Map<String, dynamic> toJson() => {
    "roomNo": roomNo,
    "createdate": createdate,
    "preyystock": preyystock,
    "premmstock": premmstock,
    "premmstock": premmstock,
    "preddstock": preddstock,
    "intoThis": intoThis,
    "outThis": outThis,
    "accidentThis": accidentThis,
    "stock": stock,
  };

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["roomNo"] = roomNo;
    map["createdate"] = createdate;
    map["preyystock"] = preyystock;
    map["premmstock"] = premmstock;
    map["preddstock"] = preddstock;
    map["intoThis"] = intoThis;
    map["outThis"] = outThis;
    map["accidentThis"] = accidentThis;
    map["stock"] = stock;
    return map;
  }
}