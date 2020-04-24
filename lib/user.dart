class User {
  final String name;
  final String password;

  User({this.name, this.password});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['name'] = name;
    map['password'] = password;
    return map;
  }

  factory User.fromJson(Map<String, dynamic> userJson) {
    return User(
      name: userJson["name"],
      password: userJson["password"],
    );
  }
}
