import 'package:flutter/foundation.dart';
import 'package:foodora/core/utils/token_storage.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/refresh_token_usecase.dart';
import '../../domain/usecases/get_user_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/update_password_usecase.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

class AuthViewModel extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final RefreshTokenUseCase refreshTokenUseCase;
  final GetUserUseCase getUserUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final UpdatePasswordUseCase updatePasswordUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final LogoutUseCase logoutUseCase;

  AuthViewModel({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.refreshTokenUseCase,
    required this.getUserUseCase,
    required this.updateProfileUseCase,
    required this.updatePasswordUseCase,
    required this.forgotPasswordUseCase,
    required this.resetPasswordUseCase,
    required this.logoutUseCase,
  });

  // ... existing fields ...

  Future<void> fetchUserProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getUserUseCase();

    _isLoading = false;

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
      },
      (user) async {
        _user = user;
        _userName = user.name;
        // Optionally update stored name
        await TokenStorage.saveUserName(user.name);
        notifyListeners();
      },
    );
  }
  
  // ... existing methods ...

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserEntity? _user;
  UserEntity? get user => _user;

  String? _userName;
  String? get userName => _userName ?? _user?.name;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await loginUseCase(email, password);

    _isLoading = false;
    
    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (user) async {
        _user = user;
        _userName = user.name;
        // Save token & user name to storage
        await TokenStorage.saveToken(
          token: user.token,
          tokenType: user.tokenType,
          expiresIn: user.expiresIn,
        );
        await TokenStorage.saveUserName(user.name);
        await TokenStorage.saveUserId(user.id);
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await registerUseCase(
      name: name,
      email: email,
      password: password,
      phone: phone,
    );

    _isLoading = false;
    
    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (user) async {
        _user = user;
        _userName = user.name;
        // Save token & user name to storage
        await TokenStorage.saveToken(
          token: user.token,
          tokenType: user.tokenType,
          expiresIn: user.expiresIn,
        );
        await TokenStorage.saveUserName(user.name);
        await TokenStorage.saveUserId(user.id);
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> refreshToken() async {
    final result = await refreshTokenUseCase();
    
    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (user) async {
        _user = user;
        _userName = user.name;
        // Update token & user name in storage
        await TokenStorage.saveToken(
          token: user.token,
          tokenType: user.tokenType,
          expiresIn: user.expiresIn,
        );
        await TokenStorage.saveUserName(user.name);
        await TokenStorage.saveUserId(user.id);
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> checkAuthStatus() async {
    final isAuthenticated = await TokenStorage.isAuthenticated();
    
    if (isAuthenticated) {
      // Load user name from storage
      _userName = await TokenStorage.getUserName();
      
      // Check if token needs refresh
      final isValid = await TokenStorage.isTokenValid();
      if (!isValid) {
        // Try to refresh token
        return await refreshToken();
      }
      notifyListeners();
      return true;
    }
    
    return false;
  }

  Future<bool> updateProfile({required String name, required String phone}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await updateProfileUseCase(name: name, phone: phone);

    _isLoading = false;

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (user) async {
        _user = user;
        _userName = user.name;
        // Update stored name
        await TokenStorage.saveUserName(user.name);
        notifyListeners();
        return true;
      },
    );
  }



  Future<bool> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await updatePasswordUseCase(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    _isLoading = false;

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (_) {
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> forgotPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await forgotPasswordUseCase(email);

    _isLoading = false;

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (_) {
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> resetPassword({
    required String otp,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await resetPasswordUseCase(
      otp: otp,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );

    _isLoading = false;

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (_) {
        notifyListeners();
        return true;
      },
    );
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    final result = await logoutUseCase();

    _isLoading = false;

    // Regardless of server success/failure, we clear local session
    await TokenStorage.deleteToken();
    _user = null;
    _userName = null;
    _errorMessage = null;
    
    notifyListeners();
  }
}
