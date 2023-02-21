class CompanyCombo {
  String? tabindex;
  String? name;

  CompanyCombo(
      this.tabindex,
      this.name,
      );

  Map<String, dynamic> toJson() => {
    "id": tabindex,
    "name": name,
  };

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = tabindex;
    map["name"] = name;
    return map;
  }

}