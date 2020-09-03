import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'tabbar_page.dart';
import 'modelss/user.dart';

class LoginPage2 extends StatefulWidget {
  @override
  _LoginPage2State createState() => _LoginPage2State();
}

final storage = new FlutterSecureStorage();

class _LoginPage2State extends State<LoginPage2> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  List urunler;

  Future<User> kullaniciGetir(
      String nameController, String passwordController) async {
    String authorization =
        nameController + ":" + passwordController + ":1:1:TRTR";
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String authEncoded = "BASIC " + stringToBase64.encode(authorization);

    final response = await post(
      'http://172.16.1.97:8090/logo/restservices/rest/login',
      headers: {
        HttpHeaders.authorizationHeader: authEncoded,
      },
    );
    return User.fromJsonMap(json.decode(response.body));
  }

  User user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    kullaniciGetir(nameController.text, passwordController.text).then((value) {
      user = value;
      debugPrint(user.authorization);
      debugPrint("seyma");
      //debugPrint(storage.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context)
          .copyWith(errorColor: Colors.white, primaryColor: Colors.red),
      child: Scaffold(
        body: Container(
          color: Colors.red,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 100,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //SizedBox(height: 50),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: Color(0xffA93226),
                        width: 4,
                      )),
                      child: Image.asset(
                        "assets/images/retina_logo.jpg",
                        width: 400,
                        height: 100,
                      ),
                    ),
                    SizedBox(height: 50),

                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.account_circle),
                        hintText: "Kullanıcı Adı",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      cursorColor: Colors.red,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        hintText: "Sifre",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      cursorColor: Colors.red,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      width: 200,
                      height: 40,
                      child: RaisedButton(
                        onPressed: () => {
                          kullaniciGetir(nameController.text.replaceAll(' ', ''), passwordController.text.replaceAll(' ', '')).then((value) => {
                                    if (value.success){
                                        storage.write(key: "authToken", value: value.authorization),
                                        debugPrint(value.success.toString()),
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => TabBarPage())),
                                    }
                                  }),
                        },
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0)),
                        color: Colors.white,
                        child: Text(
                          "Login",
                          style: TextStyle(color:Color(0xffA93226), fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
