// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:mongo_dart/mongo_dart.dart';

List<Map<String, dynamic>> authorModelListToMapList(List<AuthorDbModel> list) {
  return list.map((e) => e.toMap()).toList();
}

class AuthorDbModel extends Equatable {
  const AuthorDbModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.rate,
  });
  factory AuthorDbModel.fromJson(String source) =>
      AuthorDbModel.fromMap(json.decode(source) as Map<String, dynamic>);

  /// fromMap
  factory AuthorDbModel.fromMap(Map<String, dynamic> map) {
    return AuthorDbModel(
      id: map['_id'] as ObjectId,
      name: (map['name'] ?? '') as String,
      description: (map['description']?? '') as String,
      image: (map['image']?? '') as String,
      rate: (map['rate']?? 0) as int,
    );
  }

  final ObjectId id;
  final String name;
  final String description;
  final String image;
  final int rate;

  String toJson() => json.encode(toMap());

  AuthorDbModel copyWith({
    ObjectId? id,
    String? name,
    String? description,
    String? image,
    int? rate,
  }) {
    return AuthorDbModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description?? this.description,
      image: image?? this.image,
      rate: rate?? this.rate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id.toHexString(),
      'name': name,
      'description': description,
      'image': image,
      'rate': rate,
    };
  }

  @override
  String toString() {
    return 'UserDbModel(id: $id, name: $name, description: $description, image: $image, rate: $rate)';
  }

  @override
  List<Object?> get props => [id, name , description, image, rate];
}
