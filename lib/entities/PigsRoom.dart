class Pigsroom {
  int? roomNo;
  String? createdate;
  int? preyystock;
  int? premmstock;
  int? preddstock;
  int? into01;
  int? into02;
  int? into03;
  int? into04;
  int? into05;
  int? into06;
  int? into07;
  int? into08;
  int? into09;
  int? into10;
  int? into11;
  int? into12;
  int? out01;
  int? out02;
  int? out03;
  int? out04;
  int? out05;
  int? out06;
  int? out07;
  int? out08;
  int? out09;
  int? out10;
  int? out11;
  int? out12;
  int? accident01;
  int? accident02;
  int? accident03;
  int? accident04;
  int? accident05;
  int? accident06;
  int? accident07;
  int? accident08;
  int? accident09;
  int? accident10;
  int? accident11;
  int? accident12;
  int? stock01;
  int? stock02;
  int? stock03;
  int? stock04;
  int? stock05;
  int? stock06;
  int? stock07;
  int? stock08;
  int? stock09;
  int? stock10;
  int? stock11;
  int? stock12;
  int? stock;
  String? explanation;

  Pigsroom({
    this.roomNo,
    this.createdate,
    this.preyystock,
    this.premmstock,
    this.preddstock,
    this.into01,
    this.into02,
    this.into03,
    this.into04,
    this.into05,
    this.into06,
    this.into07,
    this.into08,
    this.into09,
    this.into10,
    this.into11,
    this.into12,
    this.out01,
    this.out02,
    this.out03,
    this.out04,
    this.out05,
    this.out06,
    this.out07,
    this.out08,
    this.out09,
    this.out10,
    this.out11,
    this.out12,
    this.accident01,
    this.accident02,
    this.accident03,
    this.accident04,
    this.accident05,
    this.accident06,
    this.accident07,
    this.accident08,
    this.accident09,
    this.accident10,
    this.accident11,
    this.accident12,
    this.stock01,
    this.stock02,
    this.stock03,
    this.stock04,
    this.stock05,
    this.stock06,
    this.stock07,
    this.stock08,
    this.stock09,
    this.stock10,
    this.stock11,
    this.stock12,
    this.stock,
    this.explanation,
  });

  factory Pigsroom.fromJson(Map<String, dynamic> json) => Pigsroom(
    roomNo: json["roomNo"],
    createdate: json["createdate"],
    preyystock: json["preyystock"],
    premmstock: json["premmstock"],
    preddstock: json["preddstock"],
    into01: json["into01"],
    into02: json["into02"],
    into03: json["into03"],
    into04: json["into04"],
    into05: json["into05"],
    into06: json["into06"],
    into07: json["into07"],
    into08: json["into08"],
    into09: json["into09"],
    into10: json["into10"],
    into11: json["into11"],
    into12: json["into12"],
    out01: json["out01"],
    out02: json["out02"],
    out03: json["out03"],
    out04: json["out04"],
    out05: json["out05"],
    out06: json["out06"],
    out07: json["out07"],
    out08: json["out08"],
    out09: json["out09"],
    out10: json["out10"],
    out11: json["out11"],
    out12: json["out12"],
    accident01: json["accident01"],
    accident02: json["accident02"],
    accident03: json["accident03"],
    accident04: json["accident04"],
    accident05: json["accident05"],
    accident06: json["accident06"],
    accident07: json["accident07"],
    accident08: json["accident08"],
    accident09: json["accident09"],
    accident10: json["accident10"],
    accident11: json["accident11"],
    accident12: json["accident12"],
    stock01: json["stock01"],
    stock02: json["stock02"],
    stock03: json["stock03"],
    stock04: json["stock04"],
    stock05: json["stock05"],
    stock06: json["stock06"],
    stock07: json["stock07"],
    stock08: json["stock08"],
    stock09: json["stock09"],
    stock10: json["stock10"],
    stock11: json["stock11"],
    stock12: json["stock12"],
    stock: json["stock"],
    explanation: json["explanation"],
  );

  Map<String, dynamic> toJson() => {
    "roomNo": roomNo,
    "createdate": createdate,
    "preyystock": preyystock,
    "premmstock": premmstock,
    "premmstock": premmstock,
    "preddstock": preddstock,
    "into01": into01,
    "into02": into02,
    "into03": into03,
    "into04": into04,
    "into05": into05,
    "into06": into06,
    "into07": into07,
    "into08": into08,
    "into09": into09,
    "into10": into10,
    "into11": into11,
    "into12": into12,
    "out01": out01,
    "out02": out02,
    "out03": out03,
    "out04": out04,
    "out05": out05,
    "out06": out06,
    "out07": out07,
    "out08": out08,
    "out09": out09,
    "out10": out10,
    "out11": out11,
    "out12": out12,
    "accident01": accident01,
    "accident02": accident02,
    "accident03": accident03,
    "accident04": accident04,
    "accident05": accident05,
    "accident06": accident06,
    "accident07": accident07,
    "accident08": accident08,
    "accident09": accident09,
    "accident10": accident10,
    "accident11": accident11,
    "accident12": accident12,
    "stock01": stock01,
    "stock02": stock02,
    "stock03": stock03,
    "stock04": stock04,
    "stock05": stock05,
    "stock06": stock06,
    "stock07": stock07,
    "stock08": stock08,
    "stock09": stock09,
    "stock10": stock10,
    "stock11": stock11,
    "stock12": stock12,
    "stock": stock,
    "explanation": explanation,
  };

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["roomNo"] = roomNo;
    map["createdate"] = createdate;
    map["preyystock"] = preyystock;
    map["premmstock"] = premmstock;
    map["preddstock"] = preddstock;
    map["into01"] = into01;
    map["into02"] = into02;
    map["into03"] = into03;
    map["into04"] = into04;
    map["into05"] = into05;
    map["into06"] = into06;
    map["into07"] = into07;
    map["into08"] = into08;
    map["into09"] = into09;
    map["into10"] = into10;
    map["into11"] = into11;
    map["into12"] = into12;
    map["out01"] = out01;
    map["out02"] = out02;
    map["out03"] = out03;
    map["out04"] = out04;
    map["out05"] = out05;
    map["out06"] = out06;
    map["out07"] = out07;
    map["out08"] = out08;
    map["out09"] = out09;
    map["out10"] = out10;
    map["out11"] = out11;
    map["out12"] = out12;
    map["accident01"] = accident01;
    map["accident02"] = accident02;
    map["accident03"] = accident03;
    map["accident04"] = accident04;
    map["accident05"] = accident05;
    map["accident06"] = accident06;
    map["accident07"] = accident07;
    map["accident08"] = accident08;
    map["accident09"] = accident09;
    map["accident10"] = accident10;
    map["accident11"] = accident11;
    map["accident12"] = accident12;
    map["stock01"] = stock01;
    map["stock02"] = stock02;
    map["stock03"] = stock03;
    map["stock04"] = stock04;
    map["stock05"] = stock05;
    map["stock06"] = stock06;
    map["stock07"] = stock07;
    map["stock08"] = stock08;
    map["stock09"] = stock09;
    map["stock10"] = stock10;
    map["stock11"] = stock11;
    map["stock12"] = stock12;
    map["stock"] = stock;
    map["explanation"] = explanation;
    return map;
  }
}