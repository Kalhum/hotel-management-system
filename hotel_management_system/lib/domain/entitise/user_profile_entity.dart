// domain/entitise/user_profile_entity.dart
class UserProfileEntity {
  final String? id;
  final String? name;
  final String? email;
  final String? role;
  final String? phone;
  final String? address;
  final String? status;
  final String? joinDate;
  final String? createdAt;

  UserProfileEntity({
    this.id,
    this.name,
    this.email,
    this.role,
    this.phone,
    this.address,
    this.status,
    this.joinDate,
    this.createdAt,
  });

  factory UserProfileEntity.fromJson(Map<String, dynamic> json) =>
      UserProfileEntity(
        id: json["id"]?.toString(),
        name: json["name"]?.toString(),
        email: json["email"]?.toString(),
        role: json["role"]?.toString(),
        phone: json["phone"]?.toString(),
        address: json["address"]?.toString(),
        status: json["status"]?.toString(),
        joinDate: json["join_date"]?.toString(),
        createdAt: json["created_at"]?.toString(),
      );

  UserProfileEntity copyWith({
    String? name,
    String? phone,
    String? address,
  }) {
    return UserProfileEntity(
      id: id,
      name: name ?? this.name,
      email: email,
      role: role,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      status: status,
      joinDate: joinDate,
      createdAt: createdAt,
    );
  }
}