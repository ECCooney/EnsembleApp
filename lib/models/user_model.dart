
class UserModel {
  final String name;
  final String profilePic;
  final String uid;
  final String email;

  UserModel({
    required this.name,
    required this.profilePic,
    required this.uid,
    required this.email,
  });

  //copyWith function as variables above are final

  UserModel copyWith({
    String? name,
    String? profilePic,
    String? uid,
    String? email,
  }) {
    return UserModel(
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      uid: uid ?? this.uid,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profilePic': profilePic,
      'uid': uid,
      'email': email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      profilePic: map['profilePic'] ?? '',
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
    );
  }

  @override
  String toString() {
    return 'UserModel(name: $name, profilePic: $profilePic, uid: $uid, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.name == name &&
        other.profilePic == profilePic &&
        other.uid == uid &&
        other.email == email;
  }

  @override
  int get hashCode {
    return name.hashCode ^
    profilePic.hashCode ^
    uid.hashCode ^
    email.hashCode;
  }
}