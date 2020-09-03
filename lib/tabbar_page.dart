import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_project_staj_logo/main_drawer.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'login.dart';
import 'modelss/veri.dart';
import 'modelss/year_data.dart';


class TabBarPage extends StatefulWidget {
  @override
  _TabBarPageState createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage>  with SingleTickerProviderStateMixin{
  TabController tabController;
  DateTime _dateTimeStart;
  DateTime _dateTimeFinish;
  DateTime _dateTimeYearStart;
  DateTime _dateTimeYearFinish;


  Future<String> getAuthToken() async {
    var value = await storage.read(key: "authToken");
    return value.toString();
  }
  Future<VeriSatis> fetchveriler(authToken, userName,datestart, datefinish) async{
    authToken = "1:" + authToken + ":" + userName;
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String productEncoded = stringToBase64.encode(authToken);

    final response = await post(
        'http://172.16.1.97:8090/logo/restservices/rest/dataQuery/executeSelectQuery',
        headers: {'content-type': 'application/json; charset=UTF-8',
          'Auth-Token': productEncoded},
        body: jsonEncode({
          "jsonFormat": 1,
          "querySqlText": "SELECT SUM(MMITEMDAYTOTALSV.SAAMOUNT) Saamount,SUM(MMITEMDAYTOTALSV.SAQUANTITY) Saquantity,FORMAT(MMITEMDAYTOTALSV.TOTDATE, 'MM/yyyy ') month FROM V_001_01_ITEMDAYTOTS MMITEMDAYTOTALSV LEFT OUTER JOIN U_001_ITEMS ITEMS ON (ITEMS.LOGICALREF = MMITEMDAYTOTALSV.ITEMREF) WHERE ((NOT ((ITEMS.CARDTYPE IN (20, 21, 22))))  AND(MMITEMDAYTOTALSV.WHREF <> -1) AND ((MMITEMDAYTOTALSV.TOTDATE >= '$datestart') AND (MMITEMDAYTOTALSV.TOTDATE <= '$datefinish')) ) GROUP BY  FORMAT(MMITEMDAYTOTALSV.TOTDATE,  'MM/yyyy ') SET ROWCOUNT 0",
          "maxCount": -1,
        }));

    final list = json.decode(response.body)['rows'];
    setState(() {

    });

    return VeriSatis.fromJson(list);
  }

  Future<YilVeri> fetchYilVeri(authToken, userName,datestart, datefinish) async{
    authToken = "1:" + authToken + ":" + userName;
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String productEncoded = stringToBase64.encode(authToken);

    final response = await post(
        'http://172.16.1.97:8090/logo/restservices/rest/dataQuery/executeSelectQuery',
        headers: {'content-type': 'application/json; charset=UTF-8',
          'Auth-Token': productEncoded},
        body: jsonEncode({"jsonFormat":1,"querySqlText":"SELECT SUM(MMITEMDAYTOTALSV.SAAMOUNT) Saamount,SUM(MMITEMDAYTOTALSV.SAQUANTITY) Saquantity,YEAR(MMITEMDAYTOTALSV.TOTDATE) year FROM V_001_01_ITEMDAYTOTS MMITEMDAYTOTALSV LEFT OUTER JOIN U_001_ITEMS ITEMS ON (ITEMS.LOGICALREF = MMITEMDAYTOTALSV.ITEMREF) WHERE ((NOT ((ITEMS.CARDTYPE IN (20, 21, 22))))  AND(MMITEMDAYTOTALSV.WHREF <> -1) AND ((MMITEMDAYTOTALSV.TOTDATE >= '$datestart') AND (MMITEMDAYTOTALSV.TOTDATE <= '$datefinish')) ) GROUP BY  YEAR(MMITEMDAYTOTALSV.TOTDATE) SET ROWCOUNT 0","maxCount":-1}));

    final listyil = json.decode(response.body)['rows'];
    setState(() {

    });
    return YilVeri.fromJson(listyil);
  }


  List<VeriSatislar> veri_test = [];
  List<YilVerileri> veri_yil_test = [];
  final List <Sales> datayearsaamount=[];
  final List <Sales> datayearsaquantity=[];
  final List<Sales> datasaamount = [];
  final List<Sales> datasaquantity = [];
  final List<LinearSales> dataLinechart=[];
  bool fetchay=false;
  bool fetchyil=false;

  var mycontroller =PageController(initialPage: 0,keepPage: true, viewportFraction: 1);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {

    var seriesAmaount = [
      charts.Series(
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (Sales pollution, _) =>
            charts.ColorUtil.fromDartColor(Color(0xffff5733)),
        domainFn: (Sales sales, _) => sales.month,
        measureFn: (Sales sales, _) => sales.satis,
        id: 'Sales',
        data:datasaamount,
        labelAccessorFn: (Sales sales, _) =>
        '${sales.month} : ${sales.satis.toString()}',
      )
    ];
    var seriesAquantitiy = [
      charts.Series(
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (Sales pollution, _) =>
            charts.ColorUtil.fromDartColor(Color(0xffff5733)),
        // colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        //fillColorFn: (Sales pollution, _) => charts.ColorUtil.fromDartColor(Color(0xffff9900)),
        domainFn: (Sales sales, _) => sales.month,
        measureFn: (Sales sales, _) => sales.satis,
        id: 'Sales',
        data:datasaquantity,
        labelAccessorFn: (Sales sales, _) =>
        '${sales.month} : ${sales.satis.toString()}',
      )
    ];
    var seriesYilAmaount = [
      charts.Series(
        // colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        fillColorFn: (Sales pollution, _) =>
            charts.ColorUtil.fromDartColor(Color(0xff9D90EC )),
        domainFn: (Sales sales, _) => sales.month,
        measureFn: (Sales sales, _) => sales.satis,
        id: 'Sales',
        data:datayearsaamount,
        labelAccessorFn: (Sales sales, _) =>
        '${sales.month} : ${sales.satis.toString()}',
      )
    ];
    var seriesYilAquantitiy = [
      charts.Series(
        colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,

        domainFn: (Sales sales, _) => sales.month,
        measureFn: (Sales sales, _) => sales.satis,
        id: 'Sales',
        data:datayearsaquantity,
        labelAccessorFn: (Sales sales, _) =>
        '${sales.month} : ${sales.satis.toString()}',
      )
    ];

    var seriesLine = [
      charts.Series(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.saaquantity,
        measureFn: (LinearSales sales, _) => sales.saamount,
        data: dataLinechart,
      )
    ];
    var chartBarYil = charts.BarChart(
      seriesYilAmaount,
     // vertical: false, //BAR CHART İÇİN
      //barRendererDecorator: charts.BarLabelDecorator<String>(), //BAR CHART İÇİN
      //domainAxis: charts.OrdinalAxisSpec(renderSpec: chartBarYil),//BAR CHART İÇİN
    );
    var chartPieYil = charts.PieChart(
      seriesYilAquantitiy,
      defaultRenderer: charts.ArcRendererConfig(
          arcRendererDecorators: [charts.ArcLabelDecorator(labelPosition: charts.ArcLabelPosition.outside)]),
      behaviors: [
        new charts.DatumLegend(
          position: charts.BehaviorPosition.end,
          horizontalFirst: false,
          cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
          showMeasures: true,
          legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
          measureFormatter: (num value) {
            return value == null ? '-' : '${value}';
          },
        )
      ],
    );

    var chartBarAmount = charts.BarChart(
      seriesAmaount,
    );
    var chartBarQuantity = charts.BarChart(
      seriesAquantitiy,
    );
    var chartPieAmount = charts.PieChart(
      seriesAmaount,
      defaultRenderer: charts.ArcRendererConfig(arcRendererDecorators: [charts.ArcLabelDecorator()]),
      behaviors: [
        new charts.DatumLegend(
          position: charts.BehaviorPosition.end,
          horizontalFirst: false,
          cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
          showMeasures: true,
          legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
          measureFormatter: (num value) {
            return value == null ? '-' : '${value}';
          },
        )
      ],
    );
    var chartPieQuantity = charts.PieChart(
      seriesAquantitiy,
      defaultRenderer: charts.ArcRendererConfig(
          arcRendererDecorators: [charts.ArcLabelDecorator()]),
      behaviors: [
        new charts.DatumLegend(
          position: charts.BehaviorPosition.end,
          horizontalFirst: false,
          cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
          showMeasures: true,
          legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
          measureFormatter: (num value) {
            return value == null ? '-' : '${value}';
          },
        )
      ],
    );
    final defaultdata=[
      Sales("Jan",30),
      Sales("Feb",70),
      Sales("Mar",10),
      Sales("Apr",45),
      Sales("May",50),
    ];
    var defaultseries = [
      charts.Series(
        id: 'Sales',
        fillColorFn: (Sales pollution, _) => charts.ColorUtil.fromDartColor(Color(0xffEC7063 )),
        domainFn: (Sales sales, _) => sales.month,
        measureFn: (Sales sales, _) => sales.satis,
        data: defaultdata,
      )
    ];
    var chartdefaultBar = charts.BarChart(
      defaultseries,
    );
    var chartdefaultPie = charts.PieChart(
      defaultseries,
    );



    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xffe74c3c),
          title: Center(child: Text("Satış Verileri & Tutarları",style:TextStyle(fontWeight: FontWeight.bold,),)),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          bottom: tabBar(),
        ),
        drawer: MainDrawer(),
        body: TabBarView(
          controller: tabController,
          children: <Widget>[
            StaggeredGridView.count(
              padding: EdgeInsets.all(8),
              mainAxisSpacing: 2.0,
              crossAxisSpacing: 2,
              crossAxisCount: 2,
              children: <Widget>[
                Container(
                  width: 300,
                  height: 200,
                  child: Container(
                    height: 100,
                    //color: Colors.red.shade50,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RaisedButton(
                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                              color: Color(0xff85929e),
                              child:Row(
                                children: <Widget>[
                                  Icon(Icons.date_range,color: Colors.white,),
                                  _dateTimeStart == null ? Text("Baslangıc Tarihi",style: TextStyle(color:Colors.white))
                                      : Text("${_dateTimeStart.day.toString().padLeft(2, '0')}-${_dateTimeStart.month.toString().padLeft(2, '0')}-${_dateTimeStart.year.toString()}",style: TextStyle(color: Colors.white)),
                                ],
                              ),
                              onPressed: () {
                                showDatePicker(context: context, initialDate: _dateTimeStart == null ? DateTime.now() : _dateTimeStart,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2021),initialDatePickerMode: DatePickerMode.year).then((date) {
                                  setState(() {
                                    _dateTimeStart = date;
                                  });
                                });
                              },
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(" - "),
                            SizedBox(
                              width: 20,
                            ),
                            RaisedButton(
                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                              color: Color(0xff85929e),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.date_range,color: Colors.white,),
                                  _dateTimeFinish == null ? Text("Bitis Tarihi",style: TextStyle(color: Colors.white),)
                                      : Text("${_dateTimeFinish.day.toString().padLeft(2, '0')}-${_dateTimeFinish.month.toString().padLeft(2, '0')}-${_dateTimeFinish.year.toString()}",style: TextStyle(color: Colors.white)),
                                ],
                              ),
                              onPressed: () {
                                showDatePicker(context: context, initialDate: _dateTimeFinish == null ? DateTime.now() : _dateTimeFinish,
                                    firstDate: DateTime(2000), lastDate: DateTime(2021),initialDatePickerMode: DatePickerMode.year).then((date) {
                                  setState(() {
                                    _dateTimeFinish = date;

                                  });
                                });
                              },
                            ),

                          ],
                        ),
                        RaisedButton(
                          color: Color(0xff5d6d7e),
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                          child: Container(
                            width: 100,
                            height: 20,
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.get_app,color: Colors.white,),
                                Text("Get Data",style: TextStyle(color: Colors.white))
                              ],
                            ),
                          ),
                          onPressed: (){
                            setState(() {
                              getAuthToken().then((value){
                                fetchveriler(value, "admin", _dateTimeStart.toString(), _dateTimeFinish.toString()).then((value) {
                                  fetchay=true;
                                  veri_test.clear();
                                  datasaamount.clear();
                                  datasaquantity.clear();
                                  dataLinechart.clear();
                                  veri_test.addAll(value.verisatislar);
                                  for(int i=0; i<veri_test.length; i++){
                                    debugPrint(veri_test[i].month);
                                    var temp_datasaamount=Sales(veri_test[i].month,veri_test[i].saamount);
                                    var temp_datasaquantity=Sales(veri_test[i].month,veri_test[i].saquantity);
                                    var temp_datalinechart=LinearSales(veri_test[i].saquantity,veri_test[i].saamount);
                                    datasaquantity.add(temp_datasaquantity);
                                    datasaamount.add(temp_datasaamount);
                                    dataLinechart.add(temp_datalinechart);
                                  }
                                });
                              });
                            });
                          },
                        )


                      ],
                    ),
                  ),
                ),
                PageView(
                  scrollDirection: Axis.horizontal,
                  reverse: false,
                  controller: mycontroller,
                  pageSnapping: true,
                  onPageChanged: (index){
                    debugPrint(" gelen page index $index");
                  },children: <Widget>[
                  Card(
                    //color: Colors.red.shade50,
                    elevation: 10, // kartın altındaki gölgeliğin yüksekliği
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Center(child: Text("Satıs Tutarı",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)),
                        ),
                        (fetchay==true ) ? Container(
                          child: chartBarAmount,
                          width: 350,height: 150,):Container(child: chartdefaultBar,width: 400,height: 150,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text("pie chart gösterimi için",style: TextStyle(fontStyle: FontStyle.italic,fontSize: 13),),
                            Icon(Icons.arrow_forward_ios,size: 30,color: Colors.red.shade300,),
                          ],
                        ),
                      ],
                    ),

                  ),
                  Card(
                    //color: Colors.red.shade50,
                    elevation: 10, // kartın altındaki gölgeliğin yüksekliği
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Center(child: Text("Satıs Tutarı",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)),
                        ),
                        (fetchay==true) ? Container(child: chartPieAmount,width: 400,height: 150,):
                        Container(child: chartdefaultPie,width: 400,height: 150,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(Icons.arrow_back_ios,size: 30,color: Colors.red.shade300,),
                            Text("bar chart gösterimi için",style: TextStyle(fontStyle: FontStyle.italic,fontSize: 13),),
                          ],
                        )
                      ],
                    ),

                  )

                ],
                ),


                PageView(
                  scrollDirection: Axis.horizontal,
                  reverse: false,
                  controller: mycontroller,
                  pageSnapping: true,
                  onPageChanged: (index){
                    debugPrint(" gelen page index $index");
                  },children: <Widget>[
                  Card(
                    //color: Colors.red.shade50,
                    elevation: 10, // kartın altındaki gölgeliğin yüksekliği
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Center(child: Text("Satıs Miktarı",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)),
                        ),
                        (fetchay==true ) ? Container(
                          child: chartPieQuantity,
                          width: 350,height: 150,):Container(child: chartdefaultPie,width: 350,height: 150,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text("bar chart gösterimi için",style: TextStyle(fontStyle: FontStyle.italic,fontSize: 13),),
                            Icon(Icons.arrow_forward_ios,size: 30,color: Colors.red.shade300,),

                          ],
                        )
                        ,
                      ],
                    ),

                  ),
                  Card(
                    //color: Colors.red.shade50,
                    elevation: 10, // kartın altındaki gölgeliğin yüksekliği
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Center(child: Text("Satıs Miktarı",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)),
                        ),
                        (fetchay==true ) ? Container(
                          child: chartBarQuantity,
                          width: 350,height: 150,):Container(child: chartdefaultBar,width: 350,height: 150,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(Icons.arrow_back_ios,size: 30,color: Colors.red.shade300,),
                            Text("pie chart gösterimi için",style: TextStyle(fontStyle: FontStyle.italic,fontSize: 13),),
                          ],
                        )
                      ],
                    ),
                  )
                ],
                ),
              ],
              staggeredTiles: [
                StaggeredTile.extent(2, 100),
                StaggeredTile.extent(2, 250),
                StaggeredTile.extent(2, 250),

              ],
            ),


            StaggeredGridView.count(
              padding: EdgeInsets.all(8),
              mainAxisSpacing: 2.0,
              crossAxisSpacing: 2,
              crossAxisCount: 2,
              children: <Widget>[
                Container(
                  // color: Colors.red.shade50,
                  width: 300,
                  height: 200,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                            color: Color(0xff85929e),
                            child:Row(
                              children: <Widget>[
                                Icon(Icons.date_range,color: Colors.white,),
                                _dateTimeYearStart == null
                                    ? Text("Baslangıc Tarihi",style: TextStyle(color:Colors.white))
                                    : Text("${_dateTimeYearStart.day.toString().padLeft(2, '0')}-${_dateTimeYearStart.month.toString().padLeft(2, '0')}-${_dateTimeYearStart.year.toString()}",style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            onPressed: () {
                              showDatePicker(context: context, initialDate: _dateTimeYearStart == null ? DateTime.now() : _dateTimeYearStart,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2021),initialDatePickerMode: DatePickerMode.year).then((date) {
                                setState(() {
                                  _dateTimeYearStart = date;
                                  //veri_test;

                                });
                              });
                            },
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(" - "),
                          SizedBox(
                            width: 20,
                          ),
                          RaisedButton(
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                            color: Color(0xff85929e),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.date_range,color: Colors.white,),
                                _dateTimeYearFinish == null
                                    ? Text("Bitis Tarihi",style: TextStyle(color: Colors.white),)
                                    : Text("${_dateTimeYearFinish.day.toString().padLeft(2, '0')}-${_dateTimeYearFinish.month.toString().padLeft(2, '0')}-${_dateTimeYearFinish.year.toString()}",style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            onPressed: () {
                              showDatePicker(context: context, initialDate: _dateTimeYearFinish == null ? DateTime.now() : _dateTimeYearFinish,
                                  firstDate: DateTime(2000), lastDate: DateTime(2021),initialDatePickerMode: DatePickerMode.year).then((date) {
                                setState(() {
                                  _dateTimeYearFinish = date;
                                });
                              });
                            },
                          ),

                        ],
                      ),
                      RaisedButton(
                        color: Color(0xff5d6d7e),
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                        child: Container(
                          width: 100,
                          height: 20,
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.get_app,color: Colors.white,),
                              Text("Get Data",style: TextStyle(color: Colors.white))
                            ],
                          ),
                        ),
                        onPressed: (){
                          setState(() {
                            getAuthToken().then((value){
                              fetchYilVeri(value, "admin", _dateTimeYearStart.toString(), _dateTimeYearFinish.toString()).then((value){
                                fetchyil=true;
                                veri_yil_test.clear();
                                datayearsaquantity.clear();
                                datayearsaamount.clear();
                                veri_yil_test.addAll(value.yilsatislari);
                                for(int i=0; i<veri_yil_test.length; i++){
                                  debugPrint(veri_yil_test[i].year.toString() );
                                  var temp_datayearsaamount=Sales(veri_yil_test[i].year.toString(),veri_yil_test[i].saamount);
                                  var temp_datayearsaquantity=Sales(veri_yil_test[i].year.toString(),veri_yil_test[i].saquantity);
                                  datayearsaquantity.add(temp_datayearsaquantity);
                                  datayearsaamount.add(temp_datayearsaamount);
                                }
                              });

                            });
                          });
                        },
                      )


                    ],
                  ),
                ),
                Card(
                  //color: Colors.red.shade50,
                  elevation: 10, // kartın altındaki gölgeliğin yüksekliği
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Center(child: Text("Satıs Tutarı",style: TextStyle(color: Color(0xffAA1C3C  ),fontWeight: FontWeight.bold),)),
                      ),
                      (fetchyil==true) ? Container(
                        child: chartBarYil,
                        width: 350,height: 150,):Container(child: chartdefaultBar,width: 350,height: 150,),
                    ],
                  ),
                ),
                Card(
                  //color: Colors.red.shade50,
                  elevation: 10, // kartın altındaki gölgeliğin yüksekliği
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Center(child: Text("Satıs Miktarı",style: TextStyle(color: Color(0xffAA1C3C ),fontWeight: FontWeight.bold),)),
                      ),
                      (fetchyil==true) ? Container(
                        child: chartPieYil,
                        width: 350,height: 150,):Container(child: chartdefaultPie,width: 350,height: 150,),
                    ],
                  ),

                )
              ],
              staggeredTiles: [
                StaggeredTile.extent(2, 100),
                StaggeredTile.extent(2, 250),
                StaggeredTile.extent(2, 250),

              ],
            ),
            (fetchay==true ) ? Container(
              child: ListView.builder(itemBuilder: (context,index){
                return Card(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(veri_test[index].month,style: TextStyle(color:Colors.indigo ),),
                        subtitle:Text( "Total Sales Amount : " + veri_test[index].saamount.toString() +" Quantity : "+ veri_test[index].saquantity.toString(),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueGrey),),
                        leading: CircleAvatar(child: Text((index+1).toString()),foregroundColor: Colors.white,backgroundColor: Colors.red,),
                      ),
                    ],
                  ),
                );
              }, itemCount: veri_test.length,),
            ):
            Column(
              children: <Widget>[
                SizedBox(height: 100,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: double.infinity/2,
                      child: Card(

                          child:ListTile(
                            title: Text("Verileri Görmek için Tarih Aralığı Seçiniz",style: TextStyle(color:Colors.red ,fontSize: 18),),
                            subtitle:Text( "Tarih aralığını seçmek için Ay sekmesine gidiniz",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo.shade400),),
                            leading: Icon(Icons.event_busy,color: Colors.red,size: 30,),
                          )
                      )
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }

  TabBar tabBar() {
    return TabBar(controller: tabController, tabs: [
      Tab(
        icon: Icon(Icons.insert_chart),
        text: "Ay ",
      ),
      Tab(
        icon: Icon(Icons.show_chart),
        text: "Yıl",
      ),
      Tab(
        icon: Icon(Icons.description),
        text: "Data List",
      ),
    ]);
  }
}

class Sales {
  final String month;
  final int satis;

  Sales(this.month, this.satis);
}

class LinearSales {
  final int saamount;
  final int saaquantity;
  LinearSales(this.saaquantity, this.saamount);
}
