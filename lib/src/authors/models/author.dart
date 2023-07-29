// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Author extends Equatable{
  const Author({
    required this.name,
    required this.description,
    required this.image,
    required this.rate,
  });




  final String name;
  final String description;
  final String image;
  final int rate;
  static const empty = Author(
    name: '',
    description: '',
    image: '',
    rate: 0,
  );

   @override
  List<Object?> get props => [name, description, image, rate];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'image': image,
      'rate': rate,
    };
  }

    Map<String, dynamic> toUpdateMap() {
    return {
      r'$set': {
      'name': name,
      'description': description,
      'image': image,
      'rate': rate,
      }
    };
  }

  factory Author.fromMap(Map<String, dynamic> map) {
    return Author(
      name: (map['name'] ?? '') as String,
      description: (map['description']?? '') as String,
      image: (map['image']?? '') as String,
      rate: (map['rate']?? 0) as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Author.fromJson(String source) =>
      Author.fromMap(json.decode(source) as Map<String, dynamic>);
}
