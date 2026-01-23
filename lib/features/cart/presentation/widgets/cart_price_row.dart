import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodora/core/providers/currency_provider.dart';

class CartPriceRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isTotal;

  const CartPriceRow({
    Key? key,
    required this.label,
    required this.amount,
    this.isTotal = false,
  }) : super(key: key);

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
        Consumer<CurrencyProvider>(
          builder: (context, currencyProvider, child) {
            return Text(
              currencyProvider.formatPrice(amount),
              style: TextStyle(
                fontSize: isTotal ? 18 : 16,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
                color: Colors.black,
              ),
            );
          }
        ),
      ],
    );
  }
}
