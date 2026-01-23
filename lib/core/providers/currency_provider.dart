import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyProvider extends ChangeNotifier {
  String _currencyCode = 'SEK'; // Default: Krones
  double _usdRate = 0.096; // Fallback rate (will be updated)
  double _eurRate = 0.088; // Fallback rate (will be updated)

  String get currencyCode => _currencyCode;

  CurrencyProvider() {
    _loadCurrency();
    _fetchRates(); // Fetch fresh rates on init
  }

  Future<void> _loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    _currencyCode = prefs.getString('currency_code') ?? 'SEK';
    
    // Load cached rates if available
    if (prefs.containsKey('rate_USD')) {
      _usdRate = prefs.getDouble('rate_USD') ?? _usdRate;
    }
    if (prefs.containsKey('rate_EUR')) {
      _eurRate = prefs.getDouble('rate_EUR') ?? _eurRate;
    }
    notifyListeners();
  }

  Future<void> _fetchRates() async {
    try {
      final response = await http.get(Uri.parse('https://api.frankfurter.app/latest?from=SEK&to=USD,EUR'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rates = data['rates'];
        if (rates != null) {
          _usdRate = (rates['USD'] as num).toDouble();
          _eurRate = (rates['EUR'] as num).toDouble();
          
          // Cache rates
          final prefs = await SharedPreferences.getInstance();
          await prefs.setDouble('rate_USD', _usdRate);
          await prefs.setDouble('rate_EUR', _eurRate);
          
          notifyListeners();
        }
      } else {
        debugPrint('Failed to fetch currency rates: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching currency rates: $e');
    }
  }

  Future<void> setCurrency(String code) async {
    if (_currencyCode == code) return;
    _currencyCode = code;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency_code', code);
  }

  String formatPrice(double priceInSEK) {
    switch (_currencyCode) {
      case 'USD':
        final converted = priceInSEK * _usdRate;
        return '\$${converted.toStringAsFixed(2)}';
      case 'EUR':
        final converted = priceInSEK * _eurRate;
        return '€${converted.toStringAsFixed(2)}';
      case 'SEK':
      default:
        return '${priceInSEK.toStringAsFixed(0)} kr';
    }
  }
}
