// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:book_library/src/auth/models/user_db_model.dart';
import 'package:equatable/equatable.dart';

class LoginResponse extends Equatable {
  final UserDbModel user;
  const LoginResponse({
    required this.user,
  });

  @override
  List<Object?> get props => [user];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user.toMap(),
    };
  }

  factory LoginResponse.fromMap(Map<String, dynamic> map) {
    return LoginResponse(
      user: UserDbModel.fromMap(
        (map['user'] ?? Map<String, dynamic>.from({})) as Map<String, dynamic>,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginResponse.fromJson(String source) =>
      LoginResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
