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
    return UserModel(id: map['id'], name: map['name'], email: map['email']);
  }
}
