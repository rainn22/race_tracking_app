import 'package:flutter/material.dart';

class RaceTimeStamp extends StatelessWidget {
  final DateTime? start;
  final DateTime? end;

  const RaceTimeStamp({
    super.key,
    required this.start,
    required this.end,
  });

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  String _formatDuration(DateTime? start, DateTime? end) {
    if (start == null || end == null) return "00 : 00 : 00";
    final duration = end.difference(start);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    return "${_twoDigits(hours)} : ${_twoDigits(minutes)} : ${_twoDigits(seconds)}";
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        _formatDuration(start, end),
        style: const TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          letterSpacing: 4,
        ),
      ),
    );
  }
}
