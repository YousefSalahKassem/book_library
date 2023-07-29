// ignore_for_file: public_member_api_docs

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:mongo_dart/mongo_dart.dart';

List<Map<String, dynamic>> bookModelListToMapList(List<BookDbModel> list) {
  return list.map((e) => e.toMap()).toList();
}

class BookDbModel extends Equatable {
  const BookDbModel({
    required this.id,
    required this.author,
    required this.headline,
    required this.leadParagraph,
    required this.imageUrl,
    required this.category,
    this.createdAt,
    this.modifiedAt,
    this.rate,
  });

  factory BookDbModel.fromJson(String source) =>
      BookDbModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory BookDbModel.fromMap(Map<String, dynamic> map) {
    return BookDbModel(
      id: map['_id'] as ObjectId,
      author: map['author'] as String? ?? '',
      headline: map['headline'] as String? ?? '',
      leadParagraph: map['leadParagraph'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      rate: map['rate'] as int,
      createdAt: map['createdAt'] as String,
      modifiedAt: map['modifiedAt'] as String,
      category: map['category'] as String? ?? '',
    );
  }

  final ObjectId id;
  final String author;
  final String headline;
  final String leadParagraph;
  final String imageUrl;
  final String? createdAt;
  final String? modifiedAt;
  final int? rate;
  final String category;

  String toJson() => json.encode(toMap());

  BookDbModel copyWith({
    ObjectId? id,
    String? author,
    String? headline,
    int? rate,
    String? leadParagraph,
    String? imageUrl,
    String? createdAt,
    String? modifiedAt,
    String? category,
  }) {
    return BookDbModel(
      id: id ?? this.id,
      rate: rate ?? this.rate,
      author: author ?? this.author,
      headline: headline ?? this.headline,
      leadParagraph: leadParagraph ?? this.leadParagraph,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id.toHexString(),
      'author': author,
      'headline': headline,
      'leadParagraph': leadParagraph,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
      'modifiedAt': modifiedAt,
      'rate': rate,
      'category': category,
    };
  }

  @override
  String toString() {
    return 'BookDbModel(id: $id, )';
  }

  @override
  List<Object?> get props => [
        id,
      ];
}
