
import 'package:flutter/foundation.dart';

class ItemModel {
  final String name;
  final String itemPic;
  final String id;
  final String description;
  final String owner;

  ItemModel({
    required this.name,
    required this.itemPic,
    required this.id,
    required this.description,
    required this.owner,
  });

  //copyWith function as variables above are final

  ItemModel copyWith({
    String? name,
    String? itemPic,
    String? id,
    String? description,
    String? owner,
  }) {
    return ItemModel(
      name: name ?? this.name,
      itemPic: itemPic ?? this.itemPic,
      id: id ?? this.id,
      description: description ?? this.description,
      owner: owner ?? this.owner,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'itemPic': itemPic,
      'id': id,
      'description': description,
      'owner': owner,
    };
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      name: map['name'] ?? '',
      itemPic: map['itemPic'] ?? '',
      id: map['id'] ?? '',
      description: map['description'] ?? '',
      owner: map['owner'] ?? '',
    );
  }

  @override
  String toString() {
    return 'ItemModel(name: $name, itemPic: $itemPic, id: $id, description: $description, owner: $owner)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ItemModel &&
        other.name == name &&
        other.itemPic == itemPic &&
        other.id == id &&
        other.description == description &&
        other.owner == owner;
  }

  @override
  int get hashCode {
    return name.hashCode ^
    itemPic.hashCode ^
    id.hashCode ^
    description.hashCode ^
    owner.hashCode;
  }
}