import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:foodora/features/cart/presentation/viewmodels/cart_viewmodel.dart';
import 'package:foodora/features/order/presentation/viewmodels/order_viewmodel.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:foodora/core/extensions/context_extensions.dart';

/// Klarna Payment Screen using WebView for Pay Later functionality
/// 
/// This implementation uses a WebView to load the Klarna payment widget.
/// For production, replace the demo HTML with your backend's Klarna session URL.
class KlarnaPaymentScreen extends StatefulWidget {
  final String clientToken;
  final String sessionId;
  final CartViewModel cartViewModel;
  final OrderViewModel orderViewModel;
  final Function(String authorizationToken) onPaymentAuthorized;
  final VoidCallback onPaymentCancelled;

  const KlarnaPaymentScreen({
    super.key,
    required this.clientToken,
    required this.sessionId,
    required this.cartViewModel,
    required this.orderViewModel,
    required this.onPaymentAuthorized,
    required this.onPaymentCancelled,
  });

  @override
  State<KlarnaPaymentScreen> createState() => _KlarnaPaymentScreenState();
}

class _KlarnaPaymentScreenState extends State<KlarnaPaymentScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _paymentComplete = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
          },
          onNavigationRequest: (NavigationRequest request) {
            // Handle Klarna callbacks
            if (request.url.contains('klarna-success')) {
              _handlePaymentSuccess();
              return NavigationDecision.prevent;
            }
            if (request.url.contains('klarna-cancel')) {
              widget.onPaymentCancelled();
              Navigator.of(context).pop();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'KlarnaChannel',
        onMessageReceived: (JavaScriptMessage message) {
          // Handle messages from Klarna widget
          if (message.message == 'authorized') {
            _handlePaymentSuccess();
          } else if (message.message == 'cancelled') {
            widget.onPaymentCancelled();
            Navigator.of(context).pop();
          }
        },
      )
      ..loadHtmlString(_buildKlarnaHtml());
  }

  String _buildKlarnaHtml() {
    final total = widget.cartViewModel.grandTotal;
    final installment = (total / 4).toStringAsFixed(2);
    
    // This is a demo HTML that simulates Klarna Pay Later widget
    // In production, this HTML would be served by your backend with actual Klarna SDK
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { 
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      background: #fff;
      padding: 20px;
      color: #1a1a1a;
    }
    .klarna-header {
      text-align: center;
      padding: 30px 0;
    }
    .klarna-logo {
      background: linear-gradient(135deg, #FFB3C7 0%, #FFA0B4 100%);
      color: #000;
      padding: 15px 40px;
      border-radius: 8px;
      font-size: 28px;
      font-weight: bold;
      letter-spacing: 3px;
      display: inline-block;
    }
    .payment-options {
      margin: 30px 0;
    }
    .option {
      border: 2px solid #e5e5e5;
      border-radius: 12px;
      padding: 20px;
      margin-bottom: 15px;
      cursor: pointer;
      transition: all 0.2s;
    }
    .option:hover, .option.selected {
      border-color: #FFB3C7;
      background: #FFF5F7;
    }
    .option.selected::before {
      content: "✓";
      float: right;
      background: #FFB3C7;
      color: #000;
      width: 24px;
      height: 24px;
      border-radius: 50%;
      text-align: center;
      line-height: 24px;
      font-size: 14px;
    }
    .option-title {
      font-size: 18px;
      font-weight: 600;
      margin-bottom: 5px;
    }
    .option-desc {
      font-size: 14px;
      color: #666;
    }
    .option-amount {
      font-size: 16px;
      font-weight: 600;
      color: #FFB3C7;
      margin-top: 8px;
    }
    .total-section {
      background: #f8f8f8;
      border-radius: 12px;
      padding: 20px;
      margin: 20px 0;
    }
    .total-row {
      display: flex;
      justify-content: space-between;
      font-size: 16px;
      margin-bottom: 10px;
    }
    .total-row.final {
      font-size: 20px;
      font-weight: bold;
      padding-top: 10px;
      border-top: 1px solid #ddd;
      margin-top: 10px;
      margin-bottom: 0;
    }
    .pay-button {
      width: 100%;
      background: linear-gradient(135deg, #FFB3C7 0%, #FFA0B4 100%);
      color: #000;
      border: none;
      padding: 18px;
      border-radius: 8px;
      font-size: 18px;
      font-weight: bold;
      cursor: pointer;
      margin-top: 20px;
    }
    .pay-button:disabled {
      opacity: 0.6;
      cursor: not-allowed;
    }
    .info-box {
      background: #E8F4FD;
      border-radius: 8px;
      padding: 15px;
      margin-top: 20px;
      font-size: 13px;
      color: #0066CC;
    }
    .processing {
      text-align: center;
      padding: 40px;
    }
    .spinner {
      border: 4px solid #f3f3f3;
      border-top: 4px solid #FFB3C7;
      border-radius: 50%;
      width: 50px;
      height: 50px;
      animation: spin 1s linear infinite;
      margin: 0 auto 20px;
    }
    @keyframes spin {
      0% { transform: rotate(0deg); }
      100% { transform: rotate(360deg); }
    }
    .hidden { display: none; }
  </style>
</head>
<body>
  <div id="main-content">
    <div class="klarna-header">
      <div class="klarna-logo">KLARNA</div>
    </div>
    
    <div class="payment-options">
      <div class="option selected" onclick="selectOption(this, 'pay_later')">
        <div class="option-title">Pay in 30 days</div>
        <div class="option-desc">Try before you buy. No fees if you pay on time.</div>
        <div class="option-amount">\$${total.toStringAsFixed(2)} due in 30 days</div>
      </div>
      
      <div class="option" onclick="selectOption(this, 'installments')">
        <div class="option-title">Pay in 4 interest-free installments</div>
        <div class="option-desc">Split your purchase into 4 payments, every 2 weeks.</div>
        <div class="option-amount">4 × \$$installment</div>
      </div>
      
      <div class="option" onclick="selectOption(this, 'financing')">
        <div class="option-title">Monthly financing</div>
        <div class="option-desc">Pay over 6-36 months with flexible terms.</div>
        <div class="option-amount">From \$${(total / 12).toStringAsFixed(2)}/month</div>
      </div>
    </div>
    
    <div class="total-section">
      <div class="total-row">
        <span>Order Total</span>
        <span>\$${total.toStringAsFixed(2)}</span>
      </div>
      <div class="total-row final">
        <span>Pay with Klarna</span>
        <span>\$${total.toStringAsFixed(2)}</span>
      </div>
    </div>
    
    <button class="pay-button" onclick="processPayment()">
      Continue with Klarna
    </button>
    
    <div class="info-box">
      🔒 Secure payment powered by Klarna. Your information is protected and encrypted.
    </div>
  </div>
  
  <div id="processing" class="processing hidden">
    <div class="spinner"></div>
    <div style="font-size: 18px; font-weight: 600;">Processing Payment...</div>
    <div style="color: #666; margin-top: 10px;">Please wait while we authorize your payment</div>
  </div>

  <script>
    let selectedOption = 'pay_later';
    
    function selectOption(element, option) {
      document.querySelectorAll('.option').forEach(opt => opt.classList.remove('selected'));
      element.classList.add('selected');
      selectedOption = option;
    }
    
    function processPayment() {
      document.getElementById('main-content').classList.add('hidden');
      document.getElementById('processing').classList.remove('hidden');
      
      // Simulate payment processing
      setTimeout(function() {
        // Send success message to Flutter
        if (window.KlarnaChannel) {
          KlarnaChannel.postMessage('authorized');
        } else {
          // Fallback: navigate to success URL
          window.location.href = 'klarna-success://payment';
        }
      }, 2000);
    }
  </script>
</body>
</html>
''';
  }

  void _handlePaymentSuccess() {
    setState(() => _paymentComplete = true);
    
    // Generate authorization token
    final authToken = 'klarna_auth_${DateTime.now().millisecondsSinceEpoch}';
    
    // Delay slightly to show success state
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        widget.onPaymentAuthorized(authToken);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('klarna_payment'),
          style: TextStyle(
            fontSize: AppDimensions.getH3Size(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            widget.onPaymentCancelled();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFFB3C7),
              ),
            ),
          if (_paymentComplete)
            Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green.shade600,
                        size: 80,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      context.tr('payment_successful'),
                      style: TextStyle(
                        fontSize: AppDimensions.getH2Size(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.tr('redirecting'),
                      style: TextStyle(
                        fontSize: AppDimensions.getBodySize(context),
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
