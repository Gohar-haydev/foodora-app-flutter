import 'package:flutter/material.dart';

/// A beautiful, reusable loading overlay with a white container and green indicator
/// Shows a semi-transparent overlay with a centered white card containing a loading spinner
class LoadingOverlay extends StatelessWidget {
  final String? message;
  final Color? indicatorColor;
  
  const LoadingOverlay({
    super.key,
    this.message,
    this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          margin: const EdgeInsets.symmetric(horizontal: 48),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    indicatorColor ?? const Color(0xFF4CAF50),
                  ),
                ),
              ),
              if (message != null) ...[
                const SizedBox(height: 24),
                Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Show loading overlay as a dialog
  static void show(
    BuildContext context, {
    String? message,
    Color? indicatorColor,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) => LoadingOverlay(
        message: message,
        indicatorColor: indicatorColor,
      ),
    );
  }

  /// Hide the loading overlay
  static void hide(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}

/// Extension method for easier usage
extension LoadingOverlayExtension on BuildContext {
  void showLoading({String? message, Color? indicatorColor}) {
    LoadingOverlay.show(
      this,
      message: message,
      indicatorColor: indicatorColor,
    );
  }

  void hideLoading() {
    LoadingOverlay.hide(this);
  }
}
