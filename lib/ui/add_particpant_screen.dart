import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app/providers/participant_provider.dart';
import 'package:race_tracking_app/utils/constants.dart';
import 'package:race_tracking_app/utils/widgets/button.dart';
import 'package:race_tracking_app/utils/widgets/input_field.dart';

class BulkAddParticipantsScreen extends StatefulWidget {
  const BulkAddParticipantsScreen({super.key});

  @override
  State<BulkAddParticipantsScreen> createState() =>
      _BulkAddParticipantsScreenState();
}

class _BulkAddParticipantsScreenState extends State<BulkAddParticipantsScreen> {
  final List<ParticipantEntry> _entries = List.generate(
    3,
    (_) => ParticipantEntry(
      bibController: TextEditingController(),
      nameController: TextEditingController(),
    ),
  );

  @override
  void dispose() {
    for (var entry in _entries) {
      entry.bibController.dispose();
      entry.nameController.dispose();
    }
    super.dispose();
  }

  void _addRow() {
    setState(() {
      _entries.add(
        ParticipantEntry(
          bibController: TextEditingController(),
          nameController: TextEditingController(),
        ),
      );
    });
  }

  void _submitEntries() {
    final provider = Provider.of<ParticipantProvider>(context, listen: false);

    final validEntries = _entries.where((entry) {
      return entry.bibController.text.trim().isNotEmpty &&
          entry.nameController.text.trim().isNotEmpty;
    }).toList();

    for (var entry in validEntries) {
      final bib = int.tryParse(entry.bibController.text) ?? 0;
      final name = entry.nameController.text.trim();
      provider.addParticipant(bib, name);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Participants')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.padding),
        child: Column(
          children: [
            const Row(
              children: [
                Expanded(
                  child: Text('#BIB', style: AppTextStyles.textLg),
                ),
                SizedBox(width: AppSpacing.gap),
                Expanded(
                  child: Text('Name', style: AppTextStyles.textLg),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.gap),
            Expanded(
              child: ListView.builder(
                itemCount: _entries.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.gap),
                    child: Row(
                      children: [
                        Expanded(
                          child: InputField(
                            controller: _entries[index].bibController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.gap),
                        Expanded(
                          child: InputField(
                            controller: _entries[index].nameController,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.gap),
              child: AppButton(
                label: 'Add Row',
                color: AppColors.secondary,
                textColor: AppColors.text,
                icon: Icons.add,
                onTap: _addRow,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Cancel',
                    color: AppColors.secondary,
                    textColor: AppColors.text,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: AppSpacing.gap),
                Expanded(
                  child: AppButton(
                    label: 'Submit',
                    color: AppColors.primary,
                    textColor: AppColors.text,
                    onTap: _submitEntries,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ParticipantEntry {
  final TextEditingController bibController;
  final TextEditingController nameController;

  ParticipantEntry({
    required this.bibController,
    required this.nameController,
  });
}
