class Ocr_maternity {
  int? ocr_seq;
  String? sow_no;
  int? sow_hang;
  String? sow_birth;
  String? sow_buy;
  String? sow_expectdate;
  String? sow_givebirth;
  String? sow_totalbaby;
  String? sow_feedbaby;
  String? sow_babyweight;
  String? sow_sevrerdate;
  String? sow_sevrerqty;
  String? sow_sevrerweight;
  String? vaccine1;
  String? vaccine2;
  String? vaccine3;
  String? vaccine4;
  String? input_date;
  String? input_time;
  String? ocr_imgpath;
  String? memo;

  Ocr_maternity({
    this.ocr_seq,
    this.sow_no,
    this.sow_hang,
    this.sow_birth,
    this.sow_buy,
    this.sow_expectdate,
    this.sow_givebirth,
    this.sow_totalbaby,
    this.sow_feedbaby,
    this.sow_babyweight,
    this.sow_sevrerdate,
    this.sow_sevrerqty,
    this.sow_sevrerweight,
    this.vaccine1,
    this.vaccine2,
    this.vaccine3,
    this.vaccine4,
    this.input_date,
    this.input_time,
    this.ocr_imgpath,
    this.memo,
  });

  factory Ocr_maternity.fromJson(Map<String, dynamic> json) => Ocr_maternity(
    ocr_seq: json["ocr_seq"],
    sow_no: json["sow_no"],
    sow_hang: json["sow_hang"],
    sow_birth: json["sow_birth"],
    sow_buy: json["sow_buy"],
    sow_expectdate: json["sow_expectdate"],
    sow_givebirth: json["sow_givebirth"],
    sow_totalbaby: json["sow_totalbaby"],
    sow_feedbaby: json["sow_feedbaby"],
    sow_babyweight: json["sow_babyweight"],
    sow_sevrerdate: json["sow_sevrerdate"],
    sow_sevrerqty: json["sow_sevrerqty"],
    sow_sevrerweight: json["sow_sevrerweight"],
    vaccine1: json["vaccine1"],
    vaccine2: json["vaccine2"],
    vaccine3: json["vaccine3"],
    vaccine4: json["vaccine4"],
    input_date: json["input_date"],
    input_time: json["input_time"],
    ocr_imgpath: json["ocr_imgpath"],
    memo: json["memo"],
  );
  Map<String, dynamic> toJson() => {
    "ocr_seq": ocr_seq,
    "sow_no": sow_no,
    "sow_hang": sow_hang,
    "sow_birth": sow_birth,
    "sow_buy": sow_buy,
    "sow_expectdate": sow_expectdate,
    "sow_givebirth": sow_givebirth,
    "sow_totalbaby": sow_totalbaby,
    "sow_feedbaby": sow_feedbaby,
    "sow_babyweight": sow_babyweight,
    "sow_sevrerdate": sow_sevrerdate,
    "sow_sevrerqty": sow_sevrerqty,
    "sow_sevrerweight": sow_sevrerweight,
    "vaccine1": vaccine1,
    "vaccine2": vaccine2,
    "vaccine3": vaccine3,
    "vaccine4": vaccine4,
    "input_date": input_date,
    "input_time": input_time,
    "ocr_imgpath": ocr_imgpath,
    "memo": memo,
  };
  Map<String, dynamic> toMap() {var map = new Map<String, dynamic>();
  map["ocr_seq"] = ocr_seq;
  map["sow_no"] = sow_no;
  map["sow_hang"] = sow_hang;
  map["sow_birth"] = sow_birth;
  map["sow_buy"] = sow_buy;
  map["sow_expectdate"] = sow_expectdate;
  map["sow_givebirth"] = sow_givebirth;
  map["sow_totalbaby"] = sow_totalbaby;
  map["sow_feedbaby"] = sow_feedbaby;
  map["sow_babyweight"] = sow_babyweight;
  map["sow_sevrerdate"] = sow_sevrerdate;
  map["sow_sevrerqty"] = sow_sevrerqty;
  map["sow_sevrerweight"] = sow_sevrerweight;
  map["vaccine1"] = vaccine1;
  map["vaccine2"] = vaccine2;
  map["vaccine3"] = vaccine3;
  map["vaccine4"] = vaccine4;
  map["input_date"] = input_date;
  map["input_time"]=input_time;
  map["ocr_imgpath"] = ocr_imgpath;
  map["memo"] = memo;
  return map;
  }
}
