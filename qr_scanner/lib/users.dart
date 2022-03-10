import 'dart:convert';

List<Users> usersFromMap(String str) => List<Users>.from(json.decode(str).map((x) => Users.fromMap(x)));

String usersToMap(List<Users> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Users {
  Users({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
  });

  String id;
  String name;
  String email;
  String age;

  factory Users.fromMap(Map<String, dynamic> json) => Users(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    age: json["age"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "email": email,
    "age": age,
  };
}
