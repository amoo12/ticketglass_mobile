import 'dart:convert';

class User {
  String? id;
  String? name;
  String? email;
  String? phoneNumber;
  String? createdAt;
  String? depositeAddress;
  String? tatumId;
  User({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.createdAt,
    this.depositeAddress,
    this.tatumId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt,
      'depositeAddress': depositeAddress,
      'tatumId': tatumId,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      createdAt: map['createdAt'],
      depositeAddress: map['depositeAddress'],
      tatumId: map['tatumId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
