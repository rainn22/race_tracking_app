import 'package:flutter/material.dart';

class ParticipantEntry {
  final TextEditingController bibController;
  final TextEditingController nameController;

  String? bibError;
  String? nameError;

  ParticipantEntry({
    required this.bibController,
    required this.nameController,
    this.bibError,
    this.nameError,
  });
}