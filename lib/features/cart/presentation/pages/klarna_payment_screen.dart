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
        title: Text(
          'Klarna Payment',
          style: TextStyle(
            fontSize: AppDimensions.getH3Size(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: AppDimensions.getMaxContentWidth(context),
          ),
          child: Column(
            children: [
              // Status indicator
              Container(
                padding: EdgeInsets.all(
                  AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20),
                ),
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
                      size: AppDimensions.responsiveIconSize(context, mobile: 24, tablet: 28),
                    ),
                    SizedBox(width: AppDimensions.responsiveSpacing(context, mobile: 12, tablet: 16)),
                    Expanded(
                      child: Text(
                        _paymentComplete
                            ? 'Payment successful!'
                            : _isProcessing
                                ? 'Processing payment...'
                                : 'Complete your payment',
                        style: TextStyle(
                          fontSize: AppDimensions.getSmallSize(context),
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
                  padding: EdgeInsets.all(
                    AppDimensions.getResponsiveHorizontalPadding(context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Klarna logo placeholder
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(
                            AppDimensions.responsiveSpacing(context, mobile: 20, tablet: 28),
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFB6C1).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'KLARNA',
                            style: TextStyle(
                              fontSize: AppDimensions.getH1Size(context),
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFFFB6C1),
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 32, tablet: 40)),
                      
                      // Payment details
                      Text(
                        'Buy Now, Pay Later',
                        style: TextStyle(
                          fontSize: AppDimensions.getH2Size(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
                      
                      Container(
                        padding: EdgeInsets.all(
                          AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20),
                        ),
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
                                Text(
                                  'Total Amount:',
                                  style: TextStyle(
                                    fontSize: AppDimensions.getBodySize(context),
                                  ),
                                ),
                                Text(
                                  '\$${widget.cartViewModel.grandTotal.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: AppDimensions.getH3Size(context),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 12, tablet: 16)),
                            const Divider(),
                            SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 12, tablet: 16)),
                            Text(
                              'Pay in 4 interest-free installments',
                              style: TextStyle(
                                fontSize: AppDimensions.getSmallSize(context),
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 8, tablet: 10)),
                            Text(
                              '4 payments of \$${(widget.cartViewModel.grandTotal / 4).toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: AppDimensions.getBodySize(context),
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 24, tablet: 32)),
                      
                      // Mock payment info
                      Container(
                        padding: EdgeInsets.all(
                          AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue[700],
                              size: AppDimensions.responsiveIconSize(context, mobile: 24, tablet: 28),
                            ),
                            SizedBox(width: AppDimensions.responsiveSpacing(context, mobile: 12, tablet: 16)),
                            Expanded(
                              child: Text(
                                'This is a demo payment screen. No real payment will be processed.',
                                style: TextStyle(
                                  fontSize: AppDimensions.getSmallSize(context),
                                ),
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
                padding: EdgeInsets.all(
                  AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    height: AppDimensions.getButtonHeight(context),
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
                          ? SizedBox(
                              height: AppDimensions.responsiveIconSize(context, mobile: 20, tablet: 24),
                              width: AppDimensions.responsiveIconSize(context, mobile: 20, tablet: 24),
                              child: const CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              _paymentComplete ? 'Payment Complete ✓' : 'Pay with Klarna',
                              style: TextStyle(
                                fontSize: AppDimensions.getBodySize(context),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
