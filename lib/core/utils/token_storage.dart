import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const String _tokenKey = 'auth_token';
  static const String _tokenTypeKey = 'token_type';
  static const String _expiresAtKey = 'expires_at';
  static const String _userNameKey = 'user_name';

  // Save token with expiration time
  static Future<void> saveToken({
    required String token,
    required String tokenType,
    required int expiresIn,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final expiresAt = DateTime.now().add(Duration(seconds: expiresIn));
    
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_tokenTypeKey, tokenType);
    await prefs.setString(_expiresAtKey, expiresAt.toIso8601String());
  }

  // Save user name
  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
  }

  // Get user name
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  // Get stored token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Get token type
  static Future<String?> getTokenType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenTypeKey);
  }

  // Check if token is valid (not expired)
  static Future<bool> isTokenValid() async {
    final prefs = await SharedPreferences.getInstance();
    final expiresAtStr = prefs.getString(_expiresAtKey);
    
    if (expiresAtStr == null) return false;
    
    final expiresAt = DateTime.parse(expiresAtStr);
    // Consider token invalid if it expires in less than 5 minutes
    final bufferTime = DateTime.now().add(const Duration(minutes: 5));
    
    return expiresAt.isAfter(bufferTime);
  }

  // Get full authorization header value
  static Future<String?> getAuthorizationHeader() async {
    final token = await getToken();
    final tokenType = await getTokenType();
    
    if (token == null || tokenType == null) return null;
    
    return '$tokenType $token';
  }

  // Delete token (logout)
  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_tokenTypeKey);
    await prefs.remove(_expiresAtKey);
    await prefs.remove(_userNameKey);
  }

  // Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    final token = await getToken();
    if (token == null) return false;
    
    return await isTokenValid();
  }

  static const String _hasSeenOnboardingKey = 'has_seen_onboarding';

  // Save has seen onboarding
  static Future<void> saveHasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSeenOnboardingKey, true);
  }

  // Check if has seen onboarding
  static Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasSeenOnboardingKey) ?? false;
  }
}
