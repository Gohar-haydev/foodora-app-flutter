import 'package:flutter/material.dart';
import 'package:foodora/features/cart/presentation/viewmodels/cart_viewmodel.dart';
import 'package:foodora/features/order/presentation/viewmodels/order_viewmodel.dart';
import 'package:foodora/core/constants/app_constants.dart';

/// Simplified Klarna payment screen without external SDK
/// This is a mock implementation for demonstration purposes
class KlarnaPaymentScreen extends StatefulWidget {
  final String clientToken;
  final String sessionId;
  final CartViewModel cartViewModel;
  final OrderViewModel orderViewModel;
  final Function(String authorizationToken) onPaymentAuthorized;
  final VoidCallback onPaymentCancelled;

  const KlarnaPaymentScreen({
    Key? key,
    required this.clientToken,
    required this.sessionId,
    required this.cartViewModel,
    required this.orderViewModel,
    required this.onPaymentAuthorized,
    required this.onPaymentCancelled,
  }) : super(key: key);

  @override
  State<KlarnaPaymentScreen> createState() => _KlarnaPaymentScreenState();
}

class _KlarnaPaymentScreenState extends State<KlarnaPaymentScreen> {
  bool _isProcessing = false;
  bool _paymentComplete = false;

  void _handlePayment() async {
    setState(() {
      _isProcessing = true;
    });

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isProcessing = false;
      _paymentComplete = true;
    });

    // Simulate successful authorization
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      widget.onPaymentAuthorized(widget.sessionId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Klarna Payment'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Status indicator
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              children: [
                Icon(
                  _paymentComplete
                      ? Icons.check_circle
                      : _isProcessing
                          ? Icons.hourglass_empty
                          : Icons.info_outline,
                  color: _paymentComplete
                      ? Colors.green
                      : _isProcessing
                          ? Colors.orange
                          : AppColors.primaryAccent,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _paymentComplete
                        ? 'Payment successful!'
                        : _isProcessing
                            ? 'Processing payment...'
                            : 'Complete your payment',
                    style: TextStyle(
                      fontSize: 14,
                      color: _paymentComplete ? Colors.green : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Mock Klarna payment interface
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Klarna logo placeholder
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB6C1).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'KLARNA',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFB6C1),
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Payment details
                  const Text(
                    'Buy Now, Pay Later',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Amount:'),
                            Text(
                              '\$${widget.cartViewModel.grandTotal.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 12),
                        const Text(
                          'Pay in 4 interest-free installments',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '4 payments of \$${(widget.cartViewModel.grandTotal / 4).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Mock payment info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue[700]),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'This is a demo payment screen. No real payment will be processed.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Pay button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: (_isProcessing || _paymentComplete) ? null : _handlePayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB6C1),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: _isProcessing
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          _paymentComplete ? 'Payment Complete ✓' : 'Pay with Klarna',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
