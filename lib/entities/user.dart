class User {
  int? id;
  String? email;
  String? password;
  String? name;
  int? memlevel;
  String? avatar;
  String? phone;

  User({
    this.id,
    this.email,
    this.password,
    this.name,
    this.memlevel,
    this.avatar,
    this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["id"],
      email: json["email"],
      password: json["password"],
      name: json["name"],
      phone: json["phone"],
      memlevel: json["memlevel"],
      avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "password": password,
    "name": name,
    "phone": phone,
    "memlevel": memlevel,
    "avatar": avatar,
  };

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["email"] = email;
    map["name"] = name;
    map["avatar"] = avatar;

    return map;
  }

}