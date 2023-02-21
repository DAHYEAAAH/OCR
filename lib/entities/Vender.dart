class Vender {
  int? code;
  String? name;
  String? businessno;
  String? ceoname;
  String? tel;

  Vender({
    this.code,
    this.name,
    this.businessno,
    this.ceoname,
    this.tel,
  });

  factory Vender.fromJson(Map<String, dynamic> json) => Vender(
    code: json["code"],
    name: json["name"],
    businessno: json["businessno"],
    ceoname: json["ceoname"],
    tel: json["tel"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "name": name,
    "businessno": businessno,
    "ceoname": ceoname,
    "tel": tel,
  };

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["code"] = code;
    map["name"] = name;
    map["businessno"] = businessno;
    map["ceoname"] = ceoname;
    map["tel"] = tel;
    return map;
  }

}