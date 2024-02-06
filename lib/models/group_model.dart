
import 'package:flutter/foundation.dart';

class GroupModel {
  final String name;
  final String groupPic;
  final String groupBanner;
  final String id;
  final String description;
  final List<String> members;
  final List<String> admins;

  GroupModel({
    required this.name,
    required this.groupPic,
    required this.groupBanner,
    required this.id,
    required this.description,
    required this.members,
    required this.admins,
  });

  //copyWith function as variables above are final

  GroupModel copyWith({
    String? name,
    String? groupPic,
    String? groupBanner,
    String? id,
    String? description,
    List<String>? members,
    List<String>? admins,
  }) {
    return GroupModel(
      name: name ?? this.name,
      groupPic: groupPic ?? this.groupPic,
      groupBanner: groupBanner ?? this.groupBanner,
      id: id ?? this.id,
      description: description ?? this.description,
      members: members ?? this.members,
      admins: admins ?? this.admins,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'groupPic': groupPic,
      'groupBanner': groupBanner,
      'id': id,
      'description': description,
      'members': members,
      'admins': admins,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      name: map['name'] ?? '',
      groupPic: map['groupPic'] ?? '',
      groupBanner: map['groupBanner'] ?? '',
      id: map['id'] ?? '',
      description: map['description'] ?? '',
      members: List<String>.from(map['members']),
      admins: List<String>.from(map['admins']),
    );
  }

  @override
  String toString() {
    return 'GroupModel(name: $name, groupPic: $groupPic, groupBanner: $groupBanner, id: $id, description: $description, members: $members, admins: $admins)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GroupModel &&
        other.name == name &&
        other.groupPic == groupPic &&
        other.groupBanner == groupBanner &&
        other.id == id &&
        other.description == description &&
        listEquals(other.members, members) &&
        listEquals(other.admins, admins);
  }

  @override
  int get hashCode {
    return name.hashCode ^
    groupPic.hashCode ^
    groupBanner.hashCode^
    id.hashCode ^
    description.hashCode ^
    members.hashCode ^ 
    admins.hashCode;
  }
}