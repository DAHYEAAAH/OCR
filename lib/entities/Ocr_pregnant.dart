class Ocr_pregnant {
  int? ocr_seq;
  String? sow_no;
  int? sow_hang;
  String? sow_birth;
  String? sow_buy;
  String? sow_estrus;
  String? sow_cross;
  String? boar_fir;
  String? boar_sec;
  String? checkdate;
  String? expectdate;
  String? vaccine1;
  String? vaccine2;
  String? vaccine3;
  String? vaccine4;
  String? input_date;
  String? ocr_imgpath;
  String? memo;

  Ocr_pregnant({
    this.ocr_seq,
    this.sow_no,
    this.sow_hang,
    this.sow_birth,
    this.sow_buy,
    this.sow_estrus,
    this.sow_cross,
    this.boar_fir,
    this.boar_sec,
    this.checkdate,
    this.expectdate,
    this.vaccine1,
    this.vaccine2,
    this.vaccine3,
    this.vaccine4,
    this.input_date,
    this.ocr_imgpath,
    this.memo,
  });

  factory Ocr_pregnant.fromJson(Map<String, dynamic> json) => Ocr_pregnant(
    ocr_seq: json["ocr_seq"],
    sow_no: json["sow_no"],
    sow_hang: json["sow_hang"],
    sow_birth: json["sow_birth"],
    sow_buy: json["sow_buy"],
    sow_estrus: json["sow_estrus"],
    sow_cross: json["sow_cross"],
    boar_fir: json["boar_fir"],
    boar_sec: json["boar_sec"],
    checkdate: json["checkdate"],
    expectdate: json["expectdate"],
    vaccine1: json["vaccine1"],
    vaccine2: json["vaccine2"],
    vaccine3: json["vaccine3"],
    vaccine4: json["vaccine4"],
    input_date: json["input_date"],
    ocr_imgpath: json["ocr_imgpath"],
    memo: json["memo"],
  );

  Map<String, dynamic> toJson() => {
    "ocr_seq": ocr_seq,
    "sow_no": sow_no,
    "sow_hang": sow_hang,
    "sow_birth": sow_birth,
    "sow_buy": sow_buy,
    "sow_estrus": sow_estrus,
    "sow_cross": sow_cross,
    "boar_fir": boar_fir,
    "boar_sec": boar_sec,
    "checkdate": checkdate,
    "expectdate": expectdate,
    "vaccine1": vaccine1,
    "vaccine2": vaccine2,
    "vaccine3": vaccine3,
    "vaccine4": vaccine4,
    "input_date": input_date,
    "ocr_imgpath": ocr_imgpath,
    "memo": memo,  };

  Map<String, dynamic> toMap() { var map = new Map<String, dynamic>();
  map["ocr_seq"] = ocr_seq;
  map["sow_no"] = sow_no;
  map["sow_hang"] = sow_hang;
  map["sow_birth"] = sow_birth;
  map["sow_buy"] = sow_buy;
  map["sow_estrus"] = sow_estrus;
  map["sow_cross"] = sow_cross;
  map["boar_fir"] = boar_fir;
  map["boar_sec"] = boar_sec;
  map["checkdate"] = checkdate;
  map["expectdate"] = expectdate;
  map["vaccine1"] = vaccine1;
  map["vaccine2"] = vaccine2;
  map["vaccine3"] = vaccine3;
  map["vaccine4"] = vaccine4;
  map["input_date"] = input_date;
  map["ocr_imgpath"] = ocr_imgpath;
  map["memo"] = memo;
  return map;
  }
}