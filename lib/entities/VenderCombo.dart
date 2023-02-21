class VenderCombo {
  int? code;
  String? name;

  VenderCombo(
      this.code,
      this.name,
      );

  Map<String, dynamic> toJson() => {
    "code": code,
    "name": name,
  };

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["code"] = code;
    map["name"] = name;
    return map;
  }

}