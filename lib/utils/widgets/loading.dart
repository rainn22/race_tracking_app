import 'package:flutter/material.dart';

class LoadingUI extends StatelessWidget {
  final bool isLoading;

  const LoadingUI({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return const SizedBox.shrink();

    return Container(
      color: Colors.black.withOpacity(0.5),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
