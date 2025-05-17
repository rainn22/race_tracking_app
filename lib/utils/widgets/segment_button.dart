import 'package:flutter/material.dart';
import 'package:race_tracking_app/models/segment.dart';

typedef OnSegmentChanged = void Function(Segment segment);

class SegmentButton extends StatelessWidget {
  final Segment selectedSegment;
  final OnSegmentChanged onSegmentChanged;

  const SegmentButton({
    super.key,
    required this.selectedSegment,
    required this.onSegmentChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      isSelected: [
        selectedSegment == Segment.swimming,
        selectedSegment == Segment.cycling,
        selectedSegment == Segment.running,
      ],
      onPressed: (index) {
        onSegmentChanged(Segment.values[index]);
      },
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Swim'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Cycle'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Run'),
        ),
      ],
    );
  }
}
