import 'package:flutter/material.dart';
import 'package:race_tracking_app/utils/constants.dart';

class SegmentToggle extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final Function(int) onTabSelected;

  const SegmentToggle({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onTabSelected,
  }) : assert(labels.length == 2, 'SegmentToggle only supports 2 segments');

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          final isSelected = selectedIndex == index;
          final isFirst = index == 0;
          final isLast = index == labels.length - 1;

          return Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(index),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.secondary,
                  borderRadius: BorderRadius.horizontal(
                    left: isFirst ? const Radius.circular(12) : Radius.zero,
                    right: isLast ? const Radius.circular(12) : Radius.zero,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  labels[index],
                  style: AppTextStyles.textLg
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
