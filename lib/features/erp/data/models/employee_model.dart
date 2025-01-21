class EmployeeModel {
  final String id;
  final String profileId;
  final String name;
  final String phone;
  final double salary;
  final String joinedAt;
  final String? address;
  final int presents;
  final int absents;
  final List<String> absentDays;
  final double credit;
  final DateTime updatedAt;

  EmployeeModel({
    required this.id,
    required this.profileId,
    required this.name,
    required this.phone,
    required this.salary,
    required this.joinedAt,
    this.address,
    this.presents = 0,
    this.absents = 0,
    this.absentDays = const [],
    this.credit = 0.0,
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
      'presents': presents,
      'absents': absents,
      'absent_days': absentDays,
      'credit': credit,
      'updated_at': updatedAt.toIso8601String(),
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
      presents: map['presents'] as int,
      absents: map['absents'] as int,
      absentDays: List<String>.from(
          map['absent_days'] ?? []),
      credit: map['credit'] as double,
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }
}
