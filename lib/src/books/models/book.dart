// ignore_for_file: public_member_api_docs

import 'dart:convert';
import 'package:equatable/equatable.dart';

class Book extends Equatable {
  const Book({
    required this.author,
    required this.headline,
    required this.leadParagraph,
    required this.imageUrl,
    required this.category,
    this.createdAt,
    this.modifiedAt,
    this.rate,
  });

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      author: map['author'] as String,
      headline: map['headline'] as String,
      leadParagraph: map['leadParagraph'] as String,
      imageUrl: map['imageUrl'] as String,
      createdAt: map['createdAt'] as String,
      modifiedAt: map['modifiedAt'] as String,
      rate: map['rate'] as int?,
      category: map['category'] as String,
    );
  }

  factory Book.fromJson(String source) =>
      Book.fromMap(json.decode(source) as Map<String, dynamic>);

  final String author;
  final String headline;
  final String leadParagraph;
  final String imageUrl;
  final String? createdAt;
  final String? modifiedAt;
  final int? rate;
  final String category;

  Map<String, dynamic> toMap() {
    return {
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

  Map<String, dynamic> toUpdateMap() {
    return {
      r'$set': {
        'author': author,
        'headline': headline,
        'leadParagraph': leadParagraph,
        'imageUrl': imageUrl,
        'createdAt': createdAt,
        'modifiedAt': modifiedAt,
        'rate': rate,
        'category': category,
      }
    };
  }

  String toJson() => json.encode(toMap());

  Book copyWith({
    String? author,
    String? headline,
    String? leadParagraph,
    String? imageUrl,
    String? createdAt,
    String? modifiedAt,
    int? rate,
    String? category,
  }) {
    return Book(
      author: author ?? this.author,
      headline: headline ?? this.headline,
      leadParagraph: leadParagraph ?? this.leadParagraph,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      rate: rate ?? this.rate,
      category: category ?? this.category,
    );
  }

  @override
  List<Object?> get props => [
        author,
        headline,
        leadParagraph,
        imageUrl,
        createdAt,
        modifiedAt,
        rate,
        category,
      ];
}
