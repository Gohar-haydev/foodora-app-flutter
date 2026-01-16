class UserEntity {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? emailVerifiedAt;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  final String token;
  final String tokenType;
  final int expiresIn;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.emailVerifiedAt,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.token,
    required this.tokenType,
    required this.expiresIn,
  });
}
