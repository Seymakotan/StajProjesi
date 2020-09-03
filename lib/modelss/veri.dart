class VeriSatis {
  final List<VeriSatislar> verisatislar;

  VeriSatis({this.verisatislar});

  factory VeriSatis.fromJson(List<dynamic> parse) {
    List<VeriSatislar> satis = new List<VeriSatislar>();
    satis = parse.map((i) => VeriSatislar.fromJson(i)).toList();
    return new VeriSatis(
      verisatislar: satis,
    );
  }
}

class VeriSatislar {
  VeriSatislar({
    this.month,
    this.saamount,
    this.saquantity,
    this.primaryKey,
  });

  String month;
  int saamount;
  int saquantity;
  int primaryKey;

  factory VeriSatislar.fromJson(Map<String, dynamic> json) => VeriSatislar(
    month: json["month"],
    saamount: json["Saamount"],
    saquantity: json["Saquantity"],
    primaryKey: json["primaryKey"],
  );

}
