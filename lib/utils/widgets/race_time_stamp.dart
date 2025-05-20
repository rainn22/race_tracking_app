import 'package:flutter/material.dart';

enum TimeStampSize { large, small }

class RaceTimeStamp extends StatelessWidget {
  final DateTime? start;
  final DateTime? end;
  final TimeStampSize size;
  final Color? color;

  const RaceTimeStamp({
    super.key,
    required this.start,
    required this.end,
    this.size = TimeStampSize.large,
    this.color,
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
    final style = size == TimeStampSize.large
        ? const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          )
        : const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          );

    return Center(
      child: Text(
        _formatDuration(start, end),
        style: style.copyWith(color: color),
      ),
    );
  }
}
