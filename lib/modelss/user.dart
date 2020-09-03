class User{
  final String authorization; //authkey için
  final bool success; //giriş durumu
  User({
    this.authorization,
    this.success,
  });

  User.fromJsonMap(Map<String, dynamic> map):
        authorization = map['authToken'],
        success = map['success'];

}