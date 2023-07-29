// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:mongo_dart/mongo_dart.dart';

List<Map<String, dynamic>> categoryModelListToMapList(List<CategoryDbModel> list) {
  return list.map((e) => e.toMap()).toList();
}

class CategoryDbModel extends Equatable {
  const CategoryDbModel({
    required this.id,
    required this.title,
  });
  factory CategoryDbModel.fromJson(String source) =>
      CategoryDbModel.fromMap(json.decode(source) as Map<String, dynamic>);

  /// fromMap
  factory CategoryDbModel.fromMap(Map<String, dynamic> map) {
    return CategoryDbModel(
      id: map['_id'] as ObjectId,
      title: (map['title'] ?? '') as String,
    );
  }

  final ObjectId id;
  final String title;
  String toJson() => json.encode(toMap());

  CategoryDbModel copyWith({
    ObjectId? id,
    String? title,
  }) {
    return CategoryDbModel(
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id.toHexString(),
      'title': title,
    };
  }

  @override
  String toString() {
    return 'UserDbModel(id: $id, title: $title)';
  }

  @override
  List<Object?> get props => [id, title];
}
