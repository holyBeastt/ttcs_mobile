import 'package:flutter/material.dart';

class AppAsyncView extends StatelessWidget {
  const AppAsyncView({
    super.key,
    required this.isLoading,
    required this.error,
    required this.onRetry,
    required this.child,
    this.empty = false,
    this.emptyMessage = 'No data available.',
  });

  final bool isLoading;
  final String? error;
  final VoidCallback onRetry;
  final Widget child;
  final bool empty;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                error!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (empty) {
      return Center(child: Text(emptyMessage));
    }

    return child;
  }
}
