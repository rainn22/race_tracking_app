// segment_button.dart
import 'package:flutter/material.dart';
import 'package:race_tracking_app/models/segment.dart';
import 'package:race_tracking_app/utils/constants.dart';

class SegmentButtons extends StatefulWidget {
  final Segment currentStage;
  final Function(int) onSegmentSelected;

  const SegmentButtons({
    super.key,
    required this.currentStage,
    required this.onSegmentSelected,
  });

  @override
  State<SegmentButtons> createState() => _SegmentButtonsState();
}

class _SegmentButtonsState extends State<SegmentButtons> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentStage.index;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ToggleButtons(
          isSelected: [
            _selectedIndex == 0,
            _selectedIndex == 1, 
            _selectedIndex == 2,
          ],
          onPressed: (int index) {
            setState(() {
              _selectedIndex = index;
            });
            widget.onSegmentSelected(index);
          },
          color: Colors.black54, 
          selectedColor: Colors.black, 
          fillColor: AppColors.primary, 
          borderRadius: BorderRadius.circular(30.0),
          borderColor: Colors.grey,
          selectedBorderColor: Colors.amber.shade800, 
          children: const [
            Padding(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), child: Text("Swim")),
            Padding(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), child: Text("Cycle")),
            Padding(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), child: Text("Run")),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          '${Segment.values[_selectedIndex].label} Stage',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}