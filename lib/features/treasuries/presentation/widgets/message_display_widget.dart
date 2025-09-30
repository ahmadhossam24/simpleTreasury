import 'package:flutter/material.dart';

class MessageDisplayWidget extends StatelessWidget {
  final String message;
  final String? iconAsset; // Optional icon asset path
  final bool isError; // For error states
  final bool isSuccess; // For success states
  final bool isWarning; // For warning states
  final VoidCallback? onAction; // Optional action callback
  final String? actionText; // Optional action button text

  const MessageDisplayWidget({
    super.key,
    required this.message,
    this.iconAsset,
    this.isError = false,
    this.isSuccess = false,
    this.isWarning = false,
    this.onAction,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    // Determine icon and color based on message type
    final (IconData icon, Color color) = _getIconAndColor();

    return Container(
      color: const Color(0xFFF5F5F5), // Off-White background
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0), // Rounded corners
            elevation: 2.0, // Subtle shadow
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon with colored background
                  Container(
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 40.0, color: color),
                  ),

                  const SizedBox(height: 24.0),

                  // Message Text - Body style
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF333333), // Charcoal
                    ),
                    textAlign: TextAlign.center,
                  ),

                  // Optional Action Button
                  if (onAction != null && actionText != null) ...[
                    const SizedBox(height: 20.0),
                    SizedBox(
                      width: double.infinity,
                      child: Material(
                        color: const Color(0xFF1A2B4C), // Navy Blue
                        borderRadius: BorderRadius.circular(
                          8.0,
                        ), // Rounded corners
                        child: InkWell(
                          onTap: onAction,
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 24.0,
                            ),
                            child: Text(
                              actionText!,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600, // SemiBold
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  (IconData, Color) _getIconAndColor() {
    if (isError) {
      return (Icons.error_outline, const Color(0xFFDC143C)); // Crimson Red
    } else if (isSuccess) {
      return (
        Icons.check_circle_outline,
        const Color(0xFF2E8B57),
      ); // Emerald Green
    } else if (isWarning) {
      return (Icons.warning_amber_outlined, const Color(0xFFFFD700)); // Gold
    } else {
      // Default informational state
      return (Icons.info_outline, const Color(0xFF008080)); // Teal
    }
  }
}

// Example usage scenarios:
class MessageDisplayExamples extends StatelessWidget {
  const MessageDisplayExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2B4C), // Navy Blue
        title: const Text(
          'Messages',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        children: [
          // Empty treasuries message
          MessageDisplayWidget(
            message:
                'You don\'t have any treasuries yet. Create your first treasury to get started!',
            isSuccess: false,
            actionText: 'Create Treasury',
            onAction: () {
              // Handle create treasury action
            },
          ),

          const SizedBox(height: 16.0),

          // Error message
          MessageDisplayWidget(
            message:
                'Failed to load treasuries. Please check your internet connection and try again.',
            isError: true,
            actionText: 'Retry',
            onAction: () {
              // Handle retry action
            },
          ),

          const SizedBox(height: 16.0),

          // Success message
          MessageDisplayWidget(
            message:
                'Treasury created successfully! You can now start adding transactions.',
            isSuccess: true,
          ),

          const SizedBox(height: 16.0),

          // Warning message
          MessageDisplayWidget(
            message:
                'Your treasury balance is getting low. Consider adding more funds soon.',
            isWarning: true,
          ),

          const SizedBox(height: 16.0),

          // Informational message (default)
          MessageDisplayWidget(
            message: 'Loading your treasuries. Please wait a moment...',
          ),
        ],
      ),
    );
  }
}
