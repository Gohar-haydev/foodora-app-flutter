import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';
import 'package:foodora/features/menu/presentation/pages/order_details_screen.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Cart',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            // Order Items Container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _OrderItem(
                    name: 'Kebabpizza',
                    code: '01',
                    price: 15.00,
                  ),
                  const SizedBox(height: 12),
                  _OrderItem(
                    name: 'Kebabpizza',
                    code: '01',
                    price: 15.00,
                  ),
                  const SizedBox(height: 12),
                  _OrderItem(
                    name: 'Kebabpizza',
                    code: '01',
                    price: 15.00,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Price Summary
            _PriceRow(label: 'Subtotal', amount: 15.00),
            const SizedBox(height: 16),
            _PriceRow(label: 'Delivery Fee', amount: 2.00),
            const SizedBox(height: 16),
            _PriceRow(label: 'Tax', amount: 1.50),
            const SizedBox(height: 16),
            _PriceRow(
              label: 'Total',
              amount: 18.50,
              isTotal: true,
            ),

            const Spacer(),

            // Place Order Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const OrderDetailsScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.backgroundLight,
                  foregroundColor: AppColors.primaryText,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'PLACE ORDER',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _OrderItem extends StatelessWidget {
  final String name;
  final String code;
  final double price;

  const _OrderItem({
    required this.name,
    required this.code,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Item Image
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 60,
            height: 60,
            color: Colors.grey[300],
            child: Image.asset(
              'assets/images/kebabpizza.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.fastfood,
                    size: 30,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Item Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                code,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),

        // Price
        Text(
          '\$${price.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isTotal;

  const _PriceRow({
    required this.label,
    required this.amount,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
