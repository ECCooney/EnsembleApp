
import 'package:flutter/foundation.dart';

class ItemModel {
  final String name;
  final String itemPic;
  final String id;
  final String groupId;
  final String description;
  final String category;
  final String owner;

  ItemModel({
    required this.name,
    required this.itemPic,
    required this.id,
    required this.groupId,
    required this.description,
    required this.category,
    required this.owner,
  });

  //copyWith function as variables above are final

  ItemModel copyWith({
    String? name,
    String? itemPic,
    String? id,
    String? groupId,
    String? description,
    String? category,
    String? owner,
  }) {
    return ItemModel(
      name: name ?? this.name,
      itemPic: itemPic ?? this.itemPic,
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      description: description ?? this.description,
      category: category ?? this.category,
      owner: owner ?? this.owner,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'itemPic': itemPic,
      'id': id,
      'groupId': groupId,
      'description': description,
      'category': category,
      'owner': owner,
    };
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      name: map['name'] ?? '',
      itemPic: map['itemPic'] ?? '',
      id: map['id'] ?? '',
      groupId: map['groupId'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      owner: map['owner'] ?? '',
    );
  }

  @override
  String toString() {
    return 'ItemModel(name: $name, itemPic: $itemPic, id: $id, groupId: $groupId, description: $description, category: $category, owner: $owner)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ItemModel &&
        other.name == name &&
        other.itemPic == itemPic &&
        other.id == id &&
        other.groupId == groupId &&
        other.description == description &&
        other.category == category &&
        other.owner == owner;
  }

  @override
  int get hashCode {
    return name.hashCode ^
    itemPic.hashCode ^
    id.hashCode ^
    groupId.hashCode ^
    description.hashCode ^
    category.hashCode ^
    owner.hashCode;
  }
}