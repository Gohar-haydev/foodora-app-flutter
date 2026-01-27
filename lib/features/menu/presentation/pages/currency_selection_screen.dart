import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodora/core/providers/currency_provider.dart';
import 'package:foodora/core/extensions/context_extensions.dart';
import 'package:foodora/core/constants/app_constants.dart';

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
          style: TextStyle(
            color: Colors.black,
            fontSize: AppDimensions.getH3Size(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: AppDimensions.responsiveIconSize(context, mobile: 24, tablet: 28),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: AppDimensions.getMaxContentWidth(context),
          ),
          child: Padding(
            padding: EdgeInsets.all(
              AppDimensions.getResponsiveHorizontalPadding(context),
            ),
            child: Column(
              children: [
                _CurrencyOption(
                  currencyName: context.tr('krones'),
                  currencyCode: 'SEK',
                  symbol: 'kr',
                  isSelected: currencyProvider.currencyCode == 'SEK',
                  onTap: () => currencyProvider.setCurrency('SEK'),
                ),
                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
                _CurrencyOption(
                  currencyName: 'US Dollar',
                  currencyCode: 'USD',
                  symbol: '\$',
                  isSelected: currencyProvider.currencyCode == 'USD',
                  onTap: () => currencyProvider.setCurrency('USD'),
                ),
                SizedBox(height: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
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
        padding: EdgeInsets.all(
          AppDimensions.responsiveSpacing(context, mobile: 20, tablet: 24),
        ),
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
              width: AppDimensions.responsive(context, mobile: 50, tablet: 60),
              height: AppDimensions.responsive(context, mobile: 50, tablet: 60),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  symbol,
                  style: TextStyle(
                    fontSize: AppDimensions.getH2Size(context),
                    fontWeight: FontWeight.bold,
                    color: isSelected ? const Color(0xFF4CAF50) : Colors.black54,
                  ),
                ),
              ),
            ),
            SizedBox(width: AppDimensions.responsiveSpacing(context, mobile: 16, tablet: 20)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currencyName,
                    style: TextStyle(
                      fontSize: AppDimensions.getH3Size(context),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected ? const Color(0xFF4CAF50) : Colors.black87,
                    ),
                  ),
                  Text(
                    currencyCode,
                    style: TextStyle(
                      fontSize: AppDimensions.getSmallSize(context),
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: const Color(0xFF4CAF50),
                size: AppDimensions.responsiveIconSize(context, mobile: 28, tablet: 32),
              ),
          ],
        ),
      ),
    );
  }
}
