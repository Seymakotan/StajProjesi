import 'package:flutter/material.dart';

import 'login.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: Color(0xffe74c3c),
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 30,bottom: 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image:NetworkImage("https://s3.eu-central-1.amazonaws.com/stajim/media/images/company/image/1371_20200116162856.jpg"),
                      fit: BoxFit.fill
                      )
                    ),
                  ),
                  Text("Logo Yazılım",style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.bold),),
                  //Text("seyma.Kotan@logo.com.tr",style: TextStyle(color: Colors.white),)
                ],
              )
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Seyma Kotan"),
          ),
          ListTile(
            leading: Icon(Icons.mail_outline),
            title: Text("seyma.Kotan@logo.com.tr"),
          ),
          ListTile(
            leading: Icon(Icons.work),
            title: Text("Java Ürün Geliştirme"),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app,color: Colors.red.shade700,size: 30,),
            title: Text("Log Out",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red.shade700,fontSize: 16),),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder:(context)=>LoginPage2()));
            },
          )
         ],
      ),
    );
  }
}
