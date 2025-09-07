import 'package:flutter/material.dart';
import '../atoms/primary_button.dart';
import '../atoms/custom_text.dart';
import '../atoms/spacing.dart';

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final bool hasPrevious;
  final bool hasNext;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.hasPrevious,
    required this.hasNext,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PrimaryButton(
            label: 'Anterior',
            icon: Icons.arrow_back,
            onPressed: hasPrevious ? onPrev : null,
          ),
          const Spacing(width: 16),
          CustomText('Página ${currentPage + 1}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const Spacing(width: 16),
          PrimaryButton(
            label: 'Próxima',
            icon: Icons.arrow_forward,
            onPressed: hasNext ? onNext : null,
          ),
        ],
      ),
    );
  }
}
