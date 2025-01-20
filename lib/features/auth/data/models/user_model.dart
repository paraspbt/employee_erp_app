// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String id;
  final String name;
  final String email;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
        id: map['id'],
        name: map['user_metadata']['name'],
        email: map['user_metadata']['email']);
  }

  factory UserModel.fromJsonSessiondata(Map<String, dynamic> map) {
    return UserModel(
        id: map['id'],
        name: map['name'],
        email: 'Email');
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}
