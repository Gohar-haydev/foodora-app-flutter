import 'package:flutter/material.dart';

/// Reusable header widget for auth screens with back button and centered title
class AuthHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;

  const AuthHeader({
    super.key,
    required this.title,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        Expanded(
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(width: 40), // Balance the back button
      ],
    );
  }
}
