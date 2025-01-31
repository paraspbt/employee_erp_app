// ignore_for_file: public_member_api_docs, sort_constructors_first
class EmployeeModel {
  final String id;
  final String profileId;
  final String name;
  final String phone;
  final double salary;
  final String joinedAt;
  final String? address;
  final double credit;
  final DateTime updatedAt;
  final String lastPaid;
  final String? note;

  EmployeeModel({
    required this.id,
    required this.profileId,
    required this.name,
    required this.phone,
    required this.salary,
    required this.joinedAt,
    this.address,
    this.credit = 0.0,
    this.lastPaid = '',
    this.note,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'profile_id': profileId,
      'name': name,
      'phone': phone,
      'salary': salary,
      'joined_at': joinedAt,
      'address': address,
      'credit': credit,
      'updated_at': updatedAt.toIso8601String(),
      'last_paid' : lastPaid,
      'note' : note,
    };
  }

  factory EmployeeModel.fromMap(Map<String, dynamic> map) {
    return EmployeeModel(
      id: map['id'] as String,
      profileId: map['profile_id'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
      salary: map['salary'] as double,
      joinedAt: map['joined_at'] as String,
      address: map['address'] != null ? map['address'] as String : null,
      credit: map['credit'] as double,
      updatedAt: DateTime.parse(map['updated_at'] as String),
      lastPaid: map['last_paid'] as String,
      note: map['note'] as String,
    );
  }

  get joiningDate => null;

  EmployeeModel copyWith({
    String? id,
    String? profileId,
    String? name,
    String? phone,
    double? salary,
    String? joinedAt,
    String? address,
    double? credit,
    DateTime? updatedAt,
    String? lastPaid,
    String? note,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      salary: salary ?? this.salary,
      joinedAt: joinedAt ?? this.joinedAt,
      address: address ?? this.address,
      credit: credit ?? this.credit,
      updatedAt: updatedAt ?? this.updatedAt,
      lastPaid: lastPaid ?? this.lastPaid,
      note: note ?? this.note,
    );
  }
}
