import 'package:flutter/material.dart';
import 'package:flutter_app_project_staj_logo/tabbar_page.dart';
import 'package:flutter_app_project_staj_logo/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "flutter demo",
      initialRoute: '/loginpage',
      theme: ThemeData(
        primaryColor: Colors.red,
      ),
      routes: {
        '/loginpage' :(context)=> LoginPage2(),
        '/mainpage' :(context)=> TabBarPage(),
      },

    );
  }
}

