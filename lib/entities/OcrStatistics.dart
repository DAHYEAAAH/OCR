class OcrStatistics {
  String? begindate;
  String? enddate;
  String? cross;
  String? sevrer;
  String? totalbaby;
  String? feedbaby;

  OcrStatistics({
    this.begindate,
    this.enddate,
    this.cross,
    this.sevrer,
    this.totalbaby,
    this.feedbaby,

  });

  factory OcrStatistics.fromJson(Map<String, dynamic> json) => OcrStatistics(
    begindate: json["begindate"],
    enddate: json["enddate"],
    cross: json["cross"],
    sevrer: json["sevrer"],
    totalbaby: json["totalbaby"],
    feedbaby: json["feedbaby"],
  );

  Map<String, dynamic> toJson() => {
    "begindate": begindate,
    "enddate": enddate,
    "cross": cross,
    "sevrer": sevrer,
    "totalbaby": totalbaby,
    "feedbaby": feedbaby,
  };

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["begindate"] = begindate;
    map["enddate"] = enddate;
    map["cross"] = cross;
    map["sevrer"] = sevrer;
    map["totalbaby"] = totalbaby;
    map["feedbaby"] = feedbaby;

    return map;
  }

}