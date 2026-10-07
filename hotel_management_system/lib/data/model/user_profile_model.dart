// user_profile_model.dart

class User {
  final String id;
  final String name;
  final String email;
  final String role;

  // field เสริมจาก /users/me (อาจเป็น null ถ้ามาจาก login response ตรงๆ)
  final String? phone;
  final String? address;
  final String? status;
  final String? joinDate;
  final String? createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.address,
    this.status,
    this.joinDate,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      phone: json['phone']?.toString(),
      address: json['address']?.toString(),
      status: json['status']?.toString(),
      joinDate: json['join_date']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }

  // ใช้ตอน merge ข้อมูลจาก /users/me เข้ากับ user เดิมใน provider
  // โดยไม่ทำ field ที่ backend ไม่ได้ส่งกลับมาหาย
  User copyWith({
    String? name,
    String? email,
    String? role,
    String? phone,
    String? address,
    String? status,
    String? joinDate,
    String? createdAt,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      status: status ?? this.status,
      joinDate: joinDate ?? this.joinDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}