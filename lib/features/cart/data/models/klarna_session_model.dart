/// Model for Klarna payment session response
class KlarnaSessionModel {
  final String clientToken;
  final String sessionId;
  final List<String> paymentMethodCategories;

  KlarnaSessionModel({
    required this.clientToken,
    required this.sessionId,
    required this.paymentMethodCategories,
  });

  factory KlarnaSessionModel.fromJson(Map<String, dynamic> json) {
    // Handle nested 'data' field if present
    final data = json['data'] ?? json;
    
    return KlarnaSessionModel(
      clientToken: data['client_token'] ?? data['clientToken'] ?? '',
      sessionId: data['session_id'] ?? data['sessionId'] ?? '',
      paymentMethodCategories: (data['payment_method_categories'] ?? 
                                 data['paymentMethodCategories'] ?? [])
          .cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'client_token': clientToken,
      'session_id': sessionId,
      'payment_method_categories': paymentMethodCategories,
    };
  }
}

/// Model for Klarna authorization response
class KlarnaAuthorizationModel {
  final String authorizationToken;
  final String orderId;
  final bool approved;

  KlarnaAuthorizationModel({
    required this.authorizationToken,
    required this.orderId,
    required this.approved,
  });

  factory KlarnaAuthorizationModel.fromJson(Map<String, dynamic> json) {
    // Handle nested 'data' field if present
    final data = json['data'] ?? json;
    
    return KlarnaAuthorizationModel(
      authorizationToken: data['authorization_token'] ?? data['authorizationToken'] ?? '',
      orderId: data['order_id'] ?? data['orderId'] ?? '',
      approved: data['approved'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authorization_token': authorizationToken,
      'order_id': orderId,
      'approved': approved,
    };
  }
}
