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
}

// 사용자 더미 데이터
// List<User> userModels = [
  // User(id: 101, email: 'test101@test.com', name: '홍길동', phone: '010-000-0000', memlevel: 5, avatar: 'https://loremflickr.com/150/150/animals'),
  // User(id: 102, email: 'test102@test.com', name: '강호동', phone: '010-000-0000', memlevel: 5, avatar: 'https://loremflickr.com/150/150/arch'),
  // User(id: 103, email: 'test103@test.com', name: '유재석', phone: '010-000-0000', memlevel: 5, avatar: 'https://loremflickr.com/150/150/nature'),
  // User(id: 104, email: 'test104@test.com', name: '하하', phone: '010-000-0000', memlevel: 5, avatar: 'https://loremflickr.com/150/150/people'),
  // User(id: 105, email: 'test105@test.com', name: '테스트', phone: '010-000-0000', memlevel: 5, avatar: 'https://loremflickr.com/150/150/tech'),
// ];
