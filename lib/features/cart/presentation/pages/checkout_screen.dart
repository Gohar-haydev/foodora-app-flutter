import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:foodora/features/cart/presentation/viewmodels/cart_viewmodel.dart';
import 'package:foodora/features/cart/presentation/pages/order_confirmation_screen.dart';
import 'package:foodora/features/cart/presentation/pages/change_address_screen.dart';
import 'package:foodora/features/cart/presentation/pages/klarna_payment_screen.dart';
import 'package:foodora/features/cart/data/datasources/klarna_payment_datasource.dart';
import 'package:foodora/features/order/presentation/viewmodels/order_viewmodel.dart';
import 'package:foodora/features/order/data/models/order_request_model.dart';
import 'package:foodora/features/order/data/models/order_item_request_model.dart';
import 'package:foodora/features/order/data/models/order_addon_request_model.dart';
import 'package:foodora/core/utils/token_storage.dart';
import 'package:foodora/core/network/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodora/core/extensions/context_extensions.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:foodora/core/widgets/error_dialog.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _addressLabel = 'Home';
  String _addressText = '123 Main Street, New York, USA';
  String _paymentMethod = AppStrings.cashOnDelivery;
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _promoCodeController = TextEditingController();
  String? _appliedPromoCode;
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    _loadSavedAddress();
  }

  Future<void> _loadSavedAddress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _addressLabel = prefs.getString('delivery_address_label') ?? 'Home';
      _addressText = prefs.getString('delivery_address_text') ??
          '123 Main Street, New York, USA';
      final lat = prefs.getString('delivery_latitude');
      final lng = prefs.getString('delivery_longitude');
      if (lat != null) _latitude = double.tryParse(lat);
      if (lng != null) _longitude = double.tryParse(lng);
    });
  }

  Future<void> _saveAddress(String label, String address,
      {String? latitude, String? longitude}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('delivery_address_label', label);
    await prefs.setString('delivery_address_text', address);
    if (latitude != null) {
      await prefs.setString('delivery_latitude', latitude);
    }
    if (longitude != null) {
      await prefs.setString('delivery_longitude', longitude);
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    _promoCodeController.dispose();
    super.dispose();
  }

  Future<void> _changeAddress() async {
    final result = await Navigator.of(context).push<Map<String, String>>(
      MaterialPageRoute(
        builder: (_) =>
            ChangeAddressScreen(
              currentAddress: _addressText,
              currentLabel: _addressLabel,
            ),
      ),
    );

    if (result != null) {
      final label = result['label'] ?? 'Home';
      final address = result['address'] ?? _addressText;
      final latitude = result['latitude'];
      final longitude = result['longitude'];

      setState(() {
        _addressLabel = label;
        _addressText = address;
        if (latitude != null) _latitude = double.tryParse(latitude);
        if (longitude != null) _longitude = double.tryParse(longitude);
      });

      // Save address to SharedPreferences
      await _saveAddress(
          label, address, latitude: latitude, longitude: longitude);
    }
  }

  void _showPaymentMethodBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) =>
          Container(
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            padding: EdgeInsets.all(
              AppDimensions.getResponsiveHorizontalPadding(context),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.grey300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 20, tablet: 28)),
                Text(
                  context.tr('select_payment_method'),
                  style: TextStyle(
                    fontSize: AppDimensions.getH3Size(context),
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 20, tablet: 28)),

                // PayPal Option
                _buildPaymentOption(
                  icon: Icons.paypal,
                  title: context.tr('paypal'),
                  isSelected: _paymentMethod == context.tr('paypal'),
                  onTap: () {
                    setState(() => _paymentMethod = context.tr('paypal'));
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 12, tablet: 16)),

                // Klarna Option
                _buildPaymentOption(
                  icon: Icons.credit_score,
                  title: context.tr('klarna'),
                  isSelected: _paymentMethod == context.tr('klarna'),
                  onTap: () {
                    setState(() => _paymentMethod = context.tr('klarna'));
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 12, tablet: 16)),

                // Cash on Delivery Option
                _buildPaymentOption(
                  icon: Icons.money,
                  title: context.tr('cash_on_delivery'),
                  isSelected: _paymentMethod == context.tr('cash_on_delivery'),
                  onTap: () {
                    setState(() => _paymentMethod = context.tr('cash_on_delivery'));
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 20, tablet: 28)),
              ],
            ),
          ),
    );
  }

  void _handlePayPalPayment(CartViewModel cartViewModel, OrderViewModel orderViewModel) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaypalCheckoutView(
          sandboxMode: true,
          clientId: "AZu9hsdQ5-kT6IDF7ItoUjcDoc1VCtaDMRYcPO8ru7ThpAx-XiaAyVFe6Pi88opZV79aTsRuC6Dhtd1k",
          secretKey: "EMZ5tcvuia--E7MB_6YhdE0FzqrmG37HoFx8LNXv15cPLSE2z6cFxKe6AjSeEkk4rf2naO36ifAu_xgW",
          transactions: [
            {
              "amount": {
                "total": cartViewModel.grandTotal.toStringAsFixed(2),
                "currency": "USD",
                "details": {
                  "subtotal": cartViewModel.totalAmount.toStringAsFixed(2),
                  "shipping": cartViewModel.deliveryFee.toStringAsFixed(2),
                  "tax": cartViewModel.tax.toStringAsFixed(2),
                  "shipping_discount": 0
                }
              },
              "description": "Foodora Order",
              "item_list": {
                "items": cartViewModel.cartItems.map((item) {
                  return {
                    "name": item.menuItem.name,
                    "quantity": item.quantity,
                    "price": (double.tryParse(item.menuItem.price) ?? 0.0).toStringAsFixed(2),
                    "currency": "USD"
                  };
                }).toList(),
              }
            }
          ],
          note: "Contact us for any questions on your order.",
          onSuccess: (Map params) async {
              print("onSuccess: $params");
            _createOrder(cartViewModel, orderViewModel);
          },
          onError: (error) {
              print("onError: $error");
            context.showError(
              title: context.tr('payment_error'),
              message: context.tr('paypal_payment_error'),
            );
          },
          onCancel: () {
              print('cancelled');
          },
        ),
      ),
    );
  }

  void _handleKlarnaPayment(CartViewModel cartViewModel, OrderViewModel orderViewModel) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final apiService = ApiService();
      final klarnaDataSource = KlarnaPaymentDataSource(apiService: apiService);

      final orderLines = cartViewModel.cartItems.map((item) {
        return {
          'name': item.menuItem.name,
          'quantity': item.quantity,
          'unit_price': (double.tryParse(item.menuItem.price) ?? 0.0) * 100,
          'total_amount': (item.totalPrice * 100).toInt(),
        };
      }).toList();

      final sessionResult = await klarnaDataSource.createKlarnaSession(
        totalAmount: (cartViewModel.grandTotal * 100),
        currency: 'USD',
        orderLines: orderLines,
        purchaseCountry: 'US',
      );

      if (mounted) Navigator.of(context).pop();

      sessionResult.fold(
        (error) {
          context.showError(
            title: context.tr('session_creation_failed'),
            message: error.message,
          );
        },
        (sessionModel) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => KlarnaPaymentScreen(
                clientToken: sessionModel.clientToken,
                sessionId: sessionModel.sessionId,
                cartViewModel: cartViewModel,
                orderViewModel: orderViewModel,
                onPaymentAuthorized: (authToken) async {
                  final authResult = await klarnaDataSource.authorizeKlarnaPayment(
                    authorizationToken: authToken,
                    sessionId: sessionModel.sessionId,
                  );

                  authResult.fold(
                    (error) {
                      if (mounted) {
                        context.showError(
                          title: 'Authorization Failed',
                          message: error.message,
                        );
                      }
                    },
                    (authModel) {
                      if (authModel.approved) {
                        if (mounted) {
                          Navigator.of(context).pop();
                          _createOrder(cartViewModel, orderViewModel);
                        }
                      } else {
                        if (mounted) {
                          context.showError(
                            title: context.tr('payment_not_approved'),
                            message: context.tr('klarna_not_approved_message'),
                          );
                        }
                      }
                    },
                  );
                },
                onPaymentCancelled: () {
                    print('Klarna payment cancelled by user');
                },
              ),
            ),
          );
        },
      );
    } catch (e) {
      if (mounted) Navigator.of(context).pop();
      
      context.showError(
        title: context.tr('klarna_payment_error'),
        message: '${context.tr('an_error_occurred')}: ${e.toString()}',
      );
    }
  }

  Future<void> _createOrder(CartViewModel cartViewModel, OrderViewModel orderViewModel) async {
    final orderRequest = OrderRequestModel(
      deliveryType: "delivery",
      paymentMethod: _paymentMethod == AppStrings.cashOnDelivery ? "cash" : "card",
      deliveryAddress: _addressText,
      deliveryLat: _latitude,
      deliveryLng: _longitude,
      customerName: await TokenStorage.getUserName() ?? "Guest",
      customerPhone: "+1234567890",
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      items: cartViewModel.cartItems.map((cartItem) {
        return OrderItemRequestModel(
          menuItemId: cartItem.menuItem.id,
          quantity: cartItem.quantity,
          specialInstructions: null,
          addons: cartItem.selectedAddons.map((addon) {
            return OrderAddonRequestModel(
              addonId: addon.id,
              quantity: 1,
            );
          }).toList(),
        );
      }).toList(),
    );

    final success = await orderViewModel.createOrder(orderRequest);

    if (success && mounted) {
      cartViewModel.clearCart();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => OrderConfirmationScreen(
            order: orderViewModel.lastCreatedOrder!,
          ),
        ),
      );
    } else if (mounted) {
      context.showError(
        title: context.tr('order_failed'),
        message: orderViewModel.errorMessage ?? context.tr('failed_to_place_order'),
      );
    }
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.spacing12),
      child: Container(
        padding: EdgeInsets.all(
          AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20),
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryAccent.withValues(alpha: 0.1) : AppColors.grey50,
          borderRadius: BorderRadius.circular(AppDimensions.spacing12),
          border: Border.all(
            color: isSelected ? AppColors.primaryAccent : AppColors.grey300,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(
                AppDimensions.responsiveSpacing(context, mobile: 10, tablet: 12),
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryAccent : AppColors.grey200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.white : AppColors.grey600,
                size: AppDimensions.responsiveIconSize(context, mobile: 24, tablet: 28),
              ),
            ),
            SizedBox(width: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: AppDimensions.getBodySize(context),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? AppColors.primaryAccent : AppColors.black87,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primaryAccent,
                size: AppDimensions.responsiveIconSize(context, mobile: 24, tablet: 28),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          context.tr('checkout'),
          style: TextStyle(
            fontSize: AppDimensions.getH3Size(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primaryText,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: AppDimensions.getMaxContentWidth(context),
          ),
          child: Consumer<CartViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.cartItems.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.remove_shopping_cart,
                        size: AppDimensions.responsiveIconSize(context, mobile: 64, tablet: 80),
                        color: AppColors.mutedText,
                      ),
                      SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 24)),
                      Text(
                        context.tr('your_cart_is_empty'),
                        style: TextStyle(
                          color: AppColors.mutedText,
                          fontSize: AppDimensions.getH3Size(context),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                padding: EdgeInsets.all(
                  AppDimensions.getResponsiveHorizontalPadding(context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Delivery Address Section
                    _SectionHeader(title: context.tr('delivery_address')),
                    SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 12, tablet: 16)),
                    Container(
                      padding: EdgeInsets.all(
                        AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryText.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: AppColors.primaryAccent,
                            size: AppDimensions.responsiveIconSize(context, mobile: 24, tablet: 28),
                          ),
                          SizedBox(width: AppDimensions.responsiveSpacing(context, mobile: 12, tablet: 16)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _addressLabel,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: AppDimensions.getBodySize(context),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _addressText,
                                  style: TextStyle(
                                    color: AppColors.grey,
                                    fontSize: AppDimensions.getSmallSize(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: _changeAddress,
                            child: Text(context.tr('change')),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 24, tablet: 32)),

                    // Payment Method Section
                    _SectionHeader(title: context.tr('payment_method')),
                    SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 12, tablet: 16)),
                    Container(
                      padding: EdgeInsets.all(
                        AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryText.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _paymentMethod == AppStrings.paypal
                                ? Icons.paypal
                                : _paymentMethod == AppStrings.klarna
                                ? Icons.credit_score
                                : Icons.money,
                            color: AppColors.primaryAccent,
                            size: AppDimensions.responsiveIconSize(context, mobile: 24, tablet: 28),
                          ),
                          SizedBox(width: AppDimensions.responsiveSpacing(context, mobile: 12, tablet: 16)),
                          Expanded(
                            child: Text(
                              _paymentMethod,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: AppDimensions.getBodySize(context),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: _showPaymentMethodBottomSheet,
                            child: Text(context.tr('change')),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 24, tablet: 32)),

                    // Order Notes Section
                    _SectionHeader(title: context.tr('order_notes')),
                    SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 12, tablet: 16)),
                    Container(
                      padding: EdgeInsets.all(
                        AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryText.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _notesController,
                        maxLines: 4,
                        style: TextStyle(
                          fontSize: AppDimensions.getBodySize(context),
                        ),
                        decoration: InputDecoration(
                          hintText: context.tr('order_notes_hint'),
                          hintStyle: TextStyle(
                            color: AppColors.grey,
                            fontSize: AppDimensions.getSmallSize(context),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.spacing12),
                            borderSide: const BorderSide(color: AppColors.grey300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.spacing12),
                            borderSide: const BorderSide(color: AppColors.grey300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.spacing12),
                            borderSide: const BorderSide(
                                color: AppColors.primaryAccent, width: 2),
                          ),
                          contentPadding: EdgeInsets.all(
                            AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 12, right: 8, top: 12),
                            child: Icon(
                              Icons.note_outlined,
                              color: AppColors.primaryAccent,
                              size: AppDimensions.responsiveIconSize(context, mobile: 24, tablet: 28),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 24, tablet: 32)),

                    // Promo Code Section
                    _SectionHeader(title: context.tr('promo_code')),
                    SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 12, tablet: 16)),
                    Container(
                      padding: EdgeInsets.all(
                        AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryText.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _promoCodeController,
                              style: TextStyle(
                                fontSize: AppDimensions.getBodySize(context),
                              ),
                              decoration: InputDecoration(
                                hintText: context.tr('promo_code_hint'),
                                hintStyle: TextStyle(
                                  color: AppColors.grey,
                                  fontSize: AppDimensions.getSmallSize(context),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(AppDimensions.spacing12),
                                  borderSide: const BorderSide(color: AppColors.grey300),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(AppDimensions.spacing12),
                                  borderSide: const BorderSide(color: AppColors.grey300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(AppDimensions.spacing12),
                                  borderSide: const BorderSide(
                                      color: AppColors.primaryAccent, width: 2),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20),
                                  vertical: AppDimensions.responsiveSpacing(context, mobile: 14, tablet: 16),
                                ),
                                prefixIcon: Icon(
                                  Icons.local_offer_outlined,
                                  color: _appliedPromoCode != null ? AppColors.success : AppColors.primaryAccent,
                                  size: AppDimensions.responsiveIconSize(context, mobile: 24, tablet: 28),
                                ),
                                suffixIcon: _appliedPromoCode != null
                                    ? IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _appliedPromoCode = null;
                                            _promoCodeController.clear();
                                          });
                                        },
                                        icon: Icon(
                                          Icons.close,
                                          color: AppColors.grey,
                                          size: AppDimensions.responsiveIconSize(context, mobile: 20, tablet: 24),
                                        ),
                                      )
                                    : null,
                              ),
                              enabled: _appliedPromoCode == null,
                            ),
                          ),
                          SizedBox(width: AppDimensions.responsiveSpacing(context, mobile: 12, tablet: 16)),
                          SizedBox(
                            height: AppDimensions.responsive(context, mobile: 50, tablet: 56),
                            child: ElevatedButton(
                              onPressed: _appliedPromoCode != null
                                  ? null
                                  : () {
                                      if (_promoCodeController.text.isNotEmpty) {
                                        setState(() {
                                          _appliedPromoCode = _promoCodeController.text;
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(context.tr('promo_code_applied')),
                                            backgroundColor: AppColors.success,
                                            duration: const Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _appliedPromoCode != null
                                    ? AppColors.success
                                    : AppColors.primaryAccent,
                                foregroundColor: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppDimensions.spacing12),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppDimensions.responsiveSpacing(context, mobile: 20, tablet: 28),
                                ),
                              ),
                              child: Text(
                                _appliedPromoCode != null
                                    ? context.tr('applied')
                                    : context.tr('apply'),
                                style: TextStyle(
                                  fontSize: AppDimensions.getBodySize(context),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 24, tablet: 32)),

                    // Order Summary
                    _SectionHeader(title: context.tr('order_summary')),
                    SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 12, tablet: 16)),
                    Container(
                      padding: EdgeInsets.all(
                        AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryText.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          ...viewModel.cartItems.map((item) =>
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${item.quantity}x ${item.menuItem.name}',
                                        style: TextStyle(
                                          fontSize: AppDimensions.getSmallSize(context),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '\$${item.totalPrice.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: AppDimensions.getSmallSize(context),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          Divider(height: AppDimensions.responsiveSpacing(context, mobile: 24, tablet: 32)),
                          _SummaryRow(label: context.tr('subtotal'), amount: viewModel.totalAmount),
                          SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 8, tablet: 10)),
                          _SummaryRow(label: context.tr('delivery_fee'), amount: viewModel.deliveryFee),
                          SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 8, tablet: 10)),
                          _SummaryRow(label: context.tr('tax'), amount: viewModel.tax),
                          Divider(height: AppDimensions.responsiveSpacing(context, mobile: 24, tablet: 32)),
                          _SummaryRow(label: context.tr('total'), amount: viewModel.grandTotal, isTotal: true),
                        ],
                      ),
                    ),
                    SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 32, tablet: 40)),

                    // Place Order Button
                    SizedBox(
                      width: double.infinity,
                      height: AppDimensions.getButtonHeight(context),
                      child: Consumer<OrderViewModel>(
                        builder: (context, orderViewModel, _) {
                          return ElevatedButton(
                            onPressed: orderViewModel.isLoading ? null : () async {
                              if (_paymentMethod == context.tr('paypal')) {
                                _handlePayPalPayment(viewModel, orderViewModel);
                              } else if (_paymentMethod == context.tr('klarna')) {
                                _handleKlarnaPayment(viewModel, orderViewModel);
                              } else {
                                await _createOrder(viewModel, orderViewModel);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryAccent,
                              foregroundColor: AppColors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              elevation: 5,
                            ),
                            child: orderViewModel.isLoading
                                ? SizedBox(
                              height: AppDimensions.responsiveIconSize(context, mobile: 20, tablet: 24),
                              width: AppDimensions.responsiveIconSize(context, mobile: 20, tablet: 24),
                              child: const CircularProgressIndicator(
                                color: AppColors.white,
                                strokeWidth: 2,
                              ),
                            )
                                : Text(
                              context.tr('place_order'),
                              style: TextStyle(
                                fontSize: AppDimensions.getBodySize(context),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: AppDimensions.getH3Size(context),
        fontWeight: FontWeight.bold,
        color: AppColors.primaryText,
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isTotal;

  const _SummaryRow(
      {required this.label, required this.amount, this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? AppDimensions.getBodySize(context) : AppDimensions.getSmallSize(context),
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? AppColors.primaryText : AppColors.grey600,
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isTotal ? AppDimensions.getBodySize(context) : AppDimensions.getSmallSize(context),
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
      ],
    );
  }
}
