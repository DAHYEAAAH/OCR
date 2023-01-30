class Group {
  String? group_name;

  Group({
    this.group_name,
  });

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    group_name: json["group_name"],
  );

  Map<String, dynamic> toJson() => {
    "group_name": group_name,
  };
}