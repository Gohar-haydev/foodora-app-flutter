import 'package:flutter/material.dart';
import 'package:foodora/core/constants/app_constants.dart';

/// A beautiful error dialog with a white container and red accent
/// Shows error messages in a more prominent and user-friendly way than snackbars
class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  
  const ErrorDialog({
    super.key,
    required this.title,
    required this.message,
    this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Error Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 32,
                color: Colors.red.shade400,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // OK Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.backgroundLight,
                  foregroundColor: AppColors.primaryText,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  buttonText ?? 'OK',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show error dialog
  static void show(
    BuildContext context, {
    required String title,
    required String message,
    String? buttonText,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ErrorDialog(
        title: title,
        message: message,
        buttonText: buttonText,
      ),
    );
  }
}

/// Extension method for easier usage
extension ErrorDialogExtension on BuildContext {
  void showError({
    required String title,
    required String message,
    String? buttonText,
  }) {
    ErrorDialog.show(
      this,
      title: title,
      message: message,
      buttonText: buttonText,
    );
  }
}
