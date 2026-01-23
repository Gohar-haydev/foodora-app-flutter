import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:foodora/features/cart/presentation/viewmodels/cart_viewmodel.dart';
import 'package:foodora/features/cart/presentation/pages/order_confirmation_screen.dart';
import 'package:foodora/features/cart/presentation/pages/change_address_screen.dart';
import 'package:foodora/features/order/presentation/viewmodels/order_viewmodel.dart';
import 'package:foodora/features/order/data/models/order_request_model.dart';
import 'package:foodora/features/order/data/models/order_item_request_model.dart';
import 'package:foodora/features/order/data/models/order_addon_request_model.dart';
import 'package:foodora/core/utils/token_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodora/core/extensions/context_extensions.dart';


class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _addressLabel = 'Home';
  String _addressText = '123 Main Street, New York, USA';
  String _paymentMethod = AppStrings.cashOnDelivery;
  final TextEditingController _notesController = TextEditingController();
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
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.all(24),
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
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  context.tr('select_payment_method'),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),

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
                const SizedBox(height: 12),

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
                const SizedBox(height: 12),

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
                const SizedBox(height: 20),
              ],
            ),
          ),
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryAccent.withOpacity(0.1) : Colors
              .grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryAccent : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryAccent : Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey[600],
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? AppColors.primaryAccent : Colors.black87,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primaryAccent,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(context.tr('checkout')),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primaryText,
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer<CartViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.remove_shopping_cart, size: 64,
                      color: AppColors.mutedText),
                  const SizedBox(height: 16),
                  Text(context.tr('your_cart_is_empty'), style: const TextStyle(
                      color: AppColors.mutedText, fontSize: 18)),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(25.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                // Delivery Address Section (Static for now)
                _SectionHeader(title: context.tr('delivery_address')),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      color: AppColors.primaryAccent),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _addressLabel,
                          style: const TextStyle(fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _addressText,
                          style: const TextStyle(color: Colors.grey),
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
            const SizedBox(height: 24),

            // Payment Method Section (Static for now)
            _SectionHeader(title: context.tr('payment_method')),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
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
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _paymentMethod,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: _showPaymentMethodBottomSheet,
                    child: Text(context.tr('change')),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Order Notes Section
            _SectionHeader(title: context.tr('order_notes')),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _notesController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: context.tr('order_notes_hint'),
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: AppColors.primaryAccent, width: 2),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 12, right: 8, top: 12),
                    child: Icon(
                        Icons.note_outlined, color: AppColors.primaryAccent),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Order Summary
            _SectionHeader(title: context.tr('order_summary')),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // List Items roughly (or just total count?)
                  // Let's show list of items briefly
                  ...viewModel.cartItems.map((item) =>
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${item.quantity}x ${item.menuItem.name}',
                                style: const TextStyle(fontSize: 14)),
                            Text('\$${item.totalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      )).toList(),
                  const Divider(height: 24),
                  _SummaryRow(label: context.tr('subtotal'),
                      amount: viewModel.totalAmount),
                  const SizedBox(height: 8),
                  _SummaryRow(label: context.tr('delivery_fee'),
                      amount: viewModel.deliveryFee),
                  const SizedBox(height: 8),
                  _SummaryRow(label: context.tr('tax'), amount: viewModel.tax),
                  const Divider(height: 24),
                  _SummaryRow(label: context.tr('total'),
                      amount: viewModel.grandTotal,
                      isTotal: true),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Place Order Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: Consumer<OrderViewModel>(
                builder: (context, orderViewModel, _) {
                  return ElevatedButton(
                    onPressed: orderViewModel.isLoading ? null : () async {
                      // Build order request from cart
                      final orderRequest = OrderRequestModel(
                        deliveryType: "delivery",
                        paymentMethod: _paymentMethod ==
                            AppStrings.cashOnDelivery ? "cash" : "card",
                        deliveryAddress: _addressText,
                        deliveryLat: _latitude,
                        deliveryLng: _longitude,
                        customerName: await TokenStorage.getUserName() ??
                            "Guest",
                        customerPhone: "+1234567890",
                        // TODO: Get from user profile
                        notes: _notesController.text.isEmpty
                            ? null
                            : _notesController.text,
                        items: viewModel.cartItems.map((cartItem) {
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

                      // Call API
                      final success = await orderViewModel.createOrder(
                          orderRequest);

                      if (success && mounted) {
                        // Clear cart
                        viewModel.clearCart();

                        // Navigate to confirmation
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) =>
                                OrderConfirmationScreen(
                                  order: orderViewModel.lastCreatedOrder!,
                                ),
                          ),
                        );
                      } else if (mounted) {
                        // Show error
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(orderViewModel.errorMessage ??
                                'Failed to place order'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 5,
                    ),
                    child: orderViewModel.isLoading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : Text(
                      context.tr('place_order'),
                      style: TextStyle(
                        fontSize: 16,
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
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
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
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.grey[600],
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
