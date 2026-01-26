class ApiConstants {
  static const String baseUrl = 'https://foodora.bitsclan.us/api/v1';
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Klarna Payment Endpoints
  static const String klarnaCreateSession = '/payments/klarna/session';
  static const String klarnaAuthorize = '/payments/klarna/authorize';
}
