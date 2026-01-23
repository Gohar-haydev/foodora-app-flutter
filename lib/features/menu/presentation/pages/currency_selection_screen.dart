import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodora/core/providers/currency_provider.dart';
import 'package:foodora/core/extensions/context_extensions.dart';

class CurrencySelectionScreen extends StatelessWidget {
  const CurrencySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyProvider = Provider.of<CurrencyProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          context.tr('select_currency'),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _CurrencyOption(
              currencyName: context.tr('krones'),
              currencyCode: 'SEK',
              symbol: 'kr',
              isSelected: currencyProvider.currencyCode == 'SEK',
              onTap: () => currencyProvider.setCurrency('SEK'),
            ),
            const SizedBox(height: 16),
            _CurrencyOption(
              currencyName: 'US Dollar',
              currencyCode: 'USD',
              symbol: '\$',
              isSelected: currencyProvider.currencyCode == 'USD',
              onTap: () => currencyProvider.setCurrency('USD'),
            ),
            const SizedBox(height: 16),
            _CurrencyOption(
              currencyName: 'Euro',
              currencyCode: 'EUR',
              symbol: '€',
              isSelected: currencyProvider.currencyCode == 'EUR',
              onTap: () => currencyProvider.setCurrency('EUR'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrencyOption extends StatelessWidget {
  final String currencyName;
  final String currencyCode;
  final String symbol;
  final bool isSelected;
  final VoidCallback onTap;

  const _CurrencyOption({
    required this.currencyName,
    required this.currencyCode,
    required this.symbol,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F5E9) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF4CAF50) : Colors.grey[300]!,
            width: 2,
          ),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  symbol,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? const Color(0xFF4CAF50) : Colors.black54,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currencyName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected ? const Color(0xFF4CAF50) : Colors.black87,
                    ),
                  ),
                  Text(
                    currencyCode,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF4CAF50),
                size: 28,
              ),
          ],
        ),
      ),
    );
  }
}
