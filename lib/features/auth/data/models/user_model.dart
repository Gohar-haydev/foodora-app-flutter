import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    super.emailVerifiedAt,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
    required super.token,
    required super.tokenType,
    required super.expiresIn,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Extract data object from response
    final data = json['data'] as Map<String, dynamic>;
    final user = data['user'] as Map<String, dynamic>;
    
    return UserModel(
      id: user['id'] as int,
      name: user['name'] as String,
      email: user['email'] as String,
      phone: user['phone'] as String,
      emailVerifiedAt: user['email_verified_at'] as String?,
      isActive: user['is_active'] as bool,
      createdAt: user['created_at'] as String,
      updatedAt: user['updated_at'] as String,
      token: data['token'] as String,
      tokenType: data['token_type'] as String,
      expiresIn: data['expires_in'] as int,
    );

  }

  factory UserModel.fromProfileJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      emailVerifiedAt: json['email_verified_at'] as String?,
      isActive: (json['is_active'] is int) 
          ? (json['is_active'] == 1) 
          : (json['is_active'] as bool? ?? true),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      // Profile endpoint might not return token, use empty/dummy
      token: '', 
      tokenType: '',
      expiresIn: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'user': {
          'id': id,
          'name': name,
          'email': email,
          'phone': phone,
          'email_verified_at': emailVerifiedAt,
          'is_active': isActive,
          'created_at': createdAt,
          'updated_at': updatedAt,
        },
        'token': token,
        'token_type': tokenType,
        'expires_in': expiresIn,
      }
    };
  }
}
