class Company {
  int? id;
  String? name;
  String? employees;
  String? animals;
  String? addr;
  int? tabindex;

  Company({
    this.id,
    this.name,
    this.employees,
    this.animals,
    this.addr,
    this.tabindex,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    id: json["id"],
    name: json["name"],
    employees: json["employees"],
    animals: json["animals"],
    addr: json["addr"],
    tabindex: json["tabindex"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "employees": employees,
    "animals": animals,
    "addr": addr,
    "tabindex": tabindex,
  };

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["employees"] = employees;
    map["animals"] = animals;
    map["addr"] = addr;
    map["tabindex"] = tabindex;
    return map;
  }

}