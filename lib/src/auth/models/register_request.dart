// ignore_for_file: sort_constructors_first, public_member_api_docs, lines_longer_than_80_chars
import 'dart:convert';

import 'package:equatable/equatable.dart';

class CreateUserReq extends Equatable {
  const CreateUserReq({
    required this.name,
    required this.email,
    required this.password,
    this.token,
  });

  final String name;
  final String email;
  final String password;
  final String? token;

  CreateUserReq copyWith({
    String? name,
    String? email,
    String? password,
    String? token,
  }) {
    return CreateUserReq(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
      'token':token,
    };
  }

  factory CreateUserReq.fromMap(Map<String, dynamic> map) {
    return CreateUserReq(
      name: (map['name'] ?? '') as String,
      email: (map['email'] ?? '') as String,
      password: (map['password'] ?? '') as String,
      token: (map['token'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateUserReq.fromJson(String source) =>
      CreateUserReq.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CreateUserReq(name: $name, email: $email, password: $password,token: $token)';

  @override
  List<Object?> get props => [name, email, password,token];
}
