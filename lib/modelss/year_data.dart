class YilVeri{
  final List<YilVerileri> yilsatislari;

  YilVeri({this.yilsatislari});

  factory YilVeri.fromJson(List<dynamic> parse){
    List<YilVerileri> yilsatis= new List<YilVerileri>();
    yilsatis =parse.map((e) => YilVerileri.fromJson(e)).toList();

    return YilVeri(
      yilsatislari: yilsatis,
    );
  }
}

class YilVerileri{
  YilVerileri({
    this.year,
    this.saamount,
    this.saquantity,
    this.primaryKey,
});
  int year;
  int saamount;
  int saquantity;
  int primaryKey;

  factory YilVerileri.fromJson(Map<String, dynamic> json)=> YilVerileri(
    year: json["year"],
    saamount: json["Saamount"],
    saquantity: json["Saquantity"],
    primaryKey: json["primaryKey"],
  );
}